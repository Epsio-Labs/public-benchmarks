CREATE TABLE sales_by_hour_store_dep (
    t_hour INT,
    half_hour STRING,
    s_store_name STRING,
    hd_dep_count INT,
    sales_count BIGINT,
    PRIMARY KEY (t_hour, half_hour, s_store_name, hd_dep_count) NOT ENFORCED
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://10.208.0.15:5432/tpcds_sf${SCALE_FACTOR}',
    'table-name' = 'sales_by_hour_store_dep',
    'username' = 'postgres',
    'password' = 'postgres',
    'sink.buffer-flush.max-rows' = '500000',
    'sink.buffer-flush.interval' = '30s'
);


INSERT INTO sales_by_hour_store_dep
select t_hour,
       case when t_minute >= 0 and t_minute <= 29 then 'first'
            else 'second' end as half_hour,
       s_store_name,
       hd_dep_count,
       count(*)
from store_sales
    inner join household_demographics
        on ss_hdemo_sk = hd_demo_sk
    inner join time_dim
        on ss_sold_time_sk = t_time_sk
    inner join store
        on ss_store_sk = s_store_sk
group by t_hour, case when t_minute >= 0 and t_minute <= 29 then 'first'
                             else 'second' end, hd_dep_count, s_store_name;
