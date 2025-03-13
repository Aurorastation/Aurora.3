// Generic crew uniform.
/obj/outfit/admin/generic/crumbling_station_crew
	name = "Commercial Installation Crew"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/navy
	l_pocket = /obj/item/device/radio/hailing
	r_pocket = /obj/item/portable_map_reader
	uniform = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/tactical,
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
	)
	r_hand = list(
		/obj/item/device/flashlight/on,
		/obj/item/device/flashlight/lantern/on,
		/obj/item/device/flashlight/maglight/on,
		/obj/item/device/flashlight/heavy/on,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/jackboots/toeless
	)


/obj/outfit/admin/generic/cryo_outpost_crew/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS
	)

// Crew engineer.
/obj/outfit/admin/generic/crumbling_station_crew/engineer
	name = "Commercial Installation Engineer"
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
	gloves = list(
		/obj/item/clothing/gloves/yellow,
	)
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/yellow/specialu,
		SPECIES_TAJARA = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/yellow/specialt,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/yellow/specialt,
	)

// Crew medic.
/obj/outfit/admin/generic/crumbling_station_crew/medic
	name = "Commercial Installation Medic"
	uniform = /obj/item/clothing/under/rank/medical/surgeon
	glasses = /obj/item/clothing/glasses/hud/health/aviator
	belt = /obj/item/storage/belt/medical/paramedic
	gloves = /obj/item/clothing/gloves/latex
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/coagzolug = 1
	)
	belt_contents = list(
		/obj/item/reagent_containers/hypospray = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
	)

// Highsec covers all roles that should have command access on the station.
ABSTRACT_TYPE(/obj/outfit/admin/generic/crumbling_station_crew/highsec)

/obj/outfit/admin/generic/cryo_outpost_crew/highsec/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CRUMBLING_STATION_COMMAND
	)

// Crew security guard.
/obj/outfit/admin/generic/crumbling_station_crew/highsec/security
	name = "Commercial Installation Security Guard"
	uniform = list(
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/under/color/darkblue,
	)
	back = list(
		/obj/item/storage/backpack/rucksack/blue,
		/obj/item/storage/backpack/rucksack/navy,
		/obj/item/storage/backpack/messenger/sec,
	)
	belt = list(
		/obj/item/storage/belt/security/full,
		/obj/item/storage/belt/security/full/alt,
	)
	gloves = list(
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/gloves/force/basic,
		/obj/item/clothing/gloves/black_leather,
	)
	head = list(
		/obj/item/clothing/head/beret/security,
		/obj/item/clothing/head/beret/security/officer,
		/obj/item/clothing/head/softcap/security,
	)
	glasses = list(
		/obj/item/clothing/glasses/sunglasses/aviator,
		/obj/item/clothing/glasses/sunglasses/sechud/aviator,
	)
	l_pocket = /obj/item/handcuffs/ziptie
	r_pocket = /obj/item/device/gps
	accessory = list (
		/obj/item/clothing/accessory/holster/armpit,
		/obj/item/clothing/accessory/holster/armpit/brown,
		/obj/item/clothing/accessory/holster/hip,
		/obj/item/clothing/accessory/holster/hip/brown,
		/obj/item/clothing/accessory/holster/thigh,
		/obj/item/clothing/accessory/holster/thigh/brown,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/clothing/accessory/holster/waist/brown,
	)
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/black_leather/unathi,
		SPECIES_TAJARA = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/black_leather/tajara,
	)

// Crew administrator.
/obj/outfit/admin/generic/crumbling_station_crew/highsec/administrator
	name = "Commercial Installation Administrator"
	r_hand = /obj/item/storage/secure/briefcase/money
	glasses = /obj/item/clothing/glasses/monocle
	uniform = list(
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/sl_suit,
	)
	gloves = list(
		/obj/item/clothing/gloves/black_leather,
		/obj/item/clothing/gloves/brown,
	)

// Civilian visitor role. May include any kind of visitor, intended to be on the proper side of the law. Not a member of the station's crew.
/obj/outfit/admin/generic/crumbling_station_crew/legal_visitor
	name = "Independent Spacer"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/box/fancy/cigarettes/acmeco,
		/obj/item/flame/lighter,
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/leather_jacket/biker,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer,
	)

// Criminal visitor role - lightly armed, may possess contraband. Not a member of the station's crew.
/obj/outfit/admin/generic/crumbling_station_crew/illegal_visitor
	name = "Independent Spacer"
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/gun/projectile/automatic/tommygun = 1,
		/obj/item/ammo_magazine/submachinemag = 2,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/material/kitchen/utensil/knife/boot,
		/obj/item/storage/box/fancy/cigarettes/acmeco,
		/obj/item/flame/lighter,
	)

	l_pocket = list(
		/obj/item/reagent_containers/hypospray/autoinjector/night_juice,
		/obj/item/reagent_containers/hypospray/autoinjector/impedrezene,
		/obj/item/storage/pill_bottle/spotlight,
		/obj/item/storage/pill_bottle/mortaphenyl,
		/obj/item/storage/pill_bottle/zoom,
	)
	r_pocket = list(
		/obj/item/material/knife/butterfly/switchblade,
		/obj/item/melee/energy/sword/knife,
	)
