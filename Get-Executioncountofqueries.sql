SELECT last_execution_time, execution_count,[text], total_elapsed_time, last_elapsed_time, max_elapsed_time, total_worker_time, min_worker_time, max_worker_time
FROM sys.dm_exec_query_stats AS deqs
CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
where dbid = (select database_id from sys.databases where name = 'SP_PRD_Web_Business_01')
ORDER BY deqs.execution_count DESC