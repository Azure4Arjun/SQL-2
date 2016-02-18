SELECT
    DB.name,
    SUM(CASE WHEN type = 0 THEN MF.size * 8 / 1024 ELSE 0 END) AS DataFileSizeMB,
    SUM(CASE WHEN type = 1 THEN MF.size * 8 / 1024 ELSE 0 END) AS LogFileSizeMB
FROM
    sys.master_files MF
    JOIN sys.databases DB ON DB.database_id = MF.database_id
GROUP BY DB.name
ORDER BY DataFileSizeMB DESC