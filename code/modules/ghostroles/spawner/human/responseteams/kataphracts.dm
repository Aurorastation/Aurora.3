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
	uses_species_whitelist = TRUE
	req_species_whitelist = "Vaurca Warrior" // Kataphract K'lax would be more difficult
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