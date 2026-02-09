# 阿里云镜像构建服务

阿里云容器镜像服务（ACR）提供了自动化的镜像构建功能，支持通过 Git 仓库自动触发镜像构建。主要特点包括：

* **自动化构建**：当代码推送到 Git 仓库时，可以自动触发镜像构建
* **多平台支持**：支持构建多种架构的镜像（如 linux/amd64、linux/arm64 等）
* **构建规则配置**：可以配置构建规则，指定 Dockerfile 路径、构建上下文等
* **构建日志**：提供详细的构建日志，方便排查问题
* **版本管理**：自动根据 Git tag 或分支创建镜像版本

## 使用方式

通过创建 Git tag 并推送到仓库，即可触发阿里云镜像构建服务自动构建镜像。

# [构建镜像](https://cr.console.aliyun.com/repository/ap-southeast-1/hlib/pyenv/build)
* 创建tag 提交到仓库, 触发阿里云镜像构建服务

```
make 
```


# 测试镜像
```
➜  pyenv git:(main) make img_run
docker run -it --rm registry.ap-southeast-1.aliyuncs.com/hlib/pyenv:1.2 /bin/bash
Unable to find image 'registry.ap-southeast-1.aliyuncs.com/hlib/pyenv:1.2' locally
1.2: Pulling from hlib/pyenv
Digest: sha256:fe7176ddb58117301e31e9c162a274ba3b913ada3b9465d6d63e0c70032f9862
Status: Downloaded newer image for registry.ap-southeast-1.aliyuncs.com/hlib/pyenv:1.2
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
root@adac20ff7256:/# python --version
Python 3.12.12
root@adac20ff7256:/# exit
exit
➜  pyenv git:(main)  
```