-- ANY

CREATE VIEW v_all_name_of_account_with_currency AS
SELECT name 
FROM account
WHERE currency_id = ANY(SELECT currency_id from currency);

-- ALL

CREATE VIEW v_account_with_PLN_currency AS
SELECT name 
FROM account 
WHERE currency_id = ALL(SELECT currency_id from currency WHERE currency.name='PLN');

-- EXISTS

CREATE VIEW v_all_subcategory AS 
SELECT subcategory.subcategory_id, subcategory.name 
FROM subcategory 
WHERE EXISTS (SELECT name FROM category);

-- IN

CREATE VIEW v_user_with_last_login_in_2021 AS 
SELECT nickname 
FROM user 
WHERE YEAR(last_login) IN('2021');
