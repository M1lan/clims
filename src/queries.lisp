(in-package :clims)

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

;;TODO: Handle case where quantity would go negative
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
(defun create-process (batch-info)
  "creates an entry in the manufacturing table"
  (let ((batch (incf (caar (query 
			    (:limit
			     (:order-by
			      (:select 'batch_id :from 'manufacturing)
			      (:desc 'batch_id))
			     1)))))
	(name (second batch-info)))
    (query (:insert-into 'manufacturing :set 'batch_id batch 'name name))
    batch))

;;;outputs = mat-info (finished)
;;;inputs = ((material amount quantities))
;;;quantities = (amounts-used amounts-returned)
;;;batch-info = (batch name)

(defun create-manufacturing (outputs inputs batch-info)
  "creates a manufacturing batch and all of the associated inputs and outputs, edits raw materials"
  (handler-case
      (progn
	(dolist (input inputs)
	  (unless (= (second input) (apply '+ (first (third input))))
	    (error () nil)))	
	(with-transaction (derp) 
	  (print derp)
	  (let ((batch-info (cons (create-process batch-info) (cdr batch-info))))
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
  

;;TODO: handle creating an order, and a sale, with updated and createions to tables where necessary
