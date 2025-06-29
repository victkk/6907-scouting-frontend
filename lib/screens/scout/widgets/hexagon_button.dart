import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HexagonalButtonGroup extends StatelessWidget {
  final double size;
  final List<VoidCallback> onPressed;
  final List<Color> colors;
  final List<Widget?> children;
  final List<Color?> borderColors;
  final double borderWidth;
  final double childPositionFactor;

  const HexagonalButtonGroup({
    super.key,
    required this.size,
    required this.onPressed,
    required this.colors,
    this.children = const [null, null, null, null, null, null],
    this.borderColors = const [null, null, null, null, null, null],
    this.borderWidth = 1.0,
    this.childPositionFactor = 0.5,
  })  : assert(onPressed.length == 6),
        assert(colors.length == 6),
        assert(children.length == 6),
        assert(borderColors.length == 6),
        assert(childPositionFactor >= 0 && childPositionFactor <= 1);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(6, (index) {
        return _buildTriangularButton(index);
      }),
    );
  }

  Widget _buildTriangularButton(int index) {
    // 计算这个三角形的中心角度
    final sectionAngle = (index * 60 + 60) * (math.pi / 180); // 转换为弧度

    return Positioned.fill(
      child: Stack(
        children: [
          // 三角形按钮
          ClipPath(
            clipper: TriangularSectionClipper(
              sectionIndex: index,
              sections: 6,
            ),
            child: Material(
              color: colors[index],
              child: InkWell(
                onTap: onPressed[index],
                // containedInkWell: true,
                // highlightShape: BoxShape.rectangle,
                child: Container(),
              ),
            ),
          ),

          // 边框
          // if (borderColors[index] != null)
          //   CustomPaint(
          //     painter: TriangularSectionBorderPainter(
          //       sectionIndex: index,
          //       sections: 6,
          //       color: borderColors[index]!,
          //       strokeWidth: borderWidth,
          //     ),
          //     size: Size(size, size),
          //   ),

          // 子组件
          // if (children[index] != null)
          //   _buildPositionedChild(sectionAngle, children[index]!),
        ],
      ),
    );
  }

  Widget _buildPositionedChild(double sectionAngle, Widget child) {
    // 计算子组件的位置
    final distance = size * 0.5 * childPositionFactor;
    final childX = size / 2 + math.cos(sectionAngle) * distance;
    final childY = size / 2 + math.sin(sectionAngle) * distance;

    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      child: CustomSingleChildLayout(
        delegate: FixedPositionDelegate(
          Offset(childX / size, childY / size),
        ),
        child: child,
      ),
    );
  }
}

class TriangularSectionClipper extends CustomClipper<Path> {
  final int sectionIndex;
  final int sections;

  TriangularSectionClipper({
    required this.sectionIndex,
    required this.sections,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // 计算这个扇区的起始角度和结束角度
    final startAngle = sectionIndex * (2 * math.pi / sections) + math.pi / 6;
    final endAngle =
        (sectionIndex + 1) * (2 * math.pi / sections) + math.pi / 6;

    // 从中心点开始
    path.moveTo(centerX, centerY);

    // 添加到起始角度对应的点
    path.lineTo(
      centerX + radius * math.cos(startAngle),
      centerY + radius * math.sin(startAngle),
    );

    // 添加到结束角度对应的点
    path.lineTo(
      centerX + radius * math.cos(endAngle),
      centerY + radius * math.sin(endAngle),
    );

    // 闭合路径回到中心点
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriangularSectionBorderPainter extends CustomPainter {
  final int sectionIndex;
  final int sections;
  final Color color;
  final double strokeWidth;

  TriangularSectionBorderPainter({
    required this.sectionIndex,
    required this.sections,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // 计算这个扇区的起始角度和结束角度
    final startAngle = sectionIndex * (2 * math.pi / sections);
    final endAngle = (sectionIndex + 1) * (2 * math.pi / sections);

    // 从中心点开始
    path.moveTo(centerX, centerY);

    // 添加到起始角度对应的点
    path.lineTo(
      centerX + radius * math.cos(startAngle),
      centerY + radius * math.sin(startAngle),
    );

    // 添加到结束角度对应的点
    path.lineTo(
      centerX + radius * math.cos(endAngle),
      centerY + radius * math.sin(endAngle),
    );

    // 闭合路径回到中心点
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FixedPositionDelegate extends SingleChildLayoutDelegate {
  final Offset position; // position.dx 和 position.dy 取值范围为 0 到 1

  FixedPositionDelegate(this.position);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // 允许子组件自行决定大小
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // 计算子组件的位置，确保其中心点在指定的位置
    return Offset(
      position.dx * size.width - childSize.width / 2,
      position.dy * size.height - childSize.height / 2,
    );
  }

  @override
  bool shouldRelayout(FixedPositionDelegate oldDelegate) {
    return position != oldDelegate.position;
  }
}
