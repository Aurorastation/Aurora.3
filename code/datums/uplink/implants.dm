/***********
* Implants *
***********/
/datum/uplink_item/item/implants
	category = /datum/uplink_category/implants

/datum/uplink_item/item/implants/imp_freedom
	name = "Freedom Implant"
	telecrystal_cost = 1
	desc = "A box containing a freedom implant case and implanter."
	path = /obj/item/storage/box/syndie_kit/imp_freedom

/datum/uplink_item/item/implants/imp_emp
	name = "EMP Implant"
	telecrystal_cost = 1
	desc = "A box containing an EMP implant case and implanter."
	path = /obj/item/storage/box/syndie_kit/imp_emp

/datum/uplink_item/item/implants/imp_explosive
	name = "Explosive Implant (DANGER!)"
	bluecrystal_cost = 3
	desc = "A box containing an explosive implant case and implanter. Use the implant case with the implant pad to set the explosion size, trigger phrase, and trigger code."
	path = /obj/item/storage/box/syndie_kit/imp_explosive

/datum/uplink_item/item/implants/imp_deadman
	name = "Deadman Implant (DANGER!)"
	bluecrystal_cost = 3
	desc = "A box containing an explosive implant and implanter. The implant monitors vitals and will detonate when the subject dies."
	path = /obj/item/storage/box/syndie_kit/imp_deadman

/datum/uplink_item/item/implants/imp_uplink
	name = "Uplink Implant"
	path = /obj/item/implanter/uplink

/datum/uplink_item/item/implants/imp_uplink/New()
	..()
	telecrystal_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)
	desc = "Contains [round((DEFAULT_TELECRYSTAL_AMOUNT / 2) * 0.8)] Telecrystal\s"

/datum/uplink_item/item/implants/aug_combitool
	name = "Combitool Augment Implanter"
	bluecrystal_cost = 1
	desc = "An augment implanter, with the combitool augment."
	path = /obj/item/device/augment_implanter/combitool

/datum/uplink_item/item/implants/aug_health_scanner
	name = "Health Scanner Augment Implanter"
	bluecrystal_cost = 1
	desc = "An augment implanter, with the integrated health scanner augment."
	path = /obj/item/device/augment_implanter/health_scanner
