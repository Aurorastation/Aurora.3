/obj/structure/machinery/power/emitter/gyrotron
	name = "gyrotron"
	icon = 'icons/obj/machinery/fusion.dmi'
	desc = "A heavy-duty, highly configurable industrial gyrotron suited for powering fusion reactors."
	icon_state = "emitter-off"
	use_power = POWER_USE_IDLE
	active_power_usage = GYRO_POWER

	var/initial_id_tag
	var/rate = 3
	var/mega_energy = 1

/obj/structure/machinery/power/emitter/gyrotron/anchored
	anchored = TRUE

/obj/structure/machinery/power/emitter/gyrotron/Initialize()
	AddComponent(/datum/component/local_network_member, initial_id_tag)
	change_power_consumption(get_effective_gyro_power(), POWER_USE_ACTIVE)
	. = ..()

/obj/structure/machinery/power/emitter/gyrotron/proc/get_effective_gyro_power()
	return mega_energy * GYRO_POWER * (reactor_tuned ? 0.85 : 1)

/obj/structure/machinery/power/emitter/gyrotron/AltClick(mob/user)
	var/tune_result = attempt_skill_tuning(user, REACTOR_SYSTEMS_SKILL_COMPONENT, reactor_tuned, "calibrating the focusing coils of", "\the [src] for 15% lower power draw")
	if(isnull(tune_result))
		return ..()
	if(tune_result && !reactor_tuned)
		reactor_tuned = TRUE
		change_power_consumption(get_effective_gyro_power(), POWER_USE_ACTIVE)
	return TRUE

/obj/structure/machinery/power/emitter/gyrotron/process()
	change_power_consumption(get_effective_gyro_power(), POWER_USE_ACTIVE)
	. = ..()

/obj/structure/machinery/power/emitter/gyrotron/get_rand_burst_delay()
	return rate * 10

/obj/structure/machinery/power/emitter/gyrotron/get_burst_delay()
	return rate * 10

/obj/structure/machinery/power/emitter/gyrotron/get_emitter_beam()
	var/obj/projectile/beam/emitter/E = ..()
	E.damage = mega_energy * 50
	return E

/obj/structure/machinery/power/emitter/gyrotron/update_icon()
	if (active && powernet && POWER_AVAIL(src))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"

/obj/structure/machinery/power/emitter/gyrotron/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_MULTITOOL)
		var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
		fusion.get_new_tag(user)
		return
	return ..()
