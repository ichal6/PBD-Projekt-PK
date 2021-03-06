-- AGGREGATE FUNCTION:

DELIMITER //
CREATE AGGREGATE FUNCTION IF NOT EXISTS avg_amount_transactions(amount double) 
RETURNS DOUBLE

BEGIN
	DECLARE average DOUBLE DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR NOT FOUND RETURN average;
	LOOP
		FETCH GROUP NEXT ROW;
		SET average = average+amount;
	END LOOP;
END //

DELIMITER ;
