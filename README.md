# SQL Data Engineering Projects

This repository contains hands-on **SQL and data engineering projects** focused on working with real-world data, building analytical pipelines, designing data models, and transforming raw data into useful datasets for analysis.

The projects demonstrate practical experience with **SQL, DuckDB, data analysis, ETL pipelines, dimensional modeling, data warehouses, data marts, Git, and cloud-based data sources**.

> Click on any project below to explore the SQL, architecture, documentation, and results.

---

## Projects

### 📊 [1. EDA](./1_EDA/) — Data Engineer Job Market Analysis

![Project 1 Overview](/Images/1_1Project1_EDA.png)

Exploratory data analysis of the Data Engineer job market using SQL.

The project analyzes job-posting data to identify:

* Most in-demand Data Engineering skills
* Highest-paying skills
* Skills with the best combination of salary and demand
* High-paying Data Engineer positions
* Companies with strong hiring activity
* Company salary and skill trends

**Tools & Skills:** SQL, DuckDB, MotherDuck, joins, aggregations, CTEs, filtering, and analytical querying.

➡️ [View Project 1](./1_EDA/)

---

### 🏗️ [2. Data Warehouse & Mart Build](./2_DW_Mart_Build/) — End-to-End ETL Pipeline

![Project 2 Data Pipeline](/Images/1_2_Project2_Data_Pipeline.png)

An end-to-end data engineering pipeline that transforms raw job-posting CSV files from Google Cloud Storage into a structured DuckDB data warehouse and multiple analytical data marts.

The project includes:

* Structured data warehouse with fact, dimension, and bridge tables
* Flat Mart for simplified analytical queries
* Skills Mart for monthly skill-demand analysis
* Priority Mart with incremental updates using SQL `MERGE`
* Company Mart for hiring, salary, and posting-characteristic analysis
* Master SQL build script for automated pipeline execution
* Data validation and repeatable pipeline design

**Tools & Skills:** SQL, DuckDB, Google Cloud Storage, ETL, dimensional modeling, data marts, bridge tables, incremental processing, arrays/structs, Git, and GitHub.

➡️ [View Project 2](./2_DW_Mart_Build/)

---

## 🧰 Core Technologies

* **SQL**
* **DuckDB / MotherDuck**
* **Google Cloud Storage**
* **Data Warehousing**
* **Dimensional Modeling**
* **ETL & Data Transformation**
* **Git & GitHub**
* **VS Code / Git Bash**
