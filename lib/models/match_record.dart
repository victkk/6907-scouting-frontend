import 'dart:convert';
import 'action.dart';
import 'action_constants.dart';

/// 锦标赛级别枚举
enum TournamentLevel {
  none('None'),
  practice('Practice'),
  qualification('Qualification'),
  playoff('Playoff');

  const TournamentLevel(this.value);
  final String value;

  static TournamentLevel fromString(String value) {
    return TournamentLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => TournamentLevel.none,
    );
  }
}

/// 比赛记录类
class MatchRecord {
  int season;
  String eventCode;
  TournamentLevel tournamentLevel;
  int matchNumber;
  int teamNo;
  String autoStartPosition;
  List<ScoutingAction> actions;
  bool isMirrorMode;

  MatchRecord({
    this.season = 2025,
    required this.eventCode,
    this.tournamentLevel = TournamentLevel.none,
    required this.matchNumber,
    required this.teamNo,
    required this.autoStartPosition,
    required this.actions,
    this.isMirrorMode = false,
  });

  void _sortActions() {
    actions.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// 从JSON创建记录
  factory MatchRecord.fromJson(Map<String, dynamic> json) {
    var actionsList = <ScoutingAction>[];
    if (json['action'] != null) {
      json['action'].forEach((v) {
        actionsList.add(ScoutingAction.fromJson(v));
      });
    }

    return MatchRecord(
      season: json['season'] ?? 2025,
      eventCode: json['eventCode'] ?? '',
      tournamentLevel:
          TournamentLevel.fromString(json['tournamentLevel'] ?? 'None'),
      matchNumber: json['matchNumber'] ?? 0,
      teamNo: json['teamNo'] ?? 0,
      autoStartPosition: json['autoStartPosition'] ?? '',
      actions: actionsList,
      isMirrorMode: json['isMirrorMode'] ?? false,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'eventCode': eventCode,
      'tournamentLevel': tournamentLevel.value,
      'matchNumber': matchNumber,
      'teamNo': teamNo,
      'autoStartPosition': autoStartPosition,
      'action': actions.map((action) => action.toJson()).toList(),
      'isMirrorMode': isMirrorMode,
      'exportTimestamp': DateTime.now().toIso8601String(),
      'exportTimestampUtc': DateTime.now().toUtc().millisecondsSinceEpoch,
    };
  }

  /// 序列化为字符串
  String serialize() => jsonEncode(toJson());

  /// 从字符串反序列化
  static MatchRecord deserialize(String jsonString) =>
      MatchRecord.fromJson(jsonDecode(jsonString));

  /// 创建空记录
  static MatchRecord empty() => MatchRecord(
        season: 2025,
        eventCode: '',
        tournamentLevel: TournamentLevel.none,
        matchNumber: 0,
        teamNo: 0,
        autoStartPosition: '',
        actions: [],
        isMirrorMode: false,
      );

  /// 添加动作
  void addAction(ScoutingAction action) {
    actions.add(action);
    _sortActions(); // 添加后排序
  }

  void defendedLastCoralOrAlgae() {
    for (int i = actions.length - 1; i >= 0; i--) {
      final action = actions[i];
      if (action.type == ActionTypes.scoreCoral ||
          action.type == ActionTypes.scoreAlgae) {
        actions[i] = action.copyWith(defended: true);
        return;
      }
    }
  }

  /// 将最近的珊瑚或藻类得分动作标记为失败
  void failLastCoralOrAlgae() {
    // 从后向前遍历动作列表，寻找最近的得分动作
    for (int i = actions.length - 1; i >= 0; i--) {
      final action = actions[i];
      // 检查是否为珊瑚或藻类得分动作
      if (action.type == ActionTypes.scoreCoral ||
          action.type == ActionTypes.scoreAlgae) {
        // 创建新动作副本，将success设为false
        actions[i] = action.copyWith(success: false);
        return; // 找到并修改后立即返回
      }
    }
    // 如果没有找到相关得分动作，不做任何操作
  }

  void starLastAction() {
    // 从后向前遍历动作列表，寻找最近的动作
    final action = actions[actions.length - 1];
    actions[actions.length - 1] = action.copyWith(starred: true);
    return;
  }

  /// 删除动作
  void removeAction(int index) {
    if (index >= 0 && index < actions.length) {
      actions.removeAt(index);
      // 删除不会改变排序顺序，所以这里不需要重排
    }
  }

  /// 更新动作
  void updateAction(int index, ScoutingAction action) {
    if (index >= 0 && index < actions.length) {
      actions[index] = action;
      _sortActions(); // 更新后重新排序
    }
  }

  /// 复制记录并更新部分字段
  MatchRecord copyWith({
    int? season,
    String? eventCode,
    TournamentLevel? tournamentLevel,
    int? matchNumber,
    int? teamNo,
    String? autoStartPosition,
    List<ScoutingAction>? actions,
    bool? isMirrorMode,
  }) {
    return MatchRecord(
      season: season ?? this.season,
      eventCode: eventCode ?? this.eventCode,
      tournamentLevel: tournamentLevel ?? this.tournamentLevel,
      matchNumber: matchNumber ?? this.matchNumber,
      teamNo: teamNo ?? this.teamNo,
      autoStartPosition: autoStartPosition ?? this.autoStartPosition,
      actions: actions ?? List.from(this.actions),
      isMirrorMode: isMirrorMode ?? this.isMirrorMode,
    );
  }
}
