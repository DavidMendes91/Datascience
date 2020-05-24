CREATE  PROCEDURE [dbo].[proc_Customer_FirstContract_MonthDiff] 
AS
BEGIN
	
	IF OBJECT_ID('dbo.Customer_FirstContract_MonthDiff ', 'U') IS NOT NULL 
		DROP TABLE dbo.Customer_FirstContract_MonthDiff ; 

	CREATE TABLE dbo.Customer_FirstContract_MonthDiff (
		id int identity(1,1)
		,customer_id int
		,month_registered int
		,month_contract int
		,month_diff int
	);

	INSERT INTO dbo.Customer_FirstContract_MonthDiff
	(
		customer_id 
		,month_registered 
		,month_contract
		,month_diff 
	)

	SELECT 
		[customer_id]
		, DATEPART(mm,[date_registered]) as month_registered
		, DATEPART(mm,[date_first_contract]) as month_contract
		, DATEDIFF(mm,[date_registered], [date_first_contract]) 
			+ 1 -- contracts made in first month result 1 (int)
			as month_diff
	FROM [ergi].[dbo].[Customer_FirstContract] 
	WHERE date_first_contract > date_registered -- QA
	ORDER BY customer_id

	/*
		QA 
	*/
END
GO
