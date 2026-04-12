(* ============================================================================
 * 文件: 03_02_MathFunctions.st
 * 章节: 第6章 - 函数
 * 描述: 数学函数库
 * 学习目标: 掌握数学函数的编写
 * ============================================================================ *)

(* ============================================================================
 * 函数: Factorial
 * 功能: 计算阶乘
 * ============================================================================ *)
FUNCTION Factorial : DINT
VAR_INPUT
    n : INT;
END_VAR
VAR
    i : INT;
    result : DINT;
END_VAR

BEGIN
    IF n < 0 THEN
        Factorial := 0;
        RETURN;
    END_IF;

    IF n <= 1 THEN
        Factorial := 1;
        RETURN;
    END_IF;

    result := 1;
    FOR i := 2 TO n DO
        result := result * INT_TO_DINT(i);
    END_FOR;

    Factorial := result;
END_FUNCTION

(* ============================================================================
 * 函数: Power
 * 功能: 计算指数
 * ============================================================================ *)
FUNCTION Power : DINT
VAR_INPUT
    base : INT;
    exponent : INT;
END_VAR
VAR
    i : INT;
    result : DINT;
END_VAR

BEGIN
    IF exponent < 0 THEN
        Power := 0;
        RETURN;
    END_IF;

    IF exponent = 0 THEN
        Power := 1;
        RETURN;
    END_IF;

    result := 1;
    FOR i := 1 TO exponent DO
        result := result * INT_TO_DINT(base);
    END_FOR;

    Power := result;
END_FUNCTION

(* ============================================================================
 * 函数: Fibonacci
 * 功能: 计算斐波那契数列第n项
 * ============================================================================ *)
FUNCTION Fibonacci : DINT
VAR_INPUT
    n : INT;
END_VAR
VAR
    i : INT;
    a, b, c : DINT;
END_VAR

BEGIN
    IF n <= 0 THEN
        Fibonacci := 0;
        RETURN;
    END_IF;

    IF n = 1 THEN
        Fibonacci := 1;
        RETURN;
    END_IF;

    a := 0;
    b := 1;

    FOR i := 2 TO n DO
        c := a + b;
        a := b;
        b := c;
    END_FOR;

    Fibonacci := b;
END_FUNCTION

(* ============================================================================
 * 函数: GCD - 最大公约数（欧几里得算法）
 * ============================================================================ *)
FUNCTION GCD : DINT
VAR_INPUT
    a : DINT;
    b : DINT;
END_VAR
VAR
    temp : DINT;
END_VAR

BEGIN
    IF a <= 0 OR b <= 0 THEN
        GCD := 0;
        RETURN;
    END_IF;

    WHILE b <> 0 DO
        temp := b;
        b := a MOD b;
        a := temp;
    END_WHILE;

    GCD := a;
END_FUNCTION

(* ============================================================================
 * 函数: LCM - 最小公倍数
 * ============================================================================ *)
FUNCTION LCM : DINT
VAR_INPUT
    a : DINT;
    b : DINT;
END_VAR
VAR
    gcdVal : DINT;
END_VAR

BEGIN
    gcdVal := GCD(a, b);
    IF gcdVal > 0 THEN
        LCM := (a * b) / gcdVal;
    ELSE
        LCM := 0;
    END_IF
END_FUNCTION

(* ============================================================================
 * 函数: IsPrime
 * 功能: 判断素数
 * ============================================================================ *)
FUNCTION IsPrime : BOOL
VAR_INPUT
    n : INT;
END_VAR
VAR
    i : INT;
END_VAR

BEGIN
    IF n <= 1 THEN
        IsPrime := FALSE;
        RETURN;
    END_IF;

    IF n <= 3 THEN
        IsPrime := TRUE;
        RETURN;
    END_IF;

    IF (n MOD 2) = 0 OR (n MOD 3) = 0 THEN
        IsPrime := FALSE;
        RETURN;
    END_IF;

    i := 5;
    WHILE i * i <= n DO
        IF (n MOD i) = 0 OR (n MOD (i + 2)) = 0 THEN
            IsPrime := FALSE;
            RETURN;
        END_IF;
        i := i + 6;
    END_WHILE;

    IsPrime := TRUE;
END_FUNCTION

(* ============================================================================
 * 函数: NextPrime
 * 功能: 查找下一个素数
 * ============================================================================ *)
FUNCTION NextPrime : INT
VAR_INPUT
    from : INT;
END_VAR

BEGIN
    NextPrime := from + 1;

    WHILE NOT IsPrime(NextPrime) DO
        NextPrime := NextPrime + 1;
    END_WHILE;
END_FUNCTION

(* ============================================================================
 * 函数: TriangleArea
 * 功能: 计算三角形面积（海伦公式）
 * ============================================================================ *)
FUNCTION TriangleArea : REAL
VAR_INPUT
    a : REAL;
    b : REAL;
    c : REAL;
END_VAR
VAR
    s : REAL;
END_VAR

BEGIN
    // 三角形存在条件
    IF (a + b <= c) OR (b + c <= a) OR (a + c <= b) THEN
        TriangleArea := 0.0;
        RETURN;
    END_IF;

    s := (a + b + c) / 2.0;
    TriangleArea := SQRT(s * (s - a) * (s - b) * (s - c));
END_FUNCTION

(* ============================================================================
 * 函数: Average
 * 功能: 计算平均值
 * ============================================================================ *)
