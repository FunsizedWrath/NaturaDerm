BACKUP DATABASE NaturaDerm
TO DISK = 'C:\tmp\NaturaDermSave.bak'

USE MASTER
RESTORE DATABASE NaturaDerm
FROM DISK = 'C:\tmp\NaturaDermSave.bak'
WITH REPLACE;

-------------

BACKUP DATABASE NaturaDerm
TO DISK = 'C:\tmp\NaturaDermSaveDiff.bak'
WITH DIFFERENTIAL;USE MASTER
RESTORE DATABASE NaturaDerm
FROM DISK = 'C:\tmp\NaturaDermSaveDiff.bak'
WITH REPLACE;