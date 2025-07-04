import 'package:flutter/material.dart';
import 'package:horus/models/action.dart';
import 'package:horus/models/action_constants.dart';
import 'package:provider/provider.dart';
import '../../../providers/scout_state_provider.dart';
import '../../../theme/app_theme.dart';

@Deprecated('Deprecated')
class AlgaeScoreMenuDialog extends StatefulWidget {
  final int timestamp; // 长按开始的时间戳

  const AlgaeScoreMenuDialog({
    super.key,
    required this.timestamp,
  });

  @override
  State<AlgaeScoreMenuDialog> createState() => _AlgaeScoreMenuDialogState();
}

class _AlgaeScoreMenuDialogState extends State<AlgaeScoreMenuDialog>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 1200;

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
                width: isSmallScreen ? screenSize.width * 0.8 : 400,
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
                    color: AppTheme.primaryColor.withOpacity(0.3),
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
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_soccer,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Net Score 类型选择',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 说明文字
                    Text(
                      '请选择具体的得分类型：',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 选项按钮
                    Row(
                      children: [
                        // 普通 Net
                        Expanded(
                          child: _buildOptionButton(
                            label: 'Net',
                            subtitle: '普通得分',
                            icon: Icons.sports_soccer,
                            color: AppTheme.primaryColor,
                            onPressed: () => _selectOption(AlgaeScoreTypes.net),
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 战术
                        Expanded(
                          child: _buildOptionButton(
                            label: '战术',
                            subtitle: 'Tactical',
                            icon: Icons.psychology,
                            color: AppTheme.warningColor,
                            onPressed: () =>
                                _selectOption(AlgaeScoreTypes.tactical),
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 射球
                        Expanded(
                          child: _buildOptionButton(
                            label: '射球',
                            subtitle: 'Shooting',
                            icon: Icons.gps_fixed,
                            color: AppTheme.errorColor,
                            onPressed: () =>
                                _selectOption(AlgaeScoreTypes.shooting),
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 取消按钮
                    SizedBox(
                      width: double.infinity,
                      child: _buildActionButton(
                        label: '取消',
                        icon: Icons.cancel,
                        color: AppTheme.textSecondary,
                        onPressed: () => Navigator.of(context).pop(),
                        isSmallScreen: isSmallScreen,
                      ),
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

  Widget _buildOptionButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required bool isSmallScreen,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // 图标
              Container(
                width: isSmallScreen ? 40 : 50,
                height: isSmallScreen ? 40 : 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: isSmallScreen ? 20 : 25,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              // 文字
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: color.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
          height: isSmallScreen ? 45 : 50,
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
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: isSmallScreen ? 18 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
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

  void _selectOption(String algaeType) {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);

    // 创建 score algae 动作
    final action = ScoutingAction.scoreAlgae(
      algaeType,
      true, // success为true
      timestamp: widget.timestamp, // 使用长按开始的时间戳
    );

    // 记录动作
    appStateProvider.addAction(action);

    // 设置hasAlgae为false，因为已经得分了
    appStateProvider.appState.hasAlgae = false;

    // 关闭对话框
    Navigator.of(context).pop();
  }
}
