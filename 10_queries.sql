-- Query 1: Revenue distribution by Value Tier and Promo Dependency
WITH CategorizedCustomers AS (
    SELECT 
        value_tier,
        "Customer ID",
        "Estimated LTV",
        "loyalty_score_A",
        CASE 
            WHEN promo_dependency_score >= 1.0 THEN 'Highly Promo Dependent'
            WHEN promo_dependency_score > 0.0 THEN 'Partially Promo Dependent'
            ELSE 'Organic (No Promos)'
        END AS promo_reliance
    FROM 
        customer_data
)
SELECT 
    value_tier,
    promo_reliance,
    COUNT("Customer ID") AS total_customers,
    ROUND(AVG("loyalty_score_A"), 2) AS avg_loyalty_score,
    SUM("Estimated LTV") AS total_projected_revenue,
    -- The Fix: Multiply by 100.0 first to force decimal math
    ROUND(SUM("Estimated LTV") * 100.0 / (SELECT SUM("Estimated LTV") FROM customer_data), 2) AS pct_of_total_revenue
FROM 
    CategorizedCustomers
GROUP BY 
    value_tier, 
    promo_reliance
ORDER BY 
    total_projected_revenue DESC;



-- Query 2: Identifying organic geographic traction
SELECT 
    "Location",
    COUNT("Customer ID") AS customer_count,
    ROUND(AVG("Estimated LTV"), 2) AS avg_ltv,
    ROUND(AVG(promo_dependency_score), 2) AS avg_promo_dependency,
    ROUND(AVG(satisfaction_flag) * 100, 2) AS satisfaction_rate_pct
FROM 
    customer_data
GROUP BY 
    "Location"
HAVING 
    COUNT("Customer ID") > 20 -- Ensuring statistical significance
ORDER BY 
    avg_promo_dependency ASC, -- Prioritize organic (low promo) regions
    avg_ltv DESC
LIMIT 10;



-- Query 3: Product category alignment with customer tenure
WITH CategoryStats AS (
    SELECT 
        "Category",
        COUNT("Customer ID") AS units_sold,
        ROUND(AVG("Previous Purchases"), 2) AS avg_prior_purchases,
        ROUND(AVG("Estimated LTV"), 2) AS avg_ltv
    FROM 
        customer_data
    GROUP BY 
        "Category"
)
SELECT 
    "Category",
    units_sold,
    avg_prior_purchases,
    avg_ltv,
    CASE 
        WHEN avg_prior_purchases < (SELECT AVG("Previous Purchases") FROM customer_data) THEN 'Entry Category'
        ELSE 'Retention Category'
    END AS category_role
FROM 
    CategoryStats
ORDER BY 
    avg_prior_purchases DESC;



-- Query 4: Profiling the Platinum Tier
SELECT 
    "Gender",
    ROUND(AVG("Age"), 1) AS avg_age,
    "Payment Method" AS preferred_payment,
    "Shipping Type" AS preferred_shipping,
    "Season" AS peak_season,
    COUNT("Customer ID") AS platinum_customer_count
FROM 
    customer_data
WHERE 
    value_tier = 'Platinum'
GROUP BY 
    "Gender", "Payment Method", "Shipping Type", "Season"
ORDER BY 
    platinum_customer_count DESC
LIMIT 5;



-- Query 5: Identifying organic geographic traction
SELECT 
    "Season",
    "Category",
    COUNT("Customer ID") AS total_customers,
    ROUND(AVG("Previous Purchases"), 2) AS avg_prior_purchases,
    ROUND(AVG("Estimated LTV"), 2) AS avg_ltv,
    ROUND(AVG(promo_dependency_score), 2) AS avg_promo_dependency
FROM 
    customer_data
GROUP BY 
    "Season", 
    "Category"
ORDER BY 
    avg_prior_purchases ASC;



-- Query 6: Identifying organic geographic traction
WITH DemographicSplit AS (
    SELECT 
        CASE 
            WHEN "Age" < 25 THEN 'Gen Z (Under 25)'
            WHEN "Age" BETWEEN 25 AND 40 THEN 'Millennials (25-40)'
            WHEN "Age" BETWEEN 41 AND 55 THEN 'Gen X (41-55)'
            ELSE 'Boomers (55+)'
        END AS age_cohort,
        "Gender",
        "Customer ID",
        "Estimated LTV",
        promo_dependency_score,
        satisfaction_flag
    FROM customer_data
)
SELECT 
    age_cohort,
    "Gender",
    COUNT("Customer ID") AS customer_count,
    ROUND(AVG("Estimated LTV"), 2) AS avg_ltv,
    ROUND(AVG(promo_dependency_score), 2) AS avg_promo_dependency,
    ROUND(AVG(satisfaction_flag) * 100, 2) AS satisfaction_rate_pct
FROM 
    DemographicSplit
GROUP BY 
    age_cohort, 
    "Gender"
