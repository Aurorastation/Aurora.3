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
	max_hardware_size = 2
	max_damage = 50
	w_class = 3
	var/mob/living/silicon/computer_host		// Thing that contains this computer. Used for silicon computers

/obj/item/modular_computer/silicon/New(host)
	computer_host = host
	loc = host
	verbs -= /obj/item/modular_computer/verb/eject_ai
	verbs -= /obj/item/modular_computer/verb/eject_id
	verbs -= /obj/item/modular_computer/verb/eject_usb
	..()

/obj/item/modular_computer/silicon/computer_use_power(power_usage)
	if(istype(computer_host, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = computer_host
		return R.cell_use_power(power_usage)
	else
		return TRUE
	. = ..()


/obj/item/modular_computer/silicon/Click(location, control, params)
	if (!istype(usr, /mob/living/silicon))
		return
	attack_self(usr)
	