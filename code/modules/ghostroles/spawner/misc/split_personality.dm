/datum/ghostspawner/split_personality
	short_name = "split_personality"
	name = "Split Personality"
	desc = "Control someone's body against their will, but only sometimes. Be entertaining split to someone's psyche."
	tags = list("Mental Trauma")

	enabled = FALSE

	spawn_mob = /mob/living/mental/split_personality

/datum/ghostspawner/split_personality/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/split_personality/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available split personalities to spawn at!"))
		return FALSE

	var/mob/living/mental/split_personality/spawn_friend = pick(spawn_atoms)

	if(user && spawn_friend)
		return spawn_friend.spawn_into_personality(user)
	return FALSE