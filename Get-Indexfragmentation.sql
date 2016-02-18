IF EXISTS (	SELECT * 
	FROM [tempdb].[dbo].[sysobjects] 
	WHERE id = OBJECT_ID(N'[tempdb].[dbo].[tmp_indexfragmentation_details]'))
	DROP TABLE [tempdb].[dbo].[tmp_indexfragmentation_details] 
GO

CREATE TABLE [tempdb].[dbo].[tmp_indexfragmentation_details](
	[DatabaseName] 					[nvarchar] (100) NULL,
	[ObjectName]					[nvarchar] (100) NULL,
	[Index_id] 						INT,
	[indexName] 					[nvarchar] (100) NULL,
	[avg_fragmentation_percent]		float NULL,
	[IndexType] 					[nvarchar] (100) NULL,
	[Action_Required] 				[nvarchar] (100) default 'NA' 
) ON [PRIMARY]

DECLARE @dbname varchar(1000)
DECLARE @sqlQuery nvarchar(4000)

DECLARE dbcursor CURSOR for
SELECT name FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')

OPEN dbcursor
FETCH NEXT FROM dbcursor INTO @dbname

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sqlQuery = '
	USE [' + @dbname + '];

	IF EXISTS
	(
		SELECT compatibility_level 
		FROM sys.databases 
		WHERE 
			name  = N'''+ @dbname +'''
			AND compatibility_level >= 90
	)
	BEGIN
		INSERT INTO [tempdb].[dbo].[tmp_indexfragmentation_details] 
		(
			DatabaseName
			, ObjectName
			, Index_id
			, indexName
			, avg_fragmentation_percent
			, IndexType
		) 
		SELECT 
			db_name() as DatabaseName
			, OBJECT_NAME (a.object_id) as ObjectName
			, a.index_id, b.name as IndexName
			, avg_fragmentation_in_percent
			, index_type_desc 
		FROM 
			sys.dm_db_index_physical_stats (db_id(), NULL, NULL, NULL, NULL) AS a 
			JOIN sys.indexes AS b
		ON 
			a.object_id = b.object_id 
			AND a.index_id = b.index_id 
		WHERE
			b.index_id <> 0 
			AND avg_fragmentation_in_percent <> 0
	END;'
	
	EXEC sp_executesql @sqlQuery
	
FETCH NEXT FROM dbcursor
INTO @dbname
END

CLOSE dbcursor
Deallocate dbcursor

-- Update the action require for item with average fragmentation value >30 to "Rebuild"
UPDATE [tempdb].[dbo].[tmp_indexfragmentation_details] 
SET Action_Required = 'Rebuild' 
WHERE avg_fragmentation_percent >30  
GO 

-- Update the action require for item with average fragmentation value >5 & <30 to "Reindex"
UPDATE [tempdb].[dbo].[tmp_indexfragmentation_details] 
SET Action_Required = 'Reorganize' 
WHERE avg_fragmentation_percent <30 and avg_fragmentation_percent >5 
GO

-- Show the index fragmentation result
SELECT * FROM [tempdb].[dbo].[tmp_indexfragmentation_details] 
ORDER BY databasename