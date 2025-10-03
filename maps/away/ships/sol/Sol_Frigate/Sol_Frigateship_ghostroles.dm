/datum/ghostspawner/human/ssrm_navy_crewman/solfrig_crewman
	short_name = "solfrig_crewman"
	name = "Solarian Frigate Crewman"
	desc = "\
	Crew a Solarian Naval Frigate, under the command of either the Northern or Southern Solarian Reconstruction Mandate. Serve and protect the interests of the Alliance, \
	whever you are. (NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, \
	and Colettish accents for the North.) \
	"

	spawnpoints = list("solfrig_crewman")
	max_count = 3

	assigned_role = "Solarian Frigate Crewman"
	special_role = "Solarian Frigate Crewman"

/datum/ghostspawner/human/ssrm_navy_crewman/solfrig_commander
	short_name = "solfrig_commander"
	name = "Solarian Frigate Commander"
	desc = "\
	Command a Solarian Naval Frigate, under the authority of either the Northern or Southern Solarian Reconstruction Mandate. \
	Serve and defend the interests of the Solarian Government, wherever you are assigned to. Praying for a more prestigious command is optional \
	(NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, \
	and San Colettish accents for the North.) \
	"
	mob_name_prefix = "CDR. "

	spawnpoints = list("solfrig_commander")
	max_count = 1

	outfit = /obj/outfit/admin/ssrm_navy_officer

	assigned_role = "Solarian Frigate Commander"
	special_role = "Solarian Frigate Commander"

/datum/ghostspawner/human/ssrm_navy_crewman/solfrig_xo
	short_name = "solfrig_xo"
	name = "Solarian Frigate Lieutenant"
	desc = "\
	Serve as the Executive Officer aboard a Solarian Naval Frigate, under the authority of either the Northern or Southern Solarian Reconstruction Mandate. \
	Follow the orders of your Captain, and defend the interests of the Solarian Alliance. No matter where you are. \
	(NOTE: It is recommended to use appropirate accents and origins depending on which region of the Spur you are in; Visegradi accents for the South, and San Colettish \
	accents for the North.) "
	mob_name_prefix = "LT. "

	spawnpoints = list("solfrig_xo")
	max_count = 1

	outfit = /obj/outfit/admin/ssrm_navy_chief_petty_officer/solfrig_xo

	assigned_role = "Solarian Frigate Executive Officer"
	special_role = "Solarian Frigate Executive Officer"

/obj/outfit/admin/ssrm_navy_chief_petty_officer/solfrig_xo
	name = "Solarian Frigate Executive Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/ssrm_ship

	l_ear = /obj/item/device/radio/headset/ship

/obj/outfit/admin/ssrm_navy_chief_petty_officer/solfrig_xo/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/ssrm_ipc/solfrig_ipc
	short_name = "solfrig_ipc"
	name = "Solarian Frigate Synthetic"
	desc = "\
	Serve as a Navy-owned IPC aboard a Solarian Frigate. Remember that you are not a free, enlisted soldier: you are the military's non-combatant property, \
	programmed to rigidly serve the interests of the Solarian government above all else. \
	"

	spawnpoints = list("solfrig_ipc")
	max_count = 1

	outfit = /obj/outfit/admin/ssrm_ipc

	assigned_role = "Sol Navy Synthetic"
	special_role = "Sol Navy Synthetic"

