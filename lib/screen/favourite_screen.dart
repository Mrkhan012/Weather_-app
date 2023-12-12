import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteLocations;
  final String temperature;

  const FavoritesScreen({
    Key? key,
    required this.favoriteLocations,
    required this.temperature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dun,
      appBar: AppBar(
        backgroundColor: dun,
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteLocations.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        favoriteLocations[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        temperature,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Add other information like wind speed, condition, etc. here if needed
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
