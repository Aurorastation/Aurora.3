/obj/item/ore_detector
	name = "ore detector"
	desc = "A device capable of locating and displaying ores to the average untrained hole explorer."
	icon = 'icons/obj/contained_items/tools/ore_scanner.dmi'
	icon_state = "ore_scanner"
	item_state = "ore_scanner"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	force = 1
	var/active = FALSE
	var/mob/our_user
	var/search_ore
	var/list/detection_types
	var/ping_rate = 4 SECONDS
	var/last_ping = 0

	var/list/ore_names

/obj/item/ore_detector/examine(mob/user, distance)
	if(..(user, 1))
		to_chat(user, FONT_SMALL(SPAN_NOTICE("Alt-click to set the ore you wish to search for.")))

/obj/item/ore_detector/Destroy()
	deactivate()
	return ..()

/obj/item/ore_detector/update_icon()
	icon_state = "ore_scanner[active ? "-active" : ""]"

/obj/item/ore_detector/attack_self(mob/user)
	if(!search_ore)
		to_chat(user, SPAN_WARNING("You haven't set an ore to search for yet!"))
		return
	active = !active
	var/msg = "You [active ? "activate" : "deactivate"] \the [src]."
	to_chat(user, SPAN_NOTICE(msg))
	if(active)
		activate(user)
	else
		deactivate()

/obj/item/ore_detector/AltClick(mob/user)
	if(!length(ore_names))
		ore_names = list()
		for(var/ore_n in ore_data)
			var/ore/O = ore_data[ore_n]
			var/ore_name = capitalize_first_letters(O.display_name)
			ore_names[ore_name] = O.type
	if(loc == user)
		var/ore_type = input(user, "Select the ore you would like to detect.", "Ore Selection") as null|anything in ore_names
		if(!ore_type)
			return
		search_ore = ore_names[ore_type]
		to_chat(user, SPAN_NOTICE("You configure \the [src] to search for <b>[ore_type]</b>."))
	else
		return ..()

/obj/item/ore_detector/process()
	if(last_ping + ping_rate > world.time)
		return
	if(loc != our_user && loc.loc != our_user)
		deactivate()
		return
	last_ping = world.time
	var/turf/our_turf = get_turf(src)
	for(var/turf/simulated/mineral/mine_turf in RANGE_TURFS(7, our_turf))
		if(isnull(our_user)) // in the event it's dropped midsweep
			return
		if(mine_turf.mineral?.type == search_ore)
			var/image/ore_ping = image(icon = 'icons/obj/contained_items/tools/ore_scanner.dmi', icon_state = "signal_overlay", loc = mine_turf)
			ore_ping.layer = OBFUSCATION_LAYER + 0.1
			our_user << ore_ping
			QDEL_IN(ore_ping, 4 SECONDS)

/obj/item/ore_detector/emp_act()
	deactivate()

/obj/item/ore_detector/proc/activate(var/mob/user)
	if(!search_ore)
		to_chat(user, SPAN_WARNING("You haven't set an ore to search for yet!"))
		return
	START_PROCESSING(SSprocessing, src)
	our_user = user
	update_icon()

/obj/item/ore_detector/proc/deactivate()
	STOP_PROCESSING(SSprocessing, src)
	our_user = null
	update_icon()

/obj/item/ore_detector/throw_at()
	..()
	deactivate()

/obj/item/ore_detector/dropped()
	..()
	deactivate()

/obj/item/ore_detector/on_give()
	deactivate()