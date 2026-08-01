/*
===============================================================================
Store Procedure: Load Bronze Layer(Source->Bronze)
===============================================================================
Script Purpose:
This stored procedure performs a full refresh of the Bronze layer by loading
raw CRM and ERP data from CSV files into SQL Server tables. It logs the loading
progress, measures execution time for each table and the overall batch, and
captures errors using TRY...CATCH to simplify ETL monitoring and troubleshooting.
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '===========================================================';
        PRINT 'LOADING BRONZE LAYER';
        PRINT '===========================================================';

        PRINT '-----------------------------------------------------------';
        PRINT 'LOADING CRM TABLES';
        PRINT '-----------------------------------------------------------';

        -- Track execution time for each table load
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,          -- Skip header row
            FIELDTERMINATOR = ',',
            TABLOCK                -- Improve bulk load performance
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        ------------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        ------------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '-----------------------------------------------------------';
        PRINT 'LOADING ERP TABLES';
        PRINT '-----------------------------------------------------------';

        ------------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        ------------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        ------------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\debup\OneDrive\Desktop\SQL...... Cource\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
            + ' seconds';

        SET @batch_end_time = GETDATE();

        PRINT '===========================================================';
        PRINT 'Loading Bronze Layer Completed Successfully';
        PRINT 'Total Load Duration: '
            + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR)
            + ' seconds';
        PRINT '===========================================================';

    END TRY

    BEGIN CATCH

        PRINT '===========================================================';
        PRINT 'Error occurred while loading Bronze Layer';
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===========================================================';

    END CATCH

END;
GO

EXEC bronze.load_bronze;
