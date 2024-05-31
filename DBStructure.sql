-- create database
USE master;
GO
ALTER DATABASE MedicalInfoSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE MedicalInfoSystem;
GO
DROP DATABASE IF EXISTS MedicalInfoSystem;
CREATE DATABASE MedicalInfoSystem;
GO
USE MedicalInfoSystem;
GO

Create Table Staff(
  StaffID varchar(6) primary key,
  SName varchar(100) not null,
  SPassportNumber varchar(50) not null,
  SPhone varchar(20),
  SystemUserID varchar(10),
  Position varchar(20) Check (Position in ('Doctor','Nurse'))
);
Create Table Patient(
  PID varchar(6) primary key,
  PName varchar(100) not null,
  PPassportNumber varchar(50) not null,
  PPhone varchar(20),
  SystemUserID varchar(10),
  PaymentCardNumber varchar(20),
  PaymentCardPinCode varchar(20)
);

Create Table Medicine(
  MID varchar(10) primary key,
  MName varchar(50) not null
);
Create Table Prescription(
  PresID int identity(1,1) primary key,
  PatientID varchar(6) references Patient(PID) ,
  DoctorID varchar(6) references Staff(StaffID) ,
  PresDateTime datetime not null
);
Create Table PrescriptionMedicine(
  PresID int references Prescription(PresID),
  MedID varchar(10) references Medicine(MID),
  Primary Key (PresID, MedID)
);



CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'password';
CREATE CERTIFICATE SecureCertificate WITH SUBJECT = 'encryption certificate for sensitive data';
CREATE SYMMETRIC KEY SecureKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE SecureCertificate;
