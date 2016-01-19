USE AdventureWorks_staging
GO

SELECT COUNT(*), D.DepartmentID, D.Name, isactive
FROM HumanResources.Department AS D
GROUP BY D.DepartmentID, d.Name, D.isactive



BEGIN TRANSACTION

UPDATE HumanResources.Department
SET IsActive = 0, ModifiedDate = GETDATE()
WHERE DepartmentID = 13

COMMIT TRANSACTION