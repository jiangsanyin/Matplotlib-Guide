---
title: python绘图库-matplotlib-chp1
date: 2026年6月10日20:54:59
tags:
  - matplotlib
  - PyTorch
categories: Python画图
math: "False"
---
笔者学习与使用matplotlib过程中做了相关笔记，然后将其整理成了此文档。

# 一、安装与初识matplotlib

Matplotlib 是 Python 中最核心、最老牌的数据可视化（绘图）基础库。它就像是 Python 世界里的“数字画笔”，能够将 NumPy 数组或 Pandas 抽象的数据，转化为折线图、柱状图、散点图、3D 图等各种专业的静态、动态或交互式图表。它的设计理念深受 MATLAB 的影响（其核心子库 `pyplot` 的语法与 MATLAB 高度相似），由于其功能极其强大、底层控制极其精细，如今它已成为大模型特征分析、医疗数据工程以及科学计算领域中不可或缺的画图利器。

虽然 Matplotlib 的名字和日常使用中大多数的场景都集中在平面二维（2D）图表上，但它其实也具备绘制三维（3D）图形的能力。Matplotlib 内置了一个叫做 mplot3d 的工具包，不需要额外安装任何第三方库，就能直接绘制出各种 3D 图表。

---
在Jupyter中可以直接显示使用Matplotlib绘制的图形，方便学习与查看效果。

Matplotlib相关链接：

- 官网：`https://matplotlib.org/index.html`
- 案例：`https://matplotlib.org/gallery/index.html`
- 官方所有示例源码：`https://matplotlib.org/stable/tutorials/index.html`
- 项目的github仓库地址：`https://github.com/matplotlib/matplotlib`

## 1.1 安装matplotlib
本文以 `python 3.11.9`、`matplotlib 3.11.0 为环境来描述。以下内容中涉及所述的stable版本matplotlib就是指2026年6月11日发布的matplotlib v3.11，它为当前最新稳定版。
```bat
# 以在conda 中安装的Python 3.11.9环境为例
C:\Users>conda activate agent_py3119
(agent_py3119) C:\Users>python -V
Python 3.11.9
(agent_py3119) C:\Users>pip install matplotlib==3.11.0
# 此时安装了matplotlib 3.11.0
(agent_py3119) C:\Users>pip list | findstr matplotlib
matplotlib                               3.11.0
matplotlib-inline                        0.1.7
```
## 1.2 感受matplotlib
使用matplotlib绘制第一张图：
```python
# 导入matplotlib
import matplotlib.pyplot as plt
# 导入numpy库并取别名np
import numpy as np

fig, ax = plt.subplots()
# 创建图表
# 此方法依赖pyplot自动创建figure和axes
"""
意思： 在内存中暗中画好一张折线图。
拆解其中 np.arange(5)： 生成一个包含 5 个数字的序列，即 [0, 1, 2, 3, 4]。
拆解其中 ax.plot(X, Y)： 它的标准语法是传入 X 轴数据和 Y 轴数据。

这里传入了两个一模一样的序列，等同于：ax.plot([0,1,2,3,4], [0,1,2,3,4])。
Matplotlib 在后台把这 5 个坐标点 (0,0), (1,1), (2,2), (3,3), (4,4) 连接起来，形成一条斜线（其实是一条从左下角到右上角的 45 度的线段）。
"""
ax.plot(np.arange(5), np.arange(5))

