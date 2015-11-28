-- SQL Bridge Fall 2015
-- Final Project
-- Rob Hodde
-- 11/27/2015

-- All data sourced from http://eve-marketdata.com/developers/mysql.php
-- I first used the scripts available from the site to build a local Eve database, then wrote queries
-- against that database to provide the summary data included in this project.

-- Eve is a massively multiplayer online role playing game (MMORPG or MMO) with millions of players around the world.
-- It has the most sophisticated market economy of any MMO spanning many regions of the universe.
-- We will look at buying and selling activity of Ice Products across the regions.

-- I have restructured the project somewhat, in some cases adding more layers of information,
-- and in others, consolidating multiple questions into single queries where I thought it elegant or more compact to do so. 
-- I've placed references to the questions like (1) below, to make it easier to see where and how I addressed each challenge.



-- (1)

-- Create database for Eve materials trading
DROP SCHEMA IF EXISTS eve2;
CREATE SCHEMA eve2;
USE eve2;



--  (2) 

-- Create and populate the market groups table.
-- The following is a tiny sample of the more than 2000 market groups on Eve, from the Materials group.
DROP TABLE IF EXISTS `eve2`.`tbl_marketgroup`;

CREATE TABLE `eve2`.`tbl_marketgroup` (
`marketgroup_id`   int(11) NOT NULL,
`marketgroup_name` char(100) NULL,
`description`      char(255) NULL,
PRIMARY KEY (`marketgroup_id`));

INSERT INTO `eve2`.`tbl_marketgroup` VALUES
('759', 'Alloys & Compounds', 'Various compounds composed of asteroid ores.'),
('942', 'Salvaged Materials', 'Materials salvaged from destroyed starships.'),
('1031', 'Raw Materials', 'The building blocks of New Eden.'),
('1032', 'Gas Clouds Materials', 'Voluminous clouds of various gases, found in space, that can be extracted and used in the manufacturing of biochemical boosters.'),
('1033', 'Ice Products', 'Ice isotopes harvested from ice asteroids.'),
('1034', 'Reaction Materials', 'The various types of raw materials harvested from the moons of New Eden.'),
('1096', 'Rogue Drone Components', 'Salvaged bits and pieces from destroyed Rogue Drones, can be integrated with current drone technology for improved performance.'),
('1144', 'Fullerenes & Polymers', 'Fullerene and polymer materials.'),
('1148', 'Ancient Salvaged Materials', 'Despite being very old, these materials hold unimaginable technological secrets.'),
('1332', 'Planetary Materials', 'Materials sourced from planets'),
('1413', 'Fuel Blocks', 'Assembled blocks of fuel for starbases and other structures.'),
('1857', 'Minerals', 'Minerals harvested from refined asteroid ore.'),
('1861', 'Salvage Materials', ''),
('1897', 'Faction Materials', '');

-- Create and populate the items (things people buy and sell) table.
-- This is a tiny subset of the 8000 + items traded on Eve, from the Minerals and Ice Products market groups (part of Materials).
DROP TABLE IF EXISTS `eve2`.`tbl_item`;

CREATE TABLE `eve2`.`tbl_item` (
`item_id`         int(11) NOT NULL,
`marketgroup_id`  int(11) NOT NULL,
`item_name`       char(100) NULL,
`description`     char(255) NULL,
`JITA_price_sell` decimal(9,2) NULL,
`JITA_price_buy`  decimal(9,2) NULL, 
PRIMARY KEY (`item_id`));

