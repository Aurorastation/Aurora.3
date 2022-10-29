/datum/ghostspawner/human/tirakqi_crew
	short_name = "tirakqi_crew"
	name = "Ti'Rakqi Qu'fup"
	desc = "You crew the ship, mop the floors, cook the meals, and shoot whoever gets too close to the goods. Try to show some initiative!"
	tags = list("External")

	spawnpoints = list("tirakqi_crew")
	max_count = 3

	outfit = /datum/outfit/admin/tirakqi_crew
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ti'Rakqi Qu'fup"
	special_role = "Ti'Rakqi Qu'fup"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/tirakqi_crew
	name = "Ti'Rakqi Qu'fup"

	uniform = list(
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/syndicate/tracksuit,
		/obj/item/clothing/under/pants/jeans,
		/obj/item/clothing/under/pants/camo,
		/obj/item/clothing/under/pants/khaki,
		/obj/item/clothing/under/pants/musthang,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/under/waiter
		)

	suit = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/accessory/poncho,
		/obj/item/clothing/accessory/overalls/random,
		/obj/item/clothing/suit/ianshirt,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random,
		/obj/item/clothing/suit/storage/hooded/wintercoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/red,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
		/obj/item/clothing/suit/storage/leathercoat,
		/obj/item/clothing/suit/storage/toggle/flannel,
		/obj/item/clothing/suit/storage/toggle/flannel/gray,
		/obj/item/clothing/suit/storage/toggle/flannel/red,
		/obj/item/clothing/suit/storage/toggle/leather_vest,
		/obj/item/clothing/suit/storage/toggle/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/biker,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/green,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/white,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/red,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan,
		/obj/item/clothing/suit/storage/toggle/trench,
		/obj/item/clothing/suit/storage/toggle/trench/grey,
		/obj/item/clothing/suit/storage/toggle/trench/colorable/random
	)

	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/combat,
		/obj/item/clothing/shoes/cowboy,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/winter,
		/obj/item/clothing/shoes/hitops/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/brown
	)

	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/tirakqi_crew/get_id_access()
	return list(access_skrell, access_external_airlocks)

/datum/outfit/admin/tirakqi_crew/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.h_style = pick("Headtails", "Headtails", "Long Headtails", "Short Headtails", "Very Short Headtails", "Short Headtails, tucked", "Short Headtails, slicked", "Headtails, behind")
	H.f_style = pick("Shaved", "Shaved", "Shaved", "Shaved", "Tuux Chin Patch", "Tuux Chops", "Tuux Tri-Point", "Tuux Monotail")

	H.r_skin = pick(50, 80, 100, 120, 140, 170)
	H.g_skin = pick(50, 80, 100, 120, 140, 170)
	H.b_skin = pick(50, 80, 100, 120, 140, 170)

	H.r_hair = H.r_skin - pick(0, 10, 20, 30)
	H.g_hair = H.g_skin - pick(0, 10, 20, 30)
	H.b_hair = H.b_skin - pick(0, 10, 20, 30)

	H.r_facial = H.r_hair
	H.g_facial = H.g_hair
	H.b_facial = H.b_hair

/datum/ghostspawner/human/tirakqi_captain
	short_name = "tirakqi_captain"
	name = "Ti'Rakqi Qu'oot"
	desc = "Lead the Qu'fup under your command. Smuggle, cheat, lie, and profit. You've got a crew and a ship to maintain."
	tags = list("External")

	spawnpoints = list("tirakqi_captain")
	max_count = 1

	outfit = /datum/outfit/admin/tirakqi_crew/captain
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ti'Rakqi Qu'oot"
	special_role = "Ti'Rakqi Qu'oot"
	respawn_flag = null

	uses_species_whitelist = TRUE

/datum/outfit/admin/tirakqi_crew/captain
	name = "Ti'Rakqi Qu'fup"

	uniform = list(
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/captainformal,
		/obj/item/clothing/under/pants/jeans,
		/obj/item/clothing/under/pants/camo,
		/obj/item/clothing/under/pants/khaki,
		/obj/item/clothing/under/pants/musthang,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/tactical
		)


/datum/ghostspawner/human/tirakqi_medic
	short_name = "tirakqi_medic"
	name = "Ti'Rakqi Medic"
	desc = "You're a trained doctor serving with the Ti'Rakqi! Try to keep the crew alive or you may find yourself stranded in space."
	tags = list("External")

	spawnpoints = list("tirakqi_medic")
	max_count = 1

	outfit = /datum/outfit/admin/tirakqi_crew/medic
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ti'Rakqi Medic"
	special_role = "Ti'Rakqi Medic"
	respawn_flag = null

	uses_species_whitelist = TRUE

/datum/outfit/admin/tirakqi_crew/medic
	name = "Ti'Rakqi Medic"

	uniform = /obj/item/clothing/under/rank/medical/surgeon
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	glasses = /obj/item/clothing/glasses/hud/health


/datum/ghostspawner/human/tirakqi_engineer
	short_name = "tirakqi_engineer"
	name = "Ti'Rakqi Engineer"
	desc = "You're a trained engineer serving with the Ti'Rakqi! Try to keep the ship functioning or you may find yourself stranded in space."
	tags = list("External")

	spawnpoints = list("tirakqi_engineer")
	max_count = 1

	outfit = /datum/outfit/admin/tirakqi_crew/engineer
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ti'Rakqi Engineer"
	special_role = "Ti'Rakqi Engineer"
	respawn_flag = null

	uses_species_whitelist = TRUE

/datum/outfit/admin/tirakqi_crew/engineer
	name = "Ti'Rakqi Engineer"

	uniform = /obj/item/clothing/under/service_overalls
	suit = /obj/item/clothing/accessory/storage/overalls
	belt = /obj/item/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/yellow
