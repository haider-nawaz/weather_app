// weather_service.dart
import 'package:dio/dio.dart';

class WeatherService {
  final String apiKey;
  final String baseUrl = 'http://api.weatherapi.com/v1/forecast.json';

  WeatherService({required this.apiKey});

  Future<Map<String, dynamic>> fetchWeather(
      double latitude, double longitude) async {
    final q = '$latitude,$longitude';
    try {
      final response = await Dio().get(
        baseUrl,
        queryParameters: {'q': q, 'key': apiKey, "days": "6"},
      );
      //print(response.data["forecast"]["forecastday"][1]);

      return response.data;
    } catch (error) {
      print('Error fetching weather data in WeatherService: $error');
      rethrow;
    }
  }
}
