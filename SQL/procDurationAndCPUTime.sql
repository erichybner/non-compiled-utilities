-- Lifted from the internet and adjusted. Original source forgotten.
-- find -- Your proc here below, and put your proc on the following line.

-- Calculate Duration and CPU Time
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Take a pre-work snapshot.
SELECT sql_handle,
       plan_handle,
       total_elapsed_time,
       total_worker_time,
       total_logical_reads,
       total_logical_writes,
       total_clr_time,
       execution_count,
       statement_start_offset,
       statement_end_offset
INTO   #PreWorkQuerySnapShot
FROM   sys.dm_exec_query_stats AS
-- Your proc here
prms_retr_cad_dispatch_active_calls_prc;

-- Take a post-work snapshot.
SELECT sql_handle,
       plan_handle,
       total_elapsed_time,
       total_worker_time,
       total_logical_reads,
       total_logical_writes,
       total_clr_time,
       execution_count,
       statement_start_offset,
       statement_end_offset
INTO   #PostWorkQuerySnapShot
FROM   sys.dm_exec_query_stats;

--  Calculate the delta between the snapshots, and order by duration.
SELECT   p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0) AS [Duration],
         p2.total_worker_time - ISNULL(p1.total_worker_time, 0) AS [Time on CPU],
         (p2.total_elapsed_time - ISNULL(p1.total_elapsed_time, 0)) - (p2.total_worker_time - ISNULL(p1.total_worker_time, 0)) AS [Time blocked],
         p2.total_logical_reads - ISNULL(p1.total_logical_reads, 0) AS [Reads],
         p2.total_logical_writes - ISNULL(p1.total_logical_writes, 0) AS [Writes],
         p2.total_clr_time - ISNULL(p1.total_clr_time, 0) AS [CLR time],
         p2.execution_count - ISNULL(p1.execution_count, 0) AS [Executions],
         SUBSTRING(qt.text, p2.statement_start_offset / 2 + 1, ((CASE 
WHEN p2.statement_end_offset = -1 THEN LEN(CONVERT (NVARCHAR (MAX), qt.text)) * 2 ELSE p2.statement_end_offset 
END - p2.statement_start_offset) / 2) + 1) AS [Individual Query],
         qt.text AS [Parent Query],
         DB_NAME(qt.dbid) AS DatabaseName
FROM     #PreWorkQuerySnapShot AS p1
         RIGHT OUTER JOIN
         #PostWorkQuerySnapShot AS p2
         ON p2.sql_handle = ISNULL(p1.sql_handle, p2.sql_handle)
            AND p2.plan_handle = ISNULL(p1.plan_handle, p2.plan_handle)
            AND p2.statement_start_offset = ISNULL(p1.statement_start_offset, p2.statement_start_offset)
            AND p2.statement_end_offset = ISNULL(p1.statement_end_offset, p2.statement_end_offset) CROSS APPLY sys.dm_exec_sql_text (p2.sql_handle) AS qt
WHERE    p2.execution_count != ISNULL(p1.execution_count, 0)
         AND qt.text NOT LIKE '-ThisRoutineIdentifier%'
ORDER BY [Duration] DESC;

-- Tidy up.
DROP TABLE #PreWorkQuerySnapShot;

DROP TABLE #PostWorkQuerySnapShot;