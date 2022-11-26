/obj/item/device/handheld_medical
	name = "hand-held suit sensor monitor"
	desc = "A miniature machine that tracks suit sensors across a facility."
	icon = 'icons/obj/device.dmi'
	icon_state = "scanner"
	w_class = ITEMSIZE_SMALL
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
