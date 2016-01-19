/*
Run this script on:

        ROBYN_N_STEVE\DEV2014.AdventureWorks_staging    -  This database will be modified

to synchronize it with:

        ROBYN_N_STEVE\DEV2014.AdventureWorks_production

You are recommended to back up your database before running this script

Script created by SQL Compare version 11.3.0 from Red Gate Software Ltd at 11/20/2015 2:42:40 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
USE [AdventureWorks_staging]
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HumanResources].[Department]'
GO
ALTER TABLE [HumanResources].[Department] DROP CONSTRAINT [DF__Departmen__IsAct__24B26D99]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [Production].[usp_GetWhereUsedProducts_All]'
GO
DROP PROCEDURE [Production].[usp_GetWhereUsedProducts_All]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HumanResources].[usp_GetAllEmployeesWithInactiveDepartment]'
GO
DROP PROCEDURE [HumanResources].[usp_GetAllEmployeesWithInactiveDepartment]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [HumanResources].[Department]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [HumanResources].[Department] DROP
COLUMN [IsActive]
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
