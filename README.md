# Smart Parking Management System

A full-stack Smart Parking Management System built using Node.js, Express.js, and Oracle 21c XE.

This system allows users to:
- View available parking slots
- Book a parking slot using a PL/SQL stored procedure
- Cancel (free) a booked slot
- Maintain transaction safety using Oracle COMMIT and ROLLBACK

---

## 🚀 Tech Stack

Backend:
- Node.js
- Express.js
- OracleDB Node Driver
- dotenv
- CORS

Database:
- Oracle 21c XE (XEPDB1)
- PL/SQL Procedure (book_slot)
- Sequences & Triggers
- Foreign Key Constraints

Frontend:
- HTML
- CSS
- JavaScript

---

## 🔌 API Endpoints

### GET /api/slots
Returns list of parking slots with status and location.

### POST /api/book
Books a parking slot using PL/SQL procedure.

Request body:
{
  "user_id": 1,
  "slot_id": 2,
  "start_time": "2026-02-21 10:00:00",
  "end_time": "2026-02-21 12:00:00"
}

---

### POST /api/free
Cancels active bookings for a slot and marks it as AVAILABLE.

Request body:
{
  "slot_id": 2
}

---

## 🗄 Database Design

Main tables:
- USERS
- VEHICLES
- LOCATIONS
- PARKING_SLOT
- BOOKING
- PAYMENT
- ADMIN
- NOTIFICATION
- PRICING

Database concepts used:
- Primary & Foreign Keys
- Sequences
- BEFORE INSERT Triggers
- Row-level locking (FOR UPDATE)
- Transaction management
- Stored procedures with OUT parameters

---

## 🔒 Security

- Database credentials stored in .env file
- .env ignored using .gitignore
- No hardcoded credentials in source code

---

## 👨‍💻 Author

Kartik Tyagi  
MCA Student

---

## 📌 Note

This project is developed for academic and learning purposes.
