SELECT message_id [error_number], severity, text
FROM sys.messages 
WHERE text LIKE ('%availability%') and language_id = 1033
AND  is_event_logged = 1
order by severity