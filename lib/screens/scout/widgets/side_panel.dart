import 'package:flutter/material.dart';
import 'package:horus/models/scout_state.dart';
import '../../../providers/scout_state_provider.dart';
import 'custom_button.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';

class SidePanel extends StatelessWidget {
  final bool isLeftPanel;

  const SidePanel({super.key, required this.isLeftPanel});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context).appState;
    final isMode2 = appState.getIsDefensing();

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      final availableHeight = constraints.maxHeight;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.surfacePrimary,
              AppTheme.surfaceSecondary,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
        child: !appState.isStarted
            ? _buildNotStartedView(context)
            : isLeftPanel
                ? _buildLeftPanel(
                    context, appState, isMode2, availableHeight, availableWidth)
                : _buildRightPanel(context, appState, isMode2),
      );
    });
  }

  Widget _buildNotStartedView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
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
            size: 40,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '等待开始',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLeftPanel(BuildContext context, AppState appState, bool isMode2,
      double availableHeight, double availableWidth) {
    if (isMode2) {
      // 防守模式
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomButton(
            id: 'Defense',
            label: 'Defense',
            height: availableHeight * 0.8,
            icon: Icons.shield,
            backgroundColor: AppTheme.warningColor,
            useGradient: true,
            isImportant: true,
          ),
        ],
      );
    } else {
      // 进攻模式 - 添加状态显示
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 顶部状态显示
          _buildRobotStatusDisplay(appState, availableHeight),
          const SizedBox(height: 12),

          // Fail按钮 - 进一步减少高度
          CustomButton(
            id: 'Fail',
            label: 'last coral/algae fail',
            icon: Icons.error_outline,
            height: availableHeight * 0.32, // 从0.35再减少到0.32
            backgroundColor: AppTheme.errorColor,
            useGradient: true,
          ),
          const SizedBox(height: 12),

          // Go Barge按钮
          CustomButton(
            id: 'Go Barge',
            label: 'Go Barge',
            height: availableHeight * 0.16, // 从0.17减少到0.16
            icon: Icons.directions_boat,
            backgroundColor: AppTheme.infoColor,
            useGradient: true,
          ),
          const SizedBox(height: 12),

          // Climb Up按钮
          CustomButton(
            id: 'Climb Up',
            label: 'Climb Up',
            height: availableHeight * 0.16, // 从0.18减少到0.16
            icon: Icons.trending_up,
            backgroundColor: AppTheme.successColor,
            useGradient: true,
            isEnabled: appState.goBarge,
          ),
        ],
      );
    }
  }

  Widget _buildRightPanel(
      BuildContext context, AppState appState, bool isMode2) {
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
              backgroundColor: AppTheme.errorColor,
              useGradient: true,
              isImportant: true,
            ),
          ),

          const SizedBox(height: 16),

          // 底部切换区域
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Defense Mode',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isMode2,
                  onChanged: (_) => appStateProvider.toggleMode(),
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
          // L4-L1 按钮
          ..._buildLevelButtons(appState),

          const SizedBox(height: 16),

          // 底部：Reef Algae按钮和模式切换
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
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
                    height: 50,
                  ),
                ),

                const SizedBox(width: 12),

                // 模式切换
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'O/D',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: isMode2,
                      onChanged: (_) => appStateProvider.toggleMode(),
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

  List<Widget> _buildLevelButtons(AppState appState) {
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
          padding:
              EdgeInsets.only(bottom: index == levels.length - 1 ? 0 : 8.0),
          child: CustomButton(
            key: ValueKey('${level}_$isEnabled'), // 添加key提高重建效率
            id: level,
            label: level,
            backgroundColor: colors[index],
            textColor: Colors.white,
            width: double.infinity,
            isEnabled: isEnabled,
            useGradient: true,
            icon: _getLevelIcon(level),
          ),
        ),
      );
    }).toList();
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

  // 构建机器人状态显示
  Widget _buildRobotStatusDisplay(AppState appState, double availableHeight) {
    return Container(
      height: availableHeight * 0.18, // 增加到18%的高度
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.surfaceSecondary,
            AppTheme.surfacePrimary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
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
          // 标题 - 更醒目
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '🤖 机器人状态',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

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
                ),

                // 分隔线
                Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(1)),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                ),

                // Coral状态 - 桶装
                _buildStatusIndicator(
                  label: 'Coral',
                  hasItem: appState.hasCoral,
                  icon: Icons.inventory, // 更清晰的桶状图标
                  activeColor: AppTheme.errorColor, // 使用红色，更符合珊瑚
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建单个状态指示器
  Widget _buildStatusIndicator({
    required String label,
    required bool hasItem,
    required IconData icon,
    required Color activeColor,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: hasItem ? activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
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
                  width: 32,
                  height: 32,
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
                  size: 18,
                  color: hasItem ? activeColor : AppTheme.textDisabled,
                ),

                // 状态指示点
                if (hasItem)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
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

            const SizedBox(height: 4),

            // 标签和状态文字
            Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: hasItem ? activeColor : AppTheme.textDisabled,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hasItem ? '✓ 有' : '✗ 无',
                  style: TextStyle(
                    color: hasItem ? activeColor : AppTheme.textDisabled,
                    fontSize: 8,
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
