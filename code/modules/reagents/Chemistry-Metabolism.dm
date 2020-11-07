/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, CHEM_BREATHE, or CHEM_BLOOD
	var/mob/living/carbon/parent

/datum/reagents/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class)
	..(max, parent_mob)

	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()
	if(parent)
		var/metabolism_type = 0 //non-human mobs
		if(ishuman(parent))
			var/mob/living/carbon/human/H = parent
			metabolism_type = H.species.reagent_tag
		// run this first to get all the chem effects sorted
		for(var/thing in reagent_list)
			var/datum/reagent/R = thing
			R.affect_chem_effect(parent, metabolism_type, metabolism_class)
		// then run this to actually do what the chems do
		for(var/thing in reagent_list)
			var/datum/reagent/R = thing
			R.on_mob_life(parent, metabolism_type, metabolism_class)
		update_total()