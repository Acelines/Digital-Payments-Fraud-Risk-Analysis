
-- =====================================================
-- DIGITAL PAYMENTS & FRAUD RISK ANALYSIS
-- EXPLORATORY DATA ANALYSIS
-- =====================================================


-- =====================================================
-- 1. TRANSACTION PERFORMANCE
-- =====================================================

-- Which transaction types generate the highest value,
-- and how does this compare with transaction volume?

SELECT
    Transaction_Type,
    COUNT(*) AS transaction_count,
    SUM(Transaction_Amount) AS total_transaction_value,
    AVG(Transaction_Amount) AS average_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Type
ORDER BY total_transaction_value DESC;


-- =====================================================
-- 2. FRAUD BY TRANSACTION TYPE
-- =====================================================

-- Is fraud concentrated in particular transaction types?

SELECT
    Transaction_Type,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Type
ORDER BY fraud_rate DESC;


-- Does fraud concentration translate into greater
-- financial exposure across transaction types?

SELECT
    Transaction_Type,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE NULL END) AS average_fraudulent_transaction
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Type
ORDER BY fraudulent_transaction_value DESC;


-- =====================================================
-- 3. DEVICE RISK
-- =====================================================

-- Are transactions from new devices more likely to be fraudulent?

SELECT
    Is_New_Device,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate
FROM digital_payments_fraud_transactions_2025
GROUP BY Is_New_Device
ORDER BY Is_New_Device DESC;


-- Are transactions from new devices particularly high-risk
-- for specific transaction types?

SELECT
    Transaction_Type,
    Is_New_Device,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Type, Is_New_Device
ORDER BY fraud_rate DESC;


-- =====================================================
-- 4. ACCOUNT AGE AND FRAUD RISK
-- =====================================================

-- Are transactions from newer accounts more likely
-- to be fraudulent than transactions from established accounts?

WITH bucketed_data AS (
    SELECT
        Fraud_Flag,
        Account_Age_Months,
        CASE
            WHEN Account_Age_Months < 6 THEN '0-5 Months'
            WHEN Account_Age_Months < 12 THEN '6-11 Months'
            WHEN Account_Age_Months < 24 THEN '12-23 Months'
            WHEN Account_Age_Months < 60 THEN '24-59 Months'
            ELSE '60+ Months'
        END AS account_age_group,
        CASE
            WHEN Account_Age_Months < 6 THEN 1
            WHEN Account_Age_Months < 12 THEN 2
            WHEN Account_Age_Months < 24 THEN 3
            WHEN Account_Age_Months < 60 THEN 4
            ELSE 5
        END AS account_age_sort
    FROM digital_payments_fraud_transactions_2025
)
SELECT
    account_age_group,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate
FROM bucketed_data
GROUP BY account_age_group, account_age_sort
ORDER BY account_age_sort;


-- =====================================================
-- 5. FRAUD BY TRANSACTION CHANNEL
-- =====================================================

-- Does the channel with the highest transaction volume
-- also have the highest fraud rate?

SELECT
    Transaction_Channel,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Channel
ORDER BY fraud_rate DESC;


-- =====================================================
-- 6. TRANSACTION VALUE AND FRAUD
-- =====================================================

-- Do fraudulent transactions tend to involve larger amounts
-- than legitimate transactions?

SELECT
    Fraud_Flag,
    COUNT(*) AS transaction_count,
    AVG(Transaction_Amount) AS average_transaction_amount,
    MIN(Transaction_Amount) AS minimum_transaction_amount,
    MAX(Transaction_Amount) AS maximum_transaction_amount,
    SUM(Transaction_Amount) AS total_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY Fraud_Flag;


-- =====================================================
-- 7. FAILED TRANSACTIONS AND FRAUD
-- =====================================================

-- Are failed transactions associated with higher fraud rates?

SELECT
    Failed_Transaction,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate
FROM digital_payments_fraud_transactions_2025
GROUP BY Failed_Transaction
ORDER BY fraud_rate DESC;


-- =====================================================
-- 8. FRAUD BY CUSTOMER TYPE
-- =====================================================

