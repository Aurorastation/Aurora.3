/datum/outfit/admin/killer
	name = "Masked Killer"

	uniform = /obj/item/clothing/under/overalls
	suit = /obj/item/clothing/accessory/apron
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/latex
	mask = /obj/item/clothing/mask/surgical
	head = /obj/item/clothing/head/welding
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/plain/monocle
	l_pocket = /obj/item/material/knife
	r_pocket = /obj/item/surgery/scalpel
	r_hand = /obj/item/material/twohanded/fireaxe
	id = null

/datum/outfit/admin/killer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	for(var/obj/item/carried_item in H.contents)
		if(!istype(carried_item, /obj/item/implant))//If it's not an implant.
			carried_item.add_blood(H)//Oh yes, there will be blood...


/datum/outfit/admin/killer/assassin
	name = "Assassin"

	uniform = /obj/item/clothing/under/suit_jacket
	suit = /obj/item/clothing/suit/wcoat
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/device/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/melee/energy/sword
	r_pocket = /obj/item/cloaking_device
	id = /obj/item/card/id/syndicate
	pda = /obj/item/modular_computer/handheld/pda/command
	id_iff = IFF_SYNDICATE

/datum/outfit/admin/killer/assassin/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i=3, i>0, i--)
		sec_briefcase.contents += new /obj/item/spacecash/c1000
	sec_briefcase.contents += new /obj/item/gun/energy/crossbow
	sec_briefcase.contents += new /obj/item/gun/projectile/revolver/mateba
	sec_briefcase.contents += new /obj/item/ammo_magazine/a357
	sec_briefcase.contents += new /obj/item/plastique
	H.equip_to_slot_or_del(sec_briefcase, slot_l_hand)

/datum/outfit/admin/killer/assassin/get_id_access()
	return get_all_station_access()