# 显示
"""
意思： 把画好的图真正展示出来。
为什么需要此行代码： 前面的 plt.plot() 只是在电脑内存里悄悄把图画好了，并没有展示出来。此语句就是在一个画布上真正展示出绘制好的图
"""
plt.show()
```
![Pasted image 20260611193021](https://files.seeusercontent.com/2026/06/11/ttK3/Pasted-image-20260611193021.png)
## 1.3 matplotlib中图表的组成部分
![20260613171512030.png](https://files.seeusercontent.com/2026/06/13/vNb2/20260613171512030.png)
此图来自 Matplotlib 官网，它清晰地展现了一个完整 Matplotlib 图表背后的所有组成构件和对应的代码 API。以下是对此图的介绍。
### 1.3.1 总体概述

- **核心内容**：此图全面展示了 Matplotlib **面向对象（Object-Oriented）** 绘图的核心层级结构（个人感觉有点类似于HTML语言中各种容器元素的嵌套结构及对它们的操作），并标注了控制每个视觉元素的关键代码方法（如 `ax.set_title`、`ax.plot` 等）。
  
- **绘制步骤与核心逻辑**：
    1. **准备画布 (`Figure`)**：最外层首先创建一个最大的空白画布。
    2. **创建坐标系 (`Axes`)**：在画布上划分出一个或多个独立的绘图区域（即子图）。
    3. **绘制核心数据 (`Line` / `Markers`)**：在坐标系中通过数据点绘制出折线、散点等主体图形。
    4. **添加辅助修饰 (`Title` / `Legend` / `Grid` / `Axis`)**：最后加上标题、图例、网格和坐标轴标签，完成一幅逻辑严密、可读性高的图表。
    
- **主要特点**：结构高度模块化、层级清晰。Matplotlib 的设计思想是“一切皆对象”（有点像当初学习Java语言时学习的OOP编程思想），图中的每一个文字、线条、刻度都是一个独立的对象，都可以被精准地定制和修改。
### 1.3.2 主要元素介绍

根据图中的蓝色圆圈圈出的标注，图表的主要元素可以分为以下三大类：
#### 1.3.2.1. 容器与框架层（基础舞台）
- Figure (`plt.figure`)：最外层的整个大画布。它是所有元素的最高层级容器，包含了图表的所有内容。
- Axes (`fig.subplots`)：具体的绘图区域（子图/坐标系）。一个 Figure 可以包含多个 Axes。它是画图的主战场，绝大部分的绘图操作（如画线、加网格）都是针对 Axes 进行的。
- Spine (`ax.spines`)：边框线。即包裹住绘图区域的四条四周边界线（上下左右）。

#### 1.3.2.2. 数据表现层（图表核心）
- Line (`ax.plot`)：折线/曲线。用于表现连续趋势的数据线（如图中的蓝色和橙色曲线）。
- Markers (`ax.scatter`)：数据标记/散点。用于表现离散数据点的形状（如图中的紫色空心正方形）。在 Matplotlib 的底层逻辑中，“线（Line）”和“点（Marker）”其实是两个互相独立、甚至可以拆分的视觉元素。
- matplotlib中并不止于这两种数据表现类型，还有其他类型如Bar (`ax.bar`)

#### 1.3.2.3. 辅助说明层（图例与轴线）
- Title (`ax.set_title`)：图表标题。位于正上方，说明整张图画的是什么。
- Legend (`ax.legend`)：图例。用来解释不同颜色、形状的线条或散点分别代表什么数据（如图中的 `Blue signal` 和 `Orange signal`）。
- Grid (`ax.grid`)：网格线。背后的虚线网格，方便眼睛快速对齐并读取数据坐标。
- xAxis / yAxis (`ax.xaxis` / `ax.yaxis`)：X 轴与 Y 轴本身。包含了轴线、刻度以及刻度标签的集合体。

- xlabel / ylabel (`ax.set_xlabel` / `ax.set_ylabel`)：坐标轴名称标签。说明 X 轴和 Y 轴分别代表什么物理含义。
- Major/Minor tick (`set_major_locator` / `set_minor_locator`)：主刻度与次刻度。长一点的是主刻度（如 0, 1, 2），短一点的是次刻度（如 0.25, 0.5）。
- Major/Minor tick label (`set_major_formatter` / `set_minor_formatter`)：刻度文字标签。即显式印在刻度旁边的数字或文字（如“3”或“3.25”）。
## 1.4 编码风格
### 1.4.1 风格说明
matplotlib支持两种编码风格：显式接口风格（也叫"object-oriented style“，简称"OO-style"）与隐式接口风格（也叫"pyplot-style"）。简介如下。
- OO-style：显式地创建画布与子图，在它们的基础上调用各种控制数据或样式的方法。
- pyplot-style：依赖于 pyplot 隐式地创建与管理画布与子图，使用 pyplot 函数进行盲盒式管理来画图。

在隐式风格中，Matplotlib 在幕后维护着一个“当前活动状态机”。当用户直接调用 `plt.plot()` 这种函数时，用户明明从来没有亲手创建过画布（Figure）和子图（Axes），但图却画出来了。这就是因为 `pyplot` 在自动进行以下隐式管理：
- **自动创建**：发现用户明确没建画布？它会自动在后台建一个 `Figure`，并在里面塞进一个默认的子图 `Axes`。
- **自动追踪（最核心的管理）**：如果用户一口气开了好几个窗口，或者画了好几个子图，`pyplot` 会在后台死死盯着：“哪一个画布是当前用户正在操作的？哪一个子图是当前活跃的？” **
- **自动路由**：比如当用户敲下 `plt.title("我的图")` 时，`pyplot` 管理系统会立刻把这个标题发送给 当前处于活跃状态的那张画布里的那个子图 。

个人认为，使用OO-style时，可以继承自己以前所学的面向对象编程思想来使用matplotlib画图，也更符合平常人思维习惯（明确责任主体，拿到句柄，使用句柄进行定点操作），当然**OO-style是matplotlib是官方推荐的编码风格**。

这两种编程风格的差异与权衡参见官网解释：[Matplotlib Application Interfaces (APIs)](https://matplotlib.org/stable/users/explain/figure/api_interfaces.html#api-interfaces)
### 1.4.2 the OO-style示例
```python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 2, 100)  # Sample data.

