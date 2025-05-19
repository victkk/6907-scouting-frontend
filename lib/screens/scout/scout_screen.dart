import 'package:flutter/material.dart';
import 'widgets/center_image.dart';
import 'widgets/side_panel.dart';
import 'widgets/timer_display.dart';

class LandscapeScreen extends StatelessWidget {
  const LandscapeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('Control Panel'),
        backgroundColor: Colors.indigo[900],
        actions: [
          // 添加计时器显示
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: TimerDisplay()),
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧面板 - 占据20%的宽度
          Container(
            width: screenSize.width * 0.2,
            child: SidePanel(isLeftPanel: true),
          ),

          // 中心区域 - 占据60%的宽度，垂直居中显示正方形图片
          Container(
            height: screenSize.height * 1,
            alignment: Alignment.center,
            child: CenterImage(),
          ),

          // 右侧面板 - 占据20%的宽度
          Container(
            width: screenSize.width * 0.2,
            child: SidePanel(isLeftPanel: false),
          ),
        ],
      ),
    );
  }
}
