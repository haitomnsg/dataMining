CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

CREATE TABLE dim_location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(50)
);

CREATE TABLE dim_time (
    time_id INT PRIMARY KEY,
    month VARCHAR(20),
    year INT
);

CREATE TABLE fact_sales (
    product_id INT,
    location_id INT,
    time_id INT,
    amount NUMERIC(10,2),

    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
    FOREIGN KEY (time_id) REFERENCES dim_time(time_id)
);

INSERT INTO dim_product VALUES
(1, 'Laptop'),
(2, 'Mobile'),
(3, 'Tablet'),
(4, 'Headphones'),
(5, 'Smartwatch');

INSERT INTO dim_location VALUES
(1, 'Kathmandu'),
(2, 'Pokhara'),
(3, 'Lalitpur'),
(4, 'Biratnagar'),
(5, 'Butwal');

INSERT INTO dim_time VALUES
(1, 'January', 2024),
(2, 'February', 2024),
(3, 'March', 2024),
(4, 'January', 2025),
(5, 'February', 2025);

INSERT INTO fact_sales VALUES
(1, 1, 1, 120000),
(2, 1, 1, 80000),
(1, 2, 2, 100000),
(3, 3, 3, 45000),
(2, 2, 4, 90000),
(4, 4, 4, 30000),
(5, 5, 5, 40000);

-- Total sales by product
SELECT 
    p.product_name,
    SUM(f.amount) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name;

-- Roll-up means going from detailed time (month) to higher level (year).
SELECT 
    t.year,
    SUM(f.amount) AS total_sales
FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.year
ORDER BY t.year;

-- Slice by a specific location (example: Kathmandu)
SELECT 
    p.product_name,
    t.year,
    SUM(f.amount) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_time t ON f.time_id = t.time_id
JOIN dim_location l ON f.location_id = l.location_id
WHERE l.location_name = 'Kathmandu'
GROUP BY p.product_name, t.year;

-- Dice by specific product (Mobile) and year (2024)
SELECT 
    l.location_name,
    SUM(f.amount) AS total_sales
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_time t ON f.time_id = t.time_id
JOIN dim_location l ON f.location_id = l.location_id
WHERE p.product_name = 'Mobile'
  AND t.year = 2024
GROUP BY l.location_name;