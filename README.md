# Nigerian Digital Lending — Credit Risk Modeling

> End-to-end ML pipeline predicting loan default probability,
> simulating the credit risk infrastructure of Nigerian fintech lenders.

---

## Overview

Digital lenders must decide **within seconds** whether to approve a loan.
Poor decisions increase **non-performing loans (NPLs)** and threaten
business sustainability.

This project builds a **Probability of Default (PD) model** that helps lenders:
- Assess borrower creditworthiness
- Predict likelihood of loan default
- Support risk-based pricing
- Automate lending decisions

Although the dataset originates from **Lending Club (U.S.)**, the pipeline
is structured to simulate the **feature engineering and modeling workflow
used by Nigerian fintech lenders** — with features mapped to local data
sources (Mono, Okra, CRC bureau) and CBN regulatory thresholds applied.

---

## Results

| Model | Baseline AUC | Tuned AUC |
|---|---|---|
| Logistic Regression | 0.7166 | 0.7171 |
| Random Forest | 0.7052 | 0.7142 |
| XGBoost v1 | 0.6949 | 0.7005 |
| **XGBoost v2** | — | **0.7223** |

**Champion model: XGBoost**
Best parameters: `learning_rate=0.05`, `max_depth=3`,
`min_child_weight=10`, `n_estimators=500`, `subsample=0.8`

---

## Project Structure
```
nigerian-credit-risk/
├── data/
│   ├── raw/                        # Original loan sample
│   ├── processed/                  # Cleaned dataset
│   └── features/                   # SQL-engineered feature set
├── notebooks/                      # End-to-end pipeline notebooks
├── sql/                            # PostgreSQL feature engineering
├── models/                         # Saved champion model
└── app/                            # Flask prediction API + web interface
```

---

## Pipeline

### 1. Data Cleaning
- Loaded raw Lending Club data (100,000 loan sample)
- Removed leakage variables including `grade` and `sub_grade`
- Engineered binary `default_flag` target variable

### 2. Exploratory Data Analysis
- Analyzed default patterns across borrower segments
- Examined feature distributions and correlations
- Identified key predictive variables

### 3. Feature Engineering (PostgreSQL)
Features engineered in SQL to simulate a **Nigerian fintech feature store**:

| Category | Features |
|---|---|
| Affordability | `income_to_loan_ratio`, `payment_coverage_ratio`, `overall_leverage_ratio`, `cbn_dti_compliant`, `high_dti_flag` |
| Credit Utilization | `revol_util_bucket` |
| Delinquency & Risk | `has_delinquency_2yrs`, `has_pub_rec`, `has_bankruptcy`, `has_current_delinq`, `risk_flag_count` |
| Inquiry Behavior | `high_inquiry_flag`, `recent_inquiry_flag`, `inquiry_rate` |
| Credit Maturity | `credit_age_bucket`, `credit_breadth`, `thin_file_flag` |
| Income Segmentation | `income_segment`, `income_verified_flag` |
| Revolving Health | `revol_utilization_ratio`, `avg_credit_limit_per_account`, `pct_maxed_cards` |

**Nigerian context mapping:**

| Feature | Nigerian Equivalent |
|---|---|
| `annual_inc` | Payroll APIs (Mono, Okra) |
| `revol_util` | CRC / FirstCentral bureau |
| `dti` | Bank statement analysis |
| `verification_status` | IPPIS / payroll verification |
| `inq_last_6mths` | Bureau inquiry count |
| `cbn_dti_compliant` | CBN 33% debt service threshold |

### 4. Modelling
- scikit-learn pipelines with median imputation, standard scaling, one-hot encoding
- Class imbalance handled via `class_weight='balanced'` and `scale_pos_weight`
- Hyperparameter tuning via `GridSearchCV` with 5-fold cross validation
- XGBoost required deeper tuning (learning_rate, min_child_weight, subsample)
  to reach performance ceiling

### 5. Model Evaluation
- ROC-AUC, KS Statistic, Confusion Matrix at multiple thresholds
- Feature importance analysis
- Business impact framing for fintech risk teams

---

## Technologies

| Layer | Tools |
|---|---|
| Language | Python 3.14.0 |
| Data Engineering | PostgreSQL, SQLAlchemy, Pandas |
| Machine Learning | scikit-learn, XGBoost |
| Environment | Pipenv, python-dotenv |
| Deployment | Flask, Gunicorn, Docker |
| Version Control | Git, GitHub |

---

## Setup
```bash
# Clone the repo
git clone https://github.com/KingsleyElo/nigerian-credit-risk.git
cd nigerian-credit-risk

# Install dependencies
pipenv install

# Configure environment
cp .env.example .env
# Edit .env with your PostgreSQL credentials

# PostgreSQL setup
# 1. Install PostgreSQL: https://www.postgresql.org/download/
# 2. Create a database and load the cleaned dataset
# 3. Update .env with your host, port, database name, user and password
# Notebook 03 connects to PostgreSQL to run feature engineering SQL
# and save the output to data/features/loan_features.csv

# Run notebooks in order
# 01 → 02 → 03 → 04 → 05
```

---

## Author

**Kingsley Eloebhose** — Lagos, Nigeria

Building production-ready ML systems for Nigerian fintech and financial
risk modeling.

- LinkedIn: [kingsley-eloebhose](https://www.linkedin.com/in/kingsley-eloebhose-77ab41379)
- GitHub: [@KingsleyElo](https://github.com/KingsleyElo)

---

## License

For educational and portfolio purposes only.
