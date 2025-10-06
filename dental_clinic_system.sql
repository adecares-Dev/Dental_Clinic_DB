-- ============================================================
-- DENTAL CLINIC MANAGEMENT SYSTEM DATABASE
-- Author: [Your Name]
-- Description: A complete relational database design for a Dental Clinic
-- ============================================================

-- ------------------------------------------------------------
-- 1. CREATE DATABASE
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS dental_clinic_db;
CREATE DATABASE dental_clinic_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE dental_clinic_db;

-- ------------------------------------------------------------
-- 2. TABLE: staff (dentists, receptionists, assistants)
-- ------------------------------------------------------------
CREATE TABLE staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(20) NOT NULL UNIQUE,
  role ENUM('Dentist', 'Receptionist', 'Dental Assistant', 'Manager') NOT NULL,
  hire_date DATE NOT NULL,
  salary DECIMAL(10,2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. TABLE: patients
-- ------------------------------------------------------------
CREATE TABLE patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  gender ENUM('Male', 'Female', 'Other'),
  date_of_birth DATE,
  phone VARCHAR(20) UNIQUE,
  email VARCHAR(150) UNIQUE,
  address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. TABLE: patient_medical_history (One-to-One with patients)
-- ------------------------------------------------------------
CREATE TABLE patient_medical_history (
  patient_id INT PRIMARY KEY,
  blood_group VARCHAR(5),
  allergies TEXT,
  chronic_conditions TEXT,
  medications TEXT,
  last_dental_visit DATE,
  CONSTRAINT fk_history_patient FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 5. TABLE: dental_services (types of treatments)
-- ------------------------------------------------------------
CREATE TABLE dental_services (
  service_id INT AUTO_INCREMENT PRIMARY KEY,
  service_name VARCHAR(150) NOT NULL UNIQUE,
  description TEXT,
  price DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 6. TABLE: appointments
-- ------------------------------------------------------------
CREATE TABLE appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  dentist_id INT NOT NULL, -- references staff table (role = Dentist)
  appointment_date DATETIME NOT NULL,
  status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
  notes TEXT,
  CONSTRAINT fk_app_patient FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_app_dentist FOREIGN KEY (dentist_id)
    REFERENCES staff(staff_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  UNIQUE (dentist_id, appointment_date) -- prevent double booking
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 7. TABLE: appointment_services (Many-to-Many)
-- A single appointment can include multiple dental services
-- ------------------------------------------------------------
CREATE TABLE appointment_services (
  appointment_id INT NOT NULL,
  service_id INT NOT NULL,
  quantity INT DEFAULT 1,
  price_at_time DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (appointment_id, service_id),
  CONSTRAINT fk_as_appointment FOREIGN KEY (appointment_id)
    REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_as_service FOREIGN KEY (service_id)
    REFERENCES dental_services(service_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 8. TABLE: treatments (records of completed appointments)
-- ------------------------------------------------------------
CREATE TABLE treatments (
  treatment_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL UNIQUE,
  dentist_id INT,  -- ← remove NOT NULL here
  diagnosis TEXT,
  procedure_details TEXT,
  prescription TEXT,
  follow_up_date DATE,
  CONSTRAINT fk_treat_appointment FOREIGN KEY (appointment_id)
    REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_treat_dentist FOREIGN KEY (dentist_id)
    REFERENCES staff(staff_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;


-- ------------------------------------------------------------
-- 9. TABLE: payments (One-to-Many from appointments)
-- ------------------------------------------------------------
CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  amount_paid DECIMAL(10,2) NOT NULL,
  payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  payment_method ENUM('Cash', 'Card', 'Transfer', 'Insurance') DEFAULT 'Cash',
  CONSTRAINT fk_payment_app FOREIGN KEY (appointment_id)
    REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 10. TABLE: invoices (One-to-One with appointments)
-- ------------------------------------------------------------
CREATE TABLE invoices (
  invoice_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT UNIQUE NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  amount_paid DECIMAL(10,2) DEFAULT 0.00,
  balance_due DECIMAL(10,2) GENERATED ALWAYS AS (total_amount - amount_paid) STORED,
  issue_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_invoice_app FOREIGN KEY (appointment_id)
    REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 11. TABLE: inventory (for dental materials)
-- ------------------------------------------------------------
CREATE TABLE inventory (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  item_name VARCHAR(150) NOT NULL UNIQUE,
  category VARCHAR(100),
  quantity_in_stock INT DEFAULT 0,
  reorder_level INT DEFAULT 5,
  unit_price DECIMAL(10,2),
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 12. TABLE: supplier (for dental materials)
-- ------------------------------------------------------------
CREATE TABLE suppliers (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  supplier_name VARCHAR(150) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(150),
  address TEXT
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 13. TABLE: supply_orders (Many-to-Many: suppliers <-> inventory)
-- ------------------------------------------------------------
CREATE TABLE supply_orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  supplier_id INT NOT NULL,
  item_id INT NOT NULL,
  quantity_ordered INT NOT NULL,
  order_date DATE DEFAULT (CURRENT_DATE),
  expected_delivery DATE,
  CONSTRAINT fk_order_supplier FOREIGN KEY (supplier_id)
    REFERENCES suppliers(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_order_item FOREIGN KEY (item_id)
    REFERENCES inventory(item_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


