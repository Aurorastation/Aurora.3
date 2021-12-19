/datum/outfit/admin/tcfl
	name = "TCFL Legate"

	uniform = /obj/item/clothing/under/legion/legate
	suit = /obj/item/clothing/suit/storage/vest/legion/legate
	gloves = /obj/item/clothing/gloves/swat/tactical
	shoes = /obj/item/clothing/shoes/swat/ert
	l_ear = /obj/item/device/radio/headset/legion
	head = /obj/item/clothing/head/legion/legate
	glasses = /obj/item/clothing/glasses/sunglasses/aviator
	id = /obj/item/card/id/distress/legion
	belt = /obj/item/storage/belt/security/tactical
	r_pocket = /obj/item/clothing/mask/gas/tactical
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/revolver/mateba = 1)
	back = null

	backpack_contents = null

	belt_contents = list(
		/obj/item/melee/energy/sword/knife = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/ammo_magazine/a454 = 2,
		/obj/item/shield/energy/legion = 1
	)

	id_iff = IFF_TCFL
	var/id_access = "NanoTrasen Representative"

/datum/outfit/admin/tcfl/get_id_access()
	return get_all_accesses() | get_centcom_access(id_access)