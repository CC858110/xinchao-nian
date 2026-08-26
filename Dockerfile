# 使用 Node.js 基础镜像（包含 npm）
FROM node:20-slim

# 安装 Python 和必要依赖（OB 需要 Python）
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 先复制 Ombre Brain
COPY ombre-brain /app/ombre-brain

# 安装 OB 的 Python 依赖
WORKDIR /app/ombre-brain
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages || \
    (python3 -m venv /app/venv && /app/venv/bin/pip install -r requirements.txt)

# 再复制心潮
COPY xinchao /app/xinchao

# 安装心潮的 Node 依赖
WORKDIR /app/xinchao
RUN npm install

# 复制启动脚本
COPY <<'EOF' /app/start.sh
#!/bin/bash
# 启动 Ombre Brain（使用 entrypoint.sh）
cd /app/ombre-brain && ./entrypoint.sh &
# 启动心潮
cd /app/xinchao && npm start &
# 等待两个进程
wait
EOF

RUN chmod +x /app/start.sh

# 暴露端口
EXPOSE 18110 18001

CMD ["/app/start.sh"]
