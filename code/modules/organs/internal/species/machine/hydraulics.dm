// Hydraulics effects are mainly in /datum/species/machine/handle_sprint_cost.
/obj/item/organ/internal/machine/hydraulics
	name = "hydraulics system"
	desc = "A byzantine system of pumps and other hydraulic components to allow a positronic chassis to stand on both its feet, and do complex tricks such as kicking you in the shins."
	icon = 'icons/obj/organs/ipc_organs.dmi'
	icon_state = "ipc_hydraulics"
	organ_tag = BP_HYDRAULICS
	parent_organ = BP_GROIN

/obj/item/organ/internal/machine/hydraulics/Initialize()
	. = ..()
	RegisterSignal(owner, COMSIG_IPC_HAS_SPRINTED, PROC_REF(handle_hydraulics))

/**
 * Handles sprint effects. For example, recharging with the kinetic reactor.
 */
/obj/item/organ/internal/machine/hydraulics/proc/handle_hydraulics()
	SIGNAL_HANDLER
	if(!owner)
		return

	var/obj/item/organ/internal/machine/reactor/reactor = owner.internal_organs_by_name[BP_REACTOR]
	if(!istype(reactor))
		return

	if(get_integrity() < IPC_INTEGRITY_THRESHOLD_LOW)
		if(prob(10 * (damage / 10)))
			spark(get_turf(owner), rand(1, 5), GLOB.alldirs)

	if(reactor.power_supply_type & POWER_SUPPLY_KINETIC)
		reactor.generate_power(reactor.base_power_generation)

/obj/item/organ/internal/machine/hydraulics/medium_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(get_integrity_damage_probability()))
		spark(owner, 3, GLOB.alldirs)
		to_chat(owner, SPAN_WARNING("Your hydraulics lock up for a second!"))
		owner.Stun(1)


/obj/item/organ/internal/machine/hydraulics/high_integrity_damage(integrity)
	. = ..()
	if(!.)
		return

	if(prob(get_integrity_damage_probability()))
		spark(owner, 5, GLOB.alldirs)
		to_chat(owner, SPAN_WARNING("Your hydraulics malfunction and you trip!"))
		owner.Weaken(1)
