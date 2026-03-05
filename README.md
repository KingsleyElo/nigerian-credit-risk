
# Nigerian Digital Lending — Credit Risk Modeling

## Project Overview

This project simulates a **Nigerian digital lending platform** building a **machine learning credit risk model** to predict borrower default.

Digital lenders must decide **within seconds** whether a borrower should receive a loan. Poor decisions increase **non-performing loans (NPLs)** and threaten the sustainability of lending businesses.

The goal of this project is to build a **probability of default (PD) model** that can help lenders:

* Assess borrower creditworthiness
* Predict likelihood of loan default
* Support **risk-based pricing**
* Reduce **loan losses**
* Automate lending decisions

Although the dataset originates from **Lending Club (U.S.)**, the project is structured to simulate the **decision pipeline used by Nigerian fintech lenders**.

---

# Business Problem

A digital lending company must answer a key question:

**"Will this borrower repay the loan?"**

This project frames the problem as a **binary classification task**:

| Target | Meaning           |
| ------ | ----------------- |
| **0**  | Loan fully repaid |
| **1**  | Loan defaulted    |

The model outputs a **probability of default (PD)** that can be integrated into a lending system to guide loan approvals.

---

# Dataset

The dataset comes from **Lending Club historical loan data**.

Original dataset:

* ~890,000 loans
* 145 variables
* Multiple borrower and credit features

For this project:

* A **100,000 observation random sample** was created
* Only **finalized loans** were used for modeling
* Target variable engineered as **default_flag**

---

# Key Feature Categories

### Loan Characteristics

* `loan_amnt`
* `term`
* `int_rate`
* `installment`
* `purpose`
* `grade`
* `sub_grade`

These describe **loan structure and pricing**.

---

### Borrower Demographics

* `emp_length`
* `home_ownership`
* `annual_inc`
* `verification_status`
* `addr_state`

These capture **borrower financial stability**.

---

### Credit Behavior Metrics

* `dti`
* `revol_bal`
* `revol_util`
* `delinq_2yrs`
* `inq_last_6mths`
* `total_acc`
* `pub_rec_bankruptcies`

These represent **borrower credit history and repayment behavior**.

---

# Project Workflow

The project follows a **real-world credit risk modeling pipeline**.

### 1 Data Cleaning (Python)

* Load raw Lending Club data
* Select relevant features
* Remove leakage variables
* Engineer binary target variable

Notebook:
`notebooks/01_data_cleaning.ipynb`

---

### 2 Exploratory Data Analysis (Python)

Focused EDA to understand:

* default patterns
* feature distributions
* predictive variables

Notebook:

`notebooks/02_eda.ipynb`

---

### 3 Feature Engineering (SQL)

SQL is used to create **credit risk features similar to those used by fintech lenders**, such as:

* credit utilization buckets
* income-to-loan ratio
* high debt-to-income flags
* delinquency indicators

This step simulates **data warehouse feature engineering used in production systems**.

---

### 4 Machine Learning Pipeline (Python)

Using **scikit-learn pipelines** to ensure proper modeling workflow:

* train/test split
* missing value imputation
* categorical encoding
* model training

Algorithms tested:

* Logistic Regression
* Random Forest
* Gradient Boosting

---

### 5 Model Evaluation

Models evaluated using credit risk metrics:

* ROC-AUC
* Precision
* Recall
* Confusion Matrix

Focus is placed on **detecting high-risk borrowers**.

---

# Technologies Used

* **Python**
* **Pandas**
* **NumPy**
* **Scikit-learn**
* **SQL (PostgreSQL)**
* **Jupyter Notebook**

---

# Key Skills Demonstrated

This project demonstrates:

* Credit risk modeling
* Data cleaning and preprocessing
* Feature engineering
* Machine learning pipelines
* Handling imbalanced datasets
* Financial risk analytics

---

# Author

**Kingsley Eloebhose**

This project is part of my journey toward building **production-ready machine learning systems for fintech and financial risk modeling**.

---

# License

This project is for **educational and portfolio purposes only**.
