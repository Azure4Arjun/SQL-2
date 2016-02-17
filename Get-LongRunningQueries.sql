SELECT SDES.[Host_Name], SDES.[Program_Name], SDES.Login_Name, SDES.NT_User_Name, SD.[Name] AS 'DatabaseName',
		SDES.Memory_Usage, SDER.Status, SDER.Session_ID, SDER.Blocking_Session_ID, SDER.Request_ID,SDER.Command, 
		SDER.Wait_Type, SDER.Wait_Time, SDER.Last_Wait_Type, SDER.Wait_Resource, SDER.Open_Transaction_Count, 
		SDER.Open_ResultSet_Count, SDER.Transaction_ID, SDER.Context_Info, SDER.Reads, SDER.Logical_Reads,
		SDER.[statement_start_offset], SDER.[statement_end_offset],  
  CASE   
     WHEN SDER.[statement_start_offset] > 0 THEN  
        --The start of the active command is not at the beginning of the full command text 
        CASE SDER.[statement_end_offset]  
           WHEN -1 THEN  
              --The end of the full command is also the end of the active statement 
              SUBSTRING(DEST.TEXT, (SDER.[statement_start_offset]/2) + 1, 2147483647) 
           ELSE   
              --The end of the active statement is not at the end of the full command 
              SUBSTRING(DEST.TEXT, (SDER.[statement_start_offset]/2) + 1, (SDER.[statement_end_offset] - SDER.[statement_start_offset])/2)   
        END  
     ELSE  
        --1st part of full command is running 
        CASE SDER.[statement_end_offset]  
           WHEN -1 THEN  
              --The end of the full command is also the end of the active statement 
              RTRIM(LTRIM(DEST.[text]))  
           ELSE  
              --The end of the active statement is not at the end of the full command 
              LEFT(DEST.TEXT, (SDER.[statement_end_offset]/2) +1)  
        END  
     END AS [executing statement],  
  DEST.[text] AS [full statement code]--, SDER.*  
FROM sys.[dm_exec_requests] SDER	CROSS APPLY sys.[dm_exec_sql_text](SDER.[sql_handle]) DEST
									INNER JOIN sys.dm_exec_sessions SDES ON SDER.Session_ID = SDES.Session_ID
									INNER JOIN sys.databases SD ON SDER.Database_ID = SD.Database_ID
WHERE (SDER.[Status] = 'RUNNING' OR SDER.[Status] = 'RUNNABLE' OR SDER.[Status] = 'SUSPENDED')
AND SDER.Database_ID NOT IN (1, 2, 3, 4)--Exclude System Databases
--AND SDER.session_id != 234 --Exclude your own Session  
AND SDES.Login_Name != 'TREASURY\A_ajwaye'
ORDER BY SDER.[session_id], SDER.[request_id]