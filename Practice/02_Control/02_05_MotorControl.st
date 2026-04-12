(* ============================================================================
 * 文件: 02_05_MotorControl.st
 * 章节: 第5章 - 综合练习
 * 描述: 电机控制系统 - 综合运用条件与循环语句
 * 学习目标: 综合运用IF、CASE、FOR循环解决实际问题
 * ============================================================================ *)

PROGRAM MotorControl
VAR
    // ==========================================================================
    // 输入变量
    // ==========================================================================
    bStartButton AT %IX0.0 : BOOL;      // 启动按钮
    bStopButton AT %IX0.1 : BOOL;       // 停止按钮
    bResetButton AT %IX0.2 : BOOL;      // 复位按钮
    bEmergencyStop AT %IX0.3 : BOOL;    // 急停
    bHomeSensor AT %IX1.0 : BOOL;       // 原点传感器
    bLimitSwitch AT %IX1.1 : BOOL;      // 限位开关
    iTargetPosition AT %IW0 : INT;      // 目标位置

    // ==========================================================================
    // 输出变量
    // ==========================================================================
    bMotorRun AT %QX0.0 : BOOL;        // 电机运行
    bMotorDirection AT %QX0.1 : BOOL;   // 电机方向 (0=正转,1=反转)
    bBrake AT %QX0.2 : BOOL;            // 制动器
    bIndicator AT %QX1.0 : BOOL;        // 指示灯
    iMotorSpeed AT %QW0 : INT;         // 电机速度
    iCurrentPosition AT %QW1 : INT;    // 当前位置

    // ==========================================================================
    // 内部变量
    // ==========================================================================
    iState : INT := 0;                  // 状态机状态
    iSpeedProfile : ARRAY[1..5] OF INT := [100, 500, 1000, 1500, 2000];  // 速度曲线
    iCurrentStage : INT := 1;           // 当前加速阶段
    iTimer : INT := 0;                  // 定时器
    iCycleCount : INT := 0;             // 循环计数
    iErrorCode : INT := 0;              // 错误代码

    // 边沿检测
    bLastStart : BOOL := FALSE;
    bLastStop : BOOL := FALSE;
    bLastReset : BOOL := FALSE;

    // 数据记录
    aiSpeedHistory : ARRAY[1..100] OF INT;
    iHistoryIndex : INT := 1;
END_VAR

// ============================================================================
// 状态定义
// ============================================================================
// 0 = STOPPED    - 停止
// 1 = STARTING   - 启动中
// 2 = ACCEL      - 加速中
// 3 = RUNNING    - 运行中
// 4 = DECEL      - 减速中
// 5 = HOMING     - 回原中
// 9 = FAULT      - 故障

// ============================================================================
// 错误代码定义
// ============================================================================
// 0 = 无错误
// 1 = 急停触发
// 2 = 限位触发
// 3 = 过温
// 4 = 过流

