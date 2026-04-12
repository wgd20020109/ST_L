(* ============================================================================
 * 文件: 04_01_CounterFB.st
 * 章节: 第7章 - 功能块
 * 描述: 计数器功能块
 * 学习目标: 掌握功能块的定义和实例化
 * ============================================================================ *)

(* ============================================================================
 * 功能块: Counter
 * 功能: 双向计数器，支持递增/递减计数
 * ============================================================================ *)
FUNCTION_BLOCK Counter
VAR_INPUT
    enable : BOOL := TRUE;           // 使能
    preset : INT := 100;             // 预设值
    increment : BOOL;                // 递增触发
    decrement : BOOL;                // 递减触发
    reset : BOOL;                    // 复位
END_VAR

VAR_OUTPUT
    currentValue : INT;              // 当前计数值
    done : BOOL;                     // 计数完成标志
    underflow : BOOL;                // 欠流标志
    overflow : BOOL;                 // 溢出标志
END_VAR

VAR
    lastInc : BOOL := FALSE;         // 上次递增状态
    lastDec : BOOL := FALSE;         // 上次递减状态
    lastReset : BOOL := FALSE;       // 上次复位状态
END_VAR

BEGIN
    (* 检测递增上升沿 *)
    IF increment AND NOT lastInc THEN
        IF enable THEN
            IF currentValue < 32767 THEN
                currentValue := currentValue + 1;
            ELSE
                overflow := TRUE;
            END_IF
        END_IF
    END_IF;

    (* 检测递减上升沿 *)
    IF decrement AND NOT lastDec THEN
        IF enable THEN
            IF currentValue > -32768 THEN
                currentValue := currentValue - 1;
            ELSE
                underflow := TRUE;
            END_IF
        END_IF
    END_IF;

    (* 检测复位上升沿 *)
    IF reset AND NOT lastReset THEN
        currentValue := 0;
        done := FALSE;
        overflow := FALSE;
        underflow := FALSE;
    END_IF;

    (* 更新完成状态 *)
    done := (currentValue >= preset);

    (* 保存上次状态 *)
    lastInc := increment;
    lastDec := decrement;
    lastReset := reset;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: UpCounter (递增计数器简化版)
 * ============================================================================ *)
FUNCTION_BLOCK UpCounter
VAR_INPUT
    enable : BOOL := TRUE;
    preset : INT := 100;
    count : BOOL;                    // 计数脉冲
    reset : BOOL;
END_VAR

VAR_OUTPUT
    q : BOOL;                        // 达到预设值
    cv : INT;                        // 当前值
END_VAR

VAR
    lastCount : BOOL := FALSE;
END_VAR

BEGIN
    (* 边沿检测 *)
    IF count AND NOT lastCount THEN
        IF enable AND NOT q THEN
            cv := cv + 1;
        END_IF
    END_IF;

    (* 复位 *)
    IF reset THEN
        cv := 0;
    END_IF;

    (* 输出 *)
    q := (cv >= preset);
    lastCount := count;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: DownCounter (递减计数器简化版)
 * ============================================================================ *)
FUNCTION_BLOCK DownCounter
VAR_INPUT
    enable : BOOL := TRUE;
    preset : INT := 10;
    count : BOOL;                    // 计数脉冲
    reset : BOOL;
END_VAR

VAR_OUTPUT
    q : BOOL;                        // 计数值减到0
    cv : INT;                        // 当前值
END_VAR

VAR
    lastCount : BOOL := FALSE;
END_VAR

BEGIN
    (* 边沿检测 *)
    IF count AND NOT lastCount THEN
        IF enable AND NOT q THEN
            IF cv > 0 THEN
                cv := cv - 1;
            END_IF
        END_IF
    END_IF;

    (* 复位 *)
    IF reset THEN
        cv := preset;
    END_IF;

    (* 输出 *)
    q := (cv <= 0);
    lastCount := count;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: CounterWithRate (带速率的计数器)
 * ============================================================================ *)
FUNCTION_BLOCK CounterWithRate
VAR_INPUT
    enable : BOOL := TRUE;
    preset : INT := 1000;
    pulse : BOOL;                    // 计数脉冲
    reset : BOOL;
    presetValue : INT;              // 可变预设值
END_VAR

VAR_OUTPUT
    current : INT;                   // 当前值
    done : BOOL;
    rate : REAL;                    // 计数速率 (次/秒)
END_VAR

