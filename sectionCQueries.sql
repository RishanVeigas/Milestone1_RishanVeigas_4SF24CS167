
-- Section C
-- 1. query to find the all details of a patient(given ppatient_id) 
SELECT 
    p.patient_id,
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
JOIN appointments a 
    ON p.patient_id = a.patient_id
JOIN consultations c 
    ON a.appointment_id = c.appointment_id
JOIN doctors d 
    ON c.doctor_id = d.doctor_id
LEFT JOIN diagnoses diag 
    ON c.consultation_id = diag.consultation_id
LEFT JOIN prescription_details pd 
    ON c.consultation_id = pd.consultation_id
LEFT JOIN treatments t 
    ON pd.prescription_id = t.prescription_id
LEFT JOIN medicines m 
    ON t.medicine_id = m.medicine_id
WHERE p.patient_id = 1   
ORDER BY c.consultation_time DESC;



-- 2.  query to find doctor with highest consultations

SELECT 
    d.doctor_id,
    d.name,
    COUNT(c.consultation_id) AS total_consultations
FROM doctors d
JOIN consultations c 
    ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, d.name
ORDER BY total_consultations DESC
LIMIT 1;


-- 3.  query to find patients with outstanding bill

SELECT 
    p.patient_id,
    p.name,
    SUM(b.bill_amount) AS total_outstanding
FROM patients p
JOIN appointments a 
    ON p.patient_id = a.patient_id
JOIN consultations c 
    ON a.appointment_id = c.appointment_id
JOIN bills b 
    ON c.consultation_id = b.consultation_id
JOIN payments pay 
    ON b.bill_id = pay.bill_id
WHERE pay.payment_status = 'pending'
GROUP BY p.patient_id, p.name
HAVING total_outstanding > 0;



-- 4. transaction query

START TRANSACTION;

-- 1. Insert consultation
INSERT INTO consultations (appointment_id, doctor_id, notes)
VALUES (1, 1, 'Routine consultation - transaction test');

-- Capture generated consultation_id
SET @consultation_id = LAST_INSERT_ID();

-- 2. Insert diagnosis
INSERT INTO diagnoses (diagnosis_description, consultation_id)
VALUES ('Test Diagnosis - Stable', @consultation_id);

-- 3. Create prescription record
INSERT INTO prescription_details (consultation_id)
VALUES (@consultation_id);

SET @prescription_id = LAST_INSERT_ID();

-- 4. Insert treatments (medicines prescribed)
INSERT INTO treatments (prescription_id, medicine_id, dosage, frequency, whenToTake)
VALUES 
(@prescription_id, 1, '500mg', 'Twice daily', 'After food'),
(@prescription_id, 2, '200mg', 'Once daily', 'After food');

-- 5. Generate bill
INSERT INTO bills (bill_amount, consultation_id)
VALUES (500.00, @consultation_id);

SET @bill_id = LAST_INSERT_ID();

-- 6. Record payment
INSERT INTO payments (bill_id, payment_status)
VALUES (@bill_id, 'pending');

-- If everything is successful
COMMIT;

select *  from treatments;