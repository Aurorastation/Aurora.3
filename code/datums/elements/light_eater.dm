/**
 * Makes anything it attaches to capable of permanently removing something's ability to produce light.
 *
 * TG_PLANE_CUBE_TEMP: reagent and niche combat hooks should be rechecked if Aurora adds matching tg signal contracts.
 */
/datum/element/light_eater
	var/static/list/blacklisted_areas = typecacheof(list(
		/turf/space,
	))

/datum/element/light_eater/Attach(datum/target)
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE

	if(ismovable(target))
		RegisterSignal(target, COMSIG_MOVABLE_IMPACT, PROC_REF(on_throw_impact))
		if(istype(target, /obj/item))
			RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(on_item_attack))
			RegisterSignal(target, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_item_afterattack))
			RegisterSignal(target, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_interacting_with))
			RegisterSignal(target, COMSIG_PROJECTILE_ON_HIT, PROC_REF(on_projectile_hit))
		else if(isprojectile(target))
			RegisterSignal(target, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(on_projectile_self_hit))
	else
		return ELEMENT_INCOMPATIBLE

	return ..()

/datum/element/light_eater/Detach(datum/source)
	UnregisterSignal(source, list(
		COMSIG_MOVABLE_IMPACT,
		COMSIG_ITEM_ATTACK,
		COMSIG_ITEM_AFTERATTACK,
		COMSIG_ITEM_INTERACTING_WITH_ATOM,
		COMSIG_PROJECTILE_ON_HIT,
		COMSIG_PROJECTILE_SELF_ON_HIT,
	))
	return ..()

/**
 * Makes the light eater consume all of the lights attached to the target atom.
 */
/datum/element/light_eater/proc/eat_lights(atom/food, datum/eater)
	var/list/buffet = table_buffet(food, eater)
	if(!LAZYLEN(buffet))
		return 0

	. = 0
	for(var/morsel in buffet)
		. += devour(morsel, eater)

/**
 * Aggregates a list of the light sources attached to the target atom.
 */
/datum/element/light_eater/proc/table_buffet(atom/commissary, datum/devourer)
	. = list()
	SEND_SIGNAL(commissary, COMSIG_LIGHT_EATER_QUEUE, ., devourer)
	for(var/datum/light_source/morsel as anything in commissary.light_sources)
		.[morsel.source_atom] = TRUE

/**
 * Consumes the light on the target, rendering it incapable of producing light.
 */
/datum/element/light_eater/proc/devour(atom/morsel, datum/eater)
	if(is_type_in_typecache(morsel, blacklisted_areas))
		return FALSE
	if(istransparentturf(morsel))
		return FALSE
	if(morsel.light_power <= 0 || morsel.light_range <= 0 || !morsel.light_on)
		return FALSE
	if(SEND_SIGNAL(morsel, COMSIG_LIGHT_EATER_ACT, eater) & COMPONENT_BLOCK_LIGHT_EATER)
		return FALSE

	morsel.AddElement(/datum/element/light_eaten)
	SEND_SIGNAL(eater, COMSIG_LIGHT_EATER_DEVOUR, morsel)
	return TRUE

/datum/element/light_eater/proc/on_throw_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing)
	SIGNAL_HANDLER
	eat_lights(hit_atom, source)
	return NONE

/datum/element/light_eater/proc/on_item_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	eat_lights(target, source)
	return NONE

/datum/element/light_eater/proc/on_item_afterattack(obj/item/source, atom/target, mob/user)
	SIGNAL_HANDLER
	eat_lights(target, source)
	return NONE

/datum/element/light_eater/proc/on_interacting_with(obj/item/source, mob/user, atom/target, modifiers)
	SIGNAL_HANDLER
	eat_lights(target, source)
	return NONE

/datum/element/light_eater/proc/on_projectile_hit(datum/source, atom/movable/firer, atom/target, angle, hit_limb, blocked)
	SIGNAL_HANDLER
	eat_lights(target, source)
	return NONE

/datum/element/light_eater/proc/on_projectile_self_hit(obj/projectile/source, atom/movable/firer, atom/target, angle, hit_limb, blocked)
	SIGNAL_HANDLER
	eat_lights(target, source)
	return NONE