VAR
    lastPulse : BOOL := FALSE;
    pulseCount : INT := 0;
    lastSecond : TIME := T#0s;
    currentSecond : TIME;
    rateTimer : TON;
END_VAR

BEGIN
    (* 检测脉冲 *)
    IF pulse AND NOT lastPulse THEN
        IF enable THEN
            current := current + 1;
            pulseCount := pulseCount + 1;
        END_IF
    END_IF;

    lastPulse := pulse;

    (* 复位 *)
    IF reset THEN
        current := 0;
        pulseCount := 0;
    END_IF;

    (* 计算速率 *)
    rateTimer(IN := enable, PT := T#1s);
    IF rateTimer.Q THEN
        rate := INT_TO_REAL(pulseCount);
        pulseCount := 0;
        rateTimer(IN := FALSE);
        rateTimer(IN := TRUE, PT := T#1s);
    END_IF;

    (* 完成标志 *)
    IF presetValue > 0 THEN
        done := (current >= presetValue);
    ELSE
        done := (current >= preset);
    END_IF
END_FUNCTION_BLOCK

(* ============================================================================
 * 程序: CounterDemo
 * 功能: 计数器功能块演示
 * ============================================================================ *)
PROGRAM CounterDemo
VAR
    (* 计数器实例 *)
    mainCounter : Counter;
    partCounter : UpCounter;
    batchCounter : DownCounter;
    rateCounter : CounterWithRate;

    (* 输入信号模拟 *)
    bPulse : BOOL := FALSE;
    bButton : BOOL := FALSE;

    (* 输出显示 *)
    iCount : INT;
    bDone : BOOL;
    rRate : REAL;

    (* 测试循环 *)
    i : INT;
END_VAR

BEGIN
    // ==========================================================================
    // 1. 基本计数器演示
    // ==========================================================================

    mainCounter(
        enable := TRUE,
        preset := 10,
        increment := bButton,
        decrement := FALSE,
        reset := FALSE
    );

    // 模拟10次计数
    FOR i := 1 TO 10 DO
        bButton := TRUE;
        mainCounter(
            enable := TRUE,
            preset := 10,
            increment := bButton,
            decrement := FALSE,
            reset := FALSE
        );
        bButton := FALSE;
    END_FOR;

    iCount := mainCounter.currentValue;  // 10
    bDone := mainCounter.done;           // TRUE

    // ==========================================================================
    // 2. 递增计数器演示
    // ==========================================================================

    // 复位
    partCounter(
        enable := TRUE,
        preset := 100,
        count := FALSE,
        reset := TRUE
    );

    // 计数50次
    FOR i := 1 TO 50 DO
        bPulse := TRUE;
        partCounter(
            enable := TRUE,
            preset := 100,
            count := bPulse,
            reset := FALSE
        );
        bPulse := FALSE;
    END_FOR;

    iCount := partCounter.cv;            // 50
    bDone := partCounter.q;             // FALSE

    // ==========================================================================
    // 3. 递减计数器演示
    // ==========================================================================

    batchCounter(
        enable := TRUE,
        preset := 20,
        count := FALSE,
        reset := TRUE
    );

    iCount := batchCounter.cv;          // 20

    // 递减计数
    FOR i := 1 TO 15 DO
        bPulse := TRUE;
        batchCounter(
            enable := TRUE,
            preset := 20,
            count := bPulse,
            reset := FALSE
        );
        bPulse := FALSE;
    END_FOR;

    iCount := batchCounter.cv;          // 5
    bDone := batchCounter.q;            // FALSE

    // 再计5次
    FOR i := 1 TO 5 DO
        bPulse := TRUE;
        batchCounter(
            enable := TRUE,
            preset := 20,
            count := bPulse,
            reset := FALSE
        );
        bPulse := FALSE;
    END_FOR;

    iCount := batchCounter.cv;          // 0
    bDone := batchCounter.q;            // TRUE

    // ==========================================================================
    // 4. 带速率计数器演示
    // ==========================================================================

    rateCounter(
        enable := TRUE,
        preset := 1000,
        pulse := FALSE,
        reset := TRUE,
        presetValue := 0
    );

    rateCounter(
        enable := TRUE,
        preset := 1000,
        pulse := bButton,
        reset := FALSE,
        presetValue := 500
    );

    iCount := rateCounter.current;      // 当前计数
    rRate := rateCounter.rate;          // 速率 (次/秒)

END_PROGRAM
