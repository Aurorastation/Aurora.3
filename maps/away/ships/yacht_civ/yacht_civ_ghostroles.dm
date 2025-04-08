/datum/ghostspawner/human/yacht_civ
	short_name = "yacht_civ_crew"
	name = "Civilian Yacht Crew"
	desc = "An affluent owner of a private civilian yacht, shared with three other people. Be rich, seek adventure, see sights, explore stars."
	welcome_message = "\
		You are a member of crew on a private civilian yacht, owned by, and shared with three other people. \
		Perhaps you are friends or family, invested in some risky stocks or inherited all your assets, and want to to explore the stars together. \
		You are rich enough to afford a small yacht, to maintain it, and live in relative luxury, \
		and you are free to do anything you like, this is your vacation after all.\
		"
	tags = list("External")

	spawnpoints = list("yacht_civ_crew")
	max_count = 4

	outfit = /obj/outfit/admin/yacht_civ
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Civilian Yacht Crew"
	special_role = "Civilian Yacht Crew"
	respawn_flag = null

/obj/outfit/admin/yacht_civ
	name = "Civilian Yacht Crew"

	uniform = list(/obj/item/clothing/under/pj/red, /obj/item/clothing/under/pj/blue)
	wrist = list(/obj/item/clothing/wrists/watch/silver, /obj/item/clothing/wrists/watch/gold)
	l_ear = /obj/item/device/radio/headset/ship
	l_pocket = /obj/item/storage/wallet/rich
