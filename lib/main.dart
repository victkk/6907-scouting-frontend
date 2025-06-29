import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/scout_state_provider.dart';
import 'screens/scout/scout_screen.dart';
import 'widgets/initial_setup_dialog.dart';

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: MaterialApp(
        title: '6907 Scout',
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
        home: const AppWrapper(),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _showInitialDialog = true;

  @override
  void initState() {
    super.initState();

    // 在构建完成后显示对话框
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showInitialDialog) {
        _showSetupDialog();
      }
    });
  }

  void _showSetupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const InitialSetupDialog(),
    ).then((_) {
      // 对话框关闭后，更新状态以显示主界面
      setState(() {
        _showInitialDialog = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showInitialDialog) {
      // 显示一个简单的加载界面，直到对话框出现
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 对话框完成后显示主界面
    return const LandscapeScreen();
  }
}
