USE MedicalInfoSystem;

-- Create roles
CREATE ROLE PatientRole;
GO
CREATE ROLE NurseRole;
GO
CREATE ROLE DoctorRole;
GO

OPEN SYMMETRIC KEY SecureKey
DECRYPTION BY CERTIFICATE SecureCertificate

-- Patients
GO
CREATE VIEW PatientView AS
SELECT 
    SystemUserID,
    CONVERT(nvarchar, DECRYPTBYKEY(PPassportNumber)) AS PPassportNumber,
    CONVERT(nvarchar, DECRYPTBYKEY(PaymentCardNumber)) AS PaymentCardNumber,
    CONVERT(nvarchar, DECRYPTBYKEY(PaymentCardPinCode)) AS PaymentCardPinCode,
    CONVERT(nvarchar, DECRYPTBYKEY(PPhone)) AS PPhone
FROM Patient 
WHERE SystemUserID = USER_NAME();
GO
GRANT SELECT, UPDATE(PPassportNumber, PPhone, PaymentCardNumber, PaymentCardPinCode) ON PatientView TO PatientRole;
GO

CREATE VIEW PatientMedicineView AS
SELECT PM.* 
FROM PrescriptionMedicine PM
JOIN Prescription P ON PM.PresID = P.PresID
WHERE P.PatientID IN (SELECT PID FROM Patient WHERE SystemUserID = USER_NAME());
GO
GRANT SELECT ON PatientMedicineView TO PatientRole;
GO

-- Nurses
CREATE VIEW NurseView AS
SELECT 
    SystemUserID,
    Position,
    CONVERT(nvarchar, DECRYPTBYKEY(SPassportNumber)) AS SPassportNumber,
    CONVERT(nvarchar, DECRYPTBYKEY(SPhone)) AS SPhone
FROM Staff 
WHERE SystemUserID = USER_NAME() AND Position = 'Nurse';
GO
GRANT SELECT, UPDATE(SPassportNumber, SPhone) ON NurseView TO NurseRole;

GO

CREATE VIEW NursePatientView AS
SELECT 
    PID, 
    PName, 
    CONVERT(nvarchar, DECRYPTBYKEY(PPhone)) AS PPhone 
FROM Patient;
GO
GRANT SELECT, UPDATE(PName, PPhone) ON NursePatientView TO NurseRole;

GO

CREATE VIEW NursePatientMedicineView AS
SELECT M.* 
FROM Medicine M
JOIN PrescriptionMedicine PM ON M.MID = PM.MedID
WHERE PM.PresID IN (SELECT PresID FROM Prescription WHERE PatientID IN (SELECT PID FROM Patient));
GO
GRANT SELECT ON NursePatientMedicineView TO NurseRole;
GO

-- Doctors
CREATE VIEW DoctorView AS
SELECT 
    SystemUserID,
    Position,
    CONVERT(nvarchar, DECRYPTBYKEY(SPassportNumber)) AS SPassportNumber,
    CONVERT(nvarchar, DECRYPTBYKEY(SPhone)) AS SPhone
FROM Staff 
WHERE SystemUserID = USER_NAME() AND Position = 'Doctor';
GO
GRANT SELECT, UPDATE(SPassportNumber, SPhone) ON DoctorView TO DoctorRole;
GO

CREATE VIEW DoctorPatientView AS
SELECT 
    PID, 
    PName, 
    CONVERT(nvarchar, DECRYPTBYKEY(PPhone)) AS PPhone 
FROM Patient;
GO
GRANT SELECT ON DoctorPatientView TO DoctorRole;
GO

CREATE VIEW DoctorPrescriptionView AS
SELECT * FROM Prescription WHERE DoctorID = USER_NAME();
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON DoctorPrescriptionView TO DoctorRole;
GO

CREATE VIEW DoctorPatientMedicineView AS
SELECT P.PID, P.PName, P.PPhone, M.MID, M.MName
FROM Patient P
JOIN PrescriptionMedicine PM ON P.PID = PM.PresID
JOIN Medicine M ON PM.MedID = M.MID;
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON DoctorPatientMedicineView TO DoctorRole;
GO

-- Trigger to prevent doctors from updating or deleting medication details added by other doctors
CREATE TRIGGER trg_PreventUpdateDelete
ON Medicine
FOR UPDATE, DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM inserted i JOIN PrescriptionMedicine pm ON i.MID = pm.MedID JOIN Prescription p ON pm.PresID = p.PresID JOIN Staff s ON p.DoctorID = s.StaffID WHERE s.SystemUserID = USER_NAME())
    BEGIN
        RAISERROR ('You are not allowed to update or delete medication details added by other doctors.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
