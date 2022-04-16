-- UNION:
CREATE VIEW v_names_of_categories_subcategories
	AS SELECT name FROM `category`
	UNION
	SELECT name FROM `subcategory`;


-- INTERSECT:
CREATE VIEW v_account_with_current_balance_email
	AS SELECT `account`.name as account_name, `account`.current_balance, `user`.email
		 FROM `account`
		 LEFT JOIN `user`
		 ON `user`.user_id = `account`.user_id
	INTERSECT
		 SELECT `account`.name as account_name, `account`.current_balance, `user`.email
		 FROM `account`
		 RIGHT JOIN `user`
		 ON `user`.user_id = `account`.user_id;


-- EXCEPT:
CREATE VIEW v_all_transactions_without_income_type
	AS SELECT * FROM `transaction`
	EXCEPT
	SELECT * FROM `transaction`
		WHERE `transaction`.transaction_type = 'income';