ORDER BY 
    avg_promo_dependency ASC, 
    avg_ltv DESC;



-- Query 7: Identifying organic geographic traction
SELECT 
    value_tier,
    "Subscription Status",
    "Frequency of Purchases",
    COUNT("Customer ID") AS customer_volume,
    ROUND(AVG("Previous Purchases"), 2) AS avg_repeat_purchases,
    ROUND(AVG(satisfaction_flag) * 100, 2) AS satisfaction_rate_pct
FROM 
    customer_data
WHERE 
    value_tier IN ('Platinum', 'Bronze')
GROUP BY 
    value_tier, 
    "Subscription Status", 
    "Frequency of Purchases"
ORDER BY 
    value_tier DESC, 
    customer_volume DESC;



-- Query 8: Identifying organic geographic traction

SELECT 
    value_tier,
    "Category",
    COUNT("Customer ID") AS customer_volume,
    ROUND(AVG("Estimated LTV"), 2) AS avg_ltv,
    ROUND(AVG(satisfaction_flag) * 100, 2) AS satisfaction_rate_pct,
    ROUND(AVG(promo_dependency_score), 2) AS promo_dependency
FROM 
    customer_data
GROUP BY 
    value_tier, 
    "Category"
ORDER BY 
    promo_dependency DESC, 
    satisfaction_rate_pct DESC;



-- Query 9: Identifying organic geographic traction

WITH GeographicMetrics AS (
    SELECT 
        "Location",
        COUNT("Customer ID") AS total_customer_volume,
        SUM("Estimated LTV") AS total_projected_revenue,
        ROUND(AVG("Estimated LTV"), 2) AS avg_customer_ltv,
        ROUND(AVG(promo_dependency_score), 2) AS regional_promo_dependency,
        ROUND(AVG(satisfaction_flag) * 100, 2) AS regional_satisfaction_rate_pct
    FROM 
        customer_data
    GROUP BY 
        "Location"
)
SELECT 
    "Location",
    total_customer_volume,
    total_projected_revenue,
    avg_customer_ltv,
    regional_promo_dependency,
    regional_satisfaction_rate_pct,
    -- Classifying the geographic demand signal based on baseline metrics
    CASE 
        WHEN regional_promo_dependency <= 0.45 AND avg_customer_ltv >= (SELECT AVG("Estimated LTV") FROM customer_data) 
            THEN 'Core Organic Pull (High Spend, Low Promos)'
        WHEN regional_promo_dependency > 0.45 AND avg_customer_ltv >= (SELECT AVG("Estimated LTV") FROM customer_data) 
            THEN 'Subsidized Scale (High Spend, High Promos)'
        WHEN regional_promo_dependency <= 0.45 AND avg_customer_ltv < (SELECT AVG("Estimated LTV") FROM customer_data) 
            THEN 'Efficient Niches (Low Spend, Low Promos)'
        ELSE 'Discount Addicted (Low Spend, High Promos)'
    END AS geographic_demand_signal
FROM 
    GeographicMetrics
ORDER BY 
    regional_promo_dependency ASC, 
    total_projected_revenue DESC;



-- Query 10: Identifying organic geographic traction
WITH CustomerBehaviorProfiles AS (
    SELECT 
        "Subscription Status",
        "Frequency of Purchases",
        "Shipping Type",
        "Payment Method",
        COUNT("Customer ID") AS total_customers,
        ROUND(AVG("Age"), 1) AS avg_age,
        ROUND(AVG("Review Rating"), 2) AS avg_review_rating,
        ROUND(AVG(promo_dependency_score), 2) AS avg_promo_dependency,
        ROUND(AVG("Previous Purchases"), 1) AS avg_historical_purchases,
        ROUND(AVG("Estimated LTV"), 2) AS avg_lifetime_value
    FROM 
        customer_data
    GROUP BY 
        "Subscription Status",
        "Frequency of Purchases",
        "Shipping Type",
        "Payment Method"
)
SELECT 
    "Subscription Status",
    "Frequency of Purchases",
    "Shipping Type",
    "Payment Method",
    total_customers,
    avg_age,
    avg_review_rating,
    avg_promo_dependency,
    avg_historical_purchases,
    avg_lifetime_value,
    -- Labeling behavioral predictability based on the overall cohort average LTV
    CASE 
        WHEN avg_lifetime_value >= (SELECT AVG("Estimated LTV") * 1.5 FROM customer_data) THEN 'High-Value Predictive Pattern'
        WHEN avg_lifetime_value >= (SELECT AVG("Estimated LTV") FROM customer_data) THEN 'Moderate-Value Baseline Pattern'
        ELSE 'Low-Value Churn Risk Pattern'
    END AS ltv_predictive_signal
FROM 
    CustomerBehaviorProfiles
WHERE 
    total_customers >= 5 -- Filtering out statistically insignificant single-user combinations
ORDER BY 
    avg_lifetime_value DESC;
