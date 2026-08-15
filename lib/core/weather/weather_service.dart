import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = "YOUR_API_KEY";

  static Future<String> getWeather(double lat, double lon) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    final weather = data['weather'][0]['main'];

    return weather; // Clear, Rain, Clouds, Thunderstorm
  }
}