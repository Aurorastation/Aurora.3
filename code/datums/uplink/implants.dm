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

/datum/uplink_item/item/implants/hiveshield
	name = "Vaurca Hivenet Defense Implanter"
	bluecrystal_cost = 1
	desc = "An augment implanter, with a Hivenet defense augment. ONLY WORKS ON VAURCA!"
	path = /obj/item/device/augment_implanter/hivenet_shield

/datum/uplink_item/item/implants/hivewarfare
	name = "Vaurca Hivenet Warfare Suite"
	bluecrystal_cost = 5
	desc = "A augment implanter, with a Hivenet defense augment and electronic warfare suite. ONLY WORKS ON VAURCA!"
	path = /obj/item/device/augment_implanter/hivenet_warfare

/datum/uplink_item/item/implants/telefreedom_kit
	name = "Telefreedom Kit"
	bluecrystal_cost = 15
	item_limit = 1
	desc = "A box containing a telefreedom full kit, which allows you to teleport to a linked telepad that you \
			will build once. Comes with everything you need for 4 people. You supply the screwdriver and have to build it."
	path = /obj/item/storage/box/telefreedom_kit

/datum/uplink_item/item/implants/auxiliary_heart
	name = "Galatean Auxiliary Heart Implanter"
	bluecrystal_cost = 3
	telecrystal_cost = 3
	desc = "An augment implanter, with a Auxiliary Heart bioaug. ONLY WORKS ON HUMANS!"
	path = /obj/item/device/augment_implanter/auxiliary_heart

/datum/uplink_item/item/implants/mind_blanker
	name = "Galatean Mind Blanker Implanter"
	bluecrystal_cost = 2
	telecrystal_cost = 2
	desc = "An augment implanter, with a Mind Blanker bioaug. ONLY WORKS ON HUMANS!"
	path = /obj/item/device/augment_implanter/mind_blanker

/datum/uplink_item/item/implants/mind_blanker_lethal
	name = "Galatean Mind Blanker (Lethal) Implanter"
	bluecrystal_cost = 4
	telecrystal_cost = 4
	desc = "An augment implanter, with a Lethal Mind Blanker bioaug. ONLY WORKS ON HUMANS!"
	path = /obj/item/device/augment_implanter/mind_blanker_lethal

/datum/uplink_item/item/implants/platelet_factories
	name = "Galatean Platelet Factories Implanter"
	bluecrystal_cost = 3
	telecrystal_cost = 3
	desc = "An augment implanter, with a Platelet Factories bioaug. ONLY WORKS ON HUMANS!"
	path = /obj/item/device/augment_implanter/platelet_factories

/datum/uplink_item/item/implants/subdermal_carapace
	name = "Galatean Subdermal Carapace Implanter"
	bluecrystal_cost = 5
	telecrystal_cost = 5
	desc = "An augment implanter, with a Subdermal Carapace bioaug. ONLY WORKS ON HUMANS!"
	path = /obj/item/device/augment_implanter/subdermal_carapace
