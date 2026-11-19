
-- =====================================================
-- DIGITAL PAYMENTS & FRAUD RISK ANALYSIS
-- DATA INSPECTION
-- =====================================================

-- 1. Inspect table structure
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'digital_payments_fraud_transactions_2025'
ORDER BY ORDINAL_POSITION;


-- 2. Check dataset size and uniqueness
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT Transaction_ID) AS unique_transactions,
    COUNT(DISTINCT Customer_ID) AS unique_customers
FROM digital_payments_fraud_transactions_2025;


-- 3. Check for missing values in key fields
SELECT
    SUM(CASE WHEN Transaction_ID IS NULL THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END) AS missing_amount,
    SUM(CASE WHEN Transaction_Type IS NULL THEN 1 ELSE 0 END) AS missing_type,
    SUM(CASE WHEN Fraud_Flag IS NULL THEN 1 ELSE 0 END) AS missing_fraud_flag
FROM digital_payments_fraud_transactions_2025;


-- 4. Check for duplicate transaction IDs
SELECT
    Transaction_ID,
    COUNT(*) AS duplicate_count
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;


-- 5. Examine transaction amounts and fees
SELECT
    MIN(Transaction_Amount) AS minimum_amount,
    MAX(Transaction_Amount) AS maximum_amount,
    AVG(Transaction_Amount) AS average_amount,
    MIN(Transaction_Fee) AS minimum_fee,
    MAX(Transaction_Fee) AS maximum_fee,
    SUM(CASE WHEN Transaction_Amount <= 0 THEN 1 ELSE 0 END) AS non_positive_amounts,
    SUM(CASE WHEN Transaction_Fee < 0 THEN 1 ELSE 0 END) AS negative_fees
FROM digital_payments_fraud_transactions_2025;


-- 6. Examine transaction channel distribution
SELECT
    Transaction_Channel,
    COUNT(*) AS transaction_count
FROM digital_payments_fraud_transactions_2025
GROUP BY Transaction_Channel
ORDER BY transaction_count DESC;


-- 7. Examine customer type distribution
SELECT
    Customer_Type,
    COUNT(*) AS transaction_count
FROM digital_payments_fraud_transactions_2025
GROUP BY Customer_Type
ORDER BY transaction_count DESC;


-- 8. Examine fraud flag and fraud type combinations
SELECT
    Fraud_Flag,
    Fraud_Type,
    COUNT(*) AS transaction_count
FROM digital_payments_fraud_transactions_2025
GROUP BY Fraud_Flag, Fraud_Type
ORDER BY Fraud_Flag DESC, transaction_count DESC;


-- 9. Check date coverage
SELECT
    MIN(Transaction_Date) AS first_transaction_date,
    MAX(Transaction_Date) AS last_transaction_date,
    COUNT(DISTINCT Transaction_Date) AS active_transaction_days
FROM digital_payments_fraud_transactions_2025;


-- 10. Examine customer account age
SELECT
    MIN(Account_Age_Months) AS minimum_account_age,
    MAX(Account_Age_Months) AS maximum_account_age,
    AVG(Account_Age_Months) AS average_account_age
FROM digital_payments_fraud_transactions_2025;
