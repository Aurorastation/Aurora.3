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
	var/mob/living/silicon/computer_host		// Thing that contains this computer. Used for silicon computers

/obj/item/modular_computer/silicon/Initialize(mapload)
	. = ..()
	if(istype(loc, /mob/living/silicon))
		computer_host = loc
	else
		return
	// Let's remove integrated verbs for ejecting things.
	verbs -= /obj/item/modular_computer/verb/eject_ai
	verbs -= /obj/item/modular_computer/verb/eject_id
	verbs -= /obj/item/modular_computer/verb/eject_usb

/obj/item/modular_computer/silicon/computer_use_power(power_usage)
	// If we have host like AI, borg or pAI we handle there power
	if(computer_host)
		// If host is borg, we use power from it's cell, like anyone other module
		if(istype(computer_host, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = computer_host
			return R.cell_use_power(power_usage)
		// If we are in AI or pAI we just don't botherwith power use.
		return TRUE
	else
		// If we don't have host, then we let regular computer code handle power - like batteries and tesla coils
		return ..()

/obj/item/modular_computer/silicon/Destroy()
	computer_host = null
	return ..()

/obj/item/modular_computer/silicon/Click(location, control, params)
	return attack_self(usr)
