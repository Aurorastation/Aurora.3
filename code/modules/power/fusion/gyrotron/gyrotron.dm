#define GYRO_POWER 25000

/obj/machinery/power/emitter/gyrotron
	name = "gyrotron"
	icon = 'icons/obj/machinery/fusion.dmi'
	desc = "A heavy-duty, highly configurable industrial gyrotron suited for powering fusion reactors."
	icon_state = "emitter-off"
	use_power = POWER_USE_IDLE
	active_power_usage = GYRO_POWER

	var/initial_id_tag
	var/rate = 3
	var/mega_energy = 1

/obj/machinery/power/emitter/gyrotron/anchored
	anchored = TRUE

/obj/machinery/power/emitter/gyrotron/Initialize()
	AddComponent(/datum/component/local_network_member, initial_id_tag)
	change_power_consumption(mega_energy * GYRO_POWER, POWER_USE_ACTIVE)
	. = ..()

/obj/machinery/power/emitter/gyrotron/process()
	change_power_consumption(mega_energy * GYRO_POWER, POWER_USE_ACTIVE)
	. = ..()

/obj/machinery/power/emitter/gyrotron/get_rand_burst_delay()
	return rate * 10

/obj/machinery/power/emitter/gyrotron/get_burst_delay()
	return rate * 10

/obj/machinery/power/emitter/gyrotron/get_emitter_beam()
	var/obj/item/projectile/beam/emitter/E = ..()
	E.damage = mega_energy * 50
	return E

/obj/machinery/power/emitter/gyrotron/update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"

/obj/machinery/power/emitter/gyrotron/attackby(obj/item/W, mob/user)
	if(W.ismultitool())
		var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
		fusion.get_new_tag(user)
		return
	return ..()

#undef GYRO_POWER