INSERT INTO `eve2`.`tbl_item` VALUES
('16272', '1033', 'Heavy Water', 'Dideuterium oxide. Water with significant nuclear properties which make it extremely effective as a neutron moderator in various types of power reactors. One of the materials required to keep Control ', '299.38', '255.32'),
('16273', '1033', 'Liquid Ozone', 'Liquid Ozone is used as a cleaning and disinfectant substance, and plays a vital role in ensuring the smooth day-to-day operation of a starbase. One of the materials required to keep Control Towers on', '502.61', '480.33'),
('16274', '1033', 'Helium Isotopes', 'The Helium-3 isotope is extremely sought-after for use in fusion processes, and also has various applications in the fields of cryogenics and machine cooling.  One of the materials required to keep Am', '714.53', '696.15'),
('16275', '1033', 'Strontium Clathrates', 'An unstable compound of strontium molecules encased in the crystal structure of water. When fed to a Control Tower\'s force field generator, these clathrates bond with the molecules already in place in', '678.96', '596.32'),
('17887', '1033', 'Oxygen Isotopes', 'Stable O-16 isotopes, crucial for maintenance of Gallente Control Towers.\r\n\r\nMay be obtained by reprocessing the following ice ores:\r\n\r\n<color=\'0xFF33FFFF\'>1.0</color> security status solar system or ', '889.96', '740.80'),
('17888', '1033', 'Nitrogen Isotopes', 'Nitrogen-14 is a stable, non-radioactive isotope, crucial for maintenance of Caldari Control Towers.\r\n\r\nMay be obtained by reprocessing the following ice ores:\r\n\r\n<color=\'0xFF33FFFF\'>1.0</color> secur', '835.85', '826.22'),
('17889', '1033', 'Hydrogen Isotopes', 'Hydrogen-2, otherwise known as Deuterium. Due to its unique properties the hydrogen-2 isotope is able to very effectively fuse with other atoms. Useful in a variety of nuclear scenarios, and an essent', '870.96', '689.48'),
('34', '1857', 'Tritanium', 'The main building block in space structures. A very hard, yet bendable metal. Cannot be used in human habitats due to its instability at atmospheric temperatures. Very common throughout the universe.\r', '6.43', '6.30'),
('35', '1857', 'Pyerite', 'A soft crystal-like mineral with a very distinguishing orange glow as if on fire. Used as conduit and in the bio-chemical industry. Commonly found in many asteroid-ore types.\r\n\r\nMay be obtained by rep', '11.41', '10.93'),
('36', '1857', 'Mexallon', 'Very flexible metallic mineral, dull to bright silvery green in color. Can be mixed with tritanium to make extremely hard alloys or it can be used by itself for various purposes. Fairly common in most', '61.90', '60.67'),
('37', '1857', 'Isogen', 'Light-bluish crystal, formed by intense pressure deep within large asteroids and moons. Used in electronic and weapon manufacturing. Only found in abundance in a few areas.\r\n\r\nMay be obtained by repro', '117.14', '113.54'),
('38', '1857', 'Nocxium', 'A highly volatile mineral only formed during supernovas, thus severely limiting the extent of its distribution. Vital ingredient in capsule production, making it very coveted.\r\n\r\nMay be obtained by re', '511.49', '487.35'),
('39', '1857', 'Zydrine', 'Only found in huge geodes; rocks on the outside with crystal-like quartz on the inside. The rarest and most precious of these geodes are those that contain the dark green zydrine within. Very rare and', '1038.94', '1010.38'),
('40', '1857', 'Megacyte', 'An extremely rare mineral found in comets and very occasionally in asteroids that have traveled through gas clouds. Has unique explosive traits that make it very valuable in the armaments industry.\r\n\r', '1288.39', '1244.00'),
('11399', '1857', 'Morphite', 'Morphite is a highly unorthodox mineral that can only be found in the hard-to-get Mercoxit ore. It is hard to use Morphite as a basic building material, but when it is joined with existing structures ', '11940.56', '10916.16');



--  (3) 

-- DEMO: This query shows the relationship between Market Groups and individual Items that are traded on Eve.
SELECT m.marketgroup_name, m.description, i.item_name, i.description
FROM `eve2`.`tbl_Item` i INNER JOIN `eve2`.`tbl_marketgroup` m ON i.marketgroup_id = m.marketgroup_id
ORDER BY m.marketgroup_name, i.item_name;



--  (4)

-- Eve is broken up into a 64 regions, which are very large, like galaxies.
-- Each region can support millions of players.

-- Create and populate the region table
DROP TABLE IF EXISTS `eve2`.`tbl_region`;

CREATE TABLE `eve2`.`tbl_region` (
`region_id`   int(11) NOT NULL,
`region_name` char(100) NULL,
PRIMARY KEY (`region_id`));

 INSERT INTO `eve2`.`tbl_region` VALUES 
('10000001', 'Derelik'),
('10000002', 'The Forge'),
('10000003', 'Vale of the Silent'),
('10000005', 'Detorid'),
('10000006', 'Wicked Creek'),
('10000007', 'Cache'),
('10000008', 'Scalding Pass'),
('10000009', 'Insmother'),
('10000010', 'Tribute'),
('10000011', 'Great Wildlands'),
('10000012', 'Curse'),
('10000013', 'Malpais'),
('10000014', 'Catch'),
('10000015', 'Venal'),
('10000016', 'Lonetrek'),
('10000018', 'The Spire'),
('10000020', 'Tash-Murkon'),
('10000021', 'Outer Passage'),
('10000022', 'Stain'),
('10000023', 'Pure Blind'),
('10000025', 'Immensea'),
('10000027', 'Etherium Reach'),
('10000028', 'Molden Heath'),
('10000029', 'Geminate'),
('10000030', 'Heimatar'),
('10000031', 'Impass'),
('10000032', 'Sinq Laison'),
('10000033', 'The Citadel'),
('10000034', 'The Kalevala Expanse'),
('10000035', 'Deklein'),
('10000036', 'Devoid'),
('10000037', 'Everyshore'),
('10000038', 'The Bleak Lands'),
('10000039', 'Esoteria'),
('10000040', 'Oasa'),
('10000041', 'Syndicate'),
('10000042', 'Metropolis'),
('10000043', 'Domain'),
('10000044', 'Solitude'),
('10000045', 'Tenal'),
('10000046', 'Fade'),
('10000047', 'Providence'),
('10000048', 'Placid'),
('10000049', 'Khanid'),
('10000050', 'Querious'),
('10000051', 'Cloud Ring'),
('10000052', 'Kador'),
('10000053', 'Cobalt Edge'),
('10000054', 'Aridia'),
('10000055', 'Branch'),
('10000056', 'Feythabolis'),
('10000057', 'Outer Ring'),
('10000058', 'Fountain'),
('10000059', 'Paragon Soul'),
('10000060', 'Delve'),
('10000061', 'Tenerifis'),
('10000062', 'Omist'),
('10000063', 'Period Basis'),
('10000064', 'Essence'),
('10000065', 'Kor-Azor'),
('10000066', 'Perrigen Falls'),
('10000067', 'Genesis'),
('10000068', 'Verge Vendor'),
('10000069', 'Black Rise');




