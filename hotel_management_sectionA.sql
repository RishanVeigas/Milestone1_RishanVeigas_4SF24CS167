create database if not exists milestone;
use milestone;
drop database if exists milestone;
create table if not exists patients (
    patient_id INT auto_increment primary KEY,
    name varchar(100) not null
);
CREATE TABLE if not exists patient_phones (
    phone_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT not null,
    phone_number VARCHAR(20) not null,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);
create table if not exists departments(
    dept_id int auto_increment primary key,
    name varchar(20) not null
);
create table if not exists specializations(
    spec_id int auto_increment primary key,
    name varchar(20) not null
);
create table if not exists doctors (
    doctor_id INT auto_increment primary KEY,
    name varchar(100) not null,
    spec_id int not null,
    dept_id int not null,
    foreign key(spec_id) references specializations(spec_id) ON DELETE CASCADE,
    foreign key(dept_id) references departments(dept_id) ON DELETE CASCADE
);
create table if not exists medicines (
    medicine_id INT auto_increment primary KEY,
    name varchar(100) not null,
    price DECIMAL(10, 2) not null
);
create table if not exists appointments(
    appointment_id int auto_increment primary key,
    patient_id INT Not null,
    doctor_id INT Not null,
    appointment_date date not null,
    appointment_time time not null,
    follow_up_to INT NULL,
    FOREIGN KEY (follow_up_to) REFERENCES appointments(appointment_id) ON DELETE
    SET NULL,
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id) on delete cascade,
        foreign key (doctor_id) REFERENCES doctors(doctor_id) on delete cascade
);
CREATE TABLE consultations (
    consultation_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    doctor_id int not null,
    consultation_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    foreign key (doctor_id) REFERENCES doctors(doctor_id) on delete cascade
);
create table consultation_doctors(
    consultation_id INT not null,
    doctor_id int not null,
    Role varchar(20),
    PRIMARY KEY (consultation_id, doctor_id),
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);
create table if not exists diagnoses(
    diagnosis_id int auto_increment primary key,
    diagnosis_description TEXT,
    consultation_id int not null,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE
);
CREATE TABLE prescription_details (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id int not null,
    unique(consultation_id),
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE
);
CREATE TABLE treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100),
    whenToTake VARCHAR(20),
    FOREIGN KEY (prescription_id) REFERENCES prescription_details(prescription_id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id) ON DELETE CASCADE
);
create table if not exists bills(
    bill_id int auto_increment primary key,
    bill_amount DECIMAL(10, 2) not null,
    consultation_id int not null,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE
);
CREATE TABLE if not exists payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('pending', 'completed', 'failed') NOT NULL default 'pending',
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id) ON DELETE CASCADE
);
INSERT INTO patients (name)
VALUES ('Ravi Kumar'),
    ('Ananya Sharma'),
    ('Mohammed Arif'),
    ('Sneha Reddy'),
    ('Karthik Rao'),
    ('Pooja Mehta'),
    ('Rahul Das');
INSERT INTO patient_phones (patient_id, phone_number)
VALUES (1, '9876543210'),
    (1, '9123456780'),
    (2, '9988776655'),
    (3, '9090909090'),
    (4, '8887766554'),
    (5, '7776655443'),
    (6, '9665544332'),
    (7, '9554433221');
INSERT INTO departments (name)
VALUES ('Cardiology'),
    ('Neurology'),
    ('Orthopedics'),
    ('Pediatrics'),
    ('General Medicine');
INSERT INTO specializations (name)
VALUES ('Cardiologist'),
    ('Neurologist'),
    ('Orthopedic Surgeon'),
    ('Pediatrician'),
    ('General Physician');
INSERT INTO doctors (name, spec_id, dept_id)
VALUES ('Dr. Vivek Menon', 1, 1),
    ('Dr. Shalini Iyer', 2, 2),
    ('Dr. Arjun Shetty', 3, 3),
    ('Dr. Neha Kapoor', 4, 4),
    ('Dr. Ramesh Gupta', 5, 5),
    ('Dr. Farhan Ali', 1, 1),
    ('Dr. Kavya Nair', 5, 5);
