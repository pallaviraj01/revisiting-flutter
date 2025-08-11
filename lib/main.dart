import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        debugShowCheckedModeBanner: false,
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
}


class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch(selectedIndex){
      case 0:
        page = GeneratorPage();
        break;
      case 1: 
        page = FavoritesPage();
        break;
      case 2: 
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
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
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    //debugPrint('Selected: $value');
                    setState((){
                      selectedIndex = value;
                    });                
                  },
                
                  //bottom icons
                  trailing: Expanded( 
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Divider(),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          // You can use a separate index or show a dialog/page
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Settings'),
                              content: Text('Settings options go here.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      tooltip: 'Settings',
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('About'),
                            content: Text('This is a simple Namer app built with Flutter.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      tooltip: 'About',
                    ),
                  ],   
                ),
              ),
            ),
          ),      
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
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


class BigCard extends StatefulWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  State<BigCard> createState() => _BigCardState();
}

class _BigCardState extends State<BigCard> {
  bool showCopyButton = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return InkWell(
      onTap: () {
        setState(() {
          showCopyButton = true;
        });
      },
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.pair.asLowerCase,
                style: style,
                semanticsLabel: widget.pair.asPascalCase,
              ),
              if (showCopyButton) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white),
                  tooltip: 'Copy',
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.pair.asPascalCase),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copied "${widget.pair.asPascalCase}" to clipboard!',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      showCopyButton = false;
                    });
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    if(appState.favorites.isEmpty){
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
          '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}



//color actually animated : Implicit animation feature of flutter