import 'package:flutter/foundation.dart';
import '../models/scout_state.dart';
import 'dart:async'; // 导入 Timer 相关功能

class AppStateProvider with ChangeNotifier {
  AppState _appState = AppState();
  // 构造函数中启动更新计时器
  AppStateProvider() {
    _startUpdateTimer();
  }
  Timer? _updateTimer;
  // 启动一个计时器来定期更新UI，显示最新的倒计时
  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (getRemainingTime() > 0) {
        notifyListeners();
      }
    });
  }

  // 暴露获取剩余时间的方法
  int getRemainingTime() {
    return _appState.getRemainingTime();
  }
  // 现有方法保持不变...

  @override
  void dispose() {
    _updateTimer?.cancel();
    _appState.dispose();
    super.dispose();
  }

  AppState get appState => _appState;

  void toggleMode() {
    _appState.changeMode();
    notifyListeners();
  }

  void recordButtonPress(String buttonId) {
    _appState.addRecord(buttonId);
    notifyListeners();
  }
}
