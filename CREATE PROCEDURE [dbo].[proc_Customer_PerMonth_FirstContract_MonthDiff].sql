CREATE PROCEDURE [dbo].[proc_Customer_PerMonth_FirstContract_MonthDiff] 
AS
BEGIN

	IF OBJECT_ID('dbo.Customer_PerMonth_FirstContract_MonthDiff ', 'U') IS NOT NULL 
		DROP TABLE dbo.Customer_PerMonth_FirstContract_MonthDiff;

	CREATE TABLE dbo.Customer_PerMonth_FirstContract_MonthDiff (
		[id] int identity(1,1)
		,[month_registered] int
		,[month_diff] int
		,[customer_count] int
	)

	IF OBJECT_ID('tempdb..#FullCalendar') IS NOT NULL 
		DROP TABLE #FullCalendar;

	CREATE TABLE #FullCalendar (
		  month_registered int
		, month_diff int
	)

	DECLARE 
		  @i int = 1
		, @h int = 1

	WHILE @i <= 12
	BEGIN
		SET @h = 1
		WHILE @h <= 12
		BEGIN
			INSERT INTO #FullCalendar(
				  month_registered
				, month_diff
			) VALUES (
				  @i
				, @h
			)
			SET @h = @h +1
		END
		SET @i = @i + 1
	END



	INSERT INTO dbo.Customer_PerMonth_FirstContract_MonthDiff (
		[month_registered] 
		,[month_diff] 
		,[customer_count]
	)

	SELECT 
		fc.month_registered
		,fc.month_diff
		,count(c.customer_id) as customer_total
	FROM Customer_FirstContract_MonthDiff c
	RIGHT JOIN #FullCalendar fc
		ON c.month_registered = fc.month_registered
		AND c.month_diff =  fc.month_diff
	GROUP BY fc.month_registered, fc.month_diff
	ORDER BY fc.month_registered, fc.month_diff

END
GO
