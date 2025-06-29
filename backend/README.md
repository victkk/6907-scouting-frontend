# Horus Match Records API 后端服务

这是 Horus FRC 比赛记录应用的后端服务，使用 Flask 框架开发。

## 功能特性

- 接收并保存比赛记录数据
- 支持跨域请求 (CORS)
- 自动生成唯一记录 ID
- 文件格式化存储
- 完整的 API 接口
- 错误处理和日志记录

## 快速开始

### 1. 安装依赖

```bash
cd backend
pip install -r requirements.txt
```

### 2. 运行服务器

```bash
python app.py
```

服务器将在 `http://localhost:5000` 启动。

## API 接口

### 1. 健康检查

- **URL**: `GET /api/health`
- **描述**: 检查服务器状态
- **响应**:

```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T12:00:00",
  "service": "Horus Match Records API"
}
```

### 2. 提交比赛记录

- **URL**: `POST /api/match-records`
- **描述**: 接收并保存比赛记录
- **请求体**: JSON 格式的比赛记录数据
- **必需字段**: `event`, `matchCode`, `teamNo`
- **响应**:

```json
{
  "success": true,
  "message": "比赛记录上传成功",
  "data": {
    "id": "uuid-string",
    "filename": "event_match_teamXX_timestamp.json",
    "receivedAt": "2024-01-01T12:00:00",
    "event": "Event Name",
    "matchCode": "Q1",
    "teamNo": 1234,
    "actionsCount": 15
  }
}
```

### 3. 获取所有比赛记录

- **URL**: `GET /api/match-records`
- **描述**: 获取所有已保存的比赛记录列表
- **响应**:

```json
{
  "success": true,
  "message": "找到 X 条比赛记录",
  "data": [
    {
      "id": "uuid-string",
      "filename": "filename.json",
      "event": "Event Name",
      "matchCode": "Q1",
      "teamNo": 1234,
      "receivedAt": "2024-01-01T12:00:00",
      "actionsCount": 15
    }
  ]
}
```

### 4. 获取特定比赛记录

- **URL**: `GET /api/match-records/<record_id>`
- **描述**: 获取特定记录的完整数据
- **响应**: 完整的比赛记录 JSON 数据

## 数据存储

- 所有比赛记录保存在 `match_records/` 目录
- 文件名格式: `{event}_{matchCode}_Team{teamNo}_{timestamp}.json`
- 每个文件包含完整的比赛数据和元数据

## 错误处理

服务器会返回相应的 HTTP 状态码和错误信息：

- `400 Bad Request`: 数据格式错误或缺少必需字段
- `404 Not Found`: 记录或接口未找到
- `500 Internal Server Error`: 服务器内部错误

## 开发说明

- 服务器默认监听所有网络接口 (`0.0.0.0:5000`)
- 开发模式下启用调试功能
- 支持跨域请求，方便前端开发测试
- 所有请求和响应都使用 UTF-8 编码支持中文

## 部署建议

生产环境部署时建议：

1. 使用 Gunicorn 或 uWSGI 作为 WSGI 服务器
2. 配置 Nginx 作为反向代理
3. 使用环境变量管理配置
4. 设置适当的日志级别
5. 配置数据库存储替代文件存储

## 示例使用

### 使用 curl 测试接口

```bash
# 健康检查
curl http://localhost:5000/api/health

# 提交记录 (需要实际的JSON数据)
curl -X POST http://localhost:5000/api/match-records \
  -H "Content-Type: application/json" \
  -d @sample_record.json

# 获取所有记录
curl http://localhost:5000/api/match-records
```
