create database  Banking_Database;
use banking_database;
  
  /* Drop existing tables  */
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS AccountHolders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS CreditCards; 
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Auditlogs;
DROP TABLE IF EXISTS Userauth;

 -- Create the Branches Table
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100) NOT NULL,
    BranchAddress VARCHAR(255),
    PhoneNumber VARCHAR(15),
    EstablishedDate DATE
);
-- Insert sample data into Branches table
INSERT INTO Branches (BranchName, BranchAddress, PhoneNumber, EstablishedDate) VALUES
('HBL Head Office', 'HBL Plaza, I.I. Chundrigar Road, Karachi', '021-111-111-425', '1972-11-01'),
('HBL Clifton Branch', 'Clifton, Karachi', '021-111-111-426', '1985-03-15'),
('HBL Gulshan Branch', 'Gulshan-e-Iqbal, Karachi', '021-111-111-427', '1990-06-10'),
('HBL F-6 Branch', 'F-6 Markaz, Islamabad', '051-111-111-428', '1995-07-20'),
('HBL Johar Town Branch', 'Johar Town, Lahore', '042-111-111-429', '2000-09-30');

select *from branches;

-- Create the Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
     
);
-- Insert sample data into Customers table (20 entries)
INSERT INTO Customers (FirstName,   DateOfBirth, Address, PhoneNumber, Email) VALUES
('Ahmed Khan', '1980-04-15', 'House No 1, Clifton, Karachi', '0321-0001111', 'ahmed.khan@hbl.com.pk'),
('Sara Ali', '1992-07-23', 'House No 2, Gulshan, Karachi', '0322-0002222', 'sara.ali@hbl.com.pk'),
('Hassan Mehmood', '1985-12-10', 'House No 3, F-7, Islamabad', '0323-0003333', 'hassan.mehmood@hbl.com.pk'),
('Ayesha Malik', '1990-03-01', 'House No 4, Johar Town, Lahore', '0324-0004444', 'ayesha.malik@hbl.com.pk'),
('Raza Ahmed', '1978-09-18', 'House No 5, Saddar, Karachi', '0325-0005555', 'raza.ahmed@hbl.com.pk'),
('Mehwish', 'Khan', '1992-05-18', 'House No 20, F-8, Islamabad', '0340-0010011', 'mehwish.khan@hbl.com.pk');

select *from customers;

-- Create the Accounts Table with foreign key reference to Branches
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    AccountNumber VARCHAR(20) UNIQUE NOT NULL,
    AccountType ENUM('Savings', 'Current', 'Fixed Deposit') NOT NULL,
    Balance DECIMAL(15, 2) DEFAULT 0.00,
    BranchID INT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
-- Insert sample data into Accounts table (20 entries)
INSERT INTO Accounts (AccountNumber, AccountType, Balance, BranchID, CreatedAt) VALUES
('PK001HBL0001', 'Savings', 50000.00, 1, '2023-01-01'),
('PK001HBL0002', 'Current', 150000.00, 2, '2023-02-01'),
('PK001HBL0003', 'Fixed Deposit', 250000.00, 3, '2023-03-01'),
('PK001HBL0004', 'Savings', 70000.00, 4, '2023-04-01'),
('PK001HBL0005', 'Current', 200000.00, 5, '2023-05-01'),
('PK001HBL0006', 'Savings', 60000.00, 1, '2023-06-01');
 

select *from Accounts;

-- Create the AccountHolders Table for Joint Accounts
CREATE TABLE AccountHolders (
    AccountHolderID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    CustomerID INT,
    HolderType ENUM('Primary', 'Secondary') DEFAULT 'Primary',
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)[employees]
);
-- Insert sample data into AccountHolders table (20 entries)
INSERT INTO AccountHolders (AccountID, CustomerID, HolderType) VALUES
(1, 1, 'Primary'),
(2, 2, 'Primary'),
(3, 3, 'Primary'),
(4, 4, 'Primary'),
(5, 5, 'Primary'),
(6, 6, 'Primary');
 
 

