USE mydb;

-- DROP stored procedures if exists before re-creating
DROP PROCEDURE IF EXISTS new_project;
DROP PROCEDURE IF EXISTS filter_products;
DROP PROCEDURE IF EXISTS add_temp_products;
DROP PROCEDURE IF EXISTS new_quote;
DROP PROCEDURE IF EXISTS calc_quote;
DROP PROCEDURE IF EXISTS mgr_reject;
DROP PROCEDURE IF EXISTS cust_decides;
DROP PROCEDURE IF EXISTS prt_equip_list;
DROP PROCEDURE IF EXISTS prt_features_list;
DROP PROCEDURE IF EXISTS prt_quote_detail;


/***********************************
* CASE 1: Insert New Customer Info - Return Project ID (doesn't allow duplicates, if already exist returns existing Project ID)
************************************/
DELIMITER //
CREATE PROCEDURE new_project(
	IN np_first_name VARCHAR(45),
    IN np_last_name VARCHAR(45),
    IN np_address VARCHAR(65),
    IN np_city VARCHAR(35),
    IN np_state CHAR(2),
    IN np_zip CHAR (5),
    IN np_email VARCHAR(80),
    IN np_phone VARCHAR(10), 
    IN np_business VARCHAR(60),
    OUT np_project_id INT -- Output to return to caller
)
BEGIN
	-- Declare variables
	DECLARE d_cust_id INT;
	DECLARE d_address_id INT;
    DECLARE existing_cust INT;
    DECLARE existing_address INT;
    DECLARE existing_proj INT;

	-- Starts transaction
	START TRANSACTION;
	
    -- CHECK if customer already exists in database
    SELECT MIN(cust_id) INTO existing_cust					-- 
    FROM customer c
    WHERE c.email = np_email;
	
    -- TEST LOGIC
    SELECT existing_cust;
    
    -- If customer EXISTS, use existing customer record
    IF existing_cust > 0 THEN
		SET d_cust_id = existing_cust;
	ELSE
		-- If not existing, ADD customer to the database
		INSERT INTO customer (first_name, last_name, email, phone, business)
		VALUES (np_first_name, np_last_name, np_email, np_phone, np_business);
		-- Update customer_id with new value
		SET d_cust_id = LAST_INSERT_ID();
    END IF;
    
    -- CHECK if address already exists in database
	SELECT MIN(address_id) INTO existing_address 
    FROM address a
    WHERE a.address = np_address AND a.city = np_city AND a.state = np_state AND a.zip = np_zip;
    
	-- If address EXISTS, use the existing address
    IF existing_address > 0 THEN
		SET d_address_id = existing_address;
    ELSE 
		-- If not existing, ADD address info to the database
		INSERT INTO address (address, city, state, zip)
		VALUES (np_address, np_city, np_state, np_zip);
		-- Update address_id with new value
		SET d_address_id = LAST_INSERT_ID();
	END IF;

	-- CHECK if "new project" already exists for this customer at this address
	SELECT MIN(proj_id) INTO existing_proj
    FROM project p
    WHERE p.cust_id = d_cust_id AND p.address_id = d_address_id AND proj_name = 'New Project';
    
    -- If existing, return existing record to update
    IF existing_proj > 0 THEN
		SET np_project_id = existing_proj;
	ELSE
		-- If not existing, ADD new project to the database
		INSERT INTO project (proj_name, status, lead_date, cust_id, address_id)
		VALUES ( 'New Project', 'New', CURDATE(), d_cust_id, d_address_id);
        -- Update project_id
        SET np_project_id = LAST_INSERT_ID();
	END IF;
	
	COMMIT;
END //
DELIMITER ;

/********************************************
* CASE 2: Return a filtered list of Products - by Brand and Category
*********************************************/
DELIMITER //
CREATE PROCEDURE filter_products ( 
	IN fp_category VARCHAR(12),
    IN fp_manufacture VARCHAR(45)
)
BEGIN
	-- Filter list of products
    SELECT equip_name AS product, equip_id 
    FROM equipment e
	JOIN manufacturer m 
		ON e.manu_id = m.manu_id
	WHERE cat_name = fp_category
		AND (manu_name = fp_manufacture OR m.manu_id IN (4));  -- include manufacture parts that work with any brand
END //
DELIMITER ;

/***********************************
* CASE 3: Store selected products in temporary table to before adding to quote
************************************/
DELIMITER //
CREATE PROCEDURE add_temp_products(
	IN at_equip_id INT,
    IN at_equip_qty INT
)
BEGIN
	-- Create a Staging Table for selected products
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_products (
		equip_id INT, 
		equip_qty INT
	);
    
    INSERT INTO temp_products (equip_id, equip_qty)
    VALUES (at_equip_id, at_equip_qty);
END //
DELIMITER ;

/***********************************
* CASE 4: ADD new quote record and selected equipment to database
************************************/
DELIMITER //
CREATE PROCEDURE new_quote(
	IN nq_proj_id INT
)
BEGIN
	-- Declare variables
	DECLARE d_quote_id INT;

	-- Add new record to QUOTE table
	INSERT INTO quote (proj_id, quote_date)
    VALUES (nq_proj_id, CURDATE());
    SET d_quote_id = LAST_INSERT_ID();
    
    -- Add products to QUOTE_HAS_EQUIP table
    INSERT INTO quote_has_equip (quote_id, equip_id, quantity)
    SELECT d_quote_id, equip_id, equip_qty
    FROM temp_products;
    
    DROP TEMPORARY TABLE IF EXISTS temp_products;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE calc_quote(IN cq_quote_id INT)
