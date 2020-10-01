/datum/ghostspawner/imaginary_friend
	short_name = "friend"
	name = "Imaginary Friend"
	desc = "Be someone's best friend! Even if you don't really exist."
	tags = list("Mental Trauma")

	enabled = FALSE

	spawn_mob = /mob/abstract/mental/friend

/datum/ghostspawner/imaginary_friend/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/imaginary_friend/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available friends to spawn at!"))
		return FALSE

	var/mob/abstract/mental/friend/spawn_friend = pick(spawn_atoms)

	if(user && spawn_friend)
		return spawn_friend.spawn_into_friend(user)
	return FALSE