/obj/machinery/modular_computer/console/preset/
	// Can be changed to give devices specific hardware
	var/_has_id_slot = 0
	var/_has_printer = 0
	var/_has_battery = 0
	var/_has_aislot = 0
	var/_enrolled = 0
	var/_app_preset_name = "" //name of the app preset

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
	if(_enrolled)
		cpu.enrolled = _enrolled
	install_programs(get_preset_programs(_app_preset_name))

/obj/machinery/modular_computer/console/preset/proc/get_preset_programs(var/app_preset_name)
	for (var/datum/modular_computer_app_presets/prs in ntnet_global.available_software_presets)
		//var/datum/modular_computer_app_presets/prs = new path()
		if(prs.name == app_preset_name && prs.available == 1)
			return prs.return_install_programs()

// Override in child types to install preset-specific programs.
/obj/machinery/modular_computer/console/preset/proc/install_programs(var/list/programs)
	for (var/datum/computer_file/program/prog in programs)
		cpu.hard_drive.store_file(prog)

// ===== ADMIN CONSOLE =====
/obj/machinery/modular_computer/console/preset/all
	console_department = "CC ITIQ"
	desc = "A computer from the CC ITIQ Department. Only available on the Odin"
	_app_preset_name = "all"
	_enrolled = 1

/obj/machinery/modular_computer/console/preset/admin/install_programs()
	..()
	cpu.battery_module = new/obj/item/weapon/computer_hardware/battery_module/lambda(cpu)

// ===== Empty Test console CONSOLE =====
/obj/machinery/modular_computer/console/preset/empty
	 desc = "A stationary computer."

// ===== ENGINEERING CONSOLE =====
/obj/machinery/modular_computer/console/preset/engineering
	 console_department = "Engineering"
	 desc = "A stationary computer. This one comes preloaded with engineering programs."
	 _app_preset_name = "engineering"
	 _enrolled = 1

// ===== MEDICAL CONSOLE =====
/obj/machinery/modular_computer/console/preset/medical
	 console_department = "Medbay"
	 desc = "A stationary computer. This one comes preloaded with medical programs."
	 _app_preset_name = "medical"
	 _enrolled = 1

// ===== RESEARCH CONSOLE =====
/obj/machinery/modular_computer/console/preset/research
	 console_department = "Research"
	 desc = "A stationary computer. This one comes preloaded with research programs."
	 _app_preset_name = "research"
	 _has_aislot = 1
	 _enrolled = 1

// ===== COMMAND CONSOLE =====
/obj/machinery/modular_computer/console/preset/command
	 console_department = "Command"
	 desc = "A stationary computer. This one comes preloaded with command programs."
	 _app_preset_name = "command"
	 _has_id_slot = 1
	 _has_printer = 1
	 _enrolled = 1

/obj/machinery/modular_computer/console/preset/command/main
	 console_department = "Command"
	 desc = "A stationary computer. This one comes preloaded with essential command programs."

// ===== SECURITY CONSOLE =====
/obj/machinery/modular_computer/console/preset/security
	 console_department = "Security"
	 desc = "A stationary computer. This one comes preloaded with security programs."
	 _app_preset_name = "security"
	 _enrolled = 1

// ===== CIVILIAN CONSOLE =====
/obj/machinery/modular_computer/console/preset/civilian
	 console_department = "Civilian"
	 desc = "A stationary computer. This one comes preloaded with generic programs."
	 _app_preset_name = "civilian"
	 _enrolled = 1
