CREATE TABLE sales_items (
    i_manufact_id BIGINT,
    d_year BIGINT,
    d_moy BIGINT,
    brand_id BIGINT,
    brand STRING,
    sum_agg BIGINT,
    max_ss_ext_sales_price BIGINT,
    PRIMARY KEY (i_manufact_id, d_year, d_moy, brand, brand_id) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://10.208.0.15:5432/tpcds_sf${SCALE_FACTOR}',
    'table-name' = 'sales_items',
    'username' = 'postgres',
    'password' = 'postgres',
    'sink.buffer-flush.max-rows' = '500000',
    'sink.buffer-flush.interval' = '30s'
);


INSERT INTO sales_items
SELECT
    item.i_manufact_id,
    dt.d_year,
    dt.d_moy,
    item.i_brand_id AS brand_id,
    item.i_brand AS brand,
    SUM(CAST(FLOOR(ss_ext_sales_price) AS BIGINT)) AS sum_agg,
    MAX(CAST(FLOOR(ss_ext_sales_price) AS BIGINT)) AS max_ss_ext_sales_price
FROM date_dim AS dt
JOIN store_sales AS ss ON dt.d_date_sk = ss.ss_sold_date_sk
JOIN item ON ss.ss_item_sk = item.i_item_sk
GROUP BY i_manufact_id, dt.d_year, dt.d_moy, item.i_brand, item.i_brand_id;
