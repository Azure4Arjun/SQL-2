DBCC SQLPERF (LOGSPACE)

select name, log_reuse_wait, log_reuse_wait_desc from sys.databases

DBCC SHRINKFILE(ArchiveManager_log, TRUNCATEONLY) 
DBCC SHRINKFILE(ArchiveManager_log, 1) 


DBCC SHRINKFILE(ArchiveManager_log)
BACKUP LOG ArchiveManager TO DISK=N'\\Isk-storage01\isk-qam01$\ArchiveManager\backup.trn'
DBCC SHRINKFILE(ArchiveManager_log)

USE ArchiveManager;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE ArchiveManager
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (ArchiveManager_log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE ArchiveManager
SET RECOVERY FULL;
GO