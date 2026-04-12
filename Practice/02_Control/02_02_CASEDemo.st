(* ============================================================================
 * 文件: 02_02_CASEDemo.st
 * 章节: 第4章 - 条件控制语句
 * 描述: CASE语句完整演示
 * 学习目标: 掌握CASE选择语句的各种用法
 * ============================================================================ *)

PROGRAM CASEDemo
VAR
    // ==========================================================================
    // 状态机变量
    // ==========================================================================
    iState : INT := 0;
    sStateName : STRING(30);

    // ==========================================================================
    // 月份处理变量
    // ==========================================================================
    iMonth : INT := 3;
    iDays : INT;
    sMonthName : STRING(20);

    // ==========================================================================
    // 菜单选择变量
    // ==========================================================================
    iMenuSelection : INT := 2;
    bExecute : BOOL := TRUE;

    // ==========================================================================
    // 报警级别变量
    // ==========================================================================
    iAlarmLevel : INT := 2;
    sAlarmMessage : STRING(50);
    bAlarmActive : BOOL := TRUE;

    // ==========================================================================
    // 枚举定义（需要定义在TYPE区域，这里用INT模拟）
    // ==========================================================================
    // MachineState: 0=IDLE, 1=STARTING, 2=RUNNING, 3=STOPPING, 4=FAULT
    iMachineState : INT := 0;

    // ==========================================================================
    // 数值范围变量
    // ==========================================================================
    iScore : INT := 78;
    iGradeLevel : INT;

    // ==========================================================================
    // 命令处理变量
    // ==========================================================================
    iCommand : INT := 16#05;
    bSuccess : BOOL;

    // ==========================================================================
    // 临时变量
    // ==========================================================================
    i : INT;
END_VAR

