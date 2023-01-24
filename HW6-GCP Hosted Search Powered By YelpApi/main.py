# Importing flask module in the project is mandatory
# An object of Flask class is our WSGI application.

import requests, json
from flask import Flask, jsonify, request

app = Flask(__name__,static_url_path="",static_folder="front")
#home directory hosting 'home.html file
@app.route('/')

def index():
   return app.send_static_file('home.html')

#endpoint for search

# for ipinfo use
@app.route('/search&latitude=<latitude>&longitude=<longitude>&radius=<radius>&term=<term>&categories=<categories>')
# ‘/’ URL is bound with hello_world() function.
def query_records(latitude,longitude,radius,term,categories):
    #json_parameters = json.stringify(parameters);

 #&<latitude>&<longitude>&<radius>&<term>&<categories>

    # Define API Key, Search Type, and header ( authorization key )
    API_KEY = 'o6ULqSmNfzy_kkBnDBVulE1MhcXYx3VinJGYtIhrxq4z-7rhcy-7x9fBw_cL8Zw9V4XM8pPLuFv3-xvrNlskeXQYBo1FxbmrYM-LXfSGOXGiFXYDzjF-sneBWBwhY3Yx'
    URL = 'https://api.yelp.com/v3/businesses/search'
    HEADERS = {'Authorization': 'bearer %s' % API_KEY}

    # Define the Parameters of the search
    
    PARAMETERS = {'latitude': latitude,'longitude': longitude, 'term': term, 'radius': radius, 'categories': categories}

    # PARAMETERS = '&'.join([k if v is None else f"{k}={v}" for k, v in PARAMETERS.items()])

    # Make a Request to the API, and return results
    response = requests.get(url=URL,
                            params=PARAMETERS,
                            headers=HEADERS)
    # print(response.url)


    # Convert response to a JSON String
    business_data = json.dumps(response.json(), indent=3)

    return business_data


# for location input use

@app.route('/search_loc&<location>&<radius>&<term>&<categories>')
# ‘/’ URL is bound with hello_world() function.
def query_records_loc(location,radius,term,categories):
    #json_parameters = json.stringify(parameters);


    # Define API Key, Search Type, and header ( authorization key )
    API_KEY = 'o6ULqSmNfzy_kkBnDBVulE1MhcXYx3VinJGYtIhrxq4z-7rhcy-7x9fBw_cL8Zw9V4XM8pPLuFv3-xvrNlskeXQYBo1FxbmrYM-LXfSGOXGiFXYDzjF-sneBWBwhY3Yx'
    URL = 'https://api.yelp.com/v3/businesses/search'
    HEADERS = {'Authorization': 'bearer %s' % API_KEY}

    # Define the Parameters of the search
    
    PARAMETERS = {'location': location, 'term': term, 'radius': radius, 'categories': categories}

    PARAMETERS = '&'.join([k if v is None else f"{k}={v}" for k, v in PARAMETERS.items()])

    # Make a Request to the API, and return results
    response = requests.get(url=URL,
                            params=PARAMETERS,
                            headers=HEADERS)

    # Convert response to a JSON String
    business_data = json.dumps(response.json(), indent=3)

    return business_data



@app.route('/detail_search/<id>')
def details(id):
    API_KEY = 'o6ULqSmNfzy_kkBnDBVulE1MhcXYx3VinJGYtIhrxq4z-7rhcy-7x9fBw_cL8Zw9V4XM8pPLuFv3-xvrNlskeXQYBo1FxbmrYM-LXfSGOXGiFXYDzjF-sneBWBwhY3Yx'
    URL = 'https://api.yelp.com/v3/businesses/'+id
    HEADERS = {'Authorization': 'bearer %s' % API_KEY}
  # Define the Parameters of the search
    

    # Make a Request to the API, and return results
    response = requests.get(url=URL,
                            headers=HEADERS)

    # Convert response to a JSON String
    business_data = json.dumps(response.json(), indent=3)

    return business_data




# main driver function
if __name__ == '__main__':
    # run() method of Flask class runs the application
    # on the local development server.
    app.run(host='127.0.0.1', port=8080, debug=True)
