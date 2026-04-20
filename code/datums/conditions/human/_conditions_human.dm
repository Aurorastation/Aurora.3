/datum/condition/human
	/// The human this condition is affecting.
	var/mob/living/carbon/human/human
	/// If this condition is restricted from certain species. This is a blacklist.
	var/list/species_restrictions

/datum/condition/human/pre_apply(new_parent)
	if(!ishuman(new_parent))
		return FALSE
	var/mob/living/carbon/human/new_human = new_parent
	if(length(species_restrictions) && (new_human.species.name in species_restrictions))
		return FALSE

	human = new_human
	return TRUE
