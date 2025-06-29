import 'package:flutter/material.dart';

class AppTheme {
  // 主色调 - 使用现代化的深蓝紫色系
  static const Color primaryColor = Color(0xFF2196F3); // 明亮蓝色
  static const Color primaryDark = Color(0xFF1976D2); // 深蓝色
  static const Color primaryLight = Color(0xFF64B5F6); // 浅蓝色

  // 强调色 - 橙色系作为互补色
  static const Color accentColor = Color(0xFFFF9800); // 橙色
  static const Color accentLight = Color(0xFFFFB74D); // 浅橙色
  static const Color accentDark = Color(0xFFF57C00); // 深橙色

  // 背景色系 - 现代化深色主题
  static const Color backgroundPrimary = Color(0xFF0A0E27); // 深蓝黑色
  static const Color backgroundSecondary = Color(0xFF1A1E3A); // 稍浅的深蓝色
  static const Color backgroundTertiary = Color(0xFF2A2E4A); // 中等深蓝色

  // 表面色系
  static const Color surfacePrimary = Color(0xFF1E2139); // 主表面色
  static const Color surfaceSecondary = Color(0xFF2E3147); // 次要表面色

  // 文本色系
  static const Color textPrimary = Color(0xFFFFFFFF); // 主文本
  static const Color textSecondary = Color(0xFFB0BEC5); // 次要文本
  static const Color textDisabled = Color(0xFF607D8B); // 禁用文本

  // 状态色系
  static const Color successColor = Color(0xFF4CAF50); // 成功绿色
  static const Color warningColor = Color(0xFFFF9800); // 警告橙色
  static const Color errorColor = Color(0xFFF44336); // 错误红色
  static const Color infoColor = Color(0xFF2196F3); // 信息蓝色

  // 边框和分割线
  static const Color borderColor = Color(0xFF3E4359);
  static const Color dividerColor = Color(0xFF2E3147);

  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, accentDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundPrimary, backgroundSecondary],
  );

  // 主题数据
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundPrimary,

      // AppBar主题
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundSecondary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // 卡片主题
      cardTheme: CardTheme(
        color: surfacePrimary,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ElevatedButton主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 文本主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Switch主题
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          return textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return accentColor.withOpacity(0.5);
          }
          return surfaceSecondary;
        }),
      ),

      // 输入装饰主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfacePrimary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textDisabled),
      ),
    );
  }

  // 按钮样式辅助方法
  static ButtonStyle primaryButtonStyle({
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    bool gradient = false,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: gradient ? null : primaryColor,
      foregroundColor: textPrimary,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  static ButtonStyle accentButtonStyle({
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  static ButtonStyle successButtonStyle({
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: successColor,
      foregroundColor: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  static ButtonStyle warningButtonStyle({
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: warningColor,
      foregroundColor: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }

  static ButtonStyle errorButtonStyle({
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: errorColor,
      foregroundColor: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }
}
