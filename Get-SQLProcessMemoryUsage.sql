/**************************************************************/
-- Script: SQL Server Process Memory Usage
-- Works On: 2008, 2008 R2, 2012, 2014, 2016
/**************************************************************/
select
      physical_memory_in_use_kb/1048576.0 AS 'physical_memory_in_use (GB)',
      locked_page_allocations_kb/1048576.0 AS 'locked_page_allocations (GB)',
      virtual_address_space_committed_kb/1048576.0 AS 'virtual_address_space_committed (GB)',
      available_commit_limit_kb/1048576.0 AS 'available_commit_limit (GB)',
      page_fault_count as 'page_fault_count'
from  sys.dm_os_process_memory;