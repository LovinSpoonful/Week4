-- SQL WEEK 4 Assignment
-- Rob Hodde  11/19/2015

-- Please create an organization chart for a real or imagined organization, implemented in a single SQL table. Your
-- deliverable script should:
-- 1. Create the table. Each row should minimally include the person’s name, the person’s supervisor, and the
-- person’s job title. Using ID columns is encouraged.
-- 2. Populate the table with a few sample rows.
-- 3. Provide a single SELECT statement that displays the information in the table, showing who reports to whom.
-- You might have an organization with a depth of three levels. For example: there could be a CEO, two vice presidents
-- that report to the CEO, and two managers that report to each of the two vice presidents. An assistant might also report
-- directly to the CEO. Your table should be designed so that the reporting hierarchy could go to any practical depth.

-- Note: sourced from http://inflooenz.com/?artist=bob+dylan&submit=Search

DROP DATABASE IF EXISTS OrgChart;
CREATE DATABASE OrgChart;


CREATE TABLE `OrgChart`.`tbl_User` (
  `UserID` INT NOT NULL,
  `Name` VARCHAR(100) NOT NULL,
  `LevelNo` INT NOT NULL,
  `ParentID` INT NULL
 );


INSERT INTO OrgChart.tbl_User (UserID, Name, LevelNo, ParentID)
VALUES
(0, 'God', 0, -1),
(1, 'Bob Dylan', 1, 0),
(2, 'Bruce Springsteen', 2, 1),
(3, 'Tom Petty',2,1),
(4, 'Jimi Hendrix',2,1),
(5, 'The Band',2,1),
(6, 'Neil Young',2,1),
(7, 'Bob Seger',3,2),
(8, 'John Mellancamp',3,2),
(9, 'Pearl Jam',3,6),
(10,'The Black Crowes',3,3),
(11,'Lenny Kravitz',3,4),
(12,'The Lovin Spoonful',3,4);

SELECT u2.Name Supervisor, uu.Name Employee 
FROM OrgChart.tbl_user uu
LEFT JOIN OrgChart.tbl_User u2
ON uu.ParentID = u2.UserID
WHERE u2.Name IS NOT NULL






