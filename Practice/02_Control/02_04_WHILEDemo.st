(* ============================================================================
 * 文件: 02_04_WHILEDemo.st
 * 章节: 第5章 - 循环控制语句
 * 描述: WHILE和REPEAT循环演示
 * 学习目标: 掌握条件循环的用法
 * ============================================================================ *)

PROGRAM WHILEDemo
VAR
    // ==========================================================================
    // WHILE循环变量
    // ==========================================================================
    iCounter : INT;
    iSum : INT;
    iTarget : INT := 100;
    bRunning : BOOL := TRUE;

    // ==========================================================================
    // 链表模拟变量
    // ==========================================================================
TYPE
    Node : STRUCT
        value : INT;
        next : INT;  (* 下一个节点索引，0表示无 *)
    END_STRUCT
END_TYPE

VAR
    atNodes : ARRAY[1..10] OF Node;
    iCurrent : INT;
    iListSum : INT;
    iNodeCount : INT;

    // ==========================================================================
    // 查找变量
    // ==========================================================================
    aiSortedData : ARRAY[1..20] OF INT := [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39];
    iSearchTarget : INT := 21;
    iLow, iHigh, iMid : INT;
    iSearchResult : INT := 0;  (* 0表示未找到 *)
    bSearchFound : BOOL := FALSE;

    // ==========================================================================
    // REPEAT循环变量
    // ==========================================================================
    iX : INT;
    iRepeatSum : INT;

    // ==========================================================================
    // 数据处理变量
    // ==========================================================================
    iValue : INT := 1;
    aiProcessedData : ARRAY[1..100] OF INT;
    iProcessedCount : INT := 0;
    iProcessLimit : INT := 50;

    // ==========================================================================
    // 模拟传感器变量
    // ==========================================================================
    iSensorReading : INT := 0;
    iStableReading : INT := 0;
    iStabilityCount : INT := 0;
    iLastReading : INT;
    bStable : BOOL := FALSE;

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
    // 1. 简单WHILE循环 - 计算1+2+3+...+n直到和超过目标
    // ==========================================================================

    iCounter := 0;
    iSum := 0;

    WHILE iSum < iTarget DO
        iCounter := iCounter + 1;
        iSum := iSum + iCounter;
    END_WHILE
    // iSum >= 100, iCounter = 14 (1+2+...+14 = 105)

    // ==========================================================================
    // 2. WHILE循环 - 计算阶乘直到结果溢出
    // ==========================================================================

    iValue := 1;
    iCounter := 1;

    WHILE iValue < 1000000 AND iCounter <= 20 DO
        iCounter := iCounter + 1;
        iValue := iValue * iCounter;
    END_WHILE
    // iValue会接近但不超过1,000,000

    // ==========================================================================
    // 3. WHILE循环 - 遍历链表
    // ==========================================================================

    (* 初始化链表: 10 -> 20 -> 30 -> 0 *)
    atNodes[1].value := 10; atNodes[1].next := 2;
    atNodes[2].value := 20; atNodes[2].next := 3;
    atNodes[3].value := 30; atNodes[3].next := 0;

    iCurrent := 1;
    iListSum := 0;
    iNodeCount := 0;

    WHILE iCurrent <> 0 DO
        iListSum := iListSum + atNodes[iCurrent].value;
        iNodeCount := iNodeCount + 1;
        iCurrent := atNodes[iCurrent].next;
    END_WHILE
    // iListSum = 60, iNodeCount = 3

    // ==========================================================================
    // 4. 二分查找（使用WHILE循环）
    // ==========================================================================

    iLow := 1;
    iHigh := 20;
    bSearchFound := FALSE;

    WHILE iLow <= iHigh AND NOT bSearchFound DO
        iMid := (iLow + iHigh) / 2;

        IF aiSortedData[iMid] = iSearchTarget THEN
            bSearchFound := TRUE;
            iSearchResult := iMid;
        ELSIF aiSortedData[iMid] < iSearchTarget THEN
            iLow := iMid + 1;
        ELSE
            iHigh := iMid - 1;
        END_IF
    END_WHILE
    // iSearchResult = 11 (值21在第11个位置)

    // ==========================================================================
    // 5. REPEAT循环 - 至少执行一次
    // ==========================================================================

    iX := 100;
    iRepeatSum := 0;

    REPEAT
        iRepeatSum := iRepeatSum + iX;
        iX := iX - 1;
    UNTIL iX < 95
    END_REPEAT
    // iRepeatSum = 100+99+98+97+96 = 490

    // ==========================================================================
    // 6. WHILE vs REPEAT对比
    // ==========================================================================

    VAR
        iWhileTest, iRepeatTest : INT;
    END_VAR

    (* WHILE: 条件初始为FALSE，循环不执行 *)
    iWhileTest := 10;
    WHILE iWhileTest < 5 DO
        iWhileTest := iWhileTest + 1;
    END_WHILE
    // iWhileTest = 10 (未进入循环)

    (* REPEAT: 至少执行一次 *)
    iRepeatTest := 10;
    REPEAT
        iRepeatTest := iRepeatTest + 1;
    UNTIL iRepeatTest >= 5
    END_REPEAT
    // iRepeatTest = 11 (执行了一次)

    // ==========================================================================
    // 7. 数据处理循环
    // ==========================================================================

    iValue := 1;
    iProcessedCount := 0;

    WHILE iProcessedCount < iProcessLimit AND iValue <= 1000 DO
        iProcessedCount := iProcessedCount + 1;
        aiProcessedData[iProcessedCount] := iValue;
        iValue := iValue * 2;  (* 每次翻倍 *)
    END_WHILE
    // 处理了直到2^5 = 32的所有值

    // ==========================================================================
    // 8. 传感器稳定性检测
    // ==========================================================================

    iStabilityCount := 0;
    iLastReading := iSensorReading;

    WHILE iStabilityCount < 5 AND NOT bStable DO
        iSensorReading := iSensorReading + 1;  (* 模拟读取 *)
        (* 实际应用中这里应该是真实的传感器读取 *)

        IF ABS(iSensorReading - iLastReading) <= 2 THEN
            iStabilityCount := iStabilityCount + 1;
        ELSE
            iStabilityCount := 0;
        END_IF

        iLastReading := iSensorReading;

        IF iStabilityCount >= 5 THEN
            bStable := TRUE;
            iStableReading := iSensorReading;
        END_IF
    END_WHILE

    // ==========================================================================
    // 9. 最大公约数（欧几里得算法）
    // ==========================================================================

    VAR
        iGCD_A, iGCD_B, iTemp : INT;
    END_VAR

    iGCD_A := 48;
    iGCD_B := 18;

    WHILE iGCD_B <> 0 DO
        iTemp := iGCD_B;
        iGCD_B := iGCD_A MOD iGCD_B;
        iGCD_A := iTemp;
    END_WHILE
    // iGCD_A = 6 (48和18的最大公约数)

    // ==========================================================================
    // 10. 嵌套循环 - 质数判断
    // ==========================================================================

    VAR
        iPrimeTest : INT := 97;
        iDivisor : INT;
        bIsPrime : BOOL := TRUE;
    END_VAR

    iDivisor := 2;

    WHILE iDivisor * iDivisor <= iPrimeTest AND bIsPrime DO
        IF iPrimeTest MOD iDivisor = 0 THEN
            bIsPrime := FALSE;
        END_IF
        iDivisor := iDivisor + 1;
    END_WHILE
    // bIsPrime = TRUE (97是质数)

    // ==========================================================================
    // 11. 生成斐波那契数列直到超过阈值
    // ==========================================================================

    VAR
        aiFib : ARRAY[1..30] OF DINT;
        iFibCount : INT := 2;
    END_VAR

    aiFib[1] := 1;
    aiFib[2] := 1;

    WHILE aiFib[iFibCount] < 1000 DO
        iFibCount := iFibCount + 1;
        aiFib[iFibCount] := aiFib[iFibCount-1] + aiFib[iFibCount-2];
    END_WHILE
    // iFibCount = 16, aiFib[16] = 987 (< 1000)
    // 下一个是1597 (> 1000)

END_PROGRAM
