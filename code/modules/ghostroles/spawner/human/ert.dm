/datum/ghostspawner/human/ert
	short_name = "ert"
	name = "Responder"
	desc = "You're an emergency response team's rank and file!"
	tags = list("External")

	enabled = FALSE
	req_perms = null
	max_count = 5

	//Vars related to human mobs
	outfit = /datum/outfit/admin/random
	possible_species = list("Human","Skrell","Tajara","Unathi")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Emergency Responder"
	special_role = "Emergency Responder"
	respawn_flag = null

	mob_name = FALSE

	var/datum/responseteam/chosen_team
	var/list/slots = list(
		"Specialist" = 0,
		"Leader" = 0,
		"Grunt" = 0,
	)

/datum/ghostspawner/human/ert/New()
	. = ..()
	var/slot_tally = chosen_team.specialists + chosen_team.grunts + chosen_team.leaders
	max_count = slot_tally
	welcome_message = chosen_team.spawn_message
	outfit = chosen_team.grunt_outfit //Default grunt outfit
	possible_species = chosen_team.species
	slots["Specialist"] = chosen_team.specialists
	slots["Leader"] = chosen_team.leaders
	slots["Grunt"] = chosen_team.grunts

/datum/ghostspawner/human/ert/post_spawn(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	var/choice = get_choice(user)
	switch(choice)
		if("Specialist")
			H.preEquipOutfit(chosen_team.specialist_outfit)
			H.equipOutfit(chosen_team.specialist_outfit)
		if("Leader")
			H.preEquipOutfit(chosen_team.leader_outfit)
			H.equipOutfit(chosen_team.leader_outfit)

/datum/ghostspawner/human/ert/proc/get_choice(user)
	var/choice = alert(user, "Choose your class:", "Response Team", "Specialist", "Leader", "Grunt"))
	if(!handle_choice(choice, user))
		get_choice()
	return choice

/datum/ghostspawner/human/ert/proc/handle_choice(var/choice, mob/user)
	if(slots[choice] <= 0)
		to_chat(user, "<span class='warning'>There are no more [choice] slots!</span>")
		return 0
	else 
		slots[choice]--
		return 1

/datum/ghostspawner/human/rescuepodsurv/select_spawnpoint(var/use=TRUE)
	//Randomly select a Turf on the asteroid. TODO-MATT: Placeholder
	var/turf/T = pick_area_turf(/area/mine/unexplored)
	if(!use) //If we are just checking if we can get one, return the turf we found
		return T

	if(!T) //If we didnt find a turn, return now
		return null

	//Otherwise spawn a droppod at that location
	var/x = T.x
	var/y = T.y
	var/z = T.z

	new /datum/random_map/droppod(null,x,y,z,supplied_drop="custom",do_not_announce=TRUE,automated=FALSE)
	return get_turf(locate(x+1,y+1,z)) //Get the turf again, so we end up inside of the pod - There is probs a better way to do this
