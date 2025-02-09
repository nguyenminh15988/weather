from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

API_KEY = "apokey"  # Replace with OpenWeatherMap API key
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

@app.route('/weather', methods=['GET'])
def get_weather():
    city = request.args.get('city')
    if not city:
        return jsonify({"error": "City parameter is required"}), 400

    # Fetch weather data from OpenWeatherMap API
    response = requests.get(f"{BASE_URL}?q={city}&appid={API_KEY}&units=metric")
    if response.status_code != 200:
        return jsonify({"error": "Failed to fetch weather data", "details": response.text}), 500

    return jsonify(response.json())

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)