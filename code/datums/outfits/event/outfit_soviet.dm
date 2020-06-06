/datum/outfit/admin/soviet_soldier
	name = "Soviet Soldier"

	uniform = /obj/item/clothing/under/soviet
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/ushanka/grey


/datum/outfit/admin/soviet_soldier/admiral
	name = "Soviet Admiral"

	uniform = /obj/item/clothing/under/soviet
	suit = /obj/item/clothing/suit/hgpirate
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/hgpiratecap
	belt = /obj/item/gun/projectile/revolver/mateba
	l_ear = /obj/item/device/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/eyepatch/hud/thermal
	id = /obj/item/card/id

/datum/outfit/admin/soviet_soldier/admiral/get_id_assignment()
	return "Admiral"

/datum/outfit/admin/soviet_soldier/admiral/get_id_rank()
	return "Admiral"