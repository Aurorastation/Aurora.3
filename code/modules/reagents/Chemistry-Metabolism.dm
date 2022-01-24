/datum/reagents/metabolism
	var/metabolism_class //CHEM_TOUCH, CHEM_INGEST, CHEM_BREATHE, or CHEM_BLOOD
	var/mob/living/carbon/parent

/datum/reagents/metabolism/New(var/max = 100, mob/living/carbon/parent_mob, var/met_class)
	..(max, parent_mob)

	metabolism_class = met_class
	if(istype(parent_mob))
		parent = parent_mob

/datum/reagents/metabolism/proc/metabolize()
	if(!parent)
		return
	var/metabolism_type = 0 //non-human mobs
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		metabolism_type = H.species.reagent_tag
	// run this first to get all the chem effects sorted
	for(var/_R in reagent_volumes)
		var/decl/reagent/R = decls_repository.get_decl(_R)
		R.affect_chem_effect(parent, metabolism_type, metabolism_class, src)
	// then run this to actually do what the chems do
	for(var/_current in reagent_volumes)
		var/decl/reagent/current = decls_repository.get_decl(_current)
		current.on_mob_life(parent, metabolism_type, metabolism_class, src)
	update_total()
