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

  var favorites = <WordPair>[];
  
  void toggleFavorite(){
    if(favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  int selectedIndexOnHomePage = 0;
}

// class MyHomePage extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;
//     IconData icon;
//     if(appState.favorites.contains(pair)){
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text('A random cool ideas: '),
//             BigCard(pair: pair),
//             SizedBox(height: 20,), //these are device independent pixels
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     appState.toggleFavorite();
//                   }, 
//                   icon: Icon(icon),
//                   label: Text('Like'),            
//                 ),
//                 SizedBox(width: 10,),
//                 ElevatedButton(
//                   onPressed: () {
//                     //debugPrint('button pressed!');
//                     appState.getNext();
//                   }, 
//                   child: Text('Next'),                  
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home), 
                  label: Text('Home')
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite), 
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.help), 
                  label: Text('Help'),
                ),
              ], 
              selectedIndex: 0,
              onDestinationSelected: (value) {
                //debugPrint('Selected: $value');
                selectedIndex = value;
              },
            ), 
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ), 
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),                         
            ],
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
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: pair.asPascalCase,
          ),
      ),
    );
  }
}

//color actually animated : Implicit animation feature of flutter