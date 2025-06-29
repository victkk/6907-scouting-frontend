import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/scout_state_provider.dart';
import '../../../models/scout_state.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final remainingTime = provider.getRemainingTime();
        final currentPhase = provider.getCurrentPhase();

        // 根据不同阶段显示不同的信息
        String displayText = '';
        Color textColor = Colors.white;

        switch (currentPhase) {
          case GamePhase.notStarted:
            return const SizedBox.shrink();

          case GamePhase.autonomous:
            if (remainingTime > 0) {
              final minutes = (remainingTime / 60).floor();
              final seconds = remainingTime % 60;
              final timeString =
                  '$minutes:${seconds.toString().padLeft(2, '0')}';
              displayText = '自动阶段: $timeString';
              textColor = Colors.green;
            }
            break;

          case GamePhase.waitingTeleop:
            displayText = '等待手动阶段开始...';
            textColor = Colors.orange;
            break;

          case GamePhase.teleop:
            if (remainingTime > 0) {
              final minutes = (remainingTime / 60).floor();
              final seconds = remainingTime % 60;
              final timeString =
                  '$minutes:${seconds.toString().padLeft(2, '0')}';
              displayText = '手动阶段: $timeString';

              // 根据剩余时间改变颜色
              if (remainingTime < 30) {
                textColor = Colors.red;
              } else if (remainingTime < 60) {
                textColor = Colors.orange;
              } else {
                textColor = Colors.blue;
              }
            }
            break;

          case GamePhase.finished:
            displayText = '比赛结束';
            textColor = Colors.grey;
            break;
        }

        if (displayText.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            displayText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
