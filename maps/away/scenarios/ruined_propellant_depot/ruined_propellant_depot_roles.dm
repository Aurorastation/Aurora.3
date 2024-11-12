
// --------------------- roles

/singleton/role/ruined_propellant_depot
	name = "Propellant Depot Crew"
	desc = "You are the depot's basic crew and worker. Perhaps you are a cargo technician, or the depot's chef, a janitor, or a jack-of-all-trades helper that does a bit of everything."
	outfit = /obj/outfit/admin/generic/ruined_propellant_depot_crew

/singleton/role/ruined_propellant_depot/engineer
	name = "Propellant Depot Engineer"
	desc = "You are an engineer in charge of keeping the depot functioning."
	outfit = /obj/outfit/admin/generic/ruined_propellant_depot_crew/engineer

/singleton/role/ruined_propellant_depot/director
	name = "Propellant Depot Director"
	desc = "You are the director of this depot. You were assigned here to make sure this depot is always fully stocked with propellant, and can sell it to any passing ships."
	outfit = /obj/outfit/admin/generic/ruined_propellant_depot_crew/director

// --------------------- outfits

/obj/outfit/admin/generic/ruined_propellant_depot_crew
	name = "Propellant Depot Crew Uniform"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/id/silver
	l_pocket = /obj/item/device/radio/hailing
	r_pocket = /obj/item/portable_map_reader
	r_hand = list(
		/obj/item/device/flashlight/on,
		/obj/item/device/flashlight/lantern/on,
		/obj/item/device/flashlight/maglight/on,
		/obj/item/device/flashlight/heavy/on,
	)

/obj/outfit/admin/generic/ruined_propellant_depot_crew/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RUINED_PROPELLANT_DEPOT,
	)

/obj/outfit/admin/generic/ruined_propellant_depot_crew/engineer
	name = "Propellant Depot Engineer Uniform"

	uniform = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/color/lightbrown,
		/obj/item/clothing/under/color/darkblue,
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/overalls,
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest/green,
		/obj/item/clothing/suit/storage/hazardvest/red,
	)
	belt = list(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/utility/very_full,
		/obj/item/storage/belt/utility/atmostech,
	)
	head = list(
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat/orange,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/hardhat/green,
	)
	glasses = null
	gloves = list(
		/obj/item/clothing/gloves/yellow,
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
	)
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/yellow/specialu,
		SPECIES_TAJARA = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/yellow/specialt,
	)

/obj/outfit/admin/generic/ruined_propellant_depot_crew/director
	name = "Propellant Depot Director Uniform"

	uniform = /obj/random/suit
	suit = null
	shoes = /obj/item/clothing/shoes/laceup

	back = list(
		/obj/item/storage/backpack/satchel/leather,
	)
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/random/suit,
	)
