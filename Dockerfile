# ============================================
# Python 基础环境镜像
# 仅提供 Python 运行环境，不包含任何依赖包
# 依赖包安装由上层业务 Dockerfile 负责
# ============================================
# 构建参数：平台架构（FC3 需要 linux/amd64）
ARG BUILDPLATFORM=linux/amd64
ARG TARGETPLATFORM=linux/amd64
# 构建参数：Python 版本，例如 3.7-slim、3.9-slim、3.10-slim
ARG PYTHON_VERSION=3.7.3-slim

FROM python:${PYTHON_VERSION}

# 配置国内镜像源以加速 apt-get（使用阿里云 Debian 镜像）
# 自动检测并替换 Debian 源为国内镜像，支持新版本（debian.sources）和旧版本（sources.list）
RUN DEBIAN_CODENAME=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d= -f2) && \
    if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i 's|http://deb.debian.org|https://mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources && \
        sed -i 's|https://deb.debian.org|https://mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources; \
    else \
        echo "deb https://mirrors.aliyun.com/debian/ ${DEBIAN_CODENAME} main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
        echo "deb https://mirrors.aliyun.com/debian/ ${DEBIAN_CODENAME}-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
        echo "deb https://mirrors.aliyun.com/debian-security ${DEBIAN_CODENAME}-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list; \
    fi

# 只安装运行时必需的系统库
RUN apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true --allow-releaseinfo-change || true && \
    apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# 标记为基础镜像，不包含应用代码和依赖包
# 应用代码和依赖包安装将在上层业务的 Dockerfile 中处理
