/*
Run this script on:

        ROBYN_N_STEVE\DEV2014.AdventureWorks_production    -  This database will be modified

to synchronize it with:

        ROBYN_N_STEVE\DEV2014.AdventureWorks_staging

You are recommended to back up your database before running this script

Script created by SQL Compare version 11.3.0 from Red Gate Software Ltd at 11/20/2015 2:41:26 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
USE [AdventureWorks_production]
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [HumanResources].[Department]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [HumanResources].[Department] ADD
[IsActive] [bit] NOT NULL CONSTRAINT [DF__Departmen__IsAct__24B26D99] DEFAULT ((1))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [HumanResources].[usp_GetAllEmployeesWithInactiveDepartment]'
GO

CREATE PROCEDURE [HumanResources].[usp_GetAllEmployeesWithInactiveDepartment]
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

	SELECT D.DepartmentID, 
		D.Name, D.IsActive,
        EDH.ShiftID, 
		EDH.StartDate,
        EDH.EndDate, 
		E.NationalIDNumber,
		E.LoginID, 
		E.OrganizationLevel, 
		E.JobTitle,
		E.HireDate
	FROM HumanResources.Department AS D
	JOIN HumanResources.EmployeeDepartmentHistory AS EDH ON EDH.DepartmentID = D.DepartmentID
	JOIN HumanResources.Employee AS E ON E.BusinessEntityID = EDH.BusinessEntityID
	WHERE D.IsActive = 0
		AND EDH.EndDate IS NULL 

END 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [Production].[usp_GetWhereUsedProducts_All]'
GO

CREATE PROCEDURE [Production].[usp_GetWhereUsedProducts_All]
    @CheckDate [DATETIME] = NULL 
AS
BEGIN
    SET NOCOUNT ON;
	IF(@CheckDate IS NULL)
	BEGIN 
		SELECT @CheckDate = MAX(BOM.StartDate) - 10 
		FROM Production.BillOfMaterials AS BOM;
	END 

    --Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 components of a level 0 assembly, all level 2 components of a level 1 assembly)
    ;WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
        FROM [Production].[BillOfMaterials] b
            INNER JOIN [Production].[Product] p 
            ON b.[ProductAssemblyID] = p.[ProductID] 
        WHERE @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        UNION ALL
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [BOM_cte] cte
            INNER JOIN [Production].[BillOfMaterials] b 
            ON cte.[ProductAssemblyID] = b.[ComponentID]
            INNER JOIN [Production].[Product] p 
            ON b.[ProductAssemblyID] = p.[ProductID] 
        WHERE @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        )
    -- Outer select from the CTE
    SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
    FROM [BOM_cte] b
    GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
    ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
    OPTION (MAXRECURSION 25) 
END;
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
