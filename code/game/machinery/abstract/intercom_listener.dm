/obj/machinery/abstract/intercom_listener
	name = "intercom power interface"
	desc = "You shouldn't see this."
	power_channel = EQUIP

	var/obj/item/device/radio/intercom/master

/obj/machinery/abstract/intercom_listener/New(atom/loc, obj/item/device/radio/intercom/owner)
	if (QDELETED(owner))
		warning("intercom_listener created with QDELETED intercom!")
		qdel(src)
	else
		master = owner
		..()

/obj/machinery/abstract/intercom_listener/Destroy()
	master = null
	return ..()

/obj/machinery/abstract/intercom_listener/power_change()
	..()
	if (master)
		var/state = powered(power_channel)
		master.power_change(state)
	else
		warning("intercom_listener got power_change but has no master!")
		qdel(src)
