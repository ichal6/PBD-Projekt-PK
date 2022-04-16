-- HAVING:

CREATE OR REPLACE VIEW v_display_only_name_if_exist_more_than_one_in_database AS
SELECT name, COUNT(*) AS how_many_the_same_name_of_subcategory_in_database 
FROM subcategory 
GROUP BY name 
HAVING how_many_the_same_name_of_subcategory_in_database > 1; 

-- GROUP BY:

CREATE OR REPLACE VIEW v_display_unique_subcategories_name AS
SELECT name
FROM subcategory
GROUP BY name;

-- **MATHEMATIC FUNCTIONS:**

-- 1 - aggregate function:

CREATE OR REPLACE VIEW v_sum_of_all_amount_for_income_transactions AS
SELECT SUM(amount) 
FROM transaction 
WHERE transaction_type = 'INCOME';
 
-- 2 - string function:

CREATE OR REPLACE VIEW v_nickname_to_upper_case AS
SELECT UPPER(nickname) 
FROM user;

-- 3 - random row from payee:

CREATE OR REPLACE VIEW v_random_row_from_payee AS
SELECT * FROM payee 
ORDER BY RAND() 
LIMIT 1;

-- 4 - day from created user:

CREATE OR REPLACE VIEW v_count_day_from_created AS
SELECT DATEDIFF(NOW(), created_at) AS 'Day from created'
FROM user;

-- 5 - display transaction between 5 to 100 amount:

CREATE OR REPLACE VIEW v_transaction_between_5_to_100_amount AS
SELECT * FROM transaction 
WHERE amount 
BETWEEN 5 AND 100;


