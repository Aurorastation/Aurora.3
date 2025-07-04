
// --- Basic gear

/obj/outfit/admin/generic/nuclear_silo_crew
	name = "Arctic Valley Citizen Uniform"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/id/syndicate
	l_pocket = /obj/item/device/radio/hailing

/obj/outfit/admin/generic/nuclear_silo_crew/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_NUCLEAR_MISSILE_SILO,
	)

/obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_NUCLEAR_MISSILE_SILO, ACCESS_NUCLEAR_MISSILE_SILO_HIGH,
	)
// --- Village
/obj/outfit/admin/generic/nuclear_silo_crew/upper/villager
	name = "Arctic Valley Villager"

	uniform = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/waiter,
	)
	suit = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/toggle/cardigan,
		/obj/item/clothing/suit/storage/toggle/flannel,
		/obj/item/clothing/suit/storage/toggle/flannel/red,
		/obj/item/clothing/suit/storage/toggle/greatcoat,
		/obj/item/clothing/suit/storage/toggle/greatcoat/brown,
		/obj/item/clothing/suit/storage/toggle/trench/green,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black,
	)
	head = list(
		/obj/item/clothing/head/beanie/random,
		/obj/item/clothing/head/beanie/submariner/random,
		/obj/item/clothing/head/beanie/earflap/random,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/softcap,
		/obj/item/clothing/head/wool,
	)
	glasses = null
	gloves = list(
		/obj/item/clothing/gloves/black_leather,
		/obj/item/clothing/gloves/mittens,
		/obj/item/clothing/gloves/fingerless,
	)
	shoes = list(
		/obj/item/clothing/shoes/sneakers,
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/shoes/sneakers/hitops/black,
		/obj/item/clothing/shoes/sneakers/hitops/red,
		/obj/item/clothing/shoes/winter,
		/obj/item/clothing/shoes/workboots,
	)
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/black_leather/unathi,
		SPECIES_TAJARA = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/black_leather/tajara,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/tajara,
	)

/obj/outfit/admin/generic/nuclear_silo_crew/upper/villager_business_owner
	name = "Arctic Valley Business Owner"

	uniform = list(
		/obj/item/clothing/under/zhongshan,
		/obj/item/clothing/under/suit_jacket/white,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/under/suit_jacket,
	)
	suit = null
	glasses = null
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/leyon)

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/storage/wallet/random = 1,
		/obj/item/ammo_magazine/mc10mm/leyon = 2,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/winter/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/laceup/tajara,
	)

//--- Bunker
/obj/outfit/admin/generic/nuclear_silo_crew/lower/silo_resident
	name = "Nuclear Missile Silo Resident"
	uniform = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/red,
		/obj/item/clothing/under/color/lightred,
	)

	suit = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/toggle/flannel,
		/obj/item/clothing/suit/storage/toggle/flannel/red,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black,
	)

	head = list(
		/obj/item/clothing/head/beanie/random,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/softcap,
	)
	glasses = null
	gloves = list(
		/obj/item/clothing/gloves/black_leather,
		/obj/item/clothing/gloves/fingerless,
	)

	shoes = list(
		/obj/item/clothing/shoes/sneakers,
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/shoes/sneakers/hitops/black,
		/obj/item/clothing/shoes/sneakers/hitops/red,
		/obj/item/clothing/shoes/workboots,
	)
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/black_leather/unathi,
		SPECIES_TAJARA = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/black_leather/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/black_leather/tajara,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/tajara,
	)
/obj/outfit/admin/generic/nuclear_silo_crew/lower/silo_engineer
	name = "Nuclear Missile Silo Engineer"
	uniform = list(
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/overalls,
		/obj/item/clothing/under/color/brown,
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest/blue,
		/obj/item/clothing/suit/storage/hazardvest/green,
		/obj/item/clothing/suit/storage/hazardvest/red,
	)
	back = list(
		/obj/item/storage/backpack/duffel,
		/obj/item/storage/backpack/duffel/eng,
		/obj/item/storage/backpack/industrial,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/messenger/engi,
		/obj/item/storage/backpack/rucksack/tan,
		/obj/item/storage/backpack/satchel/eng,
	)
	belt = list(
		/obj/item/storage/belt/utility,
		/obj/item/storage/belt/utility/alt,
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/utility/atmostech,
		/obj/item/storage/belt/utility/very_full,
	)
	shoes = list(
		/obj/item/clothing/shoes/cowboy,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
	)
	head = list(
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat/dblue,
		/obj/item/clothing/head/hardhat/green,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/hardhat/orange,
		/obj/item/clothing/head/softcap/engineering,
	)
	glasses = null

	backpack_contents = list(
		/obj/item/tape_roll = 1,
		/obj/item/taperoll/engineering = 1,
		/obj/item/device/magnetic_lock/engineering = 1,
		/obj/item/device/gps/engineering = 1,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/tajara,
	)
