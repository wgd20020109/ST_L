(* ============================================================================
 * 文件: 06_01_EnumDemo.st
 * 章节: 第9章 - 枚举与自定义类型
 * 描述: 枚举类型演示
 * 学习目标: 掌握枚举类型的定义和使用
 * ============================================================================ *)

(* ============================================================================
 * 类型定义区域
 * ============================================================================ *)
TYPE
    // --------------------------------------------------------------------------
    // 基础枚举
    // --------------------------------------------------------------------------

    // 机器状态
    MachineState : (
        STATE_OFF,         // 0
        STATE_STANDBY,     // 1
        STATE_READY,       // 2
        STATE_RUNNING,     // 3
        STATE_PAUSED,      // 4
        STATE_FAULT        // 5
    );

    // 优先级
    Priority : (
        PRIO_LOW := 1,     // 1
        PRIO_NORMAL := 5,  // 5
        PRIO_HIGH := 10,    // 10
        PRIO_URGENT := 20   // 20
    );

    // 方向
    Direction : (
        DIR_NONE,
        DIR_FORWARD,
        DIR_REVERSE
    );

    // 阀门状态
    ValveState : (
        VALVE_CLOSED,
        VALVE_OPENING,
        VALVE_OPEN,
        VALVE_CLOSING,
        VALVE_FAULT
    );

    // --------------------------------------------------------------------------
    // 报警相关枚举
    // --------------------------------------------------------------------------

    AlarmLevel : (
        ALARM_INFO := 0,
        ALARM_WARNING := 1,
        ALARM_ERROR := 2,
        ALARM_CRITICAL := 3
    );

    // --------------------------------------------------------------------------
    // 运动控制枚举
    // --------------------------------------------------------------------------

    AxisState : (
        AXIS_DISABLED,
        AXIS_HOMING,
        AXIS_STANDSTILL,
        AXIS_ACCELERATING,
        AXIS_RUNNING,
        AXIS_DECELERATING,
        AXIS_ERROR
    );

    MotionMode : (
        MODE_POSITION,
        MODE_VELOCITY,
        MODE_TORQUE
    );

    // --------------------------------------------------------------------------
    // 通信相关枚举
    // --------------------------------------------------------------------------

    CommStatus : (
        COMM_IDLE,
        COMM_CONNECTING,
        COMM_CONNECTED,
        COMM_TRANSMITTING,
        COMM_RECEIVING,
        COMM_ERROR
    );

    Protocol : (
        PROT_MODBUS,
        PROT_CANOPEN,
        PROT_ETHERNET,
        PROT_PROFINET
    );

    // --------------------------------------------------------------------------
    // 子范围类型
    // --------------------------------------------------------------------------

    Percentage : INT (0..100);
    Month : USINT (1..12);
    DayOfMonth : USINT (1..31);
    HourOfDay : USINT (0..23);

    // --------------------------------------------------------------------------
    // 复合类型
    // --------------------------------------------------------------------------

    // 设备类型
    DeviceType : (
        DEV_MOTOR,
        DEV_VALVE,
        DEV_SENSOR,
        DEV_PUMP
    );
END_TYPE

(* ============================================================================
 * 功能块: 使用枚举的状态机
 * ============================================================================ *)
FUNCTION_BLOCK StateMachineFB
VAR_INPUT
    start : BOOL;
    stop : BOOL;
    fault : BOOL;
    reset : BOOL;
END_VAR

VAR_OUTPUT
    state : MachineState;
    running : BOOL;
END_VAR

VAR
    internalState : MachineState := STATE_OFF;
END_VAR

