/*
===============================================================================
Purpose:
This script performs data quality validation and verification for CRM and ERP
data in both the Bronze and Silver layers of the data warehouse. It identifies
data quality issues such as duplicate keys, NULL values, unwanted spaces,
invalid dates, inconsistent reference values, and incorrect business data
before and after the ETL process.
===============================================================================
*/

-----------------------------------------------------------------------
-- CRM Customer Information Validation
-----------------------------------------------------------------------

-- Verify that customer IDs are unique and not NULL.
SELECT
    cst_id,
    COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;

-- Detect leading or trailing spaces in customer names.
SELECT
    cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

-- Review distinct gender values for standardization.
SELECT DISTINCT
    cst_gndr
FROM bronze.crm_cust_info;

-- Review marital status values before standardization.
SELECT DISTINCT
    cst_material_status
FROM bronze.crm_cust_info;

-----------------------------------------------------------------------
-- CRM Product Information Validation
-----------------------------------------------------------------------

-- Verify product IDs are unique.
SELECT
    prd_id,
    COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;

-- Review product line codes.
SELECT DISTINCT
    prd_line
FROM bronze.crm_prd_info;

-- Identify products with invalid effective date ranges.
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-----------------------------------------------------------------------
-- Silver Layer Validation
-----------------------------------------------------------------------

-- Confirm customer uniqueness after transformation.
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;

-- Verify whitespace has been removed.
SELECT
    cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

-- Verify standardized gender values.
SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;

-- Verify standardized marital status values.
SELECT DISTINCT
    cst_material_status
FROM silver.crm_cust_info;

-- Review final customer dataset.
SELECT *
FROM silver.crm_cust_info;

-- Review final product dataset.
SELECT *
FROM silver.crm_prd_info;

-----------------------------------------------------------------------
-- CRM Sales Validation
-----------------------------------------------------------------------

-- Identify invalid order dates.
SELECT
    NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
   OR LEN(sls_order_dt) <> 8
   OR sls_order_dt > 20500101
   OR sls_order_dt < 19000101;

-- Validate chronological order of sales dates.
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Validate sales amount against quantity and price.
SELECT DISTINCT

    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,

    CASE
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales <> sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    CASE
        WHEN sls_price IS NULL
          OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity,0)
        ELSE sls_price
    END AS sls_price

FROM bronze.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;

-- Review cleansed sales data.
SELECT *
FROM silver.crm_sales_details;

-----------------------------------------------------------------------
-- ERP Customer Validation
-----------------------------------------------------------------------

-- Identify unrealistic birth dates.
SELECT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Review source gender values before normalization.
SELECT DISTINCT
    gen,
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;

-- Review cleansed customer records.
SELECT *
FROM silver.erp_cust_az12;

-----------------------------------------------------------------------
-- ERP Location Validation
-----------------------------------------------------------------------

-- Review source country values.
SELECT DISTINCT
    cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

-- Review cleansed location data.
SELECT *
FROM silver.erp_loc_a101;

-----------------------------------------------------------------------
-- ERP Product Category Validation
-----------------------------------------------------------------------

-- Detect unwanted spaces in category names.
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat <> TRIM(cat);

-- Review maintenance values for consistency.
SELECT DISTINCT
    maintenance
FROM bronze.erp_px_cat_g1v2;

-- Review cleansed product category data.
SELECT *
FROM silver.erp_px_cat_g1v2;
