import 'package:flutter/material.dart';
import 'package:horus/models/action.dart'; // ScoutingAction
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
  bool? _success;
  AppState? _appState; // 添加AppState引用

  // 定义所有可能的 action type
  final List<String> _actionTypes = [
    'start',
    'defense',
    'foul',
    'intake coral',
    'intake algae',
    'score coral',
    'score algae',
    'go barge',
    'climb up'
  ];

  // 定义所有可能的 intake coral type
  final List<String> _intakeCoralTypes = [
    'ground',
    'load station A',
    'load station B'
  ];
  // 定义所有可能的 intake algae type
  final List<String> _intakeAlgaeTypes = ['ground', 'reef'];
  // 定义所有可能的 score coral type
  final List<String> _scoreCoralTypes = ['L1', 'L2', 'L3', 'L4'];
  // 定义所有可能的 score algae type
  final List<String> _scoreAlgaeTypes = ['net', 'processor'];

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.action == null ? 'Add Action' : 'Edit Action'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Action Type'),
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
                    _success = null;
                  });
                },
              ),
              if (_type == 'intake coral')
                DropdownButtonFormField<String>(
                  value: _intakeCoralType,
                  decoration:
                      const InputDecoration(labelText: 'Intake Coral Type'),
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
              if (_type == 'intake algae')
                DropdownButtonFormField<String>(
                  value: _intakeAlgaeType,
                  decoration:
                      const InputDecoration(labelText: 'Intake Algae Type'),
                  items: _intakeAlgaeTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _intakeAlgaeType = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a type' : null,
                ),
              if (_type == 'score coral') ...[
                DropdownButtonFormField<String>(
                  value: _scoreCoralType,
                  decoration:
                      const InputDecoration(labelText: 'Score Coral Type'),
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
                TextFormField(
                  initialValue: _face?.toString(),
                  decoration: const InputDecoration(labelText: 'Face (1-6)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _face = value != null && value.isNotEmpty
                      ? int.tryParse(value)
                      : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a face value';
                    }
                    final n = int.tryParse(value);
                    if (n == null || n < 1 || n > 6) {
                      return 'Face must be between 1 and 6';
                    }
                    return null;
                  },
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
              if (_type == 'score algae') ...[
                DropdownButtonFormField<String>(
                  value: _scoreAlgaeType,
                  decoration:
                      const InputDecoration(labelText: 'Score Algae Type'),
                  items: _scoreAlgaeTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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
              // 时间戳编辑区域
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('时间戳调整',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),

                        // 时间滑块
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[800],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blueGrey[600]!),
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
                                  inactiveTrackColor: Colors.blueGrey[600],
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
                                      .formatRelativeTimestamp(_timestamp),
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
                            style: TextStyle(fontWeight: FontWeight.w500)),
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
                            _buildAdjustButton('-5秒', -5000, Icons.replay_5),
                            // 小幅度调整
                            _buildAdjustButton('-1秒', -1000, Icons.remove),
                            _buildAdjustButton('+1秒', 1000, Icons.add),
                            // 大幅度调整
                            _buildAdjustButton('+5秒', 5000, Icons.forward_5),
                            _buildAdjustButton('+10秒', 10000, Icons.skip_next),
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
