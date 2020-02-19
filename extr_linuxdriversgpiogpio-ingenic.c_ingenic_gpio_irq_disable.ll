define internal void @ingenic_gpio_irq_disable(%struct.irq_data* %irqd) #0 {
entry:
  %irqd.addr = alloca %struct.irq_data*, align 8
  %gc = alloca %struct.gpio_chip*, align 8
  %jzgc = alloca %struct.ingenic_gpio_chip*, align 8
  %irq = alloca i32, align 4
  store %struct.irq_data* %irqd, %struct.irq_data** %irqd.addr, align 8
  %0 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %call = call %struct.gpio_chip* @irq_data_get_irq_chip_data(%struct.irq_data* %0)
  store %struct.gpio_chip* %call, %struct.gpio_chip** %gc, align 8
  %1 = load %struct.gpio_chip*, %struct.gpio_chip** %gc, align 8
  %call1 = call %struct.ingenic_gpio_chip* @gpiochip_get_data(%struct.gpio_chip* %1)
  store %struct.ingenic_gpio_chip* %call1, %struct.ingenic_gpio_chip** %jzgc, align 8
  %2 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %hwirq = getelementptr inbounds %struct.irq_data, %struct.irq_data* %2, i32 0, i32 0
  %3 = load i32, i32* %hwirq, align 4
  store i32 %3, i32* %irq, align 4
  %4 = load %struct.irq_data*, %struct.irq_data** %irqd.addr, align 8
  %call2 = call i32 @ingenic_gpio_irq_mask(%struct.irq_data* %4)
  %5 = load %struct.ingenic_gpio_chip*, %struct.ingenic_gpio_chip** %jzgc, align 8
  %version = getelementptr inbounds %struct.ingenic_gpio_chip, %struct.ingenic_gpio_chip* %5, i32 0, i32 0
  %6 = load i64, i64* %version, align 8
  %7 = load i64, i64* @ID_JZ4770, align 8
  %cmp = icmp sge i64 %6, %7
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %8 = load %struct.ingenic_gpio_chip*, %struct.ingenic_gpio_chip** %jzgc, align 8
  %9 = load i32, i32* @JZ4770_GPIO_INT, align 4
  %10 = load i32, i32* %irq, align 4
  %call3 = call i32 @gpio_ingenic_set_bit(%struct.ingenic_gpio_chip* %8, i32 %9, i32 %10, i32 0)
  br label %if.end

if.else:                                          ; preds = %entry
  %11 = load %struct.ingenic_gpio_chip*, %struct.ingenic_gpio_chip** %jzgc, align 8
  %12 = load i32, i32* @JZ4740_GPIO_SELECT, align 4
  %13 = load i32, i32* %irq, align 4
  %call4 = call i32 @gpio_ingenic_set_bit(%struct.ingenic_gpio_chip* %11, i32 %12, i32 %13, i32 0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}
