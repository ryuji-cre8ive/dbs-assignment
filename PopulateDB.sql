USE MedicalInfoSystem;
-- Insert data into Patients table
-- Insert data into Staff table
INSERT INTO Staff(StaffID, SName, SPassportNumber, SPhone, SystemUserID, Position)
VALUES ('S00001', 'Alice Williams', 'N123456', '456-789-0123', 's004', 'Nurse'),
       ('S00002', 'David Brown', 'N234567', '567-890-1234', 's005', 'Nurse'),
       ('S00003', 'Emma Davis', 'N345678', '678-901-2345', 's006', 'Nurse'),
       ('S00004', 'Michael Miller', 'D123456', '789-012-3456', 's007', 'Doctor'),
       ('S00005', 'Emily Wilson', 'D234567', '890-123-4567', 's008', 'Doctor');

-- Insert data into Patient table
INSERT INTO Patient(PID, PName, PPassportNumber, PPhone, SystemUserID, PaymentCardNumber, PaymentCardPinCode)
VALUES ('P00001', 'John Doe', 'P123456', '123-456-7890', 'p001', 'Visa 1234', '1111'),
       ('P00002', 'Jane Smith', 'P234567', '234-567-8901', 'p002', 'MasterCard 2345', '2222'),
       ('P00003', 'Bob Johnson', 'P345678', '345-678-9012', 'p003', 'Amex 3456', '3333'),
       ('P00004', 'Charlie Davis', 'P456789', '456-789-0123', 'p009', 'Visa 4567', '4444'),
       ('P00005', 'Diana Evans', 'P567890', '567-890-1234', 'p010', 'MasterCard 5678', '5555');

-- Insert data into Medicine table
INSERT INTO Medicine(MID, MName)
VALUES ('M00001', 'Medication1'),
       ('M00002', 'Medication2'),
       ('M00003', 'Medication3'),
       ('M00004', 'Medication4'),
       ('M00005', 'Medication5');

-- Insert data into Prescription table
INSERT INTO Prescription(PatientID, DoctorID, PresDateTime)
VALUES ('P00001', 'S00004', GETDATE()),
       ('P00002', 'S00005', GETDATE()),
       ('P00003', 'S00004', GETDATE()),
       ('P00004', 'S00005', GETDATE()),
       ('P00005', 'S00004', GETDATE());

-- Insert data into PrescriptionMedicine table
INSERT INTO PrescriptionMedicine(PresID, MedID)
VALUES (1, 'M00001'),
       (2, 'M00002'),
       (3, 'M00003'),
       (4, 'M00004'),
       (5, 'M00005');