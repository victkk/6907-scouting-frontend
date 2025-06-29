import 'package:flutter/material.dart';
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
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100), // 加快状态变化响应
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.isEnabled
                  ? [
                      BoxShadow(
                        color: _getBackgroundColor().withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80), // 更快的颜色变化
                decoration: BoxDecoration(
                  gradient: widget.useGradient && widget.isEnabled
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.isImportant
                              ? [AppTheme.accentColor, AppTheme.accentDark]
                              : [AppTheme.primaryColor, AppTheme.primaryDark],
                        )
                      : null,
                  color: widget.useGradient ? null : _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isEnabled
                        ? _getBackgroundColor().withOpacity(0.3)
                        : AppTheme.borderColor,
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: widget.isEnabled
                      ? () {
                          if (widget.onPressedCallback != null) {
                            widget.onPressedCallback!();
                          }
                          // 记录按钮按下的信息
                          Provider.of<AppStateProvider>(context, listen: false)
                              .recordButtonPress(widget.id);
                        }
                      : null,
                  onTapDown: widget.isEnabled
                      ? (_) {
                          setState(() => _isPressed = true);
                          _animationController.forward();
                        }
                      : null,
                  onTapUp: widget.isEnabled
                      ? (_) {
                          setState(() => _isPressed = false);
                          _animationController.reverse();
                        }
                      : null,
                  onTapCancel: widget.isEnabled
                      ? () {
                          setState(() => _isPressed = false);
                          _animationController.reverse();
                        }
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: _getTextColor(),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              color: _getTextColor(),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
      },
    );
  }
}
