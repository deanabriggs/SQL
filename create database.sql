-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`address` ;

CREATE TABLE IF NOT EXISTS `mydb`.`address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(65) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` CHAR(2) NOT NULL,
  `zip` CHAR(5) NOT NULL,
  PRIMARY KEY (`address_id`),
  UNIQUE INDEX `unq_address` (`address` ASC, `city` ASC, `state` ASC, `zip` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 515
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`category` ;

CREATE TABLE IF NOT EXISTS `mydb`.`category` (
  `cat_name` VARCHAR(12) NOT NULL,
  `cat_print_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cat_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`customer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`customer` (
  `cust_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(80) NULL DEFAULT NULL,
  `phone` VARCHAR(10) NULL DEFAULT NULL,
  `business` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`cust_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `idx_name` (`last_name` ASC, `first_name` ASC) INVISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 32
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`manufacturer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`manufacturer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`manufacturer` (
  `manu_id` INT NOT NULL AUTO_INCREMENT,
  `manu_name` VARCHAR(45) NOT NULL,
  `warranty` VARCHAR(80) NULL DEFAULT NULL,
  PRIMARY KEY (`manu_id`),
  UNIQUE INDEX `unq_manu_name` (`manu_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`equipment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`equipment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`equipment` (
  `equip_id` INT NOT NULL AUTO_INCREMENT,
  `equip_name` VARCHAR(45) NOT NULL,
  `equip_print_desc` VARCHAR(75) NOT NULL,
  `install_hours` DOUBLE NOT NULL,
  `equip_cost` DOUBLE NOT NULL,
  `manu_id` INT NOT NULL,
  `cat_name` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`equip_id`),
  UNIQUE INDEX `unq_name_manu` (`equip_name` ASC, `manu_id` ASC) VISIBLE,
  INDEX `manufacturer1_idx` (`manu_id` ASC) VISIBLE,
  INDEX `category1_idx` (`cat_name` ASC) VISIBLE,
  INDEX `idx_equip_name` (`equip_name` ASC) VISIBLE,
  CONSTRAINT `category1`
    FOREIGN KEY (`cat_name`)
    REFERENCES `mydb`.`category` (`cat_name`),
  CONSTRAINT `manufacturer1`
    FOREIGN KEY (`manu_id`)
    REFERENCES `mydb`.`manufacturer` (`manu_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 39
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`feature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`feature` ;

CREATE TABLE IF NOT EXISTS `mydb`.`feature` (
  `feature_id` INT NOT NULL AUTO_INCREMENT,
  `feature_name` VARCHAR(45) NOT NULL,
  `feature_print_desc` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`feature_id`),
  UNIQUE INDEX `unq_feature_name` (`feature_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`equip_has_feature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`equip_has_feature` ;

CREATE TABLE IF NOT EXISTS `mydb`.`equip_has_feature` (
  `equip_id` INT NOT NULL,
  `feature_id` INT NOT NULL,
  PRIMARY KEY (`equip_id`, `feature_id`),
  INDEX `feature1_idx` (`feature_id` ASC) VISIBLE,
  INDEX `equipment1_idx` (`equip_id` ASC) VISIBLE,
  CONSTRAINT `equipment1`
    FOREIGN KEY (`equip_id`)
    REFERENCES `mydb`.`equipment` (`equip_id`),
  CONSTRAINT `feature1`
    FOREIGN KEY (`feature_id`)
    REFERENCES `mydb`.`feature` (`feature_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`project` ;

CREATE TABLE IF NOT EXISTS `mydb`.`project` (
  `proj_id` INT NOT NULL AUTO_INCREMENT,
  `proj_name` VARCHAR(60) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `lead_date` DATE NOT NULL,
  `cust_id` INT NOT NULL,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`proj_id`),
  UNIQUE INDEX `unq_proj_name` (`cust_id` ASC, `address_id` ASC, `proj_name` ASC) VISIBLE,
  INDEX `customer1_idx` (`cust_id` ASC) VISIBLE,
  INDEX `address1_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `mydb`.`address` (`address_id`),
  CONSTRAINT `customer1`
    FOREIGN KEY (`cust_id`)
    REFERENCES `mydb`.`customer` (`cust_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1031
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`quote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`quote` ;

CREATE TABLE IF NOT EXISTS `mydb`.`quote` (
  `quote_id` INT NOT NULL AUTO_INCREMENT,
  `proj_id` INT NOT NULL,
  `quote_date` DATE NOT NULL,
  `mgr_approved` TINYINT(1) NULL DEFAULT '0',
  `accepted` TINYINT(1) NULL DEFAULT '0',
  `close_date` DATETIME NULL DEFAULT NULL,
  `hours` DOUBLE NULL DEFAULT '0',
  `equip_cost` DOUBLE NULL DEFAULT '0',
  `labor_cost` DOUBLE NULL DEFAULT '0',
  `commission_cost` DOUBLE NULL DEFAULT '0',
  `total_cost` DOUBLE NULL DEFAULT NULL,
  `profit` DOUBLE NULL DEFAULT '0',
  `charge_cust` DOUBLE NULL DEFAULT '0',
  PRIMARY KEY (`quote_id`),
  INDEX `project1_idx` (`proj_id` ASC) VISIBLE,
  CONSTRAINT `project1`
    FOREIGN KEY (`proj_id`)
    REFERENCES `mydb`.`project` (`proj_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`quote_has_equip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`quote_has_equip` ;

CREATE TABLE IF NOT EXISTS `mydb`.`quote_has_equip` (
  `quote_id` INT NOT NULL,
  `equip_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT '1',
  PRIMARY KEY (`quote_id`, `equip_id`),
  INDEX `equipment2_idx` (`equip_id` ASC) VISIBLE,
  INDEX `quote1_idx` (`quote_id` ASC) VISIBLE,
  CONSTRAINT `equipment2`
    FOREIGN KEY (`equip_id`)
    REFERENCES `mydb`.`equipment` (`equip_id`),
  CONSTRAINT `quote1`
    FOREIGN KEY (`quote_id`)
    REFERENCES `mydb`.`quote` (`quote_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`rate`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`rate` ;

CREATE TABLE IF NOT EXISTS `mydb`.`rate` (
  `rate_id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL COMMENT 'commission, labor, profit',
  `rate_per_unit` DOUBLE NOT NULL,
  `unit_desc` VARCHAR(45) NOT NULL COMMENT 'per dollar, per sale, per hour',
  PRIMARY KEY (`rate_id`),
  INDEX `idx_type` (`type` ASC) VISIBLE,
  UNIQUE INDEX `type_UNIQUE` (`type` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure new_project
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`new_project`;

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_project`(
	IN first_name VARCHAR(45),
    IN last_name VARCHAR(45),
    IN address VARCHAR(65),
    IN city VARCHAR(35),
    IN state CHAR(2),
    IN zip CHAR (5),
    IN email VARCHAR(80),
    IN phone VARCHAR(10), 
    IN business VARCHAR(60),
    OUT project_id INT -- Output to return to caller
)
BEGIN
	-- Declare variables
	DECLARE cust_id INT;
	DECLARE address_id INT;
    DECLARE project_id INT;
    DECLARE existing_cust INT;
    DECLARE existing_address INT;
    DECLARE existing_proj INT;
    
    -- Exit handler for SQL exception
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction failed. Rolling back changes.';
	END;

	-- Starts transaction
	START TRANSACTION;
	
    -- CHECK if customer already exists in database
    SELECT MIN(cust_id) INTO existing_cust
    FROM customer c
    WHERE c.email = email;
    
    -- If customer EXISTS, use existing customer record
    IF existing_cust > 0 THEN
		SET cust_id = existing_cust;
	ELSE
		-- If not existing, ADD customer to the database
		INSERT INTO customer (first_name, last_name, email, phone, business)
		VALUES (first_name, last_name, email, phone, business);
		-- Update customer_id with new value
		SET cust_id = LAST_INSERT_ID();
    END IF;
    
    -- CHECK if address already exists in database
	SELECT MIN(address_id) INTO existing_address 
    FROM address a
    WHERE a.address = address AND a.city = city AND a.state = state AND a.zip = zip;
    
	-- If address EXISTS, use the existing address
    IF existing_address > 0 THEN
		SET address_id = existing_address;
    ELSE 
		-- If not existing, ADD address info to the database
		INSERT INTO address (address, city, state, zip)
		VALUES (address, city, state, zip);
		-- Update address_id with new value
		SET address_id = LAST_INSERT_ID();
	END IF;

	-- CHECK if "new project" already exists for this customer at this address
	SELECT MIN(proj_id) INTO existing_proj
    FROM project p
    WHERE p.cust_id = cust_id AND p.address_id = address_id AND proj_name = 'New Project';
	
    -- If existing, return existing record to update
    IF existing_proj > 0 THEN
		SET project_id = existing_proj;
	ELSE
		-- If not existing, ADD new project to the database
		INSERT INTO project (proj_name, status, lead_date, cust_id, address_id)
		VALUES ( 'New Project', 'New', CURDATE(), cust_id, address_id);
        -- Update project_id
        SET project_id = LAST_INSERT_ID();
	END IF;
        
	COMMIT;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
