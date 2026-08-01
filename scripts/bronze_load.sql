/*
===============================================================================
Purpose:
This script loads raw CRM and ERP data from CSV files into the Bronze layer
tables of the Data Warehouse. Existing data is removed before loading to ensure
the Bronze layer contains a fresh copy of the source data.
===============================================================================
*/

-- Reload CRM Customer Information
TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,          -- Skip the header row
    FIELDTERMINATOR = ',', -- CSV delimiter
    TABLOCK                -- Acquire a table-level lock for faster loading
);
GO

-- Reload CRM Product Information
TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- Reload CRM Sales Details
TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- Reload ERP Location Data
TRUNCATE TABLE bronze.erp_loc_a101;

BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- Reload ERP Customer Data
TRUNCATE TABLE bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- Reload ERP Product Category Data
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO
