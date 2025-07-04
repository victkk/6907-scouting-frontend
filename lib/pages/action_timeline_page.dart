import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horus/providers/scout_state_provider.dart';
import './edit_action_page.dart'; // 导入 EditActionPage
import 'package:horus/models/action.dart';
import 'package:horus/models/action_constants.dart';

class ActionTimelinePage extends StatefulWidget {
  const ActionTimelinePage({super.key});

  @override
  _ActionTimelinePageState createState() => _ActionTimelinePageState();
}

class _ActionTimelinePageState extends State<ActionTimelinePage> {
  // 面部映射：数字值 -> 显示文本
  final Map<int, String> _faceDisplayMap = {
    1: '正',
    2: '左',
    3: '网',
    4: '背',
    5: '洞',
    6: '右',
  };

  String _getActionTitle(ScoutingAction action) {
    // Convert action.type to a more readable format if necessary
    // For example, 'intake coral' -> 'Intake Coral'
    return action.type
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  List<Widget> _getActionSubtitles(ScoutingAction action) {
    final subtitles = <Widget>[];

    // 获取AppState以访问时间戳格式化方法
    final appState =
        Provider.of<AppStateProvider>(context, listen: false).appState;
    final timeString = appState.formatRelativeTimestamp(action.timestamp);
    final phaseInfo = appState.getPhaseFromRelativeTimestamp(action.timestamp);

    subtitles.add(Text('时间: $timeString ($phaseInfo)',
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)));

    if (action.intakeCoralType != null) {
      subtitles.add(Text('珊瑚类型: ${action.intakeCoralType}'));
    }
    if (action.intakeAlgaeType != null) {
      subtitles.add(Text('藻类类型: ${action.intakeAlgaeType}'));
    }
    if (action.groundAlgaeSource != null) {
      String sourceText;
      switch (action.groundAlgaeSource!) {
        case GroundAlgaeSources.front:
          sourceText = '前';
          break;
        case GroundAlgaeSources.middle:
          sourceText = '中';
          break;
        case GroundAlgaeSources.back:
          sourceText = '后';
          break;
        default:
          sourceText = action.groundAlgaeSource!;
      }
      subtitles.add(Text('藻类来源: $sourceText'));
    }
    if (action.scoreCoralType != null) {
      subtitles.add(Text('得分珊瑚类型: ${action.scoreCoralType}'));
    }
    if (action.scoreAlgaeType != null) {
      String algaeScoreText = '得分藻类类型: ';
      switch (action.scoreAlgaeType!) {
        case AlgaeScoreTypes.net:
          algaeScoreText += 'Net (普通)';
          break;
        case AlgaeScoreTypes.tactical:
          algaeScoreText += '战术 (Tactical)';
          break;
        case AlgaeScoreTypes.shooting:
          algaeScoreText += '射球 (Shooting)';
          break;
        case AlgaeScoreTypes.processor:
          algaeScoreText += 'Processor';
          break;
        default:
          algaeScoreText += action.scoreAlgaeType!;
      }
      subtitles.add(Text(algaeScoreText,
          style: TextStyle(
            color: action.scoreAlgaeType == AlgaeScoreTypes.tactical
                ? Colors.orange
                : action.scoreAlgaeType == AlgaeScoreTypes.shooting
                    ? Colors.red
                    : null,
            fontWeight: action.scoreAlgaeType == AlgaeScoreTypes.tactical ||
                    action.scoreAlgaeType == AlgaeScoreTypes.shooting
                ? FontWeight.bold
                : FontWeight.normal,
          )));
    }
    if (action.face != null) {
      subtitles.add(Text('朝向: ${_faceDisplayMap[action.face] ?? action.face}'));
    }
    if (action.success != null) {
      subtitles.add(Text('成功: ${action.success}'));
    }

    // 显示详细信息（不依赖action type）
    if (action.defended == true) {
      subtitles.add(Text('🛡️ 被防守',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)));
    }

    // 显示爬升结果
    if (action.climbResult != null) {
      String resultText;
      Color resultColor;
      String resultIcon;

      switch (action.climbResult!) {
        case ClimbResults.success:
          resultText = '成功';
          resultColor = Colors.green;
          resultIcon = '✅';
          break;
        case ClimbResults.failure:
          resultText = '失败';
          resultColor = Colors.red;
          resultIcon = '❌';
          break;
        case ClimbResults.hitChain:
          resultText = '碰链子';
          resultColor = Colors.orange;
          resultIcon = '⚠️';
          break;
        default:
          resultText = action.climbResult!;
          resultColor = Colors.grey;
          resultIcon = '❓';
      }

      subtitles.add(Text('$resultIcon $resultText',
          style: TextStyle(color: resultColor, fontWeight: FontWeight.bold)));
    }

    return subtitles;
  }

  // 提交记录的方法
  Future<void> _submitRecord(BuildContext context) async {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);

    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('正在提交记录...'),
            ],
          ),
        );
      },
    );

    try {
      // 提交记录
      final result = await appStateProvider.submitMatchRecord();

      // 关闭加载对话框
      Navigator.of(context).pop();

      // 显示结果对话框
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(result['success'] ? '提交成功' : '提交失败'),
            content: Text(result['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // 关闭加载对话框
      Navigator.of(context).pop();

      // 显示错误对话框
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提交失败'),
            content: Text('发生错误: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<AppStateProvider>(context);
    final actions = appStateProvider.appState.matchRecord.actions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Timeline'),
      ),
      body: Stack(
        children: [
          actions.isEmpty
              ? const Center(child: Text('暂无记录的动作'))
              : ListView.builder(
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    return ListTile(
                      tileColor: action.type == ActionTypes.giveUp
                          ? Colors.red.withOpacity(0.3)
                          : null,
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                      title: Text(_getActionTitle(action)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _getActionSubtitles(action),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditActionPage(
                                        initialTimestamp: action.timestamp)),
                              );
                            },
                          ),
                          // 只有非start类型的action才显示编辑按钮
                          if (action.type != ActionTypes.start)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditActionPage(
                                        action: action, index: index),
                                  ),
                                );
                              },
                            ),
                          // 只有非start类型的action才显示删除按钮
                          if (action.type != ActionTypes.start)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('确认删除'),
                                      content: const Text('你确定要删除这个动作吗？'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('取消'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('删除'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirmDelete == true) {
                                  appStateProvider.deleteAction(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('动作已删除')),
                                  );
                                }
                              },
                            ),
                          // 如果是start类型，显示锁定图标表示不可编辑
                          if (action.type == ActionTypes.start)
                            const Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 20,
                            ),
                        ],
                      ),
                      onLongPress: () {
                        // TODO: Implement action deletion
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Delete action ${index + 1} (not implemented yet)')),
                        );
                      },
                    );
                  },
                ),
          // 提交记录按钮固定在屏幕1/2位置
          if (actions.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 - kToolbarHeight,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _submitRecord(context),
                  icon: const Icon(Icons.cloud_upload, color: Colors.white),
                  label: const Text(
                    '提交记录',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
