-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 30 Mar 2022 pada 15.07
-- Versi server: 10.4.20-MariaDB
-- Versi PHP: 7.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `great`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `actor`
--

CREATE TABLE `actor` (
  `ID` int(11) NOT NULL,
  `name` varchar(25) CHARACTER SET latin1 NOT NULL DEFAULT '-',
  `skin` int(11) NOT NULL DEFAULT 0,
  `anim` int(11) NOT NULL DEFAULT 0,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `posr` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `world` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `atms`
--

CREATE TABLE `atms` (
  `id` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `posrx` float NOT NULL,
  `posry` float NOT NULL,
  `posrz` float NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `world` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `atms`
--

INSERT INTO `atms` (`id`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`, `interior`, `world`) VALUES
(0, 2248.51, -1759.95, 1014.38, 0, 0, -176.5, 1, 0),
(1, 1491.64, -1011.53, 26.5137, 0, 0, -86.7, 0, 0),
(2, 1432.35, -1012, 26.4837, 0, 0, 88.7, 0, 0),
(3, 1172.09, -1319.17, 14.9891, 0, 0, 89, 0, 0),
(5, 1758.83, -1750.74, 13.235, 0, 0, 0, 0, 0),
(6, 391.069, -1805.93, 7.53812, 0, 0, 180, 0, 0),
(7, -83.2758, -1183.58, 1.42701, 0, 0, -20.3, 0, 0),
(4, 1833.23, -1850.19, 13.1897, 0, 0, -90.8, 0, 0),
(13, -1980.64, 134.372, 27.3275, 0, 0, -90.8, 0, 0),
(14, 1382.74, 262.982, 19.5669, 0, 0, 0, 0, 0),
(16, 1498.52, -1749.88, 15.0725, 0, 0, 179.9, 0, 0),
(12, -2160.13, -2458.91, 30.2628, 0, 0, -38.6, 0, 0),
(8, 1553.84, -1663.48, 13.2122, 0, 0, -90.1, 0, 0),
(11, 269.915, -202.243, 1.22812, 0, 0, 0, 0, 0),
(9, 1235.75, 209.285, 19.1947, 0, 0, -22.1, 0, 0),
(20, 690.882, -576.502, 15.9659, 0, 0, -89.0999, 0, 0),
(10, 565.791, -1293.96, 16.8582, 0, 0, -178.2, 0, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `banneds`
--

CREATE TABLE `banneds` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(24) DEFAULT 'None',
  `ip` varchar(24) DEFAULT 'None',
  `longip` int(11) DEFAULT 0,
  `ban_expire` bigint(20) DEFAULT 0,
  `ban_date` bigint(20) DEFAULT 0,
  `last_activity_timestamp` bigint(20) DEFAULT 0,
  `admin` varchar(40) DEFAULT 'Server',
  `reason` varchar(128) DEFAULT 'None'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `bisnis`
--

CREATE TABLE `bisnis` (
  `ID` int(11) NOT NULL,
  `owner` varchar(40) NOT NULL DEFAULT '-',
  `ownerid` int(11) NOT NULL,
  `name` varchar(40) NOT NULL DEFAULT 'Bisnis',
  `price` int(11) NOT NULL DEFAULT 500000,
  `type` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `prod` int(11) NOT NULL DEFAULT 50,
  `bprice0` int(11) NOT NULL DEFAULT 500,
  `bprice1` int(11) NOT NULL DEFAULT 500,
  `bprice2` int(11) NOT NULL DEFAULT 500,
  `bprice3` int(11) NOT NULL DEFAULT 500,
  `bprice4` int(11) NOT NULL DEFAULT 500,
  `bprice5` int(11) NOT NULL DEFAULT 500,
  `bprice6` int(11) NOT NULL DEFAULT 500,
  `bprice7` int(11) NOT NULL DEFAULT 500,
  `bprice8` int(11) NOT NULL DEFAULT 500,
  `bprice9` int(11) NOT NULL DEFAULT 500,
  `bint` int(11) NOT NULL DEFAULT 0,
  `extposx` float NOT NULL DEFAULT 0,
  `extposy` float NOT NULL DEFAULT 0,
  `extposz` float NOT NULL DEFAULT 0,
  `extposa` float NOT NULL DEFAULT 0,
  `intposx` float NOT NULL DEFAULT 0,
  `intposy` float NOT NULL DEFAULT 0,
  `intposz` float NOT NULL DEFAULT 0,
  `intposa` float NOT NULL DEFAULT 0,
  `pointx` float DEFAULT 0,
  `pointy` float DEFAULT 0,
  `pointz` float DEFAULT 0,
  `visit` bigint(20) NOT NULL DEFAULT 0,
  `restock` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `contacts`
--

CREATE TABLE `contacts` (
  `ID` int(11) DEFAULT 0,
  `contactID` int(11) NOT NULL,
  `contactName` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `contactNumber` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `doors`
--

CREATE TABLE `doors` (
  `ID` int(11) NOT NULL,
  `name` varchar(50) DEFAULT 'None',
  `password` varchar(50) DEFAULT '',
  `icon` int(11) DEFAULT 19130,
  `mapicon` tinyint(4) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 0,
  `admin` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT 0,
  `faction` int(11) NOT NULL DEFAULT 0,
  `family` int(11) NOT NULL DEFAULT -1,
  `garage` tinyint(4) NOT NULL DEFAULT 0,
  `custom` int(11) NOT NULL DEFAULT 0,
  `extvw` int(11) DEFAULT 0,
  `extint` int(11) DEFAULT 0,
  `extposx` float DEFAULT 0,
  `extposy` float DEFAULT 0,
  `extposz` float DEFAULT 0,
  `extposa` float DEFAULT 0,
  `intvw` int(11) DEFAULT 0,
  `intint` int(11) NOT NULL DEFAULT 0,
  `intposx` float DEFAULT 0,
  `intposy` float DEFAULT 0,
  `intposz` float DEFAULT 0,
  `intposa` float DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `doors`
--

INSERT INTO `doors` (`ID`, `name`, `password`, `icon`, `mapicon`, `locked`, `admin`, `vip`, `faction`, `family`, `garage`, `custom`, `extvw`, `extint`, `extposx`, `extposy`, `extposz`, `extposa`, `intvw`, `intint`, `intposx`, `intposy`, `intposz`, `intposa`) VALUES
(0, 'San Andreas Police Departement', '', 19130, 30, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1555.3, -1675.69, 16.1953, 87.1144, 5, 5, 101.813, 1073.54, -48.9141, 173.595),
(1, '[ Heli Pad ]', '', 19130, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1565.02, -1666.76, 28.3956, 3.67237, 5, 5, 115.088, 1064.61, -48.9141, 90.1024),
(2, '[ Basement ]', '', 19130, 0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1568.62, -1689.98, 6.21875, 3.82408, 5, 5, 86.2733, 1063.16, -48.9141, 354.993),
(3, 'City Hall', '', 19130, 12, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1481.09, -1772.31, 18.7958, 179.409, 0, 5, -2063.23, 2659.37, 1498.78, 358.826),
(4, 'San Andreas Goverment Service', '', 19130, 0, 0, 0, 0, 2, -1, 0, 1, 0, 0, 1485.14, -1824.97, 13.5469, 183.735, 0, 5, -2064.97, 2709.98, 1500.98, 186.444),
(5, 'San Andreas Medical Departement', '', 19130, 0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 2034.35, -1401.86, 17.2965, 182.651, 0, 1, -2035.83, -58.028, 1060.99, 273.832),
(6, 'San Andreas Medical Departement', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 1, -2007.88, -73.2096, 1060.99, 6.41084, 0, 0, 0, 0, 0, 0),
(7, 'San Andreas Medical Departement', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 1, -2013.29, -73.1903, 1060.99, 2.65063, 0, 0, 0, 0, 0, 0),
(8, 'ASGH Medical Departement', '', 19130, 22, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1172.08, -1325.34, 15.4074, 93.035, 5, 5, -1772.38, -2019.09, 1500.79, 1.91612),
(9, 'ASGH Medical Departement', '', 19130, 0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1144.88, -1324.18, 13.5853, 78.0049, 5, 5, -1762.8, -1995.84, 1500.79, 187.654),
(10, 'ASGH Medical Departement', '', 19130, 0, 0, 0, 0, 3, -1, 0, 1, 0, 0, 1163.41, -1329.97, 31.4847, 12.2057, 5, 5, -1768.33, -1992.17, 1500.79, 101.174),
(11, 'San Andreas News Agency', '', 19130, 19, 0, 0, 0, 0, -1, 0, 1, 0, 0, 649.092, -1360.59, 14.0034, 96.0664, 5, 5, -192.46, 1345.33, 1500.98, 172.375),
(12, 'San Andreas News Agency Studio', '', 19130, 0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 740.15, -1351.26, 14.7142, 265.1, 5, 5, -204.038, 1314.5, 1500.98, 358.955),
(13, 'Bank Los Santos', '', 19130, 52, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1467.28, -1009.92, 26.8438, 356.753, 5, 5, -2693.79, 796.65, 1500.97, 268.851),
(14, 'Taxi Longue', '', 19130, 0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1752.63, -1894.08, 13.5574, 276.873, 0, 1, -2158.5, 642.905, 1052.38, 184.752),
(15, 'VIP Longue', '', 19130, 0, 0, 0, 1, 0, -1, 0, 1, 0, 0, 1797.65, -1578.89, 14.0861, 280.855, 0, 1, -4107.23, 906.906, 3.10072, 176.818),
(16, 'SANEWS', '', 19130, 0, 0, 0, 0, 4, -1, 0, 0, 0, 1, 2473.41, 2278.42, 91.6868, 178.715, 5, 5, -212.877, 1310.36, 1507.66, 272.933),
(17, 'SANews Base', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 5, 5, -212.263, 1326.9, 1500.99, 274.5, 0, 1, 2467.58, 2253.87, 91.6868, 89.1242),
(19, 'Alhambra', '', 19130, 48, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1837.03, -1682.21, 13.323, 87.4758, 0, 3, -2636.87, 1402.56, 906.461, 12.1067),
(20, 'VIP Car Garage', '', 19130, 0, 0, 0, 1, 0, -1, 1, 1, 0, 0, 1827.26, -1538.06, 13.5469, 165.884, 0, 0, 1818.76, -1537.02, 13.3813, 84.7065),
(21, 'VIP Bike Garage', '', 19130, 0, 0, 0, 1, 0, -1, 1, 1, 0, 0, 1754.34, -1594.77, 13.537, 79.0899, 0, 0, 1753.36, -1587.71, 13.3052, 357.622),
(22, 'Pengadilan San Andreas', '', 19130, 0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 1411.69, -1699.7, 13.5395, 56.7037, 0, 1, 1356.01, 717.951, -15.7573, 260.304),
(23, 'Willowfield Gym', '', 19130, 54, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2493.03, -1958.55, 13.5827, 3.07504, 0, 6, 774.372, -50.2732, 1000.59, 2.59314),
(24, 'SAN TOWER', '', 19130, 0, 0, 1, 0, 0, -1, 0, 1, 0, 0, 1415.48, -1300.22, 13.5449, 0.765661, 0, 0, 1548.83, -1363.87, 326.218, 12.036),
(25, 'Newbie School [ OOZ ZONE ]', '', 19130, 36, 1, 0, 0, 0, -1, 0, 0, 0, 0, 1286.6, -1329.32, 13.554, 262.649, 0, 1, 2177.65, -1010.05, 1021.69, 178.971),
(26, 'Production (Perbaikan)', '', 19130, 0, 1, 0, 0, 0, -1, 0, 0, 0, 0, 694.907, -500.133, 16.3359, 178.709, 0, 1, 770.935, -1108, -43.26, 179.937),
(27, 'San Fierro Police Department', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1605.76, 710.886, 13.8672, 179.148, 1, 10, 246.593, 107.298, 1003.22, 2.36836),
(28, 'San Fierro Police Department ( Garage )', '', 19130, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0, -1606.13, 672.063, -4.90625, 167.803, 1, 10, 227.231, 117.499, 999.029, 265.716),
(29, 'Police Departement [ Dillimore ]', '', 19130, 30, 0, 0, 0, 0, -1, 0, 0, 0, 0, 626.965, -571.794, 17.9207, 89.5109, 29, 29, -1464.99, 2609.88, 19.631, 178.087),
(30, 'Rooftop', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 621.289, -568.999, 26.1432, 179.897, 29, 29, -1479.84, 2605.28, 19.781, 187.487),
(31, 'Parkiran', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 611.09, -583.501, 18.2109, 181.44, 29, 29, -1475.76, 2593.04, 15.9518, 184.353),
(35, 'Department of Motor Vehicles', '', 19130, 0, 0, 0, 0, 0, -1, 0, 1, 0, 0, 2062.83, -1897.38, 13.5538, 187.697, 5, 5, -2572.28, -1376.14, 1500.76, 83.6231),
(36, 'Las Venturas Schematic Factory', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1590.81, 688.192, 10.8203, 89.1129, 0, 0, 1062.31, 2077.53, 10.8203, 357.764),
(37, 'Palomino Bank', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 2303.82, -16.1489, 26.4844, 271.276, 0, 0, 0, 0, 0, 0),
(38, 'Insurance Center', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1333.02, -1266.15, 13.5469, 90.4743, 0, 0, 1285.88, -1270.08, 13.5939, 8.86195),
(39, 'Lantai 2', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1287.24, -1262.04, 13.5939, 358.209, 0, 0, 1287.43, -1261.74, 20.6199, 182.932),
(32, 'BlackMarket', '', 19130, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, -939.483, 1425.28, 30.434, 83.737, 666, 6, 296.907, -112.07, 1001.52, 345.349);

-- --------------------------------------------------------

--
-- Struktur dari tabel `familys`
--

CREATE TABLE `familys` (
  `ID` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'None',
  `leader` varchar(50) NOT NULL DEFAULT 'None',
  `motd` varchar(100) NOT NULL DEFAULT 'None',
  `color` int(11) DEFAULT 0,
  `extposx` float DEFAULT 0,
  `extposy` float DEFAULT 0,
  `extposz` float DEFAULT 0,
  `extposa` float DEFAULT 0,
  `intposx` float DEFAULT 0,
  `intposy` float DEFAULT 0,
  `intposz` float DEFAULT 0,
  `intposa` float DEFAULT 0,
  `fint` int(11) NOT NULL DEFAULT 0,
  `Weapon1` int(11) NOT NULL DEFAULT 0,
  `Ammo1` int(11) NOT NULL DEFAULT 0,
  `Weapon2` int(11) NOT NULL DEFAULT 0,
  `Ammo2` int(11) NOT NULL DEFAULT 0,
  `Weapon3` int(11) NOT NULL DEFAULT 0,
  `Ammo3` int(11) NOT NULL DEFAULT 0,
  `Weapon4` int(11) NOT NULL DEFAULT 0,
  `Ammo4` int(11) NOT NULL DEFAULT 0,
  `Weapon5` int(11) NOT NULL DEFAULT 0,
  `Ammo5` int(11) NOT NULL DEFAULT 0,
  `Weapon6` int(11) NOT NULL DEFAULT 0,
  `Ammo6` int(11) NOT NULL DEFAULT 0,
  `Weapon7` int(11) NOT NULL DEFAULT 0,
  `Ammo7` int(11) NOT NULL DEFAULT 0,
  `Weapon8` int(11) NOT NULL DEFAULT 0,
  `Ammo8` int(11) NOT NULL DEFAULT 0,
  `Weapon9` int(11) NOT NULL DEFAULT 0,
  `Ammo9` int(11) NOT NULL DEFAULT 0,
  `Weapon10` int(11) NOT NULL DEFAULT 0,
  `Ammo10` int(11) NOT NULL DEFAULT 0,
  `safex` float DEFAULT 0,
  `safey` float DEFAULT 0,
  `safez` float DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `marijuana` int(11) NOT NULL DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `Weapon11` int(11) NOT NULL DEFAULT 0,
  `Ammo11` int(11) NOT NULL DEFAULT 0,
  `Weapon12` int(11) NOT NULL DEFAULT 0,
  `Ammo12` int(11) NOT NULL DEFAULT 0,
  `Weapon13` int(11) NOT NULL DEFAULT 0,
  `Ammo13` int(11) NOT NULL DEFAULT 0,
  `Weapon14` int(11) NOT NULL DEFAULT 0,
  `Ammo14` int(11) NOT NULL DEFAULT 0,
  `Weapon15` int(11) NOT NULL DEFAULT 0,
  `Ammo15` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `gates`
--

CREATE TABLE `gates` (
  `ID` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `password` varchar(36) NOT NULL DEFAULT '',
  `admin` tinyint(4) NOT NULL DEFAULT 0,
  `vip` tinyint(4) NOT NULL DEFAULT 0,
  `faction` tinyint(4) NOT NULL DEFAULT 0,
  `family` int(11) NOT NULL DEFAULT -1,
  `speed` float NOT NULL DEFAULT 2,
  `cX` float NOT NULL,
  `cY` float NOT NULL,
  `cZ` float NOT NULL,
  `cRX` float NOT NULL,
  `cRY` float NOT NULL,
  `cRZ` float NOT NULL,
  `oX` float NOT NULL,
  `oY` float NOT NULL,
  `oZ` float NOT NULL,
  `oRX` float NOT NULL,
  `oRY` float NOT NULL,
  `oRZ` float NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `gates`
--

INSERT INTO `gates` (`ID`, `model`, `password`, `admin`, `vip`, `faction`, `family`, `speed`, `cX`, `cY`, `cZ`, `cRX`, `cRY`, `cRZ`, `oX`, `oY`, `oZ`, `oRX`, `oRY`, `oRZ`) VALUES
(0, 980, '', 0, 0, 1, -1, 2, 1539.41, -1627.56, 15.0128, 0, 0, 90.2, 1539.41, -1627.56, 9.51278, 0, 0, 90.2),
(1, 986, '', 0, 0, 4, -1, 2, 777.918, -1385.11, 13.6232, 0, 0, 0, 769.928, -1385.11, 13.6232, 0, 0, 0),
(2, 986, '', 0, 0, 3, -1, 2, 1147.43, -1290.87, 13.6388, 0, 0, 1.1, 1153.97, -1290.74, 13.6388, 0, 0, 1.1),
(3, 968, '', 0, 0, 0, -1, 2, 907.214, -1681.77, 13.5469, 0, 89.3, 88.3, 907.214, -1681.77, 13.5469, 0, -0.200005, 88.3),
(4, 968, '', 0, 0, 0, -1, 2, -1701.43, 687.603, 24.7006, -2.4, -90.6, 90, -1701.43, 687.603, 24.7006, 0, 0, 91.6),
(5, 968, '', 0, 0, 0, -1, 2, 907.235, -1654.92, 13.5469, 0, -90.5, 92.8, 907.235, -1654.92, 13.5469, 0, 0, 92.8),
(7, 986, '', 0, 0, 1, -1, 2, 1588.66, -1637.79, 13.3828, 0, 0, 179.7, 1596.41, -1637.83, 13.3828, 0, 0, 179.7),
(6, 19859, '', 0, 0, 1, -1, 2, 1539.68, -1620.17, 13.6946, 0, 0, 87.6, 1539.74, -1621.51, 13.6946, 0, 0, 87.6),
(8, 1498, '', 0, 0, 0, -1, 2, 1556.47, -1684.54, 6.21875, 0, 0, 0, 1556.47, -1684.54, 6.21875, 0, 0, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `gstations`
--

CREATE TABLE `gstations` (
  `id` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 10000,
  `posx` float DEFAULT 0,
  `posy` float DEFAULT 0,
  `posz` float DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `gstations`
--

INSERT INTO `gstations` (`id`, `stock`, `posx`, `posy`, `posz`) VALUES
(0, 44490, 1944.41, -1772.95, 13.3906),
(2, 49940, -92.051, -1170.65, 2.40334),
(3, 12930, 1004.45, -939.424, 42.1797),
(4, 65800, 652.534, -564.914, 16.3359),
(5, 99940, -2406.81, 975.719, 45.2969),
(6, 9840, -2243.63, -2560.31, 31.9219),
(1, 8270, -1605.74, -2714.33, 48.5335);

-- --------------------------------------------------------

--
-- Struktur dari tabel `houses`
--

CREATE TABLE `houses` (
  `ID` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL DEFAULT '-',
  `ownerid` int(11) NOT NULL,
  `address` varchar(50) DEFAULT 'None',
  `price` int(11) NOT NULL DEFAULT 500000,
  `type` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `redmoney` int(11) NOT NULL DEFAULT 0,
  `houseint` int(11) NOT NULL DEFAULT 0,
  `extposx` float NOT NULL DEFAULT 0,
  `extposy` float NOT NULL DEFAULT 0,
  `extposz` float NOT NULL DEFAULT 0,
  `extposa` float NOT NULL DEFAULT 0,
  `intposx` float NOT NULL DEFAULT 0,
  `intposy` float NOT NULL DEFAULT 0,
  `intposz` float NOT NULL DEFAULT 0,
  `intposa` float NOT NULL DEFAULT 0,
  `visit` bigint(20) DEFAULT 0,
  `snack` int(11) NOT NULL DEFAULT 0,
  `sprunk` int(11) NOT NULL DEFAULT 0,
  `medicine` int(11) NOT NULL DEFAULT 0,
  `medkit` int(11) NOT NULL DEFAULT 0,
  `bandage` int(11) NOT NULL DEFAULT 0,
  `seed` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `marijuana` int(11) NOT NULL DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `houseWeapon1` int(11) DEFAULT 0,
  `houseAmmo1` int(11) DEFAULT 0,
  `houseWeapon2` int(11) DEFAULT 0,
  `houseAmmo2` int(11) DEFAULT 0,
  `houseWeapon3` int(11) DEFAULT 0,
  `houseAmmo3` int(11) DEFAULT 0,
  `houseWeapon4` int(11) DEFAULT 0,
  `houseAmmo4` int(11) DEFAULT 0,
  `houseWeapon5` int(11) DEFAULT 0,
  `houseAmmo5` int(11) DEFAULT 0,
  `houseWeapon6` int(11) DEFAULT 0,
  `houseAmmo6` int(11) DEFAULT 0,
  `houseWeapon7` int(11) DEFAULT 0,
  `houseAmmo7` int(11) DEFAULT 0,
  `houseWeapon8` int(11) DEFAULT 0,
  `houseAmmo8` int(11) DEFAULT 0,
  `houseWeapon9` int(11) DEFAULT 0,
  `houseAmmo9` int(11) DEFAULT 0,
  `houseWeapon10` int(11) DEFAULT 0,
  `houseAmmo10` int(11) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `lockers`
--

CREATE TABLE `lockers` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `loglogin`
--

CREATE TABLE `loglogin` (
  `no` int(11) NOT NULL,
  `username` varchar(40) NOT NULL DEFAULT 'None',
  `reg_id` int(11) NOT NULL DEFAULT 0,
  `password` varchar(40) NOT NULL DEFAULT 'None',
  `time` varchar(40) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `logpay`
--

CREATE TABLE `logpay` (
  `player` varchar(40) NOT NULL DEFAULT 'None',
  `playerid` int(11) NOT NULL DEFAULT 0,
  `toplayer` varchar(40) NOT NULL DEFAULT 'None',
  `toplayerid` int(11) NOT NULL DEFAULT 0,
  `ammount` int(11) NOT NULL DEFAULT 0,
  `time` bigint(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `logstaff`
--

CREATE TABLE `logstaff` (
  `command` varchar(50) NOT NULL,
  `admin` varchar(50) NOT NULL,
  `adminid` int(11) NOT NULL,
  `player` varchar(50) NOT NULL DEFAULT '*',
  `playerid` int(11) NOT NULL DEFAULT -1,
  `str` varchar(50) NOT NULL DEFAULT '*',
  `time` bigint(20) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `object`
--

CREATE TABLE `object` (
  `id` int(11) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `posrx` float NOT NULL,
  `posry` float NOT NULL,
  `posrz` float NOT NULL,
  `interior` int(11) NOT NULL DEFAULT 0,
  `world` int(11) NOT NULL DEFAULT 0,
  `object` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `ores`
--

CREATE TABLE `ores` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `posx` float DEFAULT 0,
  `posy` float DEFAULT 0,
  `posz` float DEFAULT 0,
  `posrx` float DEFAULT 0,
  `posry` float DEFAULT 0,
  `posrz` float DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `ores`
--

INSERT INTO `ores` (`id`, `type`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`) VALUES
(0, 0, 464.381, 866.534, -28.387, 0, 0, 0),
(1, 1, 555.939, 928.367, -43.5709, 0, 0, 0),
(2, 0, 613.141, 865.3, -43.5509, 0, 0, 0),
(3, 1, 637.747, 831.97, -43.6309, 0, 0, 0),
(4, 0, 671.772, 927.05, -41.4543, 0, 0, 0),
(5, 0, 652.36, 738.067, -11.904, 0, 0, 0),
(6, 1, 640.83, 731.161, -2.64683, 0, 0, 0),
(7, 1, 500.121, 781.126, -21.9991, 0, 0, 0),
(8, 0, 488.845, 785.109, -22.3256, 0, 0, 0),
(9, 1, 685.946, 820.716, -28.3049, 0, 0, 0),
(10, 0, 562.108, 982.26, -7.96277, 0, 0, 0),
(11, 0, 535.467, 909.043, -43.4109, 0, 0, 0),
(12, 0, 539.144, 882.115, -36.6565, 0, 0, 0),
(13, 1, 461.884, 884.778, -28.8179, 0, 0, 0),
(14, 1, 698.502, 841.609, -28.2711, 0, 0, 0),
(15, 1, 487.904, 800.007, -22.22, 0, 0, 0),
(16, 0, 546.501, 824.598, -29.9684, 0, 0, 0),
(17, 1, 576.64, 805.685, -29.4404, 0, 0, 0),
(18, 1, 554.326, 786.207, -19.1056, 0, 0, 0),
(19, 1, 709.745, 921.678, -19.4611, 0, 0, 0),
(20, 0, 714.078, 913.618, -19.2864, 0, 0, 0),
(21, 1, 744.818, 776.606, -8.06283, 0, 0, 0),
(22, 0, 600.437, 932.102, -41.5237, 0, 0, 0),
(23, 0, 597.532, 829.781, -43.959, 0, 0, 0),
(24, 1, 540.974, 842.47, -42.1793, 0, 0, 0),
(25, 1, 696.797, 844.561, -28.9438, 0, 0, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `parks`
--

CREATE TABLE `parks` (
  `id` int(11) DEFAULT 0,
  `posx` float DEFAULT 0,
  `posy` float DEFAULT 0,
  `posz` float DEFAULT 0,
  `interior` int(11) DEFAULT 0,
  `world` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `parks`
--

INSERT INTO `parks` (`id`, `posx`, `posy`, `posz`, `interior`, `world`) VALUES
(0, 2115.4, -1776.52, 13.3912, 0, 0),
(1, 1320.01, -863.615, 39.5781, 0, 0),
(2, 1090.48, -1237.86, 15.8203, 0, 0),
(4, 1365.84, -1648.96, 13.3828, 0, 0),
(3, 1019.95, -1438.36, 13.5546, 0, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `plants`
--

CREATE TABLE `plants` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `players`
--

CREATE TABLE `players` (
  `reg_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(24) NOT NULL DEFAULT '',
  `ucp` varchar(22) NOT NULL,
  `adminname` varchar(24) NOT NULL DEFAULT 'None',
  `twittername` varchar(64) NOT NULL DEFAULT 'None',
  `ip` varchar(24) NOT NULL DEFAULT '',
  `email` varchar(40) NOT NULL DEFAULT 'None',
  `characterstory` int(11) NOT NULL DEFAULT 0,
  `admin` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `helper` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `servermod` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `eventmod` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `factionmod` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `familymod` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `levelup` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `vip` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `vip_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `gold` int(11) NOT NULL DEFAULT 0,
  `reg_date` varchar(30) NOT NULL DEFAULT '',
  `last_login` varchar(30) NOT NULL DEFAULT '',
  `money` int(11) NOT NULL DEFAULT 0,
  `redmoney` int(11) NOT NULL DEFAULT 0,
  `bmoney` int(11) NOT NULL DEFAULT 0,
  `brek` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `starterpack` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `phone` mediumint(8) UNSIGNED NOT NULL,
  `phonestatus` int(11) NOT NULL DEFAULT 0,
  `phonekuota` int(11) NOT NULL DEFAULT 0,
  `phonecredit` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `phonebook` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `twitter` int(11) NOT NULL DEFAULT 0,
  `twitterstatus` int(11) NOT NULL DEFAULT 0,
  `wt` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `hours` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `minutes` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `seconds` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `paycheck` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `skin` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `facskin` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `gender` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `age` varchar(30) NOT NULL DEFAULT '',
  `indoor` mediumint(9) NOT NULL DEFAULT -1,
  `inbiz` mediumint(9) NOT NULL DEFAULT -1,
  `inhouse` mediumint(9) NOT NULL DEFAULT -1,
  `infamily` mediumint(9) NOT NULL DEFAULT -1,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `posa` float NOT NULL DEFAULT 0,
  `interior` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `world` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 100,
  `armour` float NOT NULL DEFAULT 0,
  `hunger` smallint(6) NOT NULL DEFAULT 100,
  `bladder` smallint(6) NOT NULL DEFAULT 100,
  `energy` smallint(6) NOT NULL DEFAULT 100,
  `sick` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `hospital` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `injured` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `duty` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `dutytime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `faction` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `factionrank` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `factionlead` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `family` tinyint(4) NOT NULL DEFAULT -1,
  `familyrank` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `jail` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `jail_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `arrest` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `arrest_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `suspect` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `suspect_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `ask_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `warn` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `job` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `job2` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `jobtime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sidejobtime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sidejob_mowertime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sidejob_bustime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sidejob_forkliftertime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sidejob_sweepertime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `exitjob` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `taxitime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `robtime` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `myricous` mediumint(9) NOT NULL DEFAULT 0,
  `medicine` mediumint(9) NOT NULL DEFAULT 0,
  `medkit` mediumint(9) NOT NULL DEFAULT 0,
  `mask` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `helmet` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `snack` mediumint(9) NOT NULL DEFAULT 0,
  `sprunk` mediumint(9) NOT NULL DEFAULT 0,
  `gas` mediumint(9) NOT NULL DEFAULT 0,
  `bandage` mediumint(9) NOT NULL DEFAULT 0,
  `gps` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `material` mediumint(9) NOT NULL DEFAULT 0,
  `component` mediumint(9) NOT NULL DEFAULT 0,
  `food` mediumint(9) NOT NULL DEFAULT 0,
  `seed` mediumint(9) NOT NULL DEFAULT 0,
  `potato` mediumint(9) NOT NULL DEFAULT 0,
  `wheat` mediumint(9) NOT NULL DEFAULT 0,
  `orange` mediumint(9) NOT NULL DEFAULT 0,
  `price1` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `price2` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `price3` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `price4` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `marijuana` mediumint(9) NOT NULL DEFAULT 0,
  `plant` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `plant_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `fishtool` tinyint(4) NOT NULL DEFAULT 0,
  `fish` mediumint(9) NOT NULL DEFAULT 0,
  `worm` mediumint(9) NOT NULL DEFAULT 0,
  `idcard` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `idcard_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `drivelic` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `drivelic_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `weaponlic` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `weaponlic_time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `hbemode` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `togpm` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `toglog` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `togads` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `togwt` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `Gun1` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun2` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun3` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun4` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun5` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun6` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun7` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun8` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun9` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun10` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun11` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun12` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Gun13` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo1` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo2` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo3` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo4` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo5` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo6` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo7` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo8` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo9` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo10` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo11` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo12` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `Ammo13` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `kepala` int(11) NOT NULL DEFAULT 0,
  `perut` int(11) NOT NULL DEFAULT 0,
  `lengankiri` int(11) NOT NULL DEFAULT 0,
  `lengankanan` int(11) NOT NULL DEFAULT 0,
  `kakikiri` int(11) NOT NULL DEFAULT 0,
  `kakikanan` int(11) NOT NULL DEFAULT 0,
  `kurir` int(11) NOT NULL DEFAULT 0,
  `sparepart` int(11) DEFAULT 0,
  `senter` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `playerucp`
--

CREATE TABLE `playerucp` (
  `ID` int(11) NOT NULL,
  `ucp` varchar(22) NOT NULL,
  `verifycode` int(11) NOT NULL,
  `DiscordID` bigint(20) NOT NULL,
  `password` varchar(64) NOT NULL,
  `salt` varchar(16) NOT NULL,
  `extrac` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `reports`
--

CREATE TABLE `reports` (
  `ID` int(11) NOT NULL,
  `Reporter` varchar(24) NOT NULL,
  `Reason` varchar(200) NOT NULL,
  `Date` varchar(30) NOT NULL,
  `Accepted` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `salary`
--

CREATE TABLE `salary` (
  `id` bigint(20) NOT NULL,
  `owner` int(11) DEFAULT 0,
  `info` varchar(46) DEFAULT '',
  `money` int(11) NOT NULL DEFAULT 0,
  `date` varchar(36) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `server`
--

CREATE TABLE `server` (
  `id` int(11) NOT NULL DEFAULT 0,
  `servermoney` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 500,
  `materialprice` int(11) NOT NULL DEFAULT 10,
  `lumberprice` int(11) NOT NULL DEFAULT 800,
  `component` int(11) NOT NULL DEFAULT 500,
  `componentprice` int(11) NOT NULL DEFAULT 10,
  `metalprice` int(11) NOT NULL DEFAULT 500,
  `gasoil` int(11) NOT NULL DEFAULT 1000,
  `gasoilprice` int(11) NOT NULL DEFAULT 10,
  `coalprice` int(11) NOT NULL DEFAULT 500,
  `product` int(11) NOT NULL DEFAULT 500,
  `productprice` int(11) NOT NULL DEFAULT 20,
  `apotek` int(11) NOT NULL DEFAULT 500,
  `medicineprice` int(11) NOT NULL DEFAULT 300,
  `medkitprice` int(11) NOT NULL DEFAULT 500,
  `food` int(11) NOT NULL DEFAULT 500,
  `foodprice` int(11) NOT NULL DEFAULT 100,
  `seedprice` int(11) NOT NULL DEFAULT 10,
  `potatoprice` int(11) NOT NULL DEFAULT 10,
  `wheatprice` int(11) NOT NULL DEFAULT 10,
  `orangeprice` int(11) NOT NULL DEFAULT 10,
  `marijuana` int(11) NOT NULL DEFAULT 500,
  `marijuanaprice` int(11) NOT NULL DEFAULT 10,
  `fishprice` int(11) NOT NULL DEFAULT 100,
  `gstationprice` int(11) NOT NULL DEFAULT 100,
  `obatmyr` int(11) NOT NULL DEFAULT 0,
  `obatprice` int(11) NOT NULL DEFAULT 0,
  `crateforklift` int(11) NOT NULL DEFAULT 0,
  `cratekurir` int(11) NOT NULL DEFAULT 0,
  `paper` int(11) NOT NULL DEFAULT 0,
  `paperprice` int(11) NOT NULL DEFAULT 0,
  `hgschema` int(11) NOT NULL DEFAULT 0,
  `arschema` int(11) NOT NULL DEFAULT 0,
  `smgschema` int(11) NOT NULL DEFAULT 0,
  `hgprice` int(11) NOT NULL DEFAULT 70,
  `arprice` int(11) NOT NULL DEFAULT 220,
  `smgprice` int(11) NOT NULL DEFAULT 200
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `server`
--

INSERT INTO `server` (`id`, `servermoney`, `material`, `materialprice`, `lumberprice`, `component`, `componentprice`, `metalprice`, `gasoil`, `gasoilprice`, `coalprice`, `product`, `productprice`, `apotek`, `medicineprice`, `medkitprice`, `food`, `foodprice`, `seedprice`, `potatoprice`, `wheatprice`, `orangeprice`, `marijuana`, `marijuanaprice`, `fishprice`, `gstationprice`, `obatmyr`, `obatprice`, `crateforklift`, `cratekurir`, `paper`, `paperprice`, `hgschema`, `arschema`, `smgschema`, `hgprice`, `arprice`, `smgprice`) VALUES
(0, 1445254033, 0, 4, 80, 0, 2, 85, 263984, 3, 75, 29896, 8, 100000, 200, 300, 37, 2, 5, 10, 50, 30, 0, 128, 35, 1, 24, 200, 99, 30, 200, 0, 0, 10, 5, 220, 70, 200);

-- --------------------------------------------------------

--
-- Struktur dari tabel `speedcameras`
--

CREATE TABLE `speedcameras` (
  `speedID` int(11) NOT NULL,
  `speedRange` float DEFAULT 0,
  `speedLimit` float DEFAULT 0,
  `speedX` float DEFAULT 0,
  `speedY` float DEFAULT 0,
  `speedZ` float DEFAULT 0,
  `speedAngle` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data untuk tabel `speedcameras`
--

INSERT INTO `speedcameras` (`speedID`, `speedRange`, `speedLimit`, `speedX`, `speedY`, `speedZ`, `speedAngle`) VALUES
(0, 15, 50, 156.846, -1575.49, 11.0201, 226.417),
(1, 10, 90, 1350.01, -1417.63, 12.3468, 355.13),
(2, 15, 100, 1369.77, -955.765, 33.1849, 172.215);

-- --------------------------------------------------------

--
-- Struktur dari tabel `toys`
--

CREATE TABLE `toys` (
  `Id` int(11) NOT NULL,
  `Owner` varchar(40) NOT NULL DEFAULT '',
  `Slot0_Model` int(11) NOT NULL DEFAULT 0,
  `Slot0_Bone` int(11) NOT NULL DEFAULT 0,
  `Slot0_Status` int(11) NOT NULL DEFAULT 0,
  `Slot0_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot0_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_Model` int(11) NOT NULL DEFAULT 0,
  `Slot1_Bone` int(11) NOT NULL DEFAULT 0,
  `Slot1_Status` int(11) NOT NULL DEFAULT 0,
  `Slot1_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot1_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_Model` int(11) NOT NULL DEFAULT 0,
  `Slot2_Bone` int(11) NOT NULL DEFAULT 0,
  `Slot2_Status` int(11) NOT NULL DEFAULT 0,
  `Slot2_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot2_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_Model` int(11) NOT NULL DEFAULT 0,
  `Slot3_Bone` int(11) NOT NULL DEFAULT 0,
  `Slot3_Status` int(11) NOT NULL DEFAULT 0,
  `Slot3_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot3_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_Model` int(11) NOT NULL DEFAULT 0,
  `Slot4_Bone` int(11) NOT NULL DEFAULT 0,
  `Slot4_Status` int(11) NOT NULL DEFAULT 0,
  `Slot4_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot4_ZScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_Model` int(11) NOT NULL DEFAULT 0,
  `Slot5_Bone` int(11) NOT NULL DEFAULT 0,
  `Slot5_Status` int(11) NOT NULL DEFAULT 0,
  `Slot5_XPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_YPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_ZPos` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_XRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_YRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_ZRot` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_XScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_YScale` float(20,3) NOT NULL DEFAULT 0.000,
  `Slot5_ZScale` float(20,3) NOT NULL DEFAULT 0.000
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `trees`
--

CREATE TABLE `trees` (
  `id` int(11) NOT NULL,
  `posx` float DEFAULT NULL,
  `posy` float DEFAULT NULL,
  `posz` float DEFAULT NULL,
  `posrx` float DEFAULT NULL,
  `posry` float DEFAULT NULL,
  `posrz` float DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `trees`
--

INSERT INTO `trees` (`id`, `posx`, `posy`, `posz`, `posrx`, `posry`, `posrz`) VALUES
(0, -523.63, -2247.73, 34.5218, 0, 0, 0),
(1, -623.954, -2261.36, 23.9413, 0, 0, 0),
(2, -628.714, -2394, 29.5843, 0, 0, 0),
(3, -735.625, -2254.4, 27.5423, 0, 0, 0),
(4, -657.756, -2140.98, 24.2563, 0, 0, 0),
(5, -654.44, -2074.7, 25.9842, 0, 0, 0),
(6, -546.637, -1999.71, 48.0892, 0, 0, 0),
(7, -731.541, -2189.38, 34.526, 0, 0, 0),
(8, -732.679, -2200.2, 34.5699, 0, 0, 0),
(9, -739.308, -2193.72, 34.6548, 0, 0, 0),
(10, -865.874, -2199.14, 29.0169, 0, 0, 0),
(11, -814.336, -2247.82, 37.77, 0, 0, 0),
(12, -878.67, -2367.51, 68.2969, 0, 0, 0),
(13, -861.714, -2381.68, 69.0388, 0, 0, 0),
(14, -972.936, -2322.47, 62.7628, 0, 0, 0),
(15, -1043.86, -2303.47, 55.4699, 0, 0, 0),
(16, -979.795, -2391.9, 70.2428, 0, 0, 0),
(17, -928.635, -2531.78, 114.824, 0, 0, 0),
(18, -928.943, -2555.48, 114.897, 0, 0, 0),
(19, -889.914, -2502.48, 110.088, 0, 0, 0),
(20, -874.672, -2612.06, 95.074, 0, 0, 0),
(21, -622.4, -2263.39, 23.9615, 0, 0, 0),
(22, -552.445, -2272.94, 28.3696, 0, 0, 0),
(23, -1065.08, -2548.24, 68.1407, 0, 0, 0),
(24, -744.504, -2441.61, 65.1923, 0, 0, 0),
(25, -818.597, -2657.71, 91.0869, 0, 0, 0),
(26, -734.419, -2690.28, 86.7166, 0, 0, 0),
(27, -686.676, -2630.36, 82.9661, 0, 0, 0),
(28, -707.708, -2695.28, 91.3966, 0, 0, 0),
(29, -757.89, -2538.72, 90.0414, 0, 0, 0),
(30, -748.443, -2509.77, 81.1096, 0, 0, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `vehicle`
--

CREATE TABLE `vehicle` (
  `id` int(10) UNSIGNED NOT NULL,
  `owner` int(11) NOT NULL,
  `model` int(11) NOT NULL DEFAULT 0,
  `color1` int(11) NOT NULL DEFAULT 0,
  `color2` int(11) NOT NULL DEFAULT 0,
  `paintjob` int(11) NOT NULL DEFAULT -1,
  `neon` int(11) NOT NULL DEFAULT 0,
  `locked` int(11) NOT NULL DEFAULT 0,
  `insu` int(11) NOT NULL DEFAULT 1,
  `claim` int(11) NOT NULL DEFAULT 0,
  `claim_time` bigint(20) NOT NULL DEFAULT 0,
  `plate` varchar(50) NOT NULL DEFAULT 'None',
  `plate_time` bigint(20) NOT NULL DEFAULT 0,
  `ticket` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 200000,
  `health` float NOT NULL DEFAULT 1000,
  `fuel` int(11) NOT NULL DEFAULT 1000,
  `x` float NOT NULL DEFAULT 0,
  `y` float NOT NULL DEFAULT 0,
  `z` float NOT NULL DEFAULT 0,
  `a` float NOT NULL DEFAULT 0,
  `interior` int(11) NOT NULL DEFAULT 0,
  `vw` int(11) NOT NULL DEFAULT 0,
  `damage0` int(11) NOT NULL DEFAULT 0,
  `damage1` int(11) NOT NULL DEFAULT 0,
  `damage2` int(11) NOT NULL DEFAULT 0,
  `damage3` int(11) NOT NULL DEFAULT 0,
  `mod0` int(11) NOT NULL DEFAULT 0,
  `mod1` int(11) NOT NULL DEFAULT 0,
  `mod2` int(11) NOT NULL DEFAULT 0,
  `mod3` int(11) NOT NULL DEFAULT 0,
  `mod4` int(11) NOT NULL DEFAULT 0,
  `mod5` int(11) NOT NULL DEFAULT 0,
  `mod6` int(11) NOT NULL DEFAULT 0,
  `mod7` int(11) NOT NULL DEFAULT 0,
  `mod8` int(11) NOT NULL DEFAULT 0,
  `mod9` int(11) NOT NULL DEFAULT 0,
  `mod10` int(11) NOT NULL DEFAULT 0,
  `mod11` int(11) NOT NULL DEFAULT 0,
  `mod12` int(11) NOT NULL DEFAULT 0,
  `mod13` int(11) NOT NULL DEFAULT 0,
  `mod14` int(11) NOT NULL DEFAULT 0,
  `mod15` int(11) NOT NULL DEFAULT 0,
  `mod16` int(11) NOT NULL DEFAULT 0,
  `lumber` int(11) NOT NULL DEFAULT -1,
  `metal` int(11) NOT NULL DEFAULT 0,
  `coal` int(11) NOT NULL DEFAULT 0,
  `product` int(11) NOT NULL DEFAULT 0,
  `gasoil` int(11) NOT NULL DEFAULT 0,
  `box` int(11) NOT NULL DEFAULT 0,
  `rental` bigint(20) NOT NULL DEFAULT 0,
  `park` int(11) NOT NULL DEFAULT -1,
  `broken` tinyint(1) NOT NULL DEFAULT 0,
  `trunk` int(11) NOT NULL DEFAULT 1,
  `money` int(11) NOT NULL DEFAULT 0,
  `redmoney` int(11) NOT NULL DEFAULT 0,
  `snack` int(11) NOT NULL DEFAULT 0,
  `sprunk` int(11) NOT NULL DEFAULT 0,
  `medicine` int(11) NOT NULL DEFAULT 0,
  `medkit` int(11) NOT NULL DEFAULT 0,
  `bandage` int(11) NOT NULL DEFAULT 0,
  `seed` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `marijuana` int(11) NOT NULL DEFAULT 0,
  `weapon1` int(11) DEFAULT 0,
  `ammo1` int(11) DEFAULT 0,
  `weapon2` int(11) DEFAULT 0,
  `ammo2` int(11) DEFAULT 0,
  `weapon3` int(11) DEFAULT 0,
  `ammo3` int(11) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `vending`
--

CREATE TABLE `vending` (
  `ID` int(11) NOT NULL,
  `owner` varchar(40) CHARACTER SET latin1 NOT NULL DEFAULT '-',
  `ownerid` int(11) NOT NULL,
  `name` varchar(60) CHARACTER SET latin1 NOT NULL DEFAULT 'Vending Machine',
  `price` int(11) NOT NULL DEFAULT 1,
  `locked` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 50,
  `posx` float NOT NULL,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `posa` float NOT NULL DEFAULT 0,
  `posrx` float NOT NULL DEFAULT 0,
  `posry` float NOT NULL DEFAULT 0,
  `posrz` float NOT NULL DEFAULT 0,
  `restock` tinyint(4) NOT NULL DEFAULT 0,
  `vprice0` int(11) NOT NULL DEFAULT 0,
  `vprice1` int(11) NOT NULL DEFAULT 0,
  `vprice2` int(11) NOT NULL DEFAULT 0,
  `vprice3` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur dari tabel `vouchers`
--

CREATE TABLE `vouchers` (
  `id` int(11) NOT NULL,
  `code` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) NOT NULL DEFAULT 0,
  `vip_time` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `gold` int(11) NOT NULL DEFAULT 0,
  `admin` varchar(16) NOT NULL DEFAULT 'None',
  `donature` varchar(16) NOT NULL DEFAULT 'None',
  `claim` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `vstorage`
--

CREATE TABLE `vstorage` (
  `ID` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  `redmoney` int(11) NOT NULL DEFAULT 0,
  `snack` int(11) NOT NULL DEFAULT 0,
  `sprunk` int(11) NOT NULL DEFAULT 0,
  `medicine` int(11) NOT NULL DEFAULT 0,
  `medkit` int(11) NOT NULL DEFAULT 0,
  `bandage` int(11) NOT NULL DEFAULT 0,
  `seed` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `marijuana` int(11) NOT NULL DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `weapon1` int(11) DEFAULT 0,
  `ammo1` int(11) DEFAULT 0,
  `weapon2` int(11) DEFAULT 0,
  `ammo2` int(11) DEFAULT 0,
  `weapon3` int(11) DEFAULT 0,
  `ammo3` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `weaponsettings`
--

CREATE TABLE `weaponsettings` (
  `Owner` int(11) NOT NULL,
  `WeaponID` tinyint(4) NOT NULL,
  `PosX` float DEFAULT -0.116,
  `PosY` float DEFAULT 0.189,
  `PosZ` float DEFAULT 0.088,
  `RotX` float DEFAULT 0,
  `RotY` float DEFAULT 44.5,
  `RotZ` float DEFAULT 0,
  `Bone` tinyint(4) NOT NULL DEFAULT 1,
  `Hidden` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `workshop`
--

CREATE TABLE `workshop` (
  `id` int(11) NOT NULL,
  `owner` varchar(25) NOT NULL DEFAULT '-',
  `ownerid` int(11) NOT NULL,
  `posx` float NOT NULL DEFAULT 0,
  `posy` float NOT NULL DEFAULT 0,
  `posz` float NOT NULL DEFAULT 0,
  `component` int(11) NOT NULL DEFAULT 0,
  `material` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `name` varchar(26) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `employe0` varchar(25) NOT NULL DEFAULT '-',
  `employe1` varchar(25) NOT NULL DEFAULT '-',
  `employe2` varchar(25) NOT NULL DEFAULT '-'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `actor`
--
ALTER TABLE `actor`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `atms`
--
ALTER TABLE `atms`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `banneds`
--
ALTER TABLE `banneds`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `bisnis`
--
ALTER TABLE `bisnis`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`contactID`);

--
-- Indeks untuk tabel `doors`
--
ALTER TABLE `doors`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `gates`
--
ALTER TABLE `gates`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `gstations`
--
ALTER TABLE `gstations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `lockers`
--
ALTER TABLE `lockers`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `loglogin`
--
ALTER TABLE `loglogin`
  ADD PRIMARY KEY (`no`);

--
-- Indeks untuk tabel `ores`
--
ALTER TABLE `ores`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`reg_id`);

--
-- Indeks untuk tabel `playerucp`
--
ALTER TABLE `playerucp`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `server`
--
ALTER TABLE `server`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `speedcameras`
--
ALTER TABLE `speedcameras`
  ADD PRIMARY KEY (`speedID`);

--
-- Indeks untuk tabel `trees`
--
ALTER TABLE `trees`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `vending`
--
ALTER TABLE `vending`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `vstorage`
--
ALTER TABLE `vstorage`
  ADD PRIMARY KEY (`ID`);

--
-- Indeks untuk tabel `weaponsettings`
--
ALTER TABLE `weaponsettings`
  ADD PRIMARY KEY (`Owner`,`WeaponID`),
  ADD UNIQUE KEY `Owner` (`Owner`,`WeaponID`);

--
-- Indeks untuk tabel `workshop`
--
ALTER TABLE `workshop`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `banneds`
--
ALTER TABLE `banneds`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contactID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `loglogin`
--
ALTER TABLE `loglogin`
  MODIFY `no` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `players`
--
ALTER TABLE `players`
  MODIFY `reg_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `playerucp`
--
ALTER TABLE `playerucp`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `reports`
--
ALTER TABLE `reports`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `vstorage`
--
ALTER TABLE `vstorage`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
