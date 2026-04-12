(* ============================================================================
 * 文件: 05_02_StructDemo.st
 * 章节: 第8章 - 数组与结构
 * 描述: 结构体演示
 * 学习目标: 掌握结构体的定义和使用
 * ============================================================================ *)

(* ============================================================================
 * 类型定义区域
 * ============================================================================ *)
TYPE
    // --------------------------------------------------------------------------
    // 基本结构体
    // --------------------------------------------------------------------------

    // 点坐标
    Point : STRUCT
        x : INT;
        y : INT;
    END_STRUCT;

    // 3D点坐标
    Point3D : STRUCT
        x : REAL;
        y : REAL;
        z : REAL;
    END_STRUCT;

    // 日期
    Date : STRUCT
        year : INT;
        month : USINT;  // 1-12
        day : USINT;    // 1-31
    END_STRUCT;

    // 时间
    Time : STRUCT
        hour : USINT;   // 0-23
        minute : USINT; // 0-59
        second : USINT; // 0-59
    END_STRUCT;

    // 日期时间
    DateTime : STRUCT
        date : Date;
        time : Time;
    END_STRUCT;

    // --------------------------------------------------------------------------
    // 传感器相关结构体
    // --------------------------------------------------------------------------

    SensorReading : STRUCT
        sensorId : INT;
        value : REAL;
        timestamp : DateTime;
        valid : BOOL;
    END_STRUCT;

    SensorConfig : STRUCT
        id : INT;
        name : STRING(20);
        enabled : BOOL;
        minValue : REAL;
        maxValue : REAL;
        calibrationOffset : REAL;
    END_STRUCT;

    // --------------------------------------------------------------------------
    // 设备相关结构体
    // --------------------------------------------------------------------------

    MotorStatus : STRUCT
        position : DINT;
        speed : INT;
        acceleration : INT;
        enabled : BOOL;
        fault : BOOL;
        faultCode : INT;
    END_STRUCT;

    ValveStatus : STRUCT
        open : BOOL;
        openPercent : INT;    // 0-100
        fault : BOOL;
    END_STRUCT;

    // --------------------------------------------------------------------------
    // 产品相关结构体
    // --------------------------------------------------------------------------

    Product : STRUCT
        id : INT;
        name : STRING(30);
        price : REAL;
        quantity : INT;
        category : STRING(20);
    END_STRUCT;

    OrderItem : STRUCT
        product : Product;
        quantity : INT;
        discount : REAL;      // 折扣率 0.0-1.0
    END_STRUCT;

    Order : STRUCT
        orderId : INT;
        customerName : STRING(30);
        orderDate : Date;
        items : ARRAY[1..10] OF OrderItem;
        itemCount : USINT;
        totalAmount : REAL;
        paid : BOOL;
    END_STRUCT;

    // --------------------------------------------------------------------------
    // 配方相关结构体
    // --------------------------------------------------------------------------

    RecipeStep : STRUCT
        stepNumber : INT;
        description : STRING(50);
        duration : TIME;
        temperature : REAL;
        speed : INT;
    END_STRUCT;

    Recipe : STRUCT
        id : INT;
        name : STRING(30);
        steps : ARRAY[1..20] OF RecipeStep;
        stepCount : INT;
        version : INT;
    END_STRUCT;
END_TYPE

(* ============================================================================
 * 程序: StructDemo
 * 功能: 结构体演示
 * ============================================================================ *)
PROGRAM StructDemo
VAR
    // ==========================================================================
    // 基础结构体变量
    // ==========================================================================
    ptStart : Point;
    ptEnd : Point;
    ptCurrent : Point3D;
    dtNow : DateTime;

    // ==========================================================================
    // 传感器结构体变量
    // ==========================================================================
    sensor1 : SensorReading;
    sensorConfig : SensorConfig;
    asensors : ARRAY[1..8] OF SensorReading;

    // ==========================================================================
    // 设备状态结构体变量
    // ==========================================================================
    motor1 : MotorStatus;
    valve1 : ValveStatus;

    // ==========================================================================
    // 产品/订单结构体变量
    // ==========================================================================
    product1 : Product;
    order1 : Order;

    // ==========================================================================
    // 配方结构体变量
    // ==========================================================================
    recipe1 : Recipe;

    // ==========================================================================
    // 临时计算变量
    // ==========================================================================
    rDistance : REAL;
    rTotalPrice : REAL;
    i : INT;
END_VAR

