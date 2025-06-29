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
    final buttonList = isMode2
        ? [
            CustomButton(
              id: 'Defense',
              label: 'Defense',
              height: availableHeight * 0.8,
              icon: Icons.shield,
              backgroundColor: AppTheme.warningColor,
              useGradient: true,
              isImportant: true,
            ),
          ]
        : [
            CustomButton(
              id: 'Fail',
              label: 'last coral/algae fail',
              icon: Icons.error_outline,
              height: availableHeight * 0.54,
              backgroundColor: AppTheme.errorColor,
              useGradient: true,
            ),
            const SizedBox(height: 12),
            CustomButton(
              id: 'Go Barge',
              label: 'Go Barge',
              height: availableHeight * 0.17,
              icon: Icons.directions_boat,
              backgroundColor: AppTheme.infoColor,
              useGradient: true,
            ),
            const SizedBox(height: 12),
            CustomButton(
              id: 'Climb Up',
              label: 'Climb Up',
              height: availableHeight * 0.18,
              icon: Icons.trending_up,
              backgroundColor: AppTheme.successColor,
              useGradient: true,
              isEnabled: appState.goBarge,
            ),
          ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttonList,
    );
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
    final isEnabled = appState.hasCoral && (appState.faceSelected > -1);

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
}
