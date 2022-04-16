-- Tworzenie nowej tablicy, gdyż w bazie nie istnieje adekwatna tabela dla partycjonowania (klucze obce)

CREATE TABLE `logs` (
`logs_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
`user_ID` int(10) unsigned NOT NULL,
`dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`logs_ID`,`dt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 1. Partycjonowanie tabeli z maxvalue:
ALTER TABLE `logs` 
PARTITION BY RANGE (year(`dt`))
(PARTITION `less_than_2020` VALUES LESS THAN (2020) ENGINE = InnoDB,
PARTITION `less_than_2021` VALUES LESS THAN (2021) ENGINE = InnoDB,
PARTITION `the_newest` VALUES LESS THAN MAXVALUE ENGINE = InnoDB);

-- 2. Wersjonowanie:
-- Tworzenie nowej tablicy, gdyż w bazie nie istnieje adekwatna tabela dla partycjonowania (klucze obce)
CREATE TABLE `system_logs` (
`system_logs_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
`message` varchar(255) NOT NULL,
`dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`system_logs_ID`,`dt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `system_logs` WITH SYSTEM VERSIONING
  PARTITION BY SYSTEM_TIME (
    PARTITION p_hist HISTORY,
    PARTITION p_cur CURRENT
  );

-- 3. Zdarzenie:
SET GLOBAL event_scheduler = ON;

CREATE OR REPLACE EVENT add_new_partition ON SCHEDULE EVERY 1 YEAR STARTS '2021-06-10 17:06:00'
ON COMPLETION PRESERVE ENABLE DO
BEGIN
SET @new_year=YEAR(now())+1;
SET @sql = concat("alter table logs reorganize partition the_newest into (partition less_than_", @new_year, " values less than (", (@new_year+1) ,"), partition the_newest values less than maxvalue);");
PREPARE st1 FROM @sql;
EXECUTE st1;
DEALLOCATE PREPARE st1;
END;