--  (6)  

-- The following is a summary of open bids (offers to buy) by region and item for Ice Products. 
-- (Note: to make this more challenging, and to avoid denormalization, the market group id is not duplicated in this table.)


DROP TABLE IF EXISTS `eve2`.`tbl_buy`;

CREATE TABLE `eve2`.`tbl_buy` (
`item_id`      int(11) NOT NULL,
`region_id`    int(11) NOT NULL,
`kunits_avail` int(11) NULL,
`avg_price`    decimal(9,2),
PRIMARY KEY (`item_id`,`region_id`));

INSERT INTO `eve2`.`tbl_buy` VALUES 
('16272', '10000051', '930', '15'),
('16272', '10000058', '7453', '21'),
('16272', '10000028', '2913', '35'),
('16272', '10000065', '13910', '41'),
('16272', '10000044', '13517', '41'),
('16272', '10000039', '6249', '49'),
('16272', '10000013', '101184', '70'),
('16272', '10000049', '19934', '74'),
('16272', '10000056', '2719', '80'),
('16272', '10000060', '100', '85'),
('16272', '10000052', '3874', '92'),
('16272', '10000034', '68', '100'),
('16272', '10000059', '759', '100'),
('16272', '10000064', '1474', '103'),
('16272', '10000014', '17772', '109'),
('16272', '10000016', '25097', '120'),
('16272', '10000001', '1580', '124'),
('16272', '10000021', '15508', '127'),
('16272', '10000046', '4449', '131'),
('16272', '10000033', '48164', '134'),
('16272', '10000010', '1499', '140'),
('16272', '10000018', '200', '140'),
('16272', '10000066', '359', '143'),
('16272', '10000055', '9107', '148'),
('16272', '10000027', '50', '151'),
('16272', '10000015', '800', '162'),
('16272', '10000030', '13674', '171'),
('16272', '10000003', '7056', '175'),
('16272', '10000006', '7430', '176'),
('16272', '10000068', '5644', '176'),
('16272', '10000043', '49878', '186'),
('16272', '10000040', '5684', '197'),
('16272', '10000002', '74691', '198'),
('16272', '10000050', '294', '200'),
('16272', '10000009', '1784', '210'),
('16272', '10000042', '21677', '224'),
('16272', '10000023', '506', '230'),
('16272', '10000045', '3781', '243'),
('16273', '10000025', '13461', '18'),
('16273', '10000013', '98905', '20'),
('16273', '10000051', '1982', '35'),
('16273', '10000008', '3180', '48'),
('16273', '10000057', '734', '52'),
('16273', '10000011', '2101', '54'),
('16273', '10000058', '6125', '78'),
('16273', '10000046', '10354', '83'),
('16273', '10000055', '6180', '83'),
('16273', '10000050', '12926', '83'),
('16273', '10000056', '342', '90'),
('16273', '10000021', '2487', '100'),
('16273', '10000061', '50', '100'),
('16273', '10000039', '4754', '102'),
('16273', '10000065', '5935', '108'),
('16273', '10000006', '6849', '140'),
('16273', '10000066', '1123', '150'),
('16273', '10000020', '6782', '157'),
('16273', '10000045', '5862', '159'),
('16273', '10000010', '2356', '163'),
('16273', '10000069', '1689', '170'),
('16273', '10000049', '11546', '171'),
('16273', '10000014', '7206', '172'),
('16273', '10000023', '4232', '175'),
('16273', '10000064', '2252', '178'),
('16273', '10000037', '2681', '188'),
('16273', '10000022', '3255', '190'),
('16273', '10000040', '185', '195'),
('16273', '10000060', '2982', '196'),
('16273', '10000003', '8658', '208'),
('16273', '10000035', '6361', '220'),
('16273', '10000052', '1769', '226'),
('16273', '10000054', '1974', '240'),
('16273', '10000016', '16449', '260'),
('16273', '10000015', '1389', '263'),
('16273', '10000033', '11127', '271'),
('16273', '10000012', '3337', '285'),
('16273', '10000047', '3857', '287'),
('16273', '10000067', '1062', '290'),
('16273', '10000001', '8281', '335'),
('16273', '10000028', '6035', '352'),
('16273', '10000043', '13834', '364'),
('16273', '10000042', '6991', '367'),
('16273', '10000030', '21271', '389'),
('16273', '10000002', '64203', '409'),
('16273', '10000032', '35897', '414'),
('16273', '10000068', '3066', '417'),
('16273', '10000027', '20', '567'),
('16274', '10000005', '350', '25'),
('16274', '10000027', '217', '25'),
('16274', '10000021', '325', '25'),
('16274', '10000051', '170', '25'),
('16274', '10000007', '350', '26'),
('16274', '10000057', '250', '26'),
('16274', '10000053', '2074', '55'),
('16274', '10000060', '4630', '58'),
('16274', '10000066', '196', '58'),
('16274', '10000040', '255', '100'),
('16274', '10000009', '1000', '100'),
('16274', '10000061', '2710', '102'),
('16274', '10000008', '1135', '119'),
('16274', '10000006', '6184', '150'),
('16274', '10000058', '1247', '167'),
('16274', '10000038', '30', '189'),
('16274', '10000045', '9698', '204'),
('16274', '10000003', '3537', '220'),
('16274', '10000062', '500', '280'),
('16274', '10000055', '1603', '301'),
('16274', '10000023', '968', '333'),
('16274', '10000010', '782', '333'),
('16274', '10000013', '2004', '334'),
('16274', '10000069', '1578', '335'),
('16274', '10000028', '2715', '354'),
('16274', '10000054', '7123', '363'),
('16274', '10000050', '918', '419'),
('16274', '10000035', '1200', '431'),
('16274', '10000064', '3926', '436'),
('16274', '10000049', '2410', '437'),
('16274', '10000015', '1260', '442'),
('16274', '10000012', '1270', '451'),
('16274', '10000036', '8243', '476'),
('16274', '10000022', '1339', '487'),
('16274', '10000030', '12984', '518'),
('16274', '10000065', '2366', '520'),
('16274', '10000016', '4761', '528'),
('16274', '10000014', '2008', '529'),
('16274', '10000020', '7787', '535'),
('16274', '10000001', '5185', '572'),
('16274', '10000043', '34470', '583'),
('16274', '10000068', '1248', '628'),
('16274', '10000002', '108006', '659'),
('16274', '10000063', '250', '800'),
('16275', '10000055', '754', '16'),
('16275', '10000058', '6227', '16'),
('16275', '10000012', '44', '25'),
('16275', '10000051', '478', '25'),
('16275', '10000013', '411', '35'),
('16275', '10000038', '957', '50'),
('16275', '10000050', '88', '61'),
('16275', '10000052', '1494', '62'),
('16275', '10000044', '4285', '65'),
('16275', '10000040', '959', '88'),
('16275', '10000034', '96', '100'),
('16275', '10000045', '100', '100'),
('16275', '10000069', '841', '100'),
('16275', '10000010', '1492', '108'),
('16275', '10000003', '1486', '125'),
('16275', '10000021', '1434', '160'),
('16275', '10000020', '1498', '174'),
('16275', '10000033', '3919', '180'),
('16275', '10000027', '10', '200'),
('16275', '10000008', '9', '200'),
('16275', '10000001', '591', '201'),
('16275', '10000064', '2240', '263'),
('16275', '10000067', '20156', '295'),
('16275', '10000023', '9212', '299'),
('16275', '10000037', '12180', '300'),
('16275', '10000028', '2399', '317'),
('16275', '10000006', '259', '331'),
('16275', '10000068', '186', '332'),
('16275', '10000022', '270', '357'),
('16275', '10000011', '12', '401'),
('16275', '10000043', '8598', '411'),
('16275', '10000030', '3623', '457'),
('16275', '10000032', '22437', '469'),
('16275', '10000002', '35939', '487'),
('16275', '10000060', '1', '666'),
('17887', '10000027', '320', '25'),
('17887', '10000029', '160', '25'),
('17887', '10000007', '340', '25'),
('17887', '10000005', '196', '26'),
('17887', '10000054', '5949', '32'),
('17887', '10000009', '994', '100'),
('17887', '10000060', '470', '101'),
('17887', '10000031', '181', '101'),
('17887', '10000061', '5197', '102'),
('17887', '10000008', '1647', '159'),
('17887', '10000058', '482', '169'),
('17887', '10000069', '2054', '302'),
('17887', '10000020', '1500', '308'),
('17887', '10000003', '2198', '315'),
('17887', '10000014', '2816', '321'),
('17887', '10000053', '3370', '354'),
('17887', '10000055', '1890', '355'),
('17887', '10000013', '1972', '370'),
('17887', '10000028', '5606', '375'),
('17887', '10000011', '188', '400'),
('17887', '10000021', '1567', '428'),
('17887', '10000044', '6386', '443'),
('17887', '10000068', '1979', '492'),
('17887', '10000065', '974', '501'),
('17887', '10000036', '1720', '502'),
('17887', '10000035', '1650', '517'),
('17887', '10000064', '4146', '525'),
('17887', '10000006', '1463', '526'),
('17887', '10000023', '1409', '544'),
('17887', '10000048', '1774', '553'),
('17887', '10000022', '1045', '564'),
('17887', '10000032', '25229', '572'),
('17887', '10000001', '1416', '584'),
('17887', '10000050', '627', '592'),
('17887', '10000012', '963', '613'),
('17887', '10000002', '121294', '657'),
('17887', '10000043', '17516', '659'),
('17887', '10000066', '1075', '744'),
('17888', '10000021', '350', '25'),
('17888', '10000027', '220', '25'),
('17888', '10000005', '279', '26'),
('17888', '10000051', '1150', '65'),
('17888', '10000034', '3000', '100'),
('17888', '10000009', '1000', '100'),
('17888', '10000061', '298', '100'),
('17888', '10000013', '1159', '200'),
('17888', '10000058', '1680', '221'),
('17888', '10000046', '1070', '247'),
('17888', '10000062', '797', '275'),
('17888', '10000006', '1149', '300'),
('17888', '10000028', '3985', '305'),
('17888', '10000039', '1113', '305'),
('17888', '10000060', '1768', '327'),
('17888', '10000001', '3517', '348'),
('17888', '10000015', '1885', '370'),
('17888', '10000069', '2779', '375'),
('17888', '10000008', '1826', '397'),
('17888', '10000014', '2247', '439'),
('17888', '10000068', '1154', '460'),
('17888', '10000055', '6244', '469'),
('17888', '10000050', '207', '490'),
('17888', '10000010', '2315', '506'),
('17888', '10000023', '2524', '546'),
('17888', '10000033', '23237', '549'),
('17888', '10000003', '4645', '568'),
('17888', '10000012', '3342', '569'),
('17888', '10000011', '321', '579'),
('17888', '10000020', '557', '585'),
('17888', '10000049', '487', '601'),
('17888', '10000052', '473', '603'),
('17888', '10000016', '10799', '653'),
('17888', '10000035', '4492', '687'),
('17888', '10000032', '7415', '710'),
('17888', '10000043', '9798', '716'),
('17888', '10000030', '9809', '719'),
('17888', '10000002', '87639', '756'),
('17888', '10000025', '212', '3950'),
('17889', '10000051', '350', '25'),
('17889', '10000005', '340', '25'),
('17889', '10000046', '127', '25'),
('17889', '10000041', '143', '25'),
('17889', '10000027', '350', '25'),
('17889', '10000045', '250', '26'),
('17889', '10000013', '1135', '50'),
('17889', '10000053', '1961', '52'),
('17889', '10000066', '139', '52'),
('17889', '10000018', '631', '78'),
('17889', '10000061', '3069', '100'),
('17889', '10000029', '116', '101'),
('17889', '10000060', '2631', '113'),
('17889', '10000034', '2250', '113'),
('17889', '10000050', '319', '140'),
('17889', '10000058', '1260', '170'),
('17889', '10000007', '235', '218'),
('17889', '10000003', '1416', '220'),
('17889', '10000067', '1503', '241'),
('17889', '10000062', '208', '263'),
('17889', '10000010', '1134', '283'),
('17889', '10000069', '1524', '300'),
('17889', '10000064', '3534', '300'),
('17889', '10000015', '1241', '313'),
('17889', '10000014', '1577', '326'),
('17889', '10000023', '992', '333'),
('17889', '10000009', '1000', '400'),
('17889', '10000049', '418', '400'),
('17889', '10000020', '1318', '403'),
('17889', '10000028', '8954', '419'),
('17889', '10000006', '2493', '434'),
('17889', '10000052', '662', '456'),
('17889', '10000012', '2256', '467'),
('17889', '10000001', '1117', '474'),
('17889', '10000035', '1043', '476'),
('17889', '10000068', '407', '501'),
('17889', '10000055', '36', '501'),
('17889', '10000016', '4001', '503'),
('17889', '10000036', '725', '507'),
('17889', '10000022', '1188', '516'),
('17889', '10000030', '41157', '572'),
('17889', '10000033', '4082', '580'),
('17889', '10000032', '10548', '590'),
('17889', '10000042', '32483', '598'),
('17889', '10000008', '1210', '604'),
('17889', '10000043', '12684', '604'),
('17889', '10000002', '130628', '668');

