// This device is wrapper for actual power cell. I have decided to not use power cells directly as even low-end cells available on station
// have tremendeous capacity in comparsion. Higher tier cells would provide your device with nearly infinite battery life, which is something i want to avoid.
/obj/item/computer_hardware/battery_module
	name = "standard battery"
	desc = "A standard power cell, commonly seen in high-end portable microcomputers or low-end laptops. Its rating is 750."
	icon_state = "battery_normal"
	critical = TRUE
	malfunction_probability = 1
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	var/battery_rating = 750
	var/obj/item/cell/battery

/obj/item/computer_hardware/battery_module/advanced
	name = "advanced battery"
	desc = "An advanced power cell, often used in most laptops. It is too large to be fitted into smaller devices. Its rating is 1100."
	icon_state = "battery_advanced"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	battery_rating = 1100
	hardware_size = 2

/obj/item/computer_hardware/battery_module/super
	name = "super battery"
	desc = "A very advanced power cell, often used in high-end devices, or as uninterruptable power supply for important consoles or servers. Its rating is 1500."
	icon_state = "battery_super"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	hardware_size = 3
	battery_rating = 1500

/obj/item/computer_hardware/battery_module/ultra
	name = "ultra battery"
	desc = "A very advanced large power cell. Its often used as uninterruptable power supply for critical consoles or servers. Its rating is 2000."
	icon_state = "battery_ultra"
	origin_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	hardware_size = 3
	battery_rating = 2000

/obj/item/computer_hardware/battery_module/micro
	name = "micro battery"
	desc = "A small power cell, commonly seen in most portable microcomputers. Its rating is 500."
	icon_state = "battery_micro"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	battery_rating = 500

/obj/item/computer_hardware/battery_module/nano
	name = "nano battery"
	desc = "A tiny power cell, commonly seen in low-end portable microcomputers. Its rating is 300."
	icon_state = "battery_nano"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	battery_rating = 300

// This is not intended to be obtainable in-game. Intended for adminbus and debugging purposes.
/obj/item/computer_hardware/battery_module/lambda
	name = "lambda coil"
	desc = "A very complex device that creates its own bluespace dimension. This dimension may be used to store massive amounts of energy."
	icon_state = "battery_lambda"
	hardware_size = 1
	battery_rating = 1000000

/obj/item/computer_hardware/battery_module/lambda/Initialize()
	. = ..()
	battery = new /obj/item/cell/infinite(src)

/obj/item/computer_hardware/battery_module/diagnostics(var/mob/user)
	..()
	to_chat(user, SPAN_NOTICE("Internal battery charge: [battery.charge]/[battery.maxcharge] mAh"))

/obj/item/computer_hardware/battery_module/Initialize()
	. = ..()
	battery = new /obj/item/cell/device/variable(src, battery_rating)
	battery.charge = 0

/obj/item/computer_hardware/battery_module/proc/charge_to_full()
	if(battery)
		battery.charge = battery.maxcharge

/obj/item/computer_hardware/battery_module/get_cell()
	return battery