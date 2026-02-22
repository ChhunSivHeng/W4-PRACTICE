import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Home()),
    ),
  );
}

final ColorService colorService = ColorService();   // declear outside to make sure this can use colorService everywhere in your app

enum CardType { red, blue }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class ColorService extends ChangeNotifier{
  int redTapCount = 0;
  int blueTapCount = 0;
    void incrementRedTapCount() {
      redTapCount++;
      notifyListeners();
    }
    void incrementBlueTapCount() {
      blueTapCount++;
      notifyListeners();
    }
  }

class _HomeState extends State<Home> {
  int _currentIndex = 0;
//   int redTapCount = 0;
//   int blueTapCount = 0;

  // void _incrementRedTapCount() {
  //   setState(() {
  //     redTapCount++;
  //   });
  // }

  // void _incrementBlueTapCount() {
  //   setState(() {
  //     blueTapCount++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _currentIndex == 0
              ? ColorTapsScreen()
              : StatisticsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

class ColorTapsScreen extends StatelessWidget {  // in here, removed all constructor and parameter then use Listenablebuilder to listen colrService
  const ColorTapsScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Taps')),
      body: ListenableBuilder(  // automatically rebuild the ui, so no need to refreh apge
        listenable: colorService,

          builder: (context, child) { 
            return Column(
              children: [
                ColorTap(type: CardType.red, tapCount: colorService.redTapCount, onTap: colorService.incrementRedTapCount),
                ColorTap(
                  type: CardType.blue,
                  tapCount: colorService.blueTapCount ,     // use globally
                  onTap: colorService.incrementBlueTapCount,  
                ),
              ],
            );
          }
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;
  final int tapCount;
  final VoidCallback onTap;

  const ColorTap({
    super.key,
    required this.type,
    required this.tapCount,
    required this.onTap,
  });

  Color get backgroundColor => type == CardType.red ? Colors.red : Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 100,
        child: Center(
          child: Text(
            'Taps: $tapCount',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {    // this screen as well, to display the statatic of count 


  const StatisticsScreen({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Center(
        child: ListenableBuilder(
          listenable: colorService,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Red Taps: ${colorService.redTapCount}', style: TextStyle(fontSize: 24)),
                  Text('Blue Taps: ${colorService.blueTapCount}', style: TextStyle(fontSize: 24)),
                ],
              );
            }
          ),
        ),
    );
  }
}
