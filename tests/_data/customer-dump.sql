-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:8889
-- Время создания: Апр 21 2020 г., 11:10
-- Версия сервера: 5.7.26
-- Версия PHP: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `customer`
--
CREATE DATABASE IF NOT EXISTS `customer` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `customer`;

-- --------------------------------------------------------

--
-- Структура таблицы `client`
--

CREATE TABLE `client` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight_format` int(11) NOT NULL,
  `currency` int(11) NOT NULL,
  `country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postal_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` int(11) DEFAULT NULL,
  `city` int(11) DEFAULT NULL,
  `timezone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `client`
--

INSERT INTO `client` (`id`, `name`, `email`, `weight_format`, `currency`, `country`, `postal_code`, `region`, `city`, `timezone`, `token`, `created_at`) VALUES
(1, 'Black Dirt Software', 'valentinemurnik@gmail.com', 2, 4, NULL, NULL, NULL, NULL, NULL, 'fqi4fl0bexkcs08g48sk4wskso8444', '2020-04-20');

-- --------------------------------------------------------

--
-- Структура таблицы `client__affiliate`
--

CREATE TABLE `client__affiliate` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referral_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `client__affiliate`
--

INSERT INTO `client__affiliate` (`id`, `client_id`, `name`, `email`, `referral_code`, `created_at`) VALUES
(1, 1, NULL, NULL, 'qx0hiorxz2occoosc4kw', '2020-04-20');

-- --------------------------------------------------------

--
-- Структура таблицы `client__module_access`
--

CREATE TABLE `client__module_access` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `expired_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `client__module_access`
--

INSERT INTO `client__module_access` (`id`, `client_id`, `module_id`, `expired_at`, `updated_at`, `status`) VALUES
(1, 1, 1, '2020-04-20 15:11:48', '2020-04-20 15:11:48', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `client__posts`
--

CREATE TABLE `client__posts` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `thumb_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client__referral`
--

CREATE TABLE `client__referral` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `affiliate_id` int(11) NOT NULL,
  `is_paid` tinyint(1) NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client__settings`
--

CREATE TABLE `client__settings` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `module` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client__subscription`
--

CREATE TABLE `client__subscription` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `amount` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client__tags`
--

CREATE TABLE `client__tags` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `client__team`
--

CREATE TABLE `client__team` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `client__team`
--

