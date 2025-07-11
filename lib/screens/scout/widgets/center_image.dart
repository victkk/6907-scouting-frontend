import 'package:flutter/material.dart';
import 'package:horus/models/scout_state.dart';
import '../../../providers/scout_state_provider.dart';
import 'custom_button.dart';
import 'package:provider/provider.dart';
import 'hexagon_button.dart';
import 'algae_score_menu_dialog.dart';
import '../../../models/action_constants.dart';

class CenterImage extends StatelessWidget {
  const CenterImage({super.key});

  // 定义图片的长宽比 - 根据实际图片调整这些值
  static const double offenseImageAspectRatio = 1291.0 / 1110; // 示例值
  static const double defenseImageAspectRatio = 1291.0 / 1110; // 示例值
  static const double hexgon_button_size = 0.1;

  // 计算镜像位置的帮助方法
  double _getMirroredLeft(double originalLeft, double buttonWidth,
      double totalWidth, bool isMirrorMode) {
    if (!isMirrorMode) {
      return originalLeft;
    }
    return totalWidth - originalLeft - buttonWidth;
  }

  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<AppStateProvider>(context);
    final appState = appStateProvider.appState;

    // 根据模式选择不同的图片，如果是镜像模式则交换图片
    final bool shouldUseDefenseImage = appState.getIsMirrorMode()
        ? !appState.getIsDefensing()
        : appState.getIsDefensing();

    final String imagePath = shouldUseDefenseImage
        ? 'assets/images/defense_background.png'
        : 'assets/images/offense_background.png';

