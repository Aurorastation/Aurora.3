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