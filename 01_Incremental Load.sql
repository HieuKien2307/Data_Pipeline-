-- Initial load
INSERT INTO StagingPerson (PersonID, FullName, Territory)
SELECT BusinessEntityID, FirstName + ' ' + LastName, NULL
FROM Person.Person;
-- Lấy Last Extract Time để Delta Load
DECLARE @LastExtractTime DATETIME;
SELECT @LastExtractTime = LastExtractTime FROM ETL_Control WHERE ProcessName = 'SalesPerson_Extraction';

-- Incremental Load

-- Bước 1: up staging

INSERT INTO StagingPerson (PersonID, FullName, Territory, LoadDate)
SELECT sp.BusinessEntityID, p.FirstName + ' ' + p.LastName, st.Name, GETDATE()
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
WHERE p.ModifiedDate >= @LastExtractTime;

-- Bước 2: Cập nhật DimPerson_Type1
UPDATE dp
SET dp.FullName = sp.FullName,
    dp.Territory = sp.Territory,
    dp.UpdatedAt = GETDATE()
FROM DimPerson_Type1 dp
JOIN StagingPerson sp ON dp.PersonID = sp.PersonID
WHERE dp.FullName <> sp.FullName OR dp.Territory <> sp.Territory;

-- Bước 2: Cập nhật DimPerson_Type2
UPDATE DimPerson_Type2
SET EndDate = GETDATE(), IsCurrent = 0
WHERE EXISTS (
    SELECT 1 FROM StagingPerson sp
    WHERE DimPerson_Type2.PersonID = sp.PersonID
    AND (
        DimPerson_Type2.FullName <> sp.FullName
        OR DimPerson_Type2.Territory <> sp.Territory
    )
    AND DimPerson_Type2.IsCurrent = 1
);

-- Insert bản ghi mới vào DimPerson_Type2
INSERT INTO DimPerson_Type2 (PersonID, FullName, Territory, StartDate)
SELECT sp.PersonID, sp.FullName, sp.Territory, GETDATE()
FROM StagingPerson sp
WHERE EXISTS (
    SELECT 1 FROM DimPerson_Type2 dp
    WHERE sp.PersonID = dp.PersonID 
    AND dp.IsCurrent = 0 -- Đã có bản ghi cũ bị đóng
    AND (dp.FullName <> sp.FullName OR dp.Territory <> sp.Territory)
);
-- Load FactOrder Type 1 (Most Recent Record from DimPerson_Type1)
INSERT INTO FactOrder (OrderID, PersonKey, OrderDate, TotalAmount, InsertedAt, UpdatedAt)
SELECT soh.SalesOrderID, dp.PersonKey, soh.OrderDate, soh.TotalDue, GETDATE(), GETDATE()
FROM Sales.SalesOrderHeader soh
JOIN DimPerson_Type1 dp ON soh.SalesPersonID = dp.PersonID
WHERE soh.OrderDate >= @LastExtractTime;

-- Load Fact Order (type 2)
INSERT INTO FactOrder (OrderID, PersonKey, OrderDate, TotalAmount, InsertedAt, UpdatedAt)
SELECT soh.SalesOrderID, dp.PersonKey, soh.OrderDate, soh.TotalDue, GETDATE(), GETDATE()
FROM Sales.SalesOrderHeader soh
JOIN DimPerson_Type2 dp ON soh.SalesPersonID = dp.PersonID
WHERE soh.OrderDate >= @LastExtractTime
AND soh.OrderDate BETWEEN dp.StartDate AND ISNULL(dp.EndDate, '9999-12-31') -- Đảm bảo lấy đúng PersonKey tại thời điểm OrderDate
AND NOT EXISTS (  -- Tránh insert trùng
    SELECT 1 FROM FactOrder f
    WHERE f.OrderID = soh.SalesOrderID
);



-- Update bảng ETL Control with lần extract gần nhất
UPDATE ETL_Control
SET LastExtractTime = GETDATE()
WHERE ProcessName = 'SalesPerson_Extraction';