BEGIN
    // 状态转换逻辑
    CASE internalState OF
        STATE_OFF:
            running := FALSE;
            IF start THEN
                internalState := STATE_READY;
            END_IF

        STATE_STANDBY:
            running := FALSE;
            IF stop THEN
                internalState := STATE_OFF;
            ELSIF start THEN
                internalState := STATE_RUNNING;
            END_IF

        STATE_READY:
            running := FALSE;
            IF stop THEN
                internalState := STATE_OFF;
            ELSIF start THEN
                internalState := STATE_RUNNING;
            END_IF

        STATE_RUNNING:
            running := TRUE;
            IF stop THEN
                internalState := STATE_PAUSED;
            ELSIF fault THEN
                internalState := STATE_FAULT;
            END_IF

        STATE_PAUSED:
            running := FALSE;
            IF fault THEN
                internalState := STATE_FAULT;
            ELSIF reset THEN
                internalState := STATE_READY;
            END_IF

        STATE_FAULT:
            running := FALSE;
            IF reset THEN
                internalState := STATE_OFF;
            END_IF
    END_CASE;

    state := internalState;
END_FUNCTION_BLOCK

(* ============================================================================
 * 功能块: 阀门控制（使用枚举）
 * ============================================================================ *)
FUNCTION_BLOCK ValveControlFB
VAR_INPUT
    open : BOOL;
    close : BOOL;
    autoMode : BOOL := TRUE;
END_VAR

VAR_OUTPUT
    state : ValveState;
    position : Percentage;
END_VAR

VAR
    timer : TON;
    internalState : ValveState := VALVE_CLOSED;
END_VAR

