import 'package:flutter/material.dart';

import 'models/weather_model.dart';
import 'pages/favorites_page.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int selectedIndex = 0;

  final List<WeatherModel> favorites = [];
  final List<WeatherModel> history = [];

  // ==========================================
  // TARIXGA QO'SHISH
  // ==========================================

  void addToHistory(WeatherModel weather) {
    setState(() {
      history.removeWhere(
        (item) =>
            item.cityName.toLowerCase() ==
            weather.cityName.toLowerCase(),
      );

      history.insert(0, weather);
    });
  }

  // ==========================================
  // FAVORITE QO'SHISH / O'CHIRISH
  // ==========================================

  void toggleFavorite(WeatherModel weather) {
    setState(() {
      final exists = favorites.any(
        (item) =>
            item.cityName.toLowerCase() ==
            weather.cityName.toLowerCase(),
      );

      if (exists) {
        favorites.removeWhere(
          (item) =>
              item.cityName.toLowerCase() ==
              weather.cityName.toLowerCase(),
        );
      } else {
        favorites.add(weather);
      }
    });
  }

  // ==========================================
  // FAVORITE EKANINI TEKSHIRISH
  // ==========================================

  bool isFavorite(WeatherModel weather) {
    return favorites.any(
      (item) =>
          item.cityName.toLowerCase() ==
          weather.cityName.toLowerCase(),
    );
  }

  // ==========================================
  // FAVORITE O'CHIRISH
  // ==========================================

  void removeFavorite(WeatherModel weather) {
    setState(() {
      favorites.removeWhere(
        (item) =>
            item.cityName.toLowerCase() ==
            weather.cityName.toLowerCase(),
      );
    });
  }

  // ==========================================
  // HISTORY O'CHIRISH
  // ==========================================

  void removeHistory(WeatherModel weather) {
    setState(() {
      history.removeWhere(
        (item) =>
            item.cityName.toLowerCase() ==
            weather.cityName.toLowerCase(),
      );
    });
  }

  // ==========================================
  // PAGE O'ZGARTIRISH
  // ==========================================

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onWeatherFound: addToHistory,
        onFavorite: toggleFavorite,
        isFavorite: isFavorite,
      ),

      FavoritesPage(
        favorites: favorites,
        onRemove: removeFavorite,
        onOpen: (weather) {
          // Hozircha shahar ma'lumotini ko'rsatish uchun
          // home pagega o'tamiz.
          setState(() {
            selectedIndex = 0;
          });
        },
      ),

      HistoryPage(
        history: history,
        onRemove: removeHistory,
        onOpen: (weather) {
          setState(() {
            selectedIndex = 0;
          });
        },
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ob-havo',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3985DE),
        ),

        scaffoldBackgroundColor:
            const Color(0xFFF4F8FF),
      ),

      home: Scaffold(
        body: pages[selectedIndex],

        // ======================================
        // BOTTOM NAVIGATION
        // ======================================

        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x15000000),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: NavigationBar(
            height: 72,

            backgroundColor: Colors.white,

            elevation: 0,

            selectedIndex: selectedIndex,

            onDestinationSelected: changePage,

            indicatorColor:
                const Color(0xFFE4EEFF),

            labelTextStyle:
                WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(
                  WidgetState.selected,
                )) {
                  return const TextStyle(
                    color: Color(0xFF3985DE),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                }

                return const TextStyle(
                  color: Color(0xFF7A8495),
                  fontSize: 12,
                );
              },
            ),

            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  color: Color(0xFF7A8495),
                ),
                selectedIcon: Icon(
                  Icons.home,
                  color: Color(0xFF3985DE),
                ),
                label: 'Bosh sahifa',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.favorite_border,
                  color: Color(0xFF7A8495),
                ),
                selectedIcon: Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                ),
                label: 'Sevimlilar',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.history,
                  color: Color(0xFF7A8495),
                ),
                selectedIcon: Icon(
                  Icons.history,
                  color: Color(0xFF3985DE),
                ),
                label: 'Tarix',
              ),
            ],
          ),
        ),
      ),
    );
  }
}