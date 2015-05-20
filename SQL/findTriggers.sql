-- Get Triggers w/ Code - by text
SELECT   Tables.Name AS TableName,
         Triggers.name AS TriggerName,
         Triggers.crdate AS TriggerCreatedDate,
         Comments.Text AS TriggerText
FROM     sysobjects AS Triggers
         INNER JOIN
         sysobjects AS Tables
         ON Triggers.parent_obj = Tables.id
         INNER JOIN
         syscomments AS Comments
         ON Triggers.id = Comments.id
WHERE    Triggers.xtype = 'TR'
         AND Tables.xtype = 'U'
         AND Comments.text LIKE '%TRIGGER_NAMES_I_WANT%,%,%,%,%,%'
ORDER BY Tables.Name, Triggers.name;

-- Get Triggers w/ Code - by date
SELECT   Tables.Name AS TableName,
         Triggers.name AS TriggerName,
         Triggers.crdate AS TriggerCreatedDate,
         Comments.Text AS TriggerText
FROM     sysobjects AS Triggers
         INNER JOIN
         sysobjects AS Tables
         ON Triggers.parent_obj = Tables.id
         INNER JOIN
         syscomments AS Comments
         ON Triggers.id = Comments.id
WHERE    Triggers.xtype = 'TR'
         AND Tables.xtype = 'U'
         AND Triggers.crdate < '2014-03-01'
ORDER BY Tables.Name, Triggers.name;me, Triggers.name