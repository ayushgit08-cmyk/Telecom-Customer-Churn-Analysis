Create the Table
CREATE TABLE telco_churn (
customerID VARCHAR(20),
gender VARCHAR(10),
SeniorCitizen INT,
Partner VARCHAR(10),
Dependents VARCHAR(10),
tenure INT,
PhoneService VARCHAR(10),
MultipleLines VARCHAR(20),
InternetService VARCHAR(20),
OnlineSecurity VARCHAR(20),
OnlineBackup VARCHAR(20),
DeviceProtection VARCHAR(20),
TechSupport VARCHAR(20),
StreamingTV VARCHAR(20),
StreamingMovies VARCHAR(20),
Contract VARCHAR(20),
PaperlessBilling VARCHAR(10),
PaymentMethod VARCHAR(50),
MonthlyCharges DECIMAL(10,2),
TotalCharges DECIMAL(10,2),
Churn VARCHAR(10)
);

Import the CSV Correctly
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/telco_churn.csv'
INTO TABLE telco_churn
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customerID,gender,SeniorCitizen,Partner,Dependents,tenure,
PhoneService,MultipleLines,InternetService,OnlineSecurity,
OnlineBackup,DeviceProtection,TechSupport,StreamingTV,
StreamingMovies,Contract,PaperlessBilling,PaymentMethod,
MonthlyCharges,@TotalCharges,Churn)
SET TotalCharges = NULLIF(TRIM(@TotalCharges),'');

Clean Hidden Characters
UPDATE telco_churn
SET Churn = REPLACE(Churn, '\r','');

Verify Data Loaded Correctly
SELECT COUNT(*) FROM telco_churn;

Check Churn Values
SELECT DISTINCT Churn FROM telco_churn;

Churn Distribution
SELECT Churn, COUNT(*)
FROM telco_churn
GROUP BY Churn;

Contract Distribution
SELECT Contract, COUNT(*)
FROM telco_churn
GROUP BY Contract;

Total Customers
SELECT COUNT(*) AS total_customers
FROM telco_churn;

Calculate Churn Rate
SELECT 
ROUND(
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2
) AS churn_rate
FROM telco_churn;

Monthly Revenue
SELECT SUM(MonthlyCharges) AS monthly_revenue
FROM telco_churn;

Revenue Lost Due to Churn
SELECT SUM(MonthlyCharges) AS revenue_lost
FROM telco_churn
WHERE Churn='Yes';

Churn by Contract Type
SELECT
Contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM telco_churn
GROUP BY Contract;

Churn by Payment Method
SELECT
PaymentMethod,
COUNT(*) AS customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned
FROM telco_churn
GROUP BY PaymentMethod;

Churn by Tenure Group
SELECT
CASE
WHEN tenure <= 12 THEN '0-1 Year'
WHEN tenure <= 24 THEN '1-2 Years'
WHEN tenure <= 48 THEN '2-4 Years'
ELSE '4+ Years'
END AS tenure_group,
COUNT(*) AS customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned
FROM telco_churn
GROUP BY tenure_group;

Export Your Table to CSV
SELECT *
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 9.6/Uploads/clean_telco_churn.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM telco_churn;

