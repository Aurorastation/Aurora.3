/datum/map_template/ruin/exoplanet/adhomai_sole_rock_nomad
	name = "Rock Nomad"
	id = "adhomai_sole_rock_nomad"
	description = "A single rock nomad wandering around."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)

	prefix = "adhomai/"
	suffix = "adhomai_sole_rock_nomad.dmm"

	unit_test_groups = list(3)

//ghost roles

/datum/ghostspawner/human/adhomai_sole_rock_nomad
	short_name = "adhomai_rock_nomad"
	name = "Rock Nomad"
	desc = "As a Rock Nomad, roam Adhomai on your trusty climber."
	tags = list("External")

	spawnpoints = list("adhomai_rock_nomad")
	max_count = 1

	extra_languages = list(LANGUAGE_DELVAHII)
	outfit = /obj/outfit/admin/adhomai_sole_rock_nomad
	possible_species = list(SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	origin_restriction  = list(/singleton/origin_item/origin/rhazar)
	culture_restriction = list(/singleton/origin_item/culture/adhomian)

	assigned_role = "Rock Nomad"
	special_role = "Rock Nomad"
	respawn_flag = null

/obj/outfit/admin/adhomai_sole_rock_nomad
	name = "Rock Nomad"

	pants = /obj/item/clothing/pants/tajaran
	head = /obj/item/clothing/head/tajaran/fur
	suit = /obj/item/clothing/suit/storage/toggle/tajaran/wool
	shoes = /obj/item/clothing/shoes/tajara/footwraps
	l_ear = null

	id = null
	l_pocket = /obj/item/ammo_magazine/boltaction
	r_pocket = /obj/item/ammo_magazine/boltaction

	belt = /obj/item/material/knife/trench
	back = /obj/item/gun/projectile/shotgun/pump/rifle
