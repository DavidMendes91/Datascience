CREATE PROCEDURE [dbo].[proc_Contract_FirstContract] 
AS
BEGIN
	
	IF OBJECT_ID('dbo.Contracts_FirstContract', 'U') IS NOT NULL 
		DROP TABLE Contracts_FirstContract; 

	CREATE TABLE dbo.Contracts_FirstContract (
		id int identity(1,1)
		,[customer_id] int NOT NULL
		,[contract_id] int NOT NULL
		,[contract_date] date not null
	);

	INSERT INTO dbo.Contracts_FirstContract
	(
      [customer_id]
	  ,[contract_id]
      ,[contract_date]
	)	
	SELECT 
		customer_id
		,MIN(contract_id)
		,MIN(contract_date)
	FROM Contracts_Clean
	GROUP BY customer_id 
	ORDER BY customer_id

	/* QA */
	DECLARE
		@TotalContracts int
		,@RecordsKept int
		,@RecordsExcluded int

	SET @TotalContracts =
		(SELECT COUNT(1) FROM contracts_clean)
	SET @RecordsKept =
		(SELECT COUNT(1) FROM Contracts_FirstContract)
	
	; with extra_contracts as (
		SELECT 
			customer_id
			,COUNT(contract_id)-1 as extra
		FROM contracts_clean
		GROUP BY customer_id
	)
	SELECT @RecordsExcluded = SUM(extra) from extra_contracts

	PRINT ' ------------------------------'
	PRINT 'Created Contracts_FirstContract Table'
	PRINT 'Total Contracts: ' + cast(@TotalContracts as varchar(10))
	PRINT 'Records Kept: ' + cast(@RecordsKept as varchar(10))
	PRINT 'Records Excluded: ' + cast(@RecordsExcluded as varchar(10))
	PRINT ' ------------------------------'
END
GO


