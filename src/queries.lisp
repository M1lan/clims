(in-package :clims)

;;;TODO: Handle returns (cancelled sales)
;;;TODO: Handle returned orders
;;;TODO: allow for personal editing of tables (initial insert for example)

;;toy method for adding to suppliers
(defprepared add-to-suppliers 
    (:insert-into 'suppliers :set 'supplier_id '$1 'name '$2))

;;(defun selection (tables, selectors)
;;  (let (joiners '())

(defun get-raw-materials-test ()
  (query (:select '* :from 'raw_materials) :alists))
		  
(defun edit-raw-material-test (element)
  (query (:update 'raw_materials 
		:set 'name (cdr (assoc ':NAME element))
		     'quantity_bought (cdr (assoc ':QUANTITY-BOUGHT element))
		     'cost (cdr (assoc ':COST element))
		     'quantity_fresh (cdr (assoc ':QUANTITY-FRESH element))
		     'quantity_used_1 (cdr (assoc ':QUANTITY-USED-1 element))
		     'quantity_used_2 (cdr (assoc ':QUANTITY-USED-2 element))
		     'quantity_used_3 (cdr (assoc ':QUANTITY-USED-3 element))
		     'quantity_trashed (cdr (assoc ':QUANTITY-TRASHED element))
		     'order_id (cdr (assoc ':ORDER-ID element))
		:where (:and (:= 'name (cdr (assoc ':NAME element)))
			     (:= 'order_id (cdr (assoc ':ORDER-ID element)))))))

(defun create-raw-material-test (element)
    (query (:insert-into 'raw_materials 
			 :set 'name (cdr (assoc ':NAME element))
			 'quantity_bought (cdr (assoc ':QUANTITY-BOUGHT element))
			 'cost (cdr (assoc ':COST element))
			 'quantity_fresh (cdr (assoc ':QUANTITY-FRESH element))
			 'quantity_used_1 (cdr (assoc ':QUANTITY-USED-1 element))
			 'quantity_used_2 (cdr (assoc ':QUANTITY-USED-2 element))
			 'quantity_used_3 (cdr (assoc ':QUANTITY-USED-3 element))
			 'quantity_trashed (cdr (assoc ':QUANTITY-TRASHED element))
			 'order_id (cdr (assoc ':ORDER-ID element)))))

(defun delete-raw-material-test (element)
  (query (:delete-from 'raw_materials
		       :where (:and (:= 'name (cdr (assoc ':NAME element)))
				    (:= 'order_id (cdr (assoc ':ORDER-ID element)))))))

