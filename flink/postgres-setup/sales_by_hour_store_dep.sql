CREATE TABLE sales_by_hour_store_dep (
    t_hour INT,
    half_hour TEXT,
    s_store_name TEXT,
    hd_dep_count INT,
    sales_count BIGINT,
    PRIMARY KEY (t_hour, half_hour, s_store_name, hd_dep_count)
);



CREATE TABLE sales_by_hour_store_dep_real AS
SELECT * FROM
(select t_hour,
        case when t_minute >= 0 and t_minute <= 29 then 'first'
             else 'second' end as half_hour,
        s_store_name,
        hd_dep_count,
        count(*) as sales_count
 from store_sales
     inner join household_demographics
         on ss_hdemo_sk = hd_demo_sk
     inner join time_dim
         on ss_sold_time_sk = t_time_sk
     inner join store
         on ss_store_sk = s_store_sk
 group by t_hour, half_hour, hd_dep_count, s_store_name ) a
WHERE t_hour is not NULL and half_hour is not null AND hd_dep_count is not Null AND s_store_name is not null
;