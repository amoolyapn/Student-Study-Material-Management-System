-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2024 at 07:53 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ssmms`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `AdminId` int(10) NOT NULL,
  `AdminName` varchar(20) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `password` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`AdminId`, `AdminName`, `Email`, `password`) VALUES
(124, 'harshitha', 'harshithabh@gmail.com', 'harshi'),
(125, 'harika', 'harika@gmail.com', 'harika@');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `FId` int(10) NOT NULL,
  `StudentId` varchar(10) NOT NULL,
  `MSub` varchar(50) NOT NULL,
  `Module` int(10) NOT NULL,
  `Comment` text NOT NULL,
  `Rating` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`FId`, `StudentId`, `MSub`, `Module`, `Comment`, `Rating`) VALUES
(5, '1RN21IS048', 'AIML', 3, 'Problem explanation is very nice.', 5),
(6, '1RN21IS048', 'DBMS', 1, 'we can easily understand the concept.', 4),
(7, '1RN21IS035', 'AIML', 3, 'the must contain more problems.', 4);

-- --------------------------------------------------------

--
-- Table structure for table `questionpaper`
--

CREATE TABLE `questionpaper` (
  `PId` int(10) NOT NULL,
  `PScheme` int(4) NOT NULL,
  `PDept` varchar(50) NOT NULL,
  `PSem` int(2) NOT NULL,
  `PSub` varchar(50) NOT NULL,
  `UploadedPYQs` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questionpaper`
--

INSERT INTO `questionpaper` (`PId`, `PScheme`, `PDept`, `PSem`, `PSub`, `UploadedPYQs`) VALUES
(1, 2018, 'ISE', 5, 'AIML', 'uploads\\Aug-2022.pdf'),
(2, 2018, 'ISE', 5, 'DBMS', 'uploads\\dbmspyq-2018.pdf'),
(3, 2018, 'ISE', 5, 'DBMS', 'uploads\\Feb-2021.pdf'),
(4, 2018, 'ISE', 5, 'DBMS', 'uploads\\Jan-2019.pdf'),
(5, 2018, 'ISE', 5, 'AIML', 'uploads\\Feb-2023.pdf'),
(6, 2018, 'ISE', 5, 'AIML', 'uploads\\Jul-2023.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `StudentId` varchar(10) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `SEmail` varchar(50) NOT NULL,
  `SPassword` varchar(1000) NOT NULL,
  `Role` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`StudentId`, `Name`, `SEmail`, `SPassword`, `Role`) VALUES
('1RN21I056', 'HAREESH', '1rn21is056.hareesh@rnsit.ac.in', 'hareesh@', 'Student'),
('1RN21IS013', 'Akshatha', '1rn21is013.akshatha@rnsit.ac.in', 'akshatha@', 'Student'),
('1RN21IS018', 'Ananya.R', '1rn21is018.ananya@rnsit.ac.in', 'ananya@', 'Student'),
('1RN21IS022', 'Apporva.M', '1rn21is022.apporva@rnsit.ac.in', 'zpporva@', 'Student'),
('1RN21IS023', 'Aprajita', '1rn21is023.aprajita@rnsit.ac.in', 'aprajita@', 'Student'),
('1RN21IS035', 'C.V.Vidyashri', '1rn21is035.vidyashri@rnsit.ac.in', 'vidyashri@', 'Student'),
('1RN21IS045', 'Druthi.S', '1rn21is045.druthi@rnsit.ac.in', 'druthi@', 'Student'),
('1RN21IS046', 'Disha', '1rn21is046.disha@rnsit.ac.in', 'disha@', 'Student'),
('1RN21IS047', 'Eshitha', '1rn21is047.eshitha@rnsit.ac.in', 'eshitha@', 'Student'),
('1RN21IS048', 'G.Harika', '1rn21is048.gharika@rnsit.ac.in', 'harika@', 'Student'),
('1RN21IS050', 'Ghanavi', '1rn21is050.ghanavi@rnsit.ac.in', 'ghanavi@', 'Student'),
('1RN21IS053', 'Gowri', '1rn21is053.gowri@rnsit.ac.in', 'gowri@', 'Student');

--
-- Triggers `student`
--
DELIMITER $$
CREATE TRIGGER `StudentRecordDelete` BEFORE DELETE ON `student` FOR EACH ROW INSERT INTO triggers VALUES(null,OLD.StudentId,OLD.Name,OLD.SEmail,'STUDENT RECORD DELETED',Now())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `studentinsertion` AFTER INSERT ON `student` FOR EACH ROW INSERT INTO triggers VALUES(null,NEW.StudentId,NEW.Name,NEW.SEmail,'STUDENT INSERTED',Now())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `studentrecordupdated` AFTER UPDATE ON `student` FOR EACH ROW INSERT INTO triggers VALUES(null,NEW.StudentId,NEW.Name,NEW.SEmail,'STUDENT RECORD UPDATED',Now())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `studymaterial`
--