INSERT INTO medicines (name, price)
VALUES ('Paracetamol', 20.00),
    ('Ibuprofen', 35.00),
    ('Amoxicillin', 120.00),
    ('Atorvastatin', 150.00),
    ('Metformin', 80.00),
    ('Aspirin', 25.00),
    ('Cough Syrup', 60.00);
INSERT INTO appointments (
        patient_id,
        doctor_id,
        appointment_date,
        appointment_time,
        follow_up_to
    )
VALUES (1, 1, '2026-04-20', '10:00:00', NULL),
    (2, 2, '2026-04-20', '11:00:00', NULL),
    (3, 3, '2026-04-21', '09:30:00', NULL),
    (4, 4, '2026-04-21', '12:00:00', NULL),
    (5, 5, '2026-04-22', '14:00:00', NULL),
    (6, 6, '2026-04-22', '15:00:00', NULL),
    (7, 7, '2026-04-23', '16:00:00', NULL),
    (1, 1, '2026-04-27', '10:30:00', 1);
INSERT INTO consultations (appointment_id, doctor_id, notes)
VALUES (1, 1, 'Chest pain evaluation'),
    (2, 2, 'Migraine symptoms'),
    (3, 3, 'Knee joint pain'),
    (4, 4, 'Child fever and cold'),
    (5, 5, 'Routine health check'),
    (6, 6, 'High cholesterol follow-up'),
    (7, 7, 'General weakness'),
    (8, 1, 'Follow-up for chest pain');
INSERT INTO consultation_doctors (consultation_id, doctor_id, Role)
VALUES (1, 1, 'Primary'),
    (2, 2, 'Primary'),
    (3, 3, 'Primary'),
    (4, 4, 'Primary'),
    (5, 5, 'Primary'),
    (6, 6, 'Primary'),
    (7, 7, 'Primary'),
    (8, 1, 'Primary'),
    (1, 5, 'Consulting');
INSERT INTO diagnoses (diagnosis_description, consultation_id)
VALUES ('Mild Angina', 1),
    ('Chronic Migraine', 2),
    ('Ligament Strain', 3),
    ('Viral Fever', 4),
    ('Normal', 5),
    ('Hyperlipidemia', 6),
    ('Fatigue', 7),
    ('Stable Condition', 8);
INSERT INTO prescription_details (consultation_id)
VALUES (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8);
INSERT INTO treatments (
        prescription_id,
        medicine_id,
        dosage,
        frequency,
        whenToTake
    )
VALUES (1, 6, '75mg', 'Once daily', 'After food'),
    (2, 1, '500mg', 'Twice daily', 'After food'),
    (2, 2, '200mg', 'Once daily', 'After food'),
    (3, 2, '400mg', 'Twice daily', 'After food'),
    (4, 1, '250mg', 'Thrice daily', 'After food'),
    (4, 7, '10ml', 'Twice daily', 'Before sleep'),
    (5, 5, '500mg', 'Once daily', 'Before food'),
    (6, 4, '10mg', 'Once daily', 'After food'),
    (7, 1, '500mg', 'Once daily', 'After food'),
    (8, 6, '75mg', 'Once daily', 'After food');
INSERT INTO bills (bill_amount, consultation_id)
VALUES (500.00, 1),
    (400.00, 2),
    (600.00, 3),
    (300.00, 4),
    (350.00, 5),
    (700.00, 6),
    (250.00, 7),
    (450.00, 8);
INSERT INTO payments (bill_id, payment_status)
VALUES (1, 'completed'),
    (2, 'completed'),
    (3, 'pending'),
    (4, 'completed'),
    (5, 'completed'),
    (6, 'failed'),
    (7, 'completed'),
    (8, 'pending');
INSERT INTO appointments (
        patient_id,
        doctor_id,
        appointment_date,
        appointment_time,
        follow_up_to
    )
