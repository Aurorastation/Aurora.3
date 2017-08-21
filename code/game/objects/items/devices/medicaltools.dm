/*
Contains:
- Handheld suit sensor monitor
- Topical Spray

*/
//HANDHELD SUIT SENSOR
/obj/item/device/handheld_medical
	name = "Hand-held suit sensor monitor"
	desc = "A miniature machine that tracks suit sensors across the station."
	icon = 'icons/obj/device.dmi'
	icon_state = "scanner"
	w_class = 2
	slot_flags = SLOT_BELT
	var/datum/nano_module/crew_monitor/crew_monitor

/obj/item/device/handheld_medical/Initialize()
	. = ..()
	crew_monitor = new(src)

/obj/item/device/handheld_medical/Destroy()
	qdel(crew_monitor)
	crew_monitor = null
	return ..()

/obj/item/device/handheld_medical/attack_self(mob/user)
	crew_monitor.ui_interact(user)

// TOPICAL SPRAY. For now it's only used for salving burns. Can be used for other topical medicines.
/obj/item/weapon/reagent_containers/spray/chemsprayer/topical_spray/kelotane
	name = "Topical sprayer"
	desc = "A small can of medicine that applies a pre-loaded mixture of chemicals to the effected area. This version is loaded with topical kelotane."
	icon = 'icons/obj/device.dmi'
	icon_state = "topicalspray"
	w_class = 2
	slot_flags = SLOT_BELT
	volume = 120

/obj/item/weapon/reagent_containers/spray/chemsprayer/topical/kelotane/Initialize()
	. = ..()
	reagents.add_reagent("kelotanetopical", 120)