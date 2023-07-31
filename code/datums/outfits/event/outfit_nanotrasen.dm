/datum/outfit/admin/nt
	name = "NanoTrasen Representative"

	uniform = /obj/item/clothing/under/rank/centcom
	back = /obj/item/storage/backpack/satchel/leather
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/ert/ccia
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1
	)

	id_icon = "centcom"
	var/id_access = "NanoTrasen Representative"

/datum/outfit/admin/nt/get_id_access()
	return get_all_station_access() | get_centcom_access(id_access)

/datum/outfit/admin/nt/officer
	name = "NanoTrasen Navy Officer"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	l_ear = /obj/item/device/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/centcom/officer
	l_pocket = /obj/item/device/orbital_dropper/icarus_drones

/datum/outfit/admin/nt/captain
	name = "NanoTrasen Navy Captain"

	uniform = /obj/item/clothing/under/rank/centcom_captain
	l_ear = /obj/item/device/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/centcom/captain
	l_pocket = /obj/item/device/orbital_dropper/icarus_drones

/datum/outfit/admin/nt/protection_detail
	name = "ERT Protection Detail"

	uniform = /obj/item/clothing/under/ccpolice
	suit = /obj/item/clothing/suit/storage/vest/heavy/ert/peacekeeper
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat/tactical
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	id = /obj/item/card/id/ccia
	head = /obj/item/clothing/head/beret/centcom/civilprotection
	suit_store = /obj/item/gun/energy/gun
	belt = /obj/item/storage/belt/security

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/clothing/head/helmet/swat/peacekeeper = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/gun/energy/disruptorpistol/magnum = 1
	)

	implants = list(
		/obj/item/implant/mindshield
	)
	id_icon = "ccia"
	id_access = "CCIA Agent"

/datum/outfit/admin/nt/protection_detail/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)

	if(H && H.belt)

		var/obj/item/reagent_containers/spray/pepper/pepperspray = new(H)
		var/obj/item/melee/baton/loaded/baton = new(H)
		var/obj/item/shield/riot/tact/shield = new(H)
		var/obj/item/grenade/flashbang/flashbang = new(H)
		var/obj/item/handcuffs/cuffs = new(H)
		var/obj/item/device/flash/flash = new(H)
		var/obj/item/device/flashlight/flare/flare = new(H)

		H.belt.contents += flare
		H.belt.contents += flashbang
		H.belt.contents += cuffs
		H.belt.contents += pepperspray
		H.belt.contents += flash
		H.belt.contents += baton
		H.belt.contents += shield


/datum/outfit/admin/nt/ert_commander
	name = "ERT Commander"

	uniform = /obj/item/clothing/under/rank/centcom_commander
	suit = /obj/item/clothing/suit/storage/vest/heavy/ert/commander
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/centcom/commander

	backpack_contents = list(
		/obj/item/storage/box/fancy/cigarettes/cigar = 1,
		/obj/item/flame/lighter/zippo = 1,
		/obj/item/device/orbital_dropper/icarus_drones = 1
	)

	implants = list(
		/obj/item/implant/mindshield
	)

	id_access = "BlackOps Commander"

/datum/outfit/admin/nt/cciaa
	name = "CCIA Agent"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	l_ear = /obj/item/device/radio/headset/ert/ccia
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/centcom/officer
	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/device/taperecorder/cciaa
	l_hand = /obj/item/storage/lockbox/cciaa
	pda = /obj/item/modular_computer/handheld/pda/command/cciaa
	id = /obj/item/card/id/ccia

	backpack_contents = list(
		/obj/item/device/memorywiper = 1
	)

	id_icon = "ccia"
	id_access = "CCIA Agent"

/datum/outfit/admin/nt/odinsec
	name = "NTCC Odin Security Specialist"

	uniform = /obj/item/clothing/under/ccpolice
	suit = /obj/item/clothing/suit/storage/vest/heavy/ert/peacekeeper
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat/tactical
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	mask = /obj/item/clothing/mask/gas/tactical
	head = /obj/item/clothing/head/helmet/swat/peacekeeper
	back = null
	r_pocket = /obj/item/handcuffs/ziptie
	l_hand = /obj/item/shield/riot/tact
	suit_store = /obj/item/gun/energy/gun
	belt = /obj/item/storage/belt/security

	backpack_contents = null

	belt_contents = list(
		/obj/item/reagent_containers/spray/pepper = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/grenade/chem_grenade/gas = 1,
		/obj/item/device/flash = 1,
		/obj/item/ammo_magazine/c45m/auto = 2
	)

	implants = list(
		/obj/item/implant/mindshield
	)

	id_access = "Odin Security"

/datum/outfit/admin/nt/odinsec/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)

	if(H && H.w_uniform)

		var/obj/item/clothing/accessory/holster/hip/holster = new(H)
		var/obj/item/gun/projectile/automatic/x9/weapon = new(H)
		holster.contents += weapon
		holster.holstered = weapon
		var/obj/item/clothing/under/rank/U = H.w_uniform
		U.attach_accessory(null, holster)

/datum/outfit/admin/nt/specops
	name = "Special Operations Officer"

	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat/officer
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/eyepatch/hud/thermal
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/helmet/space/deathsquad/beret
	belt = /obj/item/gun/energy/pulse/pistol
	r_pocket = /obj/item/flame/lighter/zippo

	implants = list(
		/obj/item/implant/mindshield
	)

	id_access = "Death Commando"

/datum/outfit/admin/nt/fib
	name = "FIB Agent"

	uniform = /obj/item/clothing/under/rank/fib
	suit = /obj/item/clothing/suit/storage/toggle/fib
	gloves = /obj/item/clothing/gloves/black

	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/device/taperecorder/cciaa
	l_hand = /obj/item/storage/lockbox/cciaa/fib
	id = /obj/item/card/id/ccia/fib

	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/sec/lethal = 1)

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/device/flash = 1,
		/obj/item/handcuffs = 1
	)

	id_icon = "fib"
	id_access = "CCIA Agent"

/datum/outfit/admin/nt/fib/guard
	name = "FIB Escort"

	suit = /obj/item/clothing/suit/armor/vest/fib
	belt =/obj/item/storage/belt/security
	r_pocket = null
	l_hand = null
	belt_contents = list(
		/obj/item/device/flash = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/handcuffs = 2,
		/obj/item/ammo_magazine/c45m = 2
	)

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/storage/box/zipties = 1,
		/obj/item/clothing/head/helmet = 1
	)

	id_access = "CCIA Agent"

/datum/outfit/admin/nt/odindoc
	name = "NTCC Odin Medical Specialist"

	uniform = /obj/item/clothing/under/rank/medical/surgeon/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/trauma
	mask = /obj/item/clothing/mask/surgical
	l_hand = /obj/item/storage/firstaid/adv
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	glasses = /obj/item/clothing/glasses/hud/health

	gloves = /obj/item/clothing/gloves/white
	belt = /obj/item/storage/belt/medical
	back = /obj/item/storage/backpack/satchel/med
	accessory = /obj/item/clothing/accessory/storage/white_vest
	accessory_contents = list(/obj/item/stack/medical/advanced/bruise_pack = 1, /obj/item/stack/medical/advanced/ointment = 1, /obj/item/reagent_containers/glass/bottle/mortaphenyl = 1)

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/storage/firstaid/surgery = 1,
		/obj/item/storage/box/gloves = 1,
		/obj/item/storage/box/syringes = 1,
		/obj/item/device/flashlight/pen = 1
	)

	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

	id_access = "Medical Doctor"

/datum/outfit/admin/nt/odinpharm
	name = "NTCC Odin Pharmacy Specialist"

	uniform = /obj/item/clothing/under/rank/medical/pharmacist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt
	shoes = /obj/item/clothing/shoes/chemist
	headset = /obj/item/device/radio/headset/headset_med
	bowman = /obj/item/device/radio/headset/headset_med/alt
	glasses = /obj/item/clothing/glasses/hud/health

	backpack = /obj/item/storage/backpack/pharmacy
	satchel = /obj/item/storage/backpack/satchel/pharm
	dufflebag = /obj/item/storage/backpack/duffel/pharm
	messengerbag = /obj/item/storage/backpack/messenger/pharm

	id_access = "Medical Doctor"

/datum/outfit/admin/nt/odinbartender
	name = "NTCC Odin Bartender"

	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/laceup/all_species
	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt

	id_access = "Service"

/datum/outfit/admin/nt/odinchef
	name = "NTCC Odin Chef"

	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef_jacket
	head = /obj/item/clothing/head/chefhat
	shoes = /obj/item/clothing/shoes/laceup/all_species
	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt

	id_access = "Service"

/datum/outfit/admin/nt/odinjanitor
	name = "NTCC Odin Sanitation Specialist"

	uniform = /obj/item/clothing/under/rank/janitor
	pda = /obj/item/modular_computer/handheld/pda/civilian
	shoes = /obj/item/clothing/shoes/galoshes
	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	r_pocket = /obj/item/grenade/chem_grenade/cleaner

	backpack_contents = list(
		/obj/item/grenade/chem_grenade/cleaner = 14
	)

	id_access = "Service"
