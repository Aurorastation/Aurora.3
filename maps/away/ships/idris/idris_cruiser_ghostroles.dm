/datum/ghostspawner/human/idris_cruiser_crew
	name = "Idris Cruise Crewmate"
	short_name = "idriscrew"
	desc = "Serve as the waiters, stewards, and maintenance crew of an Idris cruiser."
	tags = list("External")

	welcome_message = "You're a crewmember for an Idris cruise vessel. Keep your clients happy, your ship in tip-top shape, and your smile uniquely Idris!"

	spawnpoints = list("idriscrew")
	max_count = 4

	outfit = /datum/outfit/admin/idris_cruiser_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_SHELL)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Idris Cruise Crewmate"
	special_role = "Idris Cruise Crewmate"
	respawn_flag = null

/datum/outfit/admin/idris_cruiser_crew
	
