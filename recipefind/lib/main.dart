import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipefind/pages/randomRecipeResult.dart';
import 'package:video_player/video_player.dart';
import 'pages/documentPage.dart';
import 'pages/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart' as shared_preferences;
import 'package:url_launcher/url_launcher.dart';
import 'pages/searchByName.dart';
import 'pages/searchResults.dart';
import 'pages/categoriesBar.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecentlyViewedProvider()),
      ],
      child: const RecipeApp(),
    ),
  );
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SavorSearch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff7004643),
        fontFamily: 'everything',
        scaffoldBackgroundColor: const Color(0xff7eeeeff),
        appBarTheme: const AppBarTheme(
          color: Color(0xff7004643),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff7004643)),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//just does all the splash screen magic
class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  
}
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  
  return Scaffold(
    body: Stack(
      children: [
        // Background Image
        Image.asset(
          'assets/images/wallpaper.png',
          width: screenWidth,
          height: screenHeight,
          fit: BoxFit.cover,
        ),
        // Content
        Container(
          width: screenWidth,
          height: screenHeight,
          color: const Color(0xFF004643).withOpacity(0.7), // Semi-transparent overlay
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/SavorSearch.png',
                  width: 400,
                  height: 500,
                ),
                const SizedBox(height: 20),
                const Text(
                  'SavorSearch',
                  style: TextStyle(
                    fontSize: 80, 
                    fontFamily: 'gFont',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

//houses everything that you see as soon as the splash screen goes away
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

//search bar for name for searching recipes. This is also the main thing that is handling the bad search requests by sending and empty json result, which doesn't brick the program
  Future<List<Meal>> searchMeals(String query) async {
    try {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['meals'] == null) {
        // Return empty list if no meals found
        return [];
      }
      return (data['meals'] as List).map((meal) => Meal.fromJson(meal)).toList();
    } else {
      return []; // Return empty list on error
    }
  } catch (e) {
    print('Error searching meals: $e');
    return []; // Return empty list on exception
  }
}

//calling functionality
  Future<Meal?> fetchRandomMeal() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Meal.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

//everything that is featured (largely accounts for the bottom bar nav)
  @override
  Widget build(BuildContext context) {
      return Scaffold(
    appBar: AppBar(
      title: const Text(
        'SavorSearch ~ Recipe Finder',
        style: TextStyle(color: Color(0xff7eeeeff)),
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              SearchWidget(searchController: _searchController, searchMeals: searchMeals),
              RandomRecipeWidget(fetchRandomMeal: fetchRandomMeal),
              const RecentlyViewedWidget(),
              const DocumentationPage(),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
            ],
          ),
        ),
      ],
    ),bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shuffle),
            label: 'Random',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Recently Viewed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Documentation',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6B2737),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}


//establishing the model object
  late final Meal meal;

//this is what acts a a model for all the data it allows in from the json to be used for its recipe profiles
// this is what is retrieved from the API for ANY profile result
class Meal {
  final String name;
  final String imageUrl;
  final String description;
  final String category;
  final String area;
  final String youtube;
  final List<String> ingredients;
  final List<String> measures;

  Meal({required this.name, required this.imageUrl, required this.description, required this.category, required this.area, required this.youtube, required this.ingredients, required this.measures});

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }
    
    return Meal(
      name: json['strMeal'],
      imageUrl: json['strMealThumb'],
      description: json['strInstructions'],
      category: json['strCategory'],
      area: json['strArea'],
      youtube: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }

  
   Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'area': area,
      'youtube': youtube,
      'ingredients': ingredients,
      'measures': measures,
    };
  }
}

// this helps to allow the ingredients to be formatted as a list and handles the images they have along with themselves
Widget buildIngredientList(Meal meal) {
  return Column(
    children: meal.ingredients.asMap().entries.map((entry) {
      int index = entry.key;
      String ingredient = entry.value;
      String measure = meal.measures[index];
      return ListTile(
        leading: Image.network('https://www.themealdb.com/images/ingredients/$ingredient-Small.png'),
        title: Text('$ingredient: $measure'),
      );
    }).toList(),
  );
}

//This stuff is staying here because it didn't like being moved and I understand that it integrates itself perpetually so I wanted to give it its best chances
//The section below pertains to everything regarding shared preferences use and saved recently viewed on one session
class RecentlyViewedProvider with ChangeNotifier {
  List<Meal> _recentlyViewed = [];
  static const String _storageKey = 'recentlyViewedMeals';

  RecentlyViewedProvider() {
    _loadRecentlyViewed();
  }

  List<Meal> get recentlyViewed => List.unmodifiable(_recentlyViewed);

  Future<void> _loadRecentlyViewed() async {
    final prefs = await shared_preferences.SharedPreferences.getInstance();
    final String? storedMeals = prefs.getString(_storageKey);
    if (storedMeals != null) {
      final List<dynamic> decodedMeals = jsonDecode(storedMeals);
      _recentlyViewed = decodedMeals.map((mealJson) => Meal.fromJson(mealJson)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveRecentlyViewed() async {
    final prefs = await shared_preferences.SharedPreferences.getInstance();
    final String encodedMeals = jsonEncode(_recentlyViewed.map((meal) => meal.toJson()).toList());
    await prefs.setString(_storageKey, encodedMeals);
  }

  void addMeal(Meal meal) {
    if (!_recentlyViewed.contains(meal)) {
      _recentlyViewed.insert(0, meal); // Add to the beginning of the list
      if (_recentlyViewed.length > 10) {
        _recentlyViewed.removeLast(); // Keep only the 10 most recent meals
      }
      _saveRecentlyViewed();
      notifyListeners();
    }
  }

  
}

//is what is the actual page for the results of seeing the recently viewed recipes
class RecentlyViewedWidget extends StatelessWidget {
  const RecentlyViewedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentlyViewedProvider>(
      builder: (context, provider, child) {
        final recentlyViewed = provider.recentlyViewed;

        if (recentlyViewed.isEmpty) {
          return const Center(
            child: Text(
              'No recently viewed recipes',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF6B2737),
              ),
            ),
          );
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recently Viewed Recipes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B2737),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: recentlyViewed.length,
                itemBuilder: (context, index) {
                  final meal = recentlyViewed[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealProfilePage(meal: meal),
                        ),
                      );
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
                              meal.imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${meal.category} • ${meal.area}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
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
      },
    );
  }
}