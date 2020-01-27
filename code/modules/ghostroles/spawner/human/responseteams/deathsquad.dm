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