import joblib
import pandas as pd
import os

# Load model once when module is imported
model = joblib.load(os.path.join(os.path.dirname(__file__), '..', 'models', 'best_model_xgb.pkl'))

# Default input template
DEFAULT_INPUT = {
     'loan_amnt': 12000.0, 'term': 36.0, 'int_rate': 12.74, 'installment': 374.33, 
     'emp_length': 6.0, 'annual_inc': 65000.0, 'dti': 17.56, 'delinq_2yrs': 0.0, 
     'inq_last_6mths': 0.0, 'open_acc': 11.0, 'pub_rec': 0.0, 'revol_bal': 11115.0, 
     'revol_util': 52.1, 'total_acc': 23.0, 'pub_rec_bankruptcies': 0.0, 'tax_liens': 0.0, 
     'collections_12_mths_ex_med': 0.0, 'acc_now_delinq': 0.0, 'chargeoff_within_12_mths': 0.0, 
     'delinq_amnt': 0.0, 'total_rev_hi_lim': 24000.0, 'bc_util': 63.0, 'percent_bc_gt_75': 42.9, 
     'avg_cur_bal': 7483.5, 'total_bal_ex_mort': 37366.0, 'total_bc_limit': 15000.0, 
     'tot_cur_bal': 80526.5, 'tot_hi_cred_lim': 112336.0, 'mo_sin_old_rev_tl_op': 164.0, 
     'mo_sin_rcnt_rev_tl_op': 8.0, 'mths_since_recent_inq': 5.0, 'credit_age_years': 25.675564681724847, 
     'income_to_loan_ratio': 5.0, 'payment_coverage_ratio': 13.835851458298745, 
     'overall_leverage_ratio': 0.3950470186097659, 'cbn_dti_compliant': 1.0, 
     'high_dti_flag': 0.0, 'has_delinquency_2yrs': 0.0, 'has_pub_rec': 0.0, 
     'has_bankruptcy': 0.0, 'has_current_delinq': 0.0, 'risk_flag_count': 0.0, 
     'high_inquiry_flag': 0.0, 'recent_inquiry_flag': 0.0, 'inquiry_rate': 0.0, 
     'credit_breadth': 0.8777033985581875, 'thin_file_flag': 0.0, 'income_verified_flag': 0.0, 
     'revol_utilization_ratio': 0.5242294520547945, 'avg_credit_limit_per_account': 1089.655172413793, 
     'pct_maxed_cards': 0.429, 'purpose': 'debt_consolidation', 'application_type': 'Individual', 
     'disbursement_method': 'Cash', 'initial_list_status': 'w', 'home_ownership': 'MORTGAGE', 
     'verification_status': 'Source Verified', 'addr_state': 'CA', 'revol_util_bucket': 'Medium', 
     'credit_age_bucket': 'Established', 'income_segment': 'Formal_Low'
}

def predict(input_data: dict) -> dict:
    # Start with defaults and update with user input
    borrower = DEFAULT_INPUT.copy()
    borrower.update(input_data)
    
    # Convert to single-row DataFrame
    input_df = pd.DataFrame([borrower])
    
    # Run through pipeline
    probability = model.predict_proba(input_df)[0][1]
    
    # Decision based on recommended threshold t=0.49
    decision = 'REJECT' if probability >= 0.49 else 'APPROVE'
    
    # Risk level
    if probability < 0.35:
        risk_level = 'Low'
    elif probability < 0.49:
        risk_level = 'Medium'
    else:
        risk_level = 'High'
    
    return {
        'probability': round(float(probability), 4),
        'decision': decision,
        'risk_level': risk_level
    }