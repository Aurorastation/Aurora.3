//Dionae Serz Ship

/datum/ghostspawner/human/serz_voidtamer
	short_name = "serz_voidtamer"
	name = "Serz Clan Voidtamer"
	desc = "A Member of the Serz clan of Dionae voidtamers, a group known for selling products associated with space xenofauna as well as occasional live specimens. Generally will have apperances consistent with Unathi due to most of the clan members coming from in or around Moghes. (Info on the faction is located in the Dionae minor factions page.)"
	tags = list("External")

	spawnpoints = list("serz_voidtamer")
	max_count = 2

	outfit = /datum/outfit/admin/serz_voidtamer

	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	uses_species_whitelist = FALSE

	assigned_role = "Serz Clan Voidtamer"
	special_role = "Serz Clan Voidtamer"
	respawn_flag = null

/datum/outfit/admin/serz_voidtamer
	name = "Serz Clan Voidtamer"

	uniform = /obj/item/clothing/under/unathi/zozo


	suit = /obj/item/clothing/suit/diona/serz

	back = list(
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/satchel/hegemony
	)

	id = null
	
	l_ear = /obj/item/device/radio/headset/ship

	l_pocket = /obj/item/device/radio

	backpack_contents = list(/obj/item/device/flashlight/lantern = 1, /obj/item/device/flashlight/survival = 1)

/datum/outfit/admin/serz_voidtamer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = "#6D3175"

/datum/ghostspawner/human/serz_voidtamer/captain
	short_name = "serz_voidtamer_captain"
	name = "Serz Clan Voidtamer Captain"
	desc = "Dionae captain of the Serz ship. Generally will have apperances consistent with Unathi due to most of the clan members coming from in or around Moghes."

	spawnpoints = list("serz_voidtamer_captain")
	max_count = 1

	outfit = /datum/outfit/admin/serz_voidtamer/captain

	uses_species_whitelist = TRUE

	assigned_role = "Serz Clan Voidtamer Captain"
	special_role = "Serz Clan Voidtamer Captain"


/datum/outfit/admin/serz_voidtamer/captain
	name = "Serz Clan Voidtamer Captain"
	uniform = /obj/item/clothing/under/unathi/zozo
	back = /obj/item/storage/backpack/satchel/hegemony
	id = null
	l_pocket = /obj/item/device/radio
	l_ear = /obj/item/device/radio/headset/ship
	backpack_contents = list(/obj/item/device/flashlight/lantern = 1, /obj/item/device/flashlight/survival = 1)

/datum/outfit/admin/serz_voidtamer/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = "#6D3175"
