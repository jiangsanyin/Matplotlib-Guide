---
title: python绘图库-matplotlib-chp3
date: 2026年6月10日20:54:59
tags:
  - matplotlib
  - PyTorch
categories: Python画图
math: "False"
---
#  三、Matplotlib中图的组成
## 3.1 matplotlib中API构架分层
Matplotlib官方文档[Artist tutorial](https://matplotlib.org/stable/tutorials/artists.html)将其API构架分为三层：`matplotlib.backend_bases.FigureCanvas`（笔者在官方完整API文档没有找到此类，但找到了`matplotlib.backend_bases.FigureCanvasBase`，它代表画布的基类，猜测应该是Artist tutorial中误写了。此章节中将使用`matplotlib.backend_bases.FigureCanvasBase`）、`matplotlib.backend_bases.Renderer`、`matplotlib.artist.Artist`。

官方对它们的概述如下：
-  `matplotlib.backend_bases.FigureCanvasBase` 画布，是绘制图形的区域。
-  `matplotlib.backend_bases.Renderer` 渲染器，是知道如何在画布上绘制的对象。
- `matplotlib.artist.Artist` 绘图对象或叫图元，是知道如何使用渲染器在画布上绘制图像的对象。

如果将其以图文形式展示并稍加解释，大致如下：
![](https://files.seeusercontent.com/2026/07/05/Xrl7/20260705133048550.png)
`matplotlib.backend_bases.FigureCanvasBase`与`matplotlib.backend_bases.Renderer`负责处理绘图过程、展示与资源管理的全部底层细节，`matplotlib.artist.Artist` 则处理所有高级结构（用户直接调用它，所以它是用户与前两者的媒介），例如表示和布局图形、文本和线条。根据官网文档显示，用户绝大多数时间都是在与`matplotlib.artist.Artist`打交道。

Artist（绘图对象/图元）可以细分为两大类：primitives（基础图元/基元） 与 containers（容器对象/容器）。primitives代表那些绘制在画布上的基本图形对象，如：Line2D、Rectangle、Text 与 AxesImage 等等；containers则代表放置primitives的地方，如：Axis、Axes 与 Figure。
从概念包含归属关系（非API类型继承关系）上，Artist 细分后的代表性事物如下图：
![Artist绘图对象层次结构](https://files.seeusercontent.com/2026/07/16/8woD/20260716231247917.png)

**绘图的标准化流程**：首先创建一个画布对象，然后通过画布对象创建出一个或多个坐标系（也叫子图），最后通过坐标系的相关帮助性方法（即matplotlib API中为坐标系提供的相关方法）创建出所需要的基础图元、设置其属性（如颜色、位置、透明度等），最后渲染展示整个绘图效果。

```python
import matplotlib.pyplot as plt
fig = plt.figure()
ax = fig.add_subplot(2, 1, 1) # two rows, one column, first plot
```
## 3.2 坐标系Axes与Artist的属性
### 3.2.1 最常用API-Axes
在使用matplotlib进行绘图的过程中，Axes 是matplotlib API中最重要的类型，且是最经常使用且绝大多数时间都在使用的类型。这是因为坐标系是绝大部分绘图对象附着或放置之处。

Axes提供了许多辅助函数（其实就是类型中包含的方法）来绘制常见的基础图元，比如经常用的plot()、text()、hist()、imshow()方法分别绘制了Line2D、Text、Rectangle、AxesImage 这些基础图元对象。Axes 提供的这些方法获取用户提供的数据，利用这些数据创建基础图元对象，并把它们添加到特定的容器中，最后在需要时渲染出整个画布及其中所有内容。
用户只需要给Axes的方法提供参数数据即，这背后的一系列动作都由matplotlib内部管理机制自动完成，这套机制经常被称为matplotlib大管家。Matplotlib 大管家在本质上是一个由“脚本状态机层（`matplotlib.pyplot` 模块）”发号施令，通过“面向对象图元层（Artist API）”组织和调度万物，最终交由“后端引擎（Backend）”落地渲染的统一协调管理机制。

默认情况下，坐标系区域在横纵方向分别占据画布大致77%左右长度，剩余的画布面积被转换成了四周的留白，留白区域可以用来放置坐标系标题、坐标轴刻度、刻度标签等内容。但坐标系区域可以通过修改默认参数值来调整：
```python
fig2 = plt.figure()
# 参数分别是x轴起点、y轴起点、宽度、长度（整个画布的宽高都算作1，起点与跨距用小数来表示）
ax2 = fig2.add_axes((0.15, 0.1, 0.7, 0.3))
```

在下面这个示例中，首先创建画布，然后通过画布对象创建坐标系对象。最后当执行`ax.plot`创建一个Line2D对象并把它附着在坐标系上，并返回这个Line2D对象。这个创建出来的Line2D对象其实可以通过`ax.lines`来直接获取，`ax.lines`的类型是列表，每个向坐标系添加的Line2D对象都会被添加到`ax.lines`末尾。
```python
import matplotlib.pyplot as plt
import numpy as np
t = np.arange(0.0, 1.0, 0.01)
s = np.sin(2*np.pi*t)

fig = plt.figure() #创建画布
ax = fig.add_subplot() #创建坐标系（子图），默认就是一个1*1的坐标系
# 绘制一个 Line2D 对象即一个线条，返回值line就是这个Line2D 对象
line, = ax.plot(t, s, color='blue', lw=2) #x轴数据、y轴数据、线条颜色、线条宽度linewidth

"""
此时，line 与 ax.lines[0] 其实是等同的
print(line == ax.lines[0]) #返回True
"""

# plt.show();   # 此时如果再加上这行代码，即可展示绘制的图
```

此外，Axes除了提供了方法绘制核心绘图区域的基础图元，还提供了方法来配置与装饰x轴、y轴的刻度、刻度标签与坐标轴名称。
```python
import matplotlib.pyplot as plt
import numpy as np
# 此示例中，笔者为了显式展示相关效果，为某些区域设置了一些颜色或宽度，导致美观度可能下降

# 创建画布
fig = plt.figure()
# 设置画布fig的填充色为粉色、边框颜色为红色、框架宽度为4
fig.set(facecolor='pink', edgecolor='red', linewidth=4)
# 微调画布，将子图（Axes）的“上边界”设定在整张画布物理高度的 80% 位置。
fig.subplots_adjust(top=0.8)
# 添加2行1列共2个子图。并返回第1个子图ax1（从上到下、从左往右数，最开始的子图索引是1）
ax1 = fig.add_subplot(211)
# 设置子图ax1的y轴名称
ax1.set_ylabel('Voltage [V]')
# 设置子图ax1的标题
ax1.set_title('A sine wave')

# 指定起点、终点，按照固定步长产生一个数据序列
t = np.arange(0.0, 1.0, 0.01)
# 构造一个正弦函数
s = np.sin(2 * np.pi * t)
# 在子图ax1中使用plot方法绘制一条折线段
line, = ax1.plot(t, s, color='blue', lw=2)

# 设定随机种子值保证随机数复现
np.random.seed(19680801)

# 先前准备了一个画布，但只初始化并返回了第一个坐标系，第2个坐标系对应的画布区域是空的
# 现在初始化并返回第2个坐标系
ax2 = fig.add_axes((0.15, 0.1, 0.7, 0.3))
# 在子图ax2中绘制了一个由50根小柱子组成的直方图，并返回三个底层艺术单元的引用
#  n：数组，每一个柱子里落入的数据点的绝对数量。
#  bins：数组，50个柱子边缘刻度边界值（50个柱子对应有51个边界值）
#  patches：列表，是包含了 50 个 Rectangle（矩形基础图元）对象的列表
n, bins, patches = ax2.hist(np.random.randn(1000), 50,
                            facecolor='yellow', edgecolor='yellow')

# 设置子图ax2的x轴名称
ax2.set_xlabel('Time [s]')
# 设置子图ax2对应的坐标系矩形(ax.patch)的填充色
ax2.set(facecolor='gray')

# 展示画布上的绘图效果，并做资源清理
plt.show()
```
![](https://files.seeusercontent.com/2026/07/05/4rTp/20260705202727549.png)
### 3.2.2 Artist的属性与getter/setter
在matplotlib中，画布中的所有内容都是由matplotlib大管家派出的绘图对象即Artist绘制出来的，每个绘图对象都有一长串属性，可以通过它们来修改绘图对象的视觉效果。

比如画布本身就包含一个代表其画布那个矩形的属性（fig.patch），这个矩形的大小与画布大小一样，用户可以拿到fig.patch这个属性后就可以对那个矩形进行设置（比如设置填充色、透明度、是否可见等）；类似地，坐标系本身也包含一个矩形区域，它就是由所有坐标轴围起来的那个区域（在二维直角坐标系中，它是一个矩形区域；在极坐标系中它是一个圆形或扇形区域。但不管是直角坐标系还是极坐标系，坐标系中对应的那块区域总是用 ax.patch 来获取），拿到ax.patch就可以坐标系区域的视觉效果进行配置。

对于每一个绘图对象Artist都有如下属性：

| 属性名        | 属性描述                                                                                                                              |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------- |
| alpha      | 透明度。整型或浮点数，范围在[0,1]，默认为None表示完全不透明，越小越透明，0表示完全透明                                                                                  |
| animated   | 是否动画加速开关。布尔类型，True时表示开启，开启后，大管家在绘制动态图时会使用 `Blitting` 技术（只刷新运动的组件，不刷新静止的背景），能给动态图带来极大的流畅度提升。                                       |
| axes       | 坐标系/子图。有些绘图对象Artist的此属性可能为None，表示它不属于任何一个具体的子图坐标系。如`fig.suptitle("我是全局总标题").axes`为None，即全局的画布总标题的axes的属性值为None。                   |
| clip_box   | 矩形裁剪区域。定义了该 Artist 允许被看到的矩形物理边界。                                                                                                  |
| clip_on    | 是否开启裁剪开关。布尔类型，True时表示开启，此时组件超出子图边框时会把它剪掉。                                                                                         |
| clip_path  | 路径裁剪区域。它是任意形状的路径，默认为None，表示不指定路径裁剪区域即显示全部内容。指定时，表示只有落在指定路径路径几何边界内部的像素，才允许被渲染器渲染出来，其余部分将被隐藏。                                       |
| contains   | 检测鼠标点击坐标点是否在某组件内部，需要用户自定义函数自行实现判断逻辑、并与点击事件绑定。                                                                                     |
| figure     | 组件所属的画布。某些绘图对象的figure属性值可以None，表示它还没有被添加具体的某个画布中，比如当用户调用构造函数`matplotlib.patches.Circle(...)`直接创建一个Circle实例时，此时它的figure属性值一般为None。 |
| label      | 组件的文字标签。默认是空字符串。                                                                                                                  |
| picker     | 控制该组件能否被鼠标“点中”。                                                                                                                   |
| transform  | 组件空间定位解析器。就是说组件以何种参考对象来将代表空间位置的抽象“数字”变成屏幕上具体的“像素”点位置，这种参考变换之间要有一个变换矩阵。有三个核心的变换矩阵：ax.transData（默认值）、ax.transAxes、fig.transFigure   |
| visible    | 组件是否可见。布尔值类型，默认值一般为True，表示可见。                                                                                                     |
| zorder     | 图层顺序。数字类型，它决定谁盖在谁上面（画作的“前后图层”），数值越大图层越靠前。                                                                                         |
| rasterized | 是否强行把矢量图强行变成高清像素位图。布尔类型，默认False表示关闭，保持纯矢量输出。                                                                                      |

matplotlib API中为上述每个属性提供了一个`getter`、`setter`方法，分别表示获取属性值、设置属性值。同时也支持在绘图对象上调用`set`方法同时设置多个属性值。
matplotlib API中也提供了`matplotlib.artist.getp(...)`来一次性获取某绘图对象Artist的所有属性及值。另外因为matplotlib源码中注释的高规范可读性，其为每个类型（面向对象术语）提供了docstrings，所以通过使用help(xxx)也能查看指定绘图对象xxx的所有属性。

```python
...
# 给坐标系ax2设置标题，并指定透明度
ax2.set_title("Test Title", alpha=0.1)

# 坐标系对象ax2的title属性值是一个'matplotlib.text.Text'实例，它是` matplotlib.artist.Artist` 的子类，就是说ax2.title也是一个Artist实例。ax2.title也有alpha属性，可调用get_alpha()
print(ax2.title.get_alpha())
# 再调用set_alpha()
ax2.title.set_alpha(ax2.title.get_alpha() * 5)
# 同时设置ax2.title的多个属性
ax2.title.set(alpha=0.8, color='red')

# ax2就是一个Artist实例，对其使用matplotlib.artist.getp 方法获取其所有属性
matplotlib.artist.getp(ax2)
# ax2.title 也是一个Artist实例，也可对其使用matplotlib.artist.getp 方法获取其所有属性
matplotlib.artist.getp(ax2.title)
# 调用python原生自带的help方法，输出ax2.title对应类型` matplotlib.artist.Artist`的 docstrings，其中就包含它的所有属性properties
help(ax2)
```
## 3.3 Artist的细化
在Matplotlib大管家的世界里，一切看得见的内容几乎都是 Artist。前面已经提到：Artist（绘图对象/图元）可以再细分为两大类：primitives（基础图元/基元） 与 containers（容器对象/容器）。primitives代表那些绘制在画布上的基本图形对象，如：`Line2D`、`Rectangle`、`Text` 与 `AxesImage` 等等；containers则代表放置primitives的地方，如：`Axis`、`Axes` 与 `Figure`。

以下分别对primitives（基础图元/基元）与containers（容器对象/容器）的核心代表进行简述，阅读后可以后它们有个初步的认识。
### 3.3.1 基础图元primitives
`primitives` 代表那些最终绘制在画布上的标准图形实体对象，是具体展示数据的实体。在实际应用中，它以各种形式支撑着数据的可视化呈现：无论是展示数据变化趋势的线条（折线图的底层实体）、对比数据大小或分布范围的面片（柱状图/直方图的底层矩形）、还是用来展现海量离散数据的集合图元（散点图的底层大表），亦或是对图表进行说明的文字与范围标识的圆形、多边形，在后台全是一个个具体的 `primitives` 实例。常见的分类与核心代表如图所示。
![primitives的细分与代表](https://files.seeusercontent.com/2026/07/16/kiF9/20260716231421139.png)

##### （1）线条流派“Line Elements”
类似于霓虹灯人偶舞蹈中的人偶，每一节/全身只有单一颜色的那种演员，它们在舞台上只有骨架、没有肉体。   它们是由无数个点连接而成的“极细钢丝”，可以改变它的长度、粗细（`linewidth`）和颜色，但因为它们内部没有所谓填充面积的概念，所以无从谈起给它们内部涂抹颜色（不支持 `facecolor`）。
	
- （1.1）`Line2D`（平面线条）：最经典最常见的线条。平时绘制的折线图、曲线图，甚至坐标轴上那一排排细小刻度线，底层都是用它一根根拉出来的。
- （1.2）三维曲线（3D Plot）：在xy平面的基础上进一步扩展了能力，能够上下移动、“会飞”的线条。


##### （2）面片流派“Patch Elements”
不再是霓虹灯人偶舞蹈中的人偶那样每一节/全身只有单一颜色，此类演员不仅有骨架，而且长了肉体（闭合面积）。	凡是有闭合面积的圈（演员的身体关节是一个闭合面积的形状），就会有外圈颜色与内部面积颜色的概念。它们全都继承自 `Patch`类型 ，适合用来涂色和圈定范围。
	
- （2.1）`Rectangle`（矩形）：画布的底色（`fig.patch`）、子图的背景（`ax.patch`），还是在画柱状图（`bar`）和直方图（`hist`）时那一排排并列的柱子，本质上全是一块块长宽不同的矩形方砖。
- （2.2）`Circle/Ellipse`（圆形/椭圆）：在数据分析里，如果想在密密麻麻的特征图、散点图上，把某几个最核心的异常数据点“狠狠地圈起来”引起读者注意，掏出它来准没错。有个很形象的比喻：有点像是舞台上的探照灯。
- （2.3）`Polygon`（多边形）：给出一串有序的坐标点，然后像连线游戏一样（有点像连接养鱼时圈中水域面积时用的多个浮漂），把最后一个点和第一个点死死连在一起，连出一个闭合的、形状不规则的面积区域，这个面积区域就是一个多边形。多边形同样可以通过 `facecolor` 填充不同的色彩，常用于高亮显示置信区间。
- （2.4）`Wedge`（扇形/楔形）：画饼图（`ax.pie()`）时，那些被切成不同大小、用来代表百分比的“扇形区域”，在底层，每个“扇形区域”就是一个`Wedge`实例。另外，极坐标系的圆盘也是`Wedge`。


##### （3）文本流派“Text Elements”
大管家把所有的文字都封装成了统一的 `Text` 实例。为了防止字体的颜色和背景不协调（如二者的颜色相同或相近，导致文字无法正常展示或不明显），每个 `Text` 实例在底层都暗中拥有自带了一个背景板（一个`Rectangle` 边框），可以随时给文字加阴影、设置合适样式的背景等。	
	
- `Text`（通用文本）：字符类的组件都是`Text`。如，子图标题、 $X/Y$ 轴的标签，以及在图表里随手贴的批注文字，在后台全是一个个 `Text` 实例。	


##### （4）图像流派“Images”
是数字与像互映射大师，可以处理庞大的矩阵数据。具体就是把一堆乱七八糟的矩阵二维数字（比如医疗 MRI 断层扫描数据、热力图矩阵），根据指定的映射规则“参数`cmap`”，把不同大小的数字映射成不同颜色的像素格子。	
	
- `AxesImage`（图像像素矩阵）	：调用 `ax.imshow()` 时返回的就是 `AxesImage` 实例。在机器学习中看混淆矩阵、在医疗行业看特征图，都是用它把抽象的权重数字变成像素图像。


##### （5）集合流派“Collection”
是专门用来处理独立分散几何个体的工具。图像流派“Images”与集合流派“Collection”都是为了应付海量数据而生的具体primitives组件，但它们还是有显著区别的：`Images` 渲染的是“连续的像素格子”，而 `Collection` 渲染的是“独立的几何个体”，这些独立的几何个体不一定是连续的。
在工业级实际生产应用中，要在图里画 10 万个散点时，如果创建 10 万个独立的 `Circle` 实例，内存和 CPU 当场就会卡瘫痪（即使有显卡也没有被使用到的机会）。matplotlib为了应对与处理此场景问题，开发了 `Collection` 。它把几万个点的坐标和颜色直接打包，由CPU在内存中合并成一整张大表后，直接传递给显卡。显卡最擅长处理这种批量的结构化数据，只要计算一次，就能把几万个点一次性渲染出来（当然普通的使用场景下，几百个散点时不需要使用到显卡也行）。
	
- `Collections`（图元集合 / 散点军团）：是大规模散点的救命神器。调用 `ax.scatter()` 绘制密密麻麻的散点图时，返回的其实就是它（`PathCollection`）。在处理海量患者医疗数据分布时，它绝对会使用到的性能降维利器。

### 3.3.2 容器对象containers
containers则代表放置primitives的地方，最常见的容器对象包括：`Figure`、`Axes` 与`Axis` 。
![containers的细分与代表](https://files.seeusercontent.com/2026/07/08/5Pex/20260708215310090.png)
如果说 `primitives` 是在舞台上表演的各个具体演员，那么 `containers` 就是搭建舞台的各级主办方与舞台框架。它们自己通常不负责展示核心数据，但负责提供物理坐标系、撑起整张画布，给基础图元们提供附着与展示的空间。

#### （1）Figure“画布”
它是舞台的“投资人 / 整张地皮”。代表整个绘图窗口或者整张物理打印纸，是整张图画的“总管家”。通过它，可以控制整张图的物理尺寸（`figsize`）、背景色，给整个绘图窗口取一个全局总标题，或者裁切与保存出最终的图片文件。
	
画布是绘图对象中最顶级的对象容器。常说的一个画布窗口，其实就是一个`matplotlib.figure.Figure`实例，它包含了整个图表里的一切组件。画布有很多常用的属性，这些属性分别包含着画布中经常用到的`primitives`与`containers`，常见的如下：

| 画布属性名   | 代表的意义                                                                                                                                                                                                | 相关说明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| axes    | 坐标系（[`Axes`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.html#matplotlib.axes.Axes "matplotlib.axes.Axes")）列表                                                                     | （1）通过[`add_subplot(...)`](https://matplotlib.org/stable/api/_as_gen/matplotlib.figure.Figure.add_subplot.html#matplotlib.figure.Figure.add_subplot) 、 [`add_axes(...)`](https://matplotlib.org/stable/api/_as_gen/matplotlib.figure.Figure.add_axes.html#matplotlib.figure.Figure.add_axes)方法向画布中添加的坐标糸实例将添加到axes列表末尾。（2）动态删除画布某子图坐标系，要先获取对应的坐标系，然后通过[`Axes.remove()`](https://matplotlib.org/stable/api/_as_gen/matplotlib.artist.Artist.remove.html#matplotlib.artist.Artist.remove)方法，不要直接通过`fig.axes.remove(某具体子图坐标系实例)`这样的python原生列表中删除元素的方法删除，这样会引起matplotlib大管家内数据的混乱与不一致。matplotlib中几乎都是这样的规律“要通过matplotlib提供的标准API去添加或删除指定的绘图对象，以保证大管家内部数据的统一与一致。" |
| patch   | 坐标系背景，是一个（[`Rectangle`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Rectangle.html#matplotlib.patches.Rectangle "matplotlib.patches.Rectangle")）对象                                  | 拿到矩形对象可以直接修改它的属性如填充色：`fig.patch.set_facecolor('#1e272e')`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| legends | 是画布级别的图例（[`Legend`](https://matplotlib.org/stable/api/legend_api.html#matplotlib.legend.Legend "matplotlib.legend.Legend")）列表（不同级别的对象容器的legends不存在包含关系，而是相关隔离的。所以通过ax.legend()产生的图例是属于某个具体子图的，不在此范围） | 不在子图里量的图例，而是专属于画布的图例。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| lines   | 是画布级别的线条（[`Line2D`](https://matplotlib.org/stable/api/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D "matplotlib.lines.Line2D")）列表。一般只会向坐标系中添加线条，然后通过`Axes.lines`获取)                   | 使用时的推荐做法：（1）通过`fig.lines.extend(...)`方法向`fig.lines`添加线条时，最好给线条对象加上参数`transform=fig.transFigure`即使用画布相对空间。（2）或者就通过调用画布提供专门用来添加线条的方法：fig.text()、fig.legend()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| patches | 是画布级别的面片（[`Patch`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Patch.html#matplotlib.patches.Patch "matplotlib.patches.Patch")）列表 。一般只会向坐标系中添加面片实例如矩形、椭圆等，然后通过`Axes.patches`获取)     | -                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| texts   | 是画布级别的文本（[`Text`](https://matplotlib.org/stable/api/text_api.html#matplotlib.text.Text "matplotlib.text.Text")）列表                                                                                    | `fig.suptitle(...)`设置画布标题、`fig.text(...)`设置一个普通文本对象，都会在fig.textx添加一个元素。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |


#### （2）Axes“子图/坐标系”
它是舞台上的“独立分会场“。在使用 Matplotlib 进行绘图时，与绝大多数人打交道最多的容器。只要在这个坐标系里调用 `ax.plot()` 或 `ax.bar()`，坐标系Axes就会自动把对应的折线图与柱状图绘制出来，并使其附着在自己的空间内。

一个画布上可以分布多个 `Axes`（多个 `Axes`在画布上的分布规律有点像九宫格，但相邻的格子可以合并为一个 `Axes`）。每个 `Axes`拥有自己独立的网格线、独立的图例，互不干扰。

每个 `Axes`坐标系容器又包含以下两个常见的子容器：`XAxis`、`YAxis`，它们分别表示X坐标轴与Y坐标轴：
- `XAxis`（X 坐标轴）：归属于当前子图舞台的“横向规矩尺”。负责看管子图横向的数据边界。上面的横向轴线、刻度线、刻度标签以及轴标题，底层实现上全部由它管理。
- `YAxis`（Y 坐标轴）：归属于当前子图舞台的“纵向规矩尺”。负责看管子图纵向的数据边界。上面的纵向轴线、刻度线、刻度标签以及轴标题，底层实现上全部由它管理。

Axes“子图/坐标系”（底层是一个`matplotlib.axes.Axes`实例）是整个Matplotlib绘图世界的中心。它包含了整个画布中绝大多数绘图对象Artist的实际装载与管理。同时，Axes“子图/坐标系”提供了大量的辅助方法用于创建与添加绘图对象，又提供了一些属性从而可以便捷对Axes“子图/坐标系”中所包含的绘图对象进行访问。
- Axes“子图/坐标系”提供的常用辅助方法：

| Axes 的辅助方法                                                                                                                                                             | 创建与返回的绘图对象                                                                                                                                                                                                                                                                                      | 创建的绘图对象存储位置             |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| [`annotate`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.annotate.html#matplotlib.axes.Axes.annotate "matplotlib.axes.Axes.annotate") - 文本箭头注释      | [`Annotation`](https://matplotlib.org/stable/api/text_api.html#matplotlib.text.Annotation "matplotlib.text.Annotation")                                                                                                                                                                         | ax.texts                |
| [`bar`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.bar.html#matplotlib.axes.Axes.bar "matplotlib.axes.Axes.bar") - 柱状图                             | [`Rectangle`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Rectangle.html#matplotlib.patches.Rectangle "matplotlib.patches.Rectangle")                                                                                                                                          | ax.patches              |
| [`errorbar`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.errorbar.html#matplotlib.axes.Axes.errorbar "matplotlib.axes.Axes.errorbar") - 误差棒图        | [`Line2D`](https://matplotlib.org/stable/api/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D "matplotlib.lines.Line2D") and [`Rectangle`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Rectangle.html#matplotlib.patches.Rectangle "matplotlib.patches.Rectangle") | ax.lines and ax.patches |
| [`fill`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.fill.html#matplotlib.axes.Axes.fill "matplotlib.axes.Axes.fill") - 区域填充图 / 面积图                 | [`Polygon`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Polygon.html#matplotlib.patches.Polygon "matplotlib.patches.Polygon")                                                                                                                                                  | ax.patches              |
| [`hist`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.hist.html#matplotlib.axes.Axes.hist "matplotlib.axes.Axes.hist") - 直方图                         | [`Rectangle`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Rectangle.html#matplotlib.patches.Rectangle "matplotlib.patches.Rectangle")                                                                                                                                          | ax.patches              |
| [`imshow`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.imshow.html#matplotlib.axes.Axes.imshow "matplotlib.axes.Axes.imshow") - 图像数据展示 / 热力图与像素矩阵贴图 | [`AxesImage`](https://matplotlib.org/stable/api/image_api.html#matplotlib.image.AxesImage "matplotlib.image.AxesImage")                                                                                                                                                                         | ax.images               |
| [`legend`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.legend.html#matplotlib.axes.Axes.legend "matplotlib.axes.Axes.legend") - 子图图例                | [`Legend`](https://matplotlib.org/stable/api/legend_api.html#matplotlib.legend.Legend "matplotlib.legend.Legend")                                                                                                                                                                               | ax.get_legend()         |
| [`plot`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.plot.html#matplotlib.axes.Axes.plot "matplotlib.axes.Axes.plot") - 折线图                         | [`Line2D`](https://matplotlib.org/stable/api/_as_gen/matplotlib.lines.Line2D.html#matplotlib.lines.Line2D "matplotlib.lines.Line2D")                                                                                                                                                            | ax.lines                |
| [`scatter`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.scatter.html#matplotlib.axes.Axes.scatter "matplotlib.axes.Axes.scatter") - 散点图 / 气泡图       | [`PolyCollection`](https://matplotlib.org/stable/api/collections_api.html#matplotlib.collections.PolyCollection "matplotlib.collections.PolyCollection")                                                                                                                                        | ax.collections          |
| [`text`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.text.html#matplotlib.axes.Axes.text "matplotlib.axes.Axes.text") - 纯文本标签 / 独立艺术字弹幕             | [`Text`](https://matplotlib.org/stable/api/text_api.html#matplotlib.text.Text "matplotlib.text.Text")                                                                                                                                                                                           | ax.texts                |

- Axes“子图/坐标系”提供的常用属性方法：

| Axes 的属性名   | 属性代表的意义                                                                                                                                                                                                                                    | 相关操作或注意事项                                                                                         |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| artists     | 记录通过 `ax.add_artist()` 添加且无法归类的特殊绘图对象。折线、柱状图、圆、文字都有自己的专属存放位置（`lines`, `patches`, `texts`），它们不会出现在 `ax.artists` 里。                                                                                                                          | 如果想遍历子图中的一切组件（包括图元演员与坐标轴等子容器），使用`ax.get_children()`                                               |
| patch       | 代表Axes背景矩形的[`Rectangle`](https://matplotlib.org/stable/api/_as_gen/matplotlib.patches.Rectangle.html#matplotlib.patches.Rectangle "matplotlib.patches.Rectangle")实例                                                                        | 可以通过它直接修改子图舞台的背景色或边框，例如：`ax.patch.set_facecolor('lightgray')`。                                    |
| collections | 记录各种“集合图元（Collection）”的列表，主要用来批量装载海量同类图元以优化性能。例如：`ax.scatter()` 产生的散点集合、`ax.errorbar()` 批量打包的误差线段集合、以及由高层 API（如 3D 表面图）自动生成的批量多边形集合（PolyCollection）。                                                                                       | 集合对象是为了优化内存而设计的。如果用 `scatter` 画了 1000 个点，它们不会产生 1000 个 `patch`，而是以 1 个集合的形式保存 `ax.collections` 里。 |
| images      | 记录子图内所有“二维像素贴图（Image）”的列表。                                                                                                                                                                                                                 |                                                                                                   |
| lines       | 记录子图内所有“二维线条（Line2D）”的列表。所有通过 `ax.plot()` 绘制出来的折线、趋势线、均值辅助线，都会在这里登记入册。                                                                                                                                                                     | 凡是通过 `ax.plot()` 刷出来的折线会在这里登记。**注意：** `ax.errorbar()` 产生的误差图的主线和中心点也会记录在这里。                       |
| patches     | 记录子图内部所有“二维几何面片（Patch）”的列表。包含通过 `ax.bar()` 画的柱状图矩形、`ax.hist()` 的直方图砖块、以及手工添加的圆/椭圆（`Circle`/`Ellipse`）、多边形（`Polygon`）等。记录子图内部所有独立的“二维几何面片（Patch）”。包含通过 `ax.bar()` 画的柱状图矩形、`ax.hist()` 的直方图砖块，以及**手工单点添加**的圆（`Circle`）、**独立多边形（`Polygon`）**。 | 柱状图的每一根柱子都是一个独立的 `Rectangle` 实例。如果想批量给柱子染色，可以通过遍历 `ax.patches` 逐个调用 `.set_facecolor()`。           |
| texts       | 记录子图内部所有“文本标签（Text）”的列表。包含通过 `ax.text()` 手工打的艺术字、`ax.annotate()` 做的箭头引线标注，以及各个数据点的文本标签。                                                                                                                                                    | **注意：** 子图的轴标题（Title）虽然也是 `Text` 实例，但它有自己的独立专属指针 `ax.title`，通常不通过遍历 `ax.texts` 来修改标题。             |
| xaxis       | 代表当前子图舞台的“横向规矩尺”（一个独立的 `XAxis` 子容器实例）。                                                                                                                                                                                                     |                                                                                                   |
| yaxis       | 代表当前子图舞台的“纵向规矩尺”（一个独立的 `YAxis` 子容器实例）。                                                                                                                                                                                                     |                                                                                                   |
#### （3）Axis“坐标轴”
它是大管家抽象出来的“坐标轴基类”，是 `XAxis` （X坐标轴）和 `YAxis`（Y坐标轴） 共同的“父类”。它本身不分横纵，纯粹在底层负责定义一条标准的规矩轴应该怎么装载轴线、刻度、刻度标签和轴标题。

坐标轴（底层是一个`matplotlib.axis.Axis`实例）负责处理刻度、网格、刻度标签和坐标轴标签相关操作。比如它可以配置X轴上刻度是显示在轴线的上面还是下面（甚至上下都显示，且配置成两套不同的刻度），类似地也可以配置Y轴上刻度是显示在轴线的左边还是右边（甚至左右都显示，且配置成两套不同的刻度）。此处坐标轴还存储了原始数据（绘制图表时传递进来来的原始数据，它决定了坐标轴的`data intervals` 即数据区间，代表原始数据的绝对边界）与视野范围（叫`view intervals` 即视窗区间，它代表了图表窗口当前**肉眼可见的、呈现出来的数学边界**。在对图表进行缩放与移动时，就需要调整`view intervals`）。最后，坐标轴还可以设置定位器（[`Locator`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.Locator "matplotlib.ticker.Locator")）与格式化器（[`Formatter`](https://matplotlib.org/stable/api/ticker_api.html#matplotlib.ticker.Formatter "matplotlib.ticker.Formatter")），它们分别决定刻度的位置与刻度对应的值是如何映射成为对应的显式字符串的。
对于定位器的理解，举个例子就是：是按照“每隔 10 点点一个（等间距线性）”标记刻度，和“按对数 $10^x$ 级数递增”来标记刻度（此时对于原始数据10、100、1000，它们在X轴上分别对应的刻度值是1、2、3）。对于格式化器，可以简单理解为一个映射函数，它将刻度值原始通过特定的映射函数映射成指定格式的字符串。

Axis也提供了一些属性以便用户能够便捷获取其中存储的一些绘图对象。拿到之后，一般是不推荐对它们通过python原生方法进行增加、删除或修改的，而应该通过matpotlib提供的封装API来操作。比如说修改坐标轴的标题、刻度、刻度标签等，虽然可以分别通过如下方式来实现：`axis.label = xxx`、强行往 `axis.majorTicks` 列表里 `append` 新的 Tick、修改 `axis.majorTicks[i].text` 的字符串，而应该调用对应的封装好的方法：**`ax.set_xlabel()`** / **`ax.set_ylabel()`**、`axis.set_major_locator(具体的Locator)`或ax.set_xticks([位置列表])、`axis.set_major_formatter(具体的Formatter)`或ax.set_xticklabels([文字列表])。

如果要设置刻度与网格的样式(如颜色、粗细、方向)，应该要使用`ax.tick_params()`，具体细节见[`tick_params`](https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.tick_params.html#matplotlib.axes.Axes.tick_params "matplotlib.axes.Axes.tick_params")。





