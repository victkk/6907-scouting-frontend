import 'package:flutter/material.dart';
import 'widgets/center_image.dart';
import 'widgets/side_panel.dart';
import 'widgets/timer_display.dart';
import 'package:horus/pages/action_timeline_page.dart';
import 'package:provider/provider.dart';
import '../../providers/scout_state_provider.dart';
import '../../models/scout_state.dart';

class LandscapeScreen extends StatelessWidget {
  const LandscapeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text('6907 Scout'),
        backgroundColor: Colors.indigo[900],
        actions: [
          // 添加计时器显示
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: TimerDisplay()),
          ),
          IconButton(
            icon: const Icon(Icons.timeline),
            tooltip: 'Action Timeline',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ActionTimelinePage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              // 原始界面
              Row(
                children: [
                  // 左侧面板 - 占据20%的宽度
                  SizedBox(
                    width: screenSize.width * 0.2,
                    child: const SidePanel(isLeftPanel: true),
                  ),

                  // 中心区域 - 占据60%的宽度，垂直居中显示正方形图片
                  Container(
                    height: screenSize.height * 1,
                    alignment: Alignment.center,
                    child: const CenterImage(),
                  ),

                  // 右侧面板 - 占据20%的宽度
                  SizedBox(
                    width: screenSize.width * 0.2,
                    child: const SidePanel(isLeftPanel: false),
                  ),
                ],
              ),

              // 当处于等待手动阶段时，显示巨大的teleopStart按键
              if (provider.getCurrentPhase() == GamePhase.waitingTeleop)
                Container(
                  color: Colors.black.withOpacity(0.7), // 半透明背景
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      height: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.startTeleopPhase();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                        ),
                        child: const Text(
                          'teleopStart',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
