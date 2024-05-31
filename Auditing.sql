-- Server audit function
USE master;
GO
CREATE SERVER AUDIT HIPAA_Audit TO FILE (FILEPATH = 'C:\Users\AuditLogs\HIPAA_Audit');
GO
CREATE SERVER AUDIT SPECIFICATION HIPAA_Audit_Specification  
FOR SERVER AUDIT HIPAA_Audit  
    ADD (FAILED_LOGIN_GROUP);  
GO  
-- Enables the audit.   

ALTER SERVER AUDIT HIPAA_Audit  
WITH (STATE = ON);  
GO
