/datum/ghostspawner/human/apprentice
	short_name = "apprentice"
	name = "Wizard Apprentice"
	desc = "Serve your Master. Cast Spells."
	tags = list("Antagonist")

	enabled = FALSE

	spawn_mob = /mob/living/carbon/human

/datum/ghostspawner/human/apprentice/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/human/apprentice/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available apprentice pebbles to spawn at!"))
		return FALSE

	var/obj/item/apprentice_pebble/pebble = pick(spawn_atoms)

	if(user && pebble)
		return pebble.spawn_apprentice(user)
	return FALSE