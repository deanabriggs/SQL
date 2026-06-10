USE mydb;

-- CASE 1: 
-- RETURNS: project_id
-- ENTER: first_name, last_name, address, city, state, zip, email, phone, business 
SET @np_project_id = 0;
CALL new_project('Joe', 'Black','987 Maple St', 'Sacramento', 'CA', '95812', 'jblack@me.com', '9165551212', NULL, @np_project_id);
SELECT @np_project_id AS project_id;

-- CASE 2: 
-- RETURNS: Filtered list of products with equip_id
-- ENTER: category.cat_name, manufacturer.manu_name
CALL filter_products ('camera', 'HIK Vision');

-- CASE 3:
-- RETURNS: temp_table
-- ENTER: prod_id, quantity
CALL add_temp_products(1, 2);
CALL add_temp_products(4, 3);
CALL add_temp_products(15, 1);
SELECT equip_id, equip_qty FROM temp_products;

-- CASE 4:
-- CREATES: quote record
-- ENTER: project_id
CALL new_quote(1001);  -- Creates a new quote for project ID 1001
SELECT * FROM quote WHERE quote_id = LAST_INSERT_ID();

-- CASE 5:
-- UPDATES: quote (calculated fields)
-- ENTER: quote_id
CALL calc_quote(1);
SELECT * FROM quote WHERE quote_id = 1;

-- CASE 6:
-- UPDATES or DELETES: quote (mgr_approved)
-- ENTER: quote_id, approve/reject (0/1)
CALL mgr_reject(1, 1);
SELECT * FROM quote WHERE quote_id = 1;

-- CASE 7:
-- UPDATES: quote (accepted & close_date)
-- ENTER: quote_id, accept/decline (0/1)
CALL cust_decides(1, 1);
CALL cust_decides(1, 0);
SELECT * FROM quote WHERE quote_id = 1;

-- CASE 8:
-- RETURNS: list of selected equip with quantity
-- ENTER: quote_id
CALL prt_equip_list (1);

-- CASE 9:
-- RETURNS: list of included features
-- ENTER: quote_id
CALL prt_features_list (1);

-- CASE 10:
-- RETURNS: customer and quote info (name, address, warranty, amount)
-- ENTER: quote_id
CALL prt_quote_detail (1);
