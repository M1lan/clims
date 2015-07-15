(in-package :clims)

;; give it a table or view and it will pull it, filling it in(?)

(defun defun-table-view (table-name)
  "Given a a table name this function will generate an HTML table of it."
  (let ((data (table-as-list table-name)))
    (format t "~a" (car data))
    (with-html-output-to-string (*standard-output*)
      (:table
       (:thead
        (:tr
         (loop for header in (car data)
            do (htm
                (:th (str header))))))
       (:tbody
        (loop for row in (cdr data)
           do (htm
               (:tr
                (loop for item in row
                   do (htm
                       (:td (str item))))))))))))

(defun table-as-list (table-name)
  "Takes a the name of a table and returns a list of column name strings cons'ed with the table data of NIL."
  (cond ((stringp table-name)
         (cons (table-column-names table-name)
               (select* (intern table-name))))
        ((symbolp table-name)
         (cons (table-column-names (string-downcase (symbol-name table-name)))
               (select* table-name)))
        (t nil)))

(defun table-column-names (table-name)
  "Returns a list of strings that are the column names for table-name"
  (query
   (:order-by
    (:select
     'column_name :from 'information_schema.columns
     :where (:= 'table_name table-name))
    'ordinal_position)
    :column))

(defun select* (table-name)
  (query
   (:select '* :from table-name)))
