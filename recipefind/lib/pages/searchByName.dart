
import 'package:flutter/material.dart';
import 'package:recipefind/main.dart';
import 'package:recipefind/pages/ingredientsBar.dart';
import 'package:recipefind/pages/searchResults.dart';
import 'package:recipefind/pages/categoriesBar.dart';

//handles the search bar at the top of the home page. also is where the category bar and ingredient bar are called to be displayed
class SearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Future<List<Meal>> Function(String) searchMeals;

  const SearchWidget({
    super.key, 
    required this.searchController, 
    required this.searchMeals
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Recipes by Name',
                    labelStyle: TextStyle(color: Color(0xff6B2737)),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                color: const Color(0xFF5C4742),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () async {
                    final meals = await searchMeals(searchController.text);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsPage(meals: meals),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Category Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B2737),
              ),
            ),
          ),
        ),

        // Category Gallery
        const CategoryGallery(),

        const IngredientsBar(),
        
        // Remaining space
        const Spacer(),

        
      ],
    );
  }
}