from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import os
from datetime import datetime
import uuid

app = Flask(__name__)
CORS(app)  # 允许跨域请求

# 创建数据存储目录
DATA_DIR = "match_records"
if not os.path.exists(DATA_DIR):
    os.makedirs(DATA_DIR)


@app.route("/")
def hello():
    return jsonify(
        {
            "message": "Horus Match Records API Server",
            "version": "1.0.0",
            "endpoints": {
                "POST /api/match-records": "提交比赛记录",
                "GET /api/match-records": "获取所有比赛记录",
                "GET /api/match-records/<record_id>": "获取特定比赛记录",
                "GET /api/health": "健康检查",
            },
        }
    )


@app.route("/api/health", methods=["GET"])
def health_check():
    """健康检查接口"""
    return jsonify(
        {
            "status": "healthy",
            "timestamp": datetime.now().isoformat(),
            "service": "Horus Match Records API",
        }
    )


@app.route("/api/match-records", methods=["POST"])
def submit_match_record():
    """接收并保存比赛记录"""
    try:
        # 获取JSON数据
        data = request.get_json()

        if not data:
            return jsonify({"success": False, "message": "没有收到数据"}), 400

        # 验证必要字段
        required_fields = ["event", "matchCode", "teamNo"]
        missing_fields = [
            field for field in required_fields if field not in data or not data[field]
        ]

        if missing_fields:
            return (
                jsonify(
                    {
                        "success": False,
                        "message": f'缺少必要字段: {", ".join(missing_fields)}',
                    }
                ),
                400,
            )

        # 生成唯一ID
        record_id = str(uuid.uuid4())

        # 添加服务器端的元数据
        server_data = {
            "id": record_id,
            "receivedAt": datetime.now().isoformat(),
            "serverVersion": "1.0.0",
            **data,
        }

        # 保存到文件
        filename = f"{data['event']}_{data['matchCode']}_Team{data['teamNo']}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        filepath = os.path.join(DATA_DIR, filename)

        with open(filepath, "w", encoding="utf-8") as f:
            json.dump(server_data, f, ensure_ascii=False, indent=2)

        # 记录日志
        print(f"Match record saved: {filename}")
        print(
            f"Event: {data['event']}, Match: {data['matchCode']}, Team: {data['teamNo']}"
        )
        print(f"Actions count: {len(data.get('action', []))}")

        return (
            jsonify(
                {
                    "success": True,
                    "message": "比赛记录上传成功",
                    "data": {
                        "id": record_id,
                        "filename": filename,
                        "receivedAt": server_data["receivedAt"],
                        "event": data["event"],
                        "matchCode": data["matchCode"],
                        "teamNo": data["teamNo"],
                        "actionsCount": len(data.get("action", [])),
                    },
                }
            ),
            201,
        )

    except json.JSONDecodeError:
        return jsonify({"success": False, "message": "JSON数据格式错误"}), 400
    except Exception as e:
        print(f"Error processing match record: {str(e)}")
        return jsonify({"success": False, "message": f"服务器内部错误: {str(e)}"}), 500


@app.route("/api/match-records", methods=["GET"])
def get_match_records():
    """获取所有比赛记录的列表"""
    try:
        if not os.path.exists(DATA_DIR):
            return jsonify({"success": True, "message": "暂无比赛记录", "data": []})

        records = []
        for filename in os.listdir(DATA_DIR):
            if filename.endswith(".json"):
                filepath = os.path.join(DATA_DIR, filename)
                try:
                    with open(filepath, "r", encoding="utf-8") as f:
                        data = json.load(f)
                        records.append(
                            {
                                "id": data.get("id", filename),
                                "filename": filename,
                                "event": data.get("event", ""),
                                "matchCode": data.get("matchCode", ""),
                                "teamNo": data.get("teamNo", 0),
                                "receivedAt": data.get("receivedAt", ""),
                                "actionsCount": len(data.get("action", [])),
                            }
                        )
                except Exception as e:
                    print(f"Error reading file {filename}: {str(e)}")
                    continue

        # 按接收时间排序
        records.sort(key=lambda x: x.get("receivedAt", ""), reverse=True)

        return jsonify(
            {
                "success": True,
                "message": f"找到 {len(records)} 条比赛记录",
                "data": records,
            }
        )

    except Exception as e:
        print(f"Error getting match records: {str(e)}")
        return jsonify({"success": False, "message": f"获取记录失败: {str(e)}"}), 500


@app.route("/api/match-records/<record_id>", methods=["GET"])
def get_match_record(record_id):
    """获取特定的比赛记录详情"""
    try:
        # 查找对应的文件
        for filename in os.listdir(DATA_DIR):
            if filename.endswith(".json"):
                filepath = os.path.join(DATA_DIR, filename)
                try:
                    with open(filepath, "r", encoding="utf-8") as f:
                        data = json.load(f)
                        if data.get("id") == record_id:
                            return jsonify(
                                {
                                    "success": True,
                                    "message": "记录获取成功",
                                    "data": data,
                                }
                            )
                except Exception as e:
                    print(f"Error reading file {filename}: {str(e)}")
                    continue

        return jsonify({"success": False, "message": "记录未找到"}), 404

    except Exception as e:
        print(f"Error getting match record {record_id}: {str(e)}")
        return jsonify({"success": False, "message": f"获取记录失败: {str(e)}"}), 500


@app.errorhandler(404)
def not_found(error):
    return jsonify({"success": False, "message": "API接口不存在"}), 404


@app.errorhandler(500)
def internal_error(error):
    return jsonify({"success": False, "message": "服务器内部错误"}), 500


if __name__ == "__main__":
    print("Starting Horus Match Records API Server...")
    print("Server will be available at: http://localhost:5000")
    print("API endpoints:")
    print("  POST /api/match-records - 提交比赛记录")
    print("  GET /api/match-records - 获取所有比赛记录")
    print("  GET /api/match-records/<record_id> - 获取特定比赛记录")
    print("  GET /api/health - 健康检查")
    print("-" * 50)

    app.run(debug=True, host="0.0.0.0", port=5000)