-- Below is a summary of open offers (to sell) by region and item. 
-- Note: The Eve Market Data Relay separates the buy and sell open order details into two tables
-- but they really should be placed in one table, with a Buy/Sell code indicating the order type (Bid or Ask).
-- I'll do this in the junction table below.

DROP TABLE IF EXISTS `eve2`.`tbl_sell`;

CREATE TABLE `eve2`.`tbl_sell` (
`item_id`      int(11) NOT NULL,
`region_id`    int(11) NOT NULL,
`kunits_avail` int(11) NULL,
`avg_price`    decimal(9,2),
PRIMARY KEY (`item_id`,`region_id`));

INSERT INTO `eve2`.`tbl_sell` VALUES 
('16272', '10000015', '98', '149'),
('16272', '10000060', '12154', '153'),
('16272', '10000062', '285', '166'),
('16272', '10000066', '467', '172'),
('16272', '10000021', '7416', '190'),
('16272', '10000006', '0', '200'),
('16272', '10000061', '6809', '206'),
('16272', '10000018', '1704', '207'),
('16272', '10000053', '1229', '219'),
('16272', '10000005', '1243', '250'),
('16272', '10000069', '1156', '250'),
('16272', '10000029', '2886', '275'),
('16272', '10000016', '242', '290'),
('16272', '10000020', '426', '324'),
('16272', '10000032', '6315', '330'),
('16272', '10000003', '469', '337'),
('16272', '10000002', '53591', '345'),
('16272', '10000001', '810', '353'),
('16272', '10000014', '634', '354'),
('16272', '10000035', '3256', '358'),
('16272', '10000043', '10197', '367'),
('16272', '10000054', '21223', '372'),
('16272', '10000042', '2502', '375'),
('16272', '10000041', '101', '386'),
('16272', '10000022', '398', '426'),
('16272', '10000036', '630', '450'),
('16272', '10000037', '15656', '466'),
('16272', '10000047', '1036', '480'),
('16272', '10000045', '2992', '523'),
('16272', '10000030', '4239', '571'),
('16272', '10000012', '65', '750'),
('16272', '10000011', '5', '800'),
('16273', '10000062', '3620', '250'),
('16273', '10000021', '31377', '263'),
('16273', '10000059', '2972', '266'),
('16273', '10000063', '5236', '275'),
('16273', '10000056', '3535', '275'),
('16273', '10000061', '12649', '305'),
('16273', '10000031', '3086', '324'),
('16273', '10000013', '7394', '352'),
('16273', '10000066', '16100', '383'),
('16273', '10000055', '47123', '385'),
('16273', '10000007', '11561', '387'),
('16273', '10000008', '6980', '405'),
('16273', '10000045', '4666', '406'),
('16273', '10000018', '5497', '408'),
('16273', '10000003', '5776', '452'),
('16273', '10000058', '37950', '468'),
('16273', '10000010', '2516', '475'),
('16273', '10000034', '1977', '477'),
('16273', '10000027', '1035', '479'),
('16273', '10000029', '6306', '505'),
('16273', '10000005', '2142', '522'),
('16273', '10000009', '12213', '524'),
('16273', '10000014', '12231', '546'),
('16273', '10000060', '8903', '546'),
('16273', '10000006', '5215', '549'),
('16273', '10000023', '11413', '574'),
('16273', '10000020', '1884', '628'),
('16273', '10000043', '14615', '636'),
('16273', '10000038', '1388', '667'),
('16273', '10000042', '8688', '673'),
('16273', '10000011', '750', '680'),
('16273', '10000057', '2652', '682'),
('16273', '10000002', '54856', '682'),
('16273', '10000069', '1893', '723'),
('16273', '10000064', '757', '734'),
('16273', '10000049', '3381', '738'),
('16273', '10000065', '834', '743'),
('16273', '10000032', '22163', '774'),
('16273', '10000012', '6684', '776'),
('16273', '10000041', '2768', '809'),
('16273', '10000048', '4971', '828'),
('16273', '10000036', '3292', '862'),
('16273', '10000067', '3092', '892'),
('16273', '10000030', '9622', '900'),
('16273', '10000068', '14', '900'),
('16273', '10000015', '1372', '917'),
('16273', '10000016', '2628', '930'),
('16273', '10000001', '2770', '932'),
('16273', '10000033', '2984', '961'),
('16273', '10000022', '3084', '997'),
('16273', '10000054', '10318', '1174'),
('16273', '10000044', '7428', '1267'),
('16274', '10000059', '609', '750'),
('16274', '10000052', '647', '763'),
('16274', '10000047', '5504', '788'),
('16274', '10000056', '659', '795'),
('16274', '10000043', '16059', '801'),
('16274', '10000046', '1300', '815'),
('16274', '10000002', '101313', '852'),
('16274', '10000069', '133', '852'),
('16274', '10000033', '1300', '866'),
('16274', '10000006', '3703', '867'),
('16274', '10000067', '8319', '884'),
('16274', '10000065', '2156', '886'),
('16274', '10000032', '8063', '899'),
('16274', '10000055', '150', '915'),
('16274', '10000041', '3888', '922'),
('16274', '10000037', '200', '925'),
('16274', '10000025', '1441', '936'),
('16274', '10000010', '1077', '960'),
('16274', '10000003', '5023', '977'),
('16274', '10000060', '10889', '981'),
('16274', '10000022', '4115', '997'),
('16274', '10000016', '4210', '1003'),
('16274', '10000011', '514', '1012'),
('16274', '10000054', '13824', '1025'),
('16274', '10000048', '4995', '1028'),
('16274', '10000023', '2320', '1065'),
('16274', '10000027', '786', '1066'),
('16274', '10000029', '1488', '1082'),
('16274', '10000042', '4522', '1095'),
('16274', '10000044', '1878', '1098'),
('16274', '10000034', '2433', '1136'),
('16274', '10000012', '6241', '1137'),
('16274', '10000009', '2022', '1146'),
('16274', '10000018', '409', '1187'),
('16274', '10000039', '1797', '1203'),
('16274', '10000030', '8867', '1207'),
('16274', '10000068', '718', '1307'),
('16274', '10000035', '9572', '1348'),
('16274', '10000058', '5149', '1880'),
('16274', '10000028', '1210', '2667'),
('16274', '10000001', '10693', '2799'),
('16275', '10000021', '639', '190'),
('16275', '10000053', '2564', '207'),
('16275', '10000055', '3240', '238'),
('16275', '10000066', '1557', '273'),
('16275', '10000034', '3194', '280'),
('16275', '10000061', '1008', '312'),
('16275', '10000062', '289', '326'),
('16275', '10000056', '686', '335'),
('16275', '10000047', '1302', '335'),
('16275', '10000023', '939', '344'),
('16275', '10000010', '624', '352'),
('16275', '10000014', '523', '412'),
('16275', '10000003', '1202', '413'),
('16275', '10000045', '145', '416'),
('16275', '10000065', '16', '425'),
('16275', '10000008', '371', '463'),
('16275', '10000060', '257', '528'),
('16275', '10000006', '669', '545'),
('16275', '10000058', '2037', '555'),
('16275', '10000009', '851', '567'),
('16275', '10000048', '419', '585'),
('16275', '10000033', '145', '599'),
('16275', '10000069', '428', '610'),
('16275', '10000016', '955', '611'),
('16275', '10000064', '422', '668'),
('16275', '10000054', '518', '668'),
('16275', '10000022', '199', '672'),
('16275', '10000002', '7250', '700'),
('16275', '10000043', '3044', '722'),
('16275', '10000049', '83', '740'),
('16275', '10000001', '158', '767'),
('16275', '10000030', '109', '771'),
('16275', '10000067', '117', '775'),
('16275', '10000042', '681', '779'),
('17887', '10000037', '1792', '766'),
('17887', '10000018', '113', '800'),
('17887', '10000068', '1018', '810'),
('17887', '10000041', '701', '850'),
('17887', '10000033', '3023', '854'),
('17887', '10000064', '5224', '857'),
('17887', '10000053', '859', '862'),
('17887', '10000003', '4664', '874'),
('17887', '10000010', '842', '875'),
('17887', '10000055', '3866', '884'),
('17887', '10000002', '83673', '884'),
('17887', '10000051', '2175', '910'),
('17887', '10000047', '4276', '911'),
('17887', '10000035', '5503', '912'),
('17887', '10000006', '2421', '914'),
('17887', '10000032', '13562', '914'),
('17887', '10000054', '2399', '916'),
('17887', '10000069', '88', '950'),
('17887', '10000009', '1988', '950'),
('17887', '10000067', '3872', '950'),
('17887', '10000042', '9084', '959'),
('17887', '10000052', '454', '1000'),
('17887', '10000046', '5657', '1005'),
('17887', '10000066', '467', '1061'),
('17887', '10000016', '5179', '1063'),
('17887', '10000043', '13246', '1081'),
('17887', '10000015', '1132', '1122'),
('17887', '10000040', '319', '1173'),
('17887', '10000049', '2388', '1181'),
('17887', '10000062', '110', '1200'),
('17887', '10000060', '2080', '1308'),
('17887', '10000030', '10533', '1319'),
('17887', '10000034', '1034', '1343'),
('17887', '10000038', '240', '1354'),
('17887', '10000012', '6350', '1374'),
('17887', '10000022', '734', '1405'),
('17887', '10000039', '1660', '1516'),
('17887', '10000008', '220', '1554'),
('17887', '10000057', '927', '1663'),
('17887', '10000058', '4742', '1721'),
('17887', '10000028', '1921', '2369'),
('17887', '10000001', '7002', '2644'),
('17888', '10000059', '1', '850'),
('17888', '10000002', '194021', '934'),
('17888', '10000023', '6769', '953'),
('17888', '10000069', '563', '962'),
('17888', '10000055', '2608', '966'),
('17888', '10000010', '4060', '974'),
('17888', '10000064', '11379', '976'),
('17888', '10000045', '2334', '982'),
('17888', '10000035', '10209', '988'),
('17888', '10000041', '1507', '991'),
('17888', '10000066', '71', '1000'),
('17888', '10000007', '126', '1000'),
('17888', '10000018', '282', '1005'),
('17888', '10000037', '239', '1039'),
('17888', '10000067', '1769', '1066'),
('17888', '10000003', '2703', '1069'),
('17888', '10000029', '1292', '1073'),
('17888', '10000047', '3994', '1078'),
('17888', '10000006', '2649', '1092'),
('17888', '10000043', '23000', '1098'),
('17888', '10000053', '113', '1100'),
('17888', '10000063', '206', '1100'),
('17888', '10000042', '6575', '1109'),
('17888', '10000022', '1888', '1112'),
('17888', '10000048', '1096', '1135'),
('17888', '10000036', '2894', '1146'),
('17888', '10000044', '2606', '1149'),
('17888', '10000054', '1437', '1221'),
('17888', '10000065', '3130', '1296'),
('17888', '10000060', '3215', '1379'),
('17888', '10000009', '473', '1381'),
('17888', '10000058', '3075', '1461'),
('17888', '10000014', '2355', '1705'),
('17889', '10000059', '1173', '700'),
('17889', '10000010', '501', '846'),
('17889', '10000043', '48844', '861'),
('17889', '10000002', '36356', '875'),
('17889', '10000035', '5366', '880'),
('17889', '10000055', '2691', '883'),
('17889', '10000061', '1435', '884'),
('17889', '10000047', '4885', '886'),
('17889', '10000005', '600', '905'),
('17889', '10000006', '872', '912'),
('17889', '10000003', '2266', '929'),
('17889', '10000048', '6635', '942'),
('17889', '10000009', '3408', '958'),
('17889', '10000042', '63854', '995'),
('17889', '10000027', '1364', '996'),
('17889', '10000063', '1147', '1000'),
('17889', '10000038', '200', '1006'),
('17889', '10000022', '3749', '1068'),
('17889', '10000040', '879', '1097'),
('17889', '10000057', '247', '1099'),
('17889', '10000065', '1737', '1143'),
('17889', '10000060', '3183', '1162'),
('17889', '10000044', '1553', '1163'),
('17889', '10000012', '4967', '1176'),
('17889', '10000011', '1274', '1182'),
('17889', '10000054', '802', '1216'),
('17889', '10000037', '262', '1261'),
('17889', '10000039', '1807', '1333'),
('17889', '10000028', '8745', '1674');




