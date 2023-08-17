import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Joke Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: JokePage(),
    );
  }
}

class JokePage extends StatefulWidget {
  @override
  _JokePageState createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  String question = "";
  String answer = "Press the button to get a random dad joke.";

  Future<void> fetchJoke() async {
    final response = await http.get(
      Uri.parse('https://icanhazdadjoke.com/'),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'RandomJokeGeneratorApp (https://github.com/username/repo)',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final joke = jsonResponse['joke'];

      // Check if the joke is in a question-answer format
      final splitJoke = joke.split('? ');
      if (splitJoke.length > 1) {
        setState(() {
          question = "Question: " + splitJoke[0] + "?";
          answer = "Answer: " + splitJoke.sublist(1).join('? ');
        });
      } else {
        setState(() {
          question = "";
          answer = joke;
        });
      }
    } else {
      // Handle error, maybe display a message
      setState(() {
        question = "";
        answer = "Oops! Something went wrong. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Joke Generator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 200), // Set minimum height
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center joke
                  children: [
                    Text(
                      question,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      answer,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchJoke,
                child: Text('Get a Random Joke'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
