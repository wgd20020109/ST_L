(* ============================================================================
 * 文件: 05_01_ArrayDemo.st
 * 章节: 第8章 - 数组与结构
 * 描述: 数组操作演示
 * 学习目标: 掌握数组的声明和使用
 * ============================================================================ *)

PROGRAM ArrayDemo
VAR
    // ==========================================================================
    // 一维数组
    // ==========================================================================
    aiTemperatures : ARRAY[1..24] OF INT;  // 24小时温度
    aiWeekTemps : ARRAY[0..6] OF INT := [20, 22, 25, 24, 23, 26, 21];
    abFlags : ARRAY[0..15] OF BOOL;
    arValues : ARRAY[1..10] OF REAL := [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];

    // ==========================================================================
    // 多维数组
    // ==========================================================================
    amMatrix : ARRAY[1..3, 1..3] OF INT;
    amData : ARRAY[0..2, 0..3] OF REAL;  // 3x4矩阵
    avolume : ARRAY[1..2, 1..3, 1..4] OF INT;  // 3D数组

    // ==========================================================================
    // 字符串数组
    // ==========================================================================
    asDayNames : ARRAY[0..6] OF STRING(10) :=
        ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    asMonthNames : ARRAY[1..12] OF STRING(15) :=
        ['January', 'February', 'March', 'April', 'May', 'June',
         'July', 'August', 'September', 'October', 'November', 'December'];

    // ==========================================================================
    // 临时变量
    // ==========================================================================
    i, j, k : INT;
    iSum : DINT;
    iMax, iMin, iMaxIndex, iMinIndex : INT;
    rAverage : REAL;
    bFound : BOOL;
END_VAR