FUNCTION Average : REAL
VAR_INPUT
    a : REAL;
    b : REAL;
END_VAR

BEGIN
    Average := (a + b) / 2.0;
END_FUNCTION

(* ============================================================================
 * 函数: Average3
 * 功能: 计算三个数的平均值
 * ============================================================================ *)
FUNCTION Average3 : REAL
VAR_INPUT
    a : REAL;
    b : REAL;
    c : REAL;
END_VAR

BEGIN
    Average3 := (a + b + c) / 3.0;
END_FUNCTION

(* ============================================================================
 * 函数: StandardDeviation
 * 功能: 计算标准差
 * ============================================================================ *)
FUNCTION StandardDeviation : REAL
VAR_INPUT
    values : ARRAY[1..10] OF REAL;
    count : INT;
END_VAR
VAR
    i : INT;
    mean : REAL;
    sumSq : REAL;
END_VAR

BEGIN
    IF count <= 0 THEN
        StandardDeviation := 0.0;
        RETURN;
    END_IF;

    // 计算平均值
    mean := 0.0;
    FOR i := 1 TO count DO
        mean := mean + values[i];
    END_FOR;
    mean := mean / INT_TO_REAL(count);

    // 计算方差
    sumSq := 0.0;
    FOR i := 1 TO count DO
        sumSq := sumSq + EXPT(values[i] - mean, 2);
    END_FOR;

    StandardDeviation := SQRT(sumSq / INT_TO_REAL(count));
END_FUNCTION

(* ============================================================================
 * 函数: ToDegrees
 * 功能: 弧度转角度
 * ============================================================================ *)
FUNCTION ToDegrees : REAL
VAR_INPUT
    radians : REAL;
END_VAR

BEGIN
    ToDegrees := radians * 180.0 / 3.141592653589793;
END_FUNCTION

(* ============================================================================
 * 函数: ToRadians
 * 功能: 角度转弧度
 * ============================================================================ *)
FUNCTION ToRadians : REAL
VAR_INPUT
    degrees : REAL;
END_VAR

BEGIN
    ToRadians := degrees * 3.141592653589793 / 180.0;
END_FUNCTION

(* ============================================================================
 * 程序: MathFunctionsDemo
 * 功能: 数学函数演示
 * ============================================================================ *)
PROGRAM MathFunctionsDemo
VAR
    iResult : DINT;
    rResult : REAL;
    bResult : BOOL;
    i : INT;
    aiValues : ARRAY[1..10] OF REAL := [10.0, 12.0, 23.0, 23.0, 16.0, 23.0, 21.0, 16.0, 18.0, 22.0];
END_VAR

BEGIN
    // ==========================================================================
    // 1. 阶乘
    // ==========================================================================

    iResult := Factorial(0);   // 1
    iResult := Factorial(1);   // 1
    iResult := Factorial(5);   // 120
    iResult := Factorial(10);  // 3628800
    iResult := Factorial(-5);  // 0 (非法输入)

    // ==========================================================================
    // 2. 幂运算
    // ==========================================================================

    iResult := Power(2, 0);   // 1
    iResult := Power(2, 10);  // 1024
    iResult := Power(3, 4);   // 81
    iResult := Power(10, 3);  // 1000
    iResult := Power(5, -2);  // 0 (非法输入)

    // ==========================================================================
    // 3. 斐波那契数列
    // ==========================================================================

    iResult := Fibonacci(1);   // 1
    iResult := Fibonacci(5);   // 5
    iResult := Fibonacci(10);  // 55
    iResult := Fibonacci(20);  // 6765

    // ==========================================================================
    // 4. 最大公约数和最小公倍数
    // ==========================================================================

    iResult := GCD(48, 18);    // 6
    iResult := GCD(100, 25);   // 25
    iResult := GCD(17, 13);    // 1 (互质)

    iResult := LCM(4, 6);      // 12
    iResult := LCM(12, 18);    // 36

    // ==========================================================================
    // 5. 素数判断
    // ==========================================================================

    bResult := IsPrime(2);     // TRUE
    bResult := IsPrime(17);    // TRUE
    bResult := IsPrime(100);   // FALSE
    bResult := IsPrime(1);     // FALSE

    // ==========================================================================
    // 6. 查找下一个素数
    // ==========================================================================

    i := NextPrime(10);        // 11
    i := NextPrime(97);       // 101
    i := NextPrime(100);      // 101

    // ==========================================================================
    // 7. 三角形面积
    // ==========================================================================

    rResult := TriangleArea(3.0, 4.0, 5.0);  // 6.0 (直角三角形)
    rResult := TriangleArea(5.0, 5.0, 5.0);  // 10.83 (等边三角形)
    rResult := TriangleArea(1.0, 1.0, 5.0);  // 0.0 (不能构成三角形)

    // ==========================================================================
    // 8. 平均值
    // ==========================================================================

    rResult := Average(10.0, 20.0);        // 15.0
    rResult := Average3(10.0, 20.0, 30.0); // 20.0

    // ==========================================================================
    // 9. 标准差
    // ==========================================================================

    rResult := StandardDeviation(aiValues, 10);  // ~4.49

    // ==========================================================================
    // 10. 角度转换
    // ==========================================================================

    rResult := ToDegrees(3.14159);        // ~180.0
    rResult := ToRadians(180.0);          // ~3.14159

    rResult := ToDegrees(1.5708);        // ~90.0
    rResult := ToRadians(90.0);           // ~1.5708

END_PROGRAM
