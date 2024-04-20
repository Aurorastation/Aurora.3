#define MAX_FIELD_STR 10000
#define MIN_FIELD_STR 1

/obj/machinery/power/fusion_core
	name = "\improper INDRA Mk. II Tokamak core"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields. It includes a kinetic energy harvester."
	icon = 'icons/obj/machinery/fusion_core.dmi'
	icon_state = "core0"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 50
	active_power_usage = 500 //multiplied by field strength
	anchored = FALSE

	var/obj/effect/fusion_em_field/owned_field
	var/field_strength = 1//0.01
	var/initial_id_tag

/obj/machinery/power/fusion_core/mapped
	anchored = TRUE

/obj/machinery/power/fusion_core/Initialize()
	. = ..()
	connect_to_network()
	AddComponent(/datum/component/local_network_member, initial_id_tag)

/obj/machinery/power/fusion_core/process()
	. = ..()
	if(stat & BROKEN || !powernet || !owned_field)
		Shutdown()

/obj/machinery/power/fusion_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(loc, src)
	owned_field.ChangeFieldStrength(field_strength)
	icon_state = "core1"
	update_use_power(POWER_USE_ACTIVE)
	. = 1

/obj/machinery/power/fusion_core/proc/Shutdown(force_rupture)
	if(owned_field)
		icon_state = "core0"
		if(force_rupture || owned_field.plasma_temperature > 1000)
			owned_field.Rupture()
		else
			owned_field.RadiateAll()
		qdel(owned_field)
		owned_field = null
	update_use_power(POWER_USE_IDLE)

/obj/machinery/power/fusion_core/proc/AddParticles(name, quantity = 1)
	if(owned_field)
		owned_field.AddParticles(name, quantity)
		. = 1

/obj/machinery/power/fusion_core/bullet_act(obj/item/projectile/Proj)
	if(owned_field)
		. = owned_field.bullet_act(Proj)

/obj/machinery/power/fusion_core/proc/set_strength(value)
	value = clamp(value, MIN_FIELD_STR, MAX_FIELD_STR)
	field_strength = value
	change_power_consumption(5 * value, POWER_USE_ACTIVE)
	if(owned_field)
		owned_field.ChangeFieldStrength(value)

/obj/machinery/power/fusion_core/attack_hand(mob/user)
	. = ..()
	if(ishuman(user))
		visible_message(SPAN_NOTICE("\The [user] hugs \the [src] to make it feel better!"))
		if(owned_field)
			Shutdown()
	return TRUE

/obj/machinery/power/fusion_core/attackby(obj/item/attacking_item, mob/user)

	if(owned_field)
		to_chat(user,SPAN_WARNING("Shut \the [src] off first!"))
		return

	if(attacking_item.ismultitool())
		var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
		fusion.get_new_tag(user)
		return

	else if(attacking_item.iswrench())
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet")
		return

	return ..()

/obj/machinery/power/fusion_core/proc/jumpstart(field_temperature)
	field_strength = 501 // Generally a good size.
	Startup()
	if(!owned_field)
		return FALSE
	owned_field.plasma_temperature = field_temperature
	return TRUE

/obj/machinery/power/fusion_core/proc/check_core_status()
	if(!powernet)
		connect_to_network()
	if(stat & BROKEN)
		return FALSE
	if(idle_power_usage > avail())
		return FALSE
	. = TRUE
