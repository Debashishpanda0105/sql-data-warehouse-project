# Naming Conventions

This document defines the naming standards used throughout the Data Warehouse project. Following consistent naming conventions improves readability, maintainability, and collaboration.

---

# General Naming Rules

- Use **snake_case** for all database objects.
- Use **lowercase** letters for object names.
- Avoid spaces and special characters.
- Use meaningful and descriptive names.
- Use singular names for dimension and fact tables.

---

# Schema Naming

| Schema | Purpose |
|--------|---------|
| bronze | Raw data ingested from source systems without transformations. |
| silver | Cleaned, standardized, and transformed data. |
| gold | Business-ready dimensional models for reporting and analytics. |

---

# Table Naming

## Bronze Layer

Use the source system as the prefix.

Examples:

```text
crm_cust_info
crm_prd_info
crm_sales_details
erp_cust_az12
erp_loc_a101
erp_px_cat_g1v2
```

---

## Silver Layer

Keep the same table names as the Bronze layer after cleansing.

Examples:

```text
silver.crm_cust_info
silver.crm_prd_info
silver.crm_sales_details
```

---

## Gold Layer

Use business-friendly names.

Examples:

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
```

---

# Primary Keys

Use the suffix `_key` for surrogate keys.

Examples:

```text
customer_key
product_key
```

---

# Business Keys

Use `_id` or `_number` depending on the source system.

Examples:

```text
customer_id
product_id
customer_number
product_number
order_number
```

---

# Foreign Keys

Foreign keys should reference the surrogate keys of dimension tables.

Examples:

```text
customer_key
product_key
```

---

# Date Columns

Use the suffix `_date` for all date fields.

Examples:

```text
order_date
shipping_date
due_date
birthdate
create_date
start_date
end_date
```

---

# Text Columns

Use descriptive names instead of abbreviations whenever possible.

Examples:

```text
first_name
last_name
country
gender
marital_status
category
subcategory
product_name
```

---

# Numeric Columns

Use clear business names.

Examples:

```text
sales_amount
price
cost
quantity
```

---

# Stored Procedure Naming

Use the format:

```text
<schema>.load_<layer>
```

Examples:

```sql
bronze.load_bronze
silver.load_silver
```

---

# View Naming

Use the prefix `vw_`.

Examples:

```text
vw_customer_sales
vw_product_performance
```

---

# Alias Naming

Use short and meaningful aliases.

| Alias | Table |
|--------|-------|
| cu | Customers |
| pr | Products |
| sd | Sales Details |
| ca | Categories |

Example:

```sql
SELECT
    sd.order_number,
    cu.customer_key,
    pr.product_key
FROM gold.fact_sales sd
LEFT JOIN gold.dim_customers cu
    ON sd.customer_key = cu.customer_key
LEFT JOIN gold.dim_products pr
    ON sd.product_key = pr.product_key;
```

---

# File Naming

Use lowercase with underscores.

Examples:

```text
bronze_layer.sql
silver_layer.sql
gold_layer.sql
data_dictionary.md
naming_convention.md
```

---

# Best Practices

- Keep names short but meaningful.
- Avoid reserved SQL keywords.
- Maintain consistent naming across all layers.
- Use singular table names for dimensions and facts.
- Prefer business-friendly names over technical abbreviations.
- Follow the same naming convention throughout the project.

---

# Summary

| Object | Convention |
|---------|------------|
| Schema | lowercase |
| Tables | snake_case |
| Columns | snake_case |
| Primary Key | *_key |
| Business Key | *_id / *_number |
| Foreign Key | *_key |
| Date Columns | *_date |
| Stored Procedures | load_<layer> |
| Views | vw_* |
| Files | lowercase_with_underscores |
