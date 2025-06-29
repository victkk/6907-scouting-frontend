import 'package:flutter/material.dart';
import 'package:horus/models/scout_state.dart';
import '../../../providers/scout_state_provider.dart';
import 'custom_button.dart';
import 'package:provider/provider.dart';

class SidePanel extends StatelessWidget {
  final bool isLeftPanel;

  const SidePanel({super.key, required this.isLeftPanel});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context).appState;
    final isMode2 = appState.getIsDefensing();

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      final availableHeight = constraints.maxHeight;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
        ),
        child: !appState.isStarted
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              )
            : isLeftPanel
                ? _buildLeftPanel(
                    context, appState, isMode2, availableHeight, availableWidth)
                : _buildRightPanel(context, appState, isMode2),
      );
    });
  }

  Widget _buildLeftPanel(BuildContext context, AppState appState, bool isMode2,
      double availableHeight, double availableWidth) {
    final buttonList = isMode2
        ? [
            CustomButton(
              id: 'Defense',
              label: 'Defense',
              height: availableHeight * 0.8,
              icon: Icons.star,
              backgroundColor: Colors.indigo[800],
            ),
          ]
        : [
            CustomButton(
                id: 'Fail',
                label: 'last coral/algae fail',
                icon: Icons.add_circle,
                height: availableHeight * 0.54,
                backgroundColor: Colors.blue[800]),
            const SizedBox(height: 16),
            CustomButton(
              id: 'Go Barge',
              label: 'Go Barge',
              height: availableHeight * 0.17,
              icon: Icons.remove_circle,
              backgroundColor: Colors.blue[800],
            ),
            const SizedBox(height: 16),
            CustomButton(
              id: 'Climb Up',
              label: 'Climb Up',
              height: availableHeight * 0.18,
              icon: Icons.refresh,
              backgroundColor: Colors.blue[800],
              isEnabled: appState.goBarge,
            ),
          ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttonList,
    );
  }

  Widget _buildRightPanel(
      BuildContext context, AppState appState, bool isMode2) {
    final appStateProvider =
        Provider.of<AppStateProvider>(context, listen: false);

    if (isMode2) {
      // 调整后的模式2布局，Switch位置与模式1一致
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Foul按钮占据主要空间
          Expanded(
            flex: 4, // 与模式1比例保持一致
            child: Center(
              child: CustomButton(
                id: 'Foul',
                label: 'Foul',
                icon: Icons.star,
                height: double.infinity,
                backgroundColor: Colors.indigo[800],
              ),
            ),
          ),

          // 底部区域与模式1相同的结构
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // 将Switch放在右侧
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                    value: isMode2,
                    onChanged: (_) => appStateProvider.toggleMode(),
                    activeColor: Colors.indigo[400],
                    inactiveThumbColor: Colors.blue[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // 保持模式1原样不变
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // L4 按钮
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomButton(
                id: 'L4',
                label: 'L4',
                backgroundColor: Colors.blueGrey[400],
                textColor: Colors.white,
                width: double.infinity,
                isEnabled: appState.hasCoral & (appState.faceSelected > -1),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomButton(
                id: 'L3',
                label: 'L3',
                backgroundColor: Colors.blueGrey[400],
                textColor: Colors.white,
                width: double.infinity,
                isEnabled: appState.hasCoral & (appState.faceSelected > -1),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomButton(
                id: 'L2',
                label: 'L2',
                backgroundColor: Colors.blueGrey[400],
                textColor: Colors.white,
                width: double.infinity,
                isEnabled: appState.hasCoral & (appState.faceSelected > -1),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomButton(
                id: 'L1',
                label: 'L1',
                backgroundColor: Colors.blueGrey[400],
                textColor: Colors.white,
                width: double.infinity,
                isEnabled: appState.hasCoral & (appState.faceSelected > -1),
              ),
            ),
          ),

          // 底部部分：Reef Algae按钮和Switch
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Reef Algae 按钮
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      id: 'Reef Algae',
                      label: 'Reef Algae',
                      backgroundColor: Colors.blueGrey[400],
                      textColor: Colors.white,
                    ),
                  ),

                  // O/D toggle
                  Switch(
                    value: isMode2,
                    onChanged: (_) => appStateProvider.toggleMode(),
                    activeColor: Colors.indigo[400],
                    inactiveThumbColor: Colors.blue[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
