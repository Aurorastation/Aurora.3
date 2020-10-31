/obj/item/computer_hardware/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	critical = FALSE
	icon_state = "teslalink"
	hardware_size = 3
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	var/passive_charging_rate = 2500 // mW

/obj/item/computer_hardware/tesla_link/Destroy()
	if(parent_computer?.tesla_link == src)
		parent_computer.tesla_link = null
	return ..()

/obj/item/computer_hardware/tesla_link/charging_cable
	name = "charging cable"
	desc = "An integrated charging cable used to recharge small devices manually, by hooking into the local area power controller."
	icon = 'icons/obj/power.dmi'
	icon_state = "wire"
	hardware_size = 1
	origin_tech = list(TECH_ENGINEERING = 1, TECH_POWER = 1)
	passive_charging_rate = 2500 // mW
	var/obj/machinery/power/source
	var/datum/beam/beam
	var/cable_length = 3

/obj/item/computer_hardware/tesla_link/charging_cable/Destroy()
	if(source || beam)
		deactivate()
	return ..()

/obj/item/computer_hardware/tesla_link/charging_cable/proc/toggle(var/obj/machinery/power/power_source, mob/user)
	if(!source)
		to_chat(user, SPAN_NOTICE("You connect \the [src] to \the [power_source]."))
		activate(power_source)
	else
		deactivate()

/obj/item/computer_hardware/tesla_link/charging_cable/proc/activate(var/power_source)
	var/obj/machinery/power/P = power_source
	if(!istype(P))
		return
	tether(P)

/obj/item/computer_hardware/tesla_link/charging_cable/proc/deactivate()
	untether()

/obj/item/computer_hardware/tesla_link/charging_cable/check_functionality()
	. = ..()
	if(!source || !enabled)
		return FALSE
	return TRUE

/obj/item/computer_hardware/tesla_link/charging_cable/proc/tether(var/obj/machinery/power/P)
	source = P
	var/datum/beam/power/B = new/datum/beam/power(src, source, beam_icon_state = "explore_beam", time = -1, maxdistance = cable_length)
	B.owner = src
	B.Start()
	beam = B

/obj/item/computer_hardware/tesla_link/charging_cable/proc/untether(var/destroy_beam = TRUE)
	source = null
	if(parent_computer)
		parent_computer.visible_message(SPAN_WARNING("The charging cable suddenly disconnects from the APC, quickly reeling back into the computer!"))
		playsound(get_turf(src), 'sound/machines/click.ogg', 30, 0)
	if(!destroy_beam)
		return
	if(beam)
		beam.End()