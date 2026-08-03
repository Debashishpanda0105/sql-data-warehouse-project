/*
=================================================================================================
creating silver later
==================================================================================================
Script Purpose: This stored procedure loads data from the Bronze layer into the Silver layer of
the data warehouse. It performs data cleansing, standardization, deduplication,
data quality corrections, and transformation before populating the Silver tables. 
The procedure also logs execution time for each table load and handles errors during execution.
==================================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME ,@batch_start_time DATETIME,@batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT'====================================================================';
		PRINT'LOADING SILVER LAYER';
		PRINT'====================================================================';

		PRINT'====================================================================';
		PRINT'LOADING DRM TABLE';
		PRINT'====================================================================';

		--Loading crm_cust_info
		--check for unwanted Spaces
		SET @start_time = GETDATE();
		PRINT'>>TRUNCATING TABLE: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT'>>Inserting Data INTO : silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_material_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS st_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				 ELSE 'n/a'
			END cst_gndr,-- normalise gender values to redable formate

			CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
				 WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
				 ELSE 'n/a'
			END cst_material_status,-- normalise marital status values to redable formate
			cst_create_date
		FROM(
			SELECT 
				*,
				ROW_NUMBER () OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t WHERE flag_last = 1 --select the most recent record per customer
		SET @End_time = GETDATE();
		PRINT'>>LOAD DURATION:'+CAST(DATEDIFF(SECOND,@start_time,@end_time)AS VARCHAR) +'seconds';
		PRINT'>--------------------------'	;
		--------------------------------------------------------------------------------
		--for crm_cust_info
		--clean and load crm_prd_info
		SET @start_time = GETDATE();
		PRINT'>>TRUNCATING TABLE: silver.silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT'>>Inserting Data INTO : silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, --extract category id
			SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,-- extract product key
			prd_nm,
			ISNULL(prd_cost,0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				 WHEN  'M' THEN 'Mountain'
				 WHEN  'R' THEN 'Road'
				 WHEN  'S' THEN 'Other Sales'
				 WHEN  'T' THEN 'Touring'
				 ELSE 'n/a'
			END AS prd_line,-- map product line code to descriptive value
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) -1
			AS DATE
			) AS prd_end_dt --calculate end date as one day before the next start date
		FROM bronze.crm_prd_info
		SET @End_time = GETDATE();
		PRINT'>>LOAD DURATION:'+CAST(DATEDIFF(SECOND,@start_time,@end_time)AS VARCHAR) +'seconds';
		PRINT'>--------------------------'	;
		------------------------------------------------------------------------------------
		--clean & load crm_sales_details
		SET @start_time = GETDATE();
		PRINT'>>TRUNCATING TABLE: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT'>>Inserting Data INTO :silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price 
		)

		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
			END AS sls_order_dt,

			CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_ship_dt AS VARCHAR)AS DATE)
			END AS sls_ship_dt,

			CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				 ELSE CAST(CAST(sls_due_dt AS VARCHAR)AS DATE)
			END AS sls_due_dt,

			CASE WHEN sls_sales IS NULL  OR sls_sales <=0 OR sls_sales  != sls_quantity * ABS(sls_price)
			 THEN sls_quantity * ABS(sls_price)
			 ELSE sls_sales -- recalculate sales if original value is missing or incorrect
			END AS sls_sales,
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price <= 0
			 THEN sls_sales /NULLIF(sls_quantity,0)
			 ELSE sls_price --- delivered price if original value is invalid
			END AS sls_price
		FROM bronze.crm_sales_details
		SET @End_time = GETDATE();
		PRINT'>>LOAD DURATION:'+CAST(DATEDIFF(SECOND,@start_time,@end_time)AS VARCHAR) +'seconds';
		PRINT'>--------------------------'	;
		----------------------------------------------------------------------------------------
		--clean & load erp_cust_az12
		PRINT'====================================================================';
		PRINT'LOADING ERP TABLE';
		PRINT'====================================================================';

		SET @start_time = GETDATE();
		PRINT'>>TRUNCATING TABLE: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT'>>Inserting Data INTO :silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (
			cid ,
			bdate,
			gen
		)
		SELECT 
			CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
			ELSE cid
			END AS cid, ---remove nas perfix if present

			CASE WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
			END AS bdate,--set future bdate to null

			CASE WHEN UPPER(TRIM(gen)) IN ('F' ,'FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('F' ,'MALE') THEN 'Male' 
			ELSE 'n/a' --- normalize gender values and handel unknown cases 
			END AS gen 
		FROM bronze.erp_cust_az12
		SET @End_time = GETDATE();
		PRINT'>>LOAD DURATION:'+CAST(DATEDIFF(SECOND,@start_time,@end_time)AS VARCHAR) +'seconds';
		PRINT'>--------------------------'	;
		------------------------------------------------------------------------------------
		--clean & load erp_loc_a101
		SET @start_time = GETDATE();
		PRINT'>>TRUNCATING TABLE: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT'>>Inserting Data INTO :silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry 
		)
		SELECT 
			REPLACE(cid ,'-','') cid,
			CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
				 WHEN TRIM(cntry) = '' OR cntry IS NULL  THEN 'n/a'
				 ELSE TRIM(cntry)
			END AS cntry -- normalize and handel missing values or blank country codes 
		FROM bronze.erp_loc_a101 
		SET @End_time = GETDATE();
		PRINT'>>LOAD DURATION:'+CAST(DATEDIFF(SECOND,@start_time,@end_time)AS VARCHAR) +'seconds';
		PRINT'>--------------------------'	;
		------------------------------------------------------------------------------------
		--clean & load erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT'>>TRUNCATING TABLE:silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT'>>Inserting Data INTO :silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		)

		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2
		SET @End_time = GETDATE();
		PRINT'>>LOAD DURATION:'+CAST(DATEDIFF(SECOND,@start_time,@end_time)AS VARCHAR) +'seconds';
		PRINT'>--------------------------'	;

		SET @batch_end_time = GETDATE();
		PRINT'Loding Silver Layer is Completed';
		PRINT'>>Toatl LOAD DURATION:'+CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time)AS VARCHAR) +'seconds';
		PRINT'=====================================================================';
	END TRY
	BEGIN CATCH
	PRINT '========================================================================'
	PRINT'ERROR OCCURRED DURING LOADING BRONZE LAYER'
	PRINT'ERROR MESSAGE' + ERROR_MESSAGE();
	PRINT'ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR)	;
	PRINT'ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR)	;
	END CATCH
END


--TO LOAD STOIRE PROCEDURE
EXEC bronze.load_bronze;
