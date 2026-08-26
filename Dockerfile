# 使用 Node.js 基础镜像
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
WORKDIR /app/ombre-brain
RUN pip3 install --no-cache-dir -r requirements.txt --break-system-packages || \
    (python3 -m venv /app/venv && /app/venv/bin/pip install -r requirements.txt)

# 再复制心潮
COPY xinchao /app/xinchao
WORKDIR /app/xinchao
RUN npm install

# 复制启动脚本
COPY <<'EOF' /app/start.sh
#!/bin/bash
cd /app/ombre-brain && python3 main.py &
cd /app/xinchao && npm start &
wait
EOF
RUN chmod +x /app/start.sh

EXPOSE 18110 18001

CMD ["/app/start.sh"]
