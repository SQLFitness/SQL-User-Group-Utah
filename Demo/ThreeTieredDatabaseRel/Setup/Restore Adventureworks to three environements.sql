USE [master]
GO

RESTORE DATABASE [AdventureWorks_development] FROM  DISK = N'C:\Data\AdventureWorks2014.bak' WITH  FILE = 1,  
MOVE N'AdventureWorks2014_Data' TO N'C:\Data\AdventureWorks_development_Data.mdf',  
MOVE N'AdventureWorks2014_Log' TO N'C:\Data\AdventureWorks_development_Log.ldf',  NOUNLOAD,  STATS = 5
GO

RESTORE DATABASE [AdventureWorks_staging] FROM  DISK = N'C:\Data\AdventureWorks2014.bak' WITH  FILE = 1,  
MOVE N'AdventureWorks2014_Data' TO N'C:\Data\AdventureWorks_staging_Data.mdf',  
MOVE N'AdventureWorks2014_Log' TO N'C:\Data\AdventureWorks_staging_Log.ldf',  NOUNLOAD,  STATS = 5
GO

RESTORE DATABASE [AdventureWorks_production] FROM  DISK = N'C:\Data\AdventureWorks2014.bak' WITH  FILE = 1,  
MOVE N'AdventureWorks2014_Data' TO N'C:\Data\AdventureWorks_production_Data.mdf',  
MOVE N'AdventureWorks2014_Log' TO N'C:\Data\AdventureWorks_production_Log.ldf',  NOUNLOAD,  STATS = 5
GO

USE AdventureWorks_development
GO

EXEC sys.sp_changedbowner @loginame = sa
GO
CREATE USER [SVC-HR] FOR LOGIN [SVC-HR]
GO

USE AdventureWorks_staging
GO

EXEC sys.sp_changedbowner @loginame = sa
GO 
CREATE USER [SVC-HR] FOR LOGIN [SVC-HR]
GO

USE AdventureWorks_production
GO

EXEC sys.sp_changedbowner @loginame = sa
GO
CREATE USER [SVC-HR] FOR LOGIN [SVC-HR]
GO