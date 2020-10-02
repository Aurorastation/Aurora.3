/datum/ghostspawner/human/apprentice
	short_name = "apprentice"
	name = "Wizard Apprentice"
	desc = "Serve your Master. Cast Spells."
	tags = list("Antagonist")

	loc_type = GS_LOC_ATOM

	spawn_mob = /mob/living/carbon/human

//The proc to actually spawn in the user
/datum/ghostspawner/human/apprentice/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available apprentice pebbles to spawn at!"))
		return FALSE

	var/obj/item/apprentice_pebble/pebble = select_spawnatom()

	if(user && pebble)
		return pebble.spawn_apprentice(user)
	return FALSE
