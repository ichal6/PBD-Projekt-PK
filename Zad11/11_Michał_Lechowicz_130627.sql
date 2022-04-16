CREATE OR REPLACE TRIGGER `add_new_transaction` 
AFTER INSERT ON transaction FOR EACH ROW
BEGIN

CASE NEW.transaction_type
	WHEN 'income' THEN
		UPDATE account 
		SET current_balance=current_balance+NEW.amount 
			WHERE NEW.account_id = account.account_id;
	WHEN 'expense' THEN
		UPDATE account 
		SET current_balance=current_balance-NEW.amount 
			WHERE NEW.account_id = account.account_id;
END CASE;

-- Nie mialem pomyslu gdzie wykorzystac petle
set @w := 10;
WHILE @w>0 DO
	set @w := @w -1;
END WHILE;

END;
