import 'dart:convert';

import 'package:weather_app/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static const apiKey = 'ee0d63b609f0aae332a94dba7bf87304';

  Future<WeatherData> getWeatherData(String city) async {
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final main = data['main'];
      final weather = data['weather'][0];
      final wind = data['wind'];
      final humidity = main['humidity'];

      return WeatherData(
        cityName: city,
        temperature: main['temp'].round().toString(),
        condition: weather['main'],
        windSpeed: wind['speed'].toString(),
        humidity: '$humidity%',
      );
    } else {
      throw Exception('Failed to fetch weather data. Please try again.');
    }
  }
}