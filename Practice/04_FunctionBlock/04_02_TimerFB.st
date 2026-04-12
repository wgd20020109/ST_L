(* ============================================================================
 * 文件: 04_02_TimerFB.st
 * 章节: 第7章 - 功能块
 * 描述: 定时器功能块
 * 学习目标: 掌握定时器功能块的编写
 * ============================================================================ *)

(* ============================================================================
 * 功能块: TON - 通电延时定时器
 * 功能: 输入为TRUE时，延时PT后输出Q变为TRUE
 * ============================================================================ *)
FUNCTION_BLOCK TON
VAR_INPUT
    IN : BOOL;    // 触发输入
    PT : TIME;    // 延时时间
END_VAR

VAR_OUTPUT
    Q : BOOL;     // 定时输出
    ET : TIME;    // 已计时时间
END_VAR

VAR
    startTime : TIME;
    running : BOOL := FALSE;
    lastIN : BOOL := FALSE;
END_VAR

BEGIN
    // 检测上升沿
    IF IN AND NOT lastIN THEN
        running := TRUE;
        startTime := TIME();
        Q := FALSE;
    END_IF;

    // 输入变为FALSE，立即复位
    IF NOT IN THEN
        running := FALSE;
        Q := FALSE;
        ET := T#0s;
    END_IF;

    // 计时中
    IF running THEN
        ET := TIME() - startTime;
        IF ET >= PT THEN
            Q := TRUE;
            ET := PT;
        END_IF
    END_IF;

    lastIN := IN;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: TOF - 断电延时定时器
 * 功能: 输入变为FALSE时，延时PT后输出Q变为FALSE
 * ============================================================================ *)
FUNCTION_BLOCK TOF
VAR_INPUT
    IN : BOOL;    // 触发输入
    PT : TIME;    // 延时时间
END_VAR

VAR_OUTPUT
    Q : BOOL;     // 定时输出
    ET : TIME;    // 已计时时间
END_VAR

VAR
    startTime : TIME;
    running : BOOL := FALSE;
    lastIN : BOOL := FALSE;
END_VAR

BEGIN
    // 输入变为TRUE，立即输出TRUE
    IF IN AND NOT lastIN THEN
        Q := TRUE;
        running := FALSE;
        ET := T#0s;
    END_IF;

    // 输入变为FALSE，启动延时
    IF NOT IN AND lastIN THEN
        running := TRUE;
        startTime := TIME();
    END_IF;

    // 计时中
    IF running THEN
        ET := TIME() - startTime;
        IF ET >= PT THEN
            Q := FALSE;
            running := FALSE;
            ET := T#0s;
        END_IF
    END_IF;

    lastIN := IN;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: TP - 脉冲定时器
 * 功能: 每次触发产生固定宽度的脉冲
 * ============================================================================ *)
FUNCTION_BLOCK TP
VAR_INPUT
    IN : BOOL;    // 触发输入
    PT : TIME;    // 脉冲宽度
END_VAR

VAR_OUTPUT
    Q : BOOL;     // 脉冲输出
    ET : TIME;    // 已计时时间
END_VAR

VAR
    startTime : TIME;
    running : BOOL := FALSE;
    lastIN : BOOL := FALSE;
END_VAR

BEGIN
    // 检测上升沿且未运行时启动
    IF IN AND NOT lastIN AND NOT running THEN
        running := TRUE;
        startTime := TIME();
        Q := TRUE;
    END_IF;

    // 计时
    IF running THEN
        ET := TIME() - startTime;
        IF ET >= PT THEN
            Q := FALSE;
            running := FALSE;
            ET := PT;
        END_IF
    ELSE
        ET := T#0s;
    END_IF;

    lastIN := IN;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: TON10ms - 10ms分辨率定时器（软件模拟）
 * 功能: 适用于不支持TIME类型的系统
 * ============================================================================ *)
FUNCTION_BLOCK TON10ms
VAR_INPUT
    IN : BOOL;
    PTms : INT;    // 延时时间（毫秒）
END_VAR

VAR_OUTPUT
    Q : BOOL;
    ETms : INT;    // 已计时时间（毫秒）
END_VAR

VAR
    startTick : INT;
    running : BOOL := FALSE;
    lastIN : BOOL := FALSE;
    currentTick : INT;
END_VAR

BEGIN
    // 检测上升沿
    IF IN AND NOT lastIN THEN
        running := TRUE;
        startTick := currentTick;
        Q := FALSE;
    END_IF;

    // 输入变为FALSE，立即复位
    IF NOT IN THEN
        running := FALSE;
        Q := FALSE;
        ETms := 0;
    END_IF;

    // 计时中
    IF running THEN
        ETms := (currentTick - startTick) * 10;  // 假设每个tick为10ms
        IF ETms >= PTms THEN
            Q := TRUE;
            ETms := PTms;
        END_IF
    END_IF;

    lastIN := IN;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: Blinker - 闪烁定时器
 * 功能: 产生连续闪烁信号
 * ============================================================================ *)
