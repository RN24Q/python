# Python 版本，构建时传入，例如 make build VERSION=3.9
VERSION ?= 3.7.3
# 用于基础镜像的 tag（如 3.7-slim、3.9-slim）
PYTHON_IMAGE_TAG := $(VERSION)-slim
# 输出镜像的 tag
REAL_VERSION := $(VERSION)
TAG_NAME := release-v$(REAL_VERSION)
IMG_FULL_NAME := registry.ap-southeast-1.aliyuncs.com/hlib/python:$(REAL_VERSION)

.PHONY: tag build img_run

# 构建指定版本的 Python 镜像
build:
	@echo "构建 Python $(VERSION) 镜像: $(IMG_FULL_NAME)"
	docker build --build-arg PYTHON_VERSION=$(PYTHON_IMAGE_TAG) -t $(IMG_FULL_NAME) .

tag:
	@echo "创建标签: $(TAG_NAME)"
	@git rev-parse $(TAG_NAME) >/dev/null 2>&1 || git tag $(TAG_NAME)
	@echo "推送标签到远程..."
	@git push origin $(TAG_NAME)
	@echo "✅ 标签 $(TAG_NAME) 已成功推送"

all: tag

img_run:
	# https://cr.console.aliyun.com/repository/ap-southeast-1/hlib/python/build
	docker run -it --rm $(IMG_FULL_NAME) /bin/bash