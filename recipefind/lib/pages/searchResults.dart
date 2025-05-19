import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipefind/main.dart';
import 'package:recipefind/pages/profilePage.dart';
import 'package:recipefind/pages/searchByName.dart';

//is the search results for the bar at the top of the home page. It doesn't have a way to create a good default message when no results are found, but it doesn't brick
class SearchResultsPage extends StatelessWidget {
  final List<Meal> meals;

  const SearchResultsPage({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Results',
          style: TextStyle(color: Color(0xFFEEEEFF)),
        ),
        backgroundColor: const Color(0xFF004643),
        iconTheme: const IconThemeData(color: Color(0xFFEEEEFF)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Provider.of<RecentlyViewedProvider>(context, listen: false).addMeal(meal);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealProfilePage(meal: meal),
                    ),
                  );
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        meal.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 120,
                            height: 120,
                            child: Icon(Icons.broken_image),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              meal.category!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              meal.area!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF004643),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}