import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 增强按钮包装器 - 为Flutter标准按钮添加强化的点击反馈
class EnhancedButtonWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;
  final bool enableScaleAnimation;
  final double scaleValue;
  final Duration animationDuration;

  const EnhancedButtonWrapper({
    super.key,
    required this.child,
    this.onPressed,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
    this.enableScaleAnimation = true,
    this.scaleValue = 0.95,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  State<EnhancedButtonWrapper> createState() => _EnhancedButtonWrapperState();
}

class _EnhancedButtonWrapperState extends State<EnhancedButtonWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
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

  void _handleTapDown() {
    if (widget.onPressed == null) return;

    if (widget.enableScaleAnimation) {
      _animationController.forward();
    }

    // 触觉反馈
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // 音效反馈
    if (widget.enableSoundFeedback) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _handleTapUp() {
    if (widget.onPressed == null) return;

    if (widget.enableScaleAnimation) {
      _animationController.reverse();
    }
  }

  void _handleTap() {
    if (widget.onPressed == null) return;

    // 额外的触觉反馈
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: _handleTapUp,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.enableScaleAnimation ? _scaleAnimation.value : 1.0,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// 增强版ElevatedButton
class EnhancedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;

  const EnhancedElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
  });

  factory EnhancedElevatedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    ButtonStyle? style,
    bool enableHapticFeedback = true,
    bool enableSoundFeedback = true,
  }) {
    return EnhancedElevatedButton(
      key: key,
      onPressed: onPressed,
      style: style,
      enableHapticFeedback: enableHapticFeedback,
      enableSoundFeedback: enableSoundFeedback,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon, const SizedBox(width: 8), label],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedButtonWrapper(
      onPressed: onPressed,
      enableHapticFeedback: enableHapticFeedback,
      enableSoundFeedback: enableSoundFeedback,
      child: ElevatedButton(
        onPressed: null, // 让包装器处理点击
        style: style,
        child: child,
      ),
    );
  }
}

/// 增强版TextButton
class EnhancedTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;

  const EnhancedTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedButtonWrapper(
      onPressed: onPressed,
      enableHapticFeedback: enableHapticFeedback,
      enableSoundFeedback: enableSoundFeedback,
      child: TextButton(
        onPressed: null, // 让包装器处理点击
        style: style,
        child: child,
      ),
    );
  }
}

/// 增强版IconButton
class EnhancedIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final double? iconSize;
  final Color? color;
  final String? tooltip;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;

  const EnhancedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.color,
    this.tooltip,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedButtonWrapper(
      onPressed: onPressed,
      enableHapticFeedback: enableHapticFeedback,
      enableSoundFeedback: enableSoundFeedback,
      scaleValue: 0.9, // IconButton使用更强的缩放效果
      child: IconButton(
        onPressed: null, // 让包装器处理点击
        icon: icon,
        iconSize: iconSize,
        color: color,
        tooltip: tooltip,
      ),
    );
  }
}

/// 增强版FloatingActionButton
class EnhancedFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool mini;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;

  const EnhancedFloatingActionButton({
    super.key,
    required this.onPressed,
    this.child,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.mini = false,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
  });

  factory EnhancedFloatingActionButton.extended({
    Key? key,
    required VoidCallback? onPressed,
    Widget? icon,
    required Widget label,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
    bool enableHapticFeedback = true,
    bool enableSoundFeedback = true,
  }) {
    return EnhancedFloatingActionButton(
      key: key,
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      enableHapticFeedback: enableHapticFeedback,
      enableSoundFeedback: enableSoundFeedback,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon, const SizedBox(width: 8)],
          label,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedButtonWrapper(
      onPressed: onPressed,
      enableHapticFeedback: enableHapticFeedback,
      enableSoundFeedback: enableSoundFeedback,
      scaleValue: 0.92, // FAB使用中等的缩放效果
      child: FloatingActionButton(
        onPressed: null, // 让包装器处理点击
        tooltip: tooltip,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        mini: mini,
        child: child,
      ),
    );
  }
}
