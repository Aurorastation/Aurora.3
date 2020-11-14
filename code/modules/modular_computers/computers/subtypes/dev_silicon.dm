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
	max_hardware_size = HW_CONSOLE
	max_damage = 50
	w_class = ITEMSIZE_NORMAL
	enrolled = 2
	var/mob/living/silicon/computer_host		// Thing that contains this computer. Used for silicon computers

	preset_components = list(
		MC_CPU = /obj/item/computer_hardware/processor_unit,
		MC_HDD = /obj/item/computer_hardware/hard_drive,
		MC_NET = /obj/item/computer_hardware/network_card/advanced
	)

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

/obj/item/modular_computer/silicon/install_default_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = hardware_by_slot(MC_HDD)
	hard_drive.store_file(new /datum/computer_file/program/filemanager(src))
	hard_drive.store_file(new /datum/computer_file/program/ntnetdownload(src))
	hard_drive.store_file(new /datum/computer_file/program/chatclient(src))
	hard_drive.remove_file(hard_drive.find_file_by_name("clientmanager"))
	addtimer(CALLBACK(src, .proc/register_chat), 1 SECOND)

/obj/item/modular_computer/silicon/proc/register_chat()
	set_autorun("ntnrc_client")
	enable_computer(null, TRUE) // passing null because we don't want the UI to open
	minimize_program()

/obj/item/modular_computer/silicon/verb/send_pda_message()
	set category = "AI IM"
	set name = "Send Direct Message"
	set src in usr
	if (usr.stat == DEAD)
		to_chat(usr, SPAN_WARNING("You can't send PDA messages because you are dead!"))
		return
	var/obj/item/computer_hardware/hard_drive/hard_drive = hardware_by_slot(MC_HDD)
	if(!istype(hard_drive))
		to_chat(usr, SPAN_WARNING("Hard drive inaccessible!"))
		return
	var/datum/computer_file/program/chatclient/CL = hard_drive.find_file_by_name("ntnrc_client")
	if(!istype(CL))
		output_error("Chat client not installed!")
		return
	else if(CL.program_state == PROGRAM_STATE_KILLED)
		run_program("ntnrc_client")

	CL.direct_message()
	if(CL.channel)
		CL.add_message(CL.send_message())
