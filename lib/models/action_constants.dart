/// 动作类型常量
class ActionTypes {
  static const String start = 'start';
  static const String teleopStart = 'teleop start';
  static const String intakeCoral = 'intake coral';
  static const String intakeAlgae = 'intake algae';
  static const String scoreCoral = 'score coral';
  static const String scoreAlgae = 'score algae';
  static const String giveUp = 'give up';
  static const String climbUp = 'climb up';
  static const String defense = 'defense';
  static const String foul = 'foul';
  static const List<String> all = [
    start,
    teleopStart,
    intakeCoral,
    intakeAlgae,
    scoreCoral,
    scoreAlgae,
    giveUp,
    climbUp,
    defense,
    foul
  ];
}

/// 珊瑚摄取类型常量
class CoralIntakeTypes {
  static const String loadStationA = 'load station A';
  static const String loadStationB = 'load station B';
  static const String ground = 'ground';
  static const String fixed = 'fixed';

  static const List<String> all = [loadStationA, loadStationB, ground, fixed];
}

/// 藻类摄取类型常量
class AlgaeIntakeTypes {
  static const String ground = 'ground';
  static const String reef = 'reef';
  static const String scrape = 'scrape';
  static const List<String> all = [ground, reef, scrape];
}

/// Ground Algae 来源类型常量
class GroundAlgaeSources {
  static const String front = 'front'; // 前
  static const String middle = 'middle'; // 中
  static const String back = 'back'; // 后
  static const List<String> all = [front, middle, back];
}

/// 珊瑚得分类型常量
class CoralScoreTypes {
  static const String stackl1 = 'Stack L1';
  static const String l1 = 'L1';
  static const String l2 = 'L2';
  static const String l3 = 'L3';
  static const String l4 = 'L4';
  static const List<String> all = [stackl1, l1, l2, l3, l4];
}

/// 藻类得分类型常量
class AlgaeScoreTypes {
  static const String processor = 'processor';
  static const String net = 'net';
  static const String tactical = 'tactical'; // 战术
  static const String shooting = 'shooting'; // 射球
  static const List<String> all = [net, processor, tactical, shooting];
}

/// 爬升结果类型常量
class ClimbResults {
  static const String success = 'success'; // 成功
  static const String failure = 'failure'; // 失败
  static const String hitChain = 'hit_chain'; // 碰链子
  static const String park = 'park'; // 停靠+未尝试爬升
  static const List<String> all = [success, failure, hitChain, park];
}

/// 自动阶段起始位置
class AutoStartPositions {
  static const String pos1 = 'auto 1';
  static const String pos2 = 'auto 2';
  static const String pos3 = 'auto 3';
  static const String pos4 = 'auto 4';
  static const String pos5 = 'auto 5';

  static const List<String> all = [pos1, pos2, pos3, pos4, pos5];
}
