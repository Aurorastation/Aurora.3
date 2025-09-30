/obj/machinery/igniter
	name = "igniter"
	desc = "It's useful for igniting flammable items."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "igniter1"
	var/id = null
	var/on = 0
	anchored = 1
	idle_power_usage = 2
	active_power_usage = 4
	var/_wifi_id
	var/datum/wifi/receiver/button/igniter/wifi_receiver

/obj/machinery/igniter/Initialize()
	. = ..()
	update_icon()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/igniter/update_icon()
	..()
	icon_state = "igniter[on]"

/obj/machinery/igniter/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/igniter/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/igniter/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)
	ignite()
	return

/obj/machinery/igniter/process()	//ugh why is this even in process()?
	if (on && powered() )
		var/turf/location = src.loc
		if (isturf(location))
			location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/igniter/power_change()
	..()
	update_icon()

/obj/machinery/igniter/proc/ignite()
	use_power_oneoff(50)
	on = !on
	if(on)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	update_icon()


// Wall mounted remote-control igniter.

/obj/machinery/sparker
	name = "Mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "migniter"
	var/id = null
	var/disable = 0
	var/last_spark = 0
	var/base_state = "migniter"
	anchored = 1
	idle_power_usage = 2
	active_power_usage = 4
	var/_wifi_id
	var/datum/wifi/receiver/button/sparker/wifi_receiver

/obj/machinery/sparker/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/sparker/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/sparker/update_icon()
	..()
	if(disable)
		icon_state = "migniter-d"
	else if(powered())
		icon_state = "migniter"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "migniter-p"
//		src.sd_SetLuminosity(0)

/obj/machinery/sparker/power_change()
	..()
	update_icon()

/obj/machinery/sparker/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.isscrewdriver())
		add_fingerprint(user)
		disable = !disable
		if(disable)
			user.visible_message(SPAN_WARNING("[user] has disabled the [src]!"), SPAN_WARNING("You disable the connection to the [src]."))
		else if(!disable)
			user.visible_message(SPAN_WARNING("[user] has reconnected the [src]!"), SPAN_WARNING("You fix the connection to the [src]."))
		update_icon()
		return TRUE

/obj/machinery/sparker/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	if (anchored)
		return ignite()

/obj/machinery/sparker/proc/ignite()
	if (!powered())
		return

	if (disable || (last_spark && world.time < last_spark + 50))
		return


	flick("migniter-spark", src)
	spark(src, 2, GLOB.alldirs)
	src.last_spark = world.time
	use_power_oneoff(1000)
	var/turf/location = src.loc
	if (isturf(location))
		location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/sparker/emp_act(severity)
	. = ..()

	if(stat & (BROKEN|NOPOWER))
		return

	ignite()

/obj/machinery/button/ignition
	name = "ignition switch"
	desc = "A remote control switch for a mounted igniter."
	active_time = 5 SECONDS
	var/list/datum/weakref/linked_sparkers
	var/list/datum/weakref/linked_igniters

/obj/machinery/button/ignition/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/button/ignition/LateInitialize()
	. = ..()
	for (var/obj/machinery/M in SSmachinery.machinery)
		var/obj/machinery/sparker/S = M
		if (istype(S) && S.id == id)
			LAZYADD(linked_sparkers, WEAKREF(S))
		else
			var/obj/machinery/igniter/I = M
			if (istype(I) && I.id == id)
				LAZYADD(linked_igniters, WEAKREF(I))

/obj/machinery/button/ignition/activate(mob/living/user)
	if(..())
		return

	for (var/datum/weakref/W in linked_sparkers)
		var/obj/machinery/sparker/S = W.resolve()
		if(!isnull(S))
			INVOKE_ASYNC(S, TYPE_PROC_REF(/obj/machinery/sparker, ignite))

	for (var/datum/weakref/W in linked_igniters)
		var/obj/machinery/igniter/I = W.resolve()
		if(!isnull(I))
			I.ignite()
