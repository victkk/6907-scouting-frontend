/// 动作基类
class ScoutingAction {
  final String type;
  final int timestamp;

  // 可选字段
  final String? intakeCoralType;
  final String? intakeAlgaeType;
  final String? scoreCoralType;
  final String? scoreAlgaeType;
  final int? face;
  final bool? success;

  ScoutingAction({
    required this.type,
    required this.timestamp,
    this.intakeCoralType,
    this.intakeAlgaeType,
    this.scoreCoralType,
    this.scoreAlgaeType,
    this.face,
    this.success,
  });

  /// 从JSON创建动作
  factory ScoutingAction.fromJson(Map<String, dynamic> json) {
    return ScoutingAction(
      type: json['type'] ?? '',
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      intakeCoralType: json['intake coral type'],
      intakeAlgaeType: json['intake algae type'],
      scoreCoralType: json['score coral type'],
      scoreAlgaeType: json['score algae type'],
      face: json['face'],
      success: json['success'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'timestamp': timestamp,
    };

    // 根据类型添加其他字段
    if (type == 'intake coral' && intakeCoralType != null) {
      data['intake coral type'] = intakeCoralType;
    }
    if (type == 'intake algae' && intakeAlgaeType != null) {
      data['intake algae type'] = intakeAlgaeType;
    }
    if (type == 'score coral') {
      if (scoreCoralType != null) data['score coral type'] = scoreCoralType;
      if (face != null) data['face'] = face;
      if (success != null) data['success'] = success;
    }
    if (type == 'score algae') {
      if (scoreAlgaeType != null) data['score algae type'] = scoreAlgaeType;
      if (success != null) data['success'] = success;
    }

    return data;
  }

  /// 创建复制并更新部分字段
  ScoutingAction copyWith({
    String? type,
    int? timestamp,
    String? intakeCoralType,
    String? intakeAlgaeType,
    String? scoreCoralType,
    String? scoreAlgaeType,
    int? face,
    bool? success,
  }) {
    return ScoutingAction(
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      intakeCoralType: intakeCoralType ?? this.intakeCoralType,
      intakeAlgaeType: intakeAlgaeType ?? this.intakeAlgaeType,
      scoreCoralType: scoreCoralType ?? this.scoreCoralType,
      scoreAlgaeType: scoreAlgaeType ?? this.scoreAlgaeType,
      face: face ?? this.face,
      success: success ?? this.success,
    );
  }

  /// 工厂方法 - 创建开始动作
  static ScoutingAction start() {
    return ScoutingAction(
        type: 'start', timestamp: DateTime.now().millisecondsSinceEpoch);
  }

  static ScoutingAction defense() {
    return ScoutingAction(
        type: 'defense', timestamp: DateTime.now().millisecondsSinceEpoch);
  }

  static ScoutingAction foul() {
    return ScoutingAction(
        type: 'foul', timestamp: DateTime.now().millisecondsSinceEpoch);
  }

  /// 工厂方法 - 创建摄取珊瑚动作
  static ScoutingAction intakeCoral(String type) {
    return ScoutingAction(
      type: 'intake coral',
      timestamp: DateTime.now().millisecondsSinceEpoch,
      intakeCoralType: type,
    );
  }

  /// 工厂方法 - 创建摄取藻类动作
  static ScoutingAction intakeAlgae(String type) {
    return ScoutingAction(
      type: 'intake algae',
      timestamp: DateTime.now().millisecondsSinceEpoch,
      intakeAlgaeType: type,
    );
  }

  /// 工厂方法 - 创建得分珊瑚动作
  static ScoutingAction scoreCoral(String type, int face, bool success) {
    return ScoutingAction(
      type: 'score coral',
      face: face,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      scoreCoralType: type,
      success: success,
    );
  }

  /// 工厂方法 - 创建得分藻类动作
  static ScoutingAction scoreAlgae(String type, bool success) {
    return ScoutingAction(
      type: 'score algae',
      timestamp: DateTime.now().millisecondsSinceEpoch,
      scoreAlgaeType: type,
      success: success,
    );
  }

  /// 工厂方法 - 创建前往驳船动作
  static ScoutingAction goBarge() {
    return ScoutingAction(
        type: 'go barge', timestamp: DateTime.now().millisecondsSinceEpoch);
  }

  /// 工厂方法 - 创建爬升动作
  static ScoutingAction climbUp() {
    return ScoutingAction(
        type: 'climb up', timestamp: DateTime.now().millisecondsSinceEpoch);
  }
}
