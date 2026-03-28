# 🏬 Rinascente Milano — Customer Behavior & Loyalty Program Analysis  
**A Business Intelligence project evaluating retail performance through data processing, modeling, and visualization**

---

## 📌 Project Overview

This project analyzes **customer purchasing behavior** and the effectiveness of the **Rinascentecard loyalty program** at Rinascente Milano, a flagship store in Italy’s premium retail sector.

The work is based on a structured Business Intelligence pipeline that transforms raw transactional data into **actionable insights** through:

- data cleaning and preprocessing  
- relational database design (star schema)  
- interactive dashboarding in Power BI  

The central research objective is:

> *How can data preprocessing and interactive visualization support a physical retail store in evaluating customer behavior and improving loyalty program performance?*

---

## 💳 Loyalty Program Context

Rinascente’s **Rinascentecard loyalty program** segments customers into four tiers based on spending:

- **staRter**  
- **runneR**  
- **loveR**  
- **heRo**

These tiers are designed to incentivize higher spending through increasing benefits and discounts.

However, the analysis reveals structural issues in how the program operates in practice, particularly in **customer progression and incentive alignment**.

---

## 🧠 Analytical Approach

The project follows a structured pipeline:

1. Data acquisition from transactional dataset  
2. Data cleaning and preprocessing (Python)  
3. Database design and implementation (PostgreSQL)  
4. Data modeling using a **star schema**  
5. Dashboard development (Power BI)  
6. Insight generation and evaluation  

This approach ensures consistency between raw data, processed data, and final insights, improving reliability and interpretability.

---

## 🗂️ Repository Structure

```text
.
├── CSVs tables star schema/
├── Dashboard images, ER diagram and tables/
├── Data cleaning notebook & dataset files
├── SQL scripts for database creation
└── README.md
````

### Structure Explanation

* **CSVs tables star schema/**
  Contains the final **dimension and fact tables** exported from PostgreSQL after building the star schema. These represent the cleaned and structured dataset used for analysis and reporting.

* **Dashboard images, ER diagram and tables/**
  Includes:

  * ER diagram of the database model
  * Data dictionaries of tables
  * Power BI dashboard screenshots
    These provide both **technical documentation** and **visual outputs** of the project.

---

## 🧱 Data Model

The dataset is transformed into a **star schema**, designed to improve analytical performance and reduce redundancy.

### Core components:

* **Fact Table**

  * `factSales` → transaction-level data (sales, discounts, quantities)

* **Dimension Tables**

  * Customer
  * Location
  * Loyalty tier
  * Brand
  * Product division
  * Ownership type

This structure ensures:

* efficient querying
* clear relationships
* consistency between database and dashboard

---

## 📊 Dashboard Overview

### Main Dashboard Views

![Dashboard](images/rinascente-dashboard-bookmark1.png)

![Dashboard](images/rinascente-dashboard-bookmark2.png)

The Power BI dashboard provides a comprehensive view of:

* overall store performance
* customer composition
* revenue distribution
* loyalty tier dynamics

### Key metrics:

* Total Revenue: €59.35M
* Active Customers: 137K
* Average Basket Size: 1.62
* Average Discount: ~15%

---

## 🧩 ER Diagram

![Dashboard](images/ER-diagram.png)

The ER diagram illustrates the relationships between fact and dimension tables, supporting a clear and scalable analytical structure.

---

## 🔍 Key Findings

### 1. Customer & Revenue Imbalance

* Female customers represent ~69% of customers and generate ~72% of revenue.
* Male customers show lower participation and spending, except in specific categories (e.g., men’s fashion).

### 2. Strong Seasonality

* Revenue peaks in **December** (holiday effect).
* Secondary increase in summer (promotions).
* January remains weak despite discounts.

### 3. Loyalty Tier Imbalance

* The vast majority of customers are concentrated in the **staRter tier**.
* Higher tiers contain very small populations, indicating **limited upward mobility**.

### 4. Misaligned Incentives

* The **highest average discount is not assigned to the top tier**, but to a mid-tier (runneR).
* This weakens the incentive to progress in the loyalty program.

### 5. Misleading Growth Metrics

* Higher tiers show strong **percentage growth**, but from very small bases.
* In absolute terms, the structure remains heavily unbalanced.

---

## 💡 Business Implications

### Short-term

* Clear visibility of customer segmentation and revenue drivers
* Identification of inefficiencies in loyalty structure

### Mid-term

* Redesign of loyalty thresholds to improve progression
* Targeted marketing strategies (especially toward male customers)
* Better alignment of discount policies

### Long-term

* Scalable data pipeline for continuous monitoring
* Foundation for advanced analytics (e.g., churn prediction, CLV)

---

## ⚙️ Tools & Technologies

* **Python (Pandas, NumPy)** → data cleaning & preprocessing
* **PostgreSQL** → database design & querying
* **SQL** → data transformation and modeling
* **Power BI** → dashboarding and visualization

---

## 🚀 Conclusion

This project demonstrates how **structured data preprocessing and Business Intelligence tools** enable a physical retail store to transform raw transactional data into meaningful insights.

The analysis highlights key structural issues in the loyalty program:

* excessive concentration in the entry-level tier
* weak incentives for progression
* misalignment between discounts and tier hierarchy

Overall, the project shows that **data is not inherently valuable**—its value emerges only when it is properly processed, modeled, and visualized to support decision-making.
