ALTER DATABASE tempdb
--Move files
ALTER DATABASE tempdb MODIFY FILE ( NAME = 'tempdev2', FILENAME = 'H:\EXTSP13\tempdev2.mdf' )
ALTER DATABASE tempdb MODIFY FILE ( NAME = 'tempdev3', FILENAME = 'H:\EXTSP13\tempdev3.mdf' )
ALTER DATABASE tempdb MODIFY FILE ( NAME = 'tempdev4', FILENAME = 'H:\EXTSP13\tempdev4.mdf' )
ALTER DATABASE tempdb MODIFY FILE ( NAME = 'templog', FILENAME = 'H:\EXTSP13\templog.ldf' )