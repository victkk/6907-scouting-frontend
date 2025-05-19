import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/scout_state_provider.dart';
import 'screens/scout/scout_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 强制横屏模式
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: MaterialApp(
        title: 'Control Panel App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.blueGrey[900],
          brightness: Brightness.dark,
          // 蓝色暗色系
          primaryColor: Colors.blue[800],
          // accentColor: Colors.blue[600],
          // textTheme: TextTheme(
          //   bodyText1: TextStyle(color: Colors.white),
          //   bodyText2: TextStyle(color: Colors.white70),
          // ),
          // elevatedButtonTheme: ElevatedButtonThemeData(
          //   style: ElevatedButton.styleFrom(
          //     primary: Colors.blue[800],
          //   ),
          // ),
        ),
        home: LandscapeScreen(),
      ),
    );
  }
}
