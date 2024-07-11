DECLARE @TableName NVARCHAR(128) = 'DimStore';
DECLARE @ColumnName NVARCHAR(128);
DECLARE @SQL NVARCHAR(MAX);

DECLARE column_cursor CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName;

OPEN column_cursor;

FETCH NEXT FROM column_cursor INTO @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'SELECT ''' + @ColumnName + ''' AS ColumnName, COUNT(*) AS NullCount FROM ' + @TableName + ' WHERE ' + @ColumnName + ' IS NULL;';
    EXEC sp_executesql @SQL;
    FETCH NEXT FROM column_cursor INTO @ColumnName;
END

CLOSE column_cursor;
DEALLOCATE column_cursor;

