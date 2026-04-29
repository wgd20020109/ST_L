# ST_L

本仓库用于学习和练习 Structured Text (ST) —— 一种在工业控制与可编程逻辑控制器(PLC)中常用的编程语言，属于 IEC 61131-3 标准的一部分。

## 项目目标
- 提供 ST 语言的学习资料、示例代码与练习题。
- 演示常见控制结构、函数块、数据结构与 I/O 交互的用法。
- 为学习者搭建可在仿真或实际 PLC 运行的示例工程。

## 主要内容
- src/：Structured Text 源代码示例（.st 文件或工程导出格式）。
- examples/：按练习/主题分类的代码示例（例如：PID 控制、定时器、状态机）。
- docs/：学习笔记、教程与使用说明。
- tools/：推荐的编辑器与仿真工具配置、脚本或说明（例如 CODESYS、TwinCAT、OpenPLC 等）。

> 本仓库的语言/用途：Structured Text (ST) 学习资料

## 运行环境与工具
- 支持 ST 的常用环境：CODESYS、Beckhoff TwinCAT、Siemens TIA Portal (SCL)、OpenPLC、PLCnext 等。部分工具提供免费试用或社区版。
- 若需在电脑上测试：可使用 OpenPLC 或厂商提供的仿真运行时；也可将示例导入到相应 IDE 并连接到真实 PLC。

## 如何使用
1. 克隆或下载本仓库到本地：
   git clone https://github.com/wgd20020109/ST_L.git
2. 打开支持 ST 的 IDE（例如 CODESYS 或 TwinCAT）并新建工程，或在 OpenPLC 中导入示例文件。
3. 将 examples/ 或 src/ 下的 .st 文件导入到工程中，编译并在仿真/运行时中测试。
4. 按练习说明修改参数、观察 I/O 变化并记录运行结果。

## 学习建议与示例主题
- 基础语法：变量声明、基本数据类型、算术与逻辑运算。
- 控制结构：IF、CASE、FOR、WHILE、REPEAT 等。
- 功能块与模块化：自定义 Function、Function Block、Program。
- 定时与计数器（TON、TOF、TP 等）和常用库的使用。
- PID 控制实现、状态机设计、通信（Modbus、Ethernet/IP 等）示例。

## 参考资料
- IEC 61131-3 标准（Structured Text 所属标准）
- CODESYS 官方文档
- Beckhoff TwinCAT 文档与 SCL 教程
- OpenPLC 项目主页与文档
