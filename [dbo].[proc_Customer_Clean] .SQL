
CREATE PROCEDURE [dbo].[proc_Customer_Clean] 
AS
BEGIN
	
	IF OBJECT_ID('dbo.Customer_Clean', 'U') IS NOT NULL 
		DROP TABLE dbo.Customer_Clean; 

	IF OBJECT_ID('dbo.Customer_Excluded', 'U') IS NOT NULL 
		DROP TABLE dbo.Customer_Excluded; 

	CREATE TABLE dbo.Customer_Clean (
		id int identity(1,1)
		,[customer_id] int NOT NULL
		,[date_registered] date NOT NULL
	);

	CREATE TABLE dbo.Customer_Excluded (
		id int identity(1,1)
		,[customer_id] int
		,[date_registered] date
	);

	INSERT INTO dbo.Customer_Clean
	(
      [customer_id]
      ,[date_registered]
	)	
	SELECT 
		fce.[customer id] as customer_id
		,fce.[Registration  Date] as registration_date
	FROM facts_customer_extended fce
	WHERE 
		fce.[Registration  Date] IS NOT NULL
		AND fce.[customer id] IS NOT NULL
	ORDER BY fce.[customer id]

	INSERT INTO dbo.Customer_Excluded
	(
      [customer_id]
      ,[date_registered]
	)	
	SELECT 
		fce.[customer id] as customer_id
		,fce.[Registration  Date] as registration_date
	FROM facts_customer_extended fce
	WHERE 
		fce.[Registration  Date] IS NULL
		AND fce.[customer id] IS NULL
	ORDER BY fce.[customer id]

	/* QA */
	DECLARE
		@TotalCustomers int
		,@RecordsKept int
		,@RecordsExcluded int

	SET @TotalCustomers =
		(SELECT COUNT(1) FROM facts_customer_extended)
	SET @RecordsKept =
		(SELECT COUNT(1) FROM Customer_Clean)
	SET @RecordsExcluded =
		(SELECT COUNT(1) FROM Customer_Excluded)
	
	PRINT ' ------------------------------'
	PRINT 'Created Customer_Clean Table'
	PRINT 'Total Customers: ' + cast(@TotalCustomers as varchar(10))
	PRINT 'Records Kept: ' + cast(@RecordsKept as varchar(10))
	PRINT 'Records Excluded: ' + cast(@RecordsExcluded as varchar(10))
	PRINT ' ------------------------------'
END
GO
