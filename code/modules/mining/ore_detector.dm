#define MINOR_ARTIFACTS "Minor Artifacts" // defined solely so someone doesn't typo it
#define MAJOR_ARTIFACTS "Major Artifacts"

/obj/item/ore_detector
	name = "ore detector"
	desc = "A device capable of locating and displaying ores to the average untrained hole explorer."
	icon = 'icons/obj/item/ore_scanner.dmi'
	icon_state = "ore_scanner"
	item_state = "ore_scanner"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	force = 1
	var/active = FALSE
	var/datum/weakref/our_user
	var/list/search_ores = list()
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
	if(!length(search_ores))
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
			var/ore_name = O.display_name
			ore_names += ore_name
		ore_names += MINOR_ARTIFACTS
		ore_names += MAJOR_ARTIFACTS
	if(loc == user)
		var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
		if(!ui)
			ui = new(user, src, "devices-oredetector", 320, 220, capitalize_first_letters(name))
		ui.open()
	else
		return ..()

/obj/item/ore_detector/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	VUEUI_SET_CHECK_LIST(data["ore_names"], ore_names, ., data)
	VUEUI_SET_CHECK_LIST(data["selected_ores"], search_ores, ., data)

/obj/item/ore_detector/Topic(href, href_list)
	..()

	if(href_list["chosen_ore"])
		if(href_list["chosen_ore"] in search_ores)
			search_ores -= href_list["chosen_ore"]
		else
			search_ores += href_list["chosen_ore"]

	SSvueui.check_uis_for_change(src)

/obj/item/ore_detector/process()
	if(last_ping + ping_rate > world.time)
		return
	if(isnull(our_user))
		deactivate()
		return
	var/mob/M = our_user.resolve()
	if(loc != M && loc.loc != M)
		deactivate()
		return
	last_ping = world.time
	var/turf/our_turf = get_turf(src)
	for(var/turf/simulated/mineral/mine_turf in RANGE_TURFS(7, our_turf))
		if(isnull(our_user)) // in the event it's dropped midsweep
			return
		if((length(mine_turf.finds) && (MINOR_ARTIFACTS in search_ores)) || (mine_turf.artifact_find && (MAJOR_ARTIFACTS in search_ores)) || (mine_turf.mineral && (mine_turf.mineral.display_name in search_ores)))
			var/image/ore_ping = image(icon = 'icons/obj/item/ore_scanner.dmi', icon_state = "signal_overlay", loc = our_turf, layer = OBFUSCATION_LAYER + 0.1)
			pixel_shift_to_turf(ore_ping, our_turf, mine_turf)
			M << ore_ping
			QDEL_IN(ore_ping, 4 SECONDS)

/obj/item/ore_detector/emp_act()
	deactivate()

/obj/item/ore_detector/proc/activate(var/mob/user)
	if(!length(search_ores))
		return
	START_PROCESSING(SSprocessing, src)
	our_user = WEAKREF(user)
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

#undef MINOR_ARTIFACTS
#undef MAJOR_ARTIFACTS
