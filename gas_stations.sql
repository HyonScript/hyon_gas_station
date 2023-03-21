CREATE TABLE IF NOT EXISTS `gas_stations` (
  `id` int(11) NOT NULL,
  `owner` varchar(46) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `fuel_price` int(11) NOT NULL DEFAULT 0,
  `capacity` int(11) NOT NULL DEFAULT 0,
  `max_capacity` int(11) NOT NULL DEFAULT 0,
  `balance` int(11) NOT NULL DEFAULT 0,
  `petrol_can_price` int(11) NOT NULL DEFAULT 0,
  `petrol_can_stock` int(11) NOT NULL DEFAULT 0,
  `petrol_can_max_stock` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;