CREATE TABLE `studymaterial` (
  `MId` int(10) NOT NULL,
  `MScheme` int(4) NOT NULL,
  `MDept` varchar(50) NOT NULL,
  `MSem` int(2) NOT NULL,
  `MSub` varchar(50) NOT NULL,
  `Module` int(10) NOT NULL,
  `Material` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `studymaterial`
--

INSERT INTO `studymaterial` (`MId`, `MScheme`, `MDept`, `MSem`, `MSub`, `Module`, `Material`) VALUES
(1, 2021, 'ISE', 5, 'DBMS', 1, 'uploads\\1. 21CS53 DBMS-Module 1-2023-24.pdf'),
(2, 2021, 'ISE', 5, 'DBMS', 2, 'uploads\\2. 21CS53 DBMS-Module 2-2023-24.pdf'),
(3, 2021, 'ISE', 5, 'AIML', 2, 'uploads\\AIML Module 2-part 2.pdf'),
(4, 2021, 'ISE', 5, 'AIML', 3, 'uploads\\Module 3.pdf'),
(5, 2021, 'ISE', 5, 'ATCD', 1, 'uploads\\ATCD - 21CS51 - M1.pdf'),
(6, 2021, 'ISE', 5, 'ATCD', 3, 'uploads\\ATCD - 21CS51 - M3  New.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `triggers`
--

CREATE TABLE `triggers` (
  `tid` int(11) NOT NULL,
  `StudentId` varchar(10) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `SEmail` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `triggers`
--

INSERT INTO `triggers` (`tid`, `StudentId`, `Name`, `SEmail`, `action`, `timestamp`) VALUES
(33, '1RN21IS035', 'C.V.Vidyashri', '1rn21is035.vidyashri@gamil.com', 'STUDENT INSERTED', '2024-02-21 21:21:51'),
(34, '1RN21IS048', 'G.Harika', '1rn21is048.gharika@gamil.com', 'STUDENT INSERTED', '2024-02-21 21:22:25'),
(35, '1RN21IS022', 'Apporva.M', '1rn21is022.apporva@gamil.com', 'STUDENT INSERTED', '2024-02-21 21:22:57'),
(36, '1RN21IS023', 'Aprajita', '1rn21is023.aprajita@gamil.com', 'STUDENT INSERTED', '2024-02-21 21:23:31'),
(37, '1RN21IS047', 'Eshitha', '1rn21is047.eshitha@gmail.com', 'STUDENT INSERTED', '2024-02-21 21:24:44'),
(38, '1RN21IS045', 'Druthi.S', '1rn21is045.druthi@rnsit.ac.in', 'STUDENT INSERTED', '2024-02-21 21:25:38'),
(39, '1RN21IS046', 'Disha', '1rn21is046.disha@rnsit.ac.in', 'STUDENT INSERTED', '2024-02-21 21:26:00'),
(40, '1RN21IS050', 'Ghanavi', '1rn21is050.ghanavi@rnsit.ac.in', 'STUDENT INSERTED', '2024-02-21 21:26:27'),
(41, '1RN21IS053', 'Gowri', '1rn21is053.gowri@rnsit.ac.in', 'STUDENT INSERTED', '2024-02-21 21:26:49'),
(42, '1RN21IS018', 'Ananya.R', '1rn21is018.ananya@rnsit.ac.in', 'STUDENT INSERTED', '2024-02-21 21:27:15'),
(43, '1RN21IS013', 'Akshatha', '1rn21is013.akshatha@rnsit.ac.in', 'STUDENT INSERTED', '2024-02-21 21:27:49'),
(44, '1RN21IS022', 'Apporva.M', '1rn21is022.apporva@rnsit.ac.in', 'STUDENT RECORD UPDATED', '2024-02-21 21:33:06'),
(45, '1RN21IS023', 'Aprajita', '1rn21is023.aprajita@rnsit.ac.in', 'STUDENT RECORD UPDATED', '2024-02-21 21:33:21'),
(46, '1RN21IS035', 'C.V.Vidyashri', '1rn21is035.vidyashri@rnsit.ac.in', 'STUDENT RECORD UPDATED', '2024-02-21 21:33:38'),
(47, '1RN21IS047', 'Eshitha', '1rn21is047.eshitha@rnsit.ac.in', 'STUDENT RECORD UPDATED', '2024-02-21 21:33:54'),
(48, '1RN21IS048', 'G.Harika', '1rn21is048.gharika@rnsit.ac.in', 'STUDENT RECORD UPDATED', '2024-02-21 21:34:03'),
(49, '1RN21I056', 'HAREESH', '1rn21is056.hareesh@rnsit.ac.in', 'STUDENT INSERTED', '2024-03-05 09:26:25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`AdminId`),
  ADD UNIQUE KEY `email` (`Email`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`FId`),
  ADD KEY `FK_StudentId` (`StudentId`);

--
-- Indexes for table `questionpaper`
--
ALTER TABLE `questionpaper`
  ADD PRIMARY KEY (`PId`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`StudentId`),
  ADD UNIQUE KEY `Semail` (`SEmail`);

--
-- Indexes for table `studymaterial`
--
ALTER TABLE `studymaterial`
  ADD PRIMARY KEY (`MId`);

--
-- Indexes for table `triggers`
--
ALTER TABLE `triggers`
  ADD PRIMARY KEY (`tid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `AdminId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `FId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `questionpaper`
--
ALTER TABLE `questionpaper`
  MODIFY `PId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `studymaterial`
--
ALTER TABLE `studymaterial`
  MODIFY `MId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `triggers`
--
ALTER TABLE `triggers`
  MODIFY `tid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `FK_StudentId` FOREIGN KEY (`StudentId`) REFERENCES `student` (`StudentId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
