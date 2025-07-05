import 'package:flutter/material.dart';
import 'package:horus/models/action.dart'; // ScoutingAction
import 'package:horus/models/action_constants.dart'; // GroundAlgaeSources
import 'package:horus/providers/scout_state_provider.dart';
import 'package:horus/models/scout_state.dart'; // AppState
import 'package:provider/provider.dart';

class EditActionPage extends StatefulWidget {
  final ScoutingAction? action;
  final int? index; // 用于编辑现有动作的索引
  final int? initialTimestamp; // 用于新动作的初始时间戳

  const EditActionPage(
      {super.key, this.action, this.index, this.initialTimestamp});

  @override
  _EditActionPageState createState() => _EditActionPageState();
}

class _EditActionPageState extends State<EditActionPage> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late int _timestamp;
  String? _intakeCoralType;
  String? _intakeAlgaeType;
  String? _scoreCoralType;
  String? _scoreAlgaeType;
  int? _face;
  String? _faceDisplay; // 用于显示的面部选项
  bool? _success;
  String? _groundAlgaeSource; // Ground Algae 来源
  bool? _defended = false; // 被防守
  String? _climbResult; // 爬升结果

  AppState? _appState; // 添加AppState引用

  // 定义所有可能的 action type (除了start，start只能通过特定按钮创建)
  final List<String> _actionTypes =
      ActionTypes.all.where((type) => type != ActionTypes.start).toList();

  // 定义所有可能的 intake coral type
  final List<String> _intakeCoralTypes = CoralIntakeTypes.all;

  // 定义所有可能的 intake algae type
  final List<String> _intakeAlgaeTypes = AlgaeIntakeTypes.all;

  // 定义所有可能的 score coral type
  final List<String> _scoreCoralTypes = CoralScoreTypes.all.toList();

  // 定义所有可能的 score algae type
  final List<String> _scoreAlgaeTypes = AlgaeScoreTypes.all;

  // 定义 Ground Algae 来源选项
  final List<String> _groundAlgaeSources = GroundAlgaeSources.all;

  // 定义爬升结果选项
  final List<String> _climbResults = ClimbResults.all;

  // 面部选项映射：显示文本 -> 数字值
  final Map<String, int> _faceOptions = {
    '正': 3,
    '左': 4,
    '网': 5,
    '背': 6,
    '洞': 1,
    '右': 2,
  };

  // 反向映射：数字值 -> 显示文本
  final Map<int, String> _faceDisplayMap = {
    3: '正',
    4: '左',
    5: '网',
    6: '背',
    1: '洞',
    2: '右',
  };

  @override
  void initState() {
    super.initState();
    // 获取AppState引用
    _appState = context.read<AppStateProvider>().appState;

    if (widget.action != null) {
      _type = widget.action!.type;
      _timestamp = widget.action!.timestamp;
      _intakeCoralType = widget.action!.intakeCoralType;
      _intakeAlgaeType = widget.action!.intakeAlgaeType;
      _scoreCoralType = widget.action!.scoreCoralType;
      _scoreAlgaeType = widget.action!.scoreAlgaeType;
      _face = widget.action!.face;
      _success = widget.action!.success;
      _groundAlgaeSource = widget.action!.groundAlgaeSource;

      _defended = widget.action!.defended;
      _climbResult = widget.action!.climbResult;
      _faceDisplay = _face != null ? _faceDisplayMap[_face] : null;
    } else {
      _type = _actionTypes.first; // 默认选择第一个类型
      _timestamp = widget.initialTimestamp ?? _appState!.getRelativeTimestamp();
      // 其他字段默认为 null
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final appStateProvider =
          Provider.of<AppStateProvider>(context, listen: false);
      final newAction = ScoutingAction(
        type: _type,
        timestamp: _timestamp, // 使用相对时间戳
        intakeCoralType: _intakeCoralType,
        intakeAlgaeType: _intakeAlgaeType,
        scoreCoralType: _scoreCoralType,
        scoreAlgaeType: _scoreAlgaeType,
        face: _face,
        success: _success,
        groundAlgaeSource: _groundAlgaeSource,
        defended: _defended,
        climbResult: _climbResult,
      );

      if (widget.action == null) {
        // 添加新动作
        appStateProvider.addAction(newAction);
      } else {
        // 更新现有动作
        appStateProvider.updateAction(widget.index!, newAction);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 检查是否正在编辑start类型的action
    final bool isEditingStartAction =
        widget.action != null && widget.action!.type == ActionTypes.start;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.action == null ? 'Add Action' : 'Edit Action'),
        actions: [
          if (!isEditingStartAction) // 只有非start类型的action才显示保存按钮
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveForm,
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isEditingStartAction
            ? _buildStartActionWarning() // 如果是start类型，显示警告信息
            : Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration:
                          const InputDecoration(labelText: 'Action Type'),
                      items: _actionTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _type = newValue!;
                          // 根据选择的类型，重置相关字段
                          _intakeCoralType = null;
                          _intakeAlgaeType = null;
                          _scoreCoralType = null;
                          _scoreAlgaeType = null;
                          _face = null;
                          _faceDisplay = null;
                          _success = null;
                          _groundAlgaeSource = null;
                          _defended = false;
                          _climbResult = null;
                        });
                      },
                    ),
                    if (_type == ActionTypes.intakeCoral)
                      DropdownButtonFormField<String>(
                        value: _intakeCoralType,
                        decoration: const InputDecoration(
                            labelText: 'Intake Coral Type'),
                        items: _intakeCoralTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _intakeCoralType = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a type' : null,
                      ),
                    if (_type == ActionTypes.intakeAlgae) ...[
                      DropdownButtonFormField<String>(
                        value: _intakeAlgaeType,
                        decoration: const InputDecoration(
                            labelText: 'Intake Algae Type'),
                        items: _intakeAlgaeTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _intakeAlgaeType = newValue;
                            // 如果不是ground类型，清空来源选择
                            if (newValue != AlgaeIntakeTypes.ground) {
                              _groundAlgaeSource = null;
                            }
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a type' : null,
                      ),

                      // 只有选择了ground类型时才显示来源选择
                      if (_intakeAlgaeType == AlgaeIntakeTypes.ground)
                        DropdownButtonFormField<String>(
                          value: _groundAlgaeSource,
                          decoration: const InputDecoration(
                              labelText: 'Ground Algae Source (来源)'),
                          items: _groundAlgaeSources.map((String value) {
                            String displayText;
                            switch (value) {
                              case GroundAlgaeSources.front:
                                displayText = '前 (Front)';
                                break;
                              case GroundAlgaeSources.middle:
                                displayText = '中 (Middle)';
                                break;
                              case GroundAlgaeSources.back:
                                displayText = '后 (Back)';
                                break;
                              default:
                                displayText = value;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(displayText),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _groundAlgaeSource = newValue;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a source' : null,
                        ),
                    ],
                    if (_type == ActionTypes.scoreCoral) ...[
                      DropdownButtonFormField<String>(
                        value: _scoreCoralType,
                        decoration: const InputDecoration(
                            labelText: 'Score Coral Type'),
                        items: _scoreCoralTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _scoreCoralType = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a type' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: _faceDisplay,
                        decoration: const InputDecoration(labelText: 'Face'),
                        items: _faceOptions.keys.map((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text('$key (${_faceOptions[key]})'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _faceDisplay = newValue;
                            _face = _faceOptions[newValue];
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a face' : null,
                      ),
                      CheckboxListTile(
                        title: const Text('Success'),
                        value: _success ?? false, // 默认为 false 如果是 null
                        onChanged: (bool? value) {
                          setState(() {
                            _success = value;
                          });
                        },
                      ),

                      // Score coral 详细选项
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Score Coral 详细信息:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text('🛡️ 被防守 (Defended)'),
                        subtitle: const Text('是否被对方机器人防守'),
                        value: _defended,
                        onChanged: (bool? value) {
                          setState(() {
                            _defended = value ?? false;
                          });
                        },
                        activeColor: Colors.red,
                      ),
                    ],
                    if (_type == ActionTypes.scoreAlgae) ...[
                      DropdownButtonFormField<String>(
                        value: _scoreAlgaeType,
                        decoration: const InputDecoration(
                            labelText: 'Score Algae Type'),
                        items: _scoreAlgaeTypes.map((String value) {
                          String displayText;
                          switch (value) {
                            case AlgaeScoreTypes.net:
                              displayText = 'Net (普通)';
                              break;
                            case AlgaeScoreTypes.tactical:
                              displayText = '战术 (Tactical)';
                              break;
                            case AlgaeScoreTypes.shooting:
                              displayText = '射球 (Shooting)';
                              break;
                            case AlgaeScoreTypes.processor:
                              displayText = 'Processor';
                              break;
                            default:
                              displayText = value;
                          }
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(displayText),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _scoreAlgaeType = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a type' : null,
                      ),
                      CheckboxListTile(
                        title: const Text('Success'),
                        value: _success ?? false, // 默认为 false 如果是 null
                        onChanged: (bool? value) {
                          setState(() {
                            _success = value;
                          });
                        },
                      ),
                    ],
                    if (_type == ActionTypes.climbUp) ...[
                      DropdownButtonFormField<String>(
                        value: _climbResult,
                        decoration: const InputDecoration(
                            labelText: 'Climb Result (爬升结果)'),
                        items: _climbResults.map((String value) {
                          String displayText;
                          switch (value) {
                            case ClimbResults.success:
                              displayText = '✅ 成功 (Success)';
                              break;
                            case ClimbResults.failure:
                              displayText = '❌ 失败 (Failure)';
                              break;
                            case ClimbResults.hitChain:
                              displayText = '⛓️ 碰链子 (Hit Chain)';
                              break;
                            default:
                              displayText = value;
                          }
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(displayText),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _climbResult = newValue;
                          });
                        },
                        validator: (value) => value == null
                            ? 'Please select a climb result'
                            : null,
                      ),
                    ],
                    // 时间戳编辑区域
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('时间戳调整',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),

                              // 时间滑块
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.blueGrey[600]!),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${_appState!.formatRelativeTimestamp(_timestamp)} (${_appState!.getPhaseFromRelativeTimestamp(_timestamp)})',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Colors.blue[600],
                                        inactiveTrackColor:
                                            Colors.blueGrey[600],
                                        thumbColor: Colors.blue[400],
                                        overlayColor:
                                            Colors.blue[400]!.withOpacity(0.3),
                                        valueIndicatorColor: Colors.blue[700],
                                      ),
                                      child: Slider(
                                        value: _timestamp.toDouble(),
                                        min: 0,
                                        max: 150000, // 2分30秒
                                        divisions: 150, // 每秒一个刻度
                                        label: _appState!
                                            .formatRelativeTimestamp(
                                                _timestamp),
                                        onChanged: (value) {
                                          setState(() {
                                            _timestamp = value.round();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 快速调整按钮组
                              const Text('快速调整:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  // 大幅度调整
                                  _buildAdjustButton(
                                      '-30秒', -30000, Icons.fast_rewind),
                                  _buildAdjustButton(
                                      '-10秒', -10000, Icons.skip_previous),
                                  _buildAdjustButton(
                                      '-5秒', -5000, Icons.replay_5),
                                  // 小幅度调整
                                  _buildAdjustButton(
                                      '-1秒', -1000, Icons.remove),
                                  _buildAdjustButton('+1秒', 1000, Icons.add),
                                  // 大幅度调整
                                  _buildAdjustButton(
                                      '+5秒', 5000, Icons.forward_5),
                                  _buildAdjustButton(
                                      '+10秒', 10000, Icons.skip_next),
                                  _buildAdjustButton(
                                      '+30秒', 30000, Icons.fast_forward),
                                ],
                              ),
                            ]))
                  ],
                ),
              ),
      ),
    );
  }

  // 构建start类型action的警告信息
  Widget _buildStartActionWarning() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            const Text(
              '无法编辑START类型动作',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'START类型的动作只能通过专门的开始按钮创建，\n不能通过编辑页面修改。',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('返回'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建调整按钮的辅助方法
  Widget _buildAdjustButton(String label, int adjustment, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          final newTimestamp = _timestamp + adjustment;
          if (newTimestamp >= 0 && newTimestamp <= 150000) {
            _timestamp = newTimestamp;
          }
        });
      },
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor:
            adjustment < 0 ? Colors.blueGrey[700] : Colors.blue[700],
        foregroundColor: Colors.white,
        side: BorderSide(
          color: adjustment < 0 ? Colors.blueGrey[500]! : Colors.blue[500]!,
          width: 1,
        ),
      ),
    );
  }
}
