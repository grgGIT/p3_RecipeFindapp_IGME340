import 'package:flutter/material.dart';

class DocumentationPage extends StatelessWidget {
  const DocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Roboto',
          bodyColor: Colors.black87,
          displayColor: Colors.black,
        ),
      ),
    child: Scaffold(
      appBar: AppBar(
        title: const Text(' Documentation'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'IGME 340 Project 3 Documentation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Geoff Gracia | SavorSearch Application',
              style: TextStyle(fontSize: 16,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Proposal',
              content:
                  'I am intending to create a mobile application that allows users to search for and discover recipes based on their interest or available components that they could use to make a meal. The application should provide a visual representation of the recipe, ingredients, and cooking instructions. The application should also allow users to revisit the recipes they recently viewed',
            ),
            _buildSection(
              title: 'Process',
              content:
                  'I had originally planned on creating an arcade emulator where you could select between playing classic games and having those run. I was working on it early into my development process and realized it was likely going to take more work than I would have time and ability to allocate to. So I pivoted to just create a simple recipe search app. I created the logo, color pallette, and assets aside from any fonts which are public web fonts from DaFonts.com, were made by myself in Canva and Coolors.',
            ),
            _buildSection(
              title: 'Potential Errors',
              content:
                  'Could crash if searching in the "by name" search bar and the API does not return any results. The Youtube reroute button could crash the program because of formatting issues from the API',
            ),
            _buildSection(
              title: 'Sources',
              content: 'List any references, libraries, tutorials, or other materials you used to help with this project.',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- The visual site for the API (endpoints view) https://www.themealdb.com/'),
                  Text('- The visual site for the API (API developer view) https://www.themealdb.com/api.php'),
                ],
              ),
            ),
            _buildSection(
              title: 'Special Instructions',
              content:
                  'Explore as you see fit or follow the tutorial',
              backgroundColor: const Color(0xFFFFEB3B),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildSection(
              title: 'Requirements',
              content: 'Explain how your project meets the specified requirements. You can list the requirements and describe how you addressed each one.',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- Functional: I think it is useful for someone wanting cooking recipes and getting good information about how to prepare them. It should have at least one fully integrated endpoint which is searching by name of a dish. I use sharedPref, I have a custom splash screen, I have more than 1 page. There could be crashes that I mentioned earlier that I struggled with creating catches for',),
                  Text('- Design and Interaction: I tried to apply some more vibrant colors and patterns in the app. I created a logo and a video for the splash screen but it was not cooperating. My assets are viewable in the assets/images folder and my color palette was #EEEEFF, #B88B4A, #004643, #5C4742, #6B2737'),
                  Text('- Media: I believe everything should work appropriately and I wanted to make use of an API for that reason. I used two fonts from DaFont.com'),
                  Text('- Code Conventions: I have a ton of inheriting and separated code that is architectured with main.dart serving specific purpose as the parent classes and things that are built on top of and central to the project. Did not use var. I tried to keep D.R.Y. in mind when creating everything, and always want to make sure I can streamline my code as much as possible as I learn, I believe it could be up to standard. I used intuitive page and function naming. My code could technically always be more commented and better understood but I tried to keep that in mind specifically, more than previous projects.No print statements.'),
                ],
              ),
            ),
            _buildSection(
              title: 'Video Demonstration',
              content:
                  'https://people.rit.edu/grg7576/project3_PhoneApp_IGME340/demovideo.mp4',
              backgroundColor: const Color.fromARGB(255, 141, 241, 234),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                '© 2024 Geoff Gracia. All Rights Reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    )
    );
    
  }
   Widget _buildSection({
    required String title,
    required String content,
    Widget? child,
    Color backgroundColor = Colors.white,
    TextStyle? textStyle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: textStyle ?? const TextStyle(fontSize: 16),
          ),
          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }
}