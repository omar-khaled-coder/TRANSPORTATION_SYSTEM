# 🚀 Transportation Management System API

## Overview
This is a Transportation Management System API built using **Ruby on Rails** and **PostgreSQL**. It provides JSON:API-compliant endpoints for managing trucks and drivers, supporting **JWT authentication** and periodic synchronization with an external trucks API. The API is designed to manage truck assignments to drivers and fetch truck data from a remote source.

---

## ✅ System Requirements
- **Ruby** 3.2.2
- **Rails** 7.x
- **PostgreSQL**
- **Redis** (for Sidekiq)
- **Sidekiq** (for background job processing)

---

## 🛠 Setup Instructions



### 1. Install Project Dependencies
```bash
bundle install
yarn install
```

### 2. Setup the Database
```bash
rails db:create db:migrate db:seed
```


### 3. Run Sidekiq (Background Job Processor)
```bash
bundle exec sidekiq
```

### 4. Start the Rails Server
```bash
rails server
```


---

## 📋 API Endpoints

### 🔐 Authentication Endpoints
| Method | Endpoint       | Description                    |
|--------|----------------|--------------------------------|
| POST   | `/drivers`     | Sign up and signin a new driver           |
| POST   | `/auth/login`  | Authenticate and get a JWT token |

### 🚛 Trucks Endpoints
| Method | Endpoint                  | Description                                          |
|--------|--------------------------|------------------------------------------------------|
| GET    | `/trucks`                 | List all trucks                                      |
| POST   | `/trucks/:id/assign`      | Assign a truck to the current driver                 |
| GET    | `/driver_trucks` | List trucks assigned to the current driver          |

---

## 📊 External API Integration
The application uses a **Sidekiq worker** to periodically fetch trucks from an external API and update the local database.

### **External API Details:**
- **API Endpoint:** `https://api-task-bfrm.onrender.com/api/v1/trucks`
- **API Key:** `illa-trucks-2023`

### **How it Works:**
- The Sidekiq worker runs **once a day** to fetch trucks from the external API.
- The worker handles pagination and stores new trucks in the local database.

### **Pagy Pagination:**
The API supports pagination using the **Pagy gem**. HTTP headers include:
- `current-page`
- `page-items`
- `total-count`
- `total-pages`

---

## 🧪 Running Tests
The application includes tests to ensure functionality.
I used Minitest as testing tool cause it simple and already built in with rails
I have done test for : Models, Controllers, Database, driver authentication when signing up or loging in.

### Run All Tests
```bash
rails test
```

---



## 📄 Closing Comments
Thank you for reviewing my submission! This project follows clean code principles, with scalable and maintainable architecture. I look forward to your feedback!
