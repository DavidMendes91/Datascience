CREATE PROCEDURE [dbo].[proc_FullETL] 
AS
BEGIN
	
	-- EXEC dbo.createData;
	EXEC dbo.proc_Customer_Clean
	EXEC dbo.proc_Contract_Clean
	EXEC dbo.proc_Contract_FirstContract
	EXEC dbo.proc_Customer_FirstContract
	EXEC dbo.proc_Customer_PerMonth
	EXEC dbo.proc_Customer_FirstContract_MonthDiff
	EXEC dbo.proc_pivot_Customer_PerMonth_FirstContract_MonthDiff_percent


	SELECT 
		month_registered
		,[1],[2],[3],[4],[5],[6]
		,[7],[8],[9],[10],[11],[12]
	FROM dbo.pivot_Customer_PerMonth_FirstContract_MonthDiff_percent

END
GO
