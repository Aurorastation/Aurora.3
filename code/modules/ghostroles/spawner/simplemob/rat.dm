/datum/ghostspawner/simplemob/rat
	short_name = "rat"
	name = "Rat"
	desc = "Join as a Rat on the aurora, a common nuisance to the crew."
	welcome_message = "You are now a rat. Though you may interact with players, do not give any hints away that you are more than a simple rodent. Find food, avoid cats, and try to survive!"
	show_on_job_select = FALSE
	tags = list("Simple Mobs")

	respawn_flag = ANIMAL //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)

	//Vars regarding the mob to use
	spawn_mob = /mob/living/simple_animal/rat //The mob that should be spawned
	

//This proc selects the spawnpoint to use.
/datum/ghostspawner/simplemob/rat/select_spawnpoint()
	//find a viable mouse candidate
	var/obj/machinery/atmospherics/unary/vent_pump/spawnpoint = find_mouse_spawnpoint(pick(current_map.station_levels))
	return get_turf(spawnpoint)

/datum/ghostspawner/simplemob/rat/cant_see()
	if(config.disable_player_rats)
		return "Spawning as Rat is disabled"
	return ..()

//The proc to actually spawn in the user
/datum/ghostspawner/simplemob/rat/spawn_mob(mob/user)
	//Select a spawnpoint (if available)
	var/turf/T = select_spawnpoint()
	var/mob/living/simple_animal/S
	if (T)
		S = new spawn_mob(T)
	else
		to_chat(user, "<span class='warning'>Unable to find any safe, unwelded vents to spawn rats at. The station must be quite a mess!  Trying again might work, if you think there's still a safe place. </span>")

	if(S)
		if(config.uneducated_rats)
			S.universal_understand = 0
		announce_ghost_joinleave(user, 0, "They are now a [name].")
		S.ckey = user.ckey

	return S