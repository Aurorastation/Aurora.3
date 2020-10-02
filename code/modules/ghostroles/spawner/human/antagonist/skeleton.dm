/datum/ghostspawner/human/skeleton
	short_name = "skeleton"
	name = "Risen Skeleton"
	desc = "Serve your Master. Fight things."
	tags = list("Antagonist")

	loc_type = GS_LOC_ATOM

	spawn_mob = /mob/living/carbon/human/skeleton

//The proc to actually spawn in the user
/datum/ghostspawner/human/skeleton/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available skeletons to spawn at!"))
		return FALSE

	var/mob/living/carbon/human/skeleton/skeleton = select_spawnatom()

	if(user && skeleton)
		return skeleton.spawn_skeleton(user)
	return FALSE
