# 📦 Decoding Customer Value: A SQL-Driven Retention Strategy

An end-to-end data analytics and strategic consulting project designed to transform a direct-to-consumer (D2C) fashion brand's retention strategy from reactive discounting to data-driven profitability.

This project was developed as part of the data case study simulation presented by the **Consulting & Analytics Club at IIT Guwahati**.

---

## 📌 Project Overview

The subject is a US-based D2C fashion brand processing behavioral data for **3,900 unique customers**. Historically, the founding team relied on "gut feel" and aggressive promotional markdowns to maintain sales volume. This project builds a deliberate, full-stack data pipeline to quantify the brand's true promotion dependency and construct an optimization framework to protect profit margins without fracturing transaction volume.

## 🛠️ The Analytical Constraint

The raw dataset was entirely cross-sectional, lacking timestamps, pre-calculated loyalty scores, or clear churn labels. Traditional time-series engineering models (like Recency from RFM or Time-to-Churn calculations) were mathematically impossible. All strategic business metrics had to be algorithmically engineered from behavioral snapshots and continuous variables.

---

## 🚀 Repository Structure & Workflow

```
├── 1_Python_Feature_Engineering/
│   ├── feature_pipeline.py          # Raw data cleaning & DAX/Pandas metrics engineering
│   └── engineered_customer_data.csv # Exported clean dataset for SQL ingestion
├── 2_SQL_Segmentation/
│   ├── schema.sql                   # Production schema for PostgreSQL/MySQL
│   └── segmentation_queries.sql     # Specialized consulting queries (Queries 1-10)
├── 3_Power_BI_Dashboard/
│   └── Customer_Value_Dashboard.pbix # Interactive 4-panel executive dashboard
└── 4_Executive_Playbook/
    ├── Retention_Playbook.md        # Full 4-page strategic roadmap
    └── Executive_Summary.md         # Concise 1-page boardroom brief
```

---

## 📐 Core Phases & Methodology

### 🧠 Phase 1: Python Feature Engineering & Hypothesis Testing

Using `pandas`, the analytical environment transformed static snapshots into dynamic consulting features to address the brand's questions:

- **Estimated LTV**: Formulated as `Purchase Amount × (Previous Purchases + 1)` to establish a reliable proxy for total historical spend.
- **Promo Dependency Score**: A continuous metric assigning values (1.0 for full coupon reliance, 0.5 for partial, 0.0 for organic demand) to isolate bargain hunters.
- **Satisfaction Flag**: Handled missing review attributes via median imputation and segmented product satisfaction using an indicator flag (≥4.0 = Satisfied).
- **Statistical Loyalty Showdown**: To honor strict case guidelines, two competing definitions of loyalty were explicitly tested via a Pearson correlation matrix:
  - **Hypothesis A (Transactional Loyalty)**: Blended volume percentiles and LTV spend.
  - **Hypothesis B (Behavioral Loyalty)**: Blended automated subscription status and purchase frequencies.

**The Data Verdict**: Hypothesis A yielded a **0.95 correlation** to financial value, whereas Hypothesis B hovered near **0.01**. This mathematically proved to the founders that loyalty is driven by scale and wallet-share, not automated subscriptions.

### 🗄️ Phase 2: Relational SQL Database Layer

The engineered data was migrated into a production schema table named `customer_data`. Using complex Common Table Expressions (CTEs), window functions, and aggregation blocks, a specialized script layers metrics into definitive business matrix answers:

- **Query 1**: Segmented the customer base by financial tiers and baseline promo reliance, revealing that **43.22% of total revenue ($2.65M) is promo-dependent**, with $1.51M leaking straight out of top-tier Platinum and Gold cohorts.
- **Query 9 (Geographic Signals)**: Categorized 50 states into distinct macroeconomic zones: *Core Organic Pull* (e.g., Arizona and Tennessee driving high LTV organically), *Subsidized Scale* (volume traps like Nevada), and *Discount Addicted* cost centers.
- **Query 10 (Predictive Behavior Paths)**: Isolated precise multi-variable patterns showing that customer lifecycles crossing a **30+ purchase threshold** act as the ultimate engine for high-value organic brand equity.

### 📊 Phase 3: Premium Power BI Executive Dashboard

A streamlined, high-level interactive user interface built with advanced DAX overrides, customized page-level navigation, and tooltips:

- **Panel 1 (Customer Value Pyramid)**: A custom-sorted funnel proving that the **top 30% of customers generate 57.61% of total brand revenue**.
- **Panel 2 (Margin Leakage Chart)**: Exposes conditional color-blocked warning segments showing where full-price profiles are unnecessarily utilizing promotional vouchers.
- **Panel 3 (Geographic Opportunity Map)**: Dynamically maps bubbles scaled to gross revenue and colored using a multi-variable gradient tracking regional coupon risk.
- **Panel 4 (Category Retention Scatter)**: Plots products against an analytical benchmark line, explicitly identifying **Outerwear** as the primary customer acquisition funnel and **Accessories** as the organic retention core.

---

## 📈 Strategic Takeaways (The Playbook)

- **The Promotional Sunset Plan**: Surgically steps down and phases out flat percentage coupons for high-satisfaction core categories (e.g., Platinum buyers in Clothing) while transitioning them into experience-based appreciation benefits.
- **ICP Targeting Shift**: De-biases historical assumptions by refocusing digital performance marketing on a precise, lookalike demographic blueprint: females averaging 38.4 years old who manually check out during high-margin winter periods and prefer express fulfillment over monetary discounts.
- **The 30-Purchase Milestone Engine**: Replaces traditional price markdowns with shipping convenience by gamifying the progression toward 30 purchases to capture high long-term organic LTV.

---

## 🧰 Tech Stack

| Layer | Tools |
|---|---|
| Feature Engineering | Python, pandas |
| Data Storage & Querying | SQL (PostgreSQL/MySQL), CTEs, Window Functions |
| Visualization | Power BI, DAX |
| Deliverables | Markdown strategic playbooks |

---

## 📂 How to Navigate This Repo

1. Start with `1_Python_Feature_Engineering/feature_pipeline.py` to see how raw behavioral data was transformed into engineered metrics.
2. Review `2_SQL_Segmentation/schema.sql` and `segmentation_queries.sql` for the relational data layer and the 10 consulting queries.
3. Open `3_Power_BI_Dashboard/Customer_Value_Dashboard.pbix` for the interactive executive dashboard.
4. Read `4_Executive_Playbook/Executive_Summary.md` for the 1-page boardroom brief, or `Retention_Playbook.md` for the full strategic roadmap.

---

