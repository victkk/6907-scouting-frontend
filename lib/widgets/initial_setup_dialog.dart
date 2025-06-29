import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scout_state_provider.dart';

class InitialSetupDialog extends StatefulWidget {
  const InitialSetupDialog({super.key});

  @override
  State<InitialSetupDialog> createState() => _InitialSetupDialogState();
}

class _InitialSetupDialogState extends State<InitialSetupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _teamNoController = TextEditingController();

  // 下拉菜单选择的值
  String? _selectedEvent;
  String? _selectedMatchCode;

  // 样例数据
  final List<String> _events = [
    'FRC Regional Championship',
    'FIRST World Championship',
    'District Event',
    'Off-Season Competition',
    'Practice Match',
    'Scrimmage',
  ];

  final List<String> _matchCodes = [
    'QM1',
    'QM2',
    'QM3',
    'QM4',
    'QM5',
    'QM10',
    'QM15',
    'QM20',
    'QM25',
    'QM30',
    'SF1M1',
    'SF1M2',
    'SF1M3',
    'SF2M1',
    'SF2M2',
    'SF2M3',
    'F1M1',
    'F1M2',
    'F1M3',
  ];

  @override
  void dispose() {
    _teamNoController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppStateProvider>(context, listen: false);

      // 更新MatchRecord的基本信息
      provider.updateMatchInfo(
        event: _selectedEvent!,
        matchCode: _selectedMatchCode!,
        teamNo: int.parse(_teamNoController.text),
      );

      // 关闭对话框
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 防止用户通过返回键关闭对话框
      child: Dialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Text(
                  'Match Setup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // 赛事下拉菜单
                DropdownButtonFormField<String>(
                  value: _selectedEvent,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.blueGrey[800],
                  decoration: InputDecoration(
                    labelText: 'Event',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[500]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _events.map((String event) {
                    return DropdownMenuItem<String>(
                      value: event,
                      child: Text(event,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEvent = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an event';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 比赛代码下拉菜单
                DropdownButtonFormField<String>(
                  value: _selectedMatchCode,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.blueGrey[800],
                  decoration: InputDecoration(
                    labelText: 'Match Code',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[500]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _matchCodes.map((String matchCode) {
                    return DropdownMenuItem<String>(
                      value: matchCode,
                      child: Text(matchCode,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMatchCode = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a match code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Team Number input field
                TextFormField(
                  controller: _teamNoController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Team Number',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[500]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter team number';
                    }
                    final number = int.tryParse(value);
                    if (number == null || number <= 0) {
                      return 'Please enter a valid team number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Start Match',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
