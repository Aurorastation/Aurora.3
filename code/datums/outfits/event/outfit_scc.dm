/datum/outfit/admin/scc
	name = "SCC Agent"

	uniform = /obj/item/clothing/under/rank/scc
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/ert/ccia
	glasses = /obj/item/clothing/glasses/sunglasses
	wrist = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command

	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/device/taperecorder/cciaa

	id = /obj/item/card/id

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1
	)

	id_icon = "centcom"
	var/id_access = "SCC Agent"

/datum/outfit/admin/scc/get_id_access()
	return get_all_station_access() | get_centcom_access(id_access)

/datum/outfit/admin/scc/executive
	name = "SCC Executive"

	uniform = /obj/item/clothing/under/rank/scc/executive

	id_access = "SCC Executive"

/datum/outfit/admin/scc/bodyguard
	name = "SCC Bodyguard"

	head = /obj/item/clothing/head/helmet/merc/scc
	uniform = /obj/item/clothing/under/tactical
	suit = /obj/item/clothing/suit/armor/carrier/heavy/scc
	shoes = /obj/item/clothing/shoes/jackboots
	wrist = /obj/item/modular_computer/handheld/wristbound/preset/advanced/security

	l_pocket = /obj/item/shield/energy
	r_pocket = /obj/item/device/radio

	accessory = /obj/item/clothing/accessory/holster/armpit
	accessory_contents = list(/obj/item/gun/energy/repeater)

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/reagent_containers/spray/pepper = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/grenade/chem_grenade/gas = 1,
		/obj/item/device/flash = 1,
		/obj/item/handcuffs/ziptie = 2
	)

	id_access = "SCC Bodyguard"