select *from AccountHolders;n

-- Create the Credit Cards Table
CREATE TABLE CreditCards (
    CardID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    CardNumber VARCHAR(16) UNIQUE NOT NULL,
    ExpiryDate DATE,
    CVV VARCHAR(4),
    CreditLimit DECIMAL(10, 2),
    Balance DECIMAL(10, 2) DEFAULT 0.00,
    Status ENUM('Active', 'Inactive', 'Blocked') DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-- Insert sample data into CreditCards table (20 entries)
INSERT INTO CreditCards (CustomerID, CardNumber, ExpiryDate, CVV, CreditLimit, Balance, Status) VALUES
(1, '1234567890123456', '2025-12-31', '123', 100000.00, 5000.00, 'Active'),
(2, '2345678901234567', '2024-11-30', '234', 150000.00, 10000.00, 'Active'),
(3, '3456789012345678', '2026-10-31', '345', 200000.00, 7500.00, 'Active'),
(4, '4567890123456789', '2023-09-30', '456', 120000.00, 12000.00, 'Blocked'),
(5, '5678901234567890', '2027-08-31', '567', 130000.00, 0.00, 'Active'),
(6, '6789012345678901', '2025-07-31', '678', 140000.00, 2000.00, 'Active');
 

select *from creditcards;
-- Create the Transactions Table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    CardID INT DEFAULT NULL,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer', 'Payment') NOT NULL,
    Amount DECIMAL(15, 2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Remarks VARCHAR(255),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (CardID) REFERENCES CreditCards(CardID)
);
-- Insert sample data into Transactions table (20 entries)
INSERT INTO Transactions (AccountID, CardID, TransactionType, Amount, TransactionDate, Remarks) VALUES
(1, NULL, 'Deposit', 10000.00, '2024-01-10', 'Salary deposit'),
(2, NULL, 'Withdrawal', 5000.00, '2024-01-12', 'ATM withdrawal'),
(3, 1, 'Payment', 2000.00, '2024-01-15', 'Credit card payment'),
(4, NULL, 'Transfer', 7000.00, '2024-01-18', 'Transfer to savings'),
(5, NULL, 'Deposit', 12000.00, '2024-01-20', 'Bonus deposit'),
(6, 2, 'Payment', 1500.00, '2024-01-22', 'Credit card payment');
 

select *from Transactions;


 -- Retrieve All Customer Information
SELECT * FROM Customers;

-- List Active Accounts and Balances
SELECT AccountID, AccountNumber, AccountType, Balance 
FROM Accounts 
WHERE Balance > 0;

-- Find Joint Account Holders for an Account
SELECT c.FirstName, c.LastName, ah.HolderType
FROM AccountHolders ah
JOIN Customers c ON ah.CustomerID = c.CustomerID
WHERE ah.AccountID = AccountID;

-- Get Customer’s Transaction History
SELECT t.TransactionID, t.TransactionType, t.Amount, t.TransactionDate, t.Remarks
FROM Transactions t
JOIN AccountHolders ah ON t.AccountID = ah.AccountID
WHERE ah.CustomerID = CustomerID
ORDER BY t.TransactionDate DESC;

-- Find All Credit Cards Linked to a Customer
SELECT CardID, CardNumber, ExpiryDate, CreditLimit, Balance, Status
FROM CreditCards
WHERE CustomerID = CustomerID;

-- Show Transactions Done with Credit Card Only
SELECT TransactionID, AccountID, CardID, TransactionType, Amount, TransactionDate, Remarks
FROM Transactions
WHERE CardID IS NOT NULL;

-- Total Balance of All Accounts for a Customer
SELECT SUM(a.Balance) AS TotalBalance
FROM Accounts a
JOIN AccountHolders ah ON a.AccountID = ah.AccountID
WHERE ah.CustomerID = CustomerID;

-- List of Transactions Above a Certain Amount
SELECT TransactionID, AccountID, CardID, TransactionType, Amount, TransactionDate, Remarks
FROM Transactions
WHERE Amount > Amount;

-- Audit Log for a Specific User
SELECT LogID, ActionType, ActionDetails, Timestamp
FROM AuditLogs
WHERE UserID = UserID
ORDER BY Timestamp DESC;

-- Recent Logins
SELECT Username, LastLogin
FROM UserAuth
ORDER BY LastLogin DESC;

-- Check for Locked or Inactive Credit Cards
SELECT CardID, CustomerID, CardNumber, Status
FROM CreditCards
WHERE Status IN ('Blocked', 'Inactive');

-- Most Recent Transactions for Each Account
SELECT AccountID, MAX(TransactionDate) AS LastTransactionDate
FROM Transactions
GROUP BY AccountID
ORDER BY LastTransactionDate DESC;

-- Count Total Number of Accounts per Customer
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(ah.AccountID) AS AccountCount
FROM Customers c
JOIN AccountHolders ah ON c.CustomerID = ah.CustomerID
GROUP BY c.CustomerID;

-- View All Active Customers Using MFA
SELECT c.CustomerID, c.FirstName, c.LastName, ua.MFAEnabled
FROM Customers c
JOIN UserAuth ua ON c.CustomerID = ua.CustomerID
WHERE ua.MFAEnabled = TRUE AND c.Status = 'Active';

-- Find Top 5 Customers by Account Balance
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(a.Balance) AS TotalBalance
FROM Customers c
JOIN AccountHolders ah ON c.CustomerID = ah.CustomerID
JOIN Accounts a ON ah.AccountID = a.AccountID
GROUP BY c.CustomerID
ORDER BY TotalBalance DESC
LIMIT 5;

-- List All Transactions for a Date Range
SELECT TransactionID, AccountID, CardID, TransactionType, Amount, TransactionDate, Remarks
FROM Transactions
WHERE TransactionDate BETWEEN '2024-01-01' AND '2024-12-31';

-- View All Deposits and Withdrawals for an Account
SELECT TransactionID, TransactionType, Amount, TransactionDate
FROM Transactions
WHERE AccountID = AccountID AND TransactionType IN ('Deposit', 'Withdrawal')
ORDER BY TransactionDate DESC;

-- Calculate Total Amount of All Deposits and Withdrawals by Account
SELECT AccountID, 
       SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount ELSE 0 END) AS TotalDeposits,
       SUM(CASE WHEN TransactionType = 'Withdrawal' THEN Amount ELSE 0 END) AS TotalWithdrawals
