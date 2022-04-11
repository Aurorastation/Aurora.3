/datum/ghostspawner/mining_drone
	short_name = "mining_drone"
	name = "Mining Drone"
	desc = "Join in as a Mining Drone, assist the miners, get lost on the asteroid and cry synthetic tears."
	show_on_job_select = FALSE
	tags = list("Stationbound")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"
	loc_type = GS_LOC_ATOM
	atom_add_message = "Someone is attempting to reboot a mining drone!"

	spawn_mob = /mob/living/silicon/robot/drone/mining

/datum/ghostspawner/mining_drone/spawn_mob(mob/user)
	var/drone_tag = sanitizeSafe(input(user, "Select a tag for your mining drone, for example, 'MD' would appear as 'NT-MD-[rand(100,999)]'. (Max length: 3 Characters)", "Name Tag Selection"), 4)
	if(!drone_tag)
		drone_tag = "MD"
	drone_tag = uppertext(drone_tag)
	var/mob/living/silicon/robot/drone/mining/M = ..()
	if(M)
		var/designation = "[drone_tag]-[rand(100,999)]"
		M.set_name("NT-[designation]")
		M.designation = designation
		assign_drone_to_matrix(M, current_map.station_short)
	return M
