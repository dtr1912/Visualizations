CREATE PROCEDURE DropColumnFromAllTables 
    @schema_name NVARCHAR(128),
    @column_name NVARCHAR(128)
AS
BEGIN
    DECLARE @table_name NVARCHAR(128);
    DECLARE @sql NVARCHAR(MAX);

    DECLARE cur CURSOR FOR
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE COLUMN_NAME = @column_name
      AND TABLE_SCHEMA = @schema_name;

    OPEN cur;

    FETCH NEXT FROM cur INTO @table_name;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = N'ALTER TABLE ' + QUOTENAME(@schema_name) + '.' + QUOTENAME(@table_name) + ' DROP COLUMN ' + QUOTENAME(@column_name);

        BEGIN TRY
            EXEC sp_executesql @sql;
        END TRY
        BEGIN CATCH
            PRINT 'Error dropping column ' + @column_name + ' from table ' + @table_name + ': ' + ERROR_MESSAGE();
        END CATCH;

        FETCH NEXT FROM cur INTO @table_name;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
