import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipefind/main.dart';
import 'package:recipefind/pages/profilePage.dart';

//creates the entire page after clicking the nav button and process the API call for a random meal then connects to corresponding profile page
class RandomRecipeWidget extends StatelessWidget {
  final Future<Meal?> Function() fetchRandomMeal;

  const RandomRecipeWidget({super.key, required this.fetchRandomMeal});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Feeling Adventurous?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B2737),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF004643), Color(0xFF6B2737)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  final meal = await fetchRandomMeal();
                  if (meal != null && context.mounted) {
                    Provider.of<RecentlyViewedProvider>(context, listen: false)
                        .addMeal(meal);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealProfilePage(meal: meal),
                      ),
                    );
                  }
                },
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Surprise Me!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Get Random Recipe',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Discover new flavors with\none tap!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF5C4742),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}