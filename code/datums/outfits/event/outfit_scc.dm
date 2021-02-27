/datum/outfit/admin/scc
	name = "SCC Agent"

	uniform = /obj/item/clothing/under/rank/scc
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/ert/ccia
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id

	accessory = /obj/item/clothing/accessory/holster/armpit
	accessory_contents = list(/obj/item/gun/energy/repeater)

	backpack_contents = list(
		/obj/item/storage/box/engineer = 1
	)

	id_icon = "centcom"
	var/id_access = "SCC Agent"

/datum/outfit/admin/scc/get_id_access()
	return get_all_station_access() | get_centcom_access(id_access)

/datum/outfit/admin/scc/executive
	name = "SCC Executive"

	uniform = /obj/item/clothing/under/rank/scc/executive

	id_access = "SCC Executive"