--  (5,7,8)

-- Now we will create a junction table, listing all regions that trade Ice Products.
DROP TABLE IF EXISTS `eve2`.`tbl_region_item`;

CREATE TABLE `eve2`.`tbl_region_item` (
`region_id`       int(11) NOT NULL,
`item_id`         int(11) NOT NULL,
`buy_sell_code`   char(1) NOT NULL, 
PRIMARY KEY (`region_id`,`item_id`, `buy_sell_code`));

-- NOTE: This statement allows us to forego specifying the database schema.  We will take advantage of this from now on, for brevity.
USE eve2;   

--  Place the summary buying data by region in the junction table:
INSERT INTO tbl_region_item
SELECT  b.region_id, i.item_id, 'b' AS buy_sell_code
FROM tbl_item i INNER JOIN tbl_buy b ON i.item_id = b.item_id	
GROUP BY b.region_id, i.Item_id;

--  Next place the summary selling data by region in the junction table:
INSERT INTO tbl_region_item
SELECT  b.region_id, i.item_id, 's' AS buy_sell_code
FROM tbl_item i INNER JOIN tbl_sell b ON i.item_id = b.item_id	
GROUP BY b.region_id, i.item_id;

-- Select how many distinct items each region buys and sells.
-- Note: For this exercise we've limited to only one market group (Ice Products) but we could easily include more, or all of them, 
--       using the same db structures and query.
SELECT r.region_name, m.marketgroup_name, 
       sum(CASE WHEN ri.buy_sell_code = 's' THEN 1 ELSE 0 END) Items_Region_Sells,
	   sum(CASE WHEN ri.buy_sell_code = 'b' THEN 1 ELSE 0 END) Items_Region_Buys
