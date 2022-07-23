/datum/ghostspawner/human/ert/deathsquad
	name = "SCC Asset Protection Specialist"
	short_name = "ntaps"
	max_count = 3
	desc = "Protectors of the SCC's bottom line. The last thing you never see."
	outfit = /datum/outfit/admin/deathsquad
	spawnpoints = list("DeathERTSpawn")
	possible_species = list(SPECIES_HUMAN)
	mob_name_prefix = "Spec. "

	var/deployed = TRUE

/datum/ghostspawner/human/ert/deathsquad/New()
	..()
	welcome_message = "The [current_map.station_name] has been compromised. Recover SCC assets by any means necessary. Crew expendable."

/datum/ghostspawner/human/ert/deathsquad/leader
	name = "SCC Asset Protection Leader"
	short_name = "ntapl"
	max_count = 1
	desc = "Leader of SCC's Asset Protection team."
	outfit = /datum/outfit/admin/deathsquad/leader
	mob_name_prefix = "Ldr. "

/datum/ghostspawner/human/ert/deathsquad/post_spawn(mob/user)
	var/datum/martial_art/sol_combat/F = new/datum/martial_art/sol_combat(null)
	F.teach(user)

	return ..()
