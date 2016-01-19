USE AdventureWorks_staging
GO

ALTER TABLE HumanResources.Department
ADD IsActive BIT NOT NULL DEFAULT(1);