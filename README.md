# 🦷 Dental Clinic Database System

## 📘 Overview
This project is a **Dental Clinic Management Database** designed using **MySQL**.  
It manages patient records, appointments, treatments, billing, and staff information efficiently.

## 🧩 Features
- Patient registration and history tracking  
- Dentist and staff management  
- Appointment scheduling and follow-ups  
- Treatment and prescription records  
- Billing and payment tracking  

## 🗃️ Database Structure
The database includes the following key tables:
- `patients`
- `staff`
- `appointments`
- `treatments`
- `bills`
- `payments`

Relationships are defined using **PRIMARY KEY** and **FOREIGN KEY** constraints,  
ensuring data integrity and proper referential links between tables.

---

## 🧱 ER Diagram (Entity–Relationship Overview)

```text
+-------------+       +---------------+       +----------------+
|  patients   |1----∞ | appointments  |∞----1 |    staff       |
|-------------|       |---------------|       |----------------|
| patient_id  |       | appointment_id|       | staff_id       |
| name        |       | patient_id    |       | name           |
| contact     |       | staff_id      |       | role           |
| address     |       | date          |       | specialization |
+-------------+       | time          |       +----------------+
                      +---------------+
                              |
                              |
                              ∞
                              |
                              1
                      +---------------+
                      |  treatments   |
                      |---------------|
                      | treatment_id  |
                      | appointment_id|
                      | dentist_id    |
                      | diagnosis     |
                      | procedure     |
                      +---------------+

                              |
                              1
                              |
                              ∞
                      +---------------+
                      |    bills      |
                      |---------------|
                      | bill_id       |
                      | treatment_id  |
                      | amount        |
                      | bill_date     |
                      +---------------+
                              |
                              |
                              1
                              |
                              ∞
                      +---------------+
                      |   payments    |
                      |---------------|
                      | payment_id    |
                      | bill_id       |
                      | amount_paid   |
                      | payment_date  |
                      +---------------+
````

**Legend:**

* `1` → One
* `∞` → Many
* Relationships:

  * One **patient** can have many **appointments**
  * One **appointment** is handled by one **staff** (dentist)
  * One **appointment** can result in one **treatment**
  * One **treatment** can generate many **bills**
  * One **bill** can have many **payments**

---

## ⚙️ How to Run

1. Open **MySQL Workbench** or your preferred SQL editor.
2. Copy and execute the SQL file:

   ```sql
   SOURCE dental_clinic_system.sql;
   ```
3. The database will be created automatically with all tables and relationships.

---

## 🧑‍💻 Author

**Adebowale L. (Adecares-Dev)**
GitHub: [@adecares-Dev](https://github.com/adecares-Dev)







