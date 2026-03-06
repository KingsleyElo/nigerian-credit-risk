-- ============================================================
-- Feature Engineering: Nigerian Digital Lending Credit Risk
-- Source table: lending_cleaned
-- Output table: loan_features
-- Features: Affordability(5 features), Utilization(1), Delinquency(5 features), 
--           Inquiry(3 features), Credit Maturity(3 features), Income(2 features), 
--           Revolving Health(3 features)
-- ============================================================

DROP TABLE IF EXISTS loan_features;
CREATE TABLE loan_features AS
SELECT 
    -- CORE TABLE (all original columns)
    l.*,
    
    -- CORE AFFORDABILITY (5 features)
    l.annual_inc / NULLIF(l.loan_amnt, 0) AS income_to_loan_ratio,
    l.annual_inc / NULLIF((l.installment * 12), 0) AS payment_coverage_ratio,
    l.total_bal_ex_mort / NULLIF(l.tot_hi_cred_lim, 0) AS overall_leverage_ratio,
    CASE WHEN l.dti <= 33 THEN 1 ELSE 0 END AS cbn_dti_compliant,
    CASE WHEN l.dti > 35 THEN 1 ELSE 0 END AS high_dti_flag,
    
    -- CREDIT UTILIZATION (1 feature)
    CASE 
        WHEN l.revol_util < 30 THEN 'Low'
        WHEN l.revol_util BETWEEN 30 AND 60 THEN 'Medium'
        WHEN l.revol_util > 60 THEN 'High'
        ELSE 'Unknown'
    END AS revol_util_bucket,
    
    -- DELINQUENCY & RISK FLAGS
    CASE WHEN l.delinq_2yrs > 0 THEN 1 ELSE 0 END AS has_delinquency_2yrs,
    CASE WHEN l.pub_rec > 0 THEN 1 ELSE 0 END AS has_pub_rec,
    CASE WHEN l.pub_rec_bankruptcies > 0 THEN 1 ELSE 0 END AS has_bankruptcy,
    CASE WHEN l.acc_now_delinq > 0 THEN 1 ELSE 0 END AS has_current_delinq,
    (CASE WHEN l.delinq_2yrs > 0 THEN 1 ELSE 0 END +
     CASE WHEN l.pub_rec > 0 THEN 1 ELSE 0 END +
     CASE WHEN l.pub_rec_bankruptcies > 0 THEN 1 ELSE 0 END +
     CASE WHEN l.acc_now_delinq > 0 THEN 1 ELSE 0 END) AS risk_flag_count,
    
    -- INQUIRY BEHAVIOR (3 features)
    CASE WHEN l.inq_last_6mths >= 3 THEN 1 ELSE 0 END AS high_inquiry_flag,
    -- NULL means no recent inquiry, treated as 0 (not flagged)
    CASE WHEN l.mths_since_recent_inq <= 3 THEN 1 ELSE 0 END AS recent_inquiry_flag,
    l.inq_last_6mths / NULLIF(l.credit_age_years, 0) AS inquiry_rate,
    
    -- CREDIT MATURITY & BREADTH (3 features)
    CASE
        WHEN l.credit_age_years < 20 THEN 'Developing'
        WHEN l.credit_age_years BETWEEN 20 AND 30 THEN 'Established'
        ELSE 'Seasoned'
    END AS credit_age_bucket,
    l.total_acc / NULLIF(l.credit_age_years, 0) AS credit_breadth,
    CASE WHEN l.total_acc < 5 AND l.credit_age_years < 3 THEN 1 ELSE 0 END AS thin_file_flag,
    
    -- INCOME SEGMENTATION (2 features)
    CASE
        WHEN l.annual_inc >= 100000 AND l.verification_status = 'Verified' THEN 'Formal_High'
        WHEN l.annual_inc >= 40000 AND l.verification_status = 'Verified' THEN 'Formal_Mid'
        WHEN l.verification_status = 'Source Verified' THEN 'Formal_Low'
        WHEN l.verification_status = 'Not Verified' THEN 'Informal'
        ELSE 'Formal_Low'
    END AS income_segment,
    CASE WHEN l.verification_status = 'Verified' THEN 1 ELSE 0 END AS income_verified_flag,
    
    -- REVOLVING HEALTH (3 features)
    l.revol_bal / NULLIF(l.total_rev_hi_lim, 0) AS revol_utilization_ratio,
    l.total_rev_hi_lim / NULLIF(l.total_acc, 0) AS avg_credit_limit_per_account,
    l.percent_bc_gt_75 / 100.0 AS pct_maxed_cards

FROM lending_cleaned l;

-- Drop leakage-risk columns
ALTER TABLE loan_features DROP COLUMN grade;
ALTER TABLE loan_features DROP COLUMN sub_grade;
