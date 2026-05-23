////////////////////HOLOSIGN///////////////////////////////////////
/obj/structure/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector"
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	layer = ABOVE_DOOR_LAYER
	idle_power_usage = 2
	active_power_usage = 4
	anchored = 1
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"
	var/_wifi_id
	var/datum/wifi/receiver/button/holosign/wifi_receiver

/obj/structure/machinery/holosign/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/structure/machinery/holosign/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/structure/machinery/holosign/proc/toggle()
	if (stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	update_use_power(lit ? POWER_USE_ACTIVE : POWER_USE_IDLE)
	update_icon()

/obj/structure/machinery/holosign/update_icon()
	if (!lit)
		icon_state = "sign_off"
	else
		icon_state = on_icon

/obj/structure/machinery/holosign/power_change()
	..()
	if (stat & NOPOWER)
		lit = 0
		update_use_power(POWER_USE_OFF)
	update_icon()

/obj/structure/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"

/obj/structure/machinery/holosign/service
	name = "service holosign"
	on_icon = "serviceopen"
	desc = "A small wall-mounted holographic projector. This one reads OPEN."

/obj/structure/machinery/holosign/service/update_icon()
	if(!lit)
		icon_state = "serviceclosed"
	else
		icon_state = on_icon

////////////////////SWITCH///////////////////////////////////////

/obj/structure/machinery/button/switch/holosign
	name = "holosign switch"
	desc = "A remote control switch for a holosign."
	icon_state = "light0"
	var/list/datum/weakref/linked_signs

/obj/structure/machinery/button/switch/holosign/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/button/switch/holosign/LateInitialize()
	. = ..()
	for(var/obj/structure/machinery/holosign/H in SSmachinery.machinery)
		if(H.id == id)
			LAZYADD(linked_signs, WEAKREF(H))

/obj/structure/machinery/button/switch/holosign/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)

	active = !active
	update_icon()
	for(var/datum/weakref/W in linked_signs)
		var/obj/structure/machinery/holosign/H = W.resolve()
		if(!isnull(H))
			INVOKE_ASYNC(H, TYPE_PROC_REF(/obj/structure/machinery/holosign, toggle))

	return
