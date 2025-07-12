import 'package:flutter/material.dart';
import 'widgets/center_image.dart';
import 'widgets/side_panel.dart';
import 'widgets/timer_display.dart';
import 'package:horus/pages/action_timeline_page.dart';
import 'package:provider/provider.dart';
import '../../providers/scout_state_provider.dart';
import '../../models/scout_state.dart';
import '../../theme/app_theme.dart';

class LandscapeScreen extends StatelessWidget {
  const LandscapeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = true; // 判断是否为小屏幕

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Consumer<AppStateProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                // 主要界面 - 完全占满整个屏幕
                _buildMainContent(context, screenSize, isSmallScreen),

                // 当处于等待手动阶段时，显示teleopStart按键
                if (provider.getCurrentPhase() == GamePhase.waitingTeleop)
                  _buildTeleopStartOverlay(context, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context, Size screenSize, bool isSmallScreen) {
    // 为手机屏幕优化的布局比例 - 增加侧边栏的宽度
    final double leftPanelRatio = isSmallScreen ? 0.28 : 0.2;
    final double rightPanelRatio = isSmallScreen ? 0.28 : 0.2;

    // 进一步减少手机屏幕上的间距
    final double margin = isSmallScreen ? 3.0 : 12.0;
    final double borderRadius = isSmallScreen ? 8.0 : 20.0;

    return Row(
      children: [
        // 左侧面板
        Container(
          width: screenSize.width * leftPanelRatio,
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            color: AppTheme.surfacePrimary,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: isSmallScreen ? 6.0 : 15.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const SidePanel(isLeftPanel: true),
        ),

        // 中心区域
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: margin),
            decoration: BoxDecoration(
              color: AppTheme.surfacePrimary,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: isSmallScreen ? 6.0 : 15.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const CenterImage(),
          ),
        ),

        // 右侧面板
        Container(
          width: screenSize.width * rightPanelRatio,
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            color: AppTheme.surfacePrimary,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: isSmallScreen ? 6.0 : 15.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const SidePanel(isLeftPanel: false),
        ),
      ],
    );
  }

  Widget _buildTeleopStartOverlay(
      BuildContext context, AppStateProvider provider) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 4000;

    // 为小屏幕调整覆盖层按钮的大小
    final double buttonWidth = isSmallScreen ? 250 : 400;
    final double buttonHeight = isSmallScreen ? 120 : 200;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(isSmallScreen ? 8.0 : 20.0),
      ),
      child: Center(
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            gradient: AppTheme.accentGradient,
            borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withOpacity(0.5),
                blurRadius: isSmallScreen ? 15 : 30,
                offset: Offset(0, isSmallScreen ? 8 : 15),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                provider.startTeleopPhase();
                provider.recordButtonPress('Teleop Start');
              },
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      size: isSmallScreen ? 32 : 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 16),
                    Text(
                      'teleopStart',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 18 : 32,
                          ),
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 8),
                    Text(
                      '点击开始手动操作阶段',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isSmallScreen ? 10 : 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
