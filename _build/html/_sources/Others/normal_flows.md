# LOB数据转图片方法

使用Python脚本处理TheSimulator产生的CSV文件，对其进行数据重排序、数据差分计算，并生成一个基于数据的图像。

## 步骤说明
```{admonition} 可视化步骤
:class: note
1. 读取CSV文件：
    * 使用 pandas 库读取CSV文件，获取列名及其数据。
2. 记录处理信息：
    * 创建一个JSON文件，记录CSV文件路径和第一行数据（作为context数组）。
3. 重新排序列名：
    * 根据特定规则对列名重新排序，从 bestBidPrice10 到 bestBidPrice1 再到 bestAskPrice1 到 bestAskPrice10，同样处理Volume列，最后丢弃 time 列。
4. 计算数据差分：
    * 计算每行数据与上一行数据的差分，得到 n-1 行数据，并保存为 lob.csv。
5. 生成图像：
    * 选取 lob.csv 中的连续100行数据，生成宽200像素，高1000像素的图像。图像中的每个10x10像素块由表中的一组数据决定，使用色相表示价格，明度表示量，纯度设为统一的最大值。

```