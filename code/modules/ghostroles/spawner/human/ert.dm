/datum/ghostspawner/human/ert
	tags = list("Response Teams")

	enabled = FALSE
	req_perms = null
	max_count = 5

	spawnpoints = list("ERTSpawn")

	//Vars related to human mobs
	possible_species = list("Human", "Skrell", "Tajara", "M'sai Tajara", "Unathi", "Baseline Frame")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Emergency Responder"
	special_role = "Emergency Responder"
	respawn_flag = null

	mob_name_pick_message = "Pick a callsign or last-name."

	mob_name = null

/datum/ghostspawner/human/ert/post_spawn(mob/user)
	if(name)
		to_chat(user, "<span class='danger'><font size=3>You are [max_count > 1 ? "a" : "the"] [name]!</font></span>")
	return ..()

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
	possible_species = list("Human", "Skrell")

//TCFL ERT

/datum/ghostspawner/human/ert/tcfl
	name = "TCFL Volunteer"
	short_name = "tcflr"
	desc = "The Tau Ceti Foreign Legion's rank and file."
	welcome_message = "The Tau Ceti Foreign Legion works for the Republic of Biesel; your job is to protect the place you're heading to and fix the problem. You can be a Volunteer (Vol.), Legionnaire (Lgn.) or Prefect (Pfct.). The first option is recommended for new players."
	max_count = 3
	outfit = /datum/outfit/admin/ert/legion
	spawnpoints = list("TCFLERTSpawn")
	possible_species = list("Human", "Off-Worlder Human", "Tajara", "Tajara", "M'sai Tajara", "Zhan-Khazan Tajara", "Skrell", "Unathi", "Aut'akh Unathi", "Vaurca Warrior", "Vaurca Worker", "Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame", "Diona")
	mob_name_prefix = "Vol. "

/datum/ghostspawner/human/ert/tcfl/specialist
	name = "TCFL Legionnaire"
	short_name = "tcfls"
	max_count = 2
	desc = "An experienced Legionnaire of the TCFL."
	outfit = /datum/outfit/admin/ert/legion/specialist
	mob_name_prefix = "Lgn. "

/datum/ghostspawner/human/ert/tcfl/leader
	name = "TCFL Prefect"
	short_name = "tcfll"
	max_count = 1
	desc = "A leader of Task Force XIII - Fortune."
	outfit = /datum/outfit/admin/ert/legion/leader
	mob_name_prefix = "Pfct. "
	spawnpoints = list("TCFLERTSpawn - Prefect")

/datum/ghostspawner/human/ert/tcfl/pilot
	name = "TCFL Dropship Pilot"
	short_name = "tcflpl"
	max_count = 1
	desc = "A dropship pilot of the TCFL."
	welcome_message = "As a pilot of the Tau Ceti Foreign Legion, your job is to pilot your assigned dropship and keep it safe from any hostile forces. You may also have to assist the main task force in a supporting role if the need arises."
	outfit = /datum/outfit/admin/ert/legion/pilot
	mob_name_prefix = "PL. "
	spawnpoints = list("TCFLERTSpawn - Pilot")

//Mercenary ERT
/datum/ghostspawner/human/ert/mercenary
	name = "Mercenary Responder"
	short_name = "mercr"
	max_count = 2
	desc = "Rank and file of a freelancer mercenary team."
	welcome_message = "You're part of a freelancing mercenary team who just picked up a distress beacon coming from the Aurora. You have no affiliation to anyone, but you sure do want a quick buck."
	outfit = /datum/outfit/admin/ert/mercenary
	possible_species = list("Human", "Off-Worlder Human", "Tajara", "M'sai Tajara", "Zhan-Khazan Tajara", "Skrell", "Diona", "Unathi", "Vaurca Warrior", "Vaurca Worker", "Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")

/datum/ghostspawner/human/ert/mercenary/specialist
	name = "Mercenary Medical Specialist"
	short_name = "mercs"
	max_count = 1
	desc = "The only medic of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/specialist

/datum/ghostspawner/human/ert/mercenary/engineer
	name = "Mercenary Combat Engineer"
	short_name = "merce"
	max_count = 1
	desc = "The only dedicated engineer of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/engineer

/datum/ghostspawner/human/ert/mercenary/leader
	name = "Mercenary Leader"
	short_name = "mercl"
	max_count = 1
	desc = "The leader of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/leader

// Deathsquads, spawn via admin intervention only.

