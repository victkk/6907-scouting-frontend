import 'package:flutter/foundation.dart';
import '../models/scout_state.dart';
import '../models/action.dart';

import 'dart:async'; // 导入 Timer 相关功能

class AppStateProvider with ChangeNotifier {
  final AppState _appState = AppState();
  // 构造函数中启动更新计时器
  AppStateProvider() {
    _startUpdateTimer();
  }
  Timer? _updateTimer;
  // 启动一个计时器来定期更新UI，显示最新的倒计时
  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // 在自动阶段或手动阶段时更新UI，或者在游戏阶段变化时更新
      final currentPhase = getCurrentPhase();
      if (currentPhase == GamePhase.autonomous ||
          currentPhase == GamePhase.teleop ||
          currentPhase == GamePhase.waitingTeleop) {
        notifyListeners();
      }
    });
  }

  // 暴露获取剩余时间的方法
  int getRemainingTime() {
    return _appState.getRemainingTime();
  }

  // 暴露获取游戏阶段的方法
  GamePhase getCurrentPhase() {
    return _appState.getCurrentPhase();
  }

  // 开始手动阶段
  void startTeleopPhase() {
    _appState.startTeleopPhase();
    notifyListeners();
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

  // 添加专门的face选择方法，优化性能
  void selectFace(int face) {
    if (_appState.faceSelected != face) {
      _appState.selectFace(face);
      notifyListeners();
    }
  }

  void deleteAction(int index) {
    _appState.deleteAction(index);
    notifyListeners();
  }

  void addAction(ScoutingAction action) {
    _appState.addAction(action);
    notifyListeners();
  }

  void updateAction(int index, ScoutingAction action) {
    _appState.updateAction(index, action);
    notifyListeners();
  }

  void updateMatchInfo({
    required String event,
    required String matchCode,
    required int teamNo,
  }) {
    _appState.updateMatchInfo(
      event: event,
      matchCode: matchCode,
      teamNo: teamNo,
    );
    notifyListeners();
  }

  // 提交比赛记录（保存到本地并上传到服务器）
  Future<Map<String, dynamic>> submitMatchRecord({
    String serverUrl = 'http://localhost:5000',
  }) async {
    return await _appState.submitMatchRecord(serverUrl: serverUrl);
  }

  // 仅上传到服务器
  Future<Map<String, dynamic>> uploadMatchRecordToServer({
    String serverUrl = 'http://localhost:5000',
  }) async {
    return await _appState.uploadMatchRecordToServer(serverUrl: serverUrl);
  }

  // 仅保存到本地
  Future<void> saveMatchRecordToLocal() async {
    return await _appState.saveMatchRecordToLocal();
  }
}
