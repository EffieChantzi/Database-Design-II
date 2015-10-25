/*-*-sql-*-*******************************************************************
  Database Design II - 1DL400
  Assignment 1 - Database Integrity: Assertions, Triggers, and Stored Procedures
  Group 9: Efthymia Chantzi || Huijie Shen || Eleftherios Anagnostopoulos
  February 4, 2015

  Procedure: finalizeSale
  Inputs: transaction_number
  Description: Procedure that finalizes a sale given by its transaction number. 
	       The procedure charges customer’s account the total cost of the sale, 
	       reduces qoh of the sold items (carries table) and removes the corresponding 
	       entries from tables transact, debit and sale. Uses a view in order to calculate 
               the total cost of the sale (as suggested) and finally, in case of NULL transaction
	       account, the sale is aborted and an exception is thrown.

  MySQL Version: 5.6.23  
*****************************************************************************/

DROP PROCEDURE IF EXISTS finalizeSale;

DELIMITER $$

CREATE PROCEDURE finalizeSale(IN transaction_number INTEGER)
BEGIN
	DECLARE account_number, total_amount, current_item, current_quantity, current_dept INTEGER DEFAULT 0;
	DECLARE done INT DEFAULT FALSE;
	
	DECLARE c CURSOR FOR 
		(SELECT item, quantity, dept FROM sale WHERE debit = transaction_number);

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	DROP VIEW IF EXISTS v;
	CREATE VIEW v AS SELECT debit, item, quantity, dept, (SELECT price FROM item WHERE number = item) AS price FROM sale;

	SET total_amount = (SELECT SUM(quantity * price) FROM v WHERE debit = transaction_number);
	SET account_number = (SELECT account FROM transact WHERE number = transaction_number);
	
	IF account_number IS NULL THEN
		SIGNAL SQLSTATE 'ERROR' SET MESSAGE_TEXT = 
			'Procedure: finalizeSale - Transaction account is NULL.';
	ELSE
		UPDATE account SET balance = balance - total_amount WHERE number = account_number;
	END IF;

	OPEN c;
	c_loop: LOOP
		FETCH c INTO current_item, current_quantity, current_dept;
	 	IF done THEN
	 		LEAVE c_loop;
	 	END IF;
		UPDATE carries set qoh = qoh - current_quantity where item = current_item and dept = current_dept;
	END LOOP;
	CLOSE c;
	
	DELETE FROM sale WHERE debit = transaction_number;
	DELETE FROM debit WHERE number = transaction_number;	
	DELETE FROM transact WHERE number = transaction_number;
END$$
DELIMITER ;

