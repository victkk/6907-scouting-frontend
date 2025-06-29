import 'package:flutter/material.dart';

class TriangularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Widget? child;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  const TriangularButton({
    super.key,
    required this.onPressed,
    this.color = Colors.blue,
    this.child,
    this.size = 100,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // 主要三角形按钮和点击效果
          ClipPath(
            clipper: TriangleClipper(),
            child: Material(
              color: color,
              child: InkWell(
                onTap: onPressed,
                // containedInkWell: true, // 确保水波纹效果限制在三角形内
                // highlightShape: BoxShape.rectangle,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Center(child: child),
                ),
              ),
            ),
          ),

          // 可选边框
          if (borderColor != null)
            CustomPaint(
              size: Size(size, size),
              painter: TriangleBorderPainter(
                color: borderColor!,
                strokeWidth: borderWidth,
              ),
            ),
        ],
      ),
    );
  }
}

// 定义三角形裁剪器
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0); // 顶部中心
    path.lineTo(size.width, size.height); // 右下角
    path.lineTo(0, size.height); // 左下角
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// 绘制三角形边框
class TriangleBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  TriangleBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    path.moveTo(size.width / 2, 0); // 顶部中心
    path.lineTo(size.width, size.height); // 右下角
    path.lineTo(0, size.height); // 左下角
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TriangleBorderPainter oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}
