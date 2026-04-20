/datum/condition/organ
	/// The organ this condition is affecting.
	var/obj/item/organ/organ

/datum/condition/organ/pre_apply(new_parent)
	if(!istype(new_parent, /obj/item/organ))
		return FALSE
	organ = new_parent
	return TRUE
