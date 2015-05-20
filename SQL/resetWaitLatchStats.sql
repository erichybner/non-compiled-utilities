-- Reset wait stats
DBCC SQLPERF("sys.dm_os_wait_stats",CLEAR);
DBCC SQLPERF("sys.dm_os_latch_stats",CLEAR);