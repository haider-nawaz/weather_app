// weather_controller.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../Models/weather_model.dart';
import '../Services/location_service.dart';
import '../Services/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService weatherService =
      WeatherService(apiKey: dotenv.env["API_KEY"]!);
  LocationService locationService = LocationService();

  Rx<WeatherModel?> weather = Rx<WeatherModel?>(null);

  final isLoading = false.obs;

  Future<void> fetchWeather(double latitude, double longitude) async {
    print('Fetching weather...');
    try {
      final data = await weatherService.fetchWeather(latitude, longitude);
      final weatherData = WeatherModel.fromJson(data);
      weather.value = weatherData;
    } catch (error) {
      // Handle error, e.g., show an error message to the user
      print(error);
    }
  }

  Future<Map> extractLocationCoordinates() async {
    try {
      Position currentPosition = await locationService.getCurrentLocation();
      print('Current Position: $currentPosition');

      // Extract latitude and longitude
      final latitude = currentPosition.latitude;
      final longitude = currentPosition.longitude;

      // Return latitude and longitude as a Map
      return {'latitude': latitude, 'longitude': longitude};
    } catch (e) {
      print('Error getting current location: $e');
    }
    return {};
  }

  @override
  void onInit() {
    isLoading.value = true;

    extractLocationCoordinates().then((coordinates) async {
      final latitude = coordinates['latitude'];
      final longitude = coordinates['longitude'];
      if (latitude != null && longitude != null) {
        await fetchWeather(latitude, longitude);
      }
      isLoading.value = false;
    });
    super.onInit();
  }
}
