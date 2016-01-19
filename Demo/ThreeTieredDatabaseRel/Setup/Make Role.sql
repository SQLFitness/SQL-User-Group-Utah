USE AdventureWorks_staging
GO

CREATE ROLE HumanResources AUTHORIZATION dbo;

EXEC sys.sp_addrolemember @rolename = HumanResources, -- sysname
    @membername = [SVC-HR] -- sysname


GRANT EXECUTE ON SCHEMA::HumanResources TO HumanResources
GRANT exect