FROM tbl_Region r 
LEFT JOIN tbl_region_item ri ON r.region_id = ri.region_id
LEFT JOIN tbl_item i ON ri.item_id = i.item_id	
INNER JOIN tbl_marketgroup m ON i.marketgroup_id = m.marketgroup_id
GROUP BY r.region_Name, m.marketgroup_name;

-- Note that Querious is the only region that does not sell any Ice Products.



-- because this idiotic sql engine doesn't have cte's or rowNum, we have to create another table with the top 100 trading opportunities

DROP TABLE IF EXISTS `eve2`.`tbl_top_trades`;

CREATE TABLE `eve2`.`tbl_top_trades` (
`trade_rank`        int(11) NOT NULL,
`item_id`           int(11) NULL,
`buy_region_id`     int(11) NULL,
`buy_kunits_avail`  int(11) NULL,
`buy_avg_price`     decimal(9,2),
`sell_region_id`    int(11) NULL,
`sell_kunits_avail` int(11) NULL,
`sell_avg_price`    decimal(9,2),
`unit_margin`       decimal(9,2),
PRIMARY KEY (`trade_rank`));


INSERT INTO tbl_top_trades

SELECT @r := @r+1 trade_rank, z.* from(

SELECT i.item_id, r.region_id buy_region_id, b.kunits_avail buy_kunits_avail, b.avg_price buy_avg_price, 
       r2.region_id sell_region_id, s.kunits_avail sell_kunits_avail, s.avg_price sell_avg_price, (b.avg_price - s.avg_price) unit_margin

FROM tbl_region_item ri
INNER JOIN tbl_Region r ON r.region_id = ri.region_id
INNER JOIN tbl_Item i ON i.item_id = ri.item_id
INNER JOIN tbl_buy b ON b.region_id = ri.region_id AND b.item_id = ri.item_id

INNER JOIN tbl_region_item ri2 ON ri2.item_id = ri.item_id 
INNER JOIN tbl_region r2 ON r2.region_id = ri2.region_id
INNER JOIN tbl_sell s ON s.region_id = ri2.region_id AND s.item_id = ri2.item_id

WHERE ri.buy_sell_code = 'b' AND ri2.buy_sell_code = 's' AND ri.region_id <> ri2.region_id
AND s.kunits_avail > 100 AND b.kunits_avail > 100
ORDER BY (s.avg_price - b.avg_price) 
limit 100

)z, (select @r:=0)y;














