import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class HomePage extends StatefulWidget {
  final Function(WeatherModel) onWeatherFound;
  final Function(WeatherModel) onFavorite;
  final bool Function(WeatherModel) isFavorite;

  const HomePage({
    super.key,
    required this.onWeatherFound,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController =
      TextEditingController();

  final WeatherService _weatherService = WeatherService();

  WeatherModel? weather;

  bool isLoading = false;
  String? errorMessage;

  // ==========================================
  // OB-HAVONI QIDIRISH
  // ==========================================

  Future<void> searchWeather() async {
    final city = _searchController.text.trim();

    if (city.isEmpty) {
      setState(() {
        errorMessage = 'Shahar nomini kiriting';
        weather = null;
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _weatherService.getWeather(city);

      if (!mounted) return;

      setState(() {
        weather = result;
        isLoading = false;
      });

      widget.onWeatherFound(result);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        weather = null;
        isLoading = false;
        errorMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ==========================================
  // FAVORITE
  // ==========================================

  void toggleFavorite() {
    if (weather == null) return;

    widget.onFavorite(weather!);

    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final currentWeather = weather;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF6BA8E8),
              Color(0xFFF4F8FF),
            ],
            stops: [
              0.0,
              0.48,
              1.0,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ======================================
              // CONTENT
              // ======================================

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    16,
                    18,
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ==================================
                      // HEADER
                      // ==================================

                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.cloud,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ob-havo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Dunyo ob-havosi, bir ilovada',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Theme button
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.20),
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.wb_sunny_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // ==================================
                      // SEARCH
                      // ==================================

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white54,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                textInputAction:
                                    TextInputAction.search,
                                onSubmitted: (_) =>
                                    searchWeather(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration:
                                    const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  hintText:
                                      'Shahar nomini kiriting',
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(
                                    vertical: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap:
                                isLoading ? null : searchWeather,
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.12),
                                    blurRadius: 12,
                                    offset:
                                        const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 23,
                                        height: 23,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color:
                                              Color(0xFF3985DE),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.search,
                                        color:
                                            Color(0xFF3985DE),
                                        size: 27,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // ==================================
                      // ERROR
                      // ==================================

                      if (errorMessage != null)
                        _ErrorCard(
                          message: errorMessage!,
                        ),

                      // ==================================
                      // EMPTY STATE
                      // ==================================

                      if (currentWeather == null &&
                          errorMessage == null &&
                          !isLoading)
                        const _EmptyWeather(),

                      // ==================================
                      // WEATHER CARD
                      // ==================================

                      if (currentWeather != null)
                        _WeatherCard(
                          weather: currentWeather,
                          isFavorite:
                              widget.isFavorite(currentWeather),
                          onFavorite: toggleFavorite,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// WEATHER CARD
// ======================================================

class _WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const _WeatherCard({
    required this.weather,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withOpacity(0.20),
        border: Border.all(
          color: Colors.white.withOpacity(0.40),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // ==========================================
          // CITY + FAVORITE
          // ==========================================

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.30),
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                        errorBuilder: (_, __, ___) {
                          return const Icon(
                            Icons.cloud,
                            color: Colors.white,
                            size: 32,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather.cityName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            "O'zbekiston",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Favorite button
              GestureDetector(
                onTap: onFavorite,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.redAccent,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ==========================================
          // TEMPERATURE
          // ==========================================

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 58,
                fontWeight: FontWeight.w700,
                letterSpacing: -2,
              ),
            ),
          ),

          const SizedBox(height: 3),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _capitalize(weather.description),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Bugun kun davomida ob-havo shu holatda bo'ladi.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 22),

          // ==========================================
          // DETAILS
          // ==========================================

          Row(
            children: [
              Expanded(
                child: _WeatherDetail(
                  icon: Icons.thermostat,
                  title: 'His qilinadi',
                  value:
                      '${weather.feelsLike.round()}°C',
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _WeatherDetail(
                  icon: Icons.water_drop,
                  title: 'Namlik',
                  value: '${weather.humidity}%',
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _WeatherDetail(
                  icon: Icons.air,
                  title: 'Shamol',
                  value:
                      '${weather.windSpeed.toStringAsFixed(1)} m/s',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() + text.substring(1);
  }
}

// ======================================================
// WEATHER DETAIL
// ======================================================

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// EMPTY WEATHER
// ======================================================

class _EmptyWeather extends StatelessWidget {
  const _EmptyWeather();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 55,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.cloud_outlined,
            color: Colors.white,
            size: 75,
          ),

          SizedBox(height: 15),

          Text(
            'Shahar qidiring',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Shahar nomini yuqoridagi qidiruvga yozing',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// ERROR CARD
// ======================================================

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.redAccent.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 28,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}