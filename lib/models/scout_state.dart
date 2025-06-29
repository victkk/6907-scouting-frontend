import 'dart:async'; // 导入 Timer 相关功能
import 'package:horus/models/action.dart';
import 'package:horus/models/action_constants.dart';
import 'dart:html' as html; // 导入 html 包用于 Web 平台
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'match_record.dart';

// 添加游戏阶段枚举
enum GamePhase {
  notStarted, // 未开始
  autonomous, // 自动阶段 (15秒)
  waitingTeleop, // 等待手动阶段
  teleop, // 手动阶段 (2分15秒)
  finished // 比赛结束
}

class AppState {
  // 示例状态值，根据实际需求可以增减
  int faceSelected = -1;
  bool isDefensing = false;
  bool hasCoral = true;
  bool hasAlgae = false;
  MatchRecord matchRecord = MatchRecord.empty();
  bool goBarge = false;
  // state for screen display
  bool isStarted = false;
  bool isAutoSelected = false;

  // 添加游戏阶段状态
  GamePhase currentPhase = GamePhase.notStarted;

  // 添加一个标志，用于记录是否已经添加了第一个动作
  bool _firstActionAdded = false;
  // 添加一个计时器
  Timer? _saveTimer;

  // 计时器相关变量
  int? _timerStartTimestamp;
  int? _autonomousEndTimestamp;
  int? _teleopStartTimestamp;

  int getFaceSelected() {
    return faceSelected;
  }

  bool getHasCoral() {
    return hasCoral;
  }

  bool getHasAlgae() {
    return hasAlgae;
  }

  bool getIsDefensing() {
    return isDefensing;
  }

  // 获取当前游戏阶段
  GamePhase getCurrentPhase() {
    return currentPhase;
  }

  // 开始手动阶段
  void startTeleopPhase() {
    if (currentPhase == GamePhase.waitingTeleop) {
      currentPhase = GamePhase.teleop;
      _teleopStartTimestamp = DateTime.now().millisecondsSinceEpoch;

      // 设置手动阶段结束的计时器 (2分15秒 = 135秒)
      _saveTimer?.cancel();
      _saveTimer = Timer(const Duration(seconds: 135), () {
        currentPhase = GamePhase.finished;
        saveMatchRecordToLocal();
      });
    }
  }

  void changeMode() {
    isDefensing = !isDefensing;
  }

  void selectFace(int face) {
    faceSelected = face;
  }

  void unselectFace() {
    faceSelected = -1;
  }

  void deleteAction(int index) {
    matchRecord.removeAction(index);
  }

  void addAction(ScoutingAction action) {
    matchRecord.addAction(action);
  }

  void updateAction(int index, ScoutingAction action) {
    matchRecord.updateAction(index, action);
  }

  void updateMatchInfo({
    required String event,
    required String matchCode,
    required int teamNo,
  }) {
    matchRecord = matchRecord.copyWith(
      event: event,
      matchCode: matchCode,
      teamNo: teamNo,
    );
  }