// ============================================================================
// 主程序逻辑
// ============================================================================
BEGIN
    // ==========================================================================
    // 1. 边沿检测
    // ==========================================================================
    VAR
        bStartEdge : BOOL;
        bStopEdge : BOOL;
        bResetEdge : BOOL;
    END_VAR

    bStartEdge := bStartButton AND NOT bLastStart;
    bStopEdge := bStopButton AND NOT bLastStop;
    bResetEdge := bResetButton AND NOT bLastReset;

    bLastStart := bStartButton;
    bLastStop := bStopButton;
    bLastReset := bResetButton;

    // ==========================================================================
    // 2. 急停处理（最高优先级）
    // ==========================================================================

    IF bEmergencyStop THEN
        iState := 9;                    // 故障状态
        iErrorCode := 1;
        bMotorRun := FALSE;
        bBrake := TRUE;
        iMotorSpeed := 0;
        bIndicator := FALSE;
    END_IF

    // ==========================================================================
    // 3. 主状态机
    // ==========================================================================

    CASE iState OF
        // --------------------------------------------------------------------------
        // 状态0: 停止
        // --------------------------------------------------------------------------
        0:
            bMotorRun := FALSE;
            bBrake := TRUE;
            iMotorSpeed := 0;
            iCurrentStage := 1;

            IF bStartEdge THEN
                IF NOT bHomeSensor THEN
                    // 需要回原
                    iState := 5;
                ELSE
                    // 直接启动
                    iState := 1;
                END_IF
            END_IF

        // --------------------------------------------------------------------------
        // 状态1: 启动中
        // --------------------------------------------------------------------------
        1:
            bBrake := FALSE;
            bMotorRun := TRUE;
            iMotorSpeed := iSpeedProfile[1];
            iTimer := 0;
            iState := 2;  // 自动转入加速

        // --------------------------------------------------------------------------
        // 状态2: 加速中
        // --------------------------------------------------------------------------
        2:
            iTimer := iTimer + 1;

            IF iTimer >= 100 THEN  // 每100ms加速一次
                iTimer := 0;
                iCurrentStage := iCurrentStage + 1;

                IF iCurrentStage <= 5 THEN
                    iMotorSpeed := iSpeedProfile[iCurrentStage];
                ELSE
                    iState := 3;  // 达到目标速度
                END_IF
            END_IF

            // 检查限位
            IF bLimitSwitch THEN
                iState := 9;
                iErrorCode := 2;
            END_IF

        // --------------------------------------------------------------------------
        // 状态3: 运行中
        // --------------------------------------------------------------------------
        3:
            iMotorSpeed := iSpeedProfile[5];  // 全速运行

            // 位置控制
            IF iCurrentPosition < iTargetPosition THEN
                bMotorDirection := FALSE;  // 正转
            ELSIF iCurrentPosition > iTargetPosition THEN
                bMotorDirection := TRUE;   // 反转
            END_IF

            // 接近目标时减速
            IF ABS(iCurrentPosition - iTargetPosition) < 100 THEN
                iState := 4;
                iCurrentStage := 5;
                iTimer := 0;
            END_IF

            // 检查限位
            IF bLimitSwitch THEN
                iState := 9;
                iErrorCode := 2;
            END_IF

            // 停止命令
            IF bStopEdge THEN
                iState := 4;
                iCurrentStage := 5;
                iTimer := 0;
            END_IF

            // 指示灯闪烁
            bIndicator := (iCycleCount < 50);
            iCycleCount := iCycleCount + 1;
            IF iCycleCount >= 100 THEN
                iCycleCount := 0;
            END_IF

        // --------------------------------------------------------------------------
        // 状态4: 减速中
        // --------------------------------------------------------------------------
        4:
            iTimer := iTimer + 1;

            IF iTimer >= 100 THEN
                iTimer := 0;
                iCurrentStage := iCurrentStage - 1;

                IF iCurrentStage >= 1 THEN
                    iMotorSpeed := iSpeedProfile[iCurrentStage];
                END_IF

                IF iCurrentStage <= 1 THEN
                    iState := 0;  // 停止
                END_IF
            END_IF

        // --------------------------------------------------------------------------
        // 状态5: 回原中
        // --------------------------------------------------------------------------
        5:
            bMotorDirection := TRUE;  // 反转
            bMotorRun := TRUE;
            bBrake := FALSE;
            iMotorSpeed := iSpeedProfile[2];

            IF bHomeSensor THEN
                iCurrentPosition := 0;
                bMotorRun := FALSE;
                bBrake := TRUE;
                iState := 1;  // 回到启动流程
            END_IF

        // --------------------------------------------------------------------------
        // 状态9: 故障
        // --------------------------------------------------------------------------
        9:
            bMotorRun := FALSE;
            bBrake := TRUE;
            iMotorSpeed := 0;
            bIndicator := TRUE;  // 故障指示灯亮

            IF bResetEdge THEN
                iErrorCode := 0;
                iState := 0;
                bIndicator := FALSE;
            END_IF

    ELSE
        iState := 0;
    END_CASE

    // ==========================================================================
    // 4. 模拟位置变化（实际应用中由编码器反馈）
    // ==========================================================================

    IF bMotorRun THEN
        IF bMotorDirection THEN
            iCurrentPosition := iCurrentPosition - (iMotorSpeed / 100);
        ELSE
            iCurrentPosition := iCurrentPosition + (iMotorSpeed / 100);
        END_IF
    END_IF

    // ==========================================================================
    // 5. 速度历史记录
    // ==========================================================================

    iHistoryIndex := (iHistoryIndex MOD 100) + 1;
    aiSpeedHistory[iHistoryIndex] := iMotorSpeed;

    // ==========================================================================
    // 6. 错误代码显示（通过指示灯闪烁次数表示）
    // ==========================================================================

    IF iState = 9 THEN
        VAR iBlinkCount : INT := 0; END_VAR
        iBlinkCount := 0;
        // 闪烁iErrorCode次
    END_IF

END_PROGRAM
