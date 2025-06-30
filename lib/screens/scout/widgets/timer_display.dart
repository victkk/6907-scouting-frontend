import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/scout_state_provider.dart';
import '../../../models/scout_state.dart';
import '../../../theme/app_theme.dart';
import 'dart:ui';

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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 4000; // 判断是否为小屏幕

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
              phaseText = '自动';
              primaryColor = AppTheme.successColor;
              phaseIcon = Icons.smart_toy;
            }
            break;

          case GamePhase.waitingTeleop:
            displayText = '等待';
            phaseText = '准备';
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
              phaseText = '手动';
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
            displayText = '完成';
            phaseText = '结束';
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
                  padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 4 : 12,
                      vertical: isSmallScreen ? 2 : 6), // 大幅减少padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        backgroundColor,
                        backgroundColor.withOpacity(0.5),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 6 : 12), // 减少圆角
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: isSmallScreen ? 3 : 6, // 减少阴影
                        offset: Offset(0, isSmallScreen ? 1 : 2), // 减少偏移
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 阶段图标
                      Container(
                        width: isSmallScreen ? 18 : 28, // 减少图标容器大小
                        height: isSmallScreen ? 18 : 28,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          phaseIcon,
                          color: primaryColor,
                          size: isSmallScreen ? 10 : 16, // 大幅减少图标大小
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8), // 减少间距

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
                                fontSize: isSmallScreen ? 7 : 10, // 大幅减少字体
                                fontWeight: FontWeight.w500,
                                height: 1.0, // 控制行高
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!isSmallScreen)
                              const SizedBox(height: 1), // 小屏幕移除间距

                            // 时间显示
                            Text(
                              displayText,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 11 : 16, // 大幅减少字体
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