BEGIN 
	DECLARE total_hours DOUBLE DEFAULT 0;
    DECLARE total_labor_cost DOUBLE DEFAULT 0;
    DECLARE total_equip_cost DOUBLE DEFAULT 0;
    DECLARE total_commission DOUBLE DEFAULT 0;
    DECLARE total_all_cost DOUBLE DEFAULT 0;
    DECLARE total_profit DOUBLE DEFAULT 0;
    DECLARE total_charge DOUBLE DEFAULT 0;
    DECLARE labor_rate DOUBLE DEFAULT 0;
    DECLARE commission_rate DOUBLE DEFAULT 0;
    DECLARE profit_rate DOUBLE DEFAULT 0;

	-- Get rates
	SELECT rate_per_unit INTO labor_rate FROM rate WHERE type = 'labor' LIMIT 1;
    SELECT rate_per_unit INTO commission_rate FROM rate WHERE type = 'commission' LIMIT 1;
    SELECT rate_per_unit INTO profit_rate FROM rate WHERE type = 'profit' LIMIT 1;

	-- calculate HOURS & EQUIP cost
	SELECT 
        COALESCE(round(SUM(e.install_hours * qe.quantity), 2), 0),
        COALESCE(round(SUM(e.equip_cost * qe.quantity), 2), 0)
    INTO total_hours, total_equip_cost
    FROM quote_has_equip qe
    JOIN equipment e ON qe.equip_id = e.equip_id
    WHERE qe.quote_id = cq_quote_id;

	-- calculate LABOR cost
	SET total_labor_cost = round(total_hours * labor_rate, 2);

	-- calculate COMMISSION
    SET total_commission = round((total_equip_cost + total_labor_cost) * commission_rate, 2);    
    
    -- calculate ALL COST
    SET total_all_cost = total_labor_cost + total_equip_cost + total_commission;
    
    -- calculate PROFIT
    SET total_profit = round(total_all_cost * profit_rate, 2);
    
    -- calculate CHARGE
	SET total_charge = total_all_cost + total_profit;
    
    UPDATE quote
    SET hours = total_hours, equip_cost = total_equip_cost, labor_cost = total_labor_cost, 
		commission_cost = total_commission, total_cost = total_all_cost, profit = total_profit,
        charge_cust = total_charge
	WHERE quote_id = cq_quote_id;

END //
DELIMITER ;

/********************************************
* CASE 6: Delete a manager rejected quote - does not delete the project
*********************************************/
DELIMITER //
CREATE PROCEDURE mgr_reject(IN cq_quote_id INT, IN cq_mgr_approved TINYINT)
BEGIN
	IF cq_mgr_approved = 0 THEN
        DELETE FROM quote WHERE quote_id = cq_quote_id;
	ELSEIF cq_mgr_approved = 1 THEN
		UPDATE quote
        SET mgr_approved = 1
        WHERE quote_id = cq_quote_id;
	END IF;
END //
DELIMITER ;

/********************************************
* CASE 7: Update quote status when customer Accepts or Declines the quote
*********************************************/
DELIMITER //
CREATE PROCEDURE cust_decides(IN cq_quote_id INT, IN cq_cust_accept TINYINT)
BEGIN
	UPDATE quote
    SET accepted = cq_cust_accept, close_date = CURDATE()
    WHERE quote_id = cq_quote_id;
END //
DELIMITER ;

/********************************************
* CASE 8: Formats a list of products selected with quantity
*********************************************/
DELIMITER //
CREATE PROCEDURE prt_equip_list(IN pe_quote_id INT)
BEGIN
    SELECT CONCAT ( '(', qe.quantity, ') ', e.equip_print_desc ) AS equip_list
    FROM equipment e
    JOIN quote_has_equip qe on e.equip_id = qe.equip_id
    WHERE qe.quote_id = pe_quote_id;    
END //
DELIMITER ;

/********************************************
* CASE 9: Provides a list of Features selected without duplicates
*********************************************/
DELIMITER //
CREATE PROCEDURE prt_features_list(IN pe_quote_id INT)
BEGIN
    SELECT DISTINCT f.feature_print_desc
    FROM feature f
		JOIN equip_has_feature ef on f.feature_id = ef.feature_id
        JOIN quote_has_equip qe on ef.equip_id = qe.equip_id
    WHERE qe.quote_id = pe_quote_id
    ORDER BY f.feature_print_desc;    
END //
DELIMITER ;

/********************************************
* CASE 10: Provides other basic quote information for printing
*********************************************/
DELIMITER //
CREATE PROCEDURE prt_quote_detail(IN pq_quote_id INT)
BEGIN
	DECLARE warranty VARCHAR(80);
    
    SELECT m.warranty 
    INTO warranty 
    FROM manufacturer m 
    WHERE m.manu_id = (
		SELECT MIN(m.manu_id) 
		FROM manufacturer m 
			JOIN equipment e ON m.manu_id = e.manu_id
			JOIN quote_has_equip qe ON qe.equip_id = e.equip_id
		WHERE qe.quote_id = pq_quote_id
	);
		
    SELECT CONCAT(c.first_name, ' ', c.last_name) AS name,
		a.address,
        CONCAT(a.city, ', ',  a.state, ' ', a.zip) AS city_st_zip,
        q.quote_date,
        p.proj_name,
        q.charge_cust,
        warranty
    FROM quote q 
		LEFT JOIN project p ON q.proj_id = p.proj_id
        LEFT JOIN customer c ON p.cust_id = c.cust_id
        LEFT JOIN address a ON p.address_id = a.address_id        
    WHERE q.quote_id = pq_quote_id;    
END //
DELIMITER ;