(defun manufacturing-view-data ()
  "Returns a list, first element containing the raw materials the second containing the finished materials.  For use in creating a new manufacturing batch"
  (cons (query (:select '* :from 'raw_materials) :alists)
	(cons (query (:select '* :from 'finished_materials) :alists)
	      '())))

;;;manufacturing
(defun update-raw-material-quantity (name id quantities)
  "updates a raw_material using the change list provided"
  ;;validate a net zero change in 
  (unless (= 0 (apply '+ quantities))
    (error 
     (print "there is not a net 0 change in the quantities")
     (print quantities)))
  (let*	((quantity_old (car (query (:select 'quantity_fresh
					    'quantity_used_1
					    'quantity_used_2
					    'quantity_used_3
					    'quantity_trashed
					    :from 'raw_materials
					    :where (:and (:= 'name name)
							 (:= 'order_id id))))))
	 (quantity (loop
		      for x in quantity_old
		      for y in quantities
		      collect
			(+ x y))))
    (query (:update 'raw_materials
		    :set 'quantity_fresh (first quantity)
		         'quantity_used_1 (second quantity)
			 'quantity_used_2 (third quantity)
			 'quantity_used_3 (fourth quantity)
			 'quantity_trashed (fifth quantity)
			 :where (:and  (:= 'name name)
				       (:= 'order_id id))))))

(defun create-elements (batch inputs)
  "created the two needed entries in the elements table"
  (loop 
     for input in inputs
     do 
       (query (:insert-into 'elements
			    :set 'batch_id batch
			         'order_id (cdr (assoc ':ORDER-ID input))
				 'name (cdr (assoc ':NAME input))
				 'in_out "in"
				 'quantity (cdr (assoc ':AMOUNT-USED input))))
       (query (:insert-into 'elements
			    :set 'batch_id batch
			         'order_id (cdr (assoc ':ORDER-ID input))
				 'name (cdr (assoc ':NAME input))
				 'in_out "out"
				 'quantity (cdr (assoc ':AMOUNT-USED input))))))

(defun create-finished-material (batch name quantity)
  "creates an entry in the finished materials table"
  (query (:insert-into 'finished_materials
		       :set 'name name
		            'batch_id batch
			    'quantity_made quantity
			    'quantity_in_stock quantity)))

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
    (query (:insert-into 'manufacturing
			 :set 'batch_id batch
			      'name name))
    batch))

;;;outputs = (((:NAME "name-str") (:QUANTITY-MADE output-amount))*)
;;;inputs = (((:NAME "name-str") (:ORDER-ID order-id) (:AMOUNT-USED total) (:QUANTITY-USED ((:QUANTITY-FRESH amount) (:QUANTITY-USED-1 amount) (:QUANTITY-USED-2 amount) (:QUANTITY-USED-3 amount) (:QUANTITY-TRASHED amount))) (:QUANTITY-RETURNED ((:QUANTITY-FRESH amount) (:QUANTITY-USED-1 amount) (:QUANTITY-USED-2 amount) (:QUANTITY-USED-3 amount) (:QUANTITY-TRASHED amount))))*)
;;;batch-name = batch-name or ((:BATCH-NAME "batch-name"))

(defun handle-manufacturing (outputs inputs batch-name)
  "creates a manufacturing batch and all of the associated inputs and outputs, edits raw materials"
  (handler-case
      (progn
	(dolist (input inputs)
	  ;;validate :amount-used = sum of :quantity-used
	  (unless (= (car (assoc ':AMOUNT-USED input))
		     (apply '+ (loop
				  for field in (cdr (assoc ':QUANTITY-USED input))
				  collect (cdr field))))
	    (error () nil)))
	(with-transaction (manufacturing) 	  
	  (let ((batch-id (create-manufacturing (cdr (assoc ':BATCH-NAME batch-name)))))
	    (dolist (output outputs)
	      (create-finished-material batch-id
					(cdr (assoc ':NAME output))
					(cdr (assoc ':QUANTITY-MADE output))))	    
	    (create-elements batch-id (cdr (assoc ':BATCH-NAME batch-name))))
	  (dolist (input inputs)
	    (let* ((used (loop
			    for field in (cdr (assoc ':QUANTITY-USED input))
			      collect (cdr field)))
		   (returned (loop
				for field in (cdr (assoc ':QUANTITY-RETURNED input))
				collect (cdr field)))
		   (delta (generate-delta used returned)))
	      (update-raw-material-quantity (cdr (assoc ':NAME input))
					    (cdr (assoc ':ORDER-ID input))
					    delta)))))
    (error (e)
      (print "something bad happened")
      (print e))))

(defun generate-delta (used returned)
  "takes the used and returned quantities for a material and generates a single delta quantity"
  (loop
     for a in used
     for b in returned
     collect
       (- b a)))

(defun order-view-data ()
    "Returns a list, first element containing the suppliers the second containing the raw materials.
For use in creating a new order"
  (cons (query (:select '* :from 'suppliers) :alists)
	(cons (query (:select '* :from 'raw_materials) :alists)
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

;;materials = (((:NAME . "name-str") (:QUANTITY . amount) (:COST . cost))*)
;;supplier = either supplier_id or ((:SUPPLIER-ID . id))
(defun handle-order (materials supplier)
  (handler-case
      (with-transaction(order)
	(let ((order (create-order (car (assoc ':SUPPLIER-ID supplier)))))
	  (dolist (material materials)
	    (create-raw-material (car (assoc ':NAME material))
				 (car (assoc ':QUANTITY material))
				 (car (assoc ':COST material))
				 order))))
    (error (e)
      (print "error processing the order")
      (print e))))

(defun sale-view-data ()
   "Returns a list, first element containing finished materials the second containing buyers.
For use in creating a new sale"
  (cons (query (:select '* :from 'finished_materials) :alists)
	(cons (query (:select '* :from 'buyers) :alists)
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
(defun create-sold (name batch-id quantity price sale)
  (query (:insert-into 'sold :set 'name name
		                  'batch_id batch-id
				  'sale_id sale
				  'quantity_sold quantity
				  'price price))
  (debit-finished-material name batch-id quantity))

(defun debit-finished-material (name batch-id quantity)
  (let ((stock (caar (query (:select 'quantity_in_stock
				     :from 'finished_materials
				     :where (:and (:= 'name name)
						  (:= 'batch_id batch-id)))))))
    (query (:update 'finished_materials
		    :set 'quantity_in_stock (- stock quantity)
		    :where (:and (:= 'name name)
				 (:= 'batch_id batch-id))))))

;;material-infos = (((:NAME . "name-str") (:BATCH-ID . batch-num) (:QUANTITY . num-to-sell) (:PRICE . price))*)
;;buyer = either buyer-id or ((:BUYER-ID . buyer-id))
(defun handle-sale (materials buyer)
  (handler-case 
      (with-transaction (sale)
	(let ((sale_id (create-sale (car (assoc ':BUYER-ID buyer)))))
	  (dolist (material materials)
	    (create-sold (car (assoc ':NAME material))
			 (car (assoc ':BATCH-ID material))
			 (car (assoc ':QUANTITY material))
			 (car (assoc ':PRICE material))
			 sale_id))))
    (error (e)
      (print "error processing the sale")
      (print e))))
