import 'package:flutter/material.dart';
import 'package:horus/models/action.dart';
import 'package:provider/provider.dart';
import '../../../providers/scout_state_provider.dart';
import '../../../theme/app_theme.dart';

@Deprecated('Deprecated')
class ScoreCoralDetailDialog extends StatefulWidget {
  final String level; // L1, L2, L3, L4
  final int timestamp; // 长按开始的时间戳

  const ScoreCoralDetailDialog({
    super.key,
    required this.level,
    required this.timestamp,
  });

  @override
  State<ScoreCoralDetailDialog> createState() => _ScoreCoralDetailDialogState();
}

class _ScoreCoralDetailDialogState extends State<ScoreCoralDetailDialog>
    with TickerProviderStateMixin {
  bool _stacking = false;
  bool _scraping = false;
  bool _defended = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getLevelColor() {
    switch (widget.level) {
      case 'L4':
        return AppTheme.errorColor;
      case 'L3':
        return AppTheme.warningColor;
      case 'L2':
        return AppTheme.infoColor;
      case 'L1':
        return AppTheme.successColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 4000;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: isSmallScreen ? screenSize.width * 0.9 : 500,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.surfacePrimary,
                      AppTheme.surfaceSecondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getLevelColor().withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getLevelColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getLevelColor().withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.settings,
                          //   color: _getLevelColor(),
                          //   size: 28,
                          // ),
                          const SizedBox(width: 12),
                          Text(
                            '${widget.level} Score Coral 详细设置',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: _getLevelColor(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 三个横向排列的checkbox
                    Row(
                      children: [
                        Expanded(
                          child: _buildGiantCheckbox(
                            label: '叠筒',
                            subtitle: 'Stacking',
                            value: _stacking,
                            onChanged: (value) =>
                                setState(() => _stacking = value),
                            icon: Icons.layers,
                            color: AppTheme.primaryColor,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGiantCheckbox(
                            label: '刮球',
                            subtitle: 'Scraping',
                            value: _scraping,
                            onChanged: (value) =>
                                setState(() => _scraping = value),
                            icon: Icons.cleaning_services,
                            color: AppTheme.warningColor,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildGiantCheckbox(
                            label: '被防守',
                            subtitle: 'Defended',
                            value: _defended,
                            onChanged: (value) =>
                                setState(() => _defended = value),
                            icon: Icons.shield,
                            color: AppTheme.errorColor,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 操作按钮
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            label: '取消',
                            icon: Icons.cancel,
                            color: AppTheme.textSecondary,
                            onPressed: () => Navigator.of(context).pop(),
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _buildActionButton(
                            label: '提交设置',
                            icon: Icons.check_circle,
                            color: _getLevelColor(),
                            onPressed: _submitSettings,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGiantCheckbox({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
    required bool isSmallScreen,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: value
                    ? [
                        color.withOpacity(0.2),
                        color.withOpacity(0.1),
                      ]
                    : [
                        AppTheme.surfaceSecondary,
                        AppTheme.surfacePrimary,
                      ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value ? color : AppTheme.borderColor,
                width: value ? 2 : 1,
              ),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                // AnimatedContainer(
                //   duration: const Duration(milliseconds: 200),
                //   width: isSmallScreen ? 40 : 50,
                //   height: isSmallScreen ? 40 : 50,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color:
                //         value ? color : AppTheme.textDisabled.withOpacity(0.3),
                //     boxShadow: value
                //         ? [
                //             BoxShadow(
                //               color: color.withOpacity(0.4),
                //               blurRadius: 8,
                //               spreadRadius: 2,
                //             ),
                //           ]
                //         : null,
                //   ),
                //   child: Icon(
                //     icon,
                //     size: isSmallScreen ? 20 : 25,
                //     color: value ? Colors.white : AppTheme.textDisabled,
                //   ),
                // ),

                const SizedBox(height: 8),

                // 文字
                Column(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: value ? color : AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: value
                            ? color.withOpacity(0.8)
                            : AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 复选框
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSmallScreen ? 24 : 30,
                  height: isSmallScreen ? 24 : 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? color : Colors.transparent,
                    border: Border.all(
                      color: value ? color : AppTheme.borderColor,
                      width: 2,
                    ),
                    boxShadow: value
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: value
                      ? Icon(
                          Icons.check,
                          size: isSmallScreen ? 16 : 20,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required bool isSmallScreen,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: isSmallScreen ? 50 : 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: isSmallScreen ? 20 : 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitSettings() {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);
    final appState = appStateProvider.appState;

    // 创建score coral动作
    final action = ScoutingAction.scoreCoral(
      widget.level, // coral type，这里可以根据实际需要调整
      appState.faceSelected, // 使用当前选择的face
      true, // success为true，因为用户能进入详细设置说明操作成功
      timestamp: widget.timestamp, // 使用长按开始的时间戳
      //   stacking: _stacking,
      //   scraping: _scraping,
      //   defended: _defended,
    );

    // 记录动作
    appStateProvider.addAction(action);

    // 关闭对话框
    Navigator.of(context).pop();
  }
}
