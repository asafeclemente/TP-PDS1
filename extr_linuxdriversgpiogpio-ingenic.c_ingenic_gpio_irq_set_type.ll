define internal i32 @ingenic_gpio_irq_set_type(%struct.irq_data* %irqd, i32 %type) #0 {
entry:
  %irqd.addr = alloca %struct.irq_data*, align 8
  %type.addr = alloca i32, align 4
  %gc = alloca %struct.gpio_chip*, align 8
  %jzgc = alloca %struct.ingenic_gpio_chip*, align 8
  %high = alloca i32, align 4
  store %struct.irq_data* %irqd, %struct.irq_data** %irqd.addr, align 8
  store i32 %type, i32* %type.addr, align 4
  %0 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %call = call %struct.gpio_chip* @irq_data_get_irq_chip_data(%struct.irq_data* %0)
  store %struct.gpio_chip* %call, %struct.gpio_chip** %gc, align 8
  %1 = load %struct.gpio_chip*, %struct.gpio_chip** %gc, align 8
  %call1 = call %struct.ingenic_gpio_chip* @gpiochip_get_data(%struct.gpio_chip* %1)
  store %struct.ingenic_gpio_chip* %call1, %struct.ingenic_gpio_chip** %jzgc, align 8
  %2 = load i32, i32* %type.addr, align 4
  switch i32 %2, label %sw.default [
    i32 132, label %sw.bb
    i32 130, label %sw.bb
    i32 131, label %sw.bb
    i32 129, label %sw.bb3
    i32 128, label %sw.bb3
  ]

sw.bb:                                            ; preds = %entry, %entry, %entry
  %3 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %4 = load i32, i32* @handle_edge_irq, align 4
  %call2 = call i32 @irq_set_handler_locked(%struct.irq_data* %3, i32 %4)
  br label %sw.epilog

sw.bb3:                                           ; preds = %entry, %entry
  %5 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %6 = load i32, i32* @handle_level_irq, align 4
  %call4 = call i32 @irq_set_handler_locked(%struct.irq_data* %5, i32 %6)
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  %7 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %8 = load i32, i32* @handle_bad_irq, align 4
  %call5 = call i32 @irq_set_handler_locked(%struct.irq_data* %7, i32 %8)
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %sw.bb3, %sw.bb
  %9 = load i32, i32* %type.addr, align 4
  %cmp = icmp eq i32 %9, 132
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %sw.epilog
  %10 = load %struct.ingenic_gpio_chip*, %struct.ingenic_gpio_chip** %jzgc, align 8
  %11 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %hwirq = getelementptr inbounds %struct.irq_data, %struct.irq_data* %11, i32 0, i32 0
  %12 = load i32, i32* %hwirq, align 4
  %call6 = call i32 @gpio_get_value(%struct.ingenic_gpio_chip* %10, i32 %12)
  store i32 %call6, i32* %high, align 4
  %13 = load i32, i32* %high, align 4
  %tobool = icmp ne i32 %13, 0
  %14 = zext i1 %tobool to i64
  %cond = select i1 %tobool, i32 131, i32 130
  store i32 %cond, i32* %type.addr, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sw.epilog
  %15 = load %struct.ingenic_gpio_chip*, %struct.ingenic_gpio_chip** %jzgc, align 8
  %16 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %hwirq7 = getelementptr inbounds %struct.irq_data, %struct.irq_data* %16, i32 0, i32 0
  %17 = load i32, i32* %hwirq7, align 4
  %18 = load i32, i32* %type.addr, align 4
  %call8 = call i32 @irq_set_type(%struct.ingenic_gpio_chip* %15, i32 %17, i32 %18)
  ret i32 0
}
