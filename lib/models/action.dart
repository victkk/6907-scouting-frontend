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

  // score coral 类型的详细信息
  final bool stacking; // 叠筒
  final bool scraping; // 刮球
  final bool defended; // 被防守

  ScoutingAction({
    required this.type,
    required this.timestamp,
    this.intakeCoralType,
    this.intakeAlgaeType,
    this.scoreCoralType,
    this.scoreAlgaeType,
    this.face,
    this.success,
    this.stacking = false,
    this.scraping = false,
    this.defended = false,
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
      stacking: json['stacking'] ?? false,
      scraping: json['scraping'] ?? false,
      defended: json['defended'] ?? false,
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
      data['stacking'] = stacking;
      data['scraping'] = scraping;
      data['defended'] = defended;
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
    bool? stacking,
    bool? scraping,
    bool? defended,
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
      stacking: stacking ?? this.stacking,
      scraping: scraping ?? this.scraping,
      defended: defended ?? this.defended,
    );
  }

  /// 工厂方法 - 创建开始动作
  static ScoutingAction start({int? timestamp}) {
    return ScoutingAction(
        type: 'start',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  static ScoutingAction defense({int? timestamp}) {
    return ScoutingAction(
        type: 'defense',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  static ScoutingAction foul({int? timestamp}) {
    return ScoutingAction(
        type: 'foul',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  /// 工厂方法 - 创建摄取珊瑚动作
  static ScoutingAction intakeCoral(String type, {int? timestamp}) {
    return ScoutingAction(
      type: 'intake coral',
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      intakeCoralType: type,
    );
  }

  /// 工厂方法 - 创建摄取藻类动作
  static ScoutingAction intakeAlgae(String type, {int? timestamp}) {
    return ScoutingAction(
      type: 'intake algae',
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      intakeAlgaeType: type,
    );
  }

  /// 工厂方法 - 创建得分珊瑚动作
  static ScoutingAction scoreCoral(String type, int face, bool success,
      {int? timestamp, bool? stacking, bool? scraping, bool? defended}) {
    return ScoutingAction(
      type: 'score coral',
      face: face,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      scoreCoralType: type,
      success: success,
      stacking: stacking ?? false,
      scraping: scraping ?? false,
      defended: defended ?? false,
    );
  }

  /// 工厂方法 - 创建得分藻类动作
  static ScoutingAction scoreAlgae(String type, bool success,
      {int? timestamp}) {
    return ScoutingAction(
      type: 'score algae',
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      scoreAlgaeType: type,
      success: success,
    );
  }

  /// 工厂方法 - 创建前往驳船动作
  static ScoutingAction giveUp({int? timestamp}) {
    return ScoutingAction(
        type: 'give up',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  /// 工厂方法 - 创建爬升动作
  static ScoutingAction climbUp({int? timestamp}) {
    return ScoutingAction(
        type: 'climb up',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch);
  }
}
