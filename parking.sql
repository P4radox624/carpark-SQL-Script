-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema parking
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema parking
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `parking` DEFAULT CHARACTER SET utf8mb3 ;
USE `parking` ;

-- -----------------------------------------------------
-- Table `parking`.`maker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`maker` (
  `maker_ID` INT NOT NULL AUTO_INCREMENT,
  `maker_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`maker_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `parking`.`model`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`model` (
  `model_ID` INT NOT NULL AUTO_INCREMENT,
  `model_name` VARCHAR(45) NOT NULL,
  `model_maker_ID` INT NOT NULL,
  PRIMARY KEY (`model_ID`, `model_maker_ID`),
  INDEX `fk_model_maker_idx` (`model_maker_ID` ASC) VISIBLE,
  CONSTRAINT `fk_model_maker`
    FOREIGN KEY (`model_maker_ID`)
    REFERENCES `parking`.`maker` (`maker_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `parking`.`parking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`parking` (
  `parking_ID` INT NOT NULL AUTO_INCREMENT,
  `parking_space` VARCHAR(45) NOT NULL,
  `parking_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`parking_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `parking`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`payment` (
  `payment_ID` INT NOT NULL AUTO_INCREMENT,
  `payment_type` ENUM('cash', 'card', 'mobile wallet') NOT NULL DEFAULT 'cash',
  PRIMARY KEY (`payment_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `parking`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`user` (
  `user_ID` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NOT NULL,
  `user_pass` VARCHAR(100) NOT NULL,
  `license_number` VARCHAR(45) NOT NULL,
  `user_contact` VARCHAR(11) NOT NULL,
  `user_type` ENUM('user', 'admin', 'employee') NOT NULL DEFAULT 'user',
  `user_email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_ID`),
  UNIQUE INDEX `license_number_UNIQUE` (`license_number` ASC) VISIBLE,
  UNIQUE INDEX `user_cell_UNIQUE` (`user_contact` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `parking`.`vehicle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`vehicle` (
  `vehicle_ID` INT NOT NULL AUTO_INCREMENT,
  `vehicle_name` VARCHAR(7) NOT NULL,
  `vehicle_model_ID` INT NOT NULL,
  `user_ID` INT NOT NULL,
  PRIMARY KEY (`vehicle_ID`, `vehicle_model_ID`, `user_ID`),
  INDEX `fk_vehicle_model_idx` (`vehicle_model_ID` ASC) VISIBLE,
  INDEX `fk_vehicle_user_idx` (`user_ID` ASC) VISIBLE,
  CONSTRAINT `fk_vehicle_model`
    FOREIGN KEY (`vehicle_model_ID`)
    REFERENCES `parking`.`model` (`model_ID`),
  CONSTRAINT `fk_vehicle_user`
    FOREIGN KEY (`user_ID`)
    REFERENCES `parking`.`user` (`user_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `parking`.`transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`transaction` (
  `transaction_ID` INT NOT NULL AUTO_INCREMENT,
  `transaction_date` VARCHAR(45) NOT NULL,
  `vehicle_number` VARCHAR(45) NOT NULL,
  `time_in` VARCHAR(45) NOT NULL,
  `time_out` VARCHAR(45) NULL DEFAULT NULL,
  `owner_ID` INT NOT NULL,
  `park_space` INT NOT NULL,
  `vehicle_ID` INT NOT NULL,
  PRIMARY KEY (`transaction_ID`, `owner_ID`, `park_space`, `vehicle_ID`),
  INDEX `owner_ID_idx` (`owner_ID` ASC) VISIBLE,
  INDEX `park_slot_idx` (`park_space` ASC) VISIBLE,
  INDEX `fk_transaction_vehicle_idx` (`vehicle_ID` ASC) VISIBLE,
  CONSTRAINT `fk_transaction_vehicle1`
    FOREIGN KEY (`vehicle_ID`)
    REFERENCES `parking`.`vehicle` (`vehicle_ID`),
  CONSTRAINT `owner_ID`
    FOREIGN KEY (`owner_ID`)
    REFERENCES `parking`.`user` (`user_ID`),
  CONSTRAINT `park_space_ID`
    FOREIGN KEY (`park_space`)
    REFERENCES `parking`.`parking` (`parking_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `parking`.`receipt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `parking`.`receipt` (
  `receipt_ID` INT NOT NULL AUTO_INCREMENT,
  `receipt_date` VARCHAR(45) NOT NULL,
  `mode_of_payment` INT NOT NULL,
  `transaction_ID` INT NOT NULL,
  `transaction_owner_ID` INT NOT NULL,
  `transaction_park_space` INT NOT NULL,
  PRIMARY KEY (`receipt_ID`, `mode_of_payment`, `transaction_ID`, `transaction_owner_ID`, `transaction_park_space`),
  INDEX `mode_of_payment_idx` (`mode_of_payment` ASC) INVISIBLE,
  INDEX `fk_receipt_transaction1_idx` (`transaction_ID` ASC, `transaction_owner_ID` ASC, `transaction_park_space` ASC) VISIBLE,
  CONSTRAINT `fk_receipt_transaction`
    FOREIGN KEY (`transaction_ID` , `transaction_owner_ID` , `transaction_park_space`)
    REFERENCES `parking`.`transaction` (`transaction_ID` , `owner_ID` , `park_space`),
  CONSTRAINT `mode_of_payment_ID`
    FOREIGN KEY (`mode_of_payment`)
    REFERENCES `parking`.`payment` (`payment_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
