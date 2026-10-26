import 'package:flutter/material.dart';

import '../models/weather_model.dart';

class FavoritesPage extends StatelessWidget {
  final List<WeatherModel> favorites;
  final Function(WeatherModel) onRemove;
  final Function(WeatherModel) onOpen;

  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.onRemove,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),

      body: SafeArea(
        child: Column(
          children: [
            // ==================================
            // HEADER
            // ==================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3985DE),
                    Color(0xFF6BA8E8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sevimlilar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Saqlangan shaharlaringiz',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================
            // CONTENT
            // ==================================

            Expanded(
              child: favorites.isEmpty
                  ? const _EmptyFavorites()
                  : ListView.builder(
                      physics:
                          const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(18),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final weather =
                            favorites[index];

                        return _FavoriteCard(
                          weather: weather,
                          onOpen: () {
                            onOpen(weather);
                          },
                          onRemove: () {
                            onRemove(weather);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// FAVORITE CARD
// ======================================================

class _FavoriteCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.weather,
    required this.onOpen,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            // ==================================
            // WEATHER ICON
            // ==================================

            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Image.network(
                'https://openweathermap.org/img/wn/${weather.icon}@2x.png',

                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.cloud,
                    color: Color(0xFF3985DE),
                    size: 34,
                  );
                },
              ),
            ),

            const SizedBox(width: 14),

            // ==================================
            // CITY
            // ==================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    weather.cityName,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF182335),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _capitalize(
                      weather.description,
                    ),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: Color(0xFF7B8798),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 14,
                        color: Color(0xFF3985DE),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '${weather.humidity}%',

                        style: const TextStyle(
                          color: Color(0xFF7B8798),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================
            // TEMPERATURE + DELETE
            // ==================================

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,

              children: [
                Text(
                  '${weather.temperature.round()}°',

                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF182335),
                  ),
                ),

                const SizedBox(height: 3),

                GestureDetector(
                  onTap: onRemove,

                  child: Container(
                    width: 34,
                    height: 34,

                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),

                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() +
        text.substring(1);
  }
}

// ======================================================
// EMPTY FAVORITES
// ======================================================

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.favorite_border,
                color: Color(0xFF3985DE),
                size: 55,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Sevimlilar hozircha bo‘sh',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF182335),
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              'Bosh sahifadan shahar qidiring va ❤️ tugmasini bosib saqlang.',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Color(0xFF7B8798),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}