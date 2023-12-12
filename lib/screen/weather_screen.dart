import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Services/api_service.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/screen/favourite_screen.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/widget/fade_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _cityName = '';
  String _temperature = '';
  String _condition = '';
  String _windSpeed = '';
  String _humidity = '';
  final List<String> _favoriteLocations = [];
  bool _isFavorite = false;
  bool _isLoading = false;
  String _errorMessage = '';
  final WeatherApiService _weatherApiService = WeatherApiService();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData('Delhi');
  }

  Future<void> _fetchWeatherData(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    // Data from api
    try {
      WeatherData weatherData = await _weatherApiService.getWeatherData(city);

      setState(() {
        _cityName = weatherData.cityName;
        _temperature = weatherData.temperature;
        _condition = weatherData.condition;
        _windSpeed = weatherData.windSpeed;
        _humidity = weatherData.humidity;
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      _errorMessage = 'An unexpected error occurred. Please try again.';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // add favorites city names
  void _addToFavorites(String city) {
  setState(() {
    _isFavorite = !_isFavorite;
    if (_isFavorite) {
      _favoriteLocations.add(city);
    } else {
      _favoriteLocations.remove(city);
    }
  });

  // Pass the temperature to FavoritesScreen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FavoritesScreen(
        favoriteLocations: _favoriteLocations,
        temperature: _temperature,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dun,
      appBar: AppBar(
        backgroundColor: dun,
        title: _cityName.isNotEmpty
            ? Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _cityName,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : const Text(
                'Weather App',
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteLocations: _favoriteLocations, temperature: '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  labelStyle: const TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _fetchWeatherData(_cityController.text);
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: roseWood,
                    ))
                  : FadeInWidget(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: _isFavorite ? Colors.red : null,
                                    ),
                                    onPressed: () {
                                      _addToFavorites(_cityName);
                                    },
                                  ),
                                ],
                              ),
                              _errorMessage.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _errorMessage,
                                        style: const TextStyle(
                                          color: chreey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Text(
                                _cityName,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: chreey),
                              ),
                              const SizedBox(height: 8.0),
                              // lottie images for clouds and sunnny weather
                              Lottie.asset(
                                _getWeatherImagePath(),
                                height: 190,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '$_temperature°C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              // row section for windspeed , winds and conditon
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoWidget(
                                    icon: Icons.speed,
                                    value: '$_windSpeed m/s',
                                  ),
                                  _buildInfoWidget(
                                    icon: Icons.cloud,
                                    value: _condition,
                                  ),
                                  _buildInfoWidget(
                                    icon: Icons.water,
                                    value: _humidity,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  // row section for windspeed , winds and conditon
  Widget _buildInfoWidget({required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
          color: chreey,
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // get weather image path
  String _getWeatherImagePath() {
  if (_condition.toLowerCase().contains('cloud')) {
    return 'assets/cloud.json';
  } else if (_condition.toLowerCase().contains('rain')) {
    return 'assets/rainy.json';
  } else {
    return 'assets/sunny.json';
  }
}
  }

