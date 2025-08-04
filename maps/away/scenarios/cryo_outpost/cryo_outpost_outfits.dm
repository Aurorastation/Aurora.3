
// ------------------ base

/obj/outfit/admin/generic/cryo_outpost_crew
	name = "Desert Oasis Planet Outpost Crew Uniform"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/device/radio/headset/syndicate
	l_pocket = /obj/item/device/radio/hailing

/obj/outfit/admin/generic/cryo_outpost_crew/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CRYO_OUTPOST,
	)

// ------------------ merc

/obj/outfit/admin/generic/cryo_outpost_crew/mercenary
	name = "Clone Facility Mercenary"

	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/swat/ert
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel
	l_hand = /obj/item/clothing/suit/space/void/freelancer
	r_hand = /obj/item/clothing/head/helmet/space/void/freelancer
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/colt)
	id = /obj/item/card/id/syndicate
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	l_pocket = /obj/item/tank/emergency_oxygen/double

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/gun/projectile/automatic/tommygun = 1,
		/obj/item/storage/belt/utility/full = 1,
		/obj/item/clothing/gloves/yellow = 1,
	)

	belt_contents = list(
		/obj/item/ammo_magazine/submachinedrum = 1,
		/obj/item/ammo_magazine/submachinemag = 1,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/shield/energy = 1,
		/obj/item/material/knife/trench = 1
	)

// ------------------ merc medic

/obj/outfit/admin/generic/cryo_outpost_crew/mercenary/medic
	name = "Clone Facility Mercenary Medic"

	glasses = /obj/item/clothing/glasses/hud/health/aviator
	belt = /obj/item/storage/belt/medical/paramedic/combat
	gloves = /obj/item/clothing/gloves/latex

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/gun/projectile/automatic/tommygun = 1,
		/obj/item/ammo_magazine/submachinemag = 2,
		/obj/item/ammo_magazine/c45m = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/coagzolug = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/material/knife/trench = 1
	)

// ------------------ merc engineer

/obj/outfit/admin/generic/cryo_outpost_crew/mercenary/engineer
	name = "Clone Facility Mercenary Engineer"

	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/duffel
	gloves = /obj/item/clothing/gloves/yellow
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	accessory_contents = list(
								/obj/item/plastique = 5
							)

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/gun/projectile/shotgun/pump/combat/sol = 1,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/landmine/frag = 1,
		/obj/item/landmine/emp = 1,
		/obj/item/storage/belt/utility/very_full = 1,
		/obj/item/gun/projectile/colt = 1
	)

	belt_contents = list(
		/obj/item/material/knife/trench = 1,
		/obj/item/ammo_magazine/c45m = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/shield/energy = 1,
		/obj/item/device/flashlight/flare = 1,
	)

// ------------------ merc leader

/obj/outfit/admin/generic/cryo_outpost_crew/mercenary/leader
	name = "Clone Facility Mercenary Leader"

	l_hand = /obj/item/gun/projectile/automatic/rifle/shorty
	r_hand = null
	back = /obj/item/rig/merc/distress
	suit_store = null
	suit = null
	head = null
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/revolver = 1)

	backpack_contents = list()

	belt_contents = list(
		/obj/item/ammo_magazine/c762 = 2,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/shield/energy = 1,
		/obj/item/ammo_magazine/a357 = 2,
		/obj/item/material/knife/trench = 1
	)

// ------------------ director

/obj/outfit/admin/generic/cryo_outpost_crew/director
	name = "Clone Facility Director"

	uniform = /obj/item/clothing/under/rank/scientist/zeng
	suit = /obj/item/clothing/suit/storage/toggle/longcoat/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/gun/projectile/pistol = 1,
		/obj/item/ammo_magazine/mc9mm = 1,
		/obj/item/clothing/glasses/welding/superior = 1
	)

// ------------------ scientist

/obj/outfit/admin/generic/cryo_outpost_crew/scientist
	name = "Clone Facility Scientist"

	uniform = /obj/item/clothing/under/rank/scientist/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

// ------------------ engineer

/obj/outfit/admin/generic/cryo_outpost_crew/engineer
	name = "Clone Facility Engineer"

	uniform = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/color/lightbrown,
		/obj/item/clothing/under/color/darkblue,
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/overalls,
	)
	suit = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan,
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
		/obj/item/clothing/suit/storage/toggle/track,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest/green,
		/obj/item/clothing/suit/storage/hazardvest/red,
		/obj/item/clothing/suit/storage/hazardvest/white,
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
		/obj/item/clothing/gloves/brown,
		/obj/item/clothing/gloves/black_leather,
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
