import 'package:flutter/material.dart';
import 'package:horus/models/scout_state.dart';
import '../../../providers/scout_state_provider.dart';
import 'custom_button.dart';
import 'timer_display.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import 'package:horus/pages/action_timeline_page.dart';
import 'score_coral_detail_dialog.dart';
import 'climb_result_menu_dialog.dart';

class SidePanel extends StatelessWidget {
  final bool isLeftPanel;

  const SidePanel({super.key, required this.isLeftPanel});

  /// 显示爬升结果菜单
  void _showClimbResultMenu(BuildContext context) {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);
    final timestamp = appStateProvider.appState.getRelativeTimestamp();

    showDialog(
      context: context,
      builder: (context) => ClimbResultMenuDialog(
        timestamp: timestamp,
        onActionAdded: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context).appState;
    final isMode2 = appState.getIsDefensing();
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 4000; // 判断是否为小屏幕

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      final availableHeight = constraints.maxHeight;
      return Container(
        padding: EdgeInsets.all(isSmallScreen ? 6 : 20), // 大幅减少padding
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.surfacePrimary,
              AppTheme.surfaceSecondary,
            ],
          ),
          borderRadius:
              BorderRadius.circular(isSmallScreen ? 8 : 20), // 小屏幕减少圆角
          border: Border.all(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
        child: !appState.isStarted
            ? _buildNotStartedView(context, isSmallScreen)
            : isLeftPanel
                ? _buildLeftPanel(context, appState, isMode2, availableHeight,
                    availableWidth, isSmallScreen)
                : _buildRightPanel(context, appState, isMode2, isSmallScreen),
      );
    });
  }

  Widget _buildNotStartedView(BuildContext context, bool isSmallScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isSmallScreen ? 50 : 80, // 小屏幕进一步减少图标尺寸
          height: isSmallScreen ? 50 : 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.surfaceSecondary,
            border: Border.all(
              color: AppTheme.borderColor,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.hourglass_empty,
            size: isSmallScreen ? 25 : 40,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 16),
        Text(
          '等待开始',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: isSmallScreen ? 12 : 16, // 小屏幕减少字体大小
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLeftPanel(BuildContext context, AppState appState, bool isMode2,
      double availableHeight, double availableWidth, bool isSmallScreen) {
    if (isMode2) {
      // 防守模式
      return Column(
        children: [
          // 顶部紧凑的计时器和时间线控制 - 在小屏幕下平分高度
          if (isSmallScreen)
            Expanded(
              child: _buildCompactControls(context, isSmallScreen),
            ),
          if (isSmallScreen) SizedBox(height: 4), // 最小间距

          // Defense按钮撑满剩余空间
          Expanded(
            child: CustomButton(
              id: 'Defense',
              label: 'Defense',
              height: double.infinity,
              icon: Icons.shield,
              backgroundColor: AppTheme.warningColor,
              useGradient: true,
              isImportant: true,
            ),
          ),
        ],
      );
    } else {
      // 进攻模式 - 紧凑布局
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 顶部紧凑的计时器和时间线控制 - 在小屏幕下平分高度
          if (isSmallScreen)
            Expanded(
              child: _buildCompactControls(context, isSmallScreen),
            ),
          if (isSmallScreen) SizedBox(height: 4), // 最小间距

          // 机器人状态显示 - 在小屏幕下平分高度
          if (isSmallScreen)
            Expanded(
              child: _buildRobotStatusDisplay(
                  appState, availableHeight, isSmallScreen),
            )
          else
            _buildRobotStatusDisplay(appState, availableHeight, isSmallScreen),
          SizedBox(height: isSmallScreen ? 4 : 12), // 最小间距

          // Fail按钮 - 在小屏幕下平分高度
          if (isSmallScreen)
            Expanded(
              child: CustomButton(
                id: 'Fail',
                label: 'last coral/algae fail',
                icon: Icons.error_outline,
                height: double.infinity,
                width: double.infinity, // 撑满宽度
                backgroundColor: AppTheme.errorColor,
                useGradient: true,
              ),
            )
          else
            CustomButton(
              id: 'Fail',
              label: 'last coral/algae fail',
              icon: Icons.error_outline,
              height: availableHeight * 0.32,
              width: double.infinity, // 撑满宽度
              backgroundColor: AppTheme.errorColor,
              useGradient: true,
            ),
          SizedBox(height: isSmallScreen ? 4 : 12), // 最小间距

          // Give Up按钮 - 在小屏幕下平分高度
          if (isSmallScreen)
            Expanded(
              child: CustomButton(
                id: 'Give Up',
                label: 'Give Up',
                height: double.infinity,
                width: double.infinity, // 撑满宽度
                icon: Icons.directions_boat,
                backgroundColor: AppTheme.infoColor,
                useGradient: true,
              ),
            )
          else
            CustomButton(
              id: 'Give Up',
              label: 'Give Up',
              height: availableHeight * 0.16,
              width: double.infinity, // 撑满宽度
              icon: Icons.directions_boat,
              backgroundColor: AppTheme.infoColor,
              useGradient: true,
            ),
          SizedBox(height: isSmallScreen ? 4 : 12), // 最小间距

          // Climb Up按钮 - 在小屏幕下平分高度
          if (isSmallScreen)
            Expanded(
              child: CustomButton(
                id: 'Climb Up',
                label: 'Climb Up',
                height: double.infinity,
                width: double.infinity, // 撑满宽度
                icon: Icons.trending_up,
                backgroundColor: AppTheme.successColor,
                useGradient: true,
                isEnabled: appState.giveUp,
                onLongPressCallback: () => _showClimbResultMenu(context),
              ),
            )
          else
            CustomButton(
              id: 'Climb Up',
              label: 'Climb Up',
              height: availableHeight * 0.16,
              width: double.infinity, // 撑满宽度
              icon: Icons.trending_up,
              backgroundColor: AppTheme.successColor,
              useGradient: true,
              isEnabled: appState.giveUp,
              onLongPressCallback: () => _showClimbResultMenu(context),
            ),
        ],
      );
    }
  }

  Widget _buildRightPanel(BuildContext context, AppState appState, bool isMode2,
      bool isSmallScreen) {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);

    if (isMode2) {
      // 模式2布局 - 防守模式
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Foul按钮占据主要空间
          Expanded(
            flex: 4,
            child: CustomButton(
              id: 'Foul',
              label: 'Foul',
              icon: Icons.warning,
              height: double.infinity,
              width: double.infinity, // 撑满宽度
              backgroundColor: AppTheme.errorColor,
              useGradient: true,
              isImportant: true,
            ),
          ),

          SizedBox(height: isSmallScreen ? 8 : 16), // 减少间距

          // 底部切换区域
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 16), // 减少padding
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius:
                  BorderRadius.circular(isSmallScreen ? 6 : 12), // 减少圆角
              border: Border.all(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '防守模式',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: isSmallScreen ? 10 : 14, // 减少字体
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Defense Mode',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: isSmallScreen ? 8 : 12, // 减少字体
                      ),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: isSmallScreen ? 0.8 : 1.0, // 小屏幕缩小开关
                  child: Switch(
                    value: isMode2,
                    onChanged: (_) => appStateProvider.toggleMode(),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // 模式1布局 - 进攻模式
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // L4-L1 按钮 - 减少间距
          ..._buildLevelButtons(context, appState, isSmallScreen),

          SizedBox(height: isSmallScreen ? 8 : 16), // 减少间距

          // 底部：Reef Algae按钮和模式切换
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12), // 减少padding
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius:
                  BorderRadius.circular(isSmallScreen ? 8 : 12), // 减少圆角
              border: Border.all(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Reef Algae 按钮
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    id: 'Reef Algae',
                    label: 'Reef Algae',
                    icon: Icons.eco,
                    backgroundColor: AppTheme.successColor,
                    height: isSmallScreen ? 40 : 50, // 减少高度
                    width: double.infinity, // 撑满宽度
                  ),
                ),

                SizedBox(width: isSmallScreen ? 8 : 12), // 减少间距

                // 模式切换
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'O/D',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: isSmallScreen ? 10 : 12, // 减少字体
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Transform.scale(
                      scale: isSmallScreen ? 0.8 : 1.0, // 小屏幕缩小开关
                      child: Switch(
                        value: isMode2,
                        onChanged: (_) => appStateProvider.toggleMode(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  // 紧凑的计时器和时间线控制 - 新增方法
  Widget _buildCompactControls(BuildContext context, bool isSmallScreen) {
    return Container(
      height: isSmallScreen ? double.infinity : 45, // 小屏幕时由Expanded控制高度
      decoration: BoxDecoration(
        color: AppTheme.surfaceSecondary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor, width: 1),
      ),
      child: Row(
        children: [
          // 紧凑的计时器显示
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: const TimerDisplay(),
            ),
          ),

          // 分隔线
          Container(
            width: 1,
            height: double.infinity,
            color: AppTheme.borderColor,
            margin: EdgeInsets.symmetric(vertical: 4),
          ),

          // 紧凑的时间线按钮
          Expanded(
            flex: 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ActionTimelinePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          )),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: double.infinity, // 竖向撑满
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center, // 垂直居中
                    children: [
                      Icon(
                        Icons.timeline,
                        size: isSmallScreen ? 14 : 16,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '时间线',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 9 : 11,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLevelButtons(
      BuildContext context, AppState appState, bool isSmallScreen) {
    final levels = ['L4', 'L3', 'L2', 'L1'];
    final colors = [
      AppTheme.errorColor, // L4 - 红色，最高级别
      AppTheme.warningColor, // L3 - 橙色
      AppTheme.infoColor, // L2 - 蓝色
      AppTheme.successColor, // L1 - 绿色，最低级别
    ];

    // 提前计算isEnabled，避免在每个按钮中重复计算
    final isEnabled = appState.hasCoral && (appState.faceSelected > 0);

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;

      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: index == levels.length - 1
                  ? 0
                  : (isSmallScreen ? 4.0 : 8.0)), // 最小间距
          child: CustomButton(
            key: ValueKey('${level}_$isEnabled'), // 添加key提高重建效率
            id: level,
            label: level,
            backgroundColor: colors[index],
            textColor: Colors.white,
            width: double.infinity, // 撑满宽度
            height: double.infinity, // 撑满高度
            isEnabled: isEnabled,
            useGradient: true,
            icon: _getLevelIcon(level),
            onLongPressCallback: isEnabled
                ? () => _showScoreCoralDetailDialog(context, level)
                : null,
          ),
        ),
      );
    }).toList();
  }

  void _showScoreCoralDetailDialog(BuildContext context, String level) {
    final appState =
        Provider.of<AppStateProvider>(context, listen: false).appState;
    final timestamp = appState.getRelativeTimestamp();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ScoreCoralDetailDialog(
          level: level,
          timestamp: timestamp,
        );
      },
    );
  }

  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'L4':
        return Icons.keyboard_double_arrow_up;
      case 'L3':
        return Icons.keyboard_arrow_up;
      case 'L2':
        return Icons.keyboard_arrow_down;
      case 'L1':
        return Icons.keyboard_double_arrow_down;
      default:
        return Icons.circle;
    }
  }

  // 构建机器人状态显示 - 进一步压缩
  Widget _buildRobotStatusDisplay(
      AppState appState, double availableHeight, bool isSmallScreen) {
    return Container(
      height: isSmallScreen
          ? double.infinity
          : availableHeight * 0.18, // 小屏幕时由Expanded控制高度
      padding: EdgeInsets.all(isSmallScreen ? 4 : 10), // 进一步减少padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.surfaceSecondary,
            AppTheme.surfacePrimary,
          ],
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 12), // 减少圆角
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
// 状态指示器
          Expanded(
            child: Row(
              children: [
                // Algae状态 - 球状
                _buildStatusIndicator(
                  label: 'Algae',
                  hasItem: appState.hasAlgae,
                  icon: Icons.sports_soccer, // 更像球的图标
                  activeColor: AppTheme.successColor, // 使用绿色，更符合藻类
                  isSmallScreen: isSmallScreen,
                ),

                // 分隔线
                Container(
                  width: 1,
                  height: isSmallScreen ? 25 : 40, // 减少高度
                  decoration: BoxDecoration(
                      color: AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(1)),
                  margin: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 1 : 4), // 进一步减少间距
                ),

                // Coral状态 - 桶装
                _buildStatusIndicator(
                  label: 'Coral',
                  hasItem: appState.hasCoral,
                  icon: Icons.inventory, // 更清晰的桶状图标
                  activeColor: AppTheme.errorColor, // 使用红色，更符合珊瑚
                  isSmallScreen: isSmallScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建单个状态指示器 - 进一步压缩
  Widget _buildStatusIndicator({
    required String label,
    required bool hasItem,
    required IconData icon,
    required Color activeColor,
    bool isSmallScreen = false,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 2 : 6,
            horizontal: isSmallScreen ? 1 : 4), // 进一步减少padding
        decoration: BoxDecoration(
          color: hasItem ? activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 8), // 减少圆角
          border: Border.all(
            color: hasItem
                ? activeColor.withOpacity(0.5)
                : AppTheme.borderColor.withOpacity(0.3),
            width: hasItem ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 主要状态显示
            Stack(
              alignment: Alignment.center,
              children: [
                // 背景圆圈
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSmallScreen ? 18 : 32, // 进一步减少尺寸
                  height: isSmallScreen ? 18 : 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasItem
                        ? activeColor.withOpacity(0.2)
                        : AppTheme.surfaceSecondary,
                    border: Border.all(
                      color: hasItem ? activeColor : AppTheme.borderColor,
                      width: 2,
                    ),
                    boxShadow: hasItem
                        ? [
                            BoxShadow(
                              color: activeColor.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),

                // 图标
                Icon(
                  icon,
                  size: isSmallScreen ? 10 : 18, // 进一步减少图标大小
                  color: hasItem ? activeColor : AppTheme.textDisabled,
                ),

                // 状态指示点
                if (hasItem)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: isSmallScreen ? 6 : 10, // 减少指示点大小
                      height: isSmallScreen ? 6 : 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withOpacity(0.6),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 1 : 4), // 进一步减少间距

            // 标签和状态文字
            Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: hasItem ? activeColor : AppTheme.textDisabled,
                    fontSize: isSmallScreen ? 6 : 9, // 进一步减少字体
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hasItem ? '✓ 有' : '✗ 无',
                  style: TextStyle(
                    color: hasItem ? activeColor : AppTheme.textDisabled,
                    fontSize: isSmallScreen ? 5 : 8, // 进一步减少字体
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
