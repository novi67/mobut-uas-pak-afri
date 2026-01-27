-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 27, 2026 at 01:48 PM
-- Server version: 11.4.9-MariaDB-cll-lve
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bere9277_db_novi`
--

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `body`, `image_url`, `created_at`) VALUES
(1, 'Tips Membeli Rumah Pertama', 'Berikut tips membeli rumah pertama: cek lokasi, legalitas, budget, dll...', 'https://picsum.photos/seed/article1/600/400', '2026-01-10 19:05:36');

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `price` bigint(20) NOT NULL DEFAULT 0,
  `location` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`id`, `title`, `price`, `location`, `description`, `image_url`, `created_at`) VALUES
(1, 'Rumah Minimalis Type 45', 350000000, 'Medan', 'Dekat pusat kota, 2 kamar, 1 kamar mandi.', 'https://picsum.photos/seed/house1/600/400', '2026-01-10 19:05:36'),
(2, 'Rumah Modern Type 90', 850000000, 'Jakarta', '3 kamar, 2 kamar mandi, carport.', 'https://picsum.photos/seed/house2/600/400', '2026-01-10 19:05:36');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `created_at`) VALUES
(1, 'novi', 'novi@gmail.com', '$2y$10$vmx8sXhsW6Q4XLnBSaNWF.gKwRJJxMglvrT9yLLdw3UuTh8Tba8u.', '2026-01-10 19:05:57'),
(2, 'nova', 'nova@gmail.com', '$2y$10$WTbx5UGlFpM3Z6Y3PVdKpuIX4W8UNbjKP/viRBoBa47YA5l6nNtNe', '2026-01-22 13:54:42'),
(3, 'yudha', 'test@gmail.com', '$2y$10$YCrKKF2k3aJF1LEW8SfMlOo2G/qz6sVvAJh0yjhZ77ShFOMSQEFte', '2026-01-22 14:17:22'),
(4, 'adasdasdsad', 'as@gmail.com', '$2y$10$SBDYHjDH8AuThrgp8MiuLOXqEiOiNfrE3K/4bsJXeEQqGarHgwJEi', '2026-01-23 15:22:29');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
