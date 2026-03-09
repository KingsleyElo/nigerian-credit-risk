from flask import Flask, request, jsonify, render_template
from predictor import predict

app = Flask("Credit Risk")

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict_route():
    try:
        if request.is_json:
            data = request.get_json()
        else:
            data = request.form.to_dict()
            # convert numeric strings to float for form submissions
            numeric_fields = [
                'loan_amnt', 'int_rate', 'annual_inc', 'dti',
                'installment', 'emp_length', 'revol_util', 'delinq_2yrs',
                'inq_last_6mths', 'pub_rec_bankruptcies'
            ]
            for field in numeric_fields:
                if field in data:
                    data[field] = float(data[field])

        result = predict(data)
        return jsonify(result)

    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True)