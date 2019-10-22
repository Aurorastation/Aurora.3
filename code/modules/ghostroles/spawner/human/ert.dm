/datum/ghostspawner/human/ert
	tags = list("External")

	enabled = FALSE
	req_perms = null
	max_count = 5

	spawnpoints = list("ERTSpawn")

	//Vars related to human mobs
	possible_species = list("Human","Skrell","Tajara","Unathi")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Emergency Responder"
	special_role = "Emergency Responder"
	respawn_flag = null

	mob_name_pick_message = "Pick a callsign or last-name."

	mob_name = null

//Nanotrasen ERT
/datum/ghostspawner/human/ert/nanotrasen
	name = "Nanotrasen Responder"
	short_name = "ntert"
	desc = "A responder of the Nanotrasen Phoenix ERT."
	welcome_message = "You're part of the Nanotrasen Phoenix ERT, stationed at the Odin. Your usual powers apply here."
	max_count = 2
	outfit = /datum/outfit/admin/ert/nanotrasen
	mob_name_prefix = "Tpr. "
	spawnpoints = list("NTERTSpawn")

/datum/ghostspawner/human/ert/nanotrasen/specialist
	name = "Nanotrasen Engineering Specialist"
	short_name = "nteng"
	desc = "An engineering specialist of the Nanotrasen Phoenix ERT."
	max_count = 1
	outfit = /datum/outfit/admin/ert/nanotrasen/specialist
	mob_name_prefix = "S/Tpr. "

/datum/ghostspawner/human/ert/nanotrasen/specialist/med
	name = "Nanotrasen Medical Specialist"
	short_name = "ntmed"
	desc = "A medical specialist of the Nanotrasen Phoenix ERT."
	outfit = /datum/outfit/admin/ert/nanotrasen/specialist/medical

/datum/ghostspawner/human/ert/nanotrasen/leader
	name = "Nanotrasen Leader"
	short_name = "ntlead"
	desc = "The leader of the Nanotrasen Phoenix ERT."
	max_count = 1
	mob_name_prefix = "L/Tpr. "

//TCFL ERT
/datum/ghostspawner/human/ert/tcfl
	name = "TCFL Responder"
	short_name = "tcflr"
	desc = "The Tau Ceti Foreign Legion's rank and file."
	welcome_message = "The Tau Ceti Foreign Legion works for the Republic of Biesel; your job is to protect the place you're heading to and fix the problem. You can be a volounteer (Vol.) or a legionnaire (Lgn.). The former is reccomended for new players."
	max_count = 3
	outfit = /datum/outfit/admin/ert/legion
	spawnpoints = list("TCFLERTSpawn")
	possible_species = list("Human", "Tajara", "Skrell", "Unathi", "Vaurca Warrior", "Vaurca Worker", "Machine")

/datum/ghostspawner/human/ert/tcfl/specialist
	name = "TCFL Medical Specialist"
	short_name = "tcfls"
	max_count = 2
	desc = "A medic of the Tau Ceti Foreign Legion."
	outfit = /datum/outfit/admin/ert/legion/specialist
	mob_name_prefix = "Lgn. "

/datum/ghostspawner/human/ert/tcfl/leader
	name = "TCFL Leader"
	short_name = "tcfll"
	max_count = 1
	mob_name_prefix = "Pfct. "

//Mercenary ERT
/datum/ghostspawner/human/ert/mercenary
	name = "Mercenary Responder"
	short_name = "mercr"
	max_count = 2
	desc = "Rank and file of a freelancer mercenary team."
	welcome_message = "You're part of a freelancing mercenary team who just picked up a distress beacon coming from the Aurora. You have no affiliation to anyone, but you sure do want a quick buck."
	outfit = /datum/outfit/admin/ert/mercenary
	possible_species = list("Human", "Tajara", "Skrell", "Unathi", "Vaurca Warrior", "Vaurca Worker", "Machine")

/datum/ghostspawner/human/ert/mercenary/specialist
	name = "Mercenary Medical Specialist"
	short_name = "mercs"
	max_count = 1
	desc = "The only medic of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/specialist

/datum/ghostspawner/human/ert/mercenary/leader
	name = "Mercenary Leader"
	short_name = "mercl"
	max_count = 1
	desc = "The leader of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/leader
