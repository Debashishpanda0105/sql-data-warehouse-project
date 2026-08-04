# 📊 Data Warehouse & Analytics Project

A production-style **SQL Server Data Warehouse** built using a **Medallion Architecture (Bronze → Silver → Gold)** to transform raw CRM and ERP data into a business-ready analytical model.

This project demonstrates the complete lifecycle of a modern data warehouse—from data ingestion and cleansing to dimensional modeling and analytical reporting. It follows industry-standard Data Engineering practices and serves as an end-to-end portfolio project.

---

# 📖 Table of Contents

* [Project Overview](#-project-overview)
* [Architecture](#-architecture)
* [Project Objectives](#-project-objectives)
* [Technology Stack](#-technology-stack)
* [Data Pipeline](#-data-pipeline)
* [Data Model](#-data-model)
* [Project Structure](#-project-structure)
* [ETL Workflow](#-etl-workflow)
* [Data Quality Checks](#-data-quality-checks)
* [Business Rules](#-business-rules)
* [Analytics Use Cases](#-analytics-use-cases)
* [Learning Outcomes](#-learning-outcomes)
* [Future Improvements](#-future-improvements)
* [License](#-license)

---

# 🚀 Project Overview

Organizations often receive data from multiple operational systems that contain duplicate records, inconsistent formats, missing values, and invalid business data.

This project demonstrates how to build a centralized SQL Server Data Warehouse that:

* Consolidates CRM and ERP data
* Cleans and standardizes raw datasets
* Applies business validation rules
* Builds a Star Schema for analytics
* Produces business-ready datasets for reporting tools such as Power BI and Tableau

---

# 🏛️ Architecture

```
                CSV Files
           (CRM & ERP Systems)
                    │
                    ▼
          ┌──────────────────┐
          │ Bronze Layer     │
          │ Raw Source Data  │
          └──────────────────┘
                    │
                    ▼
          ┌──────────────────┐
          │ Silver Layer     │
          │ Clean & Validate │
          └──────────────────┘
                    │
                    ▼
          ┌──────────────────┐
          │ Gold Layer       │
          │ Star Schema      │
          └──────────────────┘
                    │
                    ▼
          Dashboards & Analytics
```

---

# 🎯 Project Objectives

The project demonstrates how to:

* Design a layered SQL Server Data Warehouse
* Build scalable ETL pipelines
* Clean and standardize business data
* Integrate multiple source systems
* Design a dimensional model (Star Schema)
* Create analytical datasets optimized for BI reporting

---

# 🛠️ Technology Stack

| Category        | Technologies           |
| --------------- | ---------------------- |
| Database        | Microsoft SQL Server   |
| Language        | T-SQL                  |
| Data Modeling   | Star Schema            |
| ETL             | SQL Stored Procedures  |
| Data Quality    | Validation & Cleansing |
| Version Control | Git & GitHub           |
| Reporting       | Power BI (Gold Layer)  |

---

# 🔄 Data Pipeline

## Bronze Layer

Purpose:

* Load raw CRM and ERP CSV files
* Preserve source data
* Minimal transformations

---

## Silver Layer

Purpose:

* Remove duplicates
* Trim unwanted spaces
* Standardize gender, marital status and country values
* Correct invalid sales amounts
* Validate dates
* Handle missing values
* Apply business rules

---

## Gold Layer

Purpose:

Create analytical views following a Star Schema.

### Dimensions

* Customer Dimension
* Product Dimension

### Fact

* Sales Fact

This layer is optimized for dashboards and analytical queries.

---

# ⭐ Data Model

```
                 dim_customers
                       │
                       │
                       │
               fact_sales
                       │
                       │
                 dim_products
```

---

# 📁 Project Structure

```
Data-Warehouse-Analytics-Project
│
├── datasets
│   ├── crm
│   └── erp
│
├── scripts
│   ├── bronze
│   ├── silver
│   ├── gold
│   └── tests
│
├── docs
│   ├── architecture
│   ├── business_rules
│   ├── etl
│   └── data_dictionary
│
├── images
│
└── README.md
```

---

# ⚙️ ETL Workflow

```
Load Raw Data
        │
        ▼
Validate Source Data
        │
        ▼
Clean & Standardize
        │
        ▼
Apply Business Rules
        │
        ▼
Build Dimensions
        │
        ▼
Build Fact Table
        │
        ▼
Analytics Ready
```

---

# ✅ Data Quality Checks

The project validates:

* Duplicate primary keys
* NULL primary keys
* Leading and trailing spaces
* Invalid dates
* Future birth dates
* Product date consistency
* Invalid sales calculations
* Missing values
* Country standardization
* Gender standardization
* Marital status standardization

---

# 📋 Business Rules

Examples of implemented business rules include:

* Keep only the latest customer record
* Standardize gender values
* Standardize marital status
* Remove invalid customer IDs
* Convert country abbreviations to full names
* Calculate missing sales values
* Calculate missing prices
* Remove historical product versions
* Generate surrogate keys
* Build analytical dimensions

---

# 📈 Analytics Use Cases

The Gold Layer supports analysis such as:

### Customer Analytics

* Customer demographics
* Customer distribution by country
* Customer acquisition trends

### Product Analytics

* Product performance
* Category analysis
* Product line analysis

### Sales Analytics

* Revenue trends
* Sales by product
* Sales by customer
* Average selling price
* Order volume
* Quantity sold

---

# 💼 Skills Demonstrated

* SQL Server Development
* Data Warehousing
* ETL Pipeline Development
* Data Cleaning
* Data Validation
* Data Transformation
* Star Schema Design
* Dimensional Modeling
* Window Functions
* Stored Procedures
* Data Quality Framework
* Business Rule Implementation
* Analytical SQL
* Documentation
* Git & GitHub

---

# 📚 Learning Outcomes

Through this project I gained practical experience in:

* Designing layered Data Warehouses
* Building production-style ETL pipelines
* Writing maintainable SQL code
* Applying business transformation rules
* Creating dimensional models
* Optimizing analytical queries
* Building reusable SQL components
* Documenting enterprise data projects

---

# 🚀 Future Improvements

* Incremental Loading
* Slowly Changing Dimensions (SCD Type 2)
* SQL Server Agent Job Scheduling
* Data Quality Dashboard
* Automated Data Validation
* Metadata-driven ETL
* Power BI Dashboard
* Azure Data Factory Integration
* CI/CD Pipeline
* Unit Testing for SQL

---

# 📄 License

This project is licensed under the MIT License.

---

# 👨‍💻 About Me

**Debashish Panda**

MCA Graduate | Aspiring Data Analyst | SQL & Data Warehousing Enthusiast

I enjoy designing scalable data solutions that transform raw operational data into trusted analytical datasets. My interests include SQL Server, Data Warehousing, ETL development, Business Intelligence, and building data-driven solutions that support strategic decision-making.

---

## ⭐ Support

If you found this project helpful or learned something from it, please consider giving it a **⭐ Star**. It helps increase the visibility of the project and motivates continued learning and development.