FROM Transactions
GROUP BY AccountID;

-- Get Customers with No Transactions in the Last 6 Months
SELECT c.CustomerID, c.FirstName, c.LastName
FROM Customers c
LEFT JOIN AccountHolders ah ON c.CustomerID = ah.CustomerID
LEFT JOIN Transactions t ON ah.AccountID = t.AccountID AND t.TransactionDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
WHERE t.TransactionID IS NULL;

-- Top 5 Most Frequent Transaction Types
SELECT TransactionType, COUNT(*) AS Frequency
FROM Transactions
GROUP BY TransactionType
ORDER BY Frequency DESC
LIMIT 5;

-- Identify Customers with Multiple Active Credit Cards
SELECT CustomerID, COUNT(CardID) AS ActiveCards
FROM CreditCards
WHERE Status = 'Active'
GROUP BY CustomerID
HAVING ActiveCards > 16;

-- Find Accounts with Joint Holders
SELECT AccountID, COUNT(AccountHolderID) AS NumberOfHolders
FROM AccountHolders
GROUP BY AccountID
HAVING NumberOfHolders > 1;

-- Track Last Login Date for All Users
SELECT UserID, Username, LastLogin
FROM UserAuth
ORDER BY LastLogin DESC;

-- Count of Inactive Accounts by Branch
SELECT b.BranchID, b.BranchName, COUNT(a.AccountID) AS InactiveAccounts
FROM Branches b
JOIN Accounts a ON b.BranchID = a.BranchID
WHERE a.Balance = 0
GROUP BY b.BranchID;

