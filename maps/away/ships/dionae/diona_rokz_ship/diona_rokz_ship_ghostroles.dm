//Dionae Rokz Ship

/datum/ghostspawner/human/rokz_voidtamer
	short_name = "rokz_voidtamer"
	name = "Rokz Clan Voidtamer"
	desc = "A Member of the Rokz clan of Dionae voidtamers, a group known for selling products associated with space xenofauna as well as occasional live specimens. Generally will have appearances consistent with Unathi due to most of the clan members coming from in or around Moghes. (Info on the faction is located in the Dionae minor factions page.)"
	tags = list("External")

	spawnpoints = list("rokz_voidtamer")
	max_count = 2

	outfit = /datum/outfit/admin/rokz_voidtamer

	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	uses_species_whitelist = FALSE

	assigned_role = "Rokz Clan Voidtamer"
	special_role = "Rokz Clan Voidtamer"
	respawn_flag = null

/datum/outfit/admin/rokz_voidtamer
	name = "Rokz Clan Voidtamer"
	uniform = /obj/item/clothing/under/unathi
	suit = /obj/item/clothing/suit/diona/rokz
	back = /obj/item/storage/backpack/satchel/leather
	id = null
	l_ear = /obj/item/device/radio/headset/ship
	l_pocket = /obj/item/device/radio
	backpack_contents = list(/obj/item/device/flashlight/lantern = 1, /obj/item/device/flashlight/survival = 1)

/datum/outfit/admin/serz_voidtamer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = #6D3175

/datum/ghostspawner/human/rokz_voidtamer/captain
	short_name = "rokz_voidtamer_captain"
	name = "Rokz Clan Voidtamer Captain"
	desc = "Dionae captain of the Rokz ship. Generally will have appearances consistent with Unathi due to most of the clan members coming from in or around Moghes."

	spawnpoints = list("rokz_voidtamer_captain")
	max_count = 1

	outfit = /datum/outfit/admin/rokz_voidtamer/captain

	uses_species_whitelist = TRUE

	assigned_role = "Rokz Clan Voidtamer Captain"
	special_role = "Rokz Clan Voidtamer Captain"


/datum/outfit/admin/rokz_voidtamer/captain
	name = "Rokz Clan Voidtamer Captain"

	uniform = /obj/item/clothing/under/unathi
	head = /obj/item/clothing/head/diona/rokz
	back = /obj/item/storage/backpack/satchel/hegemony
	id = null
	l_ear = /obj/item/device/radio/headset/ship
	l_pocket = /obj/item/device/radio
	backpack_contents = list(/obj/item/device/flashlight/lantern = 1, /obj/item/device/flashlight/survival = 1)
