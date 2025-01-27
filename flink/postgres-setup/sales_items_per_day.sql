CREATE TABLE sales_items_real AS
SELECT * FROM
(SELECT
    item.i_manufact_id,
    dt.d_year,
    dt.d_moy,
    item.i_brand_id AS brand_id,
    item.i_brand AS brand,
    SUM(FLOOR(ss_ext_sales_price)) sum_agg,
    max(FLOOR(ss_ext_sales_price)) max_ss_ext_sales_price
FROM date_dim AS dt
JOIN store_sales AS ss ON dt.d_date_sk = ss.ss_sold_date_sk
JOIN item ON ss.ss_item_sk = item.i_item_sk
group by i_manufact_id, dt.d_year, dt.d_moy, item.i_brand, item.i_brand_id  ) a
WHERE brand is not NULL and brand_id is not null AND i_manufact_id is not Null
;

CREATE TABLE sales_items (
    i_manufact_id BIGINT,
    d_year BIGINT,
    d_moy BIGINT,
    brand_id BIGINT,
    brand VARCHAR(50),
    sum_agg BIGINT,
    max_ss_ext_sales_price BIGINT,
    PRIMARY KEY (i_manufact_id, d_year, d_moy, brand, brand_id)
);


