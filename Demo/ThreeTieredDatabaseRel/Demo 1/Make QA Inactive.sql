USE AdventureWorks_staging
GO

--deactivate department
BEGIN TRANSACTION

UPDATE HumanResources.Department
SET IsActive = 0, ModifiedDate = GETDATE()
WHERE DepartmentID = 13

COMMIT TRANSACTION