/*
--   (9)  Add foreign keys where appropriate.
   
ALTER TABLE tbl_item
ADD FOREIGN KEY fk_marketgroup(marketgroup_id)
REFERENCES tbl_marketgroup(marketgroup_id)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE tbl_buy
ADD FOREIGN KEY fk_item(item_id)
REFERENCES tbl_item(item_id)
ON DELETE NO ACTION
ON UPDATE CASCADE;
   
ALTER TABLE tbl_buy
ADD FOREIGN KEY fk_region(region_id)
REFERENCES tbl_region(region_id)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE tbl_sell
ADD FOREIGN KEY fk_item(item_id)
REFERENCES tbl_item(item_id)
ON DELETE NO ACTION
ON UPDATE CASCADE;
   
ALTER TABLE tbl_sell
ADD FOREIGN KEY fk_region(region_id)
REFERENCES tbl_region(region_id)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE tbl_region_item
ADD FOREIGN KEY fk_region(region_id)
REFERENCES tbl_region(region_id)
ON DELETE NO ACTION
ON UPDATE CASCADE;

ALTER TABLE tbl_region_item
ADD FOREIGN KEY fk_item(item_id)
REFERENCES tbl_item(item_id)
ON DELETE NO ACTION
ON UPDATE CASCADE;
   
*/
