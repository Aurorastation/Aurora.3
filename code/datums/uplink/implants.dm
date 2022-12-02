/***********
* Implants *
***********/
/datum/uplink_item/item/implants
	category = /datum/uplink_category/implants

/datum/uplink_item/item/implants/imp_freedom
	name = "Freedom Implant"
	item_cost = 1
	path = /obj/item/storage/box/syndie_kit/imp_freedom

/datum/uplink_item/item/implants/imp_compress
	name = "Compressed Matter Implant"
	desc = "A box containing a single implanter and matter cartridge. To remove an unintended target, use the implanter in-hand then open the cartridge with a screwdriver."
	item_cost = 1
	path = /obj/item/storage/box/syndie_kit/imp_compress

/datum/uplink_item/item/implants/imp_explosive
	name = "Explosive Implant (DANGER!)"
	item_cost = 3
	desc = "A box containing an explosive implant and implanter. Use the implant in-hand to set the explosion size and trigger phrase."
	path = /obj/item/storage/box/syndie_kit/imp_explosive

/datum/uplink_item/item/implants/imp_deadman
	name = "Deadman Implant (DANGER!)"
	item_cost = 3
	desc = "A box containing an explosive implant and implanter. The implant monitors vitals and will detonate when the subject dies."
	path = /obj/item/storage/box/syndie_kit/imp_deadman

/datum/uplink_item/item/implants/imp_uplink
	name = "Uplink Implant"
	path = /obj/item/implanter/uplink

/datum/uplink_item/item/implants/imp_uplink/New()
	..()
	item_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)
	desc = "Contains [round((DEFAULT_TELECRYSTAL_AMOUNT / 2) * 0.8)] Telecrystal\s"

/datum/uplink_item/item/implants/aug_combitool
	name = "Combitool Augment Implanter"
	item_cost = 2
	desc = "An augment implanter, with the combitool augment."
	path = /obj/item/device/augment_implanter/combitool

/datum/uplink_item/item/implants/aug_health_scanner
	name = "Health Scanner Augment Implanter"
	item_cost = 1
	desc = "An augment implanter, with the integrated health scanner augment."
	path = /obj/item/device/augment_implanter/health_scanner
