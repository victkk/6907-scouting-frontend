import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/action_constants.dart';
import '../../../models/action.dart';
import '../../../providers/scout_state_provider.dart';
import '../../../theme/app_theme.dart';

class ClimbResultMenuDialog extends StatelessWidget {
  final int timestamp;
  final VoidCallback onActionAdded;

  const ClimbResultMenuDialog({
    Key? key,
    required this.timestamp,
    required this.onActionAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? 340 : 400,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
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
                        Icons.elevator,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '爬升结果选择',
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
                  '请选择爬升的结果：',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // 选项按钮
                Row(
                  children: [
                    // 成功
                    Expanded(
                      child: _buildOptionButton(
                        label: '成功',
                        subtitle: 'Success',
                        icon: Icons.check_circle,
                        color: AppTheme.successColor,
                        onPressed: () =>
                            _selectOption(ClimbResults.success, context),
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 失败
                    Expanded(
                      child: _buildOptionButton(
                        label: '失败',
                        subtitle: 'Failure',
                        icon: Icons.cancel,
                        color: AppTheme.errorColor,
                        onPressed: () =>
                            _selectOption(ClimbResults.failure, context),
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 碰链子
                    Expanded(
                      child: _buildOptionButton(
                        label: '碰链子',
                        subtitle: 'Hit Chain',
                        icon: Icons.warning,
                        color: AppTheme.warningColor,
                        onPressed: () =>
                            _selectOption(ClimbResults.hitChain, context),
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

  void _selectOption(String climbResult, BuildContext context) {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);

    // 创建爬升动作
    final action = ScoutingAction.climbUp(
      timestamp: timestamp,
      result: climbResult,
    );

    // 记录动作
    appStateProvider.addAction(action);

    // 关闭对话框
    Navigator.of(context).pop();
  }
}
