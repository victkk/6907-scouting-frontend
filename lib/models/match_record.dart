import 'dart:convert';
import 'action.dart';
import 'action_constants.dart';

/// 比赛记录类
class MatchRecord {
  String event;
  String matchCode;
  int teamNo;
  String autoStartPosition;
  List<ScoutingAction> actions;

  MatchRecord({
    required this.event,
    required this.matchCode,
    required this.teamNo,
    required this.autoStartPosition,
    required this.actions,
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
      event: json['event'] ?? '',
      matchCode: json['matchCode'] ?? '',
      teamNo: json['teamNo'] ?? 0,
      autoStartPosition: json['autoStartPosition'] ?? '',
      actions: actionsList,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'matchCode': matchCode,
      'teamNo': teamNo,
      'autoStartPosition': autoStartPosition,
      'action': actions.map((action) => action.toJson()).toList(),
    };
  }

  /// 序列化为字符串
  String serialize() => jsonEncode(toJson());

  /// 从字符串反序列化
  static MatchRecord deserialize(String jsonString) =>
      MatchRecord.fromJson(jsonDecode(jsonString));

  /// 创建空记录
  static MatchRecord empty() => MatchRecord(
        event: '',
        matchCode: '',
        teamNo: 0,
        autoStartPosition: '',
        actions: [],
      );

  /// 添加动作
  void addAction(ScoutingAction action) {
    actions.add(action);
    _sortActions(); // 添加后排序
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
    String? event,
    String? matchCode,
    int? teamNo,
    String? autoStartPosition,
    List<ScoutingAction>? actions,
  }) {
    return MatchRecord(
      event: event ?? this.event,
      matchCode: matchCode ?? this.matchCode,
      teamNo: teamNo ?? this.teamNo,
      autoStartPosition: autoStartPosition ?? this.autoStartPosition,
      actions: actions ?? List.from(this.actions),
    );
  }
}
