/*-*-sql-*-*******************************************************************
  Database Design II - 1DL400
  Assignment 1 - Database Integrity: Assertions, Triggers, and Stored Procedures
  Group 9: Efthymia Chantzi || Huijie Shen || Eleftherios Anagnostopoulos
  February 4, 2015

  Procedure: createCustomer
  Inputs: name, street address, city
  Description: Procedure for creating and adding customers to the database. 
	       It must be mentioned that selected city must be stored at the database, 
	       since there is an added foreign key constraint for the attribute city 
	       of table customer related to the attribute name of table city.

  MySQL Version: 5.6.23  
*****************************************************************************/

DROP PROCEDURE IF EXISTS createCustomer;

DELIMITER $$
CREATE PROCEDURE createCustomer(IN new_name VARCHAR(20), IN new_address VARCHAR(20), IN new_city VARCHAR(15))
BEGIN
	INSERT INTO customer(name, address, city) VALUES (new_name, new_address, new_city);
END$$
DELIMITER ;
