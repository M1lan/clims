\copy suppliers from 'flat_files/ims0.3/suppliers.txt' (DELIMITER '|');
\copy orders from 'flat_files/ims0.3/orders.txt' (DELIMITER '|');
\copy raw_materials from 'flat_files/ims0.3/raw.txt' (DELIMITER '|');
\copy manufacturing from 'flat_files/ims0.3/manufacturing.txt' (DELIMITER '|');
\copy elements from 'flat_files/ims0.3/elements.txt' (DELIMITER '|');
\copy finished_materials from 'flat_files/ims0.3/finished.txt' (DELIMITER '|');
\copy buyers from 'flat_files/ims0.3/buyers.txt' (DELIMITER '|');
\copy sales from 'flat_files/ims0.3/sales.txt' (DELIMITER '|');
\copy sold from 'flat_files/ims0.3/sold.txt' (DELIMITER '|');
