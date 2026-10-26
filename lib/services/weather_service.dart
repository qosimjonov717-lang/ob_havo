import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  // ==========================================
  // OPENWEATHER API KEY
  // ==========================================
  static const String apiKey = 'e8ace7732ef7deb539f7d84ddc3e0fbd';

  // ==========================================
  // SHAHAR BO'YICHA OB-HAVONI OLISH
  // ==========================================
  Future<WeatherModel> getWeather(String city) async {
    final Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?q=${Uri.encodeComponent(city)}'
      '&appid=$apiKey'
      '&units=metric'
      '&lang=uz',
    );

    try {
      final response = await http.get(url);

      // Muvaffaqiyatli
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return WeatherModel.fromJson(data);
      }

      // API key xato
      if (response.statusCode == 401) {
        throw Exception('API kaliti noto‘g‘ri yoki hali aktivlashmagan');
      }

      // Shahar topilmadi
      if (response.statusCode == 404) {
        throw Exception('Shahar topilmadi. Shahar nomini tekshiring');
      }

      // Juda ko‘p so‘rov
      if (response.statusCode == 429) {
        throw Exception('Juda ko‘p so‘rov yuborildi. Biroz kuting');
      }

      // Boshqa xatolar
      throw Exception('Server xatosi: ${response.statusCode}');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Internet bilan bog‘lanishda xatolik');
    }
  }
}
