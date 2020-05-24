CREATE PROCEDURE [dbo].[proc_pivot_Customer_PerMonth_FirstContract_MonthDiff_percent] 
AS
BEGIN
	
	IF OBJECT_ID('dbo.pivot_Customer_PerMonth_FirstContract_MonthDiff_percent', 'U') IS NOT NULL 
		DROP TABLE dbo.pivot_Customer_PerMonth_FirstContract_MonthDiff_percent ; 

	CREATE TABLE dbo.pivot_Customer_PerMonth_FirstContract_MonthDiff_percent (
		id int identity(1,1)
		, month_registered int
		, [1] real
		, [2] real
		, [3] real
		, [4] real
		, [5] real
		, [6] real
		, [7] real
		, [8] real
		, [9] real
		, [10] real
		, [11] real
		, [12] real
	);

	INSERT INTO dbo.pivot_Customer_PerMonth_FirstContract_MonthDiff_percent
	(
		month_registered 
		, [1] 
		, [2]
		, [3]
		, [4]
		, [5]
		, [6]
		, [7]
		, [8]
		, [9]
		, [10]
		, [11]
		, [12]
	)


	SELECT 
		month_registered
		,[1],[2],[3],[4],[5],[6]
		,[7],[8],[9],[10],[11],[12]
	FROM
	(
		SELECT 
			[month_registered] 
			, [month_diff]
			,	CASE 
					WHEN SUM(customer_count) 
						 OVER (PARTITION BY month_registered) > 0
					THEN ROUND ( 
							cast(customer_count AS real)
							/ SUM(customer_count) 
							  OVER (PARTITION BY month_registered)
							, 2 )
					ELSE 0
				END as customer_percentage
		FROM [ergi].[dbo].[Customer_PerMonth_FirstContract_Monthdiff]
	) a
	PIVOT (
		SUM(customer_percentage)
		FOR month_diff in (
			[1],[2],[3],[4],[5],[6]
			,[7],[8],[9],[10],[11],[12])
	) b
END
GO


