---
title: python绘图库-matplotlib-chp4
date: 2026年6月10日20:54:59
tags:
  - matplotlib
  - PyTorch
categories: Python画图
math: "False"
---
# 四、Matplotlib中对图表的操作

## 4.1 rcParams全局配置参数
### 4.1.1 包含中文的画图示例
```python
# 导包
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 1: 准备数据
# 官网参考: https://matplotlib.org/stable/users/explain/quick_start.html#types-of-inputs
# ==============================================================================
x = np.arange(-5, 5, 0.1)
y = np.sin(x)

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图
# 官网参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplots.html
# ==============================================================================
# 使用 layout='constrained' 确保移动坐标轴后，刻度标签不会溢出大画布
# fig, ax = plt.subplots(figsize=(6, 5), layout='constrained')
fig, ax = plt.subplots()

# ==============================================================================
# STEP 3: 调整边框位置，使零点坐标在 (0,0) 处。此操作可选，调整零点坐标到 (0,0) 处只为了更符合我们的画图习惯
# 官网参考: https://matplotlib.org/stable/api/spines_api.html#matplotlib.spines.Spine.set_position
# ==============================================================================
# 1. 将上方和右方的边框线设置为透明/隐形
ax.spines['top'].set_color('none')
ax.spines['right'].set_color('none')

# 2. 将下边框（X轴）和左边框（Y轴）强制移动到数据坐标的 0 点位置
ax.spines['bottom'].set_position(('data', 0))
ax.spines['left'].set_position(('data', 0))

# ==============================================================================
# STEP 4: 绘制核心图表
# 官网参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.plot.html
# ==============================================================================
ax.plot(x, y, label='sin(x)', linewidth=2, linestyle='-')

# ==============================================================================
# STEP 5: 装饰与标注
# 轴标签参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xlabel.html
# 标题参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_title.html
# 图例参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.legend.html
# 文本参考：https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.text.html
# ==============================================================================
# 1. X轴、Y轴标签传入空字符串（默认就是空字符串）
ax.set_xlabel('')
ax.set_ylabel('')

# 2. 手动在第一象限指定位置“钉”上文本
# x=5.0, y=0.05 -> 正好在 X 轴最右端的上方
# ha='right' (右对齐) 确保文字不超出右边界，va='bottom' (底部对齐) 确保它悬浮在轴线上方
ax.text(5.5, 0.05, 'X 坐标轴', ha='right', va='bottom', fontsize=10)

# x=0.1, y=1.0  -> 正好在 Y 轴最顶端的右侧
# ha='left' (左对齐) 确保文字往右边长，va='top' (顶部对齐) 让它跟顶端刻度基本平齐
ax.text(0.1, 1.1, 'Y 坐标轴', ha='left', va='top', fontsize=10, rotation=0)

ax.set_title("正弦曲线", fontsize=14, pad=20) # 适当加点 pad 别让标题和Y轴标签撞车
ax.legend(loc='upper right')                             # 激活图例并固定在右上角

# ==============================================================================
# STEP 6: 输出与渲染
# 显示参考: https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.show.html
# ==============================================================================
plt.show() ;  # 末尾加分号防止在 Jupyter 中打印内存地址文字
```
![](https://files.seeusercontent.com/2026/07/14/j7yC/20260714223422823.png)

此图就是上述代码绘制出来的（整个图表没有什么大问题，只是坐标轴名称与子图名称中的中文未正常显示）。其中各行代码已经添加了注释，且其具体用法与解释也已经标出matplotlib官网对应的api解释页面的链接。

有两点需要注意到：
- 上述代码中并没有显式指出线条颜色、线条宽度、画布背景色等参数，它就已经有了默认值，这就是 `rcParams`全局参数在起作用。
- 上述代码绘制出来的图表中，坐标轴名称与子图名称中的中文显示成了乱码样式的框框，这也是因为 `rcParams`全局参数中有一个默认字体相关配置，但其默认字体不支持中文。如果要正常显示中文，就需要修改字体。
### 4.1.2 rcParams介绍

为了解上述中文显示乱码的问题，只需要在上述代码段的最前面添加如下内容：
```python
plt.rcParams['font.family'] = ['sans-serif'] # 可选。因为默认值就是['sans-serif']
plt.rcParams['font.sans-serif'] = ['SimHei'] # 必选
```



- rcParams基本介绍
  - rcParams 全称是 Runtime Configuration Parameters（运行时配置参数）。在 Matplotlib 中，`rcParams` 是整个库的“中央控制大厅”或“全局配置字典”。
  	
  - 当用户没有在代码（比如 `plt.figure()`）里显式指定颜色、字体大小、线条粗细时，Matplotlib 就会像翻阅“员工守则”一样去翻阅 `rcParams`，看看里面默认规定了什么，然后使用这些默认配置参数值画图。
  	
  - 关于`rcParams`全局参数的所有默认值，可以在此官网页面查看：[matplotlib-configuration-rcparam](https://matplotlib.org/stable/users/explain/configuration.html#matplotlib-configuration-rcparams)。此外，已经安装到本地的matplotlib可以在此文件中查看其默认值：`{python环境}\Lib\site-packages\matplotlib\mpl-data\matplotlibrc`。个人认为，如果没有特殊要求，就不用特意记忆（配置实在太多难以记忆）与关注，有需要时就查阅文档找到对应的配置名，手动设置新值以覆盖默认值。

---
- 它在代码里长什么样？
	- 在底层，`rcParams` 其实就是一个**继承自 Python 原生字典（dict）的对象**。它里面用“键值对（Key-Value）”存储了成百上千条控制画图外观的默认规则。
	
	- 例如，官方文档里写的那句： `default: rcParams["figure.facecolor"] (default: 'white')` 在 Python 后台翻译过来就是：
	
	  
```Python
import matplotlib.pyplot as plt

# 设置全局配置中画布背景色默认为white
plt.rcParams["figure.facecolor"] = 'white'

# 查看当前的全局配置中画布背景色默认是什么
print(plt.rcParams["figure.facecolor"])  # 输出: 'white'
...
```



---
- 核心作用
	- 免去重复写参数的麻烦。如果要在同一个脚本里画 10 张图，并且希望它们的背景统统都是灰色、线条都是虚线。如果不用 `rcParams`，就必须在每个 `plt.figure(facecolor='gray')` 里都写一遍。 有了 `rcParams`，只需要在脚本最开头改一次“全局出厂设置”，后面所有的绘图都会自动继承。
	- 让 Matplotlib 支持中文。在用 Matplotlib 画图时，要让图表中正常显示中文，就要修改`rcParams` 里的默认字体集（配置名：'font.sans-serif'，默认值是一个列表）为'SimHei'。
	- 支撑“一键换肤”功能。使用此功能可以一键切换成 `ggplot`、`seaborn` 甚至“暗黑模式”的炫酷换肤功能。这个换肤功能的本质，就是 Matplotlib 官方写好了一个个配置文件，当调用它时，它会批量、打包地把全新的参数覆盖进 `rcParams` 字典里。

---

- 配置是从哪里被加载进来的？
	当用户启动 Python 环境并 `import matplotlib` 的那一刹那，系统会按照以下**优先级顺序**去寻找并读取配置，最终合并进内存中的 `rcParams` 字典：
	- 当前代码运行期修改（最高优先级）：即在代码里写的 `plt.rcParams[...] = ...`。
	- 当前工作目录下的文件：如果当前文件夹下有一个名为 `matplotlibrc` 的文件，系统会读取它。
	- 用户个人家目录下的文件：存放在 `C:\Users\你的用户名\.matplotlib\matplotlibrc`（或者是 `.config/matplotlib/matplotlibrc`）。
	- Matplotlib 安装包自带的出厂设置：也就是`{python环境}\Lib\site-packages\matplotlib\mpl-data\matplotlibrc` 这个纯文本文件。官方文档里写的那些默认全局配置就是写在这个源文件里的（比如`figure.facecolor:   white`）。
## 4.2 pyplot.plot常用调用形式
官网文档：[matplotlib.pyplot.plot.html](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.plot.html)
它是一个用来绘制拆线图的方法。官方源码提供的matplotlib.pyplot.plot 函数的声明如下：
```python
matplotlib.pyplot.plot(*args, scalex=True, scaley=True, data=None, **kwargs)
```

其中第一个参数`args`是可变位置参数背包，看了后不明所以，光看声明的话，看了跟没看一样。所以matplotlib官网提供了几个常用的调用签名（相当于是给出了第一个参数`args`的一些具体例子）：
```python
#（1）调用签名1：这是最常用的调用形式（推荐！规范、优雅的 OO 风格写法）
plot([x], y, [fmt], *, data=None, **kwargs)
#（2）调用签名2：这种调用形式有点像是对“调用签名形式（1）”的扩展，它允许用户在单行代码里，一口气画出N条不同的线，即把多条线揉在一行写，会导致代码变得极其冗长、难以阅读。还是推荐分成N个语句来写，就是说推荐拆成N个“调用签名形式（1）”对应的语句。
plot([x], y, [fmt], [x2], y2, [fmt2], ..., **kwargs)
#（3）调用签名3：使用带标签的数据。它是matplotlib在老api（上述两种）的基础上，为了兼容python数据分析生态爆发导致Pandas流行而推出的兼容的调用签名
plot('xlabel', 'ylabel', data=obj)
```
下面分别对上述3种常见调用签名进行说明与举例（其中重点是调用签名1与调用签名3）。
### 4.2.1 调用签名1
```python
#（1）调用签名1：这是最常用的调用形式（推荐！规范、优雅的 OO 风格写法）
plot([x], y, [fmt], *, data=None, **kwargs)
```
说明：
- 其中第一个参数`[x]`：表示x轴上的数据，是可选的，可传可不传。当不传它时，因为`y`是必传的，系统会根据`y`的值来推断确认参数`x`的值，使用的方法叫做“序列的自然索引（Index）”。此处不给出此方法的严格定义，它在此处大概的意思与效果“就是根据`y`的值调用 NumPy 的 `np.arange()` 机制来为 X 轴量身定制一组“自然索引（Index）”，参数`x`的具体信息或确认规则如下：
	- 元素个数：严格与 y 的元素个数保持 1:1 完全一致。
	- 元素类型：默认生成标准的 64 位整型（`numpy.int64`）。
	- 起点值：永远从 `0` 开始。
	- 步长：固定为 `1`。
	- 终点值：终点值为 `N - 1`（其中 $N$ 为 `y` 的元素个数）。在数学区间上，它就是一个左闭右开的集合 $[0, N)$。
- 参数`y`：表示y轴上的数据，它必须要传。就是说当只传入一个坐标轴上的数据时，系统默认就认为传入了y坐标轴上的数据。
- [fmt]是 Format String（格式字符串） 的缩写。它是一个极度精简的“快捷皮肤代码”，用几个极度精简的字符同时指定线条的特征如**颜色、线型和标记点形状**。
- `*`（星号占位符）：这是一个 Python 语法强制限止符。意味着星号后面的所有参数，用户在调用时必须写出参数名，即必须使用关键字参数。
- data参数：在使用此调用签名1这种用户签名时，这个参数不需要传值。传值了就变成了调用签名3 ，此时需要对应改变第1、2参数的值。
- `kwargs`（关键字参数）：它是一个大杂烩。在`[fmt]` 里没法用一两个字符表达的、精细的外观控制参数，就通过 `kwargs` 来控制，这些控制参数有很多，比如线条宽度（`linewidth`）和图例名字（`label`），具体见：[matplotlib-pyplot-plot文档](https://github.com/matplotlib/matplotlib/blob/v3.11.0/lib/matplotlib/pyplot.py#L4035-L4049)

举例：
```python
import matplotlib.pyplot as plt

y = range(1,4)

#x值根据y推断出来：为[0,1,...,N-1] 。其中N为y的长度3
fig, ax = plt.subplots()

ax.plot(y)

plt.show();
```
![Pasted image 20260614210138](https://files.seeusercontent.com/2026/06/14/O9en/Pasted-image-20260614210138.png)
### 4.2.2 调用签名2
根据分析，个人认为，这种调用签名形式**不推荐**。此处记录下，以便后续看到此用法也要认识。

```python
#（2）调用签名2：这种调用形式有点像是对“调用签名形式（1）”的扩展，它允许用户在单行代码里，一口气画出N条不同的线，即把多条线揉在一行写，会导致代码变得极其冗长、难以阅读。还是推荐分成N个语句来写，就是说推荐拆成N个“调用签名形式（1）”对应的语句。
plot([x], y, [fmt], [x2], y2, [fmt2], ..., **kwargs)
```
它允许用户在单行代码里，一口气画出N条不同的线，即把多条线通过一个语句画出来，会导致代码变得极其冗长、难以阅读。一旦报错，很难一眼看出是第几条线的数据出了问题。所以推荐分成N个语句来写，就是说推荐拆成N个“调用签名1形式”对应的语句。
```python
# 导入 matplotlib 库中的 pyplot 模块，并简写为 plt，用于后续的图表绘制与展示
import matplotlib.pyplot as plt

# 导入 NumPy 科学计算库，并简写为 np，用于高效生成高密度的矩阵数据
import numpy as np

# 使用 np.arange(start, stop, step) 生成一个等差数列的一维数组作为 X 轴坐标
# 起点为 1，终点为 2.05（左闭右开，实际不包含 2.05，所以最大到 2.00），步长为 0.05
# 这行代码一共生成了 21 个高密度的采样点：[1.0, 1.05, 1.1, ..., 1.95, 2.0]
x = np.arange(1, 2.05, 0.05)   

# 根据 X 轴的数组，利用 NumPy 的广播机制，点对点地计算出三组对应的 Y 轴坐标数据
y1 = x    # 第一条线的数据：y = x（斜率为 1 的直线）
y2 = 2*x  # 第二条线的数据：y = 2x（斜率为 2 的直线）
y3 = 3*x  # 第三条线的数据：y = 3x（斜率为 3 的直线）

# 调用 plt.subplots() 创建一个画布（fig）和一个子图坐标系（ax）
# 这是 Matplotlib 最推荐的面向对象写法，后续的所有画图动作都将在 ax 上展开
fig, ax = plt.subplots()

# 在子图 ax 上绘制折线图，采用的是官方第二种多线签名模式：plot(x1, y1, x2, y2, x3, y3)
# 传入参数必须满足“偶数个、成对出现”的铁律，这里一口气画出了三条独立的直线
ax.plot(x, y1, x, y2, x, y3)

# 全局渲染指令，负责把内存中构建好的完整图表在屏幕上弹窗或在 Notebook 中展现实体图像
plt.show()
```
拆分成N个“调用签名1形式”对应的语句，如下：
```python
# 导入 matplotlib 库中的 pyplot 模块，并简写为 plt，用于图表的创建、控制和最终显示
import matplotlib.pyplot as plt

# 导入 NumPy 科学计算库，并简写为 np，用于高效生成和处理高密度的多维数组数据
import numpy as np

# 使用 np.arange(start, stop, step) 创建一个等差数列作为三条线的公共 X 轴坐标
# 起点为 1，终点为 2.05（左闭右开区间，实际不包含 2.05，最高到 2.00），步长为 0.05
# 这行代码会在内存中生成包含 21 个高密度数据点的数组：[1.0, 1.05, 1.1, ..., 1.95, 2.0]
x = np.arange(1, 2.05, 0.05)

# 结合 X 轴数组，利用 NumPy 的数组广播机制，分别计算出三组对应的 Y 轴数据
y1 = x    # 第一条线的数据公式：y = x（斜率为 1 的直线数据）
y2 = 2*x  # 第二条线的数据公式：y = 2x（斜率为 2 的直线数据）
y3 = 3*x  # 第三条线的数据公式：y = 3x（斜率为 3 的直线数据）

# 调用 subplots() 函数创建一个画布（fig）和该画布上的一个子图坐标系（ax）
# 这是面向对象风格（OO-style）的核心，后续所有图形的绘制和微调都将作用在 ax 对象上
fig, ax = plt.subplots()

# 在当前的子图坐标系 ax 上分别绘制三条独立的折线
# 每一行严格遵循 plot(x, y) 形式，传入一组明确的横纵坐标，由系统内部自动完成连线渲染
ax.plot(x, y1)  # 绘制第一条直线（默认会使用系统自带的第一种主题颜色，通常是蓝色）
ax.plot(x, y2)  # 绘制第二条直线（默认会使用系统自带的第二种主题颜色，通常是橙色）
ax.plot(x, y3)  # 绘制第三条直线（默认会使用系统自带的第三种主题颜色，通常是绿色）

# 全局绘图渲染指令，负责将内存中 ax 坐标系里已经画好的三条线真刀真枪地渲染出来
# 它会唤起系统的图形窗口或者在 Jupyter Notebook 中直接输出最终的实体可视化图像
plt.show()
```
![Pasted image 20260614210256](https://files.seeusercontent.com/2026/06/14/n3iP/Pasted-image-20260614210256.png)
### 4.2.3 调用签名3
按照上述已有知识进行画图，必须先把数据从字典里解包出来，写成 `ax.plot(my_dict['x']、my_dict['y'])`之类的形式以分别给x轴、y轴传递数据。
随着 Python 数据分析生态的爆发，Pandas DataFrame 变成了大家的家常便饭。为了兼容老用户的习惯，同时不增加新的函数名（比如再造一个 `plot_dataframe()` 之类的函数，就会让 API 变得臃肿），官方决定对原有的 `plot` 进行了“兼容性改造”：
- 如果不传 `data`，plot方法像个传统的数学计算器，去接收数字序列（就是 **调用签名1** 与 **调用签名2** 两种形式）。
- 如果传了 `data`，plot方法就切换成大管家式的兼容性模式，允许用户用字符串列名来从data中获取对应列的数据（这就是 **调用签名3**）。

- 调用签名3的形式如下：
```python
"""
data 参数支持所有可索引对象。例如，它可以是字符串dict、数组 pandas.DataFrame或结构化的 NumPy 数组。

'xlabel'与'ylabel'是data对象中的可索引键
"""
plot('xlabel', 'ylabel', data=obj)
```
- 调用签名3的示例如下：
```python
import matplotlib.pyplot as plt
import pandas as pd

# 模拟一个从 CSV 或数据库中读取出来的 Pandas DataFrame 表格
df = pd.DataFrame({
    'timestamp': [10, 20, 30, 40, 50],
    'temperature': [22.5, 23.1, 21.8, 24.0, 23.5],
    'humidity': [60, 55, 58, 62, 61]
})

# 创建画布与子图
fig, ax = plt.subplots()

# 传入相同的 data 数据源，通过更换字符串列名，轻松在一张图上画两条线
# 第一条线：横轴是时间，纵轴是温度，快捷线型为蓝色实线 'b-'
ax.plot('timestamp', 'temperature', 'b-', data=df, label='Temperature (°C)')

# 第二条线：横轴依然是时间，纵轴切换为湿度，快捷线型为绿色虚线 'g--'
ax.plot('timestamp', 'humidity', 'g--', data=df, label='Humidity (%)')

ax.set_xlabel('Time (s)')
ax.set_title('Sensor Data Summary')
ax.legend()

plt.show()
```
![Pasted image 20260614213404](https://files.seeusercontent.com/2026/06/14/pDy1/Pasted-image-20260614213404.png)

## 4.3 容器与框架层常用操作
### 4.3.1 画布操作
官网文档链接：[matplotlib.pyplot.figure.html](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.figure.html)
创建一个新画布或激活一个已存在画布的方法声明如下：
```python
matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, *, facecolor=None, edgecolor=None, frameon=True, FigureClass=<class 'matplotlib.figure.Figure'>, clear=False, **kwargs)
```
其中主要或常用的参数如下：
- `num=None`：画布序号，整数/字符串/Figure实例/SubFigure实例。这个序号在matplotlib后台管理的所有的画布中是唯一的，就是说每个画布都有一个唯一的序号。个人认为一般不用设置此参数，而是交由系统自动管理。如果传递了此参数，则它的机制如下：
	- 如果不传递此参数，则是新创建画布，系统会自动为新创建的画布自动指定一个在整个系统中递增的且唯一的整数序号，默认从1开始往上增加，寻找当前未被占用的最小正整数。
	- 如果传递的num值是一个已存在画布的序号，则此序号对应的画布就被激活并返回此画布对象；如果传递的num值不代表任何已存在的画布，则一个新画布被创建、激活并返回，且此画布的序号就为此num值。
	- 如果传递的num参数值是一个字符串，也是新创建画布，传递的字符串就是画布标签和窗口标题，这个字符串本身就是这个画布的唯一序号（标识）。
	- 如果传递的是Figure实例，当此实例已经被pyplot所追踪管理到，则此画布被激活、返回；如果此实例还没有被pyplot所追踪管理到，则它将被追踪管理到，并被激活、返回。
	- 如果传递的是SubFigure实例，则它的父画布被激活、返回。
	
- `figsize=None`：画布尺寸，参数形式与类型是`(float, float) or (float, float, str)`，不显式传递时使用默认值(6.4, 4.8)。具体情况如下：
	- 如果传递形式是`(float, float)`，则它们分别代表画布的宽、高，单位是英寸。
	- 如果传递形式是`(float, float, str)`，则它们分别代表画布的宽、高、单位，单位只能是"inch"/"cm"/"px"之一，它们分别代表英寸/厘米/像素。
	- 宽度或高度可以使用None，此时为None参数就会使用其默认值。即如果宽度为None即(None, height)则使用(6.4, height)，如果高度为None即(width, None)则使用(width, 4.8)，如果两者同时为None即(None, None)则使用(6.4, 4.8)。
	
- `facecolor=None`：画布背景颜色。默认值是`rcParams["figure.facecolor"]`，而此全局配置的默认值是'white'。
	
- `layout=None`：画布内元素的布局机制。如果使用默认值None，则系统此时会读取 `rcParams["figure.layout_engine"]`（出厂默认为 `'none'`），不使用任何布局算法，可以把此参数设置为matplotlib已提供的布局机制之一，也可使用自定义布局机制，主要用它定位绘图元素的布局机制，旨在避免坐标轴装饰元素（标签、刻度等）重叠。可选的值有：`{'constrained', 'compressed', 'tight', 'none', LayoutEngine, None}`，**官方推荐在一般情况下直接使用'constrained'**，使用此参数值时，系统会自动调整坐标系尺寸以避免坐标轴装饰元素重叠，能够处理复杂的子图布局与颜色块如图例；'LayoutEngine'就是自定义布局机制。
	
- `clear=False`：当传递一个已存在的 `num`（无论是整数还是字符串）来**激活**老画布时，如果 `clear=True`，老画布会被清空重练，激活后老画布后然后返回此画布；如果 `clear=False`（默认值），老画布会被原封不动地唤醒并返回。
```python
### 画布学习：创建两个画布 
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 1: 准备数据 (Data Preparation)
# ==============================================================================
x1 = np.linspace(0, 2, 100)
y1 = x1 ** 2
y2 = np.arange(1, 5, 1)

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图 (Figure & Axes)
# ==============================================================================
fig1, ax1 = plt.subplots(num=1, figsize=(6, 4.8, "in"), facecolor="w", layout="constrained")
fig2, ax2 = plt.subplots(num=2, figsize=(6.4, 5.2), facecolor="gray", layout="compressed")

# ==============================================================================
# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
ax1.plot(x1, y1, label='Quadratic Curve', linewidth=2, linestyle='-')
ax2.plot(y2, label='Line', linewidth=2, linestyle='--')

# ==============================================================================
# STEP 4: 装饰与标注 (Customizing Labels, Title & Legend)
# ==============================================================================
ax1.set_xlabel('X1 Axis Label')                     
ax1.set_ylabel('Y1 Axis Label')                     
ax1.set_title('Standard Template Simple Plot1')     
ax1.legend(loc='upper left')                       

# ==============================================================================
# STEP 5: 输出与渲染 (Display & Save)
# ==============================================================================
plt.show() ;
```

![363](https://files.seeusercontent.com/2026/06/16/4hFa/20260616153709011.png)![320](https://files.seeusercontent.com/2026/06/16/W0he/20260616154452374.png)

### 4.3.2 子图操作
#### 4.3.2.1 在画布中创建多个均匀子图
官方文档：[matplotlib-pyplot-subplots](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplots.html#matplotlib-pyplot-subplots)。此方法常在画布网格中各子图**均匀分布**时使用（比如 4 张图均分画布）。方法声明如下：
```python
matplotlib.pyplot.subplots(nrows=1, ncols=1, *, sharex=False, sharey=False, squeeze=True, width_ratios=None, height_ratios=None, subplot_kw=None, gridspec_kw=None, **fig_kw)
```
matplotlib中创建多子图时，会将整个画布划分成m行n列的网格，每个子图可能占据其中1到多个网格。

此方法常用参数解释（如果没有出现在调用签名中，那就是kwargs关键字参数）：
- rows：整数，表示画布分成几行。
- ncols：整数，表示画布分成几列。

示例1：
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
# 相当于plt.subplots(1,1)，画布中只有一行一列，即一个子图
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
plt.show() ;
```

---

示例2：
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

# STEP 1: 准备数据
x = np.linspace(0, 2 * np.pi, 100)

# STEP 2: 一步到位创建 2x2 矩阵网格
fig, axs = plt.subplots(nrows=2, ncols=2, figsize=(10, 8), layout='constrained')
# print(type(axs))  #此处 axs 的类型是numpy.ndarray

# ==============================================================================
# 1. 操控 [0, 0] 位置 —— 左上角格子
# ==============================================================================
axs[0, 0].plot(x, np.sin(x), color='tab:blue', linewidth=2)
axs[0, 0].set_title('子图 [0, 0]: 正弦波')  
axs[0, 0].grid(True, linestyle='--', alpha=0.6) 

# ==============================================================================
# 2. 操控 [0, 1] 位置 —— 右上角格子
# ==============================================================================
axs[0, 1].plot(x, np.cos(x), color='tab:orange', linewidth=2)
axs[0, 1].set_title('子图 [0, 1]: 余弦波')  

# ==============================================================================
# 3. 操控 [1, 0] 位置 —— 左下角格子
# ==============================================================================
axs[1, 0].plot(x, np.sin(2 * x), color='tab:green', linewidth=2)
axs[1, 0].set_title('子图 [1, 0]: 高频正弦波')  

# ==============================================================================
# 4. 操控 [1, 1] 位置 —— 右下角格子
# ==============================================================================
axs[1, 1].plot(x, np.sin(x / 2), color='tab:red', linewidth=2)
axs[1, 1].set_title('子图 [1, 1]: 低频正弦波')  

# STEP 4: 统一微调全局大标题
fig.suptitle('均匀矩阵网格多子图（2x2）', fontsize=16, weight='bold')  

# STEP 5: 渲染输出
plt.show();
```
![](https://files.seeusercontent.com/2026/06/16/s9eQ/20260616223755831.png)

---
#### 4.3.2.2 向画布中逐渐添加子图
##### 4.3.2.2.1 figure-add-subplot(推荐)
官方文档：[matplotlib-figure-figure-add-subplot](https://matplotlib.org/stable/api/_as_gen/matplotlib.figure.Figure.add_subplot.html#matplotlib-figure-figure-add-subplot)。方法声明如下：
```python
Figure.add_subplot(*args, **kwargs)
```
作用是在图中添加一个元素，作为子图布局的一部分。

此方法常在画布网格中各子图**不均匀分布**时使用。常用调用签名如下：
```python
add_subplot(nrows, ncols, index, **kwargs)
```
其中常用参数解释如下：
- nrows, ncols, index：3个整数或一个SubplotSpec对象，表示表格画布有几行几列个网格、添加的子图的索引是多少。默认值是(1, 1, 1)。实际传递整数时也有两种形式，如下。
	- 形如`fig.add_subplot(nrows, ncols, index)`，表示画布被分成了nrows行、ncols列 的网格，当前向画布中添加的子图所对应的网格的索引（添加的子图可能跨越多个网格。网格索引从1开始，从上到下、从左往右每隔一个网格索引递增1）。**推荐此形式。**
		
	- 直接将`nrows, ncols, index`实际上对应的3个数字合并成一个数字，比如`fig.add_subplot(235)`，其实等价于`fig.add_subplot(2,3,5)`。此形式只能在网格总数不多于9个时使用，因为10无法在上述参数中准确表达。
		
	- 传递一个SubplotSpec对象时，暂时不关注。
	
- projection：kwargs关键字参数可传递的实际参数，表示添加的子图所使用坐标系类型。有如下列表中有元素可选：`{None, 'aitoff', 'hammer', 'lambert', 'mollweide', 'polar', 'rectilinear'}`，可不传递使用默认值None，当前与传递'rectilinear'（直角坐标系）一样的效果，另外'polar'表示极坐标系。
	
- `sharex, sharey`：kwargs关键字参数可传递的实际参数，分别表示添加的子图与这两个参数值共享x坐标或y坐标，值类型是坐标系。设置后将与共享坐标轴的轴具有相同的范围、刻度和比例。
	
- `label`：kwargs关键字参数可传递的实际参数，表示添加的子图的名称，值类型是字符串。

示例：
```python
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 0: 修改全局设置 (rcParams Settings)
# ==============================================================================
# 设置具体字体为黑体
plt.rcParams['font.sans-serif'] = ['SimHei']
# 解决负号 '-' 显示为方块的问题
plt.rcParams['axes.unicode_minus'] = False

# 准备模拟数据
t = np.linspace(0, 2 * np.pi, 200)
y_sin = np.sin(t)
y_cos = np.cos(t)

# STEP 1: 创建顶级画布
fig = plt.figure(figsize=(10, 8), layout="constrained")

# ==============================================================================
# 示例 1: 跨格子的子图 (利用文档提到的元组 index 机制)
# 假装切分成 2 行 2 列的网格，但让第一个子图占据第一行的左右两个格子 (1, 2)
# ==============================================================================
ax1 = fig.add_subplot(2, 2, (1, 2))
ax1.plot(t, y_sin, color="tab:blue", linewidth=2)
ax1.set_title("子图 1: 宽的顶部子图 (跨越索引1与2)")

# ==============================================================================
# 示例 2: 紧凑 3 位数简写形式 (对应文档 235 逻辑)
# 在刚才 2 行 2 列的底座下，第 2 行的左边格子就是第 3 个位置
# ==============================================================================
ax2 = fig.add_subplot(223)  # 等价于 (2, 2, 3)
ax2.plot(t, y_cos, color="tab:orange", linewidth=2)
ax2.set_title("子图 2: 左下子图 (三位数缩写法)")

# ==============================================================================
# 示例 3: 更改投影机制 (对应文档 projection='polar' 逻辑)
# 在 2 行 2 列网格中，第 4 个位置（右下角）创建一个极坐标系
# ==============================================================================
ax3 = fig.add_subplot(2, 2, 4, projection='polar')
ax3.plot(t, t, color="tab:green", linewidth=2) # 绘制阿基米德螺旋线
ax3.set_title("子图 3: 右下子图 (极坐标子图)", pad=15)

# STEP 6: 显示画布
plt.show();
```
![](https://files.seeusercontent.com/2026/06/16/zz2H/20260616231134370.png)

官网还有很多官方示例：[examples-using-matplotlib-figure-figure-add-subplot](https://matplotlib.org/stable/api/_as_gen/matplotlib.figure.Figure.add_subplot.html#examples-using-matplotlib-figure-figure-add-subplot)
##### 4.3.2.2.2 pyplot-subplot
官方文档：[matplotlib-pyplot-subplot](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.subplot.html#matplotlib-pyplot-subplot)。方法声明如下：
```python
matplotlib.pyplot.subplot(*args, **kwargs)
```
作用是在图中添加一个元素，作为子图布局的一部分。

此方法常在画布网格中各子图**不均匀分布**时使用。常用调用签名如下：
```python
subplot(nrows, ncols, index, **kwargs)
```
其中常用参数解释如下：
- nrows, ncols, index：3个整数或一个SubplotSpec对象，表示表格画布有几行几列个网格、添加的子图的索引是多少。默认值是(1, 1, 1)。索引就把的子图如果不存在则新创建并返回、如果已存在直接激活并返回。实际传递整数时也有两种形式，如下。
	- 形如`fig.add_subplot(nrows, ncols, index)`，表示画布被分成了nrows行、ncols列 的网格，当前向画布中添加的子图所对应的网格的索引（添加的子图可能跨越多个网格。网格索引从1开始，从上到下、从左往右每隔一个网格索引递增1）。**推荐此形式。**
		
	- 直接将`nrows, ncols, index`实际上对应的3个数字合并成一个数字，比如`fig.add_subplot(235)`，其实等价于`fig.add_subplot(2,3,5)`。此形式只能在网格总数不多于9个时使用，因为10无法在上述参数中准确表达。
		
	- 传递一个SubplotSpec对象时，暂时不关注。
	
- projection：kwargs关键字参数可传递的实际参数，表示添加的子图所使用坐标系类型。有如下列表中有元素可选：`{None, 'aitoff', 'hammer', 'lambert', 'mollweide', 'polar', 'rectilinear'}`，可不传递使用默认值None，当前与传递'rectilinear'（直角坐标系）一样的效果，另外'polar'表示极坐标系。
	
- `sharex, sharey`：kwargs关键字参数可传递的实际参数，分别表示添加的子图与这两个参数值共享x坐标或y坐标，值类型是坐标系。设置后将与共享坐标轴的轴具有相同的范围、刻度和比例。
	
- `label`：kwargs关键字参数可传递的实际参数，表示添加的子图的名称，值类型是字符串。

示例：
```python
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 0: 修改全局设置 (rcParams Settings)
# ==============================================================================
# 设置具体字体为黑体
plt.rcParams['font.sans-serif'] = ['SimHei']
# 解决负号 '-' 显示为方块的问题
mpl.rcParams['axes.unicode_minus'] = False

# 准备模拟数据
t = np.linspace(0, 2 * np.pi, 200)
y_sin = np.sin(t)
y_cos = np.cos(t)

# STEP 1: 创建顶级画布
fig = plt.figure(figsize=(10, 8), layout="constrained")

# ==============================================================================
# 示例 1: 跨格子的子图 (利用文档提到的元组 index 机制)
# 假装切分成 2 行 2 列的网格，但让第一个子图占据第一行的左右两个格子 (1, 2)
# ==============================================================================
# ax1 = fig.add_subplot(2, 2, (1, 2))
# ax1 = plt.subplot(2, 2, (1, 2), figure=fig) 写法会报错。 官网文档显示此处可以传递figure参数，但实际调用时报错提示“TypeError: add_subplot() got an unexpected keyword argument 'figure'”
# 所以此处不传递figure参数，系统会把子图自动添加到最后创建的画布上
ax1 = plt.subplot(2, 2, (1, 2))   
ax1.plot(t, y_sin, color="tab:blue", linewidth=2)
ax1.set_title("子图 1: 宽的顶部子图 (跨越索引1与2)")

# ==============================================================================
# 示例 2: 紧凑 3 位数简写形式 (对应文档 235 逻辑)
# 在刚才 2 行 2 列的底座下，第 2 行的左边格子就是第 3 个位置
# ==============================================================================
# ax2 = fig.add_subplot(223)  # 等价于 (2, 2, 3)
ax2 = plt.subplot(2, 2, 3)
ax2.plot(t, y_cos, color="tab:orange", linewidth=2)
ax2.set_title("子图 2: 左下子图 (三位数缩写法)")

# ==============================================================================
# 示例 3: 更改投影机制 (对应文档 projection='polar' 逻辑)
# 在 2 行 2 列网格中，第 4 个位置（右下角）创建一个极坐标系
# ==============================================================================
# ax3 = fig.add_subplot(2, 2, 4, projection='polar')
ax3 = plt.subplot(2, 2, 4, projection='polar')
ax3.plot(t, t, color="tab:green", linewidth=2) # 绘制阿基米德螺旋线
ax3.set_title("子图 3: 右下子图 (极坐标子图)", pad=15)

# STEP 6: 显示画布
plt.show();
```
画出来的图跟[[#4.3.2.2.1 figure-add-subplot(推荐)]] 中示例代码绘制出来的图一样。
### 4.3.3 边框线操作（坐标轴设置）
关于边框线类型Spine的官网文档：[module-matplotlib.spines](https://matplotlib.org/stable/api/spines_api.html#module-matplotlib.spines)。但在实际使用过程中，一般不会通过Spine类直接创建实例，而是通过坐标系对象来获取，如下（重点查看“STEP 3: 调整边框”部分内容）。
```python
# 导包
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 1: 准备数据
# ==============================================================================
x = np.arange(-5, 5, 0.1)
y = np.sin(x)

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图
# ==============================================================================
# 使用 layout='constrained' 确保移动坐标轴后，刻度标签不会溢出大画布
# fig, ax = plt.subplots(figsize=(6, 5), layout='constrained')
fig, ax = plt.subplots()

# ==============================================================================
# STEP 3: 调整边框位置，使零点坐标在 (0,0) 处。此操作可选，调整零点坐标到 (0,0) 处只为了更符合我们的画图习惯
# ==============================================================================
# 1. 将上方和右方的边框线分别设置为红色、透明/隐形
ax.spines['top'].set(color='red') # 等价于 ax.spines['top'].set_color('red')
ax.spines['top'].set(linewidth=2)
ax.spines['top'].set(linestyle='--')
ax.spines['right'].set_color('none')

# 2. 将下边框（X轴）和左边框（Y轴）强制移动到数据坐标的 0 点位置
ax.spines['bottom'].set_position(('data', 0))
ax.spines['left'].set_position(('data', 0))

# ==============================================================================
# STEP 4: 绘制核心图表
# ==============================================================================
ax.plot(x, y, label='sin(x)', linewidth=2, linestyle='-')

# ==============================================================================
# STEP 5: 装饰与标注
# ==============================================================================
# 1. X轴、Y轴标签传入空字符串（默认就是空字符串）
ax.set_xlabel('')
ax.set_ylabel('')

# 2. 手动在第一象限指定位置“钉”上文本
# x=5.0, y=0.05 -> 正好在 X 轴最右端的上方
# ha='right' (右对齐) 确保文字不超出右边界，va='bottom' (底部对齐) 确保它悬浮在轴线上方
ax.text(5.5, 0.05, 'X Axis Label', ha='right', va='bottom', fontsize=10)

# x=0.1, y=1.0  -> 正好在 Y 轴最顶端的右侧
# ha='left' (左对齐) 确保文字往右边长，va='top' (顶部对齐) 让它跟顶端刻度基本平齐
ax.text(0.1, 1.1, 'Y Axis Label', ha='left', va='top', fontsize=10, rotation=0)

ax.set_title("Sine Wave", fontsize=14, pad=20) # 适当加点 pad 别让标题和Y轴标签撞车
ax.legend(loc='upper right')                             # 激活图例并固定在右上角

# ==============================================================================
# STEP 6: 输出与渲染
# ==============================================================================
plt.show() ;  # 末尾加分号防止在 Jupyter 中打印内存地址文字
```
![](https://files.seeusercontent.com/2026/06/17/2tWd/20260617105031585.png)

将上述"STEP 3: 调整边框"单独拿出来解释：
```python
...
# ==============================================================================
# STEP 3: 调整边框。使零点坐标在 (0,0) 处。此操作可选，调整零点坐标到 (0,0) 处只为了更符合我们的画图习惯
# 官网参考: https://matplotlib.org/stable/api/spines_api.html#matplotlib.spines.Spine.set_position
# ==============================================================================
# 1. 将上方和右方的边框线分别设置为红色、透明/隐形
ax.spines['top'].set(color='red') # 等价于 ax.spines['top'].set_color('red')
ax.spines['right'].set_color('none')

# 2. 将下边框（X轴）和左边框（Y轴）强制移动到数据坐标的 0 点位置
ax.spines['bottom'].set_position(('data', 0))
ax.spines['left'].set_position(('data', 0))
...
```
这里只讨论直角坐标系。一个坐标系共有上下左右4个边框线，它们在坐标系对象的是通过一个字典保存的，获取它们的方法分别就是：`ax.spines['top']、ax.spines['bottom']、ax.spines['left']、ax.spines['right']`。

拿到具体边框线对象后，就通过set方法或set_xxx方法来修改某属性的默认值。比如要修改上边框线的颜色为红色可以这样写：
```python
ax.spines['top'].set(color='red')
# 或者下面这样写。就是有一个属性名xxx就有一个对应的set_xxx方法
ax.spines['top'].set_color('red')
```
边框线的set方法解释及所有支持的属性见官网文档：[matplotlib.spines.Spine.set](https://matplotlib.org/stable/api/spines_api.html#matplotlib.spines.Spine.set)。
常见的属性名及其描述如下：

| Property                                                                                                                                                             | Description                                          |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| [`alpha`](https://matplotlib.org/stable/api/_as_gen/matplotlib.artist.Artist.set_alpha.html#matplotlib.artist.Artist.set_alpha "matplotlib.artist.Artist.set_alpha") | 表示不透明度，越小越透明。类型是浮点数或None，范围在[0.0,1.0]，为None时表示完全不透明， |
| [`color`](https://matplotlib.org/stable/api/spines_api.html#matplotlib.spines.Spine.set_color "matplotlib.spines.Spine.set_color")                                   | 边框线颜色                                                |
| linewidth                                                                                                                                                            | 边框线的粗细（宽度），浮点数或整数，单位磅                                |
| linestyle                                                                                                                                                            | 设置边框线的线型，字符串如 '-', '--', ':'                         |
| visible                                                                                                                                                              | 控制该条边框线是否显示。值为布尔值: `True`/`False`                    |
| position                                                                                                                                                             | 边框位置                                                 |

## 4.4 数据表现层常用操作
这里的数据表现层就是描述图中的线条与标记点，就是使用`matplotlib.pyplot.plot(...)`在某坐标系中绘制图的操作。前面也已经解释过其调用签名，参见”[[#4.2 pyplot.plot常用调用形式]]“章节，此章节在将此基础上展开重点再描述一些绘制图时一些参数参数及操作。

此章节以下内容都基于前述”调用签名1”形式来进行描述。回忆下其形式如下：
```python
#（1）调用签名1：这是最常用的调用形式（推荐！规范、优雅的 OO风格（Object-Oriented 风格） 写法）
plot([x], y, [fmt], *, data=None, **kwargs)
```
前面在“[[#4.2.1 调用签名1]]”章节中已经对此方法中的部分关键参数或常用参数进行了简单解释，以下重点讲解这两个参数：fmt、kwargs。
### 4.4.1 pyplot.plot方法的fmt参数
它是 Format String（格式字符串） 的缩写。它是一个简写组合，用来快速设置线条基本属性，只包含**标记点形状、线条的线型 和 线条颜色**。而且fmt参数中设置的线条基本属性，其实也可以被kwargs关键字参数进行设置。

fmt参数值是**标记点形状、线条的线型 和 线条颜色** 三者简写的组合（最多三个属性值都可以传递，也可以只传递一个或两个属性值，甚至不传）。
```python
fmt = '[marker][line][color]'
# [marker] 标记点形状
# [line]   线条的线型
# [color]  线条颜色
```
官方推荐按照这种顺序组合来传递fmt参数值，其他顺序组合可能引发不确定的结果。

---

以下这三种属性支持的属性值或常见属性值。
- marker支持的常用值
Markers支持如下常用值，而且还有其他可用值，见官网。

| character | description           |
| --------- | --------------------- |
| `'.'`     | point marker          |
| `','`     | pixel marker          |
| `'o'`     | circle marker         |
| `'v'`     | triangle_down marker  |
| `'^'`     | triangle_up marker    |
| `'<'`     | triangle_left marker  |
| `'>'`     | triangle_right marker |
- line支持值

| character | description         |
| --------- | ------------------- |
| `'-'`     | solid line style    |
| `'--'`    | dashed line style   |
| `'-.'`    | dash-dot line style |
| `':'`     | dotted line style   |
- color支持的常用值
不支持中文，如果fmt中只设置颜色可以使用英文颜色全称或十六进制字符串如'#008000'。

| character | color   |
| --------- | ------- |
| `'b'`     | blue    |
| `'g'`     | green   |
| `'r'`     | red     |
| `'c'`     | cyan    |
| `'m'`     | magenta |
| `'y'`     | yellow  |
| `'k'`     | black   |
| `'w'`     | white   |

---

- 使用示例

```python
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 0: 修改全局设置 (rcParams Settings)
# ==============================================================================
# 设置具体字体为黑体
# mpl.rcParams['font.sans-serif'] = ['SimHei']
# 解决负号 '-' 显示为方块的问题
mpl.rcParams['axes.unicode_minus'] = False

# ==============================================================================
# STEP 1: 准备数据 (Data Preparation)
# ==============================================================================
x1 = np.arange(-4, 4, 0.1)
y1 = np.cos(x1)

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图 (Figure & Axes)
# ==============================================================================
fig1, ax1 = plt.subplots(figsize=(6, 4.8, "in"), facecolor="w", layout="constrained")

# ==============================================================================
# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
# （1）此处fmt参数值为'o-r'，表示marker：o、line：-、color：r，即标记点形状为圆、线条线型为实线、线条颜色为红色
# （2）此处演示了 fmt 参数中已经设置了线型为实线，然后kwargs参数中又重复设置了线型为虚线。最后以kwargs参数中设置的值为准，但执行时会告警提示冗余设置
ax1.plot(x1, y1, 'o-r', label='Cosin Function', linewidth=1, linestyle='--')

# ==============================================================================
# STEP 4: 装饰与标注 (Customizing Labels, Title & Legend)
# ==============================================================================
ax1.set_xlabel('X1 Axis Label')                     
ax1.set_ylabel('Y1 Axis Label')                     
ax1.set_title('Cosin Function Plot1')     
ax1.legend(loc='upper left')     

# ==============================================================================
# STEP 5: 输出与渲染 (Display & Save)
# ==============================================================================
plt.show() ;
```
![](https://files.seeusercontent.com/2026/06/16/lB8u/20260616171852328.png)

### 4.4.2 pyplot.plot方法的kwargs参数
它关键字参数，是一个大杂烩。在`[fmt]` 参数里没法用一两个字符表达的、精细的外观控制参数，就通过 `kwargs` 来控制，这些控制参数有很多，比如线条宽度（`linewidth`）和图例名字（`label`），具体见：[matplotlib-pyplot-plot文档](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.plot.html#matplotlib-pyplot-plot)章节中的“Other Parameters:”部分内容。

以下示例给出了一些常用的特征设置参数（具体plot方法调用时的参数及解释）：
```python
#### plot 函数的 kwargs 参数 学习
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 0: 修改全局设置 (rcParams Settings)
# ==============================================================================
# 设置具体字体为黑体
mpl.rcParams['font.sans-serif'] = ['SimHei']
# 解决负号 '-' 显示为方块的问题
mpl.rcParams['axes.unicode_minus'] = False

# ==============================================================================
# STEP 1: 准备数据 (Data Preparation)
# ==============================================================================
x1 = np.arange(-4, 4, 0.1)
y1 = np.cos(x1)

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图 (Figure & Axes)
# ==============================================================================
fig1, ax1 = plt.subplots(figsize=(6, 4.8, "in"), facecolor="w", layout="constrained")

# ==============================================================================
# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
# 只使用kwargs参数
ax1.plot(x1, y1,  # x/y轴的数据
         label='Cosin Function',    #线条的名称 
         linewidth=1,               #线条的宽度
         alpha=0.5,                 #同时控制线条与标记点的不透明度，值是[0.0,1.0]之间的浮点数，越小越透明，0时绝对透明即隐形
         marker='o',                #标记点的形状为圆
         linestyle='--',            #线条的线型为虚线
         color='r',                 #线条的颜色为红色
         #标记点其实大概由现部分组成，里面的圆与圆外面的包裹边缘，它们都有宽度（markersize、markeredgewidth颜色（markerfacecolor、markeredgecolor）。
         markerfacecolor='blue',     #标记点的里面的圆点的填充色
         markeredgecolor='yellow',   #标记点里面圆点外面包裹的边缘的颜色
         markeredgewidth=2,          #标记点里面圆点外面包裹的边缘的宽度
         #fillstyle='right',         ##标记点里面圆点中只有右半边有颜色（markerfacecolor），左半边中空
        )

# ==============================================================================
# STEP 4: 装饰与标注 (Customizing Labels, Title & Legend)
# ==============================================================================
ax1.set_xlabel('X 坐标轴')                     
ax1.set_ylabel('Y 坐标轴')                     
ax1.set_title('余弦函数图')     
ax1.legend(loc='upper left')     

# ==============================================================================
# STEP 5: 输出与渲染 (Display & Save)
# ==============================================================================
plt.show() ;

```
![](https://files.seeusercontent.com/2026/06/16/5vBx/20260616214232808.png)
官网提供了很多示例：[examples-using-matplotlib-pyplot-plot](https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.plot.html#examples-using-matplotlib-pyplot-plot)
## 4.5 辅助说明层常用操作
### 4.5.1 ax.title设置
官网文档链接：[matplotlib.axes.Axes.set_title](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_title.html#matplotlib.axes.Axes.set_title)。
每个坐标系都可以设置title，matplotlib中关于此方法的声明如下：
```python
Axes.set_title(label, fontdict=None, loc=None, pad=None, *, y=None, **kwargs)
```


其中主要或常用的参数如下：

- label：坐标系的标题名称，类型是字符串。
- loc：坐标系的标题名称显示的位置，类型是字符串，有3个可选值：'center'/'left'/'right'，默认是'center'表示title显示在坐标系的上方正中间位置。

示例代码：
```python
import itertools
import matplotlib.pyplot as plt

fontsizes = itertools.cycle([8, 16, 24, 32])

def example_plot(ax):
    ax.plot([1, 2])
    ax.set_xlabel('x-label', fontsize=next(fontsizes))
    ax.set_ylabel('y-label', fontsize=next(fontsizes))
    # 将坐标系的标题设置为“Title”，字体大小是24，位置是坐标系的上方靠左
    ax.set_title('Title', fontsize=next(fontsizes), loc='left')

fig, ax = plt.subplots(layout="constrained")
example_plot(ax)
plt.show()
```
![570](https://files.seeusercontent.com/2026/06/17/4nJs/20260617120417400.png)
官方示例文档：[examples-using-matplotlib-axes-axes-set-title](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_title.html#examples-using-matplotlib-axes-axes-set-title)
### 4.5.2 ax.legend图例设置
官网文档链接：[matplotlib.axes.Axes.legend.html](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.legend.html)。
每个坐标系的图例默认会有一个配置，但也可以通过坐标系的legend方法来设置其配置信息如位置。matplotlib中关于此方法的声明如下：
```python
Axes.legend(*args, **kwargs)
```
常用调用签名如下：
```python
# 方式1. 自动检测图例中需要显示的元素
"""
此方式下不传递任何参数，添加到图例中的元素是自动被决定的，系统自动获取当前坐标系中所有图元信息。
此时图例中的显示的名称来自绘制图元时设置的label参数值，或者图元.set_label("label名称") 设置的参数值。如下示例1
"""
legend()

# 方式2. 明确列出被说明的plot及对应的图例名称
"""
为了更加明确地控制哪个图元使用什么图例名称，可以将图元与图例分别用可迭代容器（如list）封装起来，调用legend方法时一对对解包出来使用。如下示例2
"""
legend(handles, labels)

# 方式3. 明确列出被说明的线条（跟 方式2 类似）
"""
与方式3类似，只是这种情况已经将图元的名字在绘制图元时通过label属性确定了，所以可以不再重复传递而是直接从图元中获取。最后只需要给legend方法传递一批用可迭代容器封装起来的图元即可。如下示例3
"""
legend(handles=handles)

# 方式4. 为已存在的plot实例指定标签图例名称（不推荐）
"""
如果将多个字符串用可迭代容器封装过起来传递给legend方法，就可以为坐标系已有的所有图元设置图例名称。
这种方式不被官方推荐，因为此时图元与图元名称之间的对应关系是通过图元被创建出来的顺序来隐匿表达，而这种顺序在复杂情况会产生混乱。
如示例4
"""
legend(labels)
```


这4种具体的方式是原方法声明的4种应用实例。它们都有如下常用参数：

- loc：图例在坐标系中的位置，类型可以字符串/整型数字/二元组坐标。字符串形式的参数可以是以下值，字符串及对应的位置如图（再加上一个'best'，此参数在图元比较多、数据复杂时需计算开销较大，那时不建议使用）：
	- ![](https://files.seeusercontent.com/2026/06/17/M9ms/20260617222205733.png)
	- 如果传递整数，matplotlib为上述10个位置再加上'right'（向后兼容，实际与'center right'同义），各分配了一个对应的整数，范围是[0,10]。详情看官网文档。
	- 如果传递是坐标，坐标的单位默认是 “轴域比例坐标”，就是说(0, 0)代表坐标轴大框架的左下角、(1, 1)代表坐标轴大框架的右上角、(0.5, 0.5)代表整个坐标轴框架的正中心。其他类推。
- labelcolor：图例中文字的颜色。
- fontsize：整个图例的大小。
- facecolor：图例背景颜色。

---

以下示例1、2、3、4分别对应上述方式1、2、3、4。
示例1（重点看“STEP 3: 绘制核心图表 (Plotting)”）：
```python
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 0: 修改全局设置 (rcParams Settings)
# ==============================================================================
# 设置具体字体为黑体
mpl.rcParams['font.sans-serif'] = ['SimHei']
# 解决负号 '-' 显示为方块的问题
mpl.rcParams['axes.unicode_minus'] = False

# ==============================================================================
# STEP 1: 准备数据 (Data Preparation)
t = np.linspace(0, 2 * np.pi, 200)
y_sin = np.sin(t)
y_cos = np.cos(t)
# ==============================================================================

# ==============================================================================
# STEP 2: 创建画布与坐标系/子图 (Figure & Axes)
# ==============================================================================  
fig, ax1 = plt.subplots(layout="constrained") 
# ==============================================================================

# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
ax1.plot(t, y_sin, label='Inline Label：Sin Function', color="tab:red", linewidth=2)
ax1.plot([1, 2, 3, 4, 5, 6], label='Inline Label：Straight Line')
"""
上述一行代码等价于如下两行代码：
line = ax1.plot([1, 2, 3, 4, 5, 6])
line[0].set_label('Inline Label：Straight Line')
"""
ax1.legend() # 没有这个语句的话，默认不会显示图例

# ==============================================================================
# STEP 4: 装饰与标注 (Customizing Labels, Title & Legend)
# ==============================================================================
ax1.set_title("子图 1")

# ==============================================================================
# STEP 5: 输出与渲染 (Display & Save)
# ==============================================================================
plt.show();
```
示例2：
```python
# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
line1, = ax1.plot(t, y_sin, label='Inline Label：Sin Function', color="tab:red", linewidth=2)
line2, = ax1.plot([1, 2, 3, 4, 5, 6], label='Inline Label：Straight Line')
ax1.legend([line1, line2], ['line1 label', 'line2 label']) # 没有这个语句的话，默认不会显示图例
```
示例3：
```python
# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
line1, = ax1.plot(t, y_sin, label='Inline Label：Sin Function', color="tab:red", linewidth=2)
line2, = ax1.plot([1, 2, 3, 4, 5, 6], label='Inline Label：Straight Line')
# 一定要使用关键字参数handles，因为如果只传递一个列表时只会被当作图元的label，解析时会出错
ax1.legend(handles = [line1, line2]) # 没有这个语句的话，默认不会显示图例
```
示例4：
```python
# STEP 3: 绘制核心图表 (Plotting)
# ==============================================================================
line1, = ax1.plot(t, y_sin, label='Inline Label：Sin Function', color="tab:red", linewidth=2)
line2, = ax1.plot([1, 2, 3, 4, 5, 6], label='Inline Label：Straight Line')
# 如果列表中元素个数比图元个数少，那么后续的图元就会没有图例
ax1.legend(['line1 label', 'line2 label'], loc='upper left', fontsize=10, labelcolor='green', facecolor='gray')
# 没有这个语句的话，默认不会显示图例
# 示例4 绘制效果如下图
```
![](https://files.seeusercontent.com/2026/06/17/q2vA/20260617223631732.png)
### 4.5.3 ax.grid网格设置

官网文档链接：[matplotlib-axes-axes-grid](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.grid.html#matplotlib-axes-axes-grid)。
每个坐标系的图例默认会有一个配置，但也可以通过坐标系的legend方法来设置其配置信息如位置。matplotlib中关于此方法的声明如下：
```python
Axes.grid(visible=None, which='major', axis='both', **kwargs)
```


此方法常用参数如下：

- visible：是否显示网格，可以是布尔值或None，可选，默认是None。具体解释如下：
	- 如果使用布尔值True或False，分别是强制把网格显示出来或关闭掉，不管子图中之前是否已经显示了网格。
		
	- 如果使用None，就像电器最基础的功能只有开关两种选项，这个参数就是这在开关之间切换。就是说如果当前子图没有显示网格，使用此参数调用grid方法网格就会显示出来；反过来，如果当前子图已经显示网格了，使用此参数调用grid方法网格就会关闭掉或说隐藏起来。**不推荐：可读性不高、容易产生歧义**。
		
	- 还有一个特别的点需要注意，当传递了kwargs关键字参数后，无论visible参数传递了True或False还是None，此时认为用户的真实意图肯定是“想看它”，那么总是显示网格。
	
- which：在坐标轴哪个刻度级别显示网格，类型是字符串，可用的值有：'major'/'minor'/'both'，它们是坐标轴刻度系统（Ticks）的核心概念。可选，默认值是'major'。此处这3个参数值分别代表在主刻度、次刻度、主次刻度 上显示网格。
	
- axis：控制哪个“方向”的网格，可使用的值有'x/y/both'，默认是'both'。这个参数决定了网格线到底是要横着画、竖着画、还是铺满。'x'表示只控制垂直于 X 轴的网格线（也就是一条条竖线），'y'表示只控制垂直于 Y 轴的网格线（也就是一条条横线），'both'则表示同时控制所有方向的网格线。
	
- kwargs：关键字参数，它是一个大杂烩。在前面参数里没没定义或使用的控制参数，就通过 `kwargs` 来控制。比如color、linestyle等，具体见官网文档。

---

示例1：
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

# 创建画布与坐标系/子图 
fig, ax = plt.subplots(figsize=(7, 4))

# 绘制核心图表
ax.plot(np.linspace(0, 10, 100), np.exp(np.linspace(0, 2.3, 100)), color='tab:blue')

# ==============================================================================
# 手动启用次刻度
# ==============================================================================
ax.minorticks_on()

# ==============================================================================
# 精细化设置网格
# ==============================================================================
# 1. 开启：主刻度的 Y 轴网格（水平横线），颜色为#7f8c8d
ax.grid(visible=True, which='major', axis='y', color='#7f8c8d', linestyle='-', linewidth=1)

# 2. 辅助：次刻度的 X 轴网格（垂直竖线），颜色为#bdc3c7（极淡的虚线）且宽度也比y轴的网格线的小
ax.grid(visible=True, which='both', axis='x', color='#bdc3c7', linestyle=':', linewidth=0.6)

plt.show()
```
![](https://files.seeusercontent.com/2026/06/20/Dim8/20260620171558889.png)

官网示例参见：[examples-using-matplotlib-axes-axes-grid](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.grid.html#examples-using-matplotlib-axes-axes-grid)
### 4.5.4 xlabel/ylabel坐标轴名称标签
官网文档链接：[matplotlib-axes-axes-set-xlabel](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xlabel.html#matplotlib-axes-axes-set-xlabel)、[matplotlib-axes-axes-set-ylabel](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_ylabel.html#matplotlib-axes-axes-set-ylabel)。

xlabel/ylabel坐标轴名称标签，就是x/y坐标轴的名称。最直白的参考就是初中时学习直角坐标系时，在x/y坐标轴旁边分别标记的 x与y 字样，这就是为x/y坐标轴分别取的名称。

matplotlib中为直角坐标系中的x/y轴设置名字及相关属性的方法与用法是非常相似地，此处以x坐标轴的相关方法来进行说明。matplotlib中关于此方法的声明如下：
```python
Axes.set_xlabel(xlabel, fontdict=None, labelpad=None, *, loc=None, **kwargs)
```


其中常用参数如下：

- xlabel：x坐标轴的名称，类型是字符串。就是上面所说的 x 字样。
- fontdict：全称是 Font Dictionary（字体字典）。它是一个 Python 字典（`dict`），专门用来打包控制文本外观的各种属性（如字体名称、大小、颜色、粗细、倾斜度等）。目的是在编写规范的、可重复使用的绘图脚本以绘制 AI 实验中的各种训练曲线图时，可以利用它们，让标题、X轴标签、Y轴标签的字体风格保持高度统一。任何由 Matplotlib 官方 `matplotlib.text.Text` 类所支持的属性（官网链接：[matplotlib.text.Text](https://matplotlib.org/stable/api/text_api.html#matplotlib.text.Text)）都可以在此字典中使用。
- labelpad：轴标签（Label）与坐标轴大框架（包括刻度线和刻度数字）之间的距离，单位是磅，可以是浮点数或None，当为默认的None时取全局参数值4.0磅。根据官网文档，其计算公式可以为：`最终标签位置 = 坐标轴外边缘（Axes Bounding Box） + 刻度线长度}+ 刻度数字所占宽度 + labelpad`。当觉得轴标签（即轴名称）离坐标轴、刻度、刻度标签太近了，那就调大；太远了则调小到0，甚至可以是负数（负数情况，通常在隐藏了刻度线后，用来做极简排版）。
- loc：x坐标轴名称标签在x坐标轴那条线段的位置，可用值有：'left'/'center'/'right'，分别表示在xx坐标轴那条线段的左边/中间/右边位置。对于y坐标轴，可用值就变成了：'bottom'/'center'/'top'。
- kwargs：关键字参数，它是一个大杂烩。在前面参数里没没定义或使用的控制参数甚至声明了的参数，可以通过 `kwargs` 来控制（如果kwargs中出现了与fontdict中相同的参数，kwargs的优先级更高）。比如color、alpha等，任何由 Matplotlib 官方 `matplotlib.text.Text` 类所支持的属性（官网链接：[matplotlib.text.Text](https://matplotlib.org/stable/api/text_api.html#matplotlib.text.Text)）都可以在此处使用。

---

示例1：
```python
### 轴标签
import matplotlib.pyplot as plt

# 修改全局设置以支持中文
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(figsize=(6, 4), layout="constrained")
ax.plot([0, 1], [10000, 50000]) # Y轴是很大的五位数，就是说宽度可能比较大

# 统一定义一个样式模板字典
my_label_font = {
    'fontsize': 14,
    'color': 'darkblue',
    'weight': 'bold',
    'family': 'sans-serif'
}

# X轴标签：向外推开 25 磅
ax.set_xlabel('横轴 (Epochs)', labelpad=25, color='red', alpha=0.5, loc='center')

# Y轴标签：设置为 0 磅，它会紧紧贴着那排y轴的刻度文字标签
ax.set_ylabel('纵轴 (Loss)', labelpad=0)

ax.set_title("labelpad 间距修改演示")
plt.show()
```

![](https://files.seeusercontent.com/2026/06/20/nC8q/20260620210903396.png)

官网示例参见：[examples-using-matplotlib-axes-axes-set-xlabel](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xlabel.html#examples-using-matplotlib-axes-axes-set-xlabel)
### 4.5.5 主刻度与次刻度及刻度标签
#### 4.5.5.1 Axes.set_xticks方法
官网文档链接：[matplotlib-axes-axes-set-xticks](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xticks.html#matplotlib-axes-axes-set-xticks)。

xlabel/ylabel坐标轴名称标签，就是x/y坐标轴的名称。最直白的参考就是初中时学习直角坐标系时，在x/y坐标轴旁边分别标记的 x与y 字样，这就是为x/y坐标轴分别取的名称。

matplotlib中为直角坐标系中的x/y轴设置名字及相关属性的方法与用法是非常相似地，此处以x坐标轴的相关方法来进行说明。matplotlib中关于此方法的声明如下：
```python
Axes.set_xticks(ticks, labels=None, *, minor=False, **kwargs)
```


其中常用参数如下：

- ticks：代表x轴上要显式刻画出来的刻度位置，由一维数组类数据（比如列表 `list`、`np.arange` 生成的数组等）表示，就是说它决定了 X 轴上哪些数字的地方将伸出那些刻度“小短线”。有两种注意事项：
	- 如果传入一个空列表 `ax.set_xticks([])`，其效果是把 X 轴的所有刻度线和刻度标签删除，让 X 轴变成一条光秃秃的“光杆”。
	- 调用这个方法后，Matplotlib 内部的轴定位器会被替换为 `FixedLocator`（固定定位器），那么后面 Matplotlib 内部因为不再维护一个默认的轴定位器，那么它将不会再帮忙自动缩放或重新调整刻度密度了，而只依赖 `FixedLocator`的显式声明与操作。
	
- labels：前面ticks参数显式声明的每个刻度对应的刻度标签，可选。如果未传递参数，那么Matplotlib将把ticks参数的各个刻度值对应的字符串作为刻度对应的标签；如果传递了此参数，类型是一个字符串列表，且长度与ticks参数的长度必须一样。
	- 与ticks类似地，如果传递了参数，Matplotlib 内部的轴刻度标签格式化器会被替换为 ` FixedFormatter`（固定轴刻度标签格式化器），那么后面 Matplotlib 内部因为不再维护一个默认的轴刻度标签格式化器，那么它将不会再帮忙自动设置刻度对应的刻度标签了，而只依赖 `FixedFormatter`的显式声明与操作。 
- minor：是否只设置主刻度及其刻度标签，类型是布尔型，默认是`False`。当为`False`时，设置的 `ticks` 和 `labels` 只对主刻度生效；当为`True`时，设置的 `ticks` 和 `labels` 只对次刻度生效；当为
- kwargs：关键字参数，它是一个大杂烩。在前面参数里没没定义或使用的控制参数甚至声明了的参数，可以通过 `kwargs` 来控制（如果kwargs中出现了与fontdict中相同的参数，kwargs的优先级更高）。比如color、alpha等，任何由 Matplotlib 官方 `matplotlib.text.Text` 类所支持的属性（官网链接：[matplotlib.text.Text](https://matplotlib.org/stable/api/text_api.html#matplotlib.text.Text)）都可以在此处使用。
---

示例1：
```python
### 刻度
import matplotlib.pyplot as plt
import numpy as np

# ==============================================================================
# STEP 0: 修改全局设置 (rcParams Settings)
# ==============================================================================
# 设置具体字体为黑体
plt.rcParams['font.sans-serif'] = ['SimHei']
# 解决负号 '-' 显示为方块的问题
plt.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots()

ax.plot([0, 50, 100], [1, 2, 3], label='阶段 A')
ax.plot([0, 50, 100, 500], [10, 50, 1000, 5000], label='爆炸的阶段 B')

# 动态获取当前的 X 轴真实物理下限、上限
x_min, x_max = ax.get_xlim()  # 此时系统会自动检查到：x_max 现在是 500 多（包含了一点自动留白）

# 利用拿到的真实最大值，动态生成均匀分布的刻度
# 比如在 0 到 真实的 max 之间均匀刻3个刻度线
dynamic_ticks = np.linspace(0, x_max, 3)

# 给动态算好的坐标指定特定的刻度标签，并设置颜色与字体大小
ax.set_xticks(dynamic_ticks, labels=['起点/0', f"半程/{x_max/2}", f"最新终点/{x_max}"], color='red', size=20)
ax.set_title('x轴刻度定制、y轴刻度自动生成')
ax.legend()

plt.show()
```
![](https://files.seeusercontent.com/2026/06/21/Wpk3/20260621183431751.png)
#### 4.5.5.2 Axes.set_xlim方法
官网文档链接：[matplotlib-axes-axes-set-xlim](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xlim.html#matplotlib-axes-axes-set-xlim)。

设置x轴的显示范围。xlim/ylim分别代表x轴显示范围/y轴显示范围，它们只代表x/y坐标轴上画面可见的“物理几何范围”，本身不包含任何刻度的样式、颜色、字体等“相关属性”。

matplotlib中为直角坐标系中的x/y轴设置显示范围的方法与用法是非常相似地，此处以x坐标轴的相关方法来进行说明。matplotlib中关于此方法的声明如下：
```python
Axes.set_xlim(left=None, right=None, *, emit=True, auto=False, xmin=None, xmax=None)
```


其中常用参数如下：

- left：x坐标轴上最小刻度即左边界，可选，如果传入了只接受数字。默认值是None，表示保持现有左边界不动，让系统自动计算与适应。
	- 如果传入了一个类型为数字的二元元组，则matplotlib会自动将第一个元素解析为left，第二个元素解析为right。
	
- right：x坐标轴上最大刻度即右边界，可选，如果传入了只接受数字，默认值是None，表示保持现有右边界不动，让系统自动计算与适应。
	
- emit：是否通知观察者（Observers）视窗范围改变了。可用值是布尔值类型。默认值为True。在多个子图需要“双轴联动滚动”（比如在看 A 图的第 10~50 帧，B 图也必须同步切换到 10~50 帧）时，`emit=True` 会向系统发送一个信号。如果设置为 False，系统只会悄悄把当前子图的视窗改了，但不声张从而切断与其他联动子图的同步通知。
	
- auto：是否把 X 轴的自动缩放（Autoscaling）保持开启。可用值是布尔值类型或None，默认值是False。
	- 使用None时，表示保持当前的自动缩放状态不改变。
	- True值时，表示保留系统在此轴上刻度表示范围的自动缩放权力。如果后面追加了更大的新数据，依然允许系统自动把轴刻度范围自动适应拉宽。
	- False值（默认值）时，表示取消系统在此轴上刻度表示范围的自动缩放权力。
- xmin：等价于 `left`参数。但不能与 `left`参数同时使用，否则报错。
- xmax：等价于 `right`参数。但不能与 `right`参数同时使用，否则报错。
---

示例1：
```python
### xlim与ylim
import matplotlib.pyplot as plt
import numpy as np

# STEP 1: 修改全局设置以支持中文
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

# 创建两个上下排列的子图，模拟需要双轴联动的监控面板
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(7, 5), layout="constrained")

# 数据准备
x_data = np.linspace(0, 500, 100)
y_data = np.sin(x_data / 20)

# 绘制核心图表
ax1.plot(x_data, y_data, color='blue', label="图 1 (普通裁剪)")
ax2.plot(x_data, y_data, color='orange', label="图 2 (静默裁剪 + 保留自动缩放)")

# 1. 正常裁剪图 1 的视窗
ax1.set_xlim(left=0, right=100) 
# 此时：图 1 范围死死锁在 [0, 100]，且默认 auto=False，以后再加新数据画面也不会自动撑大。

# 2. 多参数高级定制图 2 的视窗
# [left, right]  规定了当前视野范围
# [emit=False]   让图 2 的范围改变变成“一件悄悄发生的事”，不向系统发送重绘和通知信号（阻止逆向触发某些联动回调）
# [auto=True]    告知matplotlib系统：虽然现在指定了x轴刻度范围 0-100，但如果后续如果追加新数据，依然允许系统自动把刻度范围拉宽
ax2.set_xlim(left=0, right=100, emit=False, auto=True)

# ==============================================================================
# 验证 auto=True 的效果：往两个子图同时追加一个超出当前刻度范围的数据点 (X = 600)
# ==============================================================================
ax1.plot([600], [0], 'ro') # 图 1 增加红点
ax2.plot([600], [0], 'ro') # 图 2 增加红点，结果是图2中x轴刻度范围自动适应拉宽，延伸到了x=600左右

ax1.set_title("图 1：auto=False（默认），红点在视野外看不见")
ax2.set_title("图 2：auto=True，系统发现新红点后，自动把x轴刻度范围自动适应拉宽到600左右")

# 显示网格
ax1.grid()
ax2.grid()

# 显示图例
ax1.legend()
ax2.legend(loc='upper right', fontsize=7)

plt.show()
```
![](https://files.seeusercontent.com/2026/06/21/zlI1/20260621215714996.png)

官网示例参见：[examples-using-matplotlib-axes-axes-set-xticks](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.set_xticks.html#examples-using-matplotlib-axes-axes-set-xticks)