/obj/outfit/admin/generic/nuclear_silo_crew/lower/silo_doctor
	name = "Nuclear Missile Silo Doctor"
	uniform = list(
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/medical/surgeon,
		/obj/item/clothing/under/rank/medical/generic,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/lightgreen,
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/med_dep_jacket,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/para_jacket,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
	)
	back = list(
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/satchel/pocketbook,
		/obj/item/storage/backpack/messenger/med,
		/obj/item/storage/backpack/medic,
		/obj/item/storage/backpack/duffel/med,
	)
	belt = list(
		/obj/item/storage/belt/medical/paramedic/full,
		/obj/item/storage/belt/medical/paramedic/combat/full,
		/obj/item/storage/belt/medical/full,
	)
	gloves = list(
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex/nitrile,
	)
	shoes = list(
		/obj/item/clothing/shoes/sneakers/medsci,
		/obj/item/clothing/shoes/sneakers/hitops,
		/obj/item/clothing/shoes/sneakers/hitops/green,
		/obj/item/clothing/shoes/sneakers,
		/obj/item/clothing/shoes/sneakers/green,
	)
	head = list(
		/obj/item/clothing/head/softcap/medical,
		/obj/item/clothing/head/beret/medical,
		/obj/item/clothing/head/bandana/medical,
	)
	mask = null
	glasses = null
	r_pocket = /obj/item/reagent_containers/hypospray
	l_pocket = /obj/item/device/healthanalyzer
	species_gloves = list(
		SPECIES_UNATHI = /obj/item/clothing/gloves/latex/nitrile/unathi,
		SPECIES_TAJARA = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/gloves/latex/nitrile/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/gloves/latex/nitrile/tajara,
	)

/obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_researcher
	name = "Nuclear Missile Silo Researcher"
	uniform = list(
		/obj/item/clothing/under/rank/medical/surgeon,
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/purple,
		/obj/item/clothing/under/color/lightpurple,
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/longcoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/suit/storage/toggle/sci_dep_jacket,
	)
	back = list(
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/satchel/pocketbook,
	)
	gloves = null
	shoes = list(
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/shoes/sneakers/hitops/black,
		)
	head = null
	glasses = null

	backpack_contents = list(
		/obj/item/folder = 1,
		/obj/item/folder/purple = 1,
		/obj/item/clipboard = 1,
		/obj/item/pen/fountain/black = 1,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/sneakers/hitops/black,
		SPECIES_TAJARA = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/laceup/tajara,
	)
/obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_guard
	name = "Nuclear Missile Silo Guard"
	uniform = list(
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/darkblue,
		/obj/item/clothing/under/rank/security,
	)
	suit = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/suit/storage/toggle/warden,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan,
		/obj/item/clothing/suit/storage/toggle/sec_dep_jacket,
	)
	back = list(
		/obj/item/storage/backpack/rucksack/blue,
		/obj/item/storage/backpack/rucksack/navy,
		/obj/item/storage/backpack/messenger/sec,
	)
	belt = list(
		/obj/item/storage/belt/security/full,
		/obj/item/storage/belt/security/full/alt,
		/obj/item/storage/belt/military,
		/obj/item/storage/belt/security/tactical,
	)
	gloves = list(
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/gloves/force/basic,
		/obj/item/clothing/gloves/black_leather,
	)
	shoes = list(
		/obj/item/clothing/shoes/combat,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/jackboots/cavalry,
	)
	head = list(
		/obj/item/clothing/head/beret/security,
		/obj/item/clothing/head/beret/security/officer,
		/obj/item/clothing/head/softcap/security,
		/obj/item/clothing/head/warden,
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
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/tajara,
	)
/obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_base_commander
	name = "Nuclear Missile Silo Base Commander"

	uniform = list(
		/obj/item/clothing/under/zhongshan,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/under/suit_jacket,
	)
	suit = null
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	shoes = /obj/item/clothing/shoes/laceup

	back = list(
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/satchel/pocketbook,
	)

	accessory = /obj/item/clothing/accessory/holster/hip/brown
	accessory_contents = list(/obj/item/gun/projectile/revolver)
	id = /obj/item/card/id/syndicate

	l_ear = /obj/item/device/radio/headset/distress

	backpack_contents = list(
		/obj/item/storage/wallet/random = 1,
		/obj/item/ammo_magazine/a454 = 3,
		/obj/random/smokable = 1,
		/obj/item/flame/lighter/zippo = 1,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/laceup/tajara,
	)

/obj/outfit/admin/generic/nuclear_silo_crew/lower/high_sec/silo_military_attache
	name = "Nuclear Missile Silo Military Attache"

	uniform = list(
		/obj/item/clothing/under/syndicate/tacticool,
		/obj/item/clothing/under/tactical,
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/alt,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/green,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/white,
	)
	head = /obj/item/clothing/head/beret/red
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	shoes = /obj/item/clothing/shoes/combat
	belt = /obj/item/storage/belt/military
	back = list(
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/satchel/pocketbook,
	)
	id = /obj/item/card/id/syndicate
	l_ear = /obj/item/device/radio/headset/distress
	backpack_contents = list(
		/obj/item/storage/box/fancy/cigarettes/dromedaryco = 1,
		/obj/item/flame/lighter/zippo = 1,
		//fluff documents, folder, fountain pen
	)
	belt_contents = list(
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/melee/energy/sword/knife = 1,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/tajara,
	)
