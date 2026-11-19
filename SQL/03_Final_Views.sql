
-- =====================================================
-- DIGITAL PAYMENTS & FRAUD RISK ANALYSIS
-- FINAL ANALYTICAL VIEWS
-- =====================================================


-- =====================================================
-- 1. OVERALL FRAUD PERFORMANCE
-- =====================================================
-- Provides overall transaction metrics, fraud rate
-- and financial exposure for dashboard KPI cards.

CREATE VIEW vw_fraud_overall AS
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(Transaction_Amount) AS total_transaction_value,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE NULL END) AS average_fraudulent_transaction
FROM digital_payments_fraud_transactions_2025;


-- =====================================================
-- 2. FRAUD BY TRANSACTION TYPE
-- =====================================================
-- Compares transaction volume, fraud rates and financial
-- exposure across transaction types.

CREATE VIEW vw_fraud_by_transaction_type AS
SELECT
    Transaction_Type,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(Transaction_Amount) AS total_transaction_value,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE NULL END) AS average_fraudulent_transaction
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Type;


-- =====================================================
-- 3. FRAUD RISK FACTORS
-- =====================================================
-- Consolidates individual fraud risk factors and combined
-- risk segments into one Tableau-ready analytical view.
--
-- Individual risk factors:
-- Device, Channel, Customer Type, Account Age.
--
-- Combined risk segments:
-- Device and Channel, Customer Type and Transaction Type,
-- Region and Transaction Type.

CREATE VIEW vw_fraud_risk_factors AS

-- Device risk
SELECT
    'Device' AS risk_factor,
    CAST(Is_New_Device AS VARCHAR(50)) AS category,
    'All' AS subcategory,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY Is_New_Device

UNION ALL

-- Transaction channel risk
SELECT
    'Channel',
    Transaction_Channel,
    'All',
    COUNT(*),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END),
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END)
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Channel

UNION ALL

-- Customer type risk
SELECT
    'Customer Type',
    Customer_Type,
    'All',
    COUNT(*),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END),
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END)
FROM digital_payments_fraud_transactions_2025
GROUP BY Customer_Type

UNION ALL

-- Account age risk
SELECT
    'Account Age',
    CASE
        WHEN Account_Age_Months < 6 THEN '0-5 Months'
        WHEN Account_Age_Months < 12 THEN '6-11 Months'
        WHEN Account_Age_Months < 24 THEN '12-23 Months'
        WHEN Account_Age_Months < 60 THEN '24-59 Months'
        ELSE '60+ Months'
    END,
    'All',
    COUNT(*),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END),
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END)
FROM digital_payments_fraud_transactions_2025
GROUP BY
    CASE
        WHEN Account_Age_Months < 6 THEN '0-5 Months'
        WHEN Account_Age_Months < 12 THEN '6-11 Months'
        WHEN Account_Age_Months < 24 THEN '12-23 Months'
        WHEN Account_Age_Months < 60 THEN '24-59 Months'
        ELSE '60+ Months'
    END

UNION ALL

-- Combined device and channel risk
SELECT
    'Device and Channel',
    CAST(Is_New_Device AS VARCHAR(50)),
    Transaction_Channel,
    COUNT(*),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END),
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END)
FROM digital_payments_fraud_transactions_2025
GROUP BY Is_New_Device, Transaction_Channel

UNION ALL

-- Combined customer type and transaction type risk
SELECT
    'Customer and Transaction Type',
    Customer_Type,
    Transaction_Type,
    COUNT(*),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END),
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END)
FROM digital_payments_fraud_transactions_2025
GROUP BY Customer_Type, Transaction_Type

UNION ALL

-- Combined region and transaction type risk
SELECT
    'Region and Transaction Type',
    COALESCE(Customer_Region, 'Unknown'),
    Transaction_Type,
    COUNT(*),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END),
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END),
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END)
FROM digital_payments_fraud_transactions_2025
GROUP BY COALESCE(Customer_Region, 'Unknown'), Transaction_Type;


-- =====================================================
-- 4. FRAUD TRENDS
-- =====================================================
-- Tracks monthly transaction activity, fraud rates
-- and financial exposure throughout the year.

CREATE VIEW vw_fraud_trends AS
SELECT
    MONTH(Transaction_Date) AS transaction_month_number,
    CASE MONTH(Transaction_Date)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS transaction_month,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(Transaction_Amount) AS total_transaction_value,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY MONTH(Transaction_Date);
