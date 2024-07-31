(Simulator:define)=
# 模拟器



(Maxe)=
# Maxe
## TheSimulator 简介

TheSimulator 是一个强大的仿真器，用于模拟市场交易和其他复杂系统。它支持 C++ 和 Python 语言，并通过 XML 配置文件进行仿真设置。该工具旨在为研究人员和开发人员提供一个灵活的环境，以测试和验证其交易策略和算法。

## 安装指南

### 系统要求

- **CMake** 3.15 或更高版本
- 能够编译 C++17 的编译器（如 Visual Studio 17 或更高版本、GCC 9.0 或更高版本、LLVM Clang 9.0 或更高版本）
- **Python**（测试过的版本有 Python 2.7 和 3.6）

另外，根据不同的操作系统，可能需要以下软件：
- **Windows**: 安装 Python 并包含其 C 头文件
- **Linux**: 安装 `python-all` 或至少 `python-distutils` 和 `python-dev`
- **Mac**: MacOS 10.15+ 和 Xcode 11.0+

推荐：
- 支持 XML 和 Python 的文本编辑器
- Python 3.0 或更高版本

注意：TheSimulator 已内嵌 Python 3.0 支持，但该环境仅能从仿真二进制文件中调用，不适用于预先测试。

### 安装步骤

1. **克隆仓库**：

    ```bash
    git clone --recurse-submodules <repository_url>
    cd thesimulator
    ```

2. **创建构建目录并进入**：

    ```bash
    mkdir build
    cd build
    ```

3. **配置和生成构建文件**：

    ```bash
    cmake ../
    ```

4. **编译仿真器**：

    ```bash
    cmake --build .
    ```

5. **运行仿真器**：

    ```bash
    ./TheSimulator --help
    ```

## 使用手册

### 快速入门

1. **编写仿真配置文件**：仿真配置使用 XML 文件格式，设置仿真属性并添加代理。以下是一个最小示例：

    ```xml
    <?xml version="1.0" encoding="UTF-8" standalone="no" ?>
    <Simulation start="0" duration="1000001">
        <ExchangeAgent name="MARKET" algorithm="PriceTime" />
        <RandomWalkMarketMakerAgent
            name="TRADER_MARKET_MAKER"
            exchange="MARKET"
            halfSpread="0.01"
            depth="1"
            p="0.5"
            priceStep="0.1"
            timeStep="1000"
            init="100"
            lb="50"
            ub="150"
        />
        <DoobAgent name="TRADER_DOOB" a="99" b="101" tradeUnit="1" />
        <TradeLogAgent name="LOGGER_TRADE" exchange="MARKET" />
    </Simulation>
    ```

2. **运行仿真**：

    - 在 GNU 系统上：

        ```bash
        ./TheSimulator Simulation.xml
        ```

    - 在 Windows 系统上：

        ```bash
        .\TheSimulator.exe Simulation.xml
        ```

### 添加自定义代理

#### 自定义 C++ 代理

1. 创建继承自 `Agent` 的新类 `CustomAgent` 并实现其虚方法。
2. 实现 `receiveMessage` 以处理代理逻辑和环境交互。
3. 在 `Simulation.cpp` 文件的 `Simulation::setupChildConfiguration` 方法中添加以下 `else-if` 子句：

    ```cpp
    else if (nodeName == "CustomAgent") {
        auto eaptr = std::make_unique<CustomAgent>(this);
        eaptr->configure(*nit, configurationPath);
        m_agentList.push_back(std::move(eaptr));
    }
    ```

#### 简单的自定义 Python 代理

1. 编写 `PrintingAgent.py` 文件：

    ```python
    from thesimulator import *

    class PrintingAgent:
        def configure(self, params):
            print(" --- Configuring with the following parameters --- ")
            print(params)
            print(" ------------------------------------------------- ")

        def receiveMessage(self, simulation, type, payload):
            currentTimestamp = simulation.currentTimestamp()
            print("Received a message of type '%s' at time %d, payload %s " % (type, currentTimestamp, payload))
    ```

2. 编写 `PrintingAgentExample.xml` 文件：

    ```xml
    <Simulation start="0" duration="1001">
        <PrintingAgent name="AGENT" parameter="value" />
    </Simulation>
    ```

3. 运行仿真：

    ```bash
    ./TheSimulator PrintingAgentExample.xml
    ```

## 示例输出

```bash
ExchangeSimulator v2.0
 - 'Simulation.xml' loaded successfully
 - starting the simulations
 --- Configuring with the following parameters 
---
{'parameter': 'value'}
 -------------------------------------------------
Received a message of type 'EVENT_SIMULATION_START' at time 0, payload {}
Received a message of type 'EVENT_SIMULATION_STOP' at time 1000, payload {}
 - all simulations finished, exiting
```


(SBI)=
# Simulation-based Inference
## 基于模拟的推理（Simulation-based Inference, SBI）

基于模拟的推理（Simulation-based Inference, SBI）是一种统计方法，用于从复杂的、难以直接分析的模型中推断参数。与传统的统计推断方法不同，SBI 不依赖于解析形式的似然函数，而是通过模拟数据来进行推断。这使得 SBI 特别适用于处理高维、非线性和非高斯分布的模型。

### 核心思想

SBI 的核心思想是利用计算机模拟生成大量的样本数据，并通过这些数据来估计模型参数的后验分布。具体步骤如下：

1. **模型定义**：定义一个生成模型，该模型能够根据给定的参数生成观测数据。
2. **数据模拟**：使用生成模型模拟大量的观测数据。
3. **推断过程**：通过比较模拟数据和实际观测数据，使用适当的推断算法（如 ABC、MCMC 或神经网络）来估计参数的后验分布。

### 优势

- **灵活性**：SBI 可以处理各种复杂模型，包括那些没有解析形式的似然函数。
- **适应性**：适用于高维数据和复杂的参数空间。
- **可扩展性**：可以结合现代机器学习方法，如深度学习，来提高推断效率和准确性。

### 应用领域

SBI 在许多领域中都有广泛的应用，包括但不限于：

- **天文学**：用于推断宇宙学参数和天体物理模型。
- **生态学**：用于估计生态系统模型中的参数。
- **经济学**：用于复杂经济模型的参数推断。
- **神经科学**：用于神经网络模型的参数估计。

- **金融仿真**：在金融领域，SBI 被广泛用于模拟和分析复杂的金融系统和市场行为。通过模拟不同的市场条件和交易策略，研究人员和从业者可以评估风险、优化投资组合、预测市场趋势以及测试新的金融产品。具体应用包括：

  - **风险管理**：通过模拟市场波动和极端事件，SBI 可以帮助金融机构评估和管理风险敞口。
  - **投资组合优化**：利用 SBI 模拟不同的投资组合策略，找到最优的资产配置方案。
  - **衍生品定价**：在复杂的衍生品市场中，SBI 可以用于定价和对冲策略的开发。
  - **市场微观结构分析**：通过模拟交易行为和市场动态，SBI 可以帮助理解市场微观结构和价格形成机制。


