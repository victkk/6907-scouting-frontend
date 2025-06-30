import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 添加触觉反馈和音效支持
import '../../../providers/scout_state_provider.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String id;
  final String label;
  final IconData? icon;
  final VoidCallback? onPressedCallback;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final double? width;
  final double? height;
  final bool isEnabled;
  final bool useGradient;
  final bool isImportant;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;

  const CustomButton({
    super.key,
    required this.id,
    required this.label,
    this.icon,
    this.onPressedCallback,
    this.backgroundColor,
    this.textColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.width,
    this.height,
    this.isEnabled = true,
    this.useGradient = false,
    this.isImportant = false,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _rippleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.93,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 0.4,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (!widget.isEnabled) {
      return widget.disabledBackgroundColor ?? AppTheme.textDisabled;
    }

    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    if (widget.isImportant) {
      return AppTheme.accentColor;
    }

    return AppTheme.primaryColor;
  }

  Color _getTextColor() {
    if (!widget.isEnabled) {
      return widget.disabledTextColor ?? AppTheme.textDisabled;
    }

    return widget.textColor ?? AppTheme.textPrimary;
  }

  // 获取按压时的背景颜色
  Color _getPressedBackgroundColor() {
    if (!widget.isEnabled) {
      return widget.disabledBackgroundColor ?? AppTheme.textDisabled;
    }

    final baseColor = widget.backgroundColor ??
        (widget.isImportant ? AppTheme.accentColor : AppTheme.primaryColor);

    // 按压时使用更深的颜色
    return Color.lerp(baseColor, Colors.black, 0.2) ?? baseColor;
  }

  // 获取按压时的文字颜色
  Color _getPressedTextColor() {
    if (!widget.isEnabled) {
      return widget.disabledTextColor ?? AppTheme.textDisabled;
    }

    // 按压时文字稍微变亮一点
    final baseColor = widget.textColor ?? AppTheme.textPrimary;
    return Color.lerp(baseColor, Colors.white, 0.2) ?? baseColor;
  }

  void _handleTapDown() {
    if (!widget.isEnabled) return;

    setState(() => _isPressed = true);
    _animationController.forward();
    _rippleController.forward();

    // 增强的触觉反馈
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // 音效反馈
    if (widget.enableSoundFeedback) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _handleTapUp() {
    if (!widget.isEnabled) return;

    setState(() => _isPressed = false);
    _animationController.reverse();

    // 延迟重置涟漪效果
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _rippleController.reset();
      }
    });
  }

  void _handleTap() {
    if (!widget.isEnabled) return;

    // 额外的触觉反馈
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    if (widget.onPressedCallback != null) {
      widget.onPressedCallback!();
    }
    // 记录按钮按下的信息
    Provider.of<AppStateProvider>(context, listen: false)
        .recordButtonPress(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 4000; // 判断是否为小屏幕

    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _rippleController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80), // 更快的状态变化响应
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(isSmallScreen ? 8 : 16), // 进一步减少圆角
              boxShadow: widget.isEnabled
                  ? [
                      BoxShadow(
                        color: _getBackgroundColor()
                            .withOpacity(0.4 * _shadowAnimation.value),
                        blurRadius: (isSmallScreen ? 8 : 16) *
                            _shadowAnimation.value, // 增强阴影
                        spreadRadius: 2 * _shadowAnimation.value,
                        offset: Offset(
                            0,
                            (isSmallScreen ? 4 : 8) *
                                _elevationAnimation.value), // 增强偏移
                      ),
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.15 * _shadowAnimation.value),
                        blurRadius: (isSmallScreen ? 6 : 12) *
                            _shadowAnimation.value, // 增强阴影
                        offset: Offset(
                            0,
                            (isSmallScreen ? 2 : 4) *
                                _elevationAnimation.value), // 增强偏移
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
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // 主按钮容器 - 整个区域可点击
                  InkWell(
                    onTap: _handleTap,
                    onTapDown: (_) => _handleTapDown(),
                    onTapUp: (_) => _handleTapUp(),
                    onTapCancel: _handleTapUp,
                    borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 16), // 进一步减少圆角
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 40), // 更快的颜色变化
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: widget.useGradient && widget.isEnabled
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _isPressed
                                    ? widget.isImportant
                                        ? [
                                            Color.lerp(AppTheme.accentColor,
                                                Colors.black, 0.25)!,
                                            Color.lerp(AppTheme.accentDark,
                                                Colors.black, 0.25)!
                                          ]
                                        : [
                                            Color.lerp(AppTheme.primaryColor,
                                                Colors.black, 0.25)!,
                                            Color.lerp(AppTheme.primaryDark,
                                                Colors.black, 0.25)!
                                          ]
                                    : widget.isImportant
                                        ? [
                                            AppTheme.accentColor,
                                            AppTheme.accentDark
                                          ]
                                        : [
                                            AppTheme.primaryColor,
                                            AppTheme.primaryDark
                                          ],
                              )
                            : null,
                        color: widget.useGradient
                            ? null
                            : _isPressed
                                ? _getPressedBackgroundColor()
                                : _getBackgroundColor(),
                        borderRadius: BorderRadius.circular(
                            isSmallScreen ? 8 : 16), // 进一步减少圆角
                        border: Border.all(
                          color: widget.isEnabled
                              ? (_isPressed
                                  ? Colors.white.withOpacity(0.6)
                                  : _getBackgroundColor().withOpacity(0.3))
                              : AppTheme.borderColor,
                          width: _isPressed ? 2.5 : 1.0, // 按压时加粗边框并变色
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 6 : 16, // 进一步减少padding
                            vertical: isSmallScreen ? 4 : 12), // 进一步减少padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 60),
                                transform: Matrix4.identity()
                                  ..scale(_isPressed ? 0.9 : 1.0),
                                child: Icon(
                                  widget.icon,
                                  color: _isPressed
                                      ? _getPressedTextColor()
                                      : _getTextColor(),
                                  size: isSmallScreen ? 12 : 20, // 进一步减少图标大小
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 3 : 8), // 进一步减少间距
                            ],
                            Flexible(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 60),
                                style: TextStyle(
                                  color: _isPressed
                                      ? _getPressedTextColor()
                                      : _getTextColor(),
                                  fontSize: isSmallScreen ? 9 : 14, // 进一步减少字体大小
                                  fontWeight: FontWeight.w600,
                                  shadows: _isPressed
                                      ? [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 3,
                                            offset: const Offset(1, 1),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  widget.label,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: isSmallScreen ? 1 : 2, // 小屏幕只显示一行
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 按压反馈叠加层 - 更明显的点击效果
                  if (_isPressed)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(isSmallScreen ? 8 : 16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 80),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.0,
                            ),
                            borderRadius:
                                BorderRadius.circular(isSmallScreen ? 8 : 16),
                          ),
                        ),
                      ),
                    ),

                  // 涟漪效果覆盖层
                  if (_rippleAnimation.value > 0)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(isSmallScreen ? 8 : 16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: _rippleAnimation.value,
                              colors: [
                                Colors.white.withOpacity(
                                    0.4 * (1 - _rippleAnimation.value)),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