  // 保存记录到本地文件
  Future<void> saveMatchRecordToLocal() async {
    try {
      // 将比赛记录转换为 JSON 字符串
      final jsonString = matchRecord.serialize();

      // Web 平台 - 创建 Blob 并触发下载
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'match_record_$timestamp.json';

      // 创建 Blob 对象
      final blob = html.Blob([jsonString], 'application/json');

      // 创建下载 URL
      final url = html.Url.createObjectUrlFromBlob(blob);

      // 创建临时链接元素并点击它以触发下载
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();

      // 清理：从 DOM 中移除链接并释放 URL
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      print('Match record prepared for download as $fileName');
    } catch (e) {
      print('Error saving match record: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  // 上传记录到远程服务器
  Future<Map<String, dynamic>> uploadMatchRecordToServer({
    String serverUrl = 'http://localhost:5000', // 默认本地Flask服务器地址
  }) async {
    try {
      // 将比赛记录转换为 JSON
      final jsonData = matchRecord.toJson();

      // 添加上传时间戳
      jsonData['uploadTimestamp'] = DateTime.now().millisecondsSinceEpoch;

      // 发送POST请求到服务器
      final response = await http.post(
        Uri.parse('$serverUrl/api/match-records'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Match record uploaded successfully: ${responseData['message']}');
        return {
          'success': true,
          'message': responseData['message'] ?? '上传成功',
          'data': responseData,
        };
      } else {
        print('Failed to upload match record: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'success': false,
          'message': '上传失败: HTTP ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      print('Error uploading match record: $e');
      return {
        'success': false,
        'message': '网络错误: $e',
        'error': e.toString(),
      };
    }
  }

  // 提交记录（同时保存到本地和上传到服务器）
  Future<Map<String, dynamic>> submitMatchRecord({
    String serverUrl = 'http://localhost:5000',
  }) async {
    try {
      // 1. 保存到本地
      await saveMatchRecordToLocal();

      // 2. 上传到服务器
      final uploadResult =
          await uploadMatchRecordToServer(serverUrl: serverUrl);

      if (uploadResult['success']) {
        return {
          'success': true,
          'message': '记录已成功保存到本地并上传到服务器',
          'localSaved': true,
          'uploaded': true,
          'uploadData': uploadResult['data'],
        };
      } else {
        return {
          'success': false,
          'message': '本地保存成功，但服务器上传失败: ${uploadResult['message']}',
          'localSaved': true,
          'uploaded': false,
          'error': uploadResult['error'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': '提交失败: $e',
        'localSaved': false,
        'uploaded': false,
        'error': e.toString(),
      };
    }
  }

  // 获取当前的相对时间戳
  int getRelativeTimestamp() {
    final now = DateTime.now().millisecondsSinceEpoch;

    if (_timerStartTimestamp == null) {
      return 0; // 比赛未开始
    }

    switch (currentPhase) {
      case GamePhase.notStarted:
        return 0;

      case GamePhase.autonomous:
        // 自动阶段：直接计算相对时间
        return now - _timerStartTimestamp!;

      case GamePhase.waitingTeleop:
        // 等待手动阶段：返回自动阶段结束时的相对时间（15秒）
        return 15000; // 15秒 * 1000毫秒

      case GamePhase.teleop:
        // 手动阶段：自动阶段时间(15秒) + 手动阶段已用时间
        if (_teleopStartTimestamp == null) return 15000;
        final teleopElapsed = now - _teleopStartTimestamp!;
        return 15000 + teleopElapsed;

      case GamePhase.finished:
        // 比赛结束：返回总时间（15秒自动 + 135秒手动）
        return 150000; // (15 + 135) * 1000毫秒
    }
  }

  // 添加按钮记录
  void addRecord(String buttonId) {
    // 获取当前的相对时间戳
    final relativeTimestamp = getRelativeTimestamp();

    switch (buttonId) {
      case 'Start':
        // 添加start动作到matchRecord中
        final startAction = ScoutingAction.start(timestamp: relativeTimestamp);
        matchRecord.addAction(startAction);

        isStarted = true;
        _checkFirstAction();
        break;
      case 'Auto 1':
        isAutoSelected = true;
        matchRecord.autoStartPosition = AutoStartPositions.pos1;
        break;
      case 'Auto 2':
        isAutoSelected = true;
        matchRecord.autoStartPosition = AutoStartPositions.pos2;
        break;
      case 'Auto 3':
        isAutoSelected = true;
        matchRecord.autoStartPosition = AutoStartPositions.pos3;
        break;
      case 'Auto 4':
        isAutoSelected = true;
        matchRecord.autoStartPosition = AutoStartPositions.pos4;
        break;
      case 'Auto 5':
        isAutoSelected = true;
        matchRecord.autoStartPosition = AutoStartPositions.pos5;
        break;
      case 'L1':
        assert(hasCoral == true, "!score when no coral");
        assert(getFaceSelected() > -1, "face not selected");
        matchRecord.addAction(ScoutingAction.scoreCoral(
            CoralScoreTypes.l1, faceSelected, true,
            timestamp: relativeTimestamp));
        hasCoral = false;
        unselectFace();
        break;
      case 'L2':
        assert(hasCoral == true, "!score when no coral");
        assert(getFaceSelected() > -1, "face not selected");
        matchRecord.addAction(ScoutingAction.scoreCoral(
            CoralScoreTypes.l2, faceSelected, true,
            timestamp: relativeTimestamp));
        unselectFace();
        hasCoral = false;
        break;
      case 'L3':
        assert(hasCoral == true, "!score when no coral");
        assert(getFaceSelected() > -1, "face not selected");
        matchRecord.addAction(ScoutingAction.scoreCoral(
            CoralScoreTypes.l3, faceSelected, true,
            timestamp: relativeTimestamp));
        unselectFace();
        hasCoral = false;
        break;
      case 'L4':
        assert(hasCoral == true, "!score when no coral");
        assert(getFaceSelected() > -1, "face not selected");
        matchRecord.addAction(ScoutingAction.scoreCoral(
            CoralScoreTypes.l4, faceSelected, true,
            timestamp: relativeTimestamp));
        hasCoral = false;
        unselectFace();
        break;
      case 'Reef Algae':
        hasAlgae = true;
        matchRecord.addAction(ScoutingAction.intakeAlgae(AlgaeIntakeTypes.reef,
            timestamp: relativeTimestamp));
        break;
      case "Ground Algae":
        hasAlgae = true;
        matchRecord.addAction(ScoutingAction.intakeAlgae(
            AlgaeIntakeTypes.ground,
            timestamp: relativeTimestamp));
        break;
      case "Ground Coral":
        hasCoral = true;
        matchRecord.addAction(ScoutingAction.intakeCoral(
            CoralIntakeTypes.ground,
            timestamp: relativeTimestamp));
        break;
      case "Load Station Far":
        hasCoral = true;
        matchRecord.addAction(ScoutingAction.intakeCoral(
            CoralIntakeTypes.loadStationA,
            timestamp: relativeTimestamp));
        break;
      case "Load Station Near":
        hasCoral = true;
        matchRecord.addAction(ScoutingAction.intakeCoral(
            CoralIntakeTypes.loadStationB,
            timestamp: relativeTimestamp));
        break;
      case "Net":
        assert(hasAlgae == true, "!score when no algae");
        hasAlgae = false;
        matchRecord.addAction(ScoutingAction.scoreAlgae(
            AlgaeScoreTypes.net, true,
            timestamp: relativeTimestamp));
        break;
      case "Processor":
        assert(hasAlgae == true, "!score when no algae");
        hasAlgae = false;
        matchRecord.addAction(ScoutingAction.scoreAlgae(
            AlgaeScoreTypes.processor, true,
            timestamp: relativeTimestamp));
        break;
      case "Go Barge":
        matchRecord
            .addAction(ScoutingAction.goBarge(timestamp: relativeTimestamp));
        goBarge = !goBarge;
        break;
      case "Climb Up":
        matchRecord
            .addAction(ScoutingAction.climbUp(timestamp: relativeTimestamp));
        break;
      case "Defense":
        matchRecord
            .addAction(ScoutingAction.defense(timestamp: relativeTimestamp));
        break;
      case "Foul":
        matchRecord
            .addAction(ScoutingAction.foul(timestamp: relativeTimestamp));
        break;
      case "Fail":
        matchRecord.failLastCoralOrAlgae();
        break;
      case "selectFace1":
        selectFace(1);
        break;
      case "selectFace2":
        selectFace(2);
        break;
      case "selectFace3":
        selectFace(3);
        break;
      case "selectFace4":
        selectFace(4);
        break;
      case "selectFace5":
        selectFace(5);
        break;
      case "selectFace6":
        selectFace(6);
        break;
      default:
        break;
    }
  }

  // 获取剩余时间的方法
  int getRemainingTime() {
    switch (currentPhase) {
      case GamePhase.notStarted:
        return 0;

      case GamePhase.autonomous:
        if (_timerStartTimestamp == null) return 0;
        final elapsedSeconds =
            (DateTime.now().millisecondsSinceEpoch - _timerStartTimestamp!) ~/
                1000;
        final remainingSeconds = 15 - elapsedSeconds;
        return remainingSeconds > 0 ? remainingSeconds : 0;

      case GamePhase.waitingTeleop:
        return 0; // 暂停状态，不显示时间

      case GamePhase.teleop:
        if (_teleopStartTimestamp == null) return 0;
        final elapsedSeconds =
            (DateTime.now().millisecondsSinceEpoch - _teleopStartTimestamp!) ~/
                1000;
        final remainingSeconds = 135 - elapsedSeconds; // 2分15秒 = 135秒
        return remainingSeconds > 0 ? remainingSeconds : 0;

      case GamePhase.finished:
        return 0;
    }
  }

  // 将相对时间戳转换为显示用的时间字符串（MM:SS格式）
  String formatRelativeTimestamp(int relativeTimestamp) {
    final totalSeconds = relativeTimestamp ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // 根据相对时间戳判断所属的比赛阶段
  String getPhaseFromRelativeTimestamp(int relativeTimestamp) {
    if (relativeTimestamp <= 15000) {
      return '自动阶段';
    } else {
      return '手动阶段';
    }
  }

  // 修改_checkFirstAction方法
  void _checkFirstAction() {
    if (!_firstActionAdded) {
      _firstActionAdded = true;
      currentPhase = GamePhase.autonomous;

      // 记录自动阶段开始的时间戳
      _timerStartTimestamp = DateTime.now().millisecondsSinceEpoch;

      // 取消之前的计时器（如果有）
      _saveTimer?.cancel();

      // 创建15秒自动阶段的计时器
      _saveTimer = Timer(const Duration(seconds: 15), () {
        // 自动阶段结束，进入等待手动阶段
        currentPhase = GamePhase.waitingTeleop;
        _autonomousEndTimestamp = DateTime.now().millisecondsSinceEpoch;
      });
    }
  }

  // 在对象销毁时取消计时器
  void dispose() {
    _saveTimer?.cancel();
  }
}
