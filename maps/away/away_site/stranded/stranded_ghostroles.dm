/datum/ghostspawner/human/survivor
	short_name = "survivor"
	name = "Stranded Survivor"
	desc = "Whether due to system failures, piracy, or whatever reason you can think of, you had to abandon your ship using the escape pods and have been surviving on a seemingly desolate grove planet since. Today might just be the day you get rescued, but be wary, you could swear you've been hearing strange noises from past the trees during the nights..."
	tags = list("External")

	spawnpoints = list("survivor")
	max_count = 3
	enabled = FALSE

	away_site = TRUE

	outfit = /datum/outfit/admin/survivor
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Stranded Survivor"
	special_role = "Stranded Survivor"
	respawn_flag = null


/datum/outfit/admin/survivor
	name = "Stranded Survivor"

	uniform = /obj/item/clothing/under/color/brown
	shoes = /obj/item/clothing/shoes/brown
	back = /obj/item/storage/backpack/satchel/leather

	id = null

	l_ear = null

	backpack_contents = list(/obj/item/device/flashlight/lantern= 1)


/datum/ghostspawner/simplemob/vannatusk_ghostrole
	short_name = "vannatusk"
	name = "Vannatusk"
	desc = "Become a Vannatusk. A ferocious creature of mysterious origins."
	welcome_message = "You are a Vannatusk. A native of bluespace that now finds itself stranded in another dimension. Some time ago, a few of the creatures who manipulate your native dimension landed just north of your lair, and you have been observing them setting up shelter just north of where they landed. You decide now is the time for action, whatever that action will be is up to you. But if you choose to attack, try to build some suspense first."
	tags = list("External")
	spawnpoints = list("vannatusk")

	max_count = 1
	enabled = FALSE

	away_site = TRUE

	respawn_flag = null

	spawn_mob = /mob/living/simple_animal/hostile/vannatusk/ghostrole