-- Monthly Deposit and Withdrawal Totals
SELECT YEAR(TransactionDate) AS Year, MONTH(TransactionDate) AS Month,
       SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount ELSE 0 END) AS MonthlyDeposits,
       SUM(CASE WHEN TransactionType = 'Withdrawal' THEN Amount ELSE 0 END) AS MonthlyWithdrawals
FROM Transactions
GROUP BY Year, Month
ORDER BY Year DESC, Month DESC;

-- Customers with Credit Card Balances Near Their Credit Limit
SELECT c.CustomerID, c.FirstName, c.LastName, cc.CardID, cc.Balance, cc.CreditLimit
FROM Customers c
JOIN CreditCards cc ON c.CustomerID = cc.CustomerID
WHERE cc.Balance >= cc.CreditLimit * 0.9;

-- Total Number of Actions Logged for Each User
SELECT ua.UserID, ua.Username, COUNT(al.LogID) AS TotalActions
FROM UserAuth ua
JOIN AuditLogs al ON ua.UserID = al.UserID
GROUP BY ua.UserID
ORDER BY TotalActions DESC;

-- Accounts with No Credit Card Linked
SELECT a.AccountID, a.AccountNumber, a.AccountType
FROM Accounts a
LEFT JOIN CreditCards cc ON a.AccountID = cc.AccountID
WHERE cc.CardID IS NULL;

-- Daily Transaction Summary for a Specific Account
SELECT DATE(TransactionDate) AS TransactionDate, 
       SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount ELSE 0 END) AS DailyDeposits,
       SUM(CASE WHEN TransactionType = 'Withdrawal' THEN Amount ELSE 0 END) AS DailyWithdrawals
FROM Transactions
WHERE AccountID = AccountID
GROUP BY DATE(TransactionDate)
ORDER BY TransactionDate DESC;

-- Find High-Risk Accounts Based on Unusual Activity
SELECT AccountID, COUNT(TransactionID) AS WithdrawalCount
FROM Transactions
WHERE TransactionType = 'Withdrawal'
GROUP BY AccountID
HAVING WithdrawalCount > 10;

-- List All Users with Multi-Factor Authentication (MFA) Enabled
SELECT ua.UserID, ua.Username, c.FirstName, c.LastName
FROM UserAuth ua
JOIN Customers c ON ua.CustomerID = c.CustomerID
WHERE ua.MFAEnabled = TRUE;

-- Show All Transactions for a Customer’s Joint Accounts Only
SELECT t.TransactionID, t.TransactionType, t.Amount, t.TransactionDate, t.Remarks
FROM Transactions t
JOIN AccountHolders ah1 ON t.AccountID = ah1.AccountID
JOIN AccountHolders ah2 ON t.AccountID = ah2.AccountID AND ah1.CustomerID <> ah2.CustomerID
WHERE ah1.CustomerID = CustomerID
ORDER BY t.TransactionDate DESC;

-- Top 5 Most Active Branches by Transaction Volume
SELECT b.BranchID, b.BranchName, COUNT(t.TransactionID) AS TransactionCount
FROM Branches b
JOIN Accounts a ON b.BranchID = a.BranchID
JOIN Transactions t ON a.AccountID = t.AccountID
GROUP BY b.BranchID
ORDER BY TransactionCount DESC
LIMIT 5;

-- Average Balance Per Account Type
SELECT AccountType, AVG(Balance) AS AverageBalance
FROM Accounts
GROUP BY AccountType;

-- Monthly New Account Openings
SELECT YEAR(CreatedAt) AS Year, MONTH(CreatedAt) AS Month, COUNT(AccountID) AS NewAccounts
FROM Accounts
GROUP BY Year, Month
ORDER BY Year DESC, Month DESC;




