/datum/ghostspawner
	var/short_name = null
	var/name = null
	var/desc = null

	//Vars regarding the spawnpoints and conditions of the spawner
	var/list/spawnpoints = list() //List of the applicable spawnpoints (by name)
	var/max_count = 0 //How often can this spawner be used
	var/count = 0 //How ofen has this spawner been used
	var/req_perms = null //What permission flags are required to use this spawner
	var/req_head_whitelist = FALSE //If a head of staff whitelist is required
	var/req_species_whitelist = null //Name/Datum of the species whitelist that is required, or null
	var/enabled = TRUE //If the spawnpoint is enabled
	var/enable_dmessage = TRUE //The message to send to deadchat if the ghostspawner is enabled or TRUE for a default message
	

	//Vars regarding the mob to use
	var/mob/spawn_mob = null //The mob that should be spawned
	var/list/variables = list() //Variables of that mob
	var/mob_name = null //The name of that mob; promots for placeholders such as %lastname
	
	
/datum/ghostspawner/proc/can_see(mob/user) //If the user can see the spawner in the menu
	if (req_perms) //Only those with the correct flags can see restricted roles
		if (check_rights(req_perms, show_msg=FALSE, user=user))
			return TRUE //Return early and dont perform whitelist checks if staff flags are met
		else
			return FALSE

	if(req_head_whitelist && !check_whitelist(user))
		return FALSE
	
	if(req_species_whitelist && !is_alien_whitelisted(user, req_species_whitelist))
		return FALSE

	return TRUE

/datum/ghostspawner/proc/can_spawn(mob/user) //If the user can spawn using the spawner
	if(!ROUND_IS_STARTED)
		return FALSE
	if (!can_see()) //If we cant see it, we cant spawn it
		return FALSE
	if (!enabled) //If the spawner id disabled, we cant spawn in
		return FALSE
	return TRUE

//Proc executed before someone is spawned in
/datum/ghostspawner/proc/pre_spawn(mob/user) 
	return TRUE

//The proc to actually spawn in the user
/datum/ghostspawner/proc/spawn_mob(mob/user)
	//Select a spawnpoint (if available)

	//Inform the spawnpoint that a mob has spawned (so it can update the sprite)

	//Actually spawn the mob

//Proc executed after someone is spawned in
/datum/ghostspawner/proc/post_spawn(mob/user) 
	return TRUE

//Proc to enable the ghostspawner
/datum/ghostspawner/proc/enable(mob/user)
	if(enable_dmessage)
		for(var/mob/abstract/observer/O in player_list)
			if(!O.MayRespawn())
				continue
			if(O.client && can_see(O))
				if (enable_dmessage == TRUE)
					to_chat(O, "<span class='deadsay'><b>A ghostspawner for a \"[src.name]\" has been enabled.</a></b></span>")
				else
					to_chat(O, "<span class='deadsay'><b>[enable_dmessage]</a></b></span>")
	enabled = TRUE
	return TRUE

//Proc to disable the ghostspawner
/datum/ghostspawner/proc/disable(mob/user)
	enabled = FALSE
	return TRUE
