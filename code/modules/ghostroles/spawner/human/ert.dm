/datum/ghostspawner/human/ert
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

/datum/ghostspawner/human/ert/select_spawnpoint(var/use=TRUE)
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

//Nanotrasen ERT
/datum/ghostspawner/human/ert/nanotrasen
	name = "Nanotrasen Responder"
	short_name = "ntert"
	desc = "You're a responder of the Nanotrasen Phoenix ERT! Assist the station as needed. War is hell."
	max_count = 2
	outfit = /datum/outfit/admin/ert/nanotrasen
	mob_name_prefix = "Tpr."

/datum/ghostspawner/human/ert/nanotrasen/specialist
	name = "Nanotrasen Engineering Specialist"
	short_name = "nteng"
	desc = "You're an engineering specialist of the Nanotrasen Phoenix ERT! Assist the station as needed."
	max_count = 1
	outfit = /datum/outfit/admin/ert/nanotrasen/specialist
	mob_name_prefix = "S/Tpr."

/datum/ghostspawner/human/ert/nanotrasen/specialist/med
	name = "Nanotrasen Medical Specialist"
	short_name = "ntmed"
	desc = "You're a medical specialist of the Nanotrasen Phoenix ERT! Assist the station as needed."
	outfit = /datum/outfit/admin/ert/nanotrasen/specialist/medical

/datum/ghostspawner/human/ert/nanotrasen/leader
	name = "Nanotrasen Leader"
	short_name = "ntlead"
	desc = "You're the leader of the Nanotrasen Phoenix ERT! Assist the station as needed. Remember that you're in charge here."
	max_count = 1
	mob_name_prefix = "L/Tpr."

//TCFL ERT
/datum/ghostspawner/human/ert/tcfl
	name = "TCFL Responder"
	short_name = "tcflr"
	desc = "The Tau Ceti Foreign Legion works for the Republic of Biesel; your job is to protect [current_map.company_name]. There is a code red alert on [station_name()], you are tasked to go and fix the problem."
	max_count = 3
	outfit = /datum/outfit/admin/ert/legion

/datum/ghostspawner/human/ert/tcfl/specialist
	name = "TCFL Medical Specialist"
	short_name = "tcfls"
	max_count = 2
	outfit = /datum/outfit/admin/ert/legion/specialist
	mob_name_prefix = "Lgn."

/datum/ghostspawner/human/ert/tcfl/leader
	name = "TCFL Leader"
	short_name = "tcfll"
	max_count = 1
	mob_name_prefix = "Pfct."

//Mercenary ERT
/datum/ghostspawner/human/ert/mercenary
	name = "Mercenary Responder"
	short_name = "mercr"
	max_count = 2
	desc = "Part of a freelancing mercenary crew, you're a neutral party whose intentions should be swayed by who has the biggest amount of money available."
	outfit = /datum/outfit/admin/ert/mercenary

/datum/ghostspawner/human/ert/mercenary/specialist
	name = "Mercenary Medical Specialist"
	short_name = "mercs"
	max_count = 1
	outfit = /datum/outfit/admin/ert/mercenary/specialist

/datum/ghostspawner/ert/mercenary/leader
	name = "Mercenary Leader"
	short_name = "mercl"
	max_count = 1
	outfit = /datum/outfit/admin/ert/mercenary/leader
