CREATE PROCEDURE [dbo].[proc_Customer_PerMonth] 
AS
BEGIN
	
	IF OBJECT_ID('dbo.Customer_PerMonth', 'U') IS NOT NULL 
		DROP TABLE dbo.Customer_PerMonth ; 

	CREATE TABLE dbo.Customer_PerMonth (
		id int identity(1,1)
		, month_registered int
		, total_costumers int
	);

	INSERT INTO dbo.Customer_PerMonth
	(
		month_registered
		, total_costumers
	)

	SELECT
		DATEPART(mm, [date_registered]) as month_registered
		,COUNT([customer_id]) AS new_customers
	
	FROM Customer_FirstContract
	GROUP BY DATEPART(mm, [date_registered])
	ORDER BY DATEPART(mm, [date_registered])
END
GO