-- Do Individual or Business customers have higher fraud risk
-- and financial exposure?

SELECT
    Customer_Type,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE NULL END) AS average_fraudulent_transaction
FROM digital_payments_fraud_transactions_2025
GROUP BY Customer_Type
ORDER BY fraud_rate DESC;


-- =====================================================
-- 9. FRAUD BY TRANSACTION TIME
-- =====================================================

-- Are fraudulent transactions more concentrated
-- during particular periods of the day?

WITH fraud_by_time AS (
    SELECT
        Transaction_Time,
        Fraud_Flag,
        Transaction_Amount,
        CASE
            WHEN Transaction_Time >= '00:00:00' AND Transaction_Time < '06:00:00'
                THEN 'Night (12 AM-6 AM)'
            WHEN Transaction_Time >= '06:00:00' AND Transaction_Time < '12:00:00'
                THEN 'Morning (6 AM-12 PM)'
            WHEN Transaction_Time >= '12:00:00' AND Transaction_Time < '18:00:00'
                THEN 'Afternoon (12 PM-6 PM)'
            ELSE 'Evening (6 PM-12 AM)'
        END AS transaction_period
    FROM digital_payments_fraud_transactions_2025
)
SELECT
    transaction_period,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value
FROM fraud_by_time
GROUP BY transaction_period
ORDER BY fraud_rate DESC;


-- =====================================================
-- 10. FRAUD BY FRAUD TYPE
-- =====================================================

-- Which fraud types account for the highest fraud rates
-- and financial exposure?

SELECT
    Fraud_Type,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE NULL END) AS average_fraudulent_transaction
FROM digital_payments_fraud_transactions_2025
WHERE Fraud_Type IS NOT NULL
    AND Fraud_Type <> 'None'
GROUP BY Fraud_Type
ORDER BY fraud_rate DESC;


-- =====================================================
-- 11. FRAUD BY TRANSACTION MONTH
-- =====================================================

-- Does fraud risk vary throughout the year,
-- and which months have higher financial exposure?

SELECT
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
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY MONTH(Transaction_Date)
ORDER BY MONTH(Transaction_Date);


-- =====================================================
-- 12. FRAUD BY CUSTOMER REGION
-- =====================================================

-- Are some customer regions associated with higher fraud risk
-- or financial exposure?

SELECT
    COALESCE(Customer_Region, 'Unknown') AS customer_region,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE NULL END) AS average_fraudulent_transaction
FROM digital_payments_fraud_transactions_2025
GROUP BY COALESCE(Customer_Region, 'Unknown')
ORDER BY fraud_rate DESC;


-- =====================================================
-- 13. REGION AND TRANSACTION TYPE
-- =====================================================

-- Is regional fraud risk driven by particular transaction types?

SELECT
    COALESCE(Customer_Region, 'Unknown') AS customer_region,
    Transaction_Type,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY COALESCE(Customer_Region, 'Unknown'), Transaction_Type
ORDER BY fraud_rate DESC;


-- =====================================================
-- 14. CUSTOMER TYPE AND TRANSACTION TYPE
-- =====================================================

-- Does fraud risk differ between Individual and Business
-- customers depending on the transaction type?

SELECT
    Customer_Type,
    Transaction_Type,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY Customer_Type, Transaction_Type
ORDER BY fraud_rate DESC;


-- =====================================================
-- 15. DEVICE AND TRANSACTION CHANNEL
-- =====================================================

-- Are certain device and transaction channel combinations
-- associated with higher fraud risk?

SELECT
    Is_New_Device,
    Transaction_Channel,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN 1 ELSE 0 END) AS fraudulent_transactions,
    AVG(CASE WHEN Fraud_Flag = TRUE THEN 1.0 ELSE 0.0 END) AS fraud_rate,
    SUM(CASE WHEN Fraud_Flag = TRUE THEN Transaction_Amount ELSE 0 END) AS fraudulent_transaction_value
FROM digital_payments_fraud_transactions_2025
GROUP BY Is_New_Device, Transaction_Channel
ORDER BY fraud_rate DESC;