VALUES (1, 1, '2026-05-02', '09:00:00', 8),
    (1, 5, '2026-05-10', '11:00:00', NULL),
    (2, 2, '2026-05-03', '10:30:00', 2),
    (3, 3, '2026-05-04', '12:00:00', 3),
    (4, 4, '2026-05-05', '14:30:00', 4),
    (5, 5, '2026-05-06', '16:00:00', 5),
    (6, 6, '2026-05-07', '09:45:00', 6),
    (7, 7, '2026-05-08', '15:15:00', 7);
INSERT INTO consultations (appointment_id, doctor_id, notes)
VALUES (9, 1, 'Second follow-up chest pain'),
    (10, 5, 'General fatigue check'),
    (11, 2, 'Migraine follow-up'),
    (12, 3, 'Knee recovery progress'),
    (13, 4, 'Post fever check'),
    (14, 5, 'Routine monitoring'),
    (15, 6, 'Cholesterol re-evaluation'),
    (16, 7, 'Energy level assessment');
INSERT INTO consultation_doctors (consultation_id, doctor_id, Role)
VALUES (9, 1, 'Primary'),
    (9, 6, 'Consulting'),
    (10, 5, 'Primary'),
    (11, 2, 'Primary'),
    (11, 1, 'Consulting'),
    (12, 3, 'Primary'),
    (13, 4, 'Primary'),
    (14, 5, 'Primary'),
    (15, 6, 'Primary'),
    (15, 5, 'Consulting'),
    (16, 7, 'Primary');
INSERT INTO diagnoses (diagnosis_description, consultation_id)
VALUES ('Improving Angina', 9),
    ('Mild Fatigue', 10),
    ('Migraine Under Control', 11),
    ('Healing Ligament', 12),
    ('Recovered from Viral Fever', 13),
    ('Stable Health', 14),
    ('Cholesterol Reduced', 15),
    ('Vitamin Deficiency', 16);
INSERT INTO prescription_details (consultation_id)
VALUES (9),
(10),
(11),
(12),
(13),
(14),
(15),
(16);
INSERT INTO treatments (
        prescription_id,
        medicine_id,
        dosage,
        frequency,
        whenToTake
    )
VALUES (9, 6, '75mg', 'Once daily', 'After food'),
    (10, 1, '500mg', 'Once daily', 'After food'),
    (11, 2, '200mg', 'Twice daily', 'After food'),
    (12, 2, '400mg', 'Once daily', 'After food'),
    (13, 7, '10ml', 'Twice daily', 'Before sleep'),
    (14, 5, '500mg', 'Once daily', 'Before food'),
    (15, 4, '10mg', 'Once daily', 'After food'),
    (16, 1, '500mg', 'Once daily', 'After food');
INSERT INTO bills (bill_amount, consultation_id)
VALUES (550.00, 9),
    (300.00, 10),
    (450.00, 11),
    (500.00, 12),
    (250.00, 13),
    (350.00, 14),
    (650.00, 15),
    (200.00, 16);
INSERT INTO payments (bill_id, payment_status)
VALUES (9, 'completed'),
    (10, 'pending'),
    (11, 'completed'),
    (12, 'failed'),
    (13, 'completed'),
    (14, 'pending'),
    (15, 'completed'),
    (16, 'failed');

    
SELECT p.patient_id,
    p.name AS patient_name,
    c.consultation_id,
    c.consultation_time,
    d.name AS doctor_name,
    diag.diagnosis_description,
    m.name AS medicine_name,
    t.dosage,
    t.frequency,
    t.whenToTake
FROM patients p
    JOIN appointments a ON p.patient_id = a.patient_id
    JOIN consultations c ON a.appointment_id = c.appointment_id
    JOIN doctors d ON c.doctor_id = d.doctor_id
    LEFT JOIN diagnoses diag ON c.consultation_id = diag.consultation_id
    LEFT JOIN prescription_details pd ON c.consultation_id = pd.consultation_id
    LEFT JOIN treatments t ON pd.prescription_id = t.prescription_id
    LEFT JOIN medicines m ON t.medicine_id = m.medicine_id
WHERE p.patient_id = 1
ORDER BY c.consultation_time DESC;