// ============================================================================
// 主程序逻辑
// ============================================================================
BEGIN
    // ==========================================================================
    // 1. 数组初始化
    // ==========================================================================

    // 初始化24小时温度数据
    FOR i := 1 TO 24 DO
        // 模拟温度曲线: 凌晨低, 下午高
        IF i <= 6 THEN
            aiTemperatures[i] := 15 + i;
        ELSIF i <= 12 THEN
            aiTemperatures[i] := 22 + (i - 6);
        ELSIF i <= 18 THEN
            aiTemperatures[i] := 30 - (i - 12) / 2;
        ELSE
            aiTemperatures[i] := 25 - (i - 18);
        END_IF
    END_FOR

    // ==========================================================================
    // 2. 数组求和
    // ==========================================================================

    iSum := 0;
    FOR i := 1 TO 24 DO
        iSum := iSum + aiTemperatures[i];
    END_FOR
    // iSum = 所有温度之和

    // ==========================================================================
    // 3. 查找最大值和最小值
    // ==========================================================================

    iMax := aiTemperatures[1];
    iMin := aiTemperatures[1];
    iMaxIndex := 1;
    iMinIndex := 1;

    FOR i := 2 TO 24 DO
        IF aiTemperatures[i] > iMax THEN
            iMax := aiTemperatures[i];
            iMaxIndex := i;
        END_IF
        IF aiTemperatures[i] < iMin THEN
            iMin := aiTemperatures[i];
            iMinIndex := i;
        END_IF
    END_FOR

    // ==========================================================================
    // 4. 计算平均值
    // ==========================================================================

    iSum := 0;
    FOR i := 1 TO 7 DO
        iSum := iSum + aiWeekTemps[i];
    END_FOR;
    rAverage := DINT_TO_REAL(iSum) / 7.0;

    // ==========================================================================
    // 5. 数组搜索
    // ==========================================================================

    bFound := FALSE;
    FOR i := 1 TO 7 DO
        IF aiWeekTemps[i] = 25 THEN
            bFound := TRUE;
            EXIT;
        END_IF
    END_FOR

    // ==========================================================================
    // 6. 数组反转
    // ==========================================================================
    VAR aiTempArray : ARRAY[1..10] OF INT := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; END_VAR
    VAR aiReversed : ARRAY[1..10] OF INT; END_VAR

    FOR i := 1 TO 10 DO
        aiReversed[i] := aiTempArray[11 - i];
    END_FOR
    // aiReversed = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

    // ==========================================================================
    // 7. 数组复制
    // ==========================================================================
    VAR aiSource : ARRAY[1..5] OF INT := [10, 20, 30, 40, 50]; END_VAR
    VAR aiDest : ARRAY[1..5] OF INT; END_VAR

    FOR i := 1 TO 5 DO
        aiDest[i] := aiSource[i];
    END_FOR

    // ==========================================================================
    // 8. 二维数组操作 - 矩阵初始化
    // ==========================================================================

    FOR i := 1 TO 3 DO
        FOR j := 1 TO 3 DO
            amMatrix[i, j] := i * 10 + j;
        END_FOR
    END_FOR
    // amMatrix = [[11, 12, 13], [21, 22, 23], [31, 32, 33]]

    // ==========================================================================
    // 9. 二维数组 - 计算矩阵元素和
    // ==========================================================================

    iSum := 0;
    FOR i := 1 TO 3 DO
        FOR j := 1 TO 3 DO
            iSum := iSum + amMatrix[i, j];
        END_FOR
    END_FOR
    // iSum = 198

    // ==========================================================================
    // 10. 三维数组初始化
    // ==========================================================================

    FOR i := 1 TO 2 DO
        FOR j := 1 TO 3 DO
            FOR k := 1 TO 4 DO
                avolume[i, j, k] := i * 100 + j * 10 + k;
            END_FOR
        END_FOR
    END_FOR
    // avolume[1,2,3] = 123, avolume[2,3,4] = 234

    // ==========================================================================
    // 11. 二维数组转置
    // ==========================================================================
    VAR amTranspose : ARRAY[1..3, 1..3] OF INT; END_VAR

    FOR i := 1 TO 3 DO
        FOR j := 1 TO 3 DO
            amTranspose[j, i] := amMatrix[i, j];
        END_FOR
    END_FOR

    // ==========================================================================
    // 12. 数组排序 - 选择排序
    // ==========================================================================
    VAR aiSortArray : ARRAY[1..10] OF INT := [64, 25, 12, 22, 11, 90, 45, 33, 55, 77]; END_VAR
    VAR iMinIdx, iTemp : INT; END_VAR

    FOR i := 1 TO 9 DO
        iMinIdx := i;
        FOR j := i + 1 TO 10 DO
            IF aiSortArray[j] < aiSortArray[iMinIdx] THEN
                iMinIdx := j;
            END_IF
        END_FOR;
        // 交换
        iTemp := aiSortArray[i];
        aiSortArray[i] := aiSortArray[iMinIdx];
        aiSortArray[iMinIdx] := iTemp;
    END_FOR
    // aiSortArray = [11, 12, 22, 25, 33, 45, 55, 64, 77, 90]

    // ==========================================================================
    // 13. 二分查找（前提：数组已排序）
    // ==========================================================================
    VAR aiSearchArray : ARRAY[1..20] OF INT; END_VAR
    VAR aiSearch : ARRAY[1..20] OF INT := [1, 3, 5, 7, 9, 11, 13, 15, 17, 19,
                                             21, 23, 25, 27, 29, 31, 33, 35, 37, 39]; END_VAR
    VAR iTarget, iLow, iHigh, iMid, iSearchResult : INT; END_VAR
    VAR bSearchFound : BOOL; END_VAR

    iTarget := 21;
    iLow := 1;
    iHigh := 20;
    bSearchFound := FALSE;
    iSearchResult := 0;

    WHILE (iLow <= iHigh) AND NOT bSearchFound DO
        iMid := (iLow + iHigh) / 2;
        IF aiSearch[iMid] = iTarget THEN
            bSearchFound := TRUE;
            iSearchResult := iMid;
        ELSIF aiSearch[iMid] < iTarget THEN
            iLow := iMid + 1;
        ELSE
            iHigh := iMid - 1;
        END_IF
    END_WHILE
    // iSearchResult = 11 (21在第11个位置)

    // ==========================================================================
    // 14. 数组元素计数
    // ==========================================================================
    VAR aiCount : ARRAY[1..10] OF INT := [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]; END_VAR
    VAR aiFrequency : ARRAY[1..3] OF INT; END_VAR

    FOR i := 1 TO 10 DO
        IF aiCount[i] >= 1 AND aiCount[i] <= 3 THEN
            aiFrequency[aiCount[i]] := aiFrequency[aiCount[i]] + 1;
        END_IF
    END_FOR
    // aiFrequency = [0, 4, 3, 3] (1出现4次, 2出现3次, 3出现3次)

END_PROGRAM
