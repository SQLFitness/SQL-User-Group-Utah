USE AdventureWorks_development
GO

CREATE ROLE HumanResources AUTHORIZATION dbo;

EXEC sys.sp_addrolemember @rolename = HumanResources, -- sysname
    @membername = [SVC-HR] -- sysname
