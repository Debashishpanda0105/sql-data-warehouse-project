/*===============================================================================
Script Name:
    Create Database and Schemas
===============================================================================
Script Purpose:
    This script creates a new SQL Server database named 'DataWarehouse'
    after checking whether it already exists.

    If the database already exists, it is safely dropped and recreated.
    The script also creates three schemas that represent different stages
    of the data warehouse architecture:

        • bronze  -> Raw data layer
        • silver  -> Cleaned and transformed data layer
        • gold    -> Business-ready analytics layer

WARNING:
    Running this script will permanently delete the existing
    'DataWarehouse' database (if it exists).

    All data stored in the database will be lost.

    Proceed with caution and ensure you have a proper backup
    before executing this script.
===============================================================================
*/

USE master;
GO

-------------------------------------------------------------------------------
-- Drop existing DataWarehouse database (if it exists)
-------------------------------------------------------------------------------

IF EXISTS (SELECT 1
           FROM sys.databases
           WHERE name = 'DataWarehouse')
BEGIN

    ALTER DATABASE DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;

END;
GO

-------------------------------------------------------------------------------
-- Create DataWarehouse Database
-------------------------------------------------------------------------------

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-------------------------------------------------------------------------------
-- Create Bronze Schema (Raw Data)
-------------------------------------------------------------------------------

CREATE SCHEMA bronze;
GO

-------------------------------------------------------------------------------
-- Create Silver Schema (Cleaned & Transformed Data)
-------------------------------------------------------------------------------

CREATE SCHEMA silver;
GO

-------------------------------------------------------------------------------
-- Create Gold Schema (Business Ready Data)
-------------------------------------------------------------------------------

CREATE SCHEMA gold;
GO

-------------------------------------------------------------------------------
-- Database Setup Completed Successfully
-------------------------------------------------------------------------------

PRINT 'DataWarehouse database created successfully.';
PRINT 'Schemas created: bronze, silver, gold.';
GO
