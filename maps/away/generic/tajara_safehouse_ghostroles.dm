/datum/ghostspawner/human/tajaran_migrant
	short_name = "tajaran_migrant"
	name = "Tajaran Migrant"
	desc = "Survive and try to reach Tau Ceti."
	tags = list("External")

	spawnpoints = list("tajaran_migrant")
	max_count = 4

	outfit = /datum/outfit/admin/tajaran_migrant
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tajaran Migrant"
	special_role = "Tajaran Migrant"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/tajaran_migrant
	name = "Tajaran Migrant"

	uniform = list(
				/obj/item/clothing/under/tajaran,
				/obj/item/clothing/under/tajaran/nt,
				/obj/item/clothing/under/tajaran/summer,
				/obj/item/clothing/under/pants/tajaran
	)

	shoes = list(
				/obj/item/clothing/shoes/tajara/footwraps,
				/obj/item/clothing/shoes/tajara/jackboots,
				/obj/item/clothing/shoes/tajara/workboots,
				/obj/item/clothing/shoes/tajara/workboots/adhomian_boots
	)

	back = list(
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/duffel
	)

	id = null

	l_ear = null

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)


/datum/ghostspawner/human/tajara_revolutionary_army_agent
	short_name = "tajara_revolutionary_army_agent"
	name = "Tajaran Revolutionary Army Agent"
	desc = "Protect the Tajaran migrants."
	tags = list("External")

	spawnpoints = list("tajara_revolutionary_army_agent")
	max_count = 2

	outfit = /datum/outfit/admin/tajara_revolutionary_army_agent
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tajara Revolutionary Army Agent"
	special_role = "Tajara Revolutionary Army Agent"
	respawn_flag = null

/datum/outfit/admin/tajara_revolutionary_army_agent
	name = "Tajara Revolutionary Army Agent"

	uniform = list(
				/obj/item/clothing/under/syndicate,
				/obj/item/clothing/under/tajaran/summer,
				/obj/item/clothing/under/pants/tajaran
	)

	shoes = list(
				/obj/item/clothing/shoes/tajara/footwraps,
				/obj/item/clothing/shoes/tajara/jackboots
	)

	back = /obj/item/storage/backpack/duffel

	id = null

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1, /obj/item/gun/projectile/silenced = 1, /obj/item/ammo_magazine/c45m = 2)
