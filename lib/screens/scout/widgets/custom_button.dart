import 'package:flutter/material.dart';
import '../../../providers/scout_state_provider.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
          disabledForegroundColor:
              disabledBackgroundColor ?? Colors.grey.shade300,
          disabledBackgroundColor: disabledTextColor ?? Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: isEnabled
            ? () {
                if (onPressedCallback != null) {
                  onPressedCallback!();
                }
                // 记录按钮按下的信息
                Provider.of<AppStateProvider>(context, listen: false)
                    .recordButtonPress(id);
              }
            : null,
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) Icon(icon),
            if (icon != null) const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
