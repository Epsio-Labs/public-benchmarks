# Flink Benchmark Guide

This guide walks you through the process of benchmarking using Flink with the TPC-DS dataset. We'll cover starting up Flink, setting up Debezium for CDC (Change Data Capture), and running a Flink job.

---

## Step 1: Generate the TPC-DS Dataset

The first step is to generate the TPC-DS dataset locally. Use tools such as the tpcds toolkit to generate the dataset (https://github.com/gregrahn/tpcds-kit).

---

## Step 2: Start Flink
Run `docker compose up -d` in the `flink` directory.

---

## Step 3: Add Debezium for Change Data Capture (CDC)

Debezium is used to capture changes in the database and stream them into Kafka. Follow the steps below to configure and start the Debezium PostgreSQL connector:

### Configuration

Execute the following curl command to register the connector (replace the IP with your IP, and set the SCALE_FACTOR env variable):

```bash
curl -X POST -H "Content-Type: application/json" -d "{
    \\"name\\": \\"postgres-connector\\",
    \\"config\\": {
        \\"connector.class\\": \\"io.debezium.connector.postgresql.PostgresConnector\\",
        \\"database.hostname\\": \\"<IP>\\",
        \\"database.port\\": \\"5432\\",
        \\"database.user\\": \\"postgres\\",
        \\"database.password\\": \\"postgres\\",
        \\"database.dbname\\": \\"tpcds_sf${SCALE_FACTOR}\\",
        \\"database.server.name\\": \\"dbserver1\\",
        \\"table.include.list\\": \\"public.item,public.date_dim,public.household_demographics,public.time_dim,public.store,public.customer,public.catalog_sales,public.web_sales,public.store_sales\\",
        \\"plugin.name\\": \\"pgoutput\\",
        \\"slot.name\\": \\"debezium_slot\\",
        \\"snapshot.mode\\": \\"initial\\",
        \\"topic.prefix\\": \\"dbserver1\\",
        \\"heartbeat.interval.ms\\": \\"10000\\",
        \\"key.converter\\": \\"io.confluent.connect.avro.AvroConverter\\",
        \\"value.converter\\": \\"io.confluent.connect.avro.AvroConverter\\",
        \\"key.converter.schema.registry.url\\": \\"http://schema-registry:8081\\",
        \\"value.converter.schema.registry.url\\": \\"http://schema-registry:8081\\"
    }
}" http://localhost:8083/connectors
```

## Step 4: Create the relevant tables in your Postgres sink

Take the relevant SQL for the job you want to run in postgres-setup and run it on your local Postgres. 

## Step 5: Start the Flink Job

Run the Flink job using the SQL Client. Replace <your_job>.sql with the appropriate job file name:

```bash
docker exec flink-flink-jobmanager-1 ./bin/sql-client.sh -Dexecution.variable.SCALE_FACTOR=<SCALE_FACTOR> -f /data/<your_job>.sql
```

---