SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen,'n/a')
	END new_gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2

--to check the quality of view for customers 
SELECT * FROM gold.dim_customers

--to check the quality of view for products
SELECT * FROM gold.dim_products

--to check the quality of view for sales
SELECT * FROM gold.fact_sales
