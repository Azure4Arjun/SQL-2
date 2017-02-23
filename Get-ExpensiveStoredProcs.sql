/**************************************************************/
--Script: Top 25 Costliest Stored Procedures by Logical Reads
--Works On: 2008, 2008 R2, 2012, 2014, 2016
/**************************************************************/

SELECT  TOP(25)
        p.name AS [SP Name],
        qs.total_logical_reads AS [TotalLogicalReads],
        qs.total_logical_reads/qs.execution_count AS [AvgLogicalReads],
        qs.execution_count AS 'execution_count',
        qs.total_elapsed_time AS 'total_elapsed_time',
        qs.total_elapsed_time/qs.execution_count AS 'avg_elapsed_time',
        qs.cached_time AS 'cached_time'
FROM    sys.procedures AS p
        INNER JOIN sys.dm_exec_procedure_stats AS qs 
                   ON p.[object_id] = qs.[object_id]
WHERE
        qs.database_id = DB_ID()
ORDER BY
        qs.total_logical_reads DESC;