# Note that even in the OO-style, we use `.pyplot.figure` to create the Figure.
# 创建画布与子图。
"""
figsize=(5, 2.7)：其中创建了一张 “宽 5 英寸、高 2.7 英寸”（matplotlib中的默认单位是英寸） 的画布。英寸到像素的转换取决于一个叫 “DPI（每英寸像素点数，默认值是100） 的参数，所以会创建一个“宽500像素、高270像素” 的画布。
layout='constrained'：自动优化防止标签重叠溢出。考虑到调整画布尺寸，有些元素（比如标题、坐标轴标签）可能会被挤到画布边缘甚至切掉。加上此参数值它可以帮忙 计算并优化子图与大画布边缘的留白，确保用户无论把 `figsize` 改成什么奇怪的比例，轴标签和标题都绝对不会溢出画布。
"""
fig, ax = plt.subplots(figsize=(5, 2.7), layout='constrained') # 
ax.plot(x, x, label='linear')  # Plot some data on the Axes.
ax.plot(x, x**2, label='quadratic')  # Plot more data on the Axes...
ax.plot(x, x**3, label='cubic')  # ... and some more.
ax.set_xlabel('x label')  # Add an x-label to the Axes.
ax.set_ylabel('y label')  # Add a y-label to the Axes.
ax.set_title("Simple Plot")  # Add a title to the Axes.
ax.legend();  # Add a legend.
# plt.show() # 展示图形
```
### 1.4.3 the pyplot-style示例
```python
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(0, 2, 100)  # Sample data.

plt.figure(figsize=(5, 2.7), layout='constrained')
plt.plot(x, x, label='linear')  # Plot some data on the (implicit) Axes.
plt.plot(x, x**2, label='quadratic')  # etc.
plt.plot(x, x**3, label='cubic')
plt.xlabel('x label')
plt.ylabel('y label')
plt.title("Simple Plot")
plt.legend();
# plt.show() # 展示图形
```
## 1.5 绘图模板
就像写作文、论文会有相关模板一样，为了便于记忆与掌握其编写模式，也可以为使用matplotlib画图创建一个干净、规范且高度精简的 Matplotlib **显式（面向对象风格）** 绘图模板，方便初学者上手。
同时可以此基础上添加一些其他复杂的配置与操作。

精简注释版本如下：
```python
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 1: 准备数据 (Data Preparation)
# ==============================================================================
x = np.linspace(0, 2, 100)
y = x ** 2

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图 (Figure & Axes)
# ==============================================================================
fig, ax = plt.subplots()

# ==============================================================================
# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
ax.plot(x, y, label='Quadratic Curve', linewidth=2, linestyle='-')

# ==============================================================================
# STEP 4: 装饰与标注 (Customizing Labels, Title & Legend)
# ==============================================================================
ax.set_xlabel('X Axis Label')                     
ax.set_ylabel('Y Axis Label')                     
ax.set_title('Standard Template Simple Plot')     
ax.legend(loc='upper left')                       

# ==============================================================================
# STEP 5: 输出与渲染 (Display & Save)
# ==============================================================================
plt.show();
```

详细注释版本如下：
```python
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 0: 修改全局设置 (rcParams Settings)
# ==============================================================================
# 设置具体字体为黑体
plt.rcParams['font.sans-serif'] = ['SimHei']
# 解决负号 '-' 显示为方块的问题
plt.rcParams['axes.unicode_minus'] = False

# ==============================================================================
# STEP 1: 准备数据 (Data Preparation)
# 官网参考: https://matplotlib.org/stable/users/explain/quick_start.html#types-of-inputs-to-plotting-functions
# ==============================================================================
x = np.linspace(0, 2, 100)
y = x ** 2

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图 (Figure & Axes)
# 官网参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplots.html
# ==============================================================================
fig, ax = plt.subplots()

# ==============================================================================
# STEP 3: 绘制核心图表 (Plotting)
# 官网参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.plot.html
# ==============================================================================
# label 用于图例展示，linewidth 控制线粗，linestyle 控制线型
ax.plot(x, y, label='Quadratic Curve', linewidth=2, linestyle='-')

# ==============================================================================
# STEP 4: 装饰与标注 (Customizing Labels, Title & Legend)
# 轴标签参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xlabel.html
# 标题参考:   https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_title.html
# 图例参考:   https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.legend.html
# ==============================================================================
ax.set_xlabel('X Axis Label')                     # 设置 X 轴名称
ax.set_ylabel('Y Axis Label')                     # 设置 Y 轴名称
ax.set_title('Standard Template Simple Plot')     # 设置图表正标题
ax.legend(loc='upper left')                       # 激活图例并固定在左上角

# ==============================================================================
# STEP 5: 输出与渲染 (Display & Save)
# 显示参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.show.html
# 保存参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.savefig.html
# ==============================================================================
# 如果需要保存图片到本地，取消下面这行的注释（必须在 plt.show() 之前调用）
# plt.savefig('my_plot.png', dpi=300)
"""
`plt.show()` 函数本身的返回值就是 `None`。也就是说，即使不加分号，直接写 `plt.show()`，Jupyter 也绝对不会打印任何内存地址。但可以养成良好的习惯：总是给最后一行语句末尾加上“;”
"""
plt.show();
```



