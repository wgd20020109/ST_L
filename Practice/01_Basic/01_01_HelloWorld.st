(* ============================================================================
 * 文件: 01_01_HelloWorld.st
 * 章节: 第1章 - ST语言简介
 * 描述: 第一个ST程序 - 闪烁灯控制
 * 学习目标: 理解ST程序的基本结构
 * ============================================================================ *)

(* --------------------------------------------------------------------------
 * 全局变量声明
 * 这些变量会被映射到实际的物理输入/输出
 * -------------------------------------------------------------------------- *)
VAR_GLOBAL
    // 数字量输入
    iStartButton AT %IX0.0 : BOOL;      // 启动按钮
    iStopButton AT %IX0.1 : BOOL;      // 停止按钮
    iEmergencyStop AT %IX0.2 : BOOL;    // 急停按钮

    // 数字量输出
    qIndicatorLight AT %QX0.0 : BOOL;   // 指示灯
    qMotorRun AT %QX0.1 : BOOL;         // 电机运行
    qAlarm AT %QX0.2 : BOOL;            // 报警输出

    // 模拟量输入
    iTemperature AT %IW0 : INT;          // 温度传感器
    iPressure AT %IW2 : INT;             // 压力传感器

    // 模拟量输出
    qMotorSpeed AT %QW0 : INT;          // 电机速度设定
END_VAR

(* ============================================================================
 * 程序: HelloWorld
 * 功能: 简单的闪烁灯程序，展示ST程序的基本结构
 * ============================================================================ *)
PROGRAM HelloWorld
VAR
    // 内部变量
    timer : TON;                         // 通电延时定时器
    blinkFlag : BOOL := FALSE;           // 闪烁标志
    cycleCounter : INT := 0;             // 循环计数器
    lastButtonState : BOOL := FALSE;     // 上次按钮状态
    pressCount : INT := 0;               // 按钮按下次数
END_VAR

// ============================================================================
// 主程序逻辑
// ============================================================================
BEGIN
    // ------------------------------------------------------------------------
    // 1. 边沿检测 - 检测启动按钮的上升沿
    // ------------------------------------------------------------------------
    IF iStartButton AND NOT lastButtonState THEN
        pressCount := pressCount + 1;
    END_IF
    lastButtonState := iStartButton;

    // ------------------------------------------------------------------------
    // 2. 急停处理 - 最高优先级
    // ------------------------------------------------------------------------
    IF iEmergencyStop THEN
        qMotorRun := FALSE;
        qAlarm := TRUE;
        blinkFlag := FALSE;
        qIndicatorLight := FALSE;
    ELSE
        qAlarm := FALSE;

        // ------------------------------------------------------------------------
        // 3. 正常启停控制
        // ------------------------------------------------------------------------
        IF iStartButton THEN
            qMotorRun := TRUE;
        END_IF;

        IF iStopButton THEN
            qMotorRun := FALSE;
            blinkFlag := FALSE;
        END_IF;
    END_IF

    // ------------------------------------------------------------------------
    // 4. 闪烁灯逻辑
    // ------------------------------------------------------------------------
    // 当电机运行时，指示灯以1Hz频率闪烁
    timer(IN := NOT timer.Q, PT := T#500ms);

    IF timer.Q THEN
        IF qMotorRun THEN
            blinkFlag := NOT blinkFlag;
        ELSE
            blinkFlag := FALSE;
        END_IF;
    END_IF;

    qIndicatorLight := blinkFlag;

    // ------------------------------------------------------------------------
    // 5. 电机速度控制 - 根据温度调整
    // ------------------------------------------------------------------------
    IF qMotorRun THEN
        // 温度越高，速度越慢（保护电机）
        IF iTemperature < 500 THEN
            qMotorSpeed := 1500;  // 正常速度
        ELSIF iTemperature < 800 THEN
            qMotorSpeed := 1000;  // 中等速度
        ELSE
            qMotorSpeed := 500;   // 低速
        END_IF;
    ELSE
        qMotorSpeed := 0;
    END_IF

    // ------------------------------------------------------------------------
    // 6. 循环计数器
    // ------------------------------------------------------------------------
    cycleCounter := cycleCounter + 1;
    IF cycleCounter >= 1000 THEN
        cycleCounter := 0;
    END_IF;

END_PROGRAM
