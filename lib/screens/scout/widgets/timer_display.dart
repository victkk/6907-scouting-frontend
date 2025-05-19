import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/scout_state_provider.dart';

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final remainingTime = provider.getRemainingTime();

        // 如果剩余时间为0，不显示计时器
        if (remainingTime <= 0) {
          return SizedBox.shrink();
        }

        // 格式化剩余时间为分:秒格式
        final minutes = (remainingTime / 60).floor();
        final seconds = remainingTime % 60;
        final timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';

        // 根据剩余时间改变颜色
        Color textColor = Colors.white;
        if (remainingTime < 30) {
          textColor = Colors.red;
        } else if (remainingTime < 60) {
          textColor = Colors.orange;
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Auto Save: $timeString',
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
