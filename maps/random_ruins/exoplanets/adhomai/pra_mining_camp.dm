/datum/map_template/ruin/exoplanet/pra_mining_camp
	name = "People's Republic Mining Camp"
	id = "pra_mining_camp"
	description = "A Hadiist mining operation supported by megacorporations."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/pra_mining_camp.dmm")

/area/pra_mining_camp
	name = "People's Republic Mining Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "The sound of heavy machinery is heard around this camp."

//ghostroles

/datum/ghostspawner/human/adhomai_pra_miner
	short_name = "adhomai_pra_miner."
	name = "Adhomai Corporate Miner"
	desc = "Work for a mining joint operation between the PRA and NanoTrasen."
	tags = list("External")

	spawnpoints = list("adhomai_pra_miner")
	max_count = 3

	outfit = /obj/outfit/admin/adhomai_pra_miner
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tajaran Miner"
	special_role = "Tajaran Miner"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/adhomai_pra_miner
	name = "Adhomai Corporate Miner"

	uniform = /obj/item/clothing/under/tajaran/nt
	head = /obj/item/clothing/head/hardhat
	shoes = /obj/item/clothing/shoes/workboots/tajara
	belt = /obj/item/storage/belt/mining
	back = /obj/item/storage/backpack/industrial

	l_ear = null

	id = /obj/item/card/id

	backpack_contents = list(/obj/item/storage/wallet/random = 1)

/datum/ghostspawner/human/adhomai_pra_miner_teslabody
	short_name = "adhomai_pra_miner_teslabody."
	name = "Tesla Rejuvenation Suit Mining Worker"
	desc = "Work for a mining joint operation between the PRA and NanoTrasen as a Tajara grafted into a Tesla Rejuvenation Body."
	tags = list("External")

	spawnpoints = list("adhomai_pra_miner_teslabody")
	max_count = 1

	outfit = /obj/outfit/admin/adhomai_pra_miner_teslabody
	possible_species = list(SPECIES_TAJARA_TESLA_BODY)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tesla Rejuvenation Suit Mining Worker"
	special_role = "Tesla Rejuvenation Suit Mining Worker"
	respawn_flag = null

	uses_species_whitelist = TRUE

/obj/outfit/admin/adhomai_pra_miner_teslabody
	name = "Tesla Rejuvenation Suit Mining Worker"

	uniform = /obj/item/clothing/under/tajaran/tesla_body
	back = /obj/item/storage/backpack/industrial

	l_ear = null

	id = /obj/item/card/id
