/obj/machinery/modular_computer/console/preset/
	// Can be changed to give devices specific hardware
	var/_has_id_slot = 0
	var/_has_printer = 0
	var/_has_battery = 0
	var/_has_aislot = 0
	var/_software_locked = 0

/obj/machinery/modular_computer/console/preset/New()
	. = ..()
	if(!cpu)
		return
	cpu.processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(cpu)
	if(_has_id_slot)
		cpu.card_slot = new/obj/item/weapon/computer_hardware/card_slot(cpu)
	if(_has_printer)
		cpu.nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(cpu)
	if(_has_battery)
		cpu.battery_module = new/obj/item/weapon/computer_hardware/battery_module/super(cpu)
	if(_has_aislot)
		cpu.ai_slot = new/obj/item/weapon/computer_hardware/ai_slot(cpu)
	if(_software_locked)
		cpu.software_locked = 1
	install_programs()

// Override in child types to install preset-specific programs.
/obj/machinery/modular_computer/console/preset/proc/install_programs()
	return


// ===== ADMIN CONSOLE =====
/obj/machinery/modular_computer/console/preset/admin
	console_department = "CC ITIQ"
	desc = "A computer from the CC ITIQ Department. Only available on the odin"

/obj/machinery/modular_computer/console/preset/admin/install_programs()
	for(var/F in typesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F
		cpu.hard_drive.store_file(prog)
	cpu.battery_module = new/obj/item/weapon/computer_hardware/battery_module/lambda(cpu)

// ===== ENGINEERING CONSOLE =====
/obj/machinery/modular_computer/console/preset/engineering
	 console_department = "Engineering"
	 desc = "A stationary computer. This one comes preloaded with engineering programs."
	 _software_locked = 1

/obj/machinery/modular_computer/console/preset/engineering/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/power_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/atmos_control())
	cpu.hard_drive.store_file(new/datum/computer_file/program/rcon_console())
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())


// ===== MEDICAL CONSOLE =====
/obj/machinery/modular_computer/console/preset/medical
	 console_department = "Medbay"
	 desc = "A stationary computer. This one comes preloaded with medical programs."
	 _software_locked = 1

/obj/machinery/modular_computer/console/preset/medical/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/suit_sensors())


// ===== RESEARCH CONSOLE =====
/obj/machinery/modular_computer/console/preset/research
	 console_department = "Research"
	 desc = "A stationary computer. This one comes preloaded with research programs."
	 _has_aislot = 1
	 _software_locked = 1

/obj/machinery/modular_computer/console/preset/research/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/ntnetmonitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/aidiag())


// ===== COMMAND CONSOLE =====
/obj/machinery/modular_computer/console/preset/command
	 console_department = "Command"
	 desc = "A stationary computer. This one comes preloaded with command programs."
	 _has_id_slot = 1
	 _has_printer = 1
	 _software_locked = 1

/obj/machinery/modular_computer/console/preset/command/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/card_mod())
	cpu.hard_drive.store_file(new/datum/computer_file/program/comm())

/obj/machinery/modular_computer/console/preset/command/main
	 console_department = "Command"
	 desc = "A stationary computer. This one comes preloaded with essential command programs."

// ===== SECURITY CONSOLE =====
/obj/machinery/modular_computer/console/preset/security
	 console_department = "Security"
	 desc = "A stationary computer. This one comes preloaded with security programs."
	 _software_locked = 1

/obj/machinery/modular_computer/console/preset/security/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor())

// ===== CIVILIAN CONSOLE =====
/obj/machinery/modular_computer/console/preset/civilian
	 console_department = "Civilian"
	 desc = "A stationary computer. This one comes preloaded with generic programs."

/obj/machinery/modular_computer/console/preset/civilian/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/nttransfer())
