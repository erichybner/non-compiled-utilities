-- DB in Full or Bulk Logged with no transaction log backups since last full backup
SELECT   D.[name] AS [database_name],
         D.[recovery_model_desc]
FROM     sys.databases AS D
         LEFT OUTER JOIN
         (SELECT   BS.[database_name],
                   MAX(BS.[backup_finish_date]) AS [last_log_backup_date]
          FROM     msdb.dbo.backupset AS BS
          WHERE    BS.type = 'L'
          GROUP BY BS.[database_name]) AS BS1
         ON D.[name] = BS1.[database_name]
         LEFT OUTER JOIN
         (SELECT   BS.[database_name],
                   MAX(BS.[backup_finish_date]) AS [last_data_backup_date]
          FROM     msdb.dbo.backupset AS BS
          WHERE    BS.type = 'D'
          GROUP BY BS.[database_name]) AS BS2
         ON D.[name] = BS2.[database_name]
WHERE    D.[recovery_model_desc] <> 'SIMPLE'
         AND BS1.[last_log_backup_date] IS NULL
         OR BS1.[last_log_backup_date] < BS2.[last_data_backup_date]
ORDER BY D.[name];