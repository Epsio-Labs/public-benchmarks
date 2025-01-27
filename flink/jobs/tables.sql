SET 'table.exec.sink.not-null-enforcer' = 'DROP';

CREATE TABLE store_sales (
    ss_item_sk INT,
    ss_sold_date_sk INT,
    ss_sold_time_sk INT,
    ss_store_sk INT,
    ss_customer_sk INT,
    ss_hdemo_sk INT,
    ss_wholesale_cost     DECIMAL(7, 2),
    ss_list_price         DECIMAL(7, 2),
    ss_sales_price        DECIMAL(7, 2),
    ss_ext_discount_amt   DECIMAL(7, 2),
    ss_ext_sales_price    DECIMAL(7, 2),
    ss_ext_wholesale_cost DECIMAL(7, 2),
    ss_ext_list_price     DECIMAL(7, 2),
    ss_ext_tax            DECIMAL(7, 2),
    ss_coupon_amt         DECIMAL(7, 2),
    ss_net_paid           DECIMAL(7, 2),
    ss_net_paid_inc_tax   DECIMAL(7, 2),
    ss_net_profit         DECIMAL(7, 2)
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.store_sales',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = '1',
    'properties.metadata.max.age.ms' = '1000',
    'format' = 'debezium-avro-confluent',
    'scan.startup.mode' = 'earliest-offset',
    'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);

CREATE TABLE item (
    i_item_sk INT,
    i_manufact_id INT,
    i_brand_id INT,
    i_brand STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.item',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = '1',
    'properties.metadata.max.age.ms' = '1000',
    'format' = 'debezium-avro-confluent',
    'scan.startup.mode' = 'earliest-offset',
    'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);

CREATE TABLE date_dim (
    d_date_sk INT,
    d_year INT,
    d_moy INT
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.date_dim',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = '1',
    'properties.metadata.max.age.ms' = '1000',
    'format' = 'debezium-avro-confluent',
    'scan.startup.mode' = 'earliest-offset',
    'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);


CREATE TABLE household_demographics (
    hd_demo_sk INT,
    hd_dep_count INT
) WITH (
  'connector' = 'kafka',
  'topic' = 'dbserver1.public.household_demographics',
  'properties.bootstrap.servers' = 'kafka:9092',
  'properties.group.id' = '1',
  'properties.metadata.max.age.ms' = '1000',
  'format' = 'debezium-avro-confluent',
  'scan.startup.mode' = 'earliest-offset',
  'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);

CREATE TABLE time_dim (
    t_time_sk INT,
    t_hour INT,
    t_minute INT
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.time_dim',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = '1',
    'properties.metadata.max.age.ms' = '1000',
    'format' = 'debezium-avro-confluent',
    'scan.startup.mode' = 'earliest-offset',
    'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);

CREATE TABLE store (
    s_store_sk INT,
    s_store_name STRING
) WITH (
  'connector' = 'kafka',
  'topic' = 'dbserver1.public.store',
  'properties.bootstrap.servers' = 'kafka:9092',
  'properties.group.id' = '1',
  'properties.metadata.max.age.ms' = '1000',
  'format' = 'debezium-avro-confluent',
  'scan.startup.mode' = 'earliest-offset',
  'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);

CREATE TABLE customer (
    c_customer_sk INT,
    c_customer_id STRING,
    c_first_name STRING,
    c_last_name STRING,
    c_preferred_cust_flag STRING,
    c_birth_country STRING,
    c_login STRING,
    c_email_address STRING
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.customer',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = '1',
    'properties.metadata.max.age.ms' = '1000',
    'format' = 'debezium-avro-confluent',
    'scan.startup.mode' = 'earliest-offset',
    'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);


CREATE TABLE catalog_sales (
    cs_sold_date_sk INT,
    cs_bill_customer_sk INT,
    cs_ext_list_price DECIMAL(7,2),
    cs_ext_wholesale_cost DECIMAL(7,2),
    cs_ext_discount_amt DECIMAL(7,2),
    cs_ext_sales_price DECIMAL(7,2)
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.catalog_sales',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = '1',
    'properties.metadata.max.age.ms' = '1000',
    'format' = 'debezium-avro-confluent',
    'scan.startup.mode' = 'earliest-offset',
    'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);

CREATE TABLE web_sales (
    ws_sold_date_sk INT,
    ws_bill_customer_sk INT,
    ws_ext_list_price DECIMAL(7,2),
    ws_ext_wholesale_cost DECIMAL(7,2),
    ws_ext_discount_amt DECIMAL(7,2),
    ws_ext_sales_price DECIMAL(7,2)
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbserver1.public.web_sales',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = '1',
    'properties.metadata.max.age.ms' = '1000',
    'format' = 'debezium-avro-confluent',
    'scan.startup.mode' = 'earliest-offset',
    'debezium-avro-confluent.url' = 'http://schema-registry:8081'
);