// ============================================================================
// 主程序逻辑
// ============================================================================
BEGIN
    // ==========================================================================
    // 1. 简单CASE语句 - 状态名称显示
    // ==========================================================================

    iState := 2;  // 假设当前状态为2

    CASE iState OF
        0:  sStateName := '初始化';
        1:  sStateName := '就绪';
        2:  sStateName := '运行中';
        3:  sStateName := '暂停';
        4:  sStateName := '停止';
        5:  sStateName := '故障';
    ELSE
        sStateName := '未知状态';
    END_CASE

    // ==========================================================================
    // 2. CASE语句 - 月份天数判断
    // ==========================================================================

    iMonth := 2;  // 2月

    CASE iMonth OF
        1, 3, 5, 7, 8, 10, 12:   // 大月
            iDays := 31;
        4, 6, 9, 11:               // 小月
            iDays := 30;
        2:                          // 2月
            iDays := 28;           // 假设非闰年
    ELSE
        iDays := 0;
    END_CASE

    // ==========================================================================
    // 3. CASE语句 - 月份名称
    // ==========================================================================

    CASE iMonth OF
        1:  sMonthName := '一月';
        2:  sMonthName := '二月';
        3:  sMonthName := '三月';
        4:  sMonthName := '四月';
        5:  sMonthName := '五月';
        6:  sMonthName := '六月';
        7:  sMonthName := '七月';
        8:  sMonthName := '八月';
        9:  sMonthName := '九月';
        10: sMonthName := '十月';
        11: sMonthName := '十一月';
        12: sMonthName := '十二月';
    ELSE
        sMonthName := '无效月份';
    END_CASE

    // ==========================================================================
    // 4. CASE语句 - 报警级别处理
    // ==========================================================================

    CASE iAlarmLevel OF
        0:  // 信息
            sAlarmMessage := '系统信息';
        1:  // 警告
            sAlarmMessage := '系统警告';
            bAlarmActive := TRUE;
        2:  // 错误
            sAlarmMessage := '系统错误';
            bAlarmActive := TRUE;
        3:  // 严重
            sAlarmMessage := '严重故障！';
            bAlarmActive := TRUE;
    ELSE
        sAlarmMessage := '未知级别';
    END_CASE

    // ==========================================================================
    // 5. CASE语句 - 分数等级判定（范围）
    // ==========================================================================

    iScore := 85;

    CASE iScore OF
        90..100:  iGradeLevel := 1;   // 优秀
        80..89:   iGradeLevel := 2;   // 良好
        70..79:   iGradeLevel := 3;   // 中等
        60..69:   iGradeLevel := 4;   // 及格
        0..59:    iGradeLevel := 5;   // 不及格
    ELSE
        iGradeLevel := 0;
    END_CASE

    // ==========================================================================
    // 6. CASE语句 - 命令解析
    // ==========================================================================

    iCommand := 3;

    CASE iCommand OF
        1:  // 启动命令
            bMotorRunning := TRUE;
            bSuccess := TRUE;
        2:  // 停止命令
            bMotorRunning := FALSE;
            bSuccess := TRUE;
        3:  // 复位命令
            iAlarmLevel := 0;
            bSuccess := TRUE;
        4:  // 急停命令
            bMotorRunning := FALSE;
            iAlarmLevel := 3;
            bSuccess := TRUE;
    ELSE
        bSuccess := FALSE;
    END_CASE

    // ==========================================================================
    // 7. CASE语句 - 菜单选择处理
    // ==========================================================================

    IF bExecute THEN
        CASE iMenuSelection OF
            1:  // 文件操作
                sStateName := '执行文件操作';
            2:  // 编辑操作
                sStateName := '执行编辑操作';
            3:  // 视图操作
                sStateName := '执行视图操作';
            4:  // 帮助
                sStateName := '显示帮助信息';
        ELSE
            sStateName := '无效菜单选择';
        END_CASE
    END_IF

    // ==========================================================================
    // 8. CASE语句 - 机器状态机
    // ==========================================================================

    CASE iMachineState OF
        0:  (* IDLE - 空闲状态 *)
            bMotorRunning := FALSE;
            iMotorSpeed := 0;
            (* 等待启动命令 *)
            IF bStartButton THEN
                iMachineState := 1;  (* 转到启动状态 *)
            END_IF

        1:  (* STARTING - 启动中 *)
            iMotorSpeed := iMotorSpeed + 100;
            IF iMotorSpeed >= iTargetSpeed THEN
                iMotorSpeed := iTargetSpeed;
                iMachineState := 2;  (* 转到运行状态 *)
            END_IF

        2:  (* RUNNING - 运行中 *)
            bMotorRunning := TRUE;
            (* 检查停止或故障 *)
            IF bStopButton THEN
                iMachineState := 3;  (* 转到停止状态 *)
            ELSIF iTemperature > 100 THEN
                iMachineState := 4;  (* 转到故障状态 *)
            END_IF

        3:  (* STOPPING - 停止中 *)
            iMotorSpeed := iMotorSpeed - 100;
            IF iMotorSpeed <= 0 THEN
                iMotorSpeed := 0;
                bMotorRunning := FALSE;
                iMachineState := 0;  (* 返回空闲状态 *)
            END_IF

        4:  (* FAULT - 故障状态 *)
            bMotorRunning := FALSE;
            iMotorSpeed := 0;
            (* 等待复位 *)
            IF bEmergencyStop THEN
                iMachineState := 0;  (* 复位后返回空闲 *)
            END_IF
    ELSE
        iMachineState := 0;  (* 默认返回空闲 *)
    END_CASE

    // ==========================================================================
    // 9. CASE语句 - 位字段解析
    // ==========================================================================
    VAR
        wControl : WORD := 16#0005;
        bBit0, bBit1, bBit2, bBit3 : BOOL;
    END_VAR

    // 解析控制字
    bBit0 := (wControl AND 16#0001) <> 0;
    bBit1 := (wControl AND 16#0002) <> 0;
    bBit2 := (wControl AND 16#0004) <> 0;
    bBit3 := (wControl AND 16#0008) <> 0;

    // 根据位字段值执行不同操作
    CASE 0 OF
        0: IF bBit0 THEN sAlarmMessage := '启用功能A'; END_IF
        1: IF bBit1 THEN sAlarmMessage := '启用功能B'; END_IF
        2: IF bBit2 THEN sAlarmMessage := '启用功能C'; END_IF
        3: IF bBit3 THEN sAlarmMessage := '启用功能D'; END_IF
    END_CASE

END_PROGRAM
