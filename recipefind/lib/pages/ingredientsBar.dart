import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:recipefind/main.dart';
import 'package:recipefind/pages/profilePage.dart';


// model for the ingredient cards
class Ingredient {
  final String idIngredient;
  final String strIngredient;
  final String? strDescription;

  Ingredient({
    required this.idIngredient,
    required this.strIngredient,
    this.strDescription,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      idIngredient: json['idIngredient'] ?? '',
      strIngredient: json['strIngredient'] ?? '',
      strDescription: json['strDescription'],
    );
  }
}


class IngredientsBar extends StatefulWidget {
  const IngredientsBar({super.key});

  @override
  State<IngredientsBar> createState() => _IngredientsBarState();
}

//is the API functionality behind the front end page class. It also does the autofill predictive part of the bar since theres like 500 results of ingredients
class _IngredientsBarState extends State<IngredientsBar> {
  List<Ingredient> ingredients = [];
  List<Ingredient> filteredIngredients = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchIngredients();
    _searchController.addListener(_filterIngredients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterIngredients() {
    if (_searchController.text.isEmpty) {
      setState(() {
        filteredIngredients = ingredients;
      });
      return;
    }

    setState(() {
      filteredIngredients = ingredients
          .where((ingredient) => ingredient.strIngredient
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchIngredients() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?i=list'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          ingredients = (data['meals'] as List)
              .map((json) => Ingredient.fromJson(json))
              .toList();
          filteredIngredients = ingredients; // Initialize filtered list
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching ingredients: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search ingredients...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF004643)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF004643), width: 2),
              ),
            ),
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = filteredIngredients[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IngredientMealsPage(
                          ingredient: ingredient.strIngredient,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF004643)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.themealdb.com/images/ingredients/${ingredient.strIngredient}-Small.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            ingredient.strIngredient,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004643),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

//does the front and and heavy lifting of the API communicating between the three endpoints this is sort of nested between. It grabs the ingredient and then its picture and handles the communication to the meals and then the profiles.
class IngredientMealsPage extends StatefulWidget {
  final String ingredient;

  const IngredientMealsPage({super.key, required this.ingredient});

  @override
  State<IngredientMealsPage> createState() => _IngredientMealsPageState();
}

class _IngredientMealsPageState extends State<IngredientMealsPage> {
  List<Map<String, dynamic>> simpleMeals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealsByIngredient();
  }

  Future<void> fetchMealsByIngredient() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?i=${widget.ingredient}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Store the simple meal data instead of trying to create Meal objects
          simpleMeals = List<Map<String, dynamic>>.from(data['meals']);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching meals: $e');
      setState(() => isLoading = false);
    }
  }

  Future<Meal> fetchFullMealDetails(String mealId) async {
  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final meal = Meal.fromJson(data['meals'][0]);
    
    // Add to recently viewed using the Provider
    Provider.of<RecentlyViewedProvider>(context, listen: false).addMeal(meal);
    
    return meal;
  } else {
    throw Exception('Failed to load meal details');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals with ${widget.ingredient}'),
        backgroundColor: const Color(0xFF004643),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: simpleMeals.length,
              itemBuilder: (context, index) {
                final simpleMeal = simpleMeals[index];
                return GestureDetector(
                  onTap: () async {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    
                    try {
                      // Fetch full meal details
                      final fullMeal = await fetchFullMealDetails(simpleMeal['idMeal']);
                      
                      if (context.mounted) {
                        // Remove loading indicator
                        Navigator.pop(context);
                        // Navigate to meal profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealProfilePage(meal: fullMeal),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context); // Remove loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to load meal details')),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            simpleMeal['strMealThumb'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            simpleMeal['strMeal'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

