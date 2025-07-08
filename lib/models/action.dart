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

  // ground algae 来源信息
  final String? groundAlgaeSource; // 前/中/后

  final bool? defended; // 被防守

  // climb up 类型的详细信息
  final String? climbResult; // 爬升结果：成功/失败/碰链子

  final bool? starred; // 标记这个动作记错了

  ScoutingAction({
    required this.type,
    required this.timestamp,
    this.intakeCoralType,
    this.intakeAlgaeType,
    this.scoreCoralType,
    this.scoreAlgaeType,
    this.face,
    this.success,
    this.groundAlgaeSource,
    this.defended,
    this.climbResult,
    this.starred,
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
      groundAlgaeSource: json['ground algae source'],
      defended: json['defended'] ?? false,
      climbResult: json['climb result'],
      starred: json['starred'] ?? false,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'timestamp': timestamp,
    };

    // 只要有该属性就加入，不管类型
    if (intakeCoralType != null) {
      data['intake coral type'] = intakeCoralType;
    }
    if (intakeAlgaeType != null) {
      data['intake algae type'] = intakeAlgaeType;
    }
    if (scoreCoralType != null) {
      data['score coral type'] = scoreCoralType;
    }
    if (scoreAlgaeType != null) {
      data['score algae type'] = scoreAlgaeType;
    }
    if (face != null) {
      data['face'] = face;
    }
    if (success != null) {
      data['success'] = success;
    }
    if (groundAlgaeSource != null) {
      data['ground algae source'] = groundAlgaeSource;
    }
    if (defended != null) {
      data['defended'] = defended;
    }
    if (climbResult != null) {
      data['climb result'] = climbResult;
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
    String? groundAlgaeSource,
    bool? defended,
    String? climbResult,
    bool? starred,
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
      groundAlgaeSource: groundAlgaeSource ?? this.groundAlgaeSource,
      defended: defended ?? this.defended,
      climbResult: climbResult ?? this.climbResult,
      starred: starred ?? this.starred,
    );
  }

  /// 工厂方法 - 创建开始动作
  static ScoutingAction start({int? timestamp, bool? starred}) {
    return ScoutingAction(
        type: 'start',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        starred: starred);
  }

  static ScoutingAction defense({int? timestamp, bool? starred}) {
    return ScoutingAction(
        type: 'defense',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        starred: starred);
  }

  static ScoutingAction foul({int? timestamp, bool? starred}) {
    return ScoutingAction(
        type: 'foul',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        starred: starred);
  }

  /// 工厂方法 - 创建摄取珊瑚动作
  static ScoutingAction intakeCoral(String type,
      {int? timestamp, bool? starred}) {
    return ScoutingAction(
      type: 'intake coral',
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      intakeCoralType: type,
      starred: starred,
    );
  }

  /// 工厂方法 - 创建摄取藻类动作
  static ScoutingAction intakeAlgae(String type,
      {int? timestamp, String? groundSource, bool? starred}) {
    return ScoutingAction(
      type: 'intake algae',
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      intakeAlgaeType: type,
      groundAlgaeSource: groundSource,
      starred: starred,
    );
  }

  /// 工厂方法 - 创建得分珊瑚动作
  static ScoutingAction scoreCoral(String type, int face, bool success,
      {int? timestamp, bool? defended, bool? starred}) {
    return ScoutingAction(
      type: 'score coral',
      face: face,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      scoreCoralType: type,
      success: success,
      defended: defended ?? false,
      starred: starred,
    );
  }

  /// 工厂方法 - 创建得分藻类动作
  static ScoutingAction scoreAlgae(String type, bool success,
      {int? timestamp, bool? starred}) {
    return ScoutingAction(
      type: 'score algae',
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      scoreAlgaeType: type,
      success: success,
      starred: starred,
    );
  }

  /// 工厂方法 - 创建前往驳船动作
  static ScoutingAction giveUp({int? timestamp, bool? starred}) {
    return ScoutingAction(
        type: 'give up',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        starred: starred);
  }

  /// 工厂方法 - 创建爬升动作
  static ScoutingAction climbUp(
      {int? timestamp, String? result, bool? starred}) {
    return ScoutingAction(
        type: 'climb up',
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        climbResult: result,
        starred: starred);
  }
}
