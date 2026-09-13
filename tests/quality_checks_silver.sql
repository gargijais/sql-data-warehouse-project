/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Quality Checking: Silver.crm_cust_info
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Result
SELECT
	cst_id,
	COUNT(*)
FROM Silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted spaces in string values
-- Execution: No Result
SELECT
	cst_firstname
FROM Silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
	cst_lastname
FROM Silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT
	cst_gndr
FROM Silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Check the consistency of values in low cardinality columns
-- Data Standardization & Consistency
SELECT DISTINCT cst_marital_status
FROM Silver.crm_cust_info;

SELECT DISTINCT cst_gndr
FROM Silver.crm_cust_info;

SELECT * FROM Silver.crm_cust_info;

-- =====================================================================
-- Quality Checking: Silver.crm_prd_info  
-- =====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Result
SELECT
	prd_id,
	COUNT(*)
FROM Silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted spaces in string values
-- Expectation: No Results
SELECT
	prd_nm
FROM Silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Numbers
-- Expectation: No Results
SELECT
	prd_cost
FROM Silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM Silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
SELECT *
FROM Silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;-- End date must not be earlier than the start date

SELECT * FROM Silver.crm_prd_info;

-- =====================================================================
-- Quality Checking: Silver.crm_sales_details  
-- =====================================================================
-- Check for Unwanted spaces in string values
-- Expectation: No Results
SELECT *
FROM Silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- Check sls_prd_key not in Silver.crm_prd_info
SELECT *
FROM Silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM Silver.crm_prd_info);

-- Check sls_cust_id not in Silver.crm_cust_info
SELECT *
FROM Silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM Silver.crm_cust_info);

-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT 
	NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM Silver.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101;

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results
SELECT *
FROM Silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Between Sales, quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, Zero, or negative
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM Silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

SELECT * FROM Silver.crm_sales_details;

-- =====================================================================
-- Quality Checking: Silver.erp_cust_az12  
-- =====================================================================
SELECT
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END AS cid,
	bdate,
	gen
FROM Silver.erp_cust_az12
WHERE CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END NOT IN (SELECT DISTINCT cst_key FROM Silver.crm_cust_info);

-- Identify Out-of-Range Dates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT DISTINCT
	bdate
FROM Silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM Silver.erp_cust_az12;

SELECT * FROM Silver.erp_cust_az12;

-- =====================================================================
-- Quality Checking: Silver.erp_loc_a101  
-- =====================================================================
SELECT
	REPLACE(cid, '-', '') AS cid,
	cntry
FROM Silver.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM Silver.crm_cust_info);

-- Data Standardization & Consistency
SELECT DISTINCT cntry
FROM Silver.erp_loc_a101
ORDER BY cntry;

-- =====================================================================
-- Quality Checking: Silver.erp_px_cat_g1v2  
-- =====================================================================
-- Check for unwanted spaces
-- Expectation: No Results
SELECT *
FROM Silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT
	maintenance
FROM Silver.erp_px_cat_g1v2;

SELECT * FROM Silver.erp_px_cat_g1v2;
