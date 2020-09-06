/datum/ghostspawner/syndiborg
	short_name = "syndiborg"
	name = "Syndicate Cyborg"
	desc = "Join in as a Syndicate Cyborg, assist your summoner in their goals, try and make the round fun for the people you're overequipped to deal with."
	tags = list("Antagonist")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"

	enabled = FALSE
	spawn_mob = /mob/living/silicon/robot/syndicate

/datum/ghostspawner/syndiborg/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/syndiborg/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available syndiborgs to spawn at!"))
		return FALSE

	var/mob/living/silicon/robot/syndicate/spawn_syndiborg = pick(spawn_atoms)

	if(user && spawn_syndiborg)
		return spawn_syndiborg.spawn_into_syndiborg(user)
	return FALSE