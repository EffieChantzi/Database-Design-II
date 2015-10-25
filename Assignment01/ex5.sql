/*-*-sql-*-*******************************************************************
  Database Design II - 1DL400
  Assignment 1 - Database Integrity: Assertions, Triggers, and Stored Procedures
  Group 9: Efthymia Chantzi || Huijie Shen || Eleftherios Anagnostopoulos
  February 4, 2015

  Procedure: depositMoney
  Inputs: account_number, amount
  Description: Procedure for depositing money into a customers account. 
	       The procedure should takes an account number and a positive amount as arguments. 
               If amount is not positive or selected account does not exist, then the deposit 
	       is aborted and an exception is thrown.

  MySQL Version: 5.6.23  
*****************************************************************************/

DROP PROCEDURE IF EXISTS depositMoney;

DELIMITER $$
CREATE PROCEDURE depositMoney(IN account_number INTEGER, IN positive_amount INTEGER)
BEGIN
	IF positive_amount <= 0 THEN 
		SIGNAL SQLSTATE 'ERROR' SET MESSAGE_TEXT = 'Procedure: depositMoney - Input amount must be positive.'; 

	ELSEIF (SELECT number FROM account WHERE number = account_number) IS NULL THEN 
		SIGNAL SQLSTATE 'ERROR' SET MESSAGE_TEXT = 'Procedure: depositMoney - There is no account with this number.'; 

	ELSE
		UPDATE account SET balance = balance + positive_amount WHERE number = account_number; 		
	END IF;
END$$
DELIMITER ;

