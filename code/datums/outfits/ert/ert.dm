/datum/outfit/admin/ert/nanotrasen
	name = "Nanotrasen Responder"

	uniform = /obj/item/clothing/under/ert
	suit = null
	suit_store = null
	belt = /obj/item/weapon/storage/belt/military
	shoes = /obj/item/clothing/shoes/jackboots
	accessory = /obj/item/clothing/accessory/storage/black_vest
	gloves = null
	id = /obj/item/weapon/card/id/ert
	backpack = /obj/item/weapon/rig/ert

	l_ear = /obj/item/device/radio/headset/ert
	l_hand = /obj/item/weapon/gun/projectile/automatic/rifle/z8

	belt_contents = list(
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/shield/riot/tact,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556,
		/obj/item/ammo_magazine/a556/ap
	)
	
/datum/outfit/admin/ert/nanotrasen/specialist
	belt = null
	belt_contents = null

/datum/outfit/admin/ert/nanotrasen/specialist/post_equip(mob/living/carbon/human/H)
	switch(alert("Do you want to be an engineering or medical specialist?", "Response Team", "Engineering", "Medical")
		if("Engineering")
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
			H.equip_to_slot_or_del(new /obj/item/weapon/rig/ert/engineer(H), slot_back)
		if("Medical")
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/combat(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/rig/ert/medical(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical(H), slot_belt)
			H.equip_or_collect(new /obj/item/weapon/reagent_containers/hypospray(H), slot_belt)
			H.equip_or_collect(new /obj/item/stack/medical/advanced/bruise_pack(H), slot_belt)
			H.equip_or_collect(new /obj/item/stack/medical/advanced/ointment(H), slot_belt)