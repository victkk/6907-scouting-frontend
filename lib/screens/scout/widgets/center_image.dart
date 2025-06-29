import 'package:flutter/material.dart';
import 'package:horus/models/scout_state.dart';
import '../../../providers/scout_state_provider.dart';
import 'custom_button.dart';
import 'package:provider/provider.dart';
import 'hexagon_button.dart';

class CenterImage extends StatelessWidget {
  const CenterImage({super.key});

  // 定义图片的长宽比 - 根据实际图片调整这些值
  static const double offenseImageAspectRatio = 1291.0 / 1110; // 示例值
  static const double defenseImageAspectRatio = 1291.0 / 1110; // 示例值
  static const double hexgon_button_size = 0.1;
  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<AppStateProvider>(context);
    final appState = appStateProvider.appState;

    // 根据模式选择不同的图片
    final String imagePath = appState.getIsDefensing()
        ? 'assets/images/defense_background.png'
        : 'assets/images/offense_background.png';

    // 选择对应的长宽比
    final double aspectRatio = appState.getIsDefensing()
        ? defenseImageAspectRatio
        : offenseImageAspectRatio;
    final Map<String, List<Widget> Function(double, double)>
        modeButtonBuilders = {
      'offense': (width, height) => _buildMode1Buttons(
          width, height, appStateProvider.selectFace, appState),
      'defense': (width, height) => _buildMode2Buttons(width, height),
      'auto': (width, height) => _buildAutoSelectButtons(width, height),
      'start': (width, height) => _buildStartButtons(width, height),
      // 可以添加更多模式
    };
    final String mode = !appState.isAutoSelected
        ? "auto"
        : !appState.isStarted
            ? "start"
            : appState.getIsDefensing()
                ? "defense"
                : "offense";
    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      final availableHeight = constraints.maxHeight;

      // 计算图片的实际显示尺寸
      double actualWidth;
      double actualHeight;

      if (availableWidth / availableHeight > aspectRatio) {
        // 容器更宽，以高度为基准
        actualHeight = availableHeight;
        actualWidth = actualHeight * aspectRatio;
      } else {
        // 容器更高，以宽度为基准
        actualWidth = availableWidth;
        actualHeight = actualWidth / aspectRatio;
      }

      return Center(
        child: Container(
            width: actualWidth,
            height: actualHeight,
            decoration: BoxDecoration(
              color: Colors.black54,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover, // 填满容器但保持长宽比
              ),
            ),
            child: Stack(
              children:
                  modeButtonBuilders[mode]!.call(actualWidth, actualHeight),
            )),
      );
    });
  }

  List<Widget> _buildAutoSelectButtons(double width, double height) {
    return [
      Positioned(
        top: height * 0.01,
        left: width * 0.75,
        child: CustomButton(
          id: 'Auto 1',
          label: 'Auto 1',
          width: width * 0.23,
          height: height * 0.18,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        top: height * 0.2,
        left: width * 0.75,
        child: CustomButton(
          id: 'Auto 2',
          label: 'Auto 2',
          width: width * 0.23,
          height: height * 0.18,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        top: height * 0.4,
        left: width * 0.75,
        child: CustomButton(
          id: 'Auto 3',
          label: 'Auto 3',
          width: width * 0.23,
          height: height * 0.18,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        top: height * 0.6,
        left: width * 0.75,
        child: CustomButton(
          id: 'Auto 4',
          label: 'Auto 4',
          width: width * 0.23,
          height: height * 0.18,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        top: height * 0.8,
        left: width * 0.75,
        child: CustomButton(
          id: 'Auto 5',
          label: 'Auto 5',
          width: width * 0.23,
          height: height * 0.18,
          backgroundColor: Colors.blue[700],
        ),
      ),
    ];
  }

  List<Widget> _buildStartButtons(double width, double height) {
    return [
      Positioned(
        top: height * 0.0,
        left: width * 0.0,
        child: CustomButton(
          id: 'Start',
          label: 'Start',
          width: width * 1,
          height: height * 1,
          backgroundColor: Colors.blue[700],
        ),
      )
    ];
  }

  List<Widget> _buildMode1Buttons(double width, double height,
      void Function(int) selectFace, AppState appState) {
    return [
      Positioned(
        top: height * 0.02,
        left: width * 0.02,
        child: CustomButton(
          id: 'Load Station Far',
          label: 'Load Station Far',
          width: width * 0.40,
          height: height * 0.32,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        top: height * 0.00,
        left: width * 0.875,
        child: CustomButton(
          id: 'Net',
          label: 'Net',
          width: width * 0.1185,
          height: height * 0.4514,
          backgroundColor: Colors.blue[700],
          isEnabled: appState.hasAlgae,
        ),
      ),
      Positioned(
        top: height * 0.75,
        left: width * 0.6,
        child: CustomButton(
          id: 'Processor',
          label: 'Processor',
          width: width * 0.3,
          height: height * 0.23,
          backgroundColor: Colors.blue[700],
          isEnabled: appState.hasAlgae,
        ),
      ),
      Positioned(
        top: height * 0.00,
        left: width * 0.536,
        child: CustomButton(
          id: 'Ground Algae',
          label: 'Ground Algae',
          width: width * 0.3,
          height: height * 0.3,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        top: height * 0.66,
        left: width * 0.02,
        child: CustomButton(
          id: 'Load Station Near',
          label: 'Load Station Near',
          width: width * 0.40,
          height: height * 0.32,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        bottom: height * 0.36,
        left: width * 0.02,
        child: CustomButton(
          id: 'Ground Coral',
          label: 'Ground Coral',
          width: width * 0.28,
          height: height * 0.28,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
          top: height * 0.296,
          left: width * 0.306,
          width: width * 0.35,
          height: width * 0.35,
          child: HexagonalButtonGroup(
            size: width * 0.3,
            onPressed: [
              () => selectFace(1),
              () => selectFace(2),
              () => selectFace(3),
              () => selectFace(4),
              () => selectFace(5),
              () => selectFace(6),
            ],
            colors: const [
              Color.fromARGB(255, 25, 118, 210),
              Color.fromARGB(255, 25, 118, 210),
              Color.fromARGB(255, 25, 118, 210),
              Color.fromARGB(255, 25, 118, 210),
              Color.fromARGB(255, 25, 118, 210),
              Color.fromARGB(255, 25, 118, 210),
            ],
            borderColors: List.filled(6, Colors.white),
            childPositionFactor: 0.6, // 控制图标位置靠近外边缘
            borderWidth: 2.0,
            children: [
              Icon(Icons.home, color: Colors.white),
              Icon(Icons.search, color: Colors.white),
              Icon(Icons.settings, color: Colors.white),
              Icon(Icons.favorite, color: Colors.white),
              Icon(Icons.person, color: Colors.white),
              Icon(Icons.notifications, color: Colors.white),
            ],
          )),
    ];
  }

  List<Widget> _buildMode2Buttons(double width, double height) {
    return [];
  }
}
