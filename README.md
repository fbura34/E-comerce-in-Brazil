# E-comerce in Brazil
The aim of this project is to create a multidimensional data model that will be analyzed through a tabular model in PowerBI. The domain of this project is e-commerce in Brazil, focusing on the retail segment of an online sales platform. 
The dataset covers various aspects of the platform's operations, including customer orders, product listings, 
payments, and shipping price. It provides a detailed view of transactions between businesses and consumers, 
capturing data such as order timestamps, product details, customer locations, payment methods, and shipping 
information. The main goals of analyzing this dataset are to compare revenue across different periods, identify 
top-selling products, and evaluate products with growth potential. These insights will help create effective 
marketing strategies, optimize operations, and improve customer satisfaction in the competitive e-commerce 
market.

E-commerce Data Warehouse Project - Brazil Sales
This project involves building a data warehouse for analyzing e-commerce sales in Brazil. The objective is to enable insightful analysis of customer behaviors, sales trends, product performance, and shipping costs to support strategic decisions in marketing, sales, and logistics.

Project Overview
This data warehouse project consists of three main parts:

Project Proposal and Initial Analysis (Report 1):

Domain: E-commerce in Brazil, focusing on customer orders, product listings, payments, and shipping.
Goals: Identify high-performing products, seasonal sales patterns, and customer purchasing trends to inform business strategies.
Key Analyses: Sales performance by product category, customer demographics, payment methods, and regional sales distribution.
Dimensional Model, Tabular Model, and ETL Process (Report 2):

Dimensional Modeling: A star schema was designed to support OLAP queries, consisting of fact and dimension tables for orders, products, customers, payments, and dates.
Tabular Model with SSAS: Implemented in SQL Server Analysis Services (SSAS), this model enhances data analysis with efficient processing and aggregation.
ETL Implementation: Data extraction, transformation, and loading were implemented using SQL Server Integration Services (SSIS) to process large volumes of e-commerce data, including data quality checks, incremental loads, and ensuring consistency across data sources.
Data Visualization and Dashboard (Report 3):

Dashboard Implementation: Using Power BI, key metrics and trends were visualized for business stakeholders, focusing on:
Top-selling cities and high-cost shipping regions.
Product categories by sales volume and average price.
Popular payment methods and order distribution.
User Focus: Custom insights tailored for Sales Analysts and Marketing Managers to support targeted decision-making.
Getting Started
Prerequisites
SQL Server (with Integration Services and Analysis Services)
Power BI or Tableau for dashboard visualization
Installation
Clone this repository.
Set up a SQL Server instance and import the dataset (source from Kaggle).
Use the provided ETL scripts to load and transform data into the data warehouse.
Configure the SSAS tabular model for efficient data access and processing.
Open Power BI or Tableau files to view dashboards.
Files
/scripts: Contains SQL scripts for creating and loading tables in the data warehouse.
/ssas: Contains configurations for the SSAS tabular model.
/dashboards: Power BI files to visualize key e-commerce metrics.
Usage
ETL Execution: Run the ETL scripts to transform and load data into the warehouse.
SSAS Tabular Model: Use SSAS to process and deploy the tabular model, enabling efficient multidimensional analysis.
Data Analysis: Use OLAP tools or SSAS tabular model for ad-hoc analysis on the loaded data.
Dashboards: View the dashboards in Power BI to gain insights into sales and marketing metrics.
Project Results
The data warehouse and visualizations provide valuable insights, such as:

Sales concentration in top cities like São Paulo and Rio de Janeiro.
High-value product categories, including electronics.
Most-used payment methods and states with high shipping costs.
These insights support improved decision-making across marketing, sales, and logistics.