INSERT INTO `client__team` (`id`, `client_id`, `user_id`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `firstname` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_day` int(11) DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` date NOT NULL,
  `token` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_lead` tinyint(1) NOT NULL,
  `is_activated` tinyint(1) NOT NULL,
  `testimonial` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__address`
--

CREATE TABLE `customer__address` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `street` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apartment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postalCode` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__invoice`
--

CREATE TABLE `customer__invoice` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `amount` decimal(8,2) NOT NULL,
  `ref_num` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_date` date NOT NULL,
  `is_paid` tinyint(1) NOT NULL,
  `is_sent` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__invoice_product`
--

CREATE TABLE `customer__invoice_product` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `share_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `weight` decimal(7,2) DEFAULT NULL,
  `total_amount` decimal(8,2) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__location`
--

CREATE TABLE `customer__location` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apartment` int(11) DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postalCode` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `customer__location`
--

INSERT INTO `customer__location` (`id`, `client_id`, `name`, `street`, `apartment`, `city`, `region`, `postalCode`, `description`, `type`, `is_active`, `created_at`) VALUES
(1, 1, 'HOME DELIVERY', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2020-04-20');

-- --------------------------------------------------------

--
-- Структура таблицы `customer__location_workdays`
--

CREATE TABLE `customer__location_workdays` (
  `id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `weekday` int(11) NOT NULL,
  `start_time` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `customer__location_workdays`
--

INSERT INTO `customer__location_workdays` (`id`, `location_id`, `weekday`, `start_time`, `duration`, `is_active`) VALUES
(1, 1, 1, NULL, NULL, 0),
(2, 1, 2, NULL, NULL, 0),
(3, 1, 3, NULL, NULL, 0),
(4, 1, 4, NULL, NULL, 0),
(5, 1, 5, NULL, NULL, 0),
(6, 1, 6, NULL, NULL, 0),
(7, 1, 7, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `customer__notifies`
--

CREATE TABLE `customer__notifies` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `notify_type` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__orders`
--

CREATE TABLE `customer__orders` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `share_id` int(11) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__payments`
--

CREATE TABLE `customer__payments` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `amount` decimal(8,2) NOT NULL,
  `shares` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:array)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__payment_method`
--

CREATE TABLE `customer__payment_method` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gardener_price` int(11) NOT NULL,
  `farmer_price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__product__tag`
--

CREATE TABLE `customer__product__tag` (
  `id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__referrals`
--

CREATE TABLE `customer__referrals` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `referral_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__renewal_views`
--

CREATE TABLE `customer__renewal_views` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `ip` int(10) UNSIGNED DEFAULT NULL,
  `step` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__transactions`
--

CREATE TABLE `customer__transactions` (
  `id` int(11) NOT NULL,
  `payment_method` int(11) NOT NULL,
  `payment_id` int(11) DEFAULT NULL,
  `transaction_status` int(11) NOT NULL,
  `payment_code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `wallet` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `invoice` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `confirmed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__transaction_status`
--

CREATE TABLE `customer__transaction_status` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__vendor`
--

CREATE TABLE `customer__vendor` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `address_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `order_day` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:array)',
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__vendor_contact`
--

CREATE TABLE `customer__vendor_contact` (
  `id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notify_enabled` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `customer__vendor_orders`
--

CREATE TABLE `customer__vendor_orders` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `order_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `device__page_views`
--

CREATE TABLE `device__page_views` (
  `id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `module_id` int(11) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `page` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `device__page_views`
--

INSERT INTO `device__page_views` (`id`, `device_id`, `module_id`, `url`, `page`, `created_at`) VALUES
(1, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(2, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(3, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(4, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(5, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(6, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(7, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(8, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(9, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(10, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(11, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(12, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(13, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(14, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(15, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(16, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(17, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(18, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(19, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(20, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(21, 1, NULL, '/login', 'login', '2020-04-20 00:00:00'),
(22, 1, NULL, '/login', 'login', '2020-04-20 00:00:00'),
(23, 1, NULL, '/login', 'login', '2020-04-20 00:00:00'),
(24, 1, NULL, '/register', 'register', '2020-04-20 00:00:00'),
(25, 1, NULL, '/login', 'login', '2020-04-20 00:00:00'),
(26, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(27, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(28, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(29, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(30, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(31, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(32, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(33, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(34, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(35, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(36, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(37, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(38, 1, NULL, '/register', 'register', '2020-04-21 00:00:00'),
(39, 1, NULL, '/register', 'register', '2020-04-21 00:00:00');

-- --------------------------------------------------------

--
-- Структура таблицы `device__promotion_visit`
--

CREATE TABLE `device__promotion_visit` (
  `id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `email__auto`
--

CREATE TABLE `email__auto` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `email__auto`
--

INSERT INTO `email__auto` (`id`, `client_id`, `subject`, `text`, `type`) VALUES
(1, 1, 'Membership Activated', '<h4>{Firstname} {Lastname}</h4>\n\n<h4>\n    Your membership with {ClientName} has been activated\n</h4>\n\n<p>Click here to view your profile: {ProfileLink}</p>', 1),
(2, 1, 'Membership Weekly Reminder', '<h4>{Firstname} {Lastname}</h4>\n\n<h4>Your membership weekly email reminder</h4>\n\n<p>Click here to view your profile: {ProfileLink}</p>\n<p>Click here to skip a week: {SkipWeek}</p>\n<p>Click here to customize your share: {CustomizeShare}</p>', 2),
(3, 1, 'Feedback notification', '<h4>Are you satisfied with your recent order?</h4>\n\n<p>{FeedbackLinks}</p>', 3),
(4, 1, 'Membership Renewal', '<h4>{Firstname} {Lastname} your renewal date is&nbsp;{ShareRenewal}</h4>\n\n<h4>Your membership renewal notification</h4>\n\n<p>Click here to renew your membership: {RenewLink}</p>', 4),
(5, 1, 'Membership Lapsed', '<h4>{Firstname} {Lastname}</h4>\n\n<h4>Your membership has lapsed</h4>\n\n<p>Click here to renew your membership: {RenewLink}</p>', 5),
(6, 1, 'Delivery day notification', '<h1>{Firstname} {Lastname} your delivery day is {DeliveryDay}.</h1>\n\n<h2>Your membership delivery day notification.</h2>\n\n<p>Click here to view your profile: {ProfileLink}</p>', 6);

-- --------------------------------------------------------

--
-- Структура таблицы `email__feedback`
--

CREATE TABLE `email__feedback` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `share_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `is_satisfied` tinyint(1) NOT NULL,
  `share_date` date NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `email__log`
--

CREATE TABLE `email__log` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `automated_id` int(11) DEFAULT NULL,
  `reply_email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reply_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_draft` tinyint(1) NOT NULL,
  `in_process` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `email__recipient`
--

CREATE TABLE `email__recipient` (
  `id` int(11) NOT NULL,
  `log_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `email_address` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_delivered` tinyint(1) NOT NULL,
  `is_opened` tinyint(1) NOT NULL,
  `is_clicked` tinyint(1) NOT NULL,
  `is_bounced` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `email__testimonial_recipient`
--

CREATE TABLE `email__testimonial_recipient` (
  `id` int(11) NOT NULL,
  `affiliate_id` int(11) DEFAULT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstname` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `master__email`
--

CREATE TABLE `master__email` (
  `id` int(11) NOT NULL,
  `automated_id` int(11) DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_draft` tinyint(1) NOT NULL,
  `in_process` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `master__email`
--

INSERT INTO `master__email` (`id`, `automated_id`, `subject`, `text`, `is_draft`, `in_process`, `created_at`) VALUES
(1, 1, 'Please confirm your email', '<p>Hi,&nbsp;Black Dirt Software.</p>\r\n\r\n<p>To finish creating your account, please click on this <a href=\"http://customer.local/confirm/4sXbEetzvoXfZqu_sL8Bmv5cmQIYqikhhv9wjCe9jRQ\" target=\"_blank\">Confirmation link</a>.</p>\r\n\r\n<p>Happy planting,</p>\r\n\r\n<p>&mdash;The Black Dirt Team</p>', 0, 0, '2020-04-20 15:11:49');

-- --------------------------------------------------------

--
-- Структура таблицы `master__email_automated`
--

CREATE TABLE `master__email_automated` (
  `id` int(11) NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `master__email_automated`
--

INSERT INTO `master__email_automated` (`id`, `subject`, `text`, `type`) VALUES
(1, 'Please confirm your email', '<p>Hi,&nbsp;{ClientName}.</p>\r\n\r\n<p>To finish creating your account, please click on this {ConfirmationLink}.</p>\r\n\r\n<p>Happy planting,</p>\r\n\r\n<p>&mdash;The Black Dirt Team</p>', 1),
(2, 'Welcome to Black Dirt Software', '<div><span style=\"font-size:16px\">Thanks for creating an account.</span></div>\r\n\r\n<p><span style=\"font-size:16px\">Black Dirt Software helps farmers make big business of small farming. And we&rsquo;re excited to help you. So let&rsquo;s jump in and get our hands dirty.</span></p>\r\n\r\n<p><span style=\"font-size:16px\">If you have not confirmed your site yet, you can do so at {ConfirmationLink}</span></p>\r\n\r\n<p><span style=\"font-size:16px\">SETUP<br />\r\nPlanting your farm in Black Dirt is simple.</span></p>\r\n\r\n<ul>\r\n	<li><span style=\"font-size:16px\">First, go to </span> {SetupPlantsLink} <span style=\"font-size:16px\">and tell us what you grow.</span></li>\r\n	<li><span style=\"font-size:16px\">Then, go to&nbsp;</span> {SetupGardensLink} <span style=\"font-size:16px\">and tell us how your farm&rsquo;s set up.</span></li>\r\n	<li><span style=\"font-size:16px\">Finally, go to </span> {SetupCropsLink}<span style=\"font-size:16px\">&nbsp;to tell us which plants are in which gardens.</span></li>\r\n</ul>\r\n\r\n<p><span style=\"font-size:16px\">* Or, if you want a more detailed explanation on how to get set up, watch our video tutorial&nbsp;<a href=\"https://www.youtube.com/watch?v=vf0UUkTho9E\">here</a>.</span></p>\r\n\r\n<p><span style=\"font-size:16px\">LET&rsquo;S CONNECT<br />\r\nFinally, we hope you&rsquo;ll follow us on <a href=\"https://www.facebook.com/blackdirtsoftware/\">Facebook</a>, <a href=\"https://www.instagram.com/blackdirttechnology/\">Instagram</a> and <a href=\"https://www.youtube.com/channel/UCSLnfmRao-nLHKC1PAtY3jw\">Youtube</a>.</span></p>\r\n\r\n<p><span style=\"font-size:16px\">Thank you,</span></p>\r\n\r\n<p><span style=\"font-size:16px\">&mdash;The Black Dirt Team</span></p>', 2),
(3, 'Oops! Let’s try again…', '<p>You created a Black Dirt account but failed to confirm your email address.</p>\r\n\r\n<p>If you accidentally missed the confirmation email, you can click this [ {ConfirmationLink} ]&nbsp;to complete the process.</p>\r\n\r\n<p>Once you&rsquo;ve confirmed your email address, use this <a href=\"https://youtu.be/vf0UUkTho9E\" target=\"_blank\">video</a> tutorial to get set up.</p>\r\n\r\n<p>Thanks for planting your farm in Black Dirt!</p>\r\n\r\n<p>&mdash;The Black Dirt Team</p>', 3),
(4, 'You’re Almost Set Up!', '<p>We noticed you created an account, but didn&rsquo;t finish one, or all&nbsp;3, of the steps for setting up your farm:<br />\r\n{SetupPlantsLink}<br />\r\n{SetupGardensLink}<br />\r\n{SetupCropsLink}</p>\r\n\r\n<p>Here&rsquo;s a <a href=\"https://youtu.be/vf0UUkTho9E\" target=\"_blank\">video</a> tutorial that will help you finish your setup.</p>\r\n\r\n<p>Once you&rsquo;re done, your dashboard will be functional, and our software will start helping you manage your crops.</p>\r\n\r\n<p>Click on the video link above and plant your farm in Black Dirt.</p>\r\n\r\n<p>&mdash;The Black Dirt Team</p>', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `master__email_recipient`
--

CREATE TABLE `master__email_recipient` (
  `id` int(11) NOT NULL,
  `email_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `email_address` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_delivered` tinyint(1) NOT NULL,
  `is_opened` tinyint(1) NOT NULL,
  `is_clicked` tinyint(1) NOT NULL,
  `is_bounced` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `master__email_recipient`
--

INSERT INTO `master__email_recipient` (`id`, `email_id`, `client_id`, `email_address`, `is_delivered`, `is_opened`, `is_clicked`, `is_bounced`) VALUES
(1, 1, 1, 'valentinemurnik@gmail.com', 1, 1, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `master__posts`
--

CREATE TABLE `master__posts` (
  `id` int(11) NOT NULL,
  `thumb_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `media__image`
--

CREATE TABLE `media__image` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `mime_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `migration_versions`
--

CREATE TABLE `migration_versions` (
  `version` varchar(14) COLLATE utf8mb4_unicode_ci NOT NULL,
  `executed_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `migration_versions`
--

INSERT INTO `migration_versions` (`version`, `executed_at`) VALUES
('20200420134219', '2020-04-20 13:42:30'),
('20200421110849', '2020-04-21 11:08:56');

-- --------------------------------------------------------

--
-- Структура таблицы `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `subject` varchar(4000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(4000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link` varchar(4000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `notification__notify`
--

CREATE TABLE `notification__notify` (
  `id` int(11) NOT NULL,
  `notification_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `seen` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `pos`
--

CREATE TABLE `pos` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `total` decimal(7,2) NOT NULL,
  `received_amount` decimal(7,2) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `pos__product`
--

CREATE TABLE `pos__product` (
  `id` int(11) NOT NULL,
  `pos_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `price` decimal(7,2) NOT NULL,
  `weight` decimal(7,2) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `pos__products`
--

CREATE TABLE `pos__products` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `image` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(7,2) NOT NULL,
  `delivery_price` decimal(7,2) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `weight` decimal(7,2) DEFAULT NULL,
  `sku` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pay_by_item` tinyint(1) NOT NULL,
  `is_pos` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `share`
--

CREATE TABLE `share` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `updated_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `share__custom`
--

CREATE TABLE `share__custom` (
  `id` int(11) NOT NULL,
  `share_product_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `share_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `share__customer`
--

CREATE TABLE `share__customer` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `share_id` int(11) NOT NULL,
  `location` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `pickups_num` int(11) NOT NULL,
  `renewal_date` date NOT NULL,
  `pickup_day` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `share__pickups`
--

CREATE TABLE `share__pickups` (
  `id` int(11) NOT NULL,
  `share_id` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `skipped` tinyint(1) NOT NULL,
  `is_suspended` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `share__products`
--

CREATE TABLE `share__products` (
  `id` int(11) NOT NULL,
  `customer_order` int(11) DEFAULT NULL,
  `vendor_order` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `price` decimal(7,2) NOT NULL,
  `weight` decimal(7,2) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `share__suspended_weeks`
--

CREATE TABLE `share__suspended_weeks` (
  `id` int(11) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `week` int(11) NOT NULL,
  `year` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `translation`
--

CREATE TABLE `translation` (
  `id` int(11) NOT NULL,
  `key_id` int(11) NOT NULL,
  `locale_id` int(11) NOT NULL,
  `translation` longtext COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `translation__domain`
--

CREATE TABLE `translation__domain` (
  `id` int(11) NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `translation__key`
--

CREATE TABLE `translation__key` (
  `id` int(11) NOT NULL,
  `domain_id` int(11) NOT NULL,
  `trans_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `translation__locale`
--

CREATE TABLE `translation__locale` (
  `id` int(11) NOT NULL,
  `code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `translation__locale`
--

INSERT INTO `translation__locale` (`id`, `code`) VALUES
(1, 'en');

-- --------------------------------------------------------

--
-- Структура таблицы `translation__shared`
--

CREATE TABLE `translation__shared` (
  `id` int(11) NOT NULL,
  `locale_id` int(11) NOT NULL,
  `domain_id` int(11) NOT NULL,
  `is_shared` tinyint(1) NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `locale_id` int(11) NOT NULL,
  `username` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_format` int(11) DEFAULT NULL,
  `roles` json NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `confirmation_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_requested_at` date DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `locale_id`, `username`, `email`, `date_format`, `roles`, `password`, `confirmation_token`, `password_requested_at`, `enabled`, `is_active`, `created_at`) VALUES
(1, 1, 'master-black_dirt_software', 'valentinemurnik@gmail.com', 3, '[\"ROLE_ADMIN\"]', '$argon2id$v=19$m=65536,t=4,p=1$NWzKRmB2Es0pugRDZB4jRg$tWJFeozytKC5pvbkXnXcrwOZUSfKAxHe+DyRbkgqvW4', NULL, NULL, 1, 1, '2020-04-20');

-- --------------------------------------------------------

--
-- Структура таблицы `user__device`
--

CREATE TABLE `user__device` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_computer` tinyint(1) NOT NULL,
  `os` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `browser` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `browser_version` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `user__device`
--

INSERT INTO `user__device` (`id`, `user_id`, `ip`, `is_computer`, `os`, `browser`, `browser_version`, `created_at`) VALUES
(1, NULL, '127.0.0.1', 1, 'mac', 'Apple Safari', '13.0.5', '2020-04-20 14:23:46');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_C74404555E237E06` (`name`);

--
-- Индексы таблицы `client__affiliate`
--
ALTER TABLE `client__affiliate`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_84B2399319EB6921` (`client_id`),
  ADD UNIQUE KEY `affiliate_unique` (`name`,`email`);

--
-- Индексы таблицы `client__module_access`
--
ALTER TABLE `client__module_access`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `access_unique` (`client_id`,`module_id`),
  ADD KEY `IDX_22F969DA19EB6921` (`client_id`);

--
-- Индексы таблицы `client__posts`
--
ALTER TABLE `client__posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_57C31DD52B36786B` (`title`),
  ADD KEY `IDX_57C31DD519EB6921` (`client_id`),
  ADD KEY `IDX_57C31DD5C7034EA5` (`thumb_id`);

--
-- Индексы таблицы `client__referral`
--
ALTER TABLE `client__referral`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_B6E7086F19EB6921` (`client_id`),
  ADD UNIQUE KEY `referral_unique` (`client_id`,`affiliate_id`),
  ADD KEY `IDX_B6E7086F9F12C49A` (`affiliate_id`);

--
-- Индексы таблицы `client__settings`
--
ALTER TABLE `client__settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_20A535AA19EB6921` (`client_id`);

--
-- Индексы таблицы `client__subscription`
--
ALTER TABLE `client__subscription`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_8E2B3C4E19EB6921` (`client_id`);

--
-- Индексы таблицы `client__tags`
--
ALTER TABLE `client__tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tags_unique` (`client_id`,`name`),
  ADD KEY `IDX_91F4788A19EB6921` (`client_id`);

--
-- Индексы таблицы `client__team`
--
ALTER TABLE `client__team`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_3AA84AB3A76ED395` (`user_id`),
  ADD KEY `IDX_3AA84AB319EB6921` (`client_id`);

--
-- Индексы таблицы `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customer_unique` (`client_id`,`email`),
  ADD UNIQUE KEY `customer_phone_unique` (`client_id`,`phone`),
  ADD KEY `IDX_81398E0919EB6921` (`client_id`);

--
-- Индексы таблицы `customer__address`
--
ALTER TABLE `customer__address`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_55C3CDD39395C3F3` (`customer_id`);

--
-- Индексы таблицы `customer__invoice`
--
ALTER TABLE `customer__invoice`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_C8E8B5169395C3F3` (`customer_id`),
  ADD KEY `IDX_C8E8B51664D218E` (`location_id`);

--
-- Индексы таблицы `customer__invoice_product`
--
ALTER TABLE `customer__invoice_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_4CE9878E2989F1FD` (`invoice_id`),
  ADD KEY `IDX_4CE9878E2AE63FDB` (`share_id`),
  ADD KEY `IDX_4CE9878E4584665A` (`product_id`);

--
-- Индексы таблицы `customer__location`
--
ALTER TABLE `customer__location`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_DBA334B119EB6921` (`client_id`);

--
-- Индексы таблицы `customer__location_workdays`
--
ALTER TABLE `customer__location_workdays`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_A2035B2664D218E` (`location_id`);

--
-- Индексы таблицы `customer__notifies`
--
ALTER TABLE `customer__notifies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customer_emails_unique` (`customer_id`,`notify_type`),
  ADD KEY `IDX_D4DC51699395C3F3` (`customer_id`);

--
-- Индексы таблицы `customer__orders`
--
ALTER TABLE `customer__orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_C1BED319EB6921` (`client_id`),
  ADD KEY `IDX_C1BED32AE63FDB` (`share_id`);

--
-- Индексы таблицы `customer__payments`
--
ALTER TABLE `customer__payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_E0EF26482FC0CB0F` (`transaction_id`),
  ADD KEY `IDX_E0EF26489395C3F3` (`customer_id`);

--
-- Индексы таблицы `customer__payment_method`
--
ALTER TABLE `customer__payment_method`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `customer__product__tag`
--
ALTER TABLE `customer__product__tag`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_FD349E724584665A` (`product_id`),
  ADD KEY `IDX_FD349E7219EB6921` (`client_id`);

--
-- Индексы таблицы `customer__referrals`
--
ALTER TABLE `customer__referrals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_AB286D093CCAA4B7` (`referral_id`),
  ADD UNIQUE KEY `customer_referral_unique` (`customer_id`,`referral_id`),
  ADD KEY `IDX_AB286D099395C3F3` (`customer_id`);

--
-- Индексы таблицы `customer__renewal_views`
--
ALTER TABLE `customer__renewal_views`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_88E36BAB19EB6921` (`client_id`),
  ADD KEY `IDX_88E36BAB9395C3F3` (`customer_id`);

--
-- Индексы таблицы `customer__transactions`
--
ALTER TABLE `customer__transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_D49608E64C3A3BB` (`payment_id`),
  ADD KEY `IDX_D49608E67B61A1F6` (`payment_method`),
  ADD KEY `IDX_D49608E6D7D175C` (`transaction_status`);

--
-- Индексы таблицы `customer__transaction_status`
--
ALTER TABLE `customer__transaction_status`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `customer__vendor`
--
ALTER TABLE `customer__vendor`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_10CC70CBF5B7AF75` (`address_id`),
  ADD KEY `IDX_10CC70CB19EB6921` (`client_id`);

--
-- Индексы таблицы `customer__vendor_contact`
--
ALTER TABLE `customer__vendor_contact`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_F544C542F603EE73` (`vendor_id`);

--
-- Индексы таблицы `customer__vendor_orders`
--
ALTER TABLE `customer__vendor_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_A5D88E9819EB6921` (`client_id`),
  ADD KEY `IDX_A5D88E98F603EE73` (`vendor_id`);

--
-- Индексы таблицы `device__page_views`
--
ALTER TABLE `device__page_views`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_66BAC7EF94A4C7D4` (`device_id`);

--
-- Индексы таблицы `device__promotion_visit`
--
ALTER TABLE `device__promotion_visit`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_80A5FFF2C4663E4` (`page_id`);

--
-- Индексы таблицы `email__auto`
--
ALTER TABLE `email__auto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_A6D2146E19EB6921` (`client_id`);

--
-- Индексы таблицы `email__feedback`
--
ALTER TABLE `email__feedback`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_F3E29E13E92F8F78` (`recipient_id`),
  ADD KEY `IDX_F3E29E139395C3F3` (`customer_id`),
  ADD KEY `IDX_F3E29E132AE63FDB` (`share_id`);

--
-- Индексы таблицы `email__log`
--
ALTER TABLE `email__log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_5D6251BA19EB6921` (`client_id`),
  ADD KEY `IDX_5D6251BAB1254A89` (`automated_id`);

--
-- Индексы таблицы `email__recipient`
--
ALTER TABLE `email__recipient`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customer_email_recipient` (`log_id`,`customer_id`),
  ADD KEY `IDX_892BA88BEA675D86` (`log_id`),
  ADD KEY `IDX_892BA88B9395C3F3` (`customer_id`);

--
-- Индексы таблицы `email__testimonial_recipient`
--
ALTER TABLE `email__testimonial_recipient`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_7DDB49AF9F12C49A` (`affiliate_id`);

--
-- Индексы таблицы `master__email`
--
ALTER TABLE `master__email`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_9C4A37C6B1254A89` (`automated_id`);

--
-- Индексы таблицы `master__email_automated`
--
ALTER TABLE `master__email_automated`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `master__email_recipient`
--
ALTER TABLE `master__email_recipient`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `master_email_recipient` (`email_id`,`client_id`),
  ADD KEY `IDX_8A5C4BC4A832C1C9` (`email_id`),
  ADD KEY `IDX_8A5C4BC419EB6921` (`client_id`);

--
-- Индексы таблицы `master__posts`
--
ALTER TABLE `master__posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_F385F1482B36786B` (`title`),
  ADD KEY `IDX_F385F148C7034EA5` (`thumb_id`);

--
-- Индексы таблицы `media__image`
--
ALTER TABLE `media__image`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `client_image_unique` (`client_id`,`name`),
  ADD KEY `IDX_F37C721D19EB6921` (`client_id`);

--
-- Индексы таблицы `migration_versions`
--
ALTER TABLE `migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Индексы таблицы `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `notification__notify`
--
ALTER TABLE `notification__notify`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_CD5680FCEF1A9D84` (`notification_id`),
  ADD KEY `IDX_CD5680FCA76ED395` (`user_id`);

--
-- Индексы таблицы `pos`
--
ALTER TABLE `pos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_80D9E6AC19EB6921` (`client_id`),
  ADD KEY `IDX_80D9E6AC9395C3F3` (`customer_id`);

--
-- Индексы таблицы `pos__product`
--
ALTER TABLE `pos__product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_EE06AFE041085FAE` (`pos_id`),
  ADD KEY `IDX_EE06AFE04584665A` (`product_id`);

--
-- Индексы таблицы `pos__products`
--
ALTER TABLE `pos__products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_BBEA2BDC19EB6921` (`client_id`),
  ADD KEY `IDX_BBEA2BDCC53D045F` (`image`);

--
-- Индексы таблицы `share`
--
ALTER TABLE `share`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_EF069D5A19EB6921` (`client_id`);

--
-- Индексы таблицы `share__custom`
--
ALTER TABLE `share__custom`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_4EDB5B84A1615E9C` (`share_product_id`),
  ADD KEY `IDX_4EDB5B844584665A` (`product_id`),
  ADD KEY `IDX_4EDB5B842AE63FDB` (`share_id`);

--
-- Индексы таблицы `share__customer`
--
ALTER TABLE `share__customer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_440E06E59395C3F3` (`customer_id`),
  ADD KEY `IDX_440E06E52AE63FDB` (`share_id`),
  ADD KEY `IDX_440E06E55E9E89CB` (`location`);

--
-- Индексы таблицы `share__pickups`
--
ALTER TABLE `share__pickups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_55F08D2B2AE63FDB` (`share_id`);

--
-- Индексы таблицы `share__products`
--
ALTER TABLE `share__products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_768DD2B63B1CE6A3` (`customer_order`),
  ADD KEY `IDX_768DD2B6E36F91D8` (`vendor_order`),
  ADD KEY `IDX_768DD2B64584665A` (`product_id`);

--
-- Индексы таблицы `share__suspended_weeks`
--
ALTER TABLE `share__suspended_weeks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_5A20DD0519EB6921` (`client_id`);

--
-- Индексы таблицы `translation`
--
ALTER TABLE `translation`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `translation_unique` (`key_id`,`locale_id`),
  ADD KEY `IDX_B469456FD145533` (`key_id`),
  ADD KEY `IDX_B469456FE559DFD1` (`locale_id`);

--
-- Индексы таблицы `translation__domain`
--
ALTER TABLE `translation__domain`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `translation_domain_unique` (`domain`);

--
-- Индексы таблицы `translation__key`
--
ALTER TABLE `translation__key`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `translation_key_unique` (`domain_id`,`trans_key`),
  ADD KEY `IDX_EAD911C8115F0EE5` (`domain_id`);

--
-- Индексы таблицы `translation__locale`
--
ALTER TABLE `translation__locale`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `translation_locale_unique` (`code`);

--
-- Индексы таблицы `translation__shared`
--
ALTER TABLE `translation__shared`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `translation_shared_unique` (`locale_id`,`domain_id`),
  ADD KEY `IDX_4BB3EACAE559DFD1` (`locale_id`),
  ADD KEY `IDX_4BB3EACA115F0EE5` (`domain_id`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8D93D649F85E0677` (`username`),
  ADD UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`),
  ADD KEY `IDX_8D93D649E559DFD1` (`locale_id`);

--
-- Индексы таблицы `user__device`
--
ALTER TABLE `user__device`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_A8114F07A76ED395` (`user_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `client`
--
ALTER TABLE `client`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `client__affiliate`
--
ALTER TABLE `client__affiliate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `client__module_access`
--
ALTER TABLE `client__module_access`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `client__posts`
--
ALTER TABLE `client__posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `client__referral`
--
ALTER TABLE `client__referral`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `client__settings`
--
ALTER TABLE `client__settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `client__subscription`
--
ALTER TABLE `client__subscription`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `client__tags`
--
ALTER TABLE `client__tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `client__team`
--
ALTER TABLE `client__team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__address`
--
ALTER TABLE `customer__address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__invoice`
--
ALTER TABLE `customer__invoice`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__invoice_product`
--
ALTER TABLE `customer__invoice_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__location`
--
ALTER TABLE `customer__location`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `customer__location_workdays`
--
ALTER TABLE `customer__location_workdays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT для таблицы `customer__notifies`
--
ALTER TABLE `customer__notifies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__orders`
--
ALTER TABLE `customer__orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__payments`
--
ALTER TABLE `customer__payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__payment_method`
--
ALTER TABLE `customer__payment_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__product__tag`
--
ALTER TABLE `customer__product__tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__referrals`
--
ALTER TABLE `customer__referrals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__renewal_views`
--
ALTER TABLE `customer__renewal_views`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__transactions`
--
ALTER TABLE `customer__transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__transaction_status`
--
ALTER TABLE `customer__transaction_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__vendor`
--
ALTER TABLE `customer__vendor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__vendor_contact`
--
ALTER TABLE `customer__vendor_contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `customer__vendor_orders`
--
ALTER TABLE `customer__vendor_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `device__page_views`
--
ALTER TABLE `device__page_views`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT для таблицы `device__promotion_visit`
--
ALTER TABLE `device__promotion_visit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `email__auto`
--
ALTER TABLE `email__auto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT для таблицы `email__feedback`
--
ALTER TABLE `email__feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `email__log`
--
ALTER TABLE `email__log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `email__recipient`
--
ALTER TABLE `email__recipient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `email__testimonial_recipient`
--
ALTER TABLE `email__testimonial_recipient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `master__email`
--
ALTER TABLE `master__email`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `master__email_automated`
--
ALTER TABLE `master__email_automated`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `master__email_recipient`
--
ALTER TABLE `master__email_recipient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `master__posts`
--
ALTER TABLE `master__posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `media__image`
--
ALTER TABLE `media__image`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `notification__notify`
--
ALTER TABLE `notification__notify`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `pos`
--
ALTER TABLE `pos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `pos__product`
--
ALTER TABLE `pos__product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `pos__products`
--
ALTER TABLE `pos__products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `share`
--
ALTER TABLE `share`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `share__custom`
--
ALTER TABLE `share__custom`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `share__customer`
--
ALTER TABLE `share__customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `share__pickups`
--
ALTER TABLE `share__pickups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `share__products`
--
ALTER TABLE `share__products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `share__suspended_weeks`
--
ALTER TABLE `share__suspended_weeks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `translation`
--
ALTER TABLE `translation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `translation__domain`
--
ALTER TABLE `translation__domain`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `translation__key`
--
ALTER TABLE `translation__key`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `translation__locale`
--
ALTER TABLE `translation__locale`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `translation__shared`
--
ALTER TABLE `translation__shared`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `user__device`
--
ALTER TABLE `user__device`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `client__affiliate`
--
ALTER TABLE `client__affiliate`
  ADD CONSTRAINT `FK_84B2399319EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `client__module_access`
--
ALTER TABLE `client__module_access`
  ADD CONSTRAINT `FK_22F969DA19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `client__posts`
--
ALTER TABLE `client__posts`
  ADD CONSTRAINT `FK_57C31DD519EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_57C31DD5C7034EA5` FOREIGN KEY (`thumb_id`) REFERENCES `media__image` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `client__referral`
--
ALTER TABLE `client__referral`
  ADD CONSTRAINT `FK_B6E7086F19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `FK_B6E7086F9F12C49A` FOREIGN KEY (`affiliate_id`) REFERENCES `client__affiliate` (`id`);

--
-- Ограничения внешнего ключа таблицы `client__settings`
--
ALTER TABLE `client__settings`
  ADD CONSTRAINT `FK_20A535AA19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `client__subscription`
--
ALTER TABLE `client__subscription`
  ADD CONSTRAINT `FK_8E2B3C4E19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `client__tags`
--
ALTER TABLE `client__tags`
  ADD CONSTRAINT `FK_91F4788A19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `client__team`
--
ALTER TABLE `client__team`
  ADD CONSTRAINT `FK_3AA84AB319EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `FK_3AA84AB3A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `FK_81398E0919EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__address`
--
ALTER TABLE `customer__address`
  ADD CONSTRAINT `FK_55C3CDD39395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__invoice`
--
ALTER TABLE `customer__invoice`
  ADD CONSTRAINT `FK_C8E8B51664D218E` FOREIGN KEY (`location_id`) REFERENCES `customer__location` (`id`),
  ADD CONSTRAINT `FK_C8E8B5169395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__invoice_product`
--
ALTER TABLE `customer__invoice_product`
  ADD CONSTRAINT `FK_4CE9878E2989F1FD` FOREIGN KEY (`invoice_id`) REFERENCES `customer__invoice` (`id`),
  ADD CONSTRAINT `FK_4CE9878E2AE63FDB` FOREIGN KEY (`share_id`) REFERENCES `share` (`id`),
  ADD CONSTRAINT `FK_4CE9878E4584665A` FOREIGN KEY (`product_id`) REFERENCES `pos__products` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__location`
--
ALTER TABLE `customer__location`
  ADD CONSTRAINT `FK_DBA334B119EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__location_workdays`
--
ALTER TABLE `customer__location_workdays`
  ADD CONSTRAINT `FK_A2035B2664D218E` FOREIGN KEY (`location_id`) REFERENCES `customer__location` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__notifies`
--
ALTER TABLE `customer__notifies`
  ADD CONSTRAINT `FK_D4DC51699395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__orders`
--
ALTER TABLE `customer__orders`
  ADD CONSTRAINT `FK_C1BED319EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_C1BED32AE63FDB` FOREIGN KEY (`share_id`) REFERENCES `share` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `customer__payments`
--
ALTER TABLE `customer__payments`
  ADD CONSTRAINT `FK_E0EF26482FC0CB0F` FOREIGN KEY (`transaction_id`) REFERENCES `customer__transactions` (`id`),
  ADD CONSTRAINT `FK_E0EF26489395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__product__tag`
--
ALTER TABLE `customer__product__tag`
  ADD CONSTRAINT `FK_FD349E7219EB6921` FOREIGN KEY (`client_id`) REFERENCES `client__tags` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_FD349E724584665A` FOREIGN KEY (`product_id`) REFERENCES `pos__products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `customer__referrals`
--
ALTER TABLE `customer__referrals`
  ADD CONSTRAINT `FK_AB286D093CCAA4B7` FOREIGN KEY (`referral_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `FK_AB286D099395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__renewal_views`
--
ALTER TABLE `customer__renewal_views`
  ADD CONSTRAINT `FK_88E36BAB19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `FK_88E36BAB9395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__transactions`
--
ALTER TABLE `customer__transactions`
  ADD CONSTRAINT `FK_D49608E64C3A3BB` FOREIGN KEY (`payment_id`) REFERENCES `customer__payments` (`id`),
  ADD CONSTRAINT `FK_D49608E67B61A1F6` FOREIGN KEY (`payment_method`) REFERENCES `customer__payment_method` (`id`),
  ADD CONSTRAINT `FK_D49608E6D7D175C` FOREIGN KEY (`transaction_status`) REFERENCES `customer__transaction_status` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__vendor`
--
ALTER TABLE `customer__vendor`
  ADD CONSTRAINT `FK_10CC70CB19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `FK_10CC70CBF5B7AF75` FOREIGN KEY (`address_id`) REFERENCES `customer__address` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__vendor_contact`
--
ALTER TABLE `customer__vendor_contact`
  ADD CONSTRAINT `FK_F544C542F603EE73` FOREIGN KEY (`vendor_id`) REFERENCES `customer__vendor` (`id`);

--
-- Ограничения внешнего ключа таблицы `customer__vendor_orders`
--
ALTER TABLE `customer__vendor_orders`
  ADD CONSTRAINT `FK_A5D88E9819EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_A5D88E98F603EE73` FOREIGN KEY (`vendor_id`) REFERENCES `customer__vendor` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `device__page_views`
--
ALTER TABLE `device__page_views`
  ADD CONSTRAINT `FK_66BAC7EF94A4C7D4` FOREIGN KEY (`device_id`) REFERENCES `user__device` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `device__promotion_visit`
--
ALTER TABLE `device__promotion_visit`
  ADD CONSTRAINT `FK_80A5FFF2C4663E4` FOREIGN KEY (`page_id`) REFERENCES `device__page_views` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `email__auto`
--
ALTER TABLE `email__auto`
  ADD CONSTRAINT `FK_A6D2146E19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `email__feedback`
--
ALTER TABLE `email__feedback`
  ADD CONSTRAINT `FK_F3E29E132AE63FDB` FOREIGN KEY (`share_id`) REFERENCES `share` (`id`),
  ADD CONSTRAINT `FK_F3E29E139395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `FK_F3E29E13E92F8F78` FOREIGN KEY (`recipient_id`) REFERENCES `email__recipient` (`id`);

--
-- Ограничения внешнего ключа таблицы `email__log`
--
ALTER TABLE `email__log`
  ADD CONSTRAINT `FK_5D6251BA19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `FK_5D6251BAB1254A89` FOREIGN KEY (`automated_id`) REFERENCES `email__auto` (`id`);

--
-- Ограничения внешнего ключа таблицы `email__recipient`
--
ALTER TABLE `email__recipient`
  ADD CONSTRAINT `FK_892BA88B9395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `FK_892BA88BEA675D86` FOREIGN KEY (`log_id`) REFERENCES `email__log` (`id`);

--
-- Ограничения внешнего ключа таблицы `email__testimonial_recipient`
--
ALTER TABLE `email__testimonial_recipient`
  ADD CONSTRAINT `FK_7DDB49AF9F12C49A` FOREIGN KEY (`affiliate_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `master__email`
--
ALTER TABLE `master__email`
  ADD CONSTRAINT `FK_9C4A37C6B1254A89` FOREIGN KEY (`automated_id`) REFERENCES `master__email_automated` (`id`);

--
-- Ограничения внешнего ключа таблицы `master__email_recipient`
--
ALTER TABLE `master__email_recipient`
  ADD CONSTRAINT `FK_8A5C4BC419EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  ADD CONSTRAINT `FK_8A5C4BC4A832C1C9` FOREIGN KEY (`email_id`) REFERENCES `master__email` (`id`);

--
-- Ограничения внешнего ключа таблицы `master__posts`
--
ALTER TABLE `master__posts`
  ADD CONSTRAINT `FK_F385F148C7034EA5` FOREIGN KEY (`thumb_id`) REFERENCES `media__image` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `media__image`
--
ALTER TABLE `media__image`
  ADD CONSTRAINT `FK_F37C721D19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `notification__notify`
--
ALTER TABLE `notification__notify`
  ADD CONSTRAINT `FK_CD5680FCA76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `FK_CD5680FCEF1A9D84` FOREIGN KEY (`notification_id`) REFERENCES `notification` (`id`);

--
-- Ограничения внешнего ключа таблицы `pos`
--
ALTER TABLE `pos`
  ADD CONSTRAINT `FK_80D9E6AC19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_80D9E6AC9395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `pos__product`
--
ALTER TABLE `pos__product`
  ADD CONSTRAINT `FK_EE06AFE041085FAE` FOREIGN KEY (`pos_id`) REFERENCES `pos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_EE06AFE04584665A` FOREIGN KEY (`product_id`) REFERENCES `pos__products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `pos__products`
--
ALTER TABLE `pos__products`
  ADD CONSTRAINT `FK_BBEA2BDC19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_BBEA2BDCC53D045F` FOREIGN KEY (`image`) REFERENCES `media__image` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `share`
--
ALTER TABLE `share`
  ADD CONSTRAINT `FK_EF069D5A19EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`);

--
-- Ограничения внешнего ключа таблицы `share__custom`
--
ALTER TABLE `share__custom`
  ADD CONSTRAINT `FK_4EDB5B842AE63FDB` FOREIGN KEY (`share_id`) REFERENCES `share__customer` (`id`),
  ADD CONSTRAINT `FK_4EDB5B844584665A` FOREIGN KEY (`product_id`) REFERENCES `pos__products` (`id`),
  ADD CONSTRAINT `FK_4EDB5B84A1615E9C` FOREIGN KEY (`share_product_id`) REFERENCES `share__products` (`id`);

--
-- Ограничения внешнего ключа таблицы `share__customer`
--
ALTER TABLE `share__customer`
  ADD CONSTRAINT `FK_440E06E52AE63FDB` FOREIGN KEY (`share_id`) REFERENCES `share` (`id`),
  ADD CONSTRAINT `FK_440E06E55E9E89CB` FOREIGN KEY (`location`) REFERENCES `customer__location` (`id`),
  ADD CONSTRAINT `FK_440E06E59395C3F3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `share__pickups`
--
ALTER TABLE `share__pickups`
  ADD CONSTRAINT `FK_55F08D2B2AE63FDB` FOREIGN KEY (`share_id`) REFERENCES `share__customer` (`id`);

--
-- Ограничения внешнего ключа таблицы `share__products`
--
ALTER TABLE `share__products`
  ADD CONSTRAINT `FK_768DD2B63B1CE6A3` FOREIGN KEY (`customer_order`) REFERENCES `customer__orders` (`id`),
  ADD CONSTRAINT `FK_768DD2B64584665A` FOREIGN KEY (`product_id`) REFERENCES `pos__products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_768DD2B6E36F91D8` FOREIGN KEY (`vendor_order`) REFERENCES `customer__vendor_orders` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `share__suspended_weeks`
--
ALTER TABLE `share__suspended_weeks`
  ADD CONSTRAINT `FK_5A20DD0519EB6921` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `translation`
--
ALTER TABLE `translation`
  ADD CONSTRAINT `FK_B469456FD145533` FOREIGN KEY (`key_id`) REFERENCES `translation__key` (`id`),
  ADD CONSTRAINT `FK_B469456FE559DFD1` FOREIGN KEY (`locale_id`) REFERENCES `translation__locale` (`id`);

--
-- Ограничения внешнего ключа таблицы `translation__key`
--
ALTER TABLE `translation__key`
  ADD CONSTRAINT `FK_EAD911C8115F0EE5` FOREIGN KEY (`domain_id`) REFERENCES `translation__domain` (`id`);

--
-- Ограничения внешнего ключа таблицы `translation__shared`
--
ALTER TABLE `translation__shared`
  ADD CONSTRAINT `FK_4BB3EACA115F0EE5` FOREIGN KEY (`domain_id`) REFERENCES `translation__domain` (`id`),
  ADD CONSTRAINT `FK_4BB3EACAE559DFD1` FOREIGN KEY (`locale_id`) REFERENCES `translation__locale` (`id`);

--
-- Ограничения внешнего ключа таблицы `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `FK_8D93D649E559DFD1` FOREIGN KEY (`locale_id`) REFERENCES `translation__locale` (`id`);

--
-- Ограничения внешнего ключа таблицы `user__device`
--
ALTER TABLE `user__device`
  ADD CONSTRAINT `FK_A8114F07A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
