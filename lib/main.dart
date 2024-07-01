// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black), 
        ),
      ),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String currentQuote = "Loading your inspiring quote...";
  List<String> favoriteQuotes = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _getNewQuote();
  }

  final List<String> quotes = [
    "The best way to predict the future is to create it.",
    "Life is 10% what happens to us and 90% how we react to it.",
    "The only limit to our realization of tomorrow is our doubts of today.",
    "The purpose of our lives is to be happy.",
    "Life is what happens when you're busy making other plans.",
    "Don't watch the clock; do what it does. Keep going.",
    "You are never too old to set another goal or to dream a new dream.",
    "If you can dream it, you can do it.",
    "The harder you work for something, the greater you’ll feel when you achieve it."
  ];

  void _getNewQuote() {
    setState(() {
      int newIndex;
      do {
        newIndex = Random().nextInt(quotes.length);
      } while (newIndex == currentIndex);

      currentIndex = newIndex;
      currentQuote = quotes[currentIndex];
    });
  }

  void _addToFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!favoriteQuotes.contains(currentQuote)) {
        favoriteQuotes.add(currentQuote);
        prefs.setStringList('favorites', favoriteQuotes);
      }
    });
  }

  void _shareQuote() {
    Share.share(currentQuote);
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes = prefs.getStringList('favorites') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote of the Day'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.deepPurple.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      currentQuote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _getNewQuote,
                      icon: Icon(Icons.autorenew),
                      label: Text('New Quote'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addToFavorites,
                      icon: Icon(Icons.favorite),
                      label: Text('Add to Favorites'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, 
                        foregroundColor: Colors.white, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _shareQuote,
                      icon: Icon(Icons.share),
                      label: Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(favoriteQuotes: favoriteQuotes),
                      ),
                    );
                  },
                  child: Text('View Favorites'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;

  FavoritesScreen({required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: favoriteQuotes.isNotEmpty
          ? ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        favoriteQuotes[index],
                        style: TextStyle(fontSize: 18.0, color: Colors.black87),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "No favorite quotes yet.",
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            ),
    );
  }
}
