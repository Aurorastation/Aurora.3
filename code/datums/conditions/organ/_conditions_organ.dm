/datum/condition/organ
	/// The organ this condition is affecting.
	var/obj/item/organ/organ
	/// The injury types required to inflict this condition. Must match one from the list.
	var/list/injury_types = list()
	/// The minimum damage required on the organ for this condition to be applied.
	var/min_damage = 0

/datum/condition/organ/Destroy()
	if(organ)
		organ = null
	return ..()

/datum/condition/organ/pre_apply(atom/movable/new_parent, injury_type)
	if(!istype(new_parent, /obj/item/organ))
		return FALSE
	if(!(injury_type in injury_types))
		return FALSE
	var/obj/item/organ/new_organ = new_parent
	if(new_organ.damage < min_damage)
		return FALSE
	organ = new_organ
	return TRUE
