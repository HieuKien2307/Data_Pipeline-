USE AdventureWorks2022;

-- Fact Order
CREATE TABLE FactOrder (
    OrderKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    PersonKey INT,
    OrderDate DATETIME, 
    TotalAmount DECIMAL(18,2),
    InsertedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Dim Person SCD Type 1
CREATE TABLE DimPerson_Type1 (
    PersonKey INT IDENTITY(1,1) PRIMARY KEY,
    PersonID INT UNIQUE,
    FullName NVARCHAR(255),
    Territory NVARCHAR(255),
    InsertedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- Dim Person SCD Type 2 (Lưu lịch sử)
CREATE TABLE DimPerson_Type2 (
    PersonKey INT IDENTITY(1,1) PRIMARY KEY,
    PersonID INT,
    FullName NVARCHAR(255),
    Territory NVARCHAR(255),
    StartDate DATETIME, 
    EndDate DATETIME NULL, 
    IsCurrent BIT DEFAULT 1,
    InsertedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Staging Table
CREATE TABLE StagingPerson (
    PersonID INT,
    FullName NVARCHAR(255),
    Territory NVARCHAR(255),
    LoadDate DATETIME DEFAULT GETDATE() 
);

-- Tạo thêm bảng lưu lần update cuối
CREATE TABLE ETL_Control (
    ProcessName NVARCHAR(255) PRIMARY KEY,
    LastExtractTime DATETIME
);

-- Gán sẵn 
INSERT INTO ETL_Control (ProcessName, LastExtractTime)
VALUES ('SalesPerson_Extraction', '2011-01-01 00:00:00');

