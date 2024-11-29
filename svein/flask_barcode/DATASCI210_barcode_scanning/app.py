from flask import Flask, request, render_template, jsonify
from flask_cors import CORS
from PIL import Image
from pyzbar.pyzbar import decode
import os
import cv2
import pandas as pd
from tabulate import tabulate

app = Flask(__name__)
CORS(app) ## ADDED THIS> REMOVE IF MAKES WORSE LOL
app.config['UPLOAD_FOLDER'] = 'uploads'

# Folder for image uploads
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# Load OpenFoodFacts local data
#df_us = pd.read_excel('DATASCI210_barcode_scanning/openfoodfacts_us.xlsx') ## USE THIS FOR LOCAL TESTING
df_us = pd.read_excel('/home/ec2-user/openfoodfacts_us.xlsx')

df_us['code'] = df_us['code'].apply(lambda x: '{:.0f}'.format(x))

allergy_dict= {"milk": ["butter","caseinates", "cheese", "cream", "custard","pudding", "ghee", "hydrolysates", "lactalbumin", "lactoglobulin", "lactoferrin", "lactose","lactulose", "milk", "nisin", "nougat", "recaldent", "casein","whey", "yogurt", "caramel", "chocolate", "lactose", "sausages", "margarine", "simplesse"]
               ,"egg":  ["egg", "albumin","globulin", "livetin", "lysozyme", "mayonnaise", "meringue", "ovalbumin", "ovomucin", "ovomucoid", "ovovitellin", "surimi", "lecithin","macaroni", "marzipan", "marshmallows", "nougat", "pasta", "cake icing", "frosting","eggshells", "soup stocks", "consommés", "bouillons", "coffees"]
               ,"fish": ["fish", "anchovies", "bass", "catfish", "cod", "flounder", "grouper", "haddock", "hake", "halibut", "herring", "mahi","perch", "pike", "pollock", "salmon", "scrod", "sole", "snapper", "swordfish", "tilapia", "trout", "tuna", "snapper", "swordfish","bouillabaisse", "caesar","caponata",  "shellfish", "worcestershire "]
               ,"shellfish": ["shellfish", "abalone", "barnacle", "krill", "clams", "cherrystone", "littleneck", "pismo", "quahog", "crab", "crawfish", "crayfish", "écrevisse","crawdad", "lobster", "langouste", "langoustine", "scampi", "coral", "tomalley", "mollusks", "Mussels", "squid", "calamari", "snail", "escargot","oysters", 
                              "octopus", "scallops", "shrimp", "prawns", "crevette", "bouillabaisse", "cuttlefish", "glucosamine", "surimi"]
                ,'treenut': ["treenut", "almonds", "beechnuts", "butternuts", "cashews", "chestnuts", "coconut", "filberts", "hazelnuts","gingko", "hickory", "lychee", "macadamia", "pecans", "pine", "pignolia", "pistachios","walnuts", "caponata", "gianduja", "marzipan paste", "almond paste", "natural nut extract", "nougat", "artificial nuts",
                             "nut", "cashew", "almond", "hazelnut", "almond","pesto", "praline"]
                ,'peanut': ["peatnut", "nuts", "cereal", "chili",  "crackers", "flavoring", "hydrolyzed", "marzipan", "nougat"]
                ,'wheat': ["wheat", "bran", "bread", "bulgur", "cereal", "couscous", "cracker", "durum", "einkorn", "emmer", "farina","flour", "matzoh",  "pasta", "seitan", "semolina", "spelt", "gluten", "germ", "gluten", "grass", "malt", "sprouted", "starch", "starch","gum", "hydrolyzed", "kamut", "flavoring", "soy", "starch", "surimi"]
                ,'soy':["soy", "hydrolyzed", "miso", "edamame", "natto", "shoyu", "tamari", "tempeh","tvp","tofu", "flavoring", "vitamin-e"]
}

def is_safe_to_consume(matched_products, selected_allergens):
    unsafe_allergens = []
    if selected_allergens == [''] or selected_allergens == []:
        return "No Allergens Selected. Product is Safe to Consume."
    
    for allergen in selected_allergens[0].split(','):
        for allergy in allergy_dict[allergen]:
            # Check if the allergen is present in the matched products
            if matched_products['allergens'].str.contains(allergy, na=False).any():
                unsafe_allergens.append(allergen)
                break

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
##        image = Image.open(file_path)
##        decoded_barcode = decode(image)
        image  = cv2.imread(file_path)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        decoded_barcode = decode(gray)
        print(decoded_barcode[0].data.decode('utf-8'))


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