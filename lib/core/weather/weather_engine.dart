import 'package:flutter/material.dart';
import 'weather_service.dart';

enum SkyMode { morning, sunset, night, rain, thunder, clouds }

class WeatherEngine extends ChangeNotifier {
  SkyMode mode = SkyMode.morning;

  Future<void> updateWeather(double lat, double lon) async {
    final weather = await WeatherService.getWeather(lat, lon);

    switch (weather.toLowerCase()) {
      case "rain":
        mode = SkyMode.rain;
        break;

      case "thunderstorm":
        mode = SkyMode.thunder;
        break;

      case "clouds":
        mode = SkyMode.clouds;
        break;

      default:
        _setByTime();
    }

    notifyListeners();
  }

  void _setByTime() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      mode = SkyMode.morning;
    } else if (hour < 18) {
      mode = SkyMode.sunset;
    } else {
      mode = SkyMode.night;
    }
  }
}