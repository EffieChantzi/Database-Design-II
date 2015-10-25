/*-*-sql-*-*******************************************************************
  Database Design II - 1DL400
  Assignment 1 - Database Integrity: Assertions, Triggers, and Stored Procedures
  Group 9: Efthymia Chantzi || Huijie Shen || Eleftherios Anagnostopoulos
  February 4, 2015

  Procedure: createAccount
  Inputs: customer_number, credit
  Description: Procedure for creating a new customer account. 
	       If credit is less than zero or selected customer does not exist, 
	       then new account is aborted and an exception is thrown.

  MySQL Version: 5.6.23  
*****************************************************************************/

DROP PROCEDURE IF EXISTS createAccount;

DELIMITER $$
CREATE PROCEDURE createAccount(IN customer_number INTEGER, IN credit_limit INTEGER)
BEGIN
	IF (SELECT number FROM customer WHERE number = customer_number) IS NULL THEN 
		SIGNAL SQLSTATE 'ERROR' SET MESSAGE_TEXT = 'Procedure: createAccount - There is no customer with this number.';
	
	ELSEIF credit_limit < 0 THEN
		SIGNAL SQLSTATE 'ERROR' SET MESSAGE_TEXT = 'Procedure: createAccount - Credit must be greater or equal to zero.';

	ELSE
		INSERT INTO account(customer, balance, credit) VALUES (customer_number, 0, credit_limit);
	END IF;
END$$
DELIMITER ;

