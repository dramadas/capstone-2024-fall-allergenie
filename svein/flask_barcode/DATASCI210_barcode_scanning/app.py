from flask import Flask, request, render_template, jsonify
from flask_cors import CORS
from PIL import Image
from pyzbar.pyzbar import decode
import os
import pandas as pd
from tabulate import tabulate

app = Flask(__name__)
CORS(app) ## ADDED THIS> REMOVE IF MAKES WORSE LOL
app.config['UPLOAD_FOLDER'] = 'uploads'

# Folder for image uploads
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Load OpenFoodFacts local data
# df_us = pd.read_excel('DATASCI210_barcode_scanning/openfoodfacts_us.xlsx') ## USE THIS FOR LOCAL TESTING
df_us = pd.read_excel('/home/ec2-user/openfoodfacts_us.xlsx')

df_us['code'] = df_us['code'].apply(lambda x: '{:.0f}'.format(x))

def is_safe_to_consume(matched_products, selected_allergens):
    unsafe_allergens = []
    if selected_allergens == ['']:
        return "No Allergens Selected. Product is Safe to Consume."
    
    for allergen in selected_allergens:
        # Check if the allergen is present in the matched products
        if matched_products['allergens'].str.contains(allergen, na=False).any():
            unsafe_allergens.append(allergen)

    if unsafe_allergens:
        return f"Not Safe to Consume (contains: {', '.join(unsafe_allergens)})"
    else:
        return "Safe to Consume"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return 'No file part', 400

    file = request.files['file']
    if file.filename == '':
        return 'No file selected!', 400

    if file:
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(file_path)

        # Decoding barcode
        image = Image.open(file_path)
        decoded_barcode = decode(image)

        if decoded_barcode:
            decoded_barcode_value = decoded_barcode[0].data.decode('utf-8')
            if decoded_barcode_value.startswith('0') and len(decoded_barcode_value) == 13:
                decoded_barcode_value = decoded_barcode_value[1:]

            # Database matching
            matched_products = df_us[df_us['code'].astype(str) == decoded_barcode_value]

            if len(matched_products.index) > 0:
                print("Matched Product Information:")
                output = matched_products[['url', 'product_name', 'ingredients_text']]
                print(tabulate(output, headers='keys', tablefmt='psql'))

                # Get user inputs for allergen selection
                selected_allergens = request.form.getlist('allergens')
                # selected_allergens = request.form.getlist('allergens[]')
                print ("Selected Allergens",selected_allergens)
                print("Type",type(selected_allergens))
                print (selected_allergens[0])
                selected_allergens = selected_allergens[0].split(',')
                print(selected_allergens)
                # print(f"Selected Allergens: {selected_allergens}")

                # Check if users can consume the product
                safety_status = is_safe_to_consume(matched_products, selected_allergens)
                print(safety_status)

                # return  ('result.html', output=output.to_dict(orient='records'), safety_status=safety_status)
                return jsonify ({'output': output.to_dict(orient='records'), 'safety_status':safety_status}),200
            else:
                print("No matching product found.")
                return jsonify ({'output': [], 'safety_status':"No matching product found."}),200
                # return render_template('result.html', output=[], safety_status="No matching product found.")
        else:
            print("No barcodes detected in the image.")
            return jsonify ({'output': [], 'safety_status':"No matching product found."}),200
            return render_template('result.html', output=[], safety_status="No barcodes detected in the image.")


# if __name__ == '__main__':
#     app.run(debug=True)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)