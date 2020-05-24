CREATE   PROCEDURE [dbo].[proc_Customer_FirstContract] 
AS
BEGIN
	
	IF OBJECT_ID('dbo.Customer_FirstContract', 'U') IS NOT NULL 
		DROP TABLE dbo.Customer_FirstContract ; 

	IF OBJECT_ID('dbo.Customer_FirstContract_Excluded', 'U') IS NOT NULL 
		DROP TABLE dbo.Customer_FirstContract_Excluded ; 

	CREATE TABLE dbo.Customer_FirstContract (
		id int identity(1,1)
		,[customer_id] int
		,[contract_id] int
		,[date_registered] date
		,[date_first_contract] date
	);

	CREATE TABLE dbo.Customer_FirstContract_Excluded (
		id int identity(1,1)
		,[customer_id] int
		,[contract_id] int
		,[date_registered] date
		,[date_first_contract] date
	);

	INSERT INTO dbo.Customer_FirstContract
	(
      [customer_id]
      ,[contract_id]
      ,[date_registered]
      ,[date_first_contract]
	)	
	SELECT 
		cc.customer_id
		,cf.contract_id
		,cc.date_registered
		,cf.contract_date

	FROM customer_clean cc
	INNER JOIN Contracts_FirstContract cf
		on cc.customer_id = cf.customer_id
	WHERE 
		cc.date_registered <= cf.contract_date 
	ORDER BY cc.customer_id

	
	INSERT INTO dbo.Customer_FirstContract_Excluded
	(
      [customer_id]
      ,[contract_id]
      ,[date_registered]
      ,[date_first_contract]
	)
	SELECT 
		cc.customer_id
		,cf.contract_id
		,cc.date_registered
		,cf.contract_date

	FROM customer_clean cc
	INNER JOIN Contracts_FirstContract cf
		on cc.customer_id = cf.customer_id
	WHERE 
		cc.date_registered > cf.contract_date 
	ORDER BY cc.customer_id

	/* QA */
	DECLARE
		@TotalCustomers int
		,@RecordsKept int
		,@RecordsExcluded int

	SELECT @TotalCustomers = count(1) 
	FROM customer_clean cc
	INNER JOIN Contracts_FirstContract cf
		on cc.customer_id = cf.customer_id


	SELECT @RecordsKept = count(1) 
	FROM dbo.Customer_FirstContract

	SELECT @RecordsExcluded = count(1) 
	FROM dbo.Customer_FirstContract_Excluded

	PRINT ' -------------------------- '
	PRINT 'Creating Table Customer_FirstContract'
	PRINT 'Total Customers: ' + cast(@TotalCustomers as varchar(10))
	PRINT 'Records Kept: ' + cast(@RecordsKept as varchar(10))
	PRINT 'Records Excluded: ' + cast(@RecordsExcluded as varchar(10))
	PRINT ' -------------------------- '
END
GO

