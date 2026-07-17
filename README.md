# Python绘图库 - Matplotlib学习笔记

![](https://img.shields.io/badge/Python-3.11-blue) ![](https://img.shields.io/badge/Matplotlib-3.11-orange) ![](https://img.shields.io/badge/MkDocs-Material-blueviolet) ![](https://img.shields.io/badge/license-MIT-green)

> 本教程是笔者在学习与使用 Matplotlib 过程中整理的笔记，涵盖从安装入门到常用图表绘制的完整内容，使用 MkDocs + Material 主题构建为交互式文档网站。

📖 **在线阅读**：`https://jiangsanyin.github.io/Matplotlib-Guide/`

---

## 章节目录

| 章节 | 内容 |
|:---:|:---|
| 第1章 | 安装与初识 Matplotlib |
| 第2章 | 官方文档的介绍 |
| 第3章 | Matplotlib 中图的组成 |
| 第4章 | Matplotlib 中对图的操作 |
| 第5章 | Matplotlib 绘制常用图表 |
| 第6章 | 注意事项 |

---

## 环境要求

- **Python** 3.11+
- **Matplotlib** 3.11+
- **MkDocs** 1.6+ 及 **mkdocs-material** 主题

---

## 本地运行

### 1. 克隆仓库

```bash
git clone https://github.com/jiangsanyin/Matplotlib-Guide.git
cd Matplotlib-Guide
```

### 2. 安装依赖

```bash
pip install mkdocs mkdocs-material
```

### 3. 启动本地预览（支持热重载）

```bash
mkdocs serve
```

浏览器打开 `http://127.0.0.1:8000/` 即可查看，修改 `source/` 下任何 Markdown 文件后页面会自动刷新。

### 4. 构建静态网站

```bash
mkdocs build
```

生成的 HTML 文件会输出到 `docs/` 目录。

---

## 项目结构

```
Matplotlib-Guide/
├── source/                    # Markdown 源文件
│   ├── index.md               # 首页
│   ├── 第1章-01安装与初识Matplotlib.md
│   ├── 第2章-02官方文档的介绍.md
│   ├── 第3章-03Matplotlib中图的组成.md
│   ├── 第4章-04Matplotlib中对图的操作.md
│   ├── 第5章-05Matplotlib绘制常用图表.md
│   └── 第6章-06注意事项.md
├── docs/                      # 自动生成的 HTML（勿手动修改）
├── .github/workflows/ci.yml   # GitHub Actions 自动部署
├── mkdocs.yml                 # MkDocs 配置文件
├── make.bat                   # Windows 构建脚本
├── .gitignore
├── LICENSE
└── README.md
```

---

## 部署

项目配置了 GitHub Actions 自动部署流水线（`.github/workflows/ci.yml`）。当你 push 代码到 `main` 分支时，CI 会自动构建并部署到 GitHub Pages。

手动部署命令：

```bash
mkdocs gh-deploy
```

---

## 贡献

欢迎提交 Issue 或 Pull Request 来改进文档内容！

---

## 开源许可证

本项目基于 [MIT License](LICENSE) 开源，可自由使用、复制、修改和分发。
