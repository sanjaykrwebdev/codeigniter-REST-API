-- phpMyAdmin SQL Dump
-- version 4.1.6
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Sep 03, 2016 at 08:55 PM
-- Server version: 5.6.16
-- PHP Version: 5.5.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `apps`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_CheckLogin`(IN `Email` VARCHAR(100), IN `Psw` VARCHAR(100))
    NO SQL
BEGIN

  DECLARE ResultCount INT;
  DECLARE ResultMessage varchar(15);
SET @ResultCount = (SELECT COUNT(C.CustomerId) FROM dabba_customerdetails C  WHERE C.Email = Email AND C.Password = psw);
	    IF (@ResultCount > 0) THEN
 SELECT C.CustomerId, C.FirstName, C.LastName, C.UserName, C.PictureURLId, C.Email, C.Gender, C.BirthDate,
C.Address1 +' '+ C.Address2, C.CountryId, C.StateID AS StateID, C.Status 
				FROM dabba_customerdetails C WHERE C.Email = Email AND C.Password = psw;
ELSE 
           SET @ResultMessage='User not found';
	       SELECT @ResultMessage;
	    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_GetVendors`()
    NO SQL
BEGIN

   SELECT Id, Name, Address, Cuisine, Veg, NonVeg, Rate, distance, ImageUrl, Description, Specials FROM dabba_vendors;
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_registerUser`(IN `UserName` VARCHAR(100), IN `Password` VARCHAR(100), IN `Email` VARCHAR(100), IN `FirstName` VARCHAR(100), IN `LastName` VARCHAR(100), IN `date` DATE)
    NO SQL
BEGIN
	DECLARE userId INT default 0;
	START TRANSACTION;
		INSERT INTO dabba_customerdetails (UserName, Password, Email, FirstName, LastName, BirthDate)  
			VALUES (UserName, Password, Email, FirstName, LastName, date);
		SET userId = LAST_INSERT_ID();
		SELECT userId as Status;
	COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dabba_customerdetails`
--

CREATE TABLE IF NOT EXISTS `dabba_customerdetails` (
  `CustomerId` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(100) DEFAULT NULL,
  `LastName` varchar(100) DEFAULT NULL,
  `PictureURLId` int(11) DEFAULT NULL,
  `UserName` varchar(50) DEFAULT NULL,
  `Password` varchar(200) DEFAULT NULL,
  `Email` varchar(200) DEFAULT NULL,
  `Gender` enum('Male','Female') DEFAULT NULL,
  `BirthDate` date DEFAULT NULL,
  `Address1` varchar(250) DEFAULT NULL,
  `Address2` varchar(250) DEFAULT NULL,
  `StateId` int(11) DEFAULT NULL,
  `CountryId` int(11) DEFAULT NULL,
  `Postcode` varchar(6) DEFAULT NULL,
  `PhoneNumber` varchar(13) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `CreatedById` int(11) DEFAULT NULL,
  `CreatedByDate` datetime DEFAULT NULL,
  `ModifiedById` int(11) DEFAULT NULL,
  `ModifiedByDate` datetime DEFAULT NULL,
  PRIMARY KEY (`CustomerId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `dabba_customerdetails`
--

INSERT INTO `dabba_customerdetails` (`CustomerId`, `FirstName`, `LastName`, `PictureURLId`, `UserName`, `Password`, `Email`, `Gender`, `BirthDate`, `Address1`, `Address2`, `StateId`, `CountryId`, `Postcode`, `PhoneNumber`, `Status`, `CreatedById`, `CreatedByDate`, `ModifiedById`, `ModifiedByDate`) VALUES
(1, 'test@test.com', '', NULL, 'sanju', 'Kuamr', 'passs', NULL, '0000-00-00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'test@test.com', 'raju', NULL, 'raju', 'mohan', 'passs', NULL, '0000-00-00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'sanju', 'kumar', NULL, 'sanju', 'sanju', 'test@test.com', 'Male', '1991-01-15', 'noida', 'noida', 12, 22, '123344', '1111111111', 1, 1, '2015-09-09 00:00:00', 2, '2015-09-17 00:00:00'),
(4, 'sanaajay', 'Kuaaamr', NULL, 'raj', 'passs', 'test@testa.com', NULL, '2015-05-05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `dabba_vendors`
--

CREATE TABLE IF NOT EXISTS `dabba_vendors` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `ImageUrl` varchar(255) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `distance` varchar(100) DEFAULT NULL,
  `Cuisine` varchar(255) DEFAULT NULL,
  `Rate` set('1','2','3','4','5') DEFAULT NULL,
  `Veg` set('true','false') DEFAULT NULL COMMENT '0: False, 1:True',
  `NonVeg` set('true','false') DEFAULT NULL COMMENT '0: False, 1:True',
  `Specials` varchar(255) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `dabba_vendors`
--

INSERT INTO `dabba_vendors` (`Id`, `Name`, `ImageUrl`, `Address`, `distance`, `Cuisine`, `Rate`, `Veg`, `NonVeg`, `Specials`, `Description`) VALUES
(1, 'Haldiram''s\n', 'http://www.abplive.in/incoming/article618281.ece/alternates/FREE_768/download.jpg', '6, L-Block, Outer Circle, Connaught Place\nNew Delhi', '0.5', 'Desserts, Street Food, North Indian, South Indian, Chinese', '4', 'true', 'false', 'Raj Kachori, Papdi chaat, Chhole Bhature and the assortment of sweets', 'Their economical vegetarian food and variety of Indian sweets'),
(2, 'Domino''s Pizza', 'http://www.dominos.co.in/theme/front/images/about.png', 'N-6, Ground Floor, Block N-6/7, Circle D, Connaught Place, New Delhi, Delhi 110001', '0.4', 'Pizza, Fast Food', '3', 'false', 'true', 'Spicy Tiple Tango, Country Special, 5 Pepper', 'Delivery/carryout chain offering a wide range of pizza, plus chicken wings & other sides.'),
(3, 'Rajinder Da Dhaba', 'http://livedoor.blogimg.jp/coaches_guts_india_r/imgs/9/5/95f878f0-s.jpg', 'AB-14, Safdarjung Enclave Market, New Delhi', '0.4', 'North Indian, Mughlai, Chinese', '5', 'true', 'true', 'Chicken Malai Tikka, Mutton Seekh Kabab, Spl Mutton Galauti Kabab', 'Legendary North Indian delicacies');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
