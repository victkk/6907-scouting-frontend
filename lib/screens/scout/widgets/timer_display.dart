import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/scout_state_provider.dart';
import '../../../models/scout_state.dart';
import '../../../theme/app_theme.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final remainingTime = provider.getRemainingTime();
        final currentPhase = provider.getCurrentPhase();

        // 根据不同阶段显示不同的信息
        String displayText = '';
        String phaseText = '';
        Color primaryColor = AppTheme.primaryColor;
        Color backgroundColor = AppTheme.surfaceSecondary;
        IconData phaseIcon = Icons.timer;
        bool shouldPulse = false;

        switch (currentPhase) {
          case GamePhase.notStarted:
            return const SizedBox.shrink();

          case GamePhase.autonomous:
            if (remainingTime > 0) {
              final minutes = (remainingTime / 60).floor();
              final seconds = remainingTime % 60;
              displayText = '$minutes:${seconds.toString().padLeft(2, '0')}';
              phaseText = '自动阶段';
              primaryColor = AppTheme.successColor;
              phaseIcon = Icons.smart_toy;
            }
            break;

          case GamePhase.waitingTeleop:
            displayText = '等待中';
            phaseText = '准备手动阶段';
            primaryColor = AppTheme.warningColor;
            backgroundColor = AppTheme.warningColor.withOpacity(0.1);
            phaseIcon = Icons.pause_circle_outline;
            shouldPulse = true;
            break;

          case GamePhase.teleop:
            if (remainingTime > 0) {
              final minutes = (remainingTime / 60).floor();
              final seconds = remainingTime % 60;
              displayText = '$minutes:${seconds.toString().padLeft(2, '0')}';
              phaseText = '手动阶段';
              phaseIcon = Icons.gamepad;

              // 根据剩余时间改变颜色和效果
              if (remainingTime < 30) {
                primaryColor = AppTheme.errorColor;
                backgroundColor = AppTheme.errorColor.withOpacity(0.1);
                shouldPulse = true;
              } else if (remainingTime < 60) {
                primaryColor = AppTheme.warningColor;
                backgroundColor = AppTheme.warningColor.withOpacity(0.1);
              } else {
                primaryColor = AppTheme.infoColor;
                backgroundColor = AppTheme.infoColor.withOpacity(0.1);
              }
            }
            break;

          case GamePhase.finished:
            displayText = '已结束';
            phaseText = '比赛完成';
            primaryColor = AppTheme.textDisabled;
            backgroundColor = AppTheme.textDisabled.withOpacity(0.1);
            phaseIcon = Icons.flag;
            break;
        }

        if (displayText.isEmpty) {
          return const SizedBox.shrink();
        }

        // 控制脉冲动画
        if (shouldPulse && !_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        } else if (!shouldPulse && _pulseController.isAnimating) {
          _pulseController.stop();
          _pulseController.reset();
        }

        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Center(
              child: Transform.scale(
                scale: shouldPulse ? _pulseAnimation.value : 1.0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        backgroundColor,
                        backgroundColor.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 阶段图标
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          phaseIcon,
                          color: primaryColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 时间和阶段信息
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 阶段名称
                            Text(
                              phaseText,
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.0, // 控制行高
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),

                            // 时间显示
                            Text(
                              displayText,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                height: 1.0, // 控制行高
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