/datum/ghostspawner/human/ert/deathsquad
	name = "NT Asset Protection Specialist"
	short_name = "ntaps"
	max_count = 3
	desc = "Protectors of NanoTrasen's bottom line. The last thing you never see."
	welcome_message = "The NSS Aurora has been compromised. Recover NanoTrasen assets by any means necessary. Crew expendable."
	outfit = /datum/outfit/admin/deathsquad
	spawnpoints = list("DeathERTSpawn")
	possible_species = list("Human")
	mob_name_prefix = "Spec. "

	var/deployed = TRUE

/datum/ghostspawner/human/ert/deathsquad/leader
	name = "NT Asset Protection Leader"
	short_name = "ntapl"
	max_count = 1
	desc = "Leader of NT's Asset Protection team."
	outfit = /datum/outfit/admin/deathsquad/leader
	mob_name_prefix = "Ldr. "

/datum/ghostspawner/human/ert/deathsquad/post_spawn(mob/user)
	var/datum/martial_art/sol_combat/F = new/datum/martial_art/sol_combat(null)
	F.teach(user)

	return ..()

/datum/ghostspawner/human/ert/commando
	name = "Syndicate Commando"
	short_name = "syndc"
	max_count = 3
	desc = "Well-equipped commandos of the criminal Syndicate."
	welcome_message = "The order has been given - the Aurora and its crew are to be wiped off the star-charts, by any means necessary."
	outfit = /datum/outfit/admin/deathsquad/syndicate
	spawnpoints = list("SyndERTSpawn")

/datum/ghostspawner/human/ert/commando/leader
	name = "Syndicate Commando Leader"
	short_name = "syndl"
	max_count = 1
	desc = "The leader of the Syndicate's elite commandos."
	outfit = /datum/outfit/admin/deathsquad/syndicate/leader

/datum/ghostspawner/human/ert/commando/post_spawn(mob/user)
	var/datum/martial_art/sol_combat/F = new/datum/martial_art/sol_combat(null)
	F.teach(user)

	return ..()

//Kataphract ERT
/datum/ghostspawner/human/ert/kataphract
	name = "Kataphract-Hopeful"
	short_name = "kathope"
	desc = "A Zo'saa (squire) of the local Kataphract Guild."
	welcome_message = "You're part of the local Kataphract guild, a knight-like organization of Unathi who roam the galaxy to do good. You've picked up a distress signal coming from the NSS Aurora, owned by Nanotrasen. You prefer to use melee weaponry, but will pull out your emergency pistol in a pinch. <span class='danger'>Remember to roleplay like an Unathi, even if you aren't whitelisted for it! Set auto-hiss in the OOC tab to basic or full.</span>"
	max_count = 2
	outfit = /datum/outfit/admin/ert/kataphract
	mob_name_prefix = "Zosaa "
	uses_species_whitelist = FALSE // Anyone should be able to play a Kataphract Unathi
	possible_species = list("Unathi")
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)

/datum/ghostspawner/human/ert/kataphract/klax
	name = "Kataphract-Hopeful Klaxan"
	short_name = "katklax"
	desc = "A Zo'saa (squire) from the K'lax hive, here to learn from Unathi Knights what it means to be honourable."
	welcome_message = "You're part of the local Kataphract guild, a knight-like organization of Unathi who roam the galaxy to do good. You've picked up a distress signal coming from the NSS Aurora, owned by Nanotrasen. You prefer to use melee weaponry, but will pull out your emergency pistol in a pinch. Let the Unathi teach you how to become an honourable Knight, follow their lead. Achieve glory for the hive!"
	max_count = 1
	outfit = /datum/outfit/admin/ert/kataphract/klax
	mob_name_prefix = "Zosaa "
	req_species_whitelist = "Vaurca" // Kataphract K'lax would be more difficult
	possible_species = list("Vaurca Warrior")
	extra_languages = list(LANGUAGE_VAURCA)

/datum/ghostspawner/human/ert/kataphract/specialist
	name = "Kataphract-Hopeful Specialist"
	short_name = "katspec"
	desc = "A Zo'saa (squire) trained in medicine from the local Kataphract guild."
	max_count = 1
	outfit = /datum/outfit/admin/ert/kataphract/specialist
	mob_name_prefix = "Zosaa "

/datum/ghostspawner/human/ert/kataphract/leader
	name = "Kataphract Knight"
	short_name = "katlead"
	desc = "A brave Saa (Knight) of the local Kataphract Guild. Two together operate as leaders of the team."
	max_count = 2
	outfit = /datum/outfit/admin/ert/kataphract/leader
	mob_name_prefix = "Saa "