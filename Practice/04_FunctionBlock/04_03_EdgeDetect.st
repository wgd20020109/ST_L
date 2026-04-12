(* ============================================================================
 * 文件: 04_03_EdgeDetect.st
 * 章节: 第7章 - 功能块
 * 描述: 边沿检测功能块
 * 学习目标: 掌握边沿检测的原理和实现
 * ============================================================================ *)

(* ============================================================================
 * 功能块: R_TRIG - 上升沿检测
 * 功能: 检测信号从FALSE变为TRUE的时刻
 * ============================================================================ *)
FUNCTION_BLOCK R_TRIG
VAR_INPUT
    CLK : BOOL;    // 输入信号
END_VAR

VAR_OUTPUT
    Q : BOOL;      // 上升沿脉冲输出
END_VAR

VAR
    lastCLK : BOOL := FALSE;
END_VAR

BEGIN
    // 上升沿条件: 当前=TRUE 且 上次=FALSE
    Q := CLK AND NOT lastCLK;
    lastCLK := CLK;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: F_TRIG - 下降沿检测
 * 功能: 检测信号从TRUE变为FALSE的时刻
 * ============================================================================ *)
FUNCTION_BLOCK F_TRIG
VAR_INPUT
    CLK : BOOL;    // 输入信号
END_VAR

VAR_OUTPUT
    Q : BOOL;      // 下降沿脉冲输出
END_VAR

VAR
    lastCLK : BOOL := FALSE;
END_VAR

BEGIN
    // 下降沿条件: 当前=FALSE 且 上次=TRUE
    Q := NOT CLK AND lastCLK;
    lastCLK := CLK;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: CounterFB - 基于边沿的计数器
 * 功能: 使用边沿检测实现脉冲计数
 * ============================================================================ *)
FUNCTION_BLOCK CounterFB
VAR_INPUT
    clock : BOOL;              // 时钟输入
    reset : BOOL;              // 复位输入
    preset : INT := 100;       // 预设值
    direction : BOOL := TRUE;   // 方向: TRUE=递增, FALSE=递减
END_VAR

VAR_OUTPUT
    Q : BOOL;                   // 达到预设
    underflow : BOOL;           // 欠流
    cv : INT;                   // 当前值
END_VAR

VAR
    risingEdge : R_TRIG;
    lastReset : BOOL := FALSE;
END_VAR

BEGIN
    // 检测复位上升沿
    IF reset AND NOT lastReset THEN
        cv := 0;
    END_IF;
    lastReset := reset;

    // 检测时钟上升沿
    risingEdge(CLK := clock);
    IF risingEdge.Q THEN
        IF direction THEN
            // 递增计数
            IF cv < 32767 THEN
                cv := cv + 1;
            END_IF;
        ELSE
            // 递减计数
            IF cv > -32768 THEN
                cv := cv - 1;
            END_IF;
        END_IF
    END_IF;

    // 输出状态
    Q := (cv >= preset);
    underflow := (cv <= 0);

END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: OneShot - 单次触发
 * 功能: 信号第一次变为TRUE时输出TRUE，之后保持FALSE直到复位
 * ============================================================================ *)
FUNCTION_BLOCK OneShot
VAR_INPUT
    trigger : BOOL;    // 触发信号
    reset : BOOL;     // 复位信号
END_VAR

VAR_OUTPUT
    Q : BOOL;         // 单次输出
END_VAR

VAR
    armed : BOOL := TRUE;  //  armed = TRUE 时可以触发
    lastTrigger : BOOL := FALSE;
END_VAR

BEGIN
    // 检测触发上升沿
    IF trigger AND NOT lastTrigger THEN
        IF armed THEN
            Q := TRUE;
            armed := FALSE;
        END_IF
    END_IF;

    // 复位
    IF reset THEN
        Q := FALSE;
        armed := TRUE;
    END_IF;

    lastTrigger := trigger;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: Toggle - 翻转触发
 * 功能: 每次触发时翻转输出状态
 * ============================================================================ *)
FUNCTION_BLOCK Toggle
VAR_INPUT
    trigger : BOOL;    // 触发信号
    reset : BOOL;      // 复位信号
END_VAR

VAR_OUTPUT
    Q : BOOL;          // 翻转输出
END_VAR

VAR
    lastTrigger : BOOL := FALSE;
END_VAR

BEGIN
    // 检测触发上升沿
    IF trigger AND NOT lastTrigger THEN
        Q := NOT Q;
    END_IF;

    // 复位
    IF reset THEN
        Q := FALSE;
    END_IF;

    lastTrigger := trigger;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: PulseGenerator - 脉冲生成器
 * 功能: 产生指定数量的脉冲
 * ============================================================================ *)
FUNCTION_BLOCK PulseGenerator
VAR_INPUT
    trigger : BOOL;        // 触发信号
    pulseCount : INT := 5; // 脉冲数量
    pulseWidth : TIME := T#100ms;  // 脉冲宽度
END_VAR

VAR_OUTPUT
    Q : BOOL;              // 脉冲输出
    busy : BOOL;           // 工作中
    done : BOOL;           // 完成
