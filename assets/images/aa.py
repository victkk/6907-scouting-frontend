import cv2
import argparse
import os
import sys

# 定义全局变量
drawing = False  # 标记是否正在绘制矩形
start_x, start_y = -1, -1  # 矩形起始位置
original_img = None  # 原始图片
display_img = None  # 用于显示的图片


def mouse_callback(event, x, y, flags, param):
    global drawing, start_x, start_y, original_img, display_img

    if original_img is None:
        return

    img_height, img_width = original_img.shape[:2]

    # 当用户单击时
    if event == cv2.EVENT_LBUTTONDOWN:
        drawing = True
        start_x, start_y = x, y
        display_img = original_img.copy()

        # 打印点击位置的相对比例
        rel_x = x / img_width
        rel_y = y / img_height
        print(f"点击位置相对比例: ({rel_x:.4f}, {rel_y:.4f})")

        # 在图像上标记点击位置
        cv2.circle(display_img, (x, y), 5, (0, 0, 255), -1)
        cv2.putText(
            display_img,
            f"({rel_x:.3f}, {rel_y:.3f})",
            (x + 10, y + 10),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.5,
            (0, 0, 255),
            1,
        )

    # 当用户拖动时
    elif event == cv2.EVENT_MOUSEMOVE:
        if drawing:
            temp = original_img.copy()
            cv2.rectangle(temp, (start_x, start_y), (x, y), (0, 255, 0), 2)

            # 添加实时大小比例显示
            left_x = min(start_x, x)
            top_y = min(start_y, y)
            width = abs(x - start_x)
            height = abs(y - start_y)
            rel_width = width / img_width
            rel_height = height / img_height

            info_text = f"Size: ({rel_width:.3f}, {rel_height:.3f})"
            cv2.putText(
                temp,
                info_text,
                (left_x, top_y - 10),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.5,
                (0, 255, 0),
                1,
            )

            display_img = temp

    # 当用户释放鼠标按钮时
    elif event == cv2.EVENT_LBUTTONUP:
        if drawing:
            drawing = False

            end_x, end_y = x, y
            left_x = min(start_x, end_x)
            top_y = min(start_y, end_y)
            width = abs(end_x - start_x)
            height = abs(end_y - start_y)

            # 如果创建了一个真正的矩形（不只是点击）
            if width > 3 and height > 3:  # 设置一个小的阈值以区分点击和拖动
                # 计算相对比例
                rel_left = left_x / img_width
                rel_top = top_y / img_height
                rel_width = width / img_width
                rel_height = height / img_height

                print(f"\n边界框信息:")
                print(f"左上角位置相对比例: ({rel_left:.4f}, {rel_top:.4f})")
                print(f"宽高相对比例: ({rel_width:.4f}, {rel_height:.4f})")

                # 在图像上绘制最终的矩形和信息
                temp = original_img.copy()
                cv2.rectangle(
                    temp,
                    (left_x, top_y),
                    (left_x + width, top_y + height),
                    (0, 255, 0),
                    2,
                )

                # 添加边界框信息文本
                info_text1 = f"Position: ({rel_left:.3f}, {rel_top:.3f})"
                info_text2 = f"Size: ({rel_width:.3f}, {rel_height:.3f})"

                cv2.putText(
                    temp,
                    info_text1,
                    (left_x, top_y - 25),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.5,
                    (0, 255, 0),
                    1,
                )
                cv2.putText(
                    temp,
                    info_text2,
                    (left_x, top_y - 10),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.5,
                    (0, 255, 0),
                    1,
                )

                display_img = temp


def main():
    global original_img, display_img

    # 解析命令行参数
    parser = argparse.ArgumentParser(description="显示图片并处理鼠标事件")
    parser.add_argument("--image", type=str, default="", help="图片路径")
    args = parser.parse_args()

    image_path = args.image

    # 如果没有提供图片路径，提示用户输入
    if not image_path:
        image_path = input("请输入要打开的图片路径: ")

    # 检查文件是否存在
    if not os.path.isfile(image_path):
        print(f"错误: 文件 '{image_path}' 不存在")
        return

    # 读取图片
    original_img = cv2.imread(image_path)
    if original_img is None:
        print(f"错误: 无法读取图片：{image_path}")
        return

    display_img = original_img.copy()

    # 打印操作说明
    print("\n图片交互操作说明:")
    print("1. 单击图片: 打印点击位置相对于图片左上角的比例")
    print("2. 长按并拖动: 创建一个边界框，打印边界框的左上角位置和长宽相对比例")
    print("3. 按 'q' 或 'ESC' 键退出程序\n")

    # 创建窗口并设置鼠标回调
    window_name = "Image Viewer"
    cv2.namedWindow(window_name)
    cv2.setMouseCallback(window_name, mouse_callback)

    # 显示图片和等待按键
    while True:
        cv2.imshow(window_name, display_img)
        key = cv2.waitKey(1) & 0xFF
        if key == 27 or key == ord("q"):  # 按ESC或q退出
            break

    cv2.destroyAllWindows()
    print("程序已退出")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"程序出错: {e}")
        sys.exit(1)
