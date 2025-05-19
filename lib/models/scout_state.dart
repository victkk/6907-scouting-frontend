import 'dart:async'; // 导入 Timer 相关功能
import 'package:horus/models/action.dart';
import 'package:horus/models/action_constants.dart';
import 'dart:html' as html; // 导入 html 包用于 Web 平台
import 'match_record.dart';

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

  // 添加一个标志，用于记录是否已经添加了第一个动作
  bool _firstActionAdded = false;
  // 添加一个计时器
  Timer? _saveTimer;

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

  void changeMode() {
    isDefensing = !isDefensing;
  }

  void selectFace(int face) {
    faceSelected = face;
  }

  void unselectFace() {
    faceSelected = -1;
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

  // 添加按钮记录
  void addRecord(String buttonId) {
    switch (buttonId) {
      case 'Start':
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
        matchRecord.addAction(
            ScoutingAction.scoreCoral(CoralScoreTypes.l1, faceSelected, true));
        hasCoral = false;
        unselectFace();
        break;
      case 'L2':
        assert(hasCoral == true, "!score when no coral");
        assert(getFaceSelected() > -1, "face not selected");
        matchRecord.addAction(
            ScoutingAction.scoreCoral(CoralScoreTypes.l1, faceSelected, true));
        unselectFace();
        hasCoral = false;
        break;
      case 'L3':
        assert(hasCoral == true, "!score when no coral");
        assert(getFaceSelected() > -1, "face not selected");
        matchRecord.addAction(
            ScoutingAction.scoreCoral(CoralScoreTypes.l1, faceSelected, true));
        unselectFace();
        hasCoral = false;
        break;
      case 'L4':
        assert(hasCoral == true, "!score when no coral");
        assert(getFaceSelected() > -1, "face not selected");
        matchRecord.addAction(
            ScoutingAction.scoreCoral(CoralScoreTypes.l1, faceSelected, true));
        hasCoral = false;
        unselectFace();
        break;
      case 'Reef Algae':
        hasAlgae = true;
        matchRecord
            .addAction(ScoutingAction.intakeAlgae(AlgaeIntakeTypes.reef));
        break;
      case "Ground Algae":
        hasAlgae = true;
        matchRecord
            .addAction(ScoutingAction.intakeAlgae(AlgaeIntakeTypes.ground));
        break;
      case "Ground Coral":
        hasCoral = true;
        matchRecord
            .addAction(ScoutingAction.intakeCoral(CoralIntakeTypes.ground));
        break;
      case "Load Station Far":
        hasCoral = true;
        matchRecord.addAction(
            ScoutingAction.intakeCoral(CoralIntakeTypes.loadStationA));
        break;
      case "Load Station Near":
        hasCoral = true;
        matchRecord.addAction(
            ScoutingAction.intakeCoral(CoralIntakeTypes.loadStationB));
        break;
      case "Net":
        assert(hasAlgae == true, "!score when no algae");
        hasAlgae = false;
        matchRecord
            .addAction(ScoutingAction.scoreAlgae(AlgaeScoreTypes.net, true));
        break;
      case "Processor":
        assert(hasAlgae == true, "!score when no algae");
        hasAlgae = false;
        matchRecord.addAction(
            ScoutingAction.scoreAlgae(AlgaeScoreTypes.processor, true));
        break;
      case "Go Barge":
        matchRecord.addAction(ScoutingAction.goBarge());
        goBarge = !goBarge;
        break;
      case "Climb Up":
        matchRecord.addAction(ScoutingAction.climbUp());
        break;
      case "Defense":
        matchRecord.addAction(ScoutingAction.defense());
        break;
      case "Foul":
        matchRecord.addAction(ScoutingAction.foul());
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

  int? _timerStartTimestamp;

  // 获取剩余时间的方法
  int getRemainingTime() {
    if (_timerStartTimestamp == null || !_firstActionAdded) {
      return 0;
    }

    // 计算已经过去了多少秒
    final elapsedSeconds =
        (DateTime.now().millisecondsSinceEpoch - _timerStartTimestamp!) ~/ 1000;

    // 计算剩余秒数
    final remainingSeconds = 150 - elapsedSeconds;

    // 确保不返回负数
    return remainingSeconds > 0 ? remainingSeconds : 0;
  }

  // 修改_checkFirstAction方法
  void _checkFirstAction() {
    if (!_firstActionAdded) {
      _firstActionAdded = true;

      // 记录计时器开始的时间戳
      _timerStartTimestamp = DateTime.now().millisecondsSinceEpoch;

      // 取消之前的计时器（如果有）
      _saveTimer?.cancel();

      // 创建新的计时器来触发保存
      _saveTimer = Timer(Duration(seconds: 150), () {
        saveMatchRecordToLocal();
      });
    }
  }

  // 在对象销毁时取消计时器
  void dispose() {
    _saveTimer?.cancel();
  }
}
