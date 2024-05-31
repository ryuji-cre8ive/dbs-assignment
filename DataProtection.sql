USE MedicalInfoSystem;
-- make encryption key
OPEN SYMMETRIC KEY SecureKey
DECRYPTION BY CERTIFICATE SecureCertificate;

-- encrypt the sensitive data
UPDATE Patient SET 
    PPassportNumber = ENCRYPTBYKEY(KEY_GUID('SecureKey'), CONVERT(varbinary, PPassportNumber)),
    PaymentCardNumber = ENCRYPTBYKEY(KEY_GUID('SecureKey'), CONVERT(varbinary, PaymentCardNumber)),
    PaymentCardPinCode = ENCRYPTBYKEY(KEY_GUID('SecureKey'), CONVERT(varbinary, PaymentCardPinCode)),
    PPhone = ENCRYPTBYKEY(KEY_GUID('SecureKey'), CONVERT(varbinary,PPhone)); 

UPDATE Staff SET
    SPassportNumber = ENCRYPTBYKEY(KEY_GUID('SecureKey'), CONVERT(varbinary,SPassportNumber)),
    SPhone = ENCRYPTBYKEY(KEY_GUID('SecureKey'), CONVERT(varbinary,SPhone));

CLOSE SYMMETRIC KEY SecureKey;

-- create full backup
BACKUP DATABASE MedicalInfoSystem
TO DISK = 'C:\Backup\MedicalInfoSystem_Full.bak'
WITH FORMAT;

-- create differential backup
BACKUP DATABASE MedicalInfoSystem
TO DISK = 'C:\Backup\MedicalInfoSystem_Diff.bak'
WITH DIFFERENTIAL;

-- restore database from full backup
USE master;
RESTORE DATABASE MedicalInfoSystem
FROM DISK = 'C:\Backup\MedicalInfoSystem_Full.bak'
WITH NORECOVERY;

-- restore database from differential backup
USE master;
RESTORE DATABASE MedicalInfoSystem
FROM DISK = 'C:\Backup\MedicalInfoSystem_Diff.bak'
WITH RECOVERY;