/datum/ghostspawner/human/skeleton
	short_name = "skeleton"
	name = "Risen Skeleton"
	desc = "Serve your Master. Fight things."
	tags = list("Antagonist")

	enabled = FALSE

	spawn_mob = /mob/living/carbon/human/skeleton

/datum/ghostspawner/human/skeleton/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/human/skeleton/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available skeletons to spawn at!"))
		return FALSE

	var/mob/living/carbon/human/skeleton/skeleton = pick(spawn_atoms)

	if(user && skeleton)
		return skeleton.spawn_skeleton(user)
	return FALSE