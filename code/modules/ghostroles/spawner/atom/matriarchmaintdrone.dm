/datum/ghostspawner/matriarchmaintdrone
	short_name = "matriarchmaintdrone"
	name = "Matriarch Maintenance Drone"
	desc = "Delegate tasks to your lesser maintenance drones. Maintain and Improve the Systems on the Aurora."
	show_on_job_select = FALSE
	tags = list("Simple Mobs")

	req_head_whitelist = TRUE // basically a chief engineer for drones

	loc_type = GS_LOC_ATOM
	atom_add_message = "A matriarch maintenance drone is now available!"

	spawn_mob = /mob/living/silicon/robot/drone/construction/matriarch

/datum/ghostspawner/matriarchmaintdrone/spawn_mob(mob/user)
	var/drone_name = sanitizeSafe(input(user, "Select a first-name suffix for your maintenance drone, for example, 'Bishop' would appear as 'matriach maintenance drone (Bishop)'. (Max length: 16 Characters)", "Name Suffix Selection"), 16)
	if(!drone_name)
		drone_name = pick("Ripley", "Tano", "Data")
	var/mob/living/silicon/robot/drone/construction/matriarch/M = ..()
	if(M)
		M.real_name = "[initial(M.name)] ([drone_name])"
		M.name = M.real_name
		M.voice_name = M.real_name
		M.updatename()
	return M