    // 选择对应的长宽比
    final double aspectRatio = shouldUseDefenseImage
        ? defenseImageAspectRatio
        : offenseImageAspectRatio;
    final Map<String, List<Widget> Function(double, double, bool)>
        modeButtonBuilders = {
      'offense': (width, height, isMirrorMode) => _buildMode1Buttons(context,
          width, height, appStateProvider.selectFace, appState, isMirrorMode),
      'defense': (width, height, isMirrorMode) =>
          _buildMode2Buttons(width, height, isMirrorMode),
      'auto': (width, height, isMirrorMode) =>
          _buildAutoSelectButtons(width, height, isMirrorMode),
      'start': (width, height, isMirrorMode) =>
          _buildStartButtons(width, height, isMirrorMode),
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
              children: modeButtonBuilders[mode]!
                  .call(actualWidth, actualHeight, appState.getIsMirrorMode()),
            )),
      );
    });
  }

  List<Widget> _buildAutoSelectButtons(
      double width, double height, bool isMirrorMode) {
    return [
      Positioned(
        top: height * 0.01,
        bottom: height * 0.01,
        left: _getMirroredLeft(width * 0.75, width * 0.23, width, isMirrorMode),
        width: width * 0.23,
        child: Column(
          children: [
            Expanded(
              child: CustomButton(
                id: 'Auto 1',
                label: 'Auto 1',
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.blue[700],
              ),
            ),
            SizedBox(height: height * 0.01), // 小间距
            Expanded(
              child: CustomButton(
                id: 'Auto 2',
                label: 'Auto 2',
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.blue[700],
              ),
            ),
            SizedBox(height: height * 0.01), // 小间距
            Expanded(
              child: CustomButton(
                id: 'Auto 3',
                label: 'Auto 3',
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.blue[700],
              ),
            ),
            SizedBox(height: height * 0.01), // 小间距
            Expanded(
              child: CustomButton(
                id: 'Auto 4',
                label: 'Auto 4',
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.blue[700],
              ),
            ),
            SizedBox(height: height * 0.01), // 小间距
            Expanded(
              child: CustomButton(
                id: 'Auto 5',
                label: 'Auto 5',
                width: double.infinity,
                height: double.infinity,
                backgroundColor: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @Deprecated('Deprecated')
  void _showAlgaeScoreMenu(BuildContext context, AppState appState) {
    final timestamp = appState.getRelativeTimestamp();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlgaeScoreMenuDialog(
          timestamp: timestamp,
        );
      },
    );
  }

  List<Widget> _buildStartButtons(
      double width, double height, bool isMirrorMode) {
    return [
      Positioned(
        top: height * 0.0,
        left: _getMirroredLeft(width * 0.0, width * 1, width, isMirrorMode),
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

  List<Widget> _buildMode1Buttons(
      BuildContext context,
      double width,
      double height,
      void Function(int) selectFace,
      AppState appState,
      bool isMirrorMode) {
    return [
      Positioned(
        top: height * 0.02,
        left: _getMirroredLeft(width * 0.02, width * 0.30, width, isMirrorMode),
        child: CustomButton(
          id: 'Load Station Far',
          label: 'Load Station Far',
          width: width * 0.30,
          height: height * 0.32,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        top: height * 0.00,
        left: _getMirroredLeft(
            width * 0.875, width * 0.1185, width, isMirrorMode),
        child: CustomButton(
          id: AlgaeScoreTypes.net,
          label: 'Net',
          width: width * 0.1185,
          height: height * 0.4514,
          useGradient: true,
          backgroundColor: Colors.cyan[700],
          isEnabled: appState.hasAlgae,
          // onLongPressCallback: appState.hasAlgae
          //     ? () => _showAlgaeScoreMenu(context, appState)
          //     : null,
        ),
      ),
      Positioned(
        top: 0.5 * height,
        left: _getMirroredLeft(
            0.875 * width, 0.1185 * width, width, isMirrorMode),
        child: CustomButton(
          id: 'Ground Algae Front',
          label: 'Steal Algae',
          width: 0.1185 * width,
          height: 0.23 * height,
          useGradient: true,
          backgroundColor: Colors.cyan[700],
        ),
      ),

      Positioned(
        top: height * 0.2514,
        left:
            _getMirroredLeft(width * 0.72, width * 0.1185, width, isMirrorMode),
        child: CustomButton(
          id: AlgaeScoreTypes.shooting,
          label: 'Shoot',
          width: width * 0.1185,
          height: height * 0.23,

          useGradient: true,
          backgroundColor: Colors.cyan[700],
          isEnabled: appState.hasAlgae,
          // onLongPressCallback: appState.hasAlgae
          //     ? () => _showAlgaeScoreMenu(context, appState)
          //     : null,
        ),
      ),
      Positioned(
        top: height * 0.75,
        left: _getMirroredLeft(width * 0.6, width * 0.25, width, isMirrorMode),
        child: CustomButton(
          id: AlgaeScoreTypes.processor,
          label: 'Processor',
          width: width * 0.25,
          useGradient: true,
          height: height * 0.23,
          backgroundColor: Colors.cyan[700],
          isEnabled: appState.hasAlgae,
        ),
      ),

      Positioned(
        top: height * 0.75,
        left: _getMirroredLeft(width * 0.85, width * 0.15, width, isMirrorMode),
        child: CustomButton(
          id: AlgaeScoreTypes.tactical,
          label: 'tactical Algae',
          width: width * 0.15,
          useGradient: true,
          height: height * 0.23,
          backgroundColor: Colors.cyan[700],
          isEnabled: appState.hasAlgae,
        ),
      ),
      // Ground Algae 按钮组 (前中后)
      Positioned(
        top: height * 0.00,
        left: _getMirroredLeft(width * 0.336, width * 0.5, width, isMirrorMode),
        width: width * 0.5,
        height: height * 0.2,
        child: Row(
          children: isMirrorMode
              ? [
                  // 镜像模式时顺序调换
                  Expanded(
                    child: CustomButton(
                      id: 'Ground Algae Middle',
                      label: 'Algae Middle',
                      width: double.infinity,
                      height: double.infinity,
                      backgroundColor: Colors.cyan[700],
                    ),
                  ),
                  const SizedBox(width: 2), // 小间距
                  Expanded(
                    child: CustomButton(
                      id: 'Ground Algae Back',
                      label: 'Algae Back',
                      width: double.infinity,
                      height: double.infinity,
                      backgroundColor: Colors.cyan[700],
                    ),
                  ),
                ]
              : [
                  // 正常模式
                  Expanded(
                    child: CustomButton(
                      id: 'Ground Algae Back',
                      label: 'Algae Back',
                      width: double.infinity,
                      height: double.infinity,
                      backgroundColor: Colors.cyan[700],
                    ),
                  ),
                  const SizedBox(width: 2), // 小间距
                  Expanded(
                    child: CustomButton(
                      id: 'Ground Algae Middle',
                      label: 'Algae Middle',
                      width: double.infinity,
                      height: double.infinity,
                      backgroundColor: Colors.cyan[700],
                    ),
                  ),
                ],
        ),
      ),
      Positioned(
        top: height * 0.66,
        left: _getMirroredLeft(width * 0.02, width * 0.30, width, isMirrorMode),
        child: CustomButton(
          id: 'Load Station Near',
          label: 'Load Station Near',
          width: width * 0.30,
          height: height * 0.32,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
        bottom: height * 0.36,
        left: _getMirroredLeft(width * 0.02, width * 0.20, width, isMirrorMode),
        child: CustomButton(
          id: 'Ground Coral',
          label: 'Ground Coral',
          width: width * 0.20,
          height: height * 0.28,
          backgroundColor: Colors.blue[700],
        ),
      ),

      Positioned(
        bottom: height * 0.36,
        left: _getMirroredLeft(width * 0.22, width * 0.08, width, isMirrorMode),
        child: CustomButton(
          id: 'Fixed Coral',
          label: 'Fixed Coral',
          width: width * 0.08,
          height: height * 0.28,
          backgroundColor: Colors.blue[700],
        ),
      ),
      Positioned(
          top: height * 0.296,
          left:
              _getMirroredLeft(width * 0.306, width * 0.4, width, isMirrorMode),
          width: width * 0.4,
          height: width * 0.4,
          child: HexagonalButtonGroup(
            size: width * 0.36,
            selectedIndex: appState.faceSelected, // 传递当前选中的face
            selectedColor: const Color.fromARGB(255, 255, 152, 0), // 橙色高亮
            unselectedColor: const Color.fromARGB(255, 120, 120, 120), // 灰色
            onPressed: [
              () => selectFace(1),
              () => selectFace(2),
              () => selectFace(3),
              () => selectFace(4),
              () => selectFace(5),
              () => selectFace(6),
            ],
            childPositionFactor: 0.6, // 控制图标位置靠近外边缘
            borderWidth: 3.0, // 增加边框宽度使选中更明显
            indexMap: isMirrorMode
                ? {
                    1: 4,
                    2: 5,
                    3: 6,
                    4: 1,
                    5: 2,
                    6: 3,
                  }
                : {
                    1: 1,
                    2: 2,
                    3: 3,
                    4: 4,
                    5: 5,
                    6: 6,
                  },
            children: isMirrorMode
                ? const [
                    Icon(Icons.looks_one,
                        size: 20), // 颜色将由HexagonalButtonGroup动态设置
                    Icon(Icons.looks_6, size: 20),
                    Icon(Icons.looks_5, size: 20),
                    Icon(Icons.looks_4, size: 20),
                    Icon(Icons.looks_3, size: 20),
                    Icon(Icons.looks_two, size: 20),
                  ]
                : const [
                    Icon(Icons.looks_one,
                        size: 20), // 颜色将由HexagonalButtonGroup动态设置
                    Icon(Icons.looks_two, size: 20),
                    Icon(Icons.looks_3, size: 20),
                    Icon(Icons.looks_4, size: 20),
                    Icon(Icons.looks_5, size: 20),
                    Icon(Icons.looks_6, size: 20),
                  ],
          )),
    ];
  }

  List<Widget> _buildMode2Buttons(
      double width, double height, bool isMirrorMode) {
    return [];
  }
}
