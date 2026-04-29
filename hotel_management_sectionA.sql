create database if not exists milestone;
use milestone;

create table if not exists patients (
    patient_id INT auto_increment primary KEY,
    name varchar(100) not null
    );
    
CREATE TABLE if not exists patient_phones (
    phone_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT not null,
    phone_number VARCHAR(20) not null,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
) ;    
create table if not exists specializations(
    spec_id int auto_increment primary key,
    name varchar(20) not null
    );  
create table if not exists doctors (
    doctor_id INT auto_increment primary KEY,
    name varchar(100)  not null,
    spec_id int not null,
    foreign key(spec_id) references specializations(spec_id) ON DELETE CASCADE
    );
    
 
    
create table if not exists medicines (
    medicine_id INT auto_increment primary KEY,
    name varchar(100)  not null,
    price DECIMAL(10,2) not null
    );
    
    
create table if not exists appointments(
    appointment_id int auto_increment primary key,
    patient_id INT Not null,
    doctor_id INT Not null,
    appointment_date date not null,
    appointment_time time not null,
    follow_up_to INT NULL,
	FOREIGN KEY (follow_up_to) REFERENCES appointments(appointment_id)
    ON DELETE SET NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
       on delete cascade,
	foreign key (doctor_id) REFERENCES doctors(doctor_id)
       on delete cascade
    );

       
create table if not exists diagnoses(
       diagnosis_id int auto_increment primary key,
       diagnosis_description TEXT ,
        appointment_id int not null,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE)
      ;
       

CREATE TABLE prescription_details (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id int not null,
    unique(appointment_id),
     FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
);
CREATE TABLE treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100),
    when_to_take VARCHAR(20),
    
    FOREIGN KEY (prescription_id) 
        REFERENCES prescription_details(prescription_id)
        ON DELETE CASCADE,
        
    FOREIGN KEY (medicine_id) 
        REFERENCES medicines(medicine_id)
        ON DELETE CASCADE
);
create table if not exists bills(
    bill_id int auto_increment primary key,
    bill_amount DECIMAL(10,2) not null,
    appointment_id int not null,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
    );
    

CREATE TABLE if not exists payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('pending', 'completed', 'failed') NOT NULL default 'pending',
    FOREIGN KEY (bill_id) 
        REFERENCES bills(bill_id)
        ON DELETE CASCADE
);   