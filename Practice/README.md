# ST语言编程实践指南

## 📁 目录结构

```
Practice/
├── 01_Basic/                    # 第1-3章：基础语法
│   ├── 01_01_HelloWorld.st     # 第一个ST程序
│   ├── 01_02_VariableDemo.st   # 变量声明演示
│   ├── 01_03_DataTypeDemo.st   # 数据类型演示
│   └── 01_04_OperatorDemo.st   # 运算符演示
│
├── 02_Control/                  # 第4-5章：控制语句
│   ├── 02_01_IFDemo.st        # IF条件语句
│   ├── 02_02_CASEDemo.st      # CASE选择语句
│   ├── 02_03_FORDemo.st       # FOR循环
│   ├── 02_04_WHILEDemo.st     # WHILE循环
│   └── 02_05_MotorControl.st  # 综合练习：电机控制
│
├── 03_Function/                 # 第6章：函数
│   ├── 03_01_FunctionDemo.st   # 函数基础
│   ├── 03_02_MathFunctions.st  # 数学函数库
│   ├── 03_03_ArrayFunctions.st # 数组处理函数
│   └── 03_04_RecursionDemo.st # 递归函数
│
├── 04_FunctionBlock/           # 第7章：功能块
│   ├── 04_01_FBDemo.st         # 功能块基础
│   ├── 04_02_CounterFB.st      # 计数器功能块
│   ├── 04_03_TimerFB.st        # 定时器功能块
│   ├── 04_04_EdgeDetect.st     # 边沿检测功能块
│   └── 04_05_MotorControlFB.st # 电机控制功能块
│
├── 05_DataStructure/            # 第8章：数据结构
│   ├── 05_01_ArrayDemo.st      # 数组演示
│   ├── 05_02_StructDemo.st     # 结构体演示
│   ├── 05_03_ComplexData.st    # 复杂数据结构
│   └── 05_04_DataLogger.st     # 数据采集案例
│
├── 06_TypeDefinition/          # 第9章：类型定义
│   ├── 06_01_EnumDemo.st       # 枚举类型
│   ├── 06_02_SubrangeDemo.st   # 子范围类型
│   └── 06_03_StateMachine.st   # 状态机应用
│
├── 07_Advanced/                 # 第10章：高级特性
│   ├── 07_01_PointerDemo.st    # 指针演示
│   ├── 07_02_TypeConversion.st # 类型转换
│   └── 07_03_RingBuffer.st    # 环形缓冲区
│
├── GlobalVariables.gvl         # 全局变量定义
└── Project/                     # CODESYS项目文件(可选)
```

## 🚀 如何使用

### 方式一：CODESYS IDE

1. 打开 CODESYS 开发环境
2. 创建新项目 → 选择 PLC 编程
3. 在项目树中创建对应的 POU
4. 将 `.st` 文件内容复制到对应的 POU 中
5. 编译运行

### 方式二：TwinCAT

1. 在 Visual Studio 中打开 TwinCAT 项目
2. 创建新的 ST 源文件
3. 粘贴代码内容
4. 编译并下载到 PLC

## 📝 代码使用说明

每个代码文件都包含：
- **文件头注释**：说明功能、作者、日期
- **变量声明区**：VAR_INPUT, VAR_OUTPUT, VAR
- **实现代码**：BEGIN...END_FUNCTION/FUNCTION_BLOCK
- **使用示例**：在注释中说明如何调用

## ⚠️ 注意事项

1. 某些高级特性（如指针操作）可能因 PLC 平台不同而有所差异
2. 定时器和时间相关代码需要在实际 PLC 上测试
3. 建议先在仿真模式下运行验证
4. 全局变量文件需要在 CODESYS 中导入

## 🔧 环境配置建议

推荐配置：
- CODESYS Development System 3.5+
- 目标设备：SoftPLC 或实际 PLC
- 扫描周期：10ms - 100ms（根据应用调整）

---

**开始你的ST语言编程实践之旅吧！** 🚀
