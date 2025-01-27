CREATE TABLE if not exists store_sales_count_real AS
SELECT 1, count(*) as total_count FROM store_sales;

create table IF NOT exists store_sales_count
(
    id          serial
        primary key,
    total_count bigint
);


TRUNCATE store_sales_count;