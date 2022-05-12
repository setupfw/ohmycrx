# 浏览器扩展套装

使用环境：Chromium

用途：文档阅读、信息检索、自动部署

依赖命令行：`wget`, `unzip`

构建环境：Linux + Chromium + docker or podman

可能用到的镜像：

    docker pull node:lts-slim ubuntu:latest

[Chrome 扩展自动部署配置(google.com)](https://support.google.com/chrome/a/answer/7532015?hl=zh-Hans#zippy=%2C%E6%8C%87%E5%AE%9A%E6%89%A9%E5%B1%95%E7%A8%8B%E5%BA%8F%E4%B8%8B%E8%BD%BD%E4%BD%8D%E7%BD%AE)

## 简介

| 插件          | 作用               |
| ------------- | ------------------ |
| vimium-c      | 无鼠标键盘冲浪     |
| darkreader    | 体验优良的夜色模式 |
| cdn4cn        | 英文文档浏览加速   |
| gooreplacer   | 网址重定向         |
| uBlock        | 广告屏蔽           |
| violentmonkey | 网页脚本注入管理器 |
| linkclump     | z 键框选多开       |

此外，构建脚本会应用 `*.patch*` 补丁。这些补丁都是作者精心优化过的，欢迎补充。

## 构建

```bash
git clone https://gitee.com/littleboyharry-crx/ohmycrx.git
cd ohmycrx
make all
```

## 安装

打开生成目录

    xdg-open dist

打开浏览器，地址栏输入：

    about:extensions

激活“开发者模式”，拖入插件包安装。

安装完成后，关闭开发者模式。清理构建容器：

    make rmi

## 定制化

要想自定义构建产物，需要的背景知识：

- docker 使用、Dockerfile 编写
- Shell 脚本
- Web 前端基础知识
- Chrome 插件开发知识

可加速构建的特性：

- 源码仓库镜像源
- docker 容器镜像源
- npm 包镜像源
- yarn, pnpm 代替 npm
