-- Drop column ETLLoadID, LoadDate, UpdateDate used for ETL
EXEC DropColumnFromAllTables 'dbo', 'LoadDate';
EXEC DropColumnFromAllTables 'dbo', 'ETLLoadID';
EXEC DropColumnFromAllTables 'dbo', 'UpdateDate';

-- Checking DimAccount 
SELECT * 
FROM DimAccount
-- Drop null column
AlTER TABLE DimAccount
DROP COLUMN CustomMembers
-- Drop garbage columns
AlTER TABLE DimAccount
DROP COLUMN AccountLabel, 
            Operator, 
			CustomMemberOptions
-- Where AccountName is 'Profit and Loss after tax' or 'Profit and Loss before tax'', fill the NULL of columns AccountType and ValueType with 'Income'
UPDATE  DimAccount
SET ValueType = 'Income',
    AccountType = 'Income'
WHERE AccountName  = 'Profit and Loss after tax' 
	  OR AccountName  = 'Profit and Loss before tax' 
-- The table DimAccount is cleaned

-- Checking DimChannel table
SELECT * 
FROM DimChannel
-- Drop garbage columns
ALTER TABLE DimChannel
DROP COLUMN ChannelLabel

-- Checking DimCurrency table
SELECT * 
FROM DimCurrency
EXEC sp_help 'DimCurrency';
-- Checking DimCustomer
SELECT *
FROM DimCustomer

EXEC sp_help 'DimCustomer';
-- Drop garbage columns
ALTER TABLE DimCustomer
DROP COLUMN  NameStyle, Title, Suffix, MiddleName, AddressLine2

UPDATE DimCustomer
SET CompanyName = 'No Entered'
WHERE CompanyName is NULL

ALTER TABLE DimCustomer
ALTER COLUMN MaritalStatus VARCHAR(7);
UPDATE DimCustomer
SET MaritalStatus =
CASE 
        WHEN MaritalStatus = 'M' THEN 'Married'
        WHEN MaritalStatus = 'S' THEN 'Single'
END;

ALTER TABLE DimCustomer
ALTER COLUMN Gender VARCHAR(6);
UPDATE DimCustomer
SET Gender =
CASE 
        WHEN Gender = 'M' THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
END;
-- Checking DimDate
EXEC sp_help 'DimDate'

EXEC sp_statistics 'DimDate'

SELECT * 
FROM DimDate
-- Drop garbage columns
ALTER TABLE DimDate
DROP COLUMN FiscalHalfYear, 
            FiscalMonth, 
			CalendarQuarter,
			CalendarHalfYear,
			CalendarMonth, 
			CalendarWeek, 
			CalendarDayOfWeek, 
			FiscalQuarter,
			HolidayName, 
			FullDateLabel, 
			DateDescription

SELECT EuropeSeason 
FROM DimDate
GROUP BY EuropeSeason

UPDATE DimDate
SET EuropeSeason = 'No Season'
WHERE EuropeSeason = 'None'

SELECT NorthAmericaSeason
FROM DimDate
GROUP BY NorthAmericaSeason

UPDATE DimDate
SET NorthAmericaSeason = 'No Season'
WHERE NorthAmericaSeason = 'None'

UPDATE DimDate
SET  AsiaSeason = 'No Season'
WHERE AsiaSeason = 'None'

UPDATE DimDate
SET  IsHoliday = 1
WHERE IsWorkDay = 'WeekEnd'

UPDATE DimDate
SET  FiscalMonthLabel = 'January'
WHERE FiscalMonthLabel = 'Month 1'

UPDATE DimDate
SET  FiscalMonthLabel = 'February'
WHERE FiscalMonthLabel = 'Month 2'

UPDATE DimDate
SET  FiscalMonthLabel = 'March'
WHERE FiscalMonthLabel = 'Month 3'

UPDATE DimDate
SET  FiscalMonthLabel = 'April'
WHERE FiscalMonthLabel = 'Month 4'

UPDATE DimDate
SET  FiscalMonthLabel = 'May'
WHERE FiscalMonthLabel = 'Month 5'

UPDATE DimDate
SET  FiscalMonthLabel = 'June'
WHERE FiscalMonthLabel = 'Month 6'

UPDATE DimDate
SET  FiscalMonthLabel = 'July'
WHERE FiscalMonthLabel = 'Month 7'

UPDATE DimDate
SET  FiscalMonthLabel = 'August'
WHERE FiscalMonthLabel = 'Month 8'

UPDATE DimDate
SET  FiscalMonthLabel = 'September'
WHERE FiscalMonthLabel = 'Month 9'

UPDATE DimDate
SET  FiscalMonthLabel = 'October'
WHERE FiscalMonthLabel = 'Month 10'

UPDATE DimDate
SET  FiscalMonthLabel = 'November'
WHERE FiscalMonthLabel = 'Month 11'

UPDATE DimDate
SET  FiscalMonthLabel = 'December'
WHERE FiscalMonthLabel = 'Month 12'

ALTER TABLE DimDate
ADD MonthNumber INT;
UPDATE DimDate
SET MonthNumber = MONTH(Datekey)

ALTER TABLE DimDate 
ADD CalendarDayOfWeekNumber INT;
UPDATE DimDate
SET CalendarDayOfWeekNumber = DATEPART(WEEKDAY, Datekey);

EXEC sp_rename 'DImDate.Datekey', 'DateKey', 'COLUMN';

-- Checking DimEmployee

SELECT * FROM DimEmployee

EXEC sp_statistics DimEmployee

EXEC sp_help DimEmployee

UPDATE DimEmployee
SET MiddleName = 'None'
WHERE MiddleName IS NULL

UPDATE DimEmployee 
SET Status = 'Retirement'
WHERE Status ='NULL'

ALTER TABLE DimEmployee
DROP COLUMN EndDate

SELECT CurrentFlag
FROM DimEmployee
GROUP BY CurrentFlag

UPDATE DimEmployee 
SET CurrentFlag = 0
WHERE Status = 'Retirement'


SELECT DepartmentName
FROM DimEmployee
GROUP BY DepartmentName

UPDATE DimEmployee 
SET DepartmentName = 'Human Resources'
WHERE  EmployeeKey = 18

ALTER TABLE DimEmployee
ALTER COLUMN MaritalStatus VARCHAR(7);
UPDATE DimEmployee 
SET MaritalStatus =
CASE 
        WHEN MaritalStatus = 'M' THEN 'Married'
        WHEN MaritalStatus = 'S' THEN 'Single'
END;

ALTER TABLE DimEmployee
ALTER COLUMN Gender VARCHAR(6);
UPDATE DimEmployee 
SET Gender =
CASE 
        WHEN Gender = 'M' THEN 'Male'
        WHEN Gender = 'F' THEN 'Female'
END;
-- Check DimEntity
SELECT *
FROM DimEntity

ALTER TABLE DimEntity
DROP COLUMN EntityDescription,
            EndDate

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'DimEntity';
-- Check DimGeography
SELECT *
FROM DimGeography

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'DimGeography';

ALTER TABLE DimGeography
DROP COLUMN Geometry

-- Check DimMachine
SELECT *
FROM DimMachine
-- Check DimOutage
SELECT *
FROM DimOutage
ALTER TABLE DimOutage 
DROP COLUMN OutageLabel, 
            OutageDescription, 
            OutageSubTypeDescription
-- Check DimProduct
SELECT *
FROM DimProduct

ALTER TABLE DimProduct
DROP COLUMN StopSaleDate,
            ImageURL,
            ProductURL,
			ProductLabel,
			Size,
			SizeRange,
			SizeUnitMeasureID
UPDATE DimProduct
SET Status = 'Off'
WHERE Status IS NULL

SELECT *
FROM DimProduct
WHERE ProductDescription IS NULL

UPDATE DimProduct
SET  AvailableForSaleDate = '2005-05-03 00:00:00.000'
WHERE AvailableForSaleDate IS NULL

UPDATE DimProduct
SET StyleID = 1
WHERE StyleID IS NULL

-- Check DimProductCategory
SELECT *
FROM DimProductCategory

ALTER TABLE DimProductCategory
DROP COLUMN 
            ProductCategoryDescription

-- Check DimProductSubcategory
SELECT *
FROM DimProductSubcategory

ALTER TABLE DimProductSubcategory
DROP COLUMN ProductSubcategoryDescription

-- Check DimPromotion
SELECT *
FROM DimPromotion

ALTER TABLE DimPromotion
DROP COLUMN PromotionDescription,
			StartDate,
			EndDate
-- Check DimSalesTerritory
SELECT *
FROM DimSalesTerritory

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'DimSalesTerritory';

AlTER TABLE DimSalesTerritory 
DROP COLUMN EndDate,
            StartDate
-- Check DimScenario
SELECT *
FROM DimScenario

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'DimScenario';

ALTER TABLE DimScenario
DROP COLUMN ScenarioDescription

-- Check DimStore
SELECT 
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimStore'

SELECT * FROM DimStore

ALTER TABLE DimStore 
DROP COLUMN StoreDescription, 
            AddressLine1,
            AddressLine2,
			ZipCode,
			ZipCodeExtension,
			GeoLocation,
			Geometry
UPDATE DimStore
SET CloseReason = 'Not Yet Closed'
WHERE CloseReason IS NULL

UPDATE DimStore
SET CloseDate = '2090-12-31 00:00:00.000'
WHERE CloseDate IS NULL

SELECT AVG(EmployeeCount) 
FROM DimStore

UPDATE DimStore
SET EmployeeCount = 36
WHERE EmployeeCount IS NULL

-- Check FactExchangeRate
SELECT *
FROM FactExchangeRate

SELECT 
    COLUMN_NAME, 
    DATA_TYPE
    
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'FactExchangeRate';