FUNCTION_BLOCK Blinker
VAR_INPUT
    enable : BOOL;
    period : TIME := T#1s;    // 闪烁周期
END_VAR

VAR_OUTPUT
    Q : BOOL;                 // 闪烁输出
END_VAR

VAR
    timer : TON;
    toggle : BOOL := FALSE;
END_VAR

BEGIN
    IF enable THEN
        timer(IN := NOT timer.Q, PT := period);
        IF timer.Q THEN
            toggle := NOT toggle;
        END_IF;
        Q := toggle;
    ELSE
        Q := FALSE;
        toggle := FALSE;
        timer(IN := FALSE);
    END_IF
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: Watchdog - 看门狗定时器
 * 功能: 监控信号是否正常
 * ============================================================================ *)
FUNCTION_BLOCK Watchdog
VAR_INPUT
    IN : BOOL;                // 被监控信号
    timeout : TIME := T#5s;   // 超时时间
    reset : BOOL;             // 手动复位
END_VAR

VAR_OUTPUT
    Q : BOOL;                 // 超时标志
    ET : TIME;                // 已超时时间
END_VAR

VAR
    timer : TON;
END_VAR

BEGIN
    // 监控信号
    timer(IN := NOT IN, PT := timeout);
    Q := timer.Q;
    ET := timer.ET;

    // 手动复位
    IF reset THEN
        timer(IN := FALSE);
        Q := FALSE;
    END_IF
END_FUNCTION_BLOCK

(* ============================================================================
 * 程序: TimerDemo
 * 功能: 定时器功能块演示
 * ============================================================================ *)
PROGRAM TimerDemo
VAR
    (* 定时器实例 *)
    startDelay : TON;          // 启动延时
    stopDelay : TOF;           // 停止延时
    pulseTimer : TP;           // 脉冲定时器
    warningBlink : Blinker;    // 警告闪烁
    motorWatchdog : Watchdog;   // 电机看门狗

    (* 输入信号 *)
    bStartButton : BOOL := TRUE;
    bStopButton : BOOL := FALSE;
    bMotorRunning : BOOL := FALSE;
    bFaultPresent : BOOL := FALSE;

    (* 输出 *)
    bMotor : BOOL;
    bWarningLight : BOOL;
    bWatchdogFault : BOOL;

    (* 状态显示 *)
    tElapsed : TIME;
END_VAR

BEGIN
    // ==========================================================================
    // 1. 启动延时 (TON)
    // ==========================================================================
    // 按下启动按钮后，延时2秒启动电机

    startDelay(
        IN := bStartButton,
        PT := T#2s
    );

    bMotor := startDelay.Q;
    tElapsed := startDelay.ET;

    // ==========================================================================
    // 2. 停止延时 (TOF)
    // ==========================================================================
    // 松开停止按钮后，延时3秒停止电机（用于平滑停止）

    stopDelay(
        IN := bStopButton,
        PT := T#3s
    );

    // 注意: TOF的逻辑是输入FALSE时延时
    // 这里需要反向逻辑

    // ==========================================================================
    // 3. 脉冲定时器 (TP)
    // ==========================================================================
    // 产生一个500ms的脉冲

    pulseTimer(
        IN := bStartButton,
        PT := T#500ms
    );

    // pulseTimer.Q 会在按下按钮时产生500ms脉冲

    // ==========================================================================
    // 4. 闪烁定时器
    // ==========================================================================
    // 故障时警告灯以1Hz闪烁

    warningBlink(
        enable := bFaultPresent,
        period := T#1s
    );

    bWarningLight := warningBlink.Q;

    // ==========================================================================
    // 5. 看门狗定时器
    // ==========================================================================
    // 监控电机运行信号，5秒无信号则报警

    motorWatchdog(
        IN := bMotorRunning,
        timeout := T#5s,
        reset := FALSE
    );

    bWatchdogFault := motorWatchdog.Q;

    // ==========================================================================
    // 综合应用示例
    // ==========================================================================

    // 使用TON实现延时启动
    startDelay(IN := bStartButton, PT := T#1s);

    // 组合使用: 启动延时 + 脉冲指示
    IF startDelay.Q AND NOT bMotor THEN
        pulseTimer(IN := TRUE, PT := T#200ms);
        bMotor := TRUE;
    END_IF

    // 故障时闪烁
    IF bFaultPresent THEN
        warningBlink(enable := TRUE, period := T#500ms);
        bWarningLight := warningBlink.Q;
    ELSE
        warningBlink(enable := FALSE);
        bWarningLight := FALSE;
    END_IF

END_PROGRAM
