/*
 * Rig security can be snipped to disable ID access checks on rig.
 * Rig AI override can be pulsed to toggle whether or not the AI can take control of the suit.
 * System control can be pulsed to toggle some malfunctions.
 * Interface lock can be pulsed to toggle whether or not the interface can be accessed.
 */
#define RIG_SECURITY BITFLAG(1)
#define RIG_AI_OVERRIDE BITFLAG(2)
#define RIG_SYSTEM_CONTROL BITFLAG(3)
#define RIG_INTERFACE_LOCK BITFLAG(4)
#define RIG_INTERFACE_SHOCK BITFLAG(5)

/datum/wires/rig
	random = 1
	holder_type = /obj/item/rig

/datum/wires/rig/New(atom/holder)
	wires = list(
		RIG_SECURITY,
		RIG_AI_OVERRIDE,
		RIG_SYSTEM_CONTROL,
		RIG_INTERFACE_LOCK,
		RIG_INTERFACE_SHOCK
	)
	add_duds(3)
	. = ..()

/datum/wires/rig/on_cut(wire, mend, source)

	var/obj/item/rig/rig = holder
	switch(wire)
		if(RIG_SECURITY)
			if(mend)
				rig.req_access = initial(rig.req_access)
				rig.req_one_access = initial(rig.req_one_access)
		if(RIG_INTERFACE_SHOCK)
			rig.electrified = mend ? 0 : -1
			rig.shock(usr,100)
		if(RIG_SYSTEM_CONTROL)
			if(mend)
				rig.malfunctioning = 0
				rig.malfunction_delay = 0
			else
				rig.malfunctioning += 10
				rig.malfunction_delay = 10000000000

/datum/wires/rig/on_pulse(wire)

	var/obj/item/rig/rig = holder
	switch(wire)
		if(RIG_SECURITY)
			rig.security_check_enabled = !rig.security_check_enabled
			rig.visible_message("\The [rig] twitches as several suit locks [rig.security_check_enabled?"close":"open"].")
		if(RIG_AI_OVERRIDE)
			rig.ai_override_enabled = !rig.ai_override_enabled
			rig.visible_message("A small red light on [rig] [rig.ai_override_enabled?"goes dead":"flickers on"].")
		if(RIG_SYSTEM_CONTROL)
			rig.malfunctioning += 10
			if(rig.malfunction_delay <= 0)
				rig.malfunction_delay = 20
			rig.shock(usr,100)
		if(RIG_INTERFACE_LOCK)
			rig.interface_locked = !rig.interface_locked
			rig.visible_message("\The [rig] clicks audibly as the software interface [rig.interface_locked?"darkens":"brightens"].")
		if(RIG_INTERFACE_SHOCK)
			if(rig.electrified != -1)
				rig.electrified = 30
			rig.shock(usr,100)

/datum/wires/rig/interactable(var/mob/living/L)
	if(!..())
		return FALSE
	var/obj/item/rig/rig = holder
	if(rig.open)
		return TRUE
	return FALSE

#undef RIG_SECURITY
#undef RIG_AI_OVERRIDE
#undef RIG_SYSTEM_CONTROL
#undef RIG_INTERFACE_LOCK
#undef RIG_INTERFACE_SHOCK
