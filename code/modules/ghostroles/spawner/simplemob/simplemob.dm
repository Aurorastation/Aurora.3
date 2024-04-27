/datum/ghostspawner/simplemob/spawn_mob(mob/user)
	//Select a spawnpoint (if available)
	if(loc_type == GS_LOC_POS)
		var/turf/T = select_spawnlocation()
		var/mob/living/simple_animal/S
		if (T)
			S = new spawn_mob(T)
		else
			to_chat(user, "<span class='warning'>Unable to find any spawn point. </span>")
			return

		if(S)
			announce_ghost_joinleave(user, 0, "They are now a [name].")
			S.ckey = user.ckey

		return S
	else
		var/mob/living/simple_animal/S = select_spawnatom()
		if(!S)
			to_chat(user, "<span class='warning'>Unable to find any spawn mob. </span>")
			return

		announce_ghost_joinleave(user, 0, "They are now a [name].")
		return S.assign_player(user)
