
// Base Outfit

/obj/outfit/admin/generic/ringstation
	name = "Ringstation Base Uniform"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/id
	l_pocket = /obj/item/device/radio/hailing

/obj/outfit/admin/generic/ringstation/staff/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RINGSTATION
	)

// Staff Outfits
/obj/outfit/admin/generic/ringstation/staff/administrator
	name = "Waystation Administrator"

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

	shoes = /obj/item/clothing/shoes/laceup
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/winter/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/laceup/tajara,
	)

	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/wallet/rich = 1
	)

/obj/outfit/admin/generic/ringstation/staff/administrator/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RINGSTATION, ACCESS_RINGSTATION_MEDICAL, ACCESS_RINGSTATION_ENGINEERING
	)

/obj/outfit/admin/generic/ringstation/staff/maintenance_staff
	name = "Waystation Maintenance Staff"
	uniform = /obj/item/clothing/under/color/yellow
	suit = list(
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
		/obj/item/clothing/suit/storage/hazardvest
	)
	back = list(
		/obj/item/storage/backpack/industrial,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/rucksack/tan
	)
	belt = /obj/item/storage/belt/utility/full
	shoes = list(
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark
	)
	head = /obj/item/clothing/head/hardhat/orange
	glasses = null

	backpack_contents = list(
		/obj/item/tape_roll = 1,
		/obj/item/device/magnetic_lock/engineering = 1,
		/obj/item/device/gps/engineering = 1
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/tajara,
	)

/obj/outfit/admin/generic/ringstation/staff/maintenance_staff/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RINGSTATION, ACCESS_RINGSTATION_ENGINEERING
	)

/obj/outfit/admin/generic/ringstation/staff/clinic_staff
	name = "Waystation Clinic Staff"
	uniform = /obj/item/clothing/under/color/white
	back = /obj/item/storage/backpack/messenger/med
	belt = /obj/item/storage/belt/medical
	shoes = list(
		/obj/item/clothing/shoes/sneakers/medsci,
		/obj/item/clothing/shoes/sneakers/green
	)
	mask = null
	glasses = null
	l_pocket = /obj/item/device/healthanalyzer

/obj/outfit/admin/generic/ringstation/staff/clinic_staff/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_RINGSTATION, ACCESS_RINGSTATION_MEDICAL
	)

/obj/outfit/admin/generic/ringstation/staff/supply_staff
	name = "Waystation Supply Staff"
	uniform = /obj/item/clothing/under/color/brown
	suit = list(
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
		/obj/item/clothing/suit/storage/hazardvest
	)
	back = list(
		/obj/item/storage/backpack/industrial,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/rucksack/tan
	)
	belt = /obj/item/storage/belt/utility/full
	shoes = list(
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark
	)
	glasses = null

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/tajara,
	)

/obj/outfit/admin/generic/ringstation/staff/service
	name = "Waystation Service Staff"

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

	shoes = /obj/item/clothing/shoes/laceup
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/winter/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/laceup/tajara,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/laceup/tajara,
	)

	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/wallet/random = 1
	)

/obj/outfit/admin/generic/ringstation/visitor
	name = "Waystation Visitor"

	uniform = list(
		/obj/item/clothing/under/zhongshan,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/red,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/waiter,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/burgundy
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/toggle/cardigan,
		/obj/item/clothing/suit/storage/toggle/flannel,
		/obj/item/clothing/suit/storage/toggle/flannel/red,
		/obj/item/clothing/suit/storage/toggle/trench/green,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black
	)
	head = list(
		/obj/item/clothing/head/beanie/random,
		/obj/item/clothing/head/beanie/submariner,
		/obj/item/clothing/head/beanie/winter,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/newsboy,
		/obj/item/clothing/head/softcap,
		/obj/item/clothing/head/wool
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
		/obj/item/clothing/shoes/workboots
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
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
		/obj/item/storage/wallet/random = 1
	)
