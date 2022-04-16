-- VIEW WITHOUT JOINS:

-- 1:

CREATE VIEW Income_Category AS 
SELECT name
FROM category
WHERE general_type_id = 1;

-- 2:

CREATE VIEW Expense_Category AS 
SELECT name
FROM category
WHERE general_type_id = 2;

-- 3:

CREATE VIEW Category_user_1 AS
SELECT name
FROM category
WHERE user_id = 1;

-- 4:

CREATE VIEW Trasaction_payee_2 AS
SELECT title, transaction_date, amount, transaction_type
FROM transaction
WHERE payee_id = 2;

-- 5:

CREATE VIEW Category_user_2 AS
SELECT name
FROM category
WHERE user_id = 2;

-- 6:

CREATE VIEW Category_user_3 AS
SELECT name
FROM category
WHERE user_id = 3;

-- VIEW WITH JOINS:

-- 1:

CREATE VIEW User_And_Accounts_With_PLN AS
SELECT user.email, user.nickname, account.name AS name_account, account.current_balance 
FROM user
LEFT JOIN account ON user.user_id = account.user_id
LEFT JOIN currency ON account.currency_id = currency.currency_id
WHERE currency.name = 'PLN';

-- 2:

CREATE VIEW User_And_Accounts_With_USD AS
SELECT u.email, u.nickname, acc.name AS name_account, acc.current_balance 
FROM user AS u
NATURAL JOIN account AS acc
LEFT JOIN currency AS cur USING (currency_id)
WHERE cur.name = 'USD';

-- 3:

CREATE VIEW All_Transaction_For_Account AS
SELECT acc.name AS 'account name', t.title AS 'transaction_title', t.amount, t.transaction_type, t.transaction_date  
FROM transaction AS t
JOIN account AS acc  USING(account_id);

-- 4:

CREATE VIEW Category_With_Subcategory AS
SELECT u.nickname, cat.name AS 'category_name', sub.name AS 'subcategory_name'
FROM category AS cat
LEFT JOIN subcategory AS sub USING(category_id)
JOIN user AS u USING(user_id);

-- 5:

CREATE VIEW Payee_For_User AS
SELECT u.nickname, p.name AS 'payee_name', gt.name AS 'general_type'
FROM user AS u
LEFT JOIN payee AS p USING(user_id)
JOIN general_type AS gt USING(general_type_id);

-- 6:

CREATE VIEW All_Transaction_For_User_3 AS
SELECT t.title AS 'transaction_title', t.amount, t.transaction_type, t.transaction_date  
FROM transaction AS t
JOIN account AS acc  USING(account_id)
JOIN user AS u USING(user_id)
WHERE user_id = 3;

-- 7:

CREATE VIEW All_Income_Transaction_For_michal3 AS
SELECT t.title AS 'transaction_title', t.amount, t.transaction_type, t.transaction_date  
FROM transaction AS t
JOIN account AS acc  USING(account_id)
JOIN user AS u USING(user_id)
WHERE transaction_type = 'income' AND nickname = 'michal3';

-- 8:

CREATE VIEW All_Income_Transaction_In_USD AS
SELECT t.title AS 'transaction_title', t.amount, t.transaction_type, t.transaction_date  
FROM transaction AS t
JOIN account AS acc  USING(account_id)
JOIN currency AS cur USING(currency_id)
WHERE cur.name = 'USD';
