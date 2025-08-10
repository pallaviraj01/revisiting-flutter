import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent) //Color.fromRGBD(0,0,125,1) four parameters
        ),
        home: MyHomePage(),
      ),
    );
  }
}
//changenotifier is kinda like "Oh! I have changed. Anyone who is watching me or listening to me, should take a note
//or maybe update yourself." --It's really cool.

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  
  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Column(
        children: [
          Text('A random cool ideas: '),
          BigCard(pair: pair),
          ElevatedButton(
            onPressed: () {
              //debugPrint('button pressed!');
              appState.getNext();
            }, 
            child: Text('Next'),
          ),
      ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  }); 

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(pair.asLowerCase, style: style,),
      ),
    );
  }
}

//color actually animated : Implicit animation feature of flutter