BEGIN
    CASE internalState OF
        VALVE_CLOSED:
            position := 0;
            IF open THEN
                internalState := VALVE_OPENING;
            END_IF

        VALVE_OPENING:
            timer(IN := TRUE, PT := T#3s);
            position := Percentage(100 * TIME_TO_MS(timer.ET) / 3000);
            IF timer.Q THEN
                timer(IN := FALSE);
                position := 100;
                internalState := VALVE_OPEN;
            END_IF
            IF close THEN
                timer(IN := FALSE);
                internalState := VALVE_CLOSING;
            END_IF

        VALVE_OPEN:
            position := 100;
            IF close THEN
                internalState := VALVE_CLOSING;
            END_IF

        VALVE_CLOSING:
            timer(IN := TRUE, PT := T#3s);
            position := Percentage(100 - 100 * TIME_TO_MS(timer.ET) / 3000);
            IF timer.Q THEN
                timer(IN := FALSE);
                position := 0;
                internalState := VALVE_CLOSED;
            END_IF
            IF open THEN
                timer(IN := FALSE);
                internalState := VALVE_OPENING;
            END_IF

        VALVE_FAULT:
            position := 0;
    END_CASE;

    state := internalState;
END_FUNCTION_BLOCK

(* ============================================================================
 * 程序: EnumDemo
 * 功能: 枚举类型演示
 * ============================================================================ *)
PROGRAM EnumDemo
VAR
    // ==========================================================================
    // 枚举变量
    // ==========================================================================
    eCurrentState : MachineState;
    ePriority : Priority;
    eDirection : Direction;
    eValveState : ValveState;
    eAxisState : AxisState;
    eAlarmLevel : AlarmLevel;

    // ==========================================================================
    // 功能块实例
    // ==========================================================================
    machine1 : StateMachineFB;
    valve1 : ValveControlFB;

    // ==========================================================================
    // 模拟输入
    // ==========================================================================
    bStart : BOOL := TRUE;
    bStop : BOOL := FALSE;
    bFault : BOOL := FALSE;
    bReset : BOOL := FALSE;

    // ==========================================================================
    // 状态输出
    // ==========================================================================
    bRunning : BOOL;
    iPosition : INT;

    // ==========================================================================
    // 临时变量
    // ==========================================================================
    i : INT;
    sStatus : STRING(30);
END_VAR

// ============================================================================
// 主程序逻辑
// ============================================================================
BEGIN
    // ==========================================================================
    // 1. 基本枚举赋值
    // ==========================================================================

    eCurrentState := STATE_OFF;
    ePriority := PRIO_NORMAL;
    eDirection := DIR_FORWARD;
    eAlarmLevel := ALARM_INFO;

    // ==========================================================================
    // 2. 枚举比较
    // ==========================================================================

    IF eCurrentState = STATE_RUNNING THEN
        bRunning := TRUE;
    ELSE
        bRunning := FALSE;
    END_IF

    // ==========================================================================
    // 3. 枚举用于CASE语句
    // ==========================================================================

    CASE eCurrentState OF
        STATE_OFF:
            sStatus := 'Machine is OFF';
        STATE_STANDBY:
            sStatus := 'Machine in STANDBY';
        STATE_READY:
            sStatus := 'Machine is READY';
        STATE_RUNNING:
            sStatus := 'Machine is RUNNING';
        STATE_PAUSED:
            sStatus := 'Machine is PAUSED';
        STATE_FAULT:
            sStatus := 'Machine in FAULT';
    END_CASE

    // ==========================================================================
    // 4. 枚举转换（某些平台支持）
    // ==========================================================================

    // 枚举转整数
    i := INT#(ePriority);  // PRIO_NORMAL = 5

    // 整数转枚举（需要类型转换函数，部分平台支持）
    // ePriority := TO_ENUM(Priority, 10);

    // ==========================================================================
    // 5. 枚举数组
    // ==========================================================================
    VAR aStates : ARRAY[1..5] OF MachineState; END_VAR

    aStates[1] := STATE_OFF;
    aStates[2] := STATE_READY;
    aStates[3] := STATE_RUNNING;
    aStates[4] := STATE_PAUSED;
    aStates[5] := STATE_FAULT;

    // 遍历状态数组
    FOR i := 1 TO 5 DO
        // 处理每个状态
    END_FOR

    // ==========================================================================
    // 6. 枚举在结构体中
    // ==========================================================================
    TYPE
        DeviceInfo : STRUCT
            deviceType : DeviceType;
            deviceState : MachineState;
            priority : Priority;
        END_STRUCT
    END_TYPE

    VAR device : DeviceInfo; END_VAR

    device.deviceType := DEV_MOTOR;
    device.deviceState := STATE_RUNNING;
    device.priority := PRIO_HIGH;

    // ==========================================================================
    // 7. 优先级比较
    // ==========================================================================

    IF ePriority >= PRIO_HIGH THEN
        // 高优先级处理
    END_IF

    // ==========================================================================
    // 8. 方向枚举使用
    // ==========================================================================

    eDirection := DIR_FORWARD;

    CASE eDirection OF
        DIR_NONE:
            // 不移动
        DIR_FORWARD:
            // 正转
        DIR_REVERSE:
            // 反转
    END_CASE

    // ==========================================================================
    // 9. 报警级别判断
    // ==========================================================================

    CASE eAlarmLevel OF
        ALARM_INFO:
            // 记录信息日志
        ALARM_WARNING:
            // 发送警告
        ALARM_ERROR:
            // 发送错误
        ALARM_CRITICAL:
            // 触发紧急停机
    END_CASE

    // ==========================================================================
    // 10. 使用功能块
    // ==========================================================================

    machine1(
        start := bStart,
        stop := bStop,
        fault := bFault,
        reset := bReset
    );

    eCurrentState := machine1.state;
    bRunning := machine1.running;

    valve1(
        open := bStart,
        close := bStop,
        autoMode := TRUE
    );

    eValveState := valve1.state;
    iPosition := valve1.position;

    // ==========================================================================
    // 11. 子范围类型使用
    // ==========================================================================

    VAR percentage : Percentage; END_VAR
    VAR month : Month; END_VAR

    percentage := 75;        // 合法
    // percentage := 150;    // 非法，会被截断或报错

    month := 6;              // 六月

    // ==========================================================================
    // 12. 枚举循环（有限状态机）
    // ==========================================================================

    // 循环遍历所有状态
    FOR i := INT#(STATE_OFF) TO INT#(STATE_FAULT) DO
        eCurrentState := TO_ENUM(MachineState, i);
        // 处理每个状态
    END_FOR

END_PROGRAM
