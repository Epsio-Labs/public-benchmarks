CREATE TABLE sales_trends (
    first_year INT,
    second_year INT,
    customer_id VARCHAR NOT NULL,
    customer_first_name VARCHAR,
    customer_last_name VARCHAR,
    customer_email_address VARCHAR,
    PRIMARY KEY (first_year, second_year, customer_id)
);

CREATE TABLE sales_trends_real AS with year_total as (
                                      select c_customer_id customer_id
                                         ,c_first_name customer_first_name
                                         ,c_last_name customer_last_name
                                         ,c_preferred_cust_flag customer_preferred_cust_flag
                                         ,c_birth_country customer_birth_country
                                         ,c_login customer_login
                                         ,c_email_address customer_email_address
                                         ,d_year dyear
                                         ,sum(((ss_ext_list_price-ss_ext_wholesale_cost-ss_ext_discount_amt)+ss_ext_sales_price)/2) year_total
                                         ,'s' sale_type
                                   from customer
                                       join store_sales on c_customer_sk = ss_customer_sk
                                       join date_dim on ss_sold_date_sk = d_date_sk
                                   group by c_customer_id
                                           ,c_first_name
                                           ,c_last_name
                                           ,c_preferred_cust_flag
                                           ,c_birth_country
                                           ,c_login
                                           ,c_email_address
                                           ,d_year
                                   union all
                                   select c_customer_id customer_id
                                         ,c_first_name customer_first_name
                                         ,c_last_name customer_last_name
                                         ,c_preferred_cust_flag customer_preferred_cust_flag
                                         ,c_birth_country customer_birth_country
                                         ,c_login customer_login
                                         ,c_email_address customer_email_address
                                         ,d_year dyear
                                         ,sum((((cs_ext_list_price-cs_ext_wholesale_cost-cs_ext_discount_amt)+cs_ext_sales_price)/2) ) year_total
                                         ,'c' sale_type
                                   from customer
                                       join catalog_sales on c_customer_sk = cs_bill_customer_sk
                                       join date_dim on cs_sold_date_sk = d_date_sk
                                   group by c_customer_id
                                           ,c_first_name
                                           ,c_last_name
                                           ,c_preferred_cust_flag
                                           ,c_birth_country
                                           ,c_login
                                           ,c_email_address
                                           ,d_year
                                  union all
                                   select c_customer_id customer_id
                                         ,c_first_name customer_first_name
                                         ,c_last_name customer_last_name
                                         ,c_preferred_cust_flag customer_preferred_cust_flag
                                         ,c_birth_country customer_birth_country
                                         ,c_login customer_login
                                         ,c_email_address customer_email_address
                                         ,d_year dyear
                                         ,sum((((ws_ext_list_price-ws_ext_wholesale_cost-ws_ext_discount_amt)+ws_ext_sales_price)/2) ) year_total
                                         ,'w' sale_type
                                   from customer
                                       join web_sales on c_customer_sk = ws_bill_customer_sk
                                       join date_dim on ws_sold_date_sk = d_date_sk
                                   group by c_customer_id
                                           ,c_first_name
                                           ,c_last_name
                                           ,c_preferred_cust_flag
                                           ,c_birth_country
                                           ,c_login
                                           ,c_email_address
                                           ,d_year)
                                  select
                                                    t_s_firstyear.dyear as first_year,
                                                    t_s_firstyear.dyear + 1 as second_year,
                                                    t_s_secyear.customer_id
                                                   ,t_s_secyear.customer_first_name
                                                   ,t_s_secyear.customer_last_name
                                                   ,t_s_secyear.customer_email_address
                                   from year_total t_s_firstyear
                                       join year_total t_s_secyear on t_s_secyear.customer_id = t_s_firstyear.customer_id
                                                                               and t_s_secyear.dyear = t_s_firstyear.dyear + 1
                                                                               and t_s_secyear.sale_type = 's'
                                       join year_total t_c_firstyear on t_s_firstyear.customer_id = t_c_firstyear.customer_id
                                                                                 and t_c_firstyear.dyear = t_s_firstyear.dyear
                                                                                 and t_c_firstyear.sale_type = 'c'
                                       join year_total t_c_secyear on t_s_firstyear.customer_id = t_c_secyear.customer_id
                                                                               and t_c_secyear.dyear = t_s_firstyear.dyear + 1
                                                                               and t_c_secyear.sale_type = 'c'
                                       join year_total t_w_firstyear on t_s_firstyear.customer_id = t_w_firstyear.customer_id
                                                                                 and t_w_firstyear.dyear = t_s_firstyear.dyear
                                                                                 and t_w_firstyear.sale_type = 'w'
                                       join year_total t_w_secyear on t_s_firstyear.customer_id = t_w_secyear.customer_id
                                                                               and t_w_secyear.dyear = t_s_firstyear.dyear + 1
                                                                               and t_w_secyear.sale_type = 'w'
                                   where t_s_firstyear.sale_type = 's'
                                     and t_s_firstyear.year_total > 0
                                     and t_c_firstyear.year_total > 0
                                     and t_w_firstyear.year_total > 0
                                     and case when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total else null end
                                             > case when t_s_firstyear.year_total > 0 then t_s_secyear.year_total / t_s_firstyear.year_total else null end
                                     and case when t_c_firstyear.year_total > 0 then t_c_secyear.year_total / t_c_firstyear.year_total else null end
                                             > case when t_w_firstyear.year_total > 0 then t_w_secyear.year_total / t_w_firstyear.year_total else null end;