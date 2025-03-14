//Police (access=218)

//Civilian (access=219)

//Benevolent Guild (access=249)
/datum/ghostspawner/human/konyang_benevolent
	short_name = "konyang_benevolent"
	name = "Benevolent Guild Muscle"
	desc = "Guard the hideout. Say goon phrases like 'sure thing, Boss.' Be big and scary so people listen to your boss. Remember that you're not an antagonist."
	tags = list("External")
	spawnpoints = list("konyang_goon")
	max_count = 1
	outfit = /obj/outfit/admin/konyang/goon
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Benevolent Guild Muscle"
	special_role = "Benevolent Guild Muscle"
	respawn_flag = null

/obj/outfit/admin/konyang/konyang_benevolent
	name = "Benevolent Guild Muscle"
	uniform = /obj/item/clothing/pants/tan
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = null
	l_pocket = /obj/item/storage/wallet/random
	r_pocket = /obj/item/material/knife/butterfly/switchblade
	back = /obj/item/storage/backpack/satchel

/datum/ghostspawner/human/konyang_benevolent/boss
	name = "Benevolent Guild Lieutenant"
	short_name = "konyang_benevolent_boss"
	desc = "Manage the local operations of Benevolent Guild. Keep your goons in line and away from police scrutiny. Collect money from\
	guild owned enterprises. Lament that you cant abduct IPC's anymore because there's a Trinary church next door now."
	max_count = 1
	spawnpoints = list("konyang_goon_boss")
	outfit = /obj/outfit/admin/konyang/mob_boss
	assigned_role = "5-Cheung Boss"
	special_role = "5-Cheung Boss"
	respawn_flag = null

/obj/outfit/admin/konyang/mob_boss
	name = "5-Cheung Boss"
	uniform = /obj/item/clothing/under/suit_jacket/white
	shoes = /obj/item/clothing/shoes/laceup
	wrist = /obj/item/clothing/wrists/watch/gold
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel/leather
	id = null
