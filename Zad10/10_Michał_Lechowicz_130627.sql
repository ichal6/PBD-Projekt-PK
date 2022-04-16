delimiter ;;
CREATE OR REPLACE PROCEDURE `delete_transaction`(IN `vtransaction_id` int)
dt: BEGIN

SET SESSION autocommit := 0;

START TRANSACTION;

SET @amount_t = (SELECT amount 
FROM transaction 
WHERE vtransaction_id = transaction.transaction_id 
LOCK IN SHARE MODE);

SELECT @amount_t;

IF ISNULL(@amount_id) THEN
	ROLLBACK;
	SET SESSION autocommit := 1;
	LEAVE dt;
END IF;	

SET @account_id = (SELECT account_id 
FROM transaction 
WHERE vtransaction_id = transaction.transaction_id
LOCK IN SHARE MODE);

SET @t_type = (SELECT transaction_type 
FROM transaction 
WHERE vtransaction_id = transaction.transaction_id
FOR UPDATE);

CASE @t_type
	WHEN 'income' THEN
		UPDATE account 
		SET current_balance=current_balance-@amount_t
		WHERE @account_id = account.account_id;
	WHEN 'expense' THEN
		UPDATE account 
		SET current_balance=current_balance+@amount_t
		WHERE @account_id = account.account_id;
END CASE;

DELETE FROM transaction 
WHERE transaction.transaction_id = vtransaction_id;



COMMIT;

SET SESSION autocommit := 1;

END ;;

delimiter ;