--------------------
-- Check for I/O Stalls, to see if there are files or disks where SQL is struggling to read/write
SELECT   a.io_stall,
         a.io_stall_read_ms,
         a.io_stall_write_ms,
         a.num_of_reads,
         a.num_of_writes,
         --a.sample_ms, a.num_of_bytes_read, a.num_of_bytes_written, a.io_stall_write_ms,
         ((a.size_on_disk_bytes / 1024) / 1024.0) AS size_on_disk_mb,
         db_name(a.database_id) AS dbname,
         b.name,
         a.file_id,
         CASE 
WHEN a.file_id = 2 THEN 'Log' ELSE 'Data' 
END AS db_file_type,
         UPPER(SUBSTRING(b.physical_name, 1, 2)) AS disk_location
FROM     sys.dm_io_virtual_file_stats (NULL, NULL) AS a
         INNER JOIN
         sys.master_files AS b
         ON a.file_id = b.file_id
            AND a.database_id = b.database_id
ORDER BY a.io_stall DESC;

--------------------
-- Are transaction logs getting truncated? If not, there may be an issue with recovery model and backup strategy
SELECT name,
       recovery_model_desc,
       log_reuse_wait,
       log_reuse_wait_desc
FROM   sys.databases;

--------------------