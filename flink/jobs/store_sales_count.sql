CREATE TABLE store_sales_count (
    id BIGINT,
    total_count BIGINT,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://10.208.0.15:5432/tpcds_sf${SCALE_FACTOR}',
    'table-name' = 'store_sales_count',
    'username' = 'postgres',
    'password' = 'postgres',
    'sink.buffer-flush.max-rows' = '500000',
    'sink.buffer-flush.interval' = '30s'
);


INSERT INTO store_sales_count
SELECT 1, count(*) as total_count FROM store_sales;
