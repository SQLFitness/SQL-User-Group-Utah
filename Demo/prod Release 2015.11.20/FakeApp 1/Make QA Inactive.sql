USE AdventureWorks_staging
GO

--Reactivate QA
BEGIN TRANSACTION

UPDATE HumanResources.Department
SET IsActive = 0, ModifiedDate = GETDATE()
WHERE DepartmentID = 13

COMMIT TRANSACTION