(in-package :clims)

;;;TODO: Handle returns (cancelled sales)
;;;TODO: Handle returned orders
;;;TODO: allow for personal editing of tables (initial insert for example)

;;toy method for adding to suppliers
(defprepared add-to-suppliers 
    (:insert-into 'suppliers :set 'supplier_id '$1 'name '$2))

;;(defun selection (tables, selectors)
;;  (let (joiners '())

(defun manufacturing-view-data ()
  "Returns a list, first element containing the raw materials the second containing the finished materials.
For use in creating a new manufacturing batch"
  (cons (query (:select '* :from 'raw_materials))
	(cons (query (:select '* :from 'finished_materials))
	      '())))

;;;mat-info = (material quantity)
;;;material = (name id)

;;;manufacturing
(defun update-raw-material-quantity (mat-info)
  "updates a raw_material using the change list provided"
  (unless (= 0 (apply '+ (second mat-info)))
    (error 
     (print "there is not a net 0 change in the quantities")
     (print (second mat-info))))
  (let* ((material (first mat-info))
	 (delta (second mat-info))
	 (quantity_old (car (query (:select 'quantity_fresh 'quantity_used_1 'quantity_used_2 'quantity_used_3 'quantity_trashed :from 'raw_materials
					    :where (:and (:= 'name (first material))
							 (:= 'order_id (second material)))))))
	 (quantity (loop
		      for x in quantity_old
		      for y in delta
		      collect
			(+ x y))))
    (query (:update 'raw_materials
		    :set 'quantity_fresh (first quantity)
		    'quantity_used_1 (second quantity)
		    'quantity_used_2 (third quantity)
		    'quantity_used_3 (fourth quantity)
		    'quantity_trashed (fifth quantity)
		    :where (:and  (:= 'name (first material))
				  (:= 'order_id (second material)))))))

(defun create-elements (batch materials quantities)
  "created the two needed enries in the elements table"
  (loop 
     for material in materials
     for quantity in quantities
     do 
       (query (:insert-into 'elements
			    :set 'batch_id batch
			    'order_id (second material)
			    'name (first material)
			    'in_out "in"
			    'quantity quantity))
       (query (:insert-into 'elements
			    :set 'batch_id batch
			    'order_id (second material)
			    'name (first material)
			    'in_out "out"
			    'quantity quantity))))

(defun create-finished-material (batch mat-info)
  "creates an entry in the finished materials table"
  (let ((material (first mat-info))
	(quantity (second mat-info)))    
    (query (:insert-into 'finished_materials
			 :set 'name material
			 'batch_id batch
			 'quantity_made quantity
			 'quantity_in_stock quantity))))

;;;postmodern/s-sql dont play nice with serials, so query to get highest number so far is required.
;;;look into sequences for fixing manual serials problem
(defun create-manufacturing (name)
  "creates an entry in the manufacturing table"
  (let ((batch (incf (caar (query 
			    (:limit
			     (:order-by
			      (:select 'batch_id :from 'manufacturing)
			      (:desc 'batch_id))
			     1))))))
    (query (:insert-into 'manufacturing :set 'batch_id batch 'name name))
    batch))

;;;outputs = mat-info (finished)
;;;inputs = ((material amount quantities))
;;;quantities = (amounts-used amounts-returned)
;;;batch-info = (batch name)

(defun handle-manufacturing (outputs inputs batch-name)
  "creates a manufacturing batch and all of the associated inputs and outputs, edits raw materials"
  (handler-case
      (progn
	(dolist (input inputs)
	  (unless (= (second input) (apply '+ (first (third input))))
	    (error () nil)))	
	(with-transaction (manufacturing) 	  
	  (let ((batch-info (cons (create-manufacturing batch-name) (cons batch-name '()))))
	    (dolist (output outputs)
	      (create-finished-material (first batch-info) output))
	    (let ((element-materials (loop
					for input in inputs
					collect (first input)))
		  (element-quantities (loop
					 for input in inputs
					 collect (second input))))
	      (create-elements (first batch-info) element-materials element-quantities)
	      (let ((mat-infos (loop
				  for input in inputs
				  collect (cons (first input)
						(cons (generate-delta (third input))
						      '())))))
		(dolist (mat-info mat-infos)
		  (update-raw-material-quantity mat-info)))))))
    (error (e)
      (print "something bad happened")
      (print e))))

(defun generate-delta (quantities)
  "takes the input and returned quantities for a material and generates a single delta quantity"
  (loop
     for a in (first quantities)
     for b in (second quantities)
     collect
       (- b a)))

(defun order-view-data ()
    "Returns a list, first element containing the suppliers the second containing the raw materials.
For use in creating a new order"
  (cons (query (:select '* :from 'suppliers))
	(cons (query (:select '* :from 'raw_materials))
	      '())))

;;;order
(defun create-order (supplier)
  (let ((order (incf (caar (query 
			    (:limit
			     (:order-by
			      (:select 'order_id :from 'orders)
			      (:desc 'order_id))
			     1))))))
    (query (:insert-into 'orders :set 'order_id order 'supplier_id supplier))
    order))

(defun create-raw-material (name quantity cost order)
  (query (:insert-into 'raw_materials :set 'name name
		                           'quantity_bought quantity
					   'quantity_fresh quantity
					   'quantity_used_1 0
					   'quantity_used_2 0
					   'quantity_used_3 0
					   'quantity_trashed 0
					   'cost cost
					   'order_id order)))

;;materials = ((name, quantity, cost))
(defun handle-order (materials supplier)
  (handler-case
      (with-transaction(order)
	(let ((order (create-order supplier)))
	  (dolist (material materials)
	    (create-raw-material (first material) (second material) (third material) order))))
    (error (e)
      (print "error processing the order")
      (print e))))

(defun sale-view-data ()
   "Returns a list, first element containing finished materials the second containing buyers.
For use in creating a new sale"
  (cons (query (:select '* :from 'finished_materials))
	(cons (query (:select '* :from 'buyers))
	      '())))

;;;sale
(defun create-sale (buyer)
    (let ((sale (incf (caar (query 
			    (:limit
			     (:order-by
			      (:select 'sale_id :from 'sales)
			      (:desc 'sale_id))
			     1))))))
    (query (:insert-into 'sales :set 'sale_id sale 'buyer_id buyer))
    sale))

;;material = (name batch-id)
(defun create-sold (material quantity price sale)
  (query (:insert-into 'sold :set 'name (first material)
		                  'batch_id (second material)
				  'sale_id sale
				  'quantity_sold quantity
				  'price price))
  (debit-finished-material material quantity))

(defun debit-finished-material (material quantity)
  (let ((stock (caar (query (:select 'quantity_in_stock
				     :from 'finished_materials
				     :where (:and (:= 'name (first material))
						  (:= 'batch_id (second material))))))))
    (query (:update 'finished_materials
		    :set 'quantity_in_stock (- stock quantity)
		    :where (:and (:= 'name (first material))
				 (:= 'batch_id (second material)))))))

;;material = (name batch-id)
;;material-infos = ((material quantity price))
(defun handle-sale (material-infos buyer)
  (handler-case 
      (with-transaction (sale)
	(let ((sale_id (create-sale buyer)))
	  (dolist (material-info material-infos)
	    (create-sold (first material-info) (second material-info) (third material-info) sale_id))))
    (error (e)
      (print "error processing the sale")
      (print e))))
