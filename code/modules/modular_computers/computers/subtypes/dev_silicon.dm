/obj/item/modular_computer/silicon
	name = "internal computing device"
	desc = "A synthetic computer."
	hardware_flag = PROGRAM_SILICON
	icon_state_unpowered = "laptop-open"
	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop-open"
	icon_state_broken = "laptop-broken"
	base_idle_power_usage = 5
	base_active_power_usage = 25
	max_hardware_size = 3
	max_damage = 50
	w_class = ITEMSIZE_NORMAL
	enrolled = 2
	var/mob/living/silicon/computer_host		// Thing that contains this computer. Used for silicon computers
	looping_sound = FALSE

/obj/item/modular_computer/silicon/ui_host()
	. = computer_host

/obj/item/modular_computer/silicon/Initialize(mapload)
	. = ..()
	if(istype(loc, /mob/living/silicon))
		computer_host = loc
	else
		return

/obj/item/modular_computer/silicon/computer_use_power(power_usage)
	// If we have host like AI, borg or pAI we handle there power
	if(computer_host)
		// If host is borg, we use power from it's cell, like anyone other module
		if(istype(computer_host, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = computer_host
			return R.cell_use_power(power_usage)
		// If we are in AI or pAI we just don't bother with power use.
		return TRUE
	else
		// If we don't have host, then we let regular computer code handle power - like batteries and tesla coils.
		return ..()

/obj/item/modular_computer/silicon/Destroy()
	computer_host = null
	return ..()

/obj/item/modular_computer/silicon/Click(location, control, params)
	return attack_self(usr)

/obj/item/modular_computer/silicon/install_default_hardware()
	. = ..()
	processor_unit = new /obj/item/computer_hardware/processor_unit(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive(src)
	network_card = new /obj/item/computer_hardware/network_card/advanced(src)

/obj/item/modular_computer/silicon/install_default_programs()
	hard_drive.store_file(new /datum/computer_file/program/filemanager(src))
	hard_drive.store_file(new /datum/computer_file/program/ntnetdownload(src))
	hard_drive.store_file(new /datum/computer_file/program/chat_client(src))
	hard_drive.remove_file(hard_drive.find_file_by_name("clientmanager"))
	addtimer(CALLBACK(src, .proc/register_chat), 1 SECOND)

/obj/item/modular_computer/silicon/proc/register_chat()
	set_autorun("ntnrc_client")
	enable_computer(null, TRUE) // passing null because we don't want the UI to open
	minimize_program()

/obj/item/modular_computer/silicon/robot/drone/install_default_programs()
	hard_drive.store_file(new /datum/computer_file/program/filemanager(src))
	hard_drive.store_file(new /datum/computer_file/program/ntnetdownload(src))
	hard_drive.remove_file(hard_drive.find_file_by_name("clientmanager"))
