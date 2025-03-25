use AdventureWorks2022

CREATE TRIGGER trg_UpdateDimPerson
ON StagingPerson
AFTER INSERT
AS
BEGIN
    EXEC sp_executesql N'EXEC Job_UpdateDimPersonType1';
    EXEC sp_executesql N'EXEC Job_UpdateDimPersonType2';
END;
