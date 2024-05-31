USE MedicalInfoSystem;
-- create patients user
CREATE LOGIN p001 With Password='QwErTy12345!@#$%';
CREATE USER p001 FOR LOGIN p001;

-- create nurses user
CREATE LOGIN s004 With Password='QwErTy12345!@#$%';
CREATE USER s004 FOR LOGIN s004;

CREATE LOGIN s007 With Password='QwErTy12345!@#$%';
CREATE USER s007 FOR LOGIN s007;
GO
ALTER ROLE PatientRole ADD MEMBER p001;
ALTER ROLE NurseRole ADD MEMBER s004;
ALTER ROLE DoctorRole ADD MEMBER s007;
GO


-- Patients
-- a. Each patient is given a unique system user id which can be used by them to log into the system
EXECUTE AS USER = 'p001'

-- b. Patients must be able to see all their own personal details only
SELECT * FROM PatientView;

-- c. Patients must be able to update their own details such as passport number, phone , and payment card details only.
UPDATE PatientView SET PPhone = '07070707070', PaymentCardNumber = '1234567890123456', PaymentCardPinCode = '1234' WHERE SystemUserID = USER_NAME();

-- d. Patients must be able to check their own medications that was prescribed by their doctor but not change or delete them including past historical data.
SELECT * FROM PatientMedicineView;

-- e. Patients must not be able to access other patients’ personal or medication details
UPDATE PatientView SET PName = 'testtesttest' WHERE SystemUserID = USER_NAME();
REVERT;



-- Nurses
-- a. Each nurse is given a unique system user id which can be used by them to log into the system
EXECUTE AS USER = 's004'

-- b. Nurses must be able to see all their own personal details only
SELECT * FROM NurseView;

-- c. Nurses must be able to update their own details such as passport number and phone only.
UPDATE NurseView SET SPhone = '029029029029', SPassportNumber = 'TT04873048' WHERE SystemUserID = USER_NAME();

-- d. Nurses must be able to check any patient’s medication details but not add, update or delete them including past historical data.
SELECT * FROM NursePatientMedicineView;

-- e. Nurses must be able to check and update any patients’ personal details except for sensitive details
UPDATE NursePatientView SET PPhone = '07070707070' WHERE PID = 'P00001';
SELECT * FROM NursePatientView


-- Nurses must not be able to update any patient’s personal details
UPDATE Prescription SET PatientID = '112233445566' WHERE PatientID = 'P00001';

-- Nurses must not be able to update any patient's medication details
INSERT INTO Prescription (PatientID, DoctorID, PresDateTime) VALUES ('P00001', 'S00001', GETDATE());
DELETE FROM Prescription WHERE PatientID = 'P00001';

-- Nurses must not be able to update any patient's sensitive details
UPDATE NursePatientView SET PPassportNumber = 'rr9392u83ry2' WHERE PID = 'P00001';
REVERT;





-- Doctors
-- a. Each doctor is given a unique system user id which can be used by them to log into the system
EXECUTE AS USER = 's007'

-- b. Doctors must be able to see all their own personal details only
SELECT * FROM DoctorView;

-- c. Doctors must be able to update their own details such as passport number and phone only.
UPDATE DoctorView SET SPhone = '07082837493', SPassportNumber = 'D123456' WHERE SystemUserID = USER_NAME();

-- d. Doctors must be able to add medications
INSERT INTO DoctorPrescriptionView (MID, MName) VALUES ('M000133', 'new medicine');

-- e. Doctors must be able to update medications
INSERT INTO Prescription (PatientID, DoctorID, PresDateTime) VALUES ('P00001', 'S00001', GETDATE());
INSERT INTO PrescriptionMedicine (PresID, MedID) VALUES (SCOPE_IDENTITY(), 'M000133');

-- f. Doctors must be able to check medications information
SELECT * FROM DoctorPrescriptionView;

-- g. Doctors must be able to update medications
UPDATE Medicine SET MName = ‘updated medicine’ WHERE MID = ‘M000133’ AND EXISTS (SELECT 1 FROM Prescription WHERE DoctorID = ‘S00004’ AND PresID IN (SELECT PresID FROM PrescriptionMedicine WHERE MedID = ‘M000133’));
SELECT * FROM PrescriptionMedicine;

-- h. Doctors must be able to delete medications

BEGIN TRANSACTION;
DELETE FROM PrescriptionMedicine WHERE MedID = 'M000133';
DELETE FROM Medicine WHERE MID = 'M000133'
COMMIT TRANSACTION;


-- i. Doctors must not be able to update medications which is registered by their own
UPDATE Medicine SET MName = 'updated medicine' WHERE MID = 'M000133' AND EXISTS (SELECT 1 FROM Prescription WHERE DoctorID = 'S00001' AND PresID IN (SELECT PresID FROM PrescriptionMedicine WHERE MedID = 'M000133'));
SELECT * FROM PrescriptionMedicine;

-- j. Doctors must not be able to delete medications which is registered by their own
DELETE FROM Medicine WHERE MID = 'M000133' AND EXISTS (SELECT 1 FROM Prescription WHERE DoctorID = 'S00001' AND PresID IN (SELECT PresID FROM PrescriptionMedicine WHERE MedID = 'M000133'));
SELECT * FROM DoctorPrescriptionView;
REVERT;

-- Close the key
CLOSE SYMMETRIC KEY SecureKey;