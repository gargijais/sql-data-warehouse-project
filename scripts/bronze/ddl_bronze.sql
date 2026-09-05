/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'Bonze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'Bronze' Tables
===============================================================================
*/

/* ===================================================
   1. CREATE TABLE: Bronze 'CRM Customer Info'
   ==================================================== */

IF OBJECT_ID('Bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE Bronze.crm_cust_info;
CREATE TABLE Bronze.crm_cust_info (
	cst_id                 INT,
	cst_key                NVARCHAR(50),
	cst_firstname          NVARCHAR(50),
	cst_lastname           NVARCHAR(50),
	cst_marital_status     NVARCHAR(50),
	cst_gndr               NVARCHAR(50),
	cst_create_date        DATE
);
GO

/* ===================================================
   2. CREATE TABLE: Bronze 'CRM Product Info'
   =================================================== */

IF OBJECT_ID('Bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE Bronze.crm_prd_info;
CREATE TABLE Bronze.crm_prd_info (
	prd_id          INT,
	prd_key         NVARCHAR(50),
	prd_nm          NVARCHAR(50),
	prd_cost        INT,
	prd_line        NVARCHAR(50),
	prd_start_dt    DATETIME,
	prd_end_dt      DATETIME
);
GO

/* ===================================================
   3. CREATE TABLE: Bronze 'CRM Sales Details'
   ==================================================== */

IF OBJECT_ID('Bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE Bronze.crm_sales_details;
CREATE TABLE Bronze.crm_sales_details (
	sls_ord_num     NVARCHAR(50),
	sls_prd_key     NVARCHAR(50),
	sls_cust_id     INT,
	sls_order_dt    INT,
	sls_ship_dt     INT,
	sls_due_dt      INT,
	sls_sales       INT,
	sls_quantity    INT,
	sls_price       INT
);
GO

/* ===================================================
   4. CREATE TABLE: Bronze 'ERP Customer AZ12'
   ==================================================== */

IF OBJECT_ID('Bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE Bronze.erp_cust_az12;
CREATE TABLE Bronze.erp_cust_az12 (
	cid      NVARCHAR(50),
	bdate    DATE,
	gen      NVARCHAR(50)
);
GO

/* ===================================================
   5. CREATE TABLE: Bronze 'ERP Location A101'
   ==================================================== */

IF OBJECT_ID('Bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE Bronze.erp_loc_a101;
CREATE TABLE Bronze.erp_loc_a101 (
	cid     NVARCHAR(50),
	cntry   NVARCHAR(50)
);
GO

/* ===================================================
   6. CREATE TABLE: Bronze 'ERP Px Category G1V2'
   ==================================================== */

IF OBJECT_ID('Bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE Bronze.erp_px_cat_g1v2;
CREATE TABLE Bronze.erp_px_cat_g1v2 (
	id           NVARCHAR(50),
	cat          NVARCHAR(50),
	subcat       NVARCHAR(50),
	maintenace   NVARCHAR(50)
);
GO
