CREATE PROCEDURE [dbo].[proc_Contract_Clean] 
AS
BEGIN
	
	IF OBJECT_ID('dbo.Contracts_Clean', 'U') IS NOT NULL 
		DROP TABLE dbo.Contracts_Clean; 

	IF OBJECT_ID('dbo.Contracts_Excluded', 'U') IS NOT NULL 
		DROP TABLE dbo.Contracts_Excluded; 

	CREATE TABLE dbo.Contracts_Clean (
		id int identity(1,1)
		,[customer_id] int NOT NULL
		,[contract_id] int NOT NULL
		,[contract_date] date not null
	);

	CREATE TABLE dbo.Contracts_Excluded (
		id int identity(1,1)
		,[customer_id] int NOT NULL
		,[contract_id] int NOT NULL
		,[contract_date] date not null
	);

	INSERT INTO dbo.Contracts_Clean
	(
      [customer_id]
	  ,[contract_id]
      ,[contract_date]
	)	
	SELECT 
		fc.[Customer ID]
		,fc.[Contract ID]
		,fc.[Created Date]
	FROM facts_contract fc
	WHERE 
		fc.[Customer ID] IS NOT NULL
		AND fc.[Contract ID] IS NOT NULL
		AND fc.[Created Date] IS NOT NULL
	ORDER BY fc.[Customer ID]


	INSERT INTO dbo.Contracts_Excluded
	(
      [customer_id]
	  ,[contract_id]
      ,[contract_date]
	)	
	SELECT 
		fc.[Customer ID]
		,fc.[Contract ID]
		,fc.[Created Date]
	FROM facts_contract fc
	WHERE 
		fc.[Customer ID] IS NULL
		OR fc.[Contract ID] IS NULL
		OR fc.[Created Date] IS NULL
	ORDER BY fc.[Customer ID]

	/* QA */
	DECLARE
		@TotalContracts int
		,@RecordsKept int
		,@RecordsExcluded int

	SET @TotalContracts =
		(SELECT COUNT(1) FROM facts_contract)
	SET @RecordsKept =
		(SELECT COUNT(1) FROM Contracts_Clean)
	SET @RecordsExcluded =
		(SELECT COUNT(1) FROM Contracts_Excluded)
	
	PRINT ' ------------------------------'
	PRINT 'Created Contracts_Clean Table'
	PRINT 'Total Contracts: ' + cast(@TotalContracts as varchar(10))
	PRINT 'Records Kept: ' + cast(@RecordsKept as varchar(10))
	PRINT 'Records Excluded: ' + cast(@RecordsExcluded as varchar(10))
	PRINT ' ------------------------------'
END
GO
