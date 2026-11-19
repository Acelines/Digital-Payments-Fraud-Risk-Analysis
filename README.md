# Digital Payments & Fraud Risk Analysis

## Project Overview

This project examines fraud risk in digital payment transactions, focusing on transaction behaviour, customer activity, payment channels, and financial exposure.

Using SQL, I explored transaction patterns and identified factors associated with fraudulent activity. Tableau was then used to present the results through two interactive dashboards.

## Business Objectives

- Examine overall transaction performance and fraud activity.
- Identify transaction types associated with higher fraud rates and financial exposure.
- Evaluate fraud risk across payment channels, devices, customer types, and account ages.
- Examine how fraud rates vary across transaction types and the six geopolitical zones.
- Provide insights that can support fraud monitoring and risk management decisions.

## Dataset Overview

The dataset contains 50,000 simulated digital payment transactions representing payment activity in Nigeria over 2025.

It includes transaction details, customer information, payment channels, device activity, transaction amounts, account age, regional information covering Nigeria's six geopolitical zones, and fraud indicators.

## Tools Used

- **SQL:** Data inspection, exploratory analysis, aggregation, and creation of analytical views.
- **Tableau Public:** Data visualization and interactive dashboards.

## Data Inspection and Preparation

Initial inspection covered:

- Dataset size and transaction ID uniqueness.
- Missing values and duplicate records.
- Transaction amount and fee distributions.
- Transaction type and payment channel distributions.
- Customer type and fraud indicator distributions.
- Transaction date coverage.

The inspection did not identify a need for substantial data cleaning. Missing regional values were accounted for during the regional analysis.

## SQL Analysis

The analysis was organised into three scripts:

**01 – Data Inspection**

- Examined the dataset structure, completeness, uniqueness, and distributions.

**02 – Exploratory Analysis**

- Transaction volume and value by transaction type.
- Fraud rates and financial exposure by transaction type.
- Fraud patterns by device and payment channel.
- Account age and customer type analysis.
- Transaction amount and failed transaction analysis.
- Fraud patterns by time, month, and region.
- Combined analysis of device, channel, customer type, and transaction type.

**03 – Final Analytical Views**

Four SQL views were created for Tableau:

- `vw_fraud_overall`
- `vw_fraud_by_transaction_type`
- `vw_fraud_risk_factors`
- `vw_fraud_trends`

## Tableau Dashboards

The analysis was presented through two dashboards.

### 1. Fraud Overview

Provides an overview of transaction activity, fraud rates, and financial exposure.



**Key components:**

- Fraud Rate
- Total Transactions
- Flagged Transactions
- Fraud Exposure
- Fraud Rate by Transaction Type
- Fraud Exposure by Transaction Type
- Monthly Fraud Rate
- Monthly Fraud Exposure

### 2. Fraud Risk Analysis

Examines the factors and transaction patterns associated with fraudulent activity.



**Key components:**

- Fraud Rate by Device
- Fraud Rate by Channel
- Fraud Rate by Account Age
- Fraud Rate by Customer Type
- Device and Channel Fraud Risk
- Customer Type and Transaction Type Fraud Risk

[**View the Interactive Dashboards on Tableau Public**](https://public.tableau.com:9443/views/DigitalPaymentsFraudRiskAnalysis/FraudOverview?\:language=en-US&\:sid=&\:redirect=auth&\:display_count=n&\:origin=viz_share_link)

## Key Insights

### Overall Fraud Performance

- 50,000 transactions were analysed.
- 765 transactions were flagged.
- The overall fraud rate was 1.5%.
- Total fraud exposure amounted to ₦182.1M.

### Transaction Type

- Transfers recorded the highest fraud rate at 2.7%.
- Transfers also accounted for the largest financial exposure at ₦131.9M.
- Cash-Out transactions recorded the second-highest exposure at ₦25.7M.

### Monthly Trends

- December recorded the highest monthly fraud rate at approximately 2.3%.
- December also recorded the highest fraud exposure at ₦31.6M.
- July followed with ₦25.0M in fraud exposure.

### Device and Payment Channel

- Transactions from new devices had an 11.5% fraud rate, compared with 0.7% for existing devices.
- Web transactions from new devices recorded the highest combined fraud rate at 17.2%.
- USSD transactions recorded a 2.1% fraud rate, followed by Web at 2.0% and Mobile App at 1.2%.

### Account Age and Customer Type

- Accounts aged 0–5 months recorded the highest fraud rate at 2.0%.
- Business customers had a higher fraud rate of 1.7%, compared with 1.4% for individual customers.

### Combined Risk Patterns

- Transfers recorded the highest fraud rate across both business and individual customer categories.
- Business transfers had a 3.0% fraud rate, compared with 2.5% for individual transfers.
- Regional analysis also showed differences in fraud rates across transaction types, with transfers presenting elevated risk in several regions.

## Business Recommendations

1. **Strengthen transfer monitoring:** Apply closer monitoring to transfers, particularly those involving higher transaction values or unusual activity.

2. **Introduce additional device verification:** Apply stronger authentication checks when transactions originate from new devices, especially through Web channels.

3. **Monitor newer accounts:** Apply additional monitoring to accounts within their first six months of activity.

4. **Review business transactions:** Give particular attention to business transfers, which recorded a higher fraud rate than individual transfers.

5. **Monitor monthly trends:** Increase fraud monitoring during periods with higher observed fraud rates and financial exposure, particularly December.

6. **Use regional risk patterns:** Prioritise closer monitoring of transfer transactions in the South West and North Central zones, where fraud rates reached 3.0%, and review regional differences across other transaction types to identify areas requiring additional attention.

## Repository Structure

```text
Digital-Payments-Fraud-Analysis/
│
├── SQL/
│   ├── 01_Data_Inspection.sql
│   ├── 02_Exploratory_Analysis.sql
│   └── 03_Final_Views.sql
│
├── Tableau/
│   └── Digital_Payments_Fraud_Analysis.twbx
│
├── Dashboard Images/
│   ├── Fraud_Overview.png
│   └── Fraud_Risk_Analysis.png
│
└── README.md
```

## Project Scope

This project demonstrates the use of SQL to examine digital payment activity and fraud risk, alongside Tableau dashboards for communicating analytical results. The analysis provides a basis for identifying risk patterns and supporting more informed fraud monitoring decisions.
