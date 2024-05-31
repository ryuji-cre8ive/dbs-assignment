## How to run this code

1. Execute Auditing.sql

2. DBStructure.sql

3. Permissions.sql

4. Populate.sql

5. DataProtection.sql

6. Test.sql

## rights

1. patient.

- Ensure that the patient can view their details.
- Ensure that the patient can update their details (passport number, phone and payment card details).
- Ensure that the patient can check their prescribed medication.
- Ensure that the patient cannot access other patients' details or medication information.

2. nurses.

- Ensure that the nurse can view their details.
- Ensure that the nurse can update their details (passport number, telephone).
- Ensure that the nurse can check the patient's medication details.
- Ensure that the nurse can view and update the patient's personal details.

3. doctors.

- Ensure that the doctor can view your details.
- Ensure that the doctor can update his/her details (passport number, telephone).
- Ensure that the doctor can add new medication details to the patient.
- Ensure that the doctor can update or remove medication details that he/she has added.
- Ensure that the doctor cannot update or remove medication details added by another doctor.
- Ensure that the doctor can check the patient's personal details.
