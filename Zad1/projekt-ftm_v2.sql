/*
 Navicat Premium Data Transfer

 Source Server         : MariaDB
 Source Server Type    : MariaDB
 Source Server Version : 100509
 Source Host           : localhost:3306
 Source Schema         : projekt-ftm

 Target Server Type    : MariaDB
 Target Server Version : 100509
 File Encoding         : 65001

 Date: 05/05/2021 20:52:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `current_balance` double(12, 2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `storage_type` enum('cash','bank') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `account_type` enum('business','personal') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `currency_id` tinyint(3) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`account_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `currency_id`(`currency_id`) USING BTREE,
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `account_ibfk_2` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `general_type_id` tinyint(1) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`category_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `general_type_id`(`general_type_id`) USING BTREE,
  CONSTRAINT `category_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `category_ibfk_2` FOREIGN KEY (`general_type_id`) REFERENCES `general_type` (`general_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for currency
-- ----------------------------
DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency`  (
  `currency_id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL CHECK(CHAR_LENGTH(name) = 3),
  PRIMARY KEY (`currency_id`) USING BTREE,
  UNIQUE INDEX `unique_name_of_currency`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for general_type
-- ----------------------------
DROP TABLE IF EXISTS `general_type`;
CREATE TABLE `general_type`  (
  `general_type_id` tinyint(1) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` enum('income','expense') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`general_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for payee
-- ----------------------------
DROP TABLE IF EXISTS `payee`;
CREATE TABLE `payee`  (
  `payee_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `general_type_id` tinyint(1) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`payee_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `general_type_id`(`general_type_id`) USING BTREE,
  CONSTRAINT `payee_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `payee_ibfk_2` FOREIGN KEY (`general_type_id`) REFERENCES `general_type` (`general_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for subcategory
-- ----------------------------
DROP TABLE IF EXISTS `subcategory`;
CREATE TABLE `subcategory`  (
  `subcategory_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `general_type_id` tinyint(1) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`subcategory_id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  INDEX `general_type_id`(`general_type_id`) USING BTREE,
  CONSTRAINT `subcategory_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `subcategory_ibfk_2` FOREIGN KEY (`general_type_id`) REFERENCES `general_type` (`general_type_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for transaction
-- ----------------------------
DROP TABLE IF EXISTS `transaction`;
CREATE TABLE `transaction`  (
  `transaction_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `transaction_date` datetime(6) NOT NULL,
  `title` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `amount` double(12, 2) NOT NULL,
  `transaction_type` enum('income','expense') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `payee_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `subcategory_id` int(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`transaction_id`) USING BTREE,
  INDEX `account_id`(`account_id`) USING BTREE,
  INDEX `payee_id`(`payee_id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  INDEX `transaction_ibfk_4`(`subcategory_id`) USING BTREE,
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`payee_id`) REFERENCES `payee` (`payee_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `transaction_ibfk_4` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategory` (`subcategory_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for transfer
-- ----------------------------
DROP TABLE IF EXISTS `transfer`;
CREATE TABLE `transfer`  (
  `transfer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `transfer_date` datetime(6) NOT NULL,
  `title` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `amount` double(12, 2) NOT NULL,
  `recipient_account_id` int(10) UNSIGNED NOT NULL,
  `owner_account_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`transfer_id`) USING BTREE,
  INDEX `owner_account_id`(`owner_account_id`) USING BTREE,
  INDEX `recipient_account_id`(`recipient_account_id`) USING BTREE,
  CONSTRAINT `transfer_ibfk_1` FOREIGN KEY (`owner_account_id`) REFERENCES `account` (`account_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `transfer_ibfk_2` FOREIGN KEY (`recipient_account_id`) REFERENCES `account` (`account_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL CHECK(email LIKE '%@%'),
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL CHECK(CHAR_LENGTH(password) > 7),
  `nickname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL CHECK(CHAR_LENGTH(nickname) > 1),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `day_from_last_login` int(6) GENERATED ALWAYS AS (to_days(current_timestamp()) - to_days(`last_login`)) VIRTUAL,
  `avatar_b64` blob NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `unique_email_on_user`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
