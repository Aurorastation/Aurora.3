/datum/component/armor/plate
	under_armor_mult = 0.1
	over_armor_mult = 1.5
	full_block_message = "Your armor plate blocks the blow!"
	partial_block_message = "Your armor plate softens the blow!"

	/// The connected armor plate on this component. Health is tracked on the physical item.
	var/obj/item/armor_plate/plate
	/// A list of recorded shots taken, for LARP.
	var/list/recorded_hits
	/// How fast armor degrades with blocked damage.
	var/armor_degradation_coef = 0.5
	/// The effectiveness of our blocking. All armour is multiplied by this value. Degrades as it's hit by [coef * damage_taken].
	var/effectiveness = 1

/datum/component/armor/plate/Initialize(list/armor, armor_type, hidden)
	. = ..()
	if(!istype(parent, /obj/item/armor_plate))
		log_debug("Armor component spawned with invalid plate: [parent]")
		return COMPONENT_INCOMPATIBLE

	plate = parent

/datum/component/armor/plate/Destroy(force)
	plate = null
	return ..()

/datum/component/armor/plate/on_blocking(damage, damage_type, damage_flags, armor_pen, blocked)
	var/damage_taken
	if(blocked)
		damage_taken = damage * (1 - blocked)
	else
		damage_taken = damage
	plate.add_true_damage(damage_taken * armor_degradation_coef)
	effectiveness = plate.health / plate.maxhealth
	if(plate.health <= 0 && !(plate.plate_flags & ARMOUR_PLATE_BROKEN))
		var/mob/M = parent
		to_chat(M, SPAN_HIGHDANGER("Your [plate] shatters!"))
		plate.plate_flags |= ARMOUR_PLATE_BROKEN
		playsound(M, 'sound/effects/synth_armor_break.ogg', 50) //todomatt new sound (or maybe just rename this one?)

/datum/component/armor/plate/get_value(key)
	return round(..() * effectiveness, 1)
