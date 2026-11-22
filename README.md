# 🍔 Food Delivery Operations & Revenue Analysis (MySQL)

## 📌 Project Overview
This project analyzes operational efficiency, revenue performance, customer retention, and delivery logistics for an online food delivery platform across multiple cities (Indore, Bhopal, and Ujjain). Built using **MySQL**, the relational database models real-world business scenarios—including cancelled orders, late deliveries, discount impact, and inactive signups—to generate actionable business recommendations.

---

## 🗂️ Database Schema
The relational database (`food_delivery_analytics`) consists of **4 normalized tables** connected via primary and foreign keys:

| Table Name | Description | Key Columns |
| :--- | :--- | :--- |
| **`users`** | Customer profile and onboarding details | `user_id` (PK), `user_name`, `city`, `signup_date` |
| **`restaurants`** | Partner restaurant metadata and ratings | `restaurant_id` (PK), `restaurant_name`, `cuisine`, `city`, `rating` |
| **`orders`** | Order transactions, discounts, and fulfillment status | `order_id` (PK), `user_id` (FK), `restaurant_id` (FK), `order_date`, `order_amount`, `discount_amount`, `order_status` |
| **`deliveries`** | Rider assignment and delivery SLA tracking | `delivery_id` (PK), `order_id` (FK), `rider_id`, `estimated_mins`, `actual_mins` |

---

## 🛠️ SQL Concepts & Techniques Used
* **Data Filtering & Aggregations:** `WHERE`, `GROUP BY`, `HAVING`, `SUM()`, `COUNT()`, `AVG()`, `ROUND()`
* **Relational Joins:** `INNER JOIN`, `LEFT JOIN` (with `IS NULL` filtering for inactive user detection)
* **Conditional Logic:** `CASE WHEN` expressions for time-slot segmentation and conditional rate calculations
* **Date & Time Functions:** `EXTRACT(HOUR FROM ...)`, `DATEDIFF()`
* **Advanced Analytics:** Common Table Expressions (`CTEs`), Window Functions (`ROW_NUMBER()`, `DENSE_RANK()`, and cumulative `SUM() OVER (...)`)

---

## 🔍 Business Questions Solved

### Level 1: Revenue & Order Performance
1. **Net Revenue by City:** Calculated total net revenue (`order_amount - discount_amount`) across cities for completed deliveries.
2. **Platform Cancellation Rate:** Measured overall order cancellation percentage to assess fulfillment reliability.
3. **Top Cuisine by Volume & AOV:** Identified the highest-ordered cuisine and computed its Average Order Value (AOV).

### Level 2: Customer Behavior & Delivery Operations
4. **Inactive User Identification:** Isolated registered users who have yet to place their first order.
5. **Peak Ordering Hours:** Segmented orders into Morning, Afternoon, Evening, and Night slots to pinpoint demand spikes.
6. **Late Delivery Rate:** Evaluated the percentage of delivered orders exceeding estimated delivery times.

### Level 3: Rider Ranking, Retention & Cumulative Trends
7. **Rider Efficiency Ranking:** Ranked delivery riders based on average delay (`actual_mins - estimated_mins`).
8. **Customer Order Frequency & Gap:** Calculated order count and active day span (`DATEDIFF`) for repeat customers.
9. **Running Revenue Total:** Tracked cumulative net revenue chronologically across order timestamps.
10. **Top Restaurant per City:** Ranked partner restaurants within each city to identify top revenue generators.

---

## 📊 Key Insights & Business Recommendations
* **Peak Demand Management:** Order volume peaks during **Evening (5 PM – 8 PM)** and **Afternoon (12 PM – 4 PM)** windows, where delivery delays also occur more frequently. *Recommendation: Introduce dynamic rider incentives during peak dinner hours to improve on-time SLA.*
* **Customer Activation Gap:** Users who sign up without placing an initial order represent an untapped acquisition cost. *Recommendation: Trigger automated first-order discount coupons within 48 hours of signup.*
* **City-Level Partner Strategy:** Top-performing restaurants drive a significant share of city revenue (e.g., *Spice Route* in Indore and *Royal Biryani* in Bhopal). *Recommendation: Feature top city partners in loyalty campaigns while auditing high-cancellation outlets.*

---

## 🚀 How to Run This Project
1. Open **MySQL Workbench** (or any MySQL 8.0+ client).
2. Create a database:
   ```sql
   CREATE DATABASE food_delivery_analytics;
   USE food_delivery_analytics;
