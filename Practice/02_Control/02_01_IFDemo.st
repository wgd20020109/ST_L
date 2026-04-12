(* ============================================================================
 * 文件: 02_01_IFDemo.st
 * 章节: 第4章 - 条件控制语句
 * 描述: IF语句完整演示
 * 学习目标: 掌握IF条件语句的各种用法
 * ============================================================================ *)

PROGRAM IFDemo
VAR
    // ==========================================================================
    // 温度监控变量
    // ==========================================================================
    iTemperature : INT := 75;      // 当前温度
    iHighLimit : INT := 100;       // 高温限值
    iLowLimit : INT := 20;         // 低温限值
    iWarningLimit : INT := 80;     // 警告限值
    bHighAlarm : BOOL;             // 高温报警
    bLowAlarm : BOOL;              // 低温报警
    bWarning : BOOL;               // 警告状态

    // ==========================================================================
    // 电机控制变量
    // ==========================================================================
    iMotorSpeed : INT := 0;
    iTargetSpeed : INT := 1500;
    bMotorRunning : BOOL := FALSE;
    bStartButton : BOOL := TRUE;
    bStopButton : BOOL := FALSE;
    bEmergencyStop : BOOL := FALSE;

    // ==========================================================================
    // 数值判断变量
    // ==========================================================================
    iScore : INT := 85;
    sGrade : STRING(2);

    iValue1, iValue2 : INT := 10;
    iMax, iMin, iMid : INT;

    // ==========================================================================
    // 边沿检测变量
    // ==========================================================================
    bCurrentInput : BOOL := FALSE;
    bLastInput : BOOL := FALSE;
    bRisingEdge : BOOL;
    iEdgeCount : INT := 0;

    // ==========================================================================
    // 数值计算变量
    // ==========================================================================
    rNumber : REAL := -3.7;
    iIntegerPart : INT;
    rFractionalPart : REAL;

    iCounter : INT := 0;
END_VAR

// ============================================================================
// 主程序逻辑
// ============================================================================
BEGIN
    // ==========================================================================
    // 1. 简单IF语句
    // ==========================================================================

    // 如果温度超过100度，触发高温报警
    IF iTemperature > iHighLimit THEN
        bHighAlarm := TRUE;
    END_IF

    // ==========================================================================
    // 2. IF-ELSE双分支
    // ==========================================================================

    // 判断电机运行状态
    IF bMotorRunning THEN
        iMotorSpeed := iTargetSpeed;
    ELSE
        iMotorSpeed := 0;
    END_IF

    // ==========================================================================
    // 3. IF-ELSIF-ELSE多分支 - 温度状态判断
    // ==========================================================================

    // 重置报警状态
    bHighAlarm := FALSE;
    bLowAlarm := FALSE;
    bWarning := FALSE;

    IF iTemperature >= iHighLimit THEN
        bHighAlarm := TRUE;
        bWarning := TRUE;
    ELSIF iTemperature <= iLowLimit THEN
        bLowAlarm := TRUE;
        bWarning := TRUE;
    ELSIF iTemperature >= iWarningLimit THEN
        bWarning := TRUE;
    ELSE
        // 温度正常
        bHighAlarm := FALSE;
        bLowAlarm := FALSE;
        bWarning := FALSE;
    END_IF

    // ==========================================================================
    // 4. IF-ELSIF-ELSE多分支 - 分数等级判定
    // ==========================================================================

    IF iScore >= 90 THEN
        sGrade := 'A';
    ELSIF iScore >= 80 THEN
        sGrade := 'B';
    ELSIF iScore >= 70 THEN
        sGrade := 'C';
    ELSIF iScore >= 60 THEN
        sGrade := 'D';
    ELSE
        sGrade := 'F';
    END_IF

    // ==========================================================================
    // 5. 嵌套IF语句 - 三角形类型判断
    // ==========================================================================
    VAR
        a, b, c : INT := 3;
        sTriangleType : STRING(20);
    END_VAR

    IF a + b > c AND b + c > a AND a + c > b THEN
        IF a = b AND b = c THEN
            sTriangleType := '等边三角形';
        ELSIF a = b OR b = c OR a = c THEN
            sTriangleType := '等腰三角形';
        ELSIF (a * a + b * b = c * c) OR (a * a + c * c = b * b) OR (b * b + c * c = a * a) THEN
            sTriangleType := '直角三角形';
        ELSE
            sTriangleType := '普通三角形';
        END_IF
    ELSE
        sTriangleType := '不能构成三角形';
    END_IF

    // ==========================================================================
    // 6. 求三个数的最大、最小、中间值
    // ==========================================================================

    iValue1 := 30;
    iValue2 := 50;

    VAR iValue3 : INT := 40; END_VAR

    IF iValue1 >= iValue2 THEN
        IF iValue1 >= iValue3 THEN
            iMax := iValue1;
            IF iValue2 >= iValue3 THEN
                iMid := iValue2;
                iMin := iValue3;
            ELSE
                iMid := iValue3;
                iMin := iValue2;
            END_IF
        ELSE
            iMax := iValue3;
            iMid := iValue1;
            iMin := iValue2;
        END_IF
    ELSE
        IF iValue2 >= iValue3 THEN
            iMax := iValue2;
            IF iValue1 >= iValue3 THEN
                iMid := iValue1;
                iMin := iValue3;
            ELSE
                iMid := iValue3;
                iMin := iValue1;
            END_IF
        ELSE
            iMax := iValue3;
            iMid := iValue2;
            iMin := iValue1;
        END_IF
    END_IF

    // ==========================================================================
    // 7. 边沿检测 - 上升沿识别
    // ==========================================================================

    bRisingEdge := bCurrentInput AND NOT bLastInput;

    IF bRisingEdge THEN
        iEdgeCount := iEdgeCount + 1;
    END_IF

    bLastInput := bCurrentInput;

    // ==========================================================================
    // 8. 浮点数处理 - 分离整数和小数部分
    // ==========================================================================

    rNumber := -3.14159;

    IF rNumber < 0.0 THEN
        iIntegerPart := REAL_TO_INT(rNumber) - 1;
    ELSE
        iIntegerPart := REAL_TO_INT(rNumber);
    END_IF

    rFractionalPart := rNumber - INT_TO_REAL(iIntegerPart);

    // ==========================================================================
    // 9. 电机启停控制（综合示例）
    // ==========================================================================

    // 急停优先级最高
    IF bEmergencyStop THEN
        bMotorRunning := FALSE;
        iMotorSpeed := 0;
    ELSIF bStopButton THEN
        bMotorRunning := FALSE;
        iMotorSpeed := 0;
    ELSIF bStartButton THEN
        bMotorRunning := TRUE;
        iMotorSpeed := iTargetSpeed;
    END_IF

    // ==========================================================================
    // 10. 计数器限幅
    // ==========================================================================

    iCounter := iCounter + 1;

    IF iCounter > 1000 THEN
        iCounter := 0;
    END_IF

END_PROGRAM