// ============================================================================
// 主程序逻辑
// ============================================================================
BEGIN
    // ==========================================================================
    // 1. 基本结构体使用 - 点坐标
    // ==========================================================================

    // 赋值
    ptStart.x := 100;
    ptStart.y := 200;

    ptEnd.x := 300;
    ptEnd.y := 400;

    // 计算中点
    ptStart.x := (ptStart.x + ptEnd.x) / 2;
    ptStart.y := (ptStart.y + ptEnd.y) / 2;

    // ==========================================================================
    // 2. 3D坐标计算
    // ==========================================================================

    ptCurrent.x := 1.0;
    ptCurrent.y := 2.0;
    ptCurrent.z := 3.0;

    // 计算到原点的距离
    rDistance := SQRT(ptCurrent.x * ptCurrent.x +
                      ptCurrent.y * ptCurrent.y +
                      ptCurrent.z * ptCurrent.z);

    // ==========================================================================
    // 3. 日期时间结构体
    // ==========================================================================

    dtNow.date.year := 2024;
    dtNow.date.month := 1;
    dtNow.date.day := 15;

    dtNow.time.hour := 10;
    dtNow.time.minute := 30;
    dtNow.time.second := 45;

    // ==========================================================================
    // 4. 传感器结构体
    // ==========================================================================

    sensor1.sensorId := 1;
    sensor1.value := 25.5;
    sensor1.timestamp := dtNow;
    sensor1.valid := TRUE;

    // 批量设置传感器
    FOR i := 1 TO 8 DO
        asensors[i].sensorId := i;
        asensors[i].value := 20.0 + INT_TO_REAL(i);
        asensors[i].valid := TRUE;
    END_FOR

    // 传感器配置
    sensorConfig.id := 1;
    sensorConfig.name := 'Temperature_01';
    sensorConfig.enabled := TRUE;
    sensorConfig.minValue := -50.0;
    sensorConfig.maxValue := 150.0;
    sensorConfig.calibrationOffset := 0.5;

    // 验证传感器值
    IF sensor1.value < sensorConfig.minValue OR
       sensor1.value > sensorConfig.maxValue THEN
        sensor1.valid := FALSE;
    END_IF

    // 应用校准偏移
    sensor1.value := sensor1.value + sensorConfig.calibrationOffset;

    // ==========================================================================
    // 5. 电机状态结构体
    // ==========================================================================

    motor1.position := 0;
    motor1.speed := 0;
    motor1.acceleration := 100;
    motor1.enabled := FALSE;
    motor1.fault := FALSE;
    motor1.faultCode := 0;

    // 电机启动
    motor1.enabled := TRUE;
    motor1.speed := 1500;

    // 模拟位置变化
    IF motor1.enabled AND NOT motor1.fault THEN
        motor1.position := motor1.position + INT_TO_DINT(motor1.speed / 60);
    END_IF

    // ==========================================================================
    // 6. 产品结构体
    // ==========================================================================

    product1.id := 1001;
    product1.name := 'Widget A';
    product1.price := 29.99;
    product1.quantity := 50;
    product1.category := 'Electronics';

    // 计算库存价值
    rTotalPrice := product1.price * INT_TO_REAL(product1.quantity);

    // ==========================================================================
    // 7. 订单结构体
    // ==========================================================================

    order1.orderId := 10001;
    order1.customerName := 'ABC Corporation';
    order1.orderDate.year := 2024;
    order1.orderDate.month := 1;
    order1.orderDate.day := 10;
    order1.itemCount := 3;
    order1.paid := FALSE;

    // 订单项目
    order1.items[1].product.id := 1001;
    order1.items[1].product.name := 'Widget A';
    order1.items[1].product.price := 29.99;
    order1.items[1].quantity := 5;
    order1.items[1].discount := 0.1;

    order1.items[2].product.id := 1002;
    order1.items[2].product.name := 'Widget B';
    order1.items[2].product.price := 49.99;
    order1.items[2].quantity := 2;
    order1.items[2].discount := 0.0;

    order1.items[3].product.id := 1003;
    order1.items[3].product.name := 'Widget C';
    order1.items[3].product.price := 19.99;
    order1.items[3].quantity := 10;
    order1.items[3].discount := 0.15;

    // 计算订单总额
    order1.totalAmount := 0.0;
    FOR i := 1 TO INT_TO_USINT(order1.itemCount) DO
        order1.totalAmount := order1.totalAmount +
            order1.items[i].product.price *
            INT_TO_REAL(order1.items[i].quantity) *
            (1.0 - order1.items[i].discount);
    END_FOR

    // ==========================================================================
    // 8. 配方结构体
    // ==========================================================================

    recipe1.id := 1;
    recipe1.name := 'Standard Production';
    recipe1.stepCount := 4;
    recipe1.version := 1;

    // 配方步骤
    recipe1.steps[1].stepNumber := 1;
    recipe1.steps[1].description := 'Fill tank';
    recipe1.steps[1].duration := T#5m;
    recipe1.steps[1].temperature := 20.0;
    recipe1.steps[1].speed := 0;

    recipe1.steps[2].stepNumber := 2;
    recipe1.steps[2].description := 'Heat to 80°C';
    recipe1.steps[2].duration := T#10m;
    recipe1.steps[2].temperature := 80.0;
    recipe1.steps[2].speed := 500;

    recipe1.steps[3].stepNumber := 3;
    recipe1.steps[3].description := 'Mix for 5 minutes';
    recipe1.steps[3].duration := T#5m;
    recipe1.steps[3].temperature := 80.0;
    recipe1.steps[3].speed := 1500;

    recipe1.steps[4].stepNumber := 4;
    recipe1.steps[4].description := 'Drain';
    recipe1.steps[4].duration := T#3m;
    recipe1.steps[4].temperature := 60.0;
    recipe1.steps[4].speed := 200;

    // ==========================================================================
    // 9. 批量处理
    // ==========================================================================

    // 重置所有电机
    FOR i := 1 TO 4 DO
        VAR motors : ARRAY[1..4] OF MotorStatus; END_VAR
        motors[i].position := 0;
        motors[i].speed := 0;
        motors[i].enabled := FALSE;
        motors[i].fault := FALSE;
    END_FOR

    // ==========================================================================
    // 10. 初始化结构体数组
    // ==========================================================================

    VAR products : ARRAY[1..3] OF Product := [
        (id := 1, name := 'Product A', price := 10.0, quantity := 100, category := 'Cat1'),
        (id := 2, name := 'Product B', price := 20.0, quantity := 50, category := 'Cat2'),
        (id := 3, name := 'Product C', price := 30.0, quantity := 75, category := 'Cat1')
    ]; END_VAR

    // 计算所有产品的总库存价值
    rTotalPrice := 0.0;
    FOR i := 1 TO 3 DO
        rTotalPrice := rTotalPrice + products[i].price * INT_TO_REAL(products[i].quantity);
    END_FOR

END_PROGRAM
