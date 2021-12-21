/datum/outfit/admin/megacorp/shipwright
	name = "Chief Shipwright"

	uniform = /obj/item/clothing/under/rank/hephaestus
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/yellow
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/storage/belt/utility/very_full
	l_ear = /obj/item/device/radio/headset/heads/captain
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/heph
	head = /obj/item/clothing/head/hardhat/white
	id = /obj/item/card/id/syndicate

	backpack_contents = list(
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/tank/oxygen = 1,
		/obj/item/device/multitool = 1,
		/obj/item/weldingtool/hugetank = 1,
		/obj/item/clothing/glasses/welding/superior = 1,
		/obj/item/clipboard = 1
	)

	var/id_access = "NanoTrasen Representative"

/datum/outfit/admin/megacorp/shipwright/get_id_access()
	return get_all_accesses() | get_centcom_access(id_access)