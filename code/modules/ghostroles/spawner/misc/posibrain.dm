/datum/ghostspawner/posibrain
	short_name = "posibrain"
	name = "Positronic Brain"
	desc = "Enter a synthetic brain, capable of piloting a spiderbrain, operating an android, becoming an AI, or being a pocketbuddy."
	tags = list("Stationbound")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"

	enabled = FALSE
	spawn_mob = /mob/living/carbon/brain

/datum/ghostspawner/posibrain/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/posibrain/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available posibrains to spawn at!"))
		return FALSE

	var/obj/item/device/mmi/digital/posibrain/spawn_posibrain = pick(spawn_atoms)

	if(user && spawn_posibrain)
		return spawn_posibrain.spawn_into_posibrain(user)
	return FALSE