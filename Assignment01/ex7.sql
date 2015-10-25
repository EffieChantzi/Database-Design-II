/*-*-sql-*-*******************************************************************
  Database Design II - 1DL400
  Assignment 1 - Database Integrity: Assertions, Triggers, and Stored Procedures
  Group 9: Efthymia Chantzi || Huijie Shen || Eleftherios Anagnostopoulos
  February 4, 2015

  Trigger: overdraftCheck
  Created Table: overdraft
  Description: Procedure for creating an update trigger that checks if a customer account exceeds
	       its given credit limit. If the credit limit is exceeded by less than 10% the trigger 
	       stores the date, account number and the overdraft amount in a new table (overdraft). 
	       If the credit limit is exceeded by more than 10%, an exception is thrown, 
	       preventing any update to take place.

  MySQL Version: 5.6.23  
*****************************************************************************/

DROP TABLE IF EXISTS overdraft;

CREATE TABLE overdraft(
	number INTEGER PRIMARY KEY AUTO_INCREMENT, 
	date DATE,
	account INTEGER,
	amount INTEGER
); 

ALTER TABLE overdraft 
	ADD CONSTRAINT fk_overdraft_account FOREIGN KEY (account) REFERENCES account(number);

DROP TRIGGER IF EXISTS overdraftCheck;
DELIMITER $$

CREATE 
TRIGGER overdraftCheck BEFORE UPDATE 
ON account 
FOR EACH ROW 
BEGIN
	IF (-1) * NEW.balance > NEW.credit AND (-1) * NEW.balance <= 1.1 * NEW.credit THEN
		INSERT INTO overdraft(date, account, amount) VALUES(CURDATE(), NEW.number, (-1) * NEW.balance - NEW.credit);
	
	ELSEIF (-1) * NEW.balance > 1.1 * NEW.credit THEN
		SIGNAL SQLSTATE 'ERROR' SET MESSAGE_TEXT = 'overdraftCheck - Credit limit exceeded. ';
	END IF;
END$$
DELIMITER ;