END_VAR

VAR
    edgeDetect : R_TRIG;
    timer : TP;
    remaining : INT := 0;
    lastTrigger : BOOL := FALSE;
    generating : BOOL := FALSE;
END_VAR

BEGIN
    // 检测触发
    edgeDetect(CLK := trigger);
    IF edgeDetect.Q AND NOT generating THEN
        remaining := pulseCount;
        generating := TRUE;
        done := FALSE;
    END_IF;

    // 生成脉冲
    IF generating THEN
        busy := TRUE;

        // 生成脉冲
        timer(IN := (remaining > 0), PT := pulseWidth);
        Q := timer.Q;

        // 计数
        IF timer.Q AND (remaining > 0) THEN
            remaining := remaining - 1;
        END_IF;

        // 完成
        IF remaining <= 0 THEN
            generating := FALSE;
            busy := FALSE;
            done := TRUE;
            Q := FALSE;
        END_IF
    ELSE
        busy := FALSE;
        done := FALSE;
        Q := FALSE;
        timer(IN := FALSE);
    END_IF;

    lastTrigger := trigger;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: Debounce - 防抖模块
 * 功能: 对输入信号进行防抖处理
 * ============================================================================ *)
FUNCTION_BLOCK Debounce
VAR_INPUT
    signal : BOOL;                 // 输入信号
    debounceTime : TIME := T#50ms; // 防抖时间
END_VAR

VAR_OUTPUT
    Q : BOOL;                      // 去抖后输出
END_VAR

VAR
    timer : TON;
    lastSignal : BOOL := FALSE;
END_VAR

BEGIN
    // 状态改变时启动定时器
    IF signal <> lastSignal THEN
        timer(IN := TRUE, PT := debounceTime);
    END_IF;

    // 定时结束且信号稳定
    IF timer.Q THEN
        Q := signal;
    END_IF;

    // 定时结束前保持原状态
    IF NOT timer.Q AND timer.ET > T#0ms THEN
        // 等待中，保持原状态
    END_IF;

    // 信号稳定后复位定时器
    IF signal = lastSignal THEN
        timer(IN := FALSE);
    END_IF;

    lastSignal := signal;
END_FUNCTION_BLOCK

(* ============================================================================
 * 程序: EdgeDetectionDemo
 * 功能: 边沿检测功能块演示
 * ============================================================================ *)
PROGRAM EdgeDetectionDemo
VAR
    (* 边沿检测实例 *)
    sensorRising : R_TRIG;
    buttonRising : R_TRIG;
    sensorFalling : F_TRIG;

    (* 计数器实例 *)
    partCounter : CounterFB;
    cycleCounter : CounterFB;

    (* 其他功能块实例 *)
    motorToggle : Toggle;
    startOneShot : OneShot;
    pulseGen : PulseGenerator;
    inputDebounce : Debounce;

    (* 输入信号 *)
    bSensor : BOOL := FALSE;
    bButton : BOOL := FALSE;
    bReset : BOOL := FALSE;

    (* 输出 *)
    iPartCount : INT;
    bMotorRunning : BOOL;
    iPulseOutput : BOOL;
    bDebounced : BOOL;

    (* 边沿信号 *)
    bSensorEdge : BOOL;
    bButtonEdge : BOOL;

    (* 循环计数 *)
    i : INT;
END_VAR

BEGIN
    // ==========================================================================
    // 1. 上升沿检测
    // ==========================================================================

    sensorRising(CLK := bSensor);
    bSensorEdge := sensorRising.Q;

    // 检测到上升沿时计数
    IF bSensorEdge THEN
        iPartCount := iPartCount + 1;
    END_IF

    // ==========================================================================
    // 2. 下降沿检测
    // ==========================================================================

    sensorFalling(CLK := bSensor);
    // bSensorEdge := sensorFalling.Q; // 下降沿检测

    // ==========================================================================
    // 3. 翻转触发
    // ==========================================================================

    motorToggle(trigger := bButton, reset := bReset);
    bMotorRunning := motorToggle.Q;

    // ==========================================================================
    // 4. 单次触发
    // ==========================================================================

    startOneShot(trigger := bButton, reset := bReset);
    // startOneShot.Q 只在第一次触发时为TRUE

    // ==========================================================================
    // 5. 防抖
    // ==========================================================================

    inputDebounce(
        signal := bSensor,
        debounceTime := T#50ms
    );
    bDebounced := inputDebounce.Q;

    // ==========================================================================
    // 6. 脉冲生成器
    // ==========================================================================

    pulseGen(
        trigger := bButton,
        pulseCount := 5,
        pulseWidth := T#100ms
    );
    iPulseOutput := pulseGen.Q;

    // ==========================================================================
    // 7. 组合应用示例
    // ==========================================================================

    // 检测启动按钮上升沿，计数
    buttonRising(CLK := bButton);
    IF buttonRising.Q THEN
        partCounter(
            clock := TRUE,
            reset := bReset,
            preset := 100,
            direction := TRUE
        );
    END_IF

    iPartCount := partCounter.cv;

END_PROGRAM
