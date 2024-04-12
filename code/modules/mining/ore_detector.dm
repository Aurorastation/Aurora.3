#define MINOR_ARTIFACTS "Minor Artifacts" // defined solely so someone doesn't typo it
#define MAJOR_ARTIFACTS "Major Artifacts"

#define SURFACE_MINERALS "Surface Minerals"
#define PRECIOUS_METALS "Precious Metals"
#define NUCLEAR_FUEL "Nuclear Fuel"
#define EXOTIC_MATTER "Exotic Matter"

/obj/item/ore_detector
	name = "ore detector"
	desc = "A device capable of locating and displaying ores to the average untrained hole explorer."
	icon = 'icons/obj/item/tools/ore_scanner.dmi'
	icon_state = "ore_scanner"
	item_state = "ore_scanner"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	force = 1
	var/active = FALSE
	var/datum/weakref/our_user
	var/list/ore_pings = list()
	var/list/search_ores = list()
	var/ping_rate = 4 SECONDS
	var/last_ping = 0

	var/list/ore_names

/obj/item/ore_detector/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += FONT_SMALL(SPAN_NOTICE("Alt-click to set the ore you wish to search for."))

/obj/item/ore_detector/Destroy()
	deactivate()
	return ..()

/obj/item/ore_detector/update_icon()
	icon_state = "ore_scanner[active ? "-active" : ""]"

/obj/item/ore_detector/attack_self(mob/user)
	ui_interact(user)

/obj/item/ore_detector/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OreDetector", ui_x=400, ui_y=420)
		ui.open()

/obj/item/ore_detector/ui_data(mob/user)
	if(!length(ore_names))
		ore_names = list()
		for(var/ore_n in GLOB.ore_data)
			var/ore/O = GLOB.ore_data[ore_n]
			var/ore_name = O.display_name
			ore_names += ore_name
		ore_names += SURFACE_MINERALS
		ore_names += PRECIOUS_METALS
		ore_names += NUCLEAR_FUEL
		ore_names += EXOTIC_MATTER
		ore_names += MINOR_ARTIFACTS
		ore_names += MAJOR_ARTIFACTS

	var/list/data = list()
	data["ore_names"] = ore_names
	data["search_ores"] = search_ores
	data["enabled"] = active
	return data

/obj/item/ore_detector/ui_act(action,params)
	. = ..()
	if(.)
		return
	if(action=="toggle")
		if(active)
			deactivate()
		else
			activate(usr)
		. = TRUE
		update_icon()
	if(action=="select_ore")
		if(params["ore_name"] in search_ores)
			search_ores -= params["ore_name"]
		else
			search_ores += params["ore_name"]
		if(!length(search_ores))
			deactivate()
		. = TRUE

/obj/item/ore_detector/process()
	if(last_ping + ping_rate > world.time)
		return
	if(isnull(our_user))
		deactivate()
		return
	clear_images()
	var/mob/M = our_user.resolve()
	if(loc != M && loc.loc != M)
		deactivate()
		return
	last_ping = world.time
	var/turf/our_turf = get_turf(src)
	for(var/turf/turf as anything in RANGE_TURFS(7, our_turf))
		if(isnull(our_user)) // in the event it's dropped midsweep
			return

		var/found_ores = FALSE
		if(
			length(turf.resources) && \
			( \
				((SURFACE_MINERALS in search_ores) && (ORE_IRON in turf.resources)) || \
				((PRECIOUS_METALS in search_ores) && ((ORE_GOLD in turf.resources) || (ORE_SILVER in turf.resources) || (ORE_DIAMOND in turf.resources))) || \
				((NUCLEAR_FUEL in search_ores) && (ORE_URANIUM in turf.resources)) || \
				((EXOTIC_MATTER in search_ores) && ((ORE_PHORON in turf.resources) || (ORE_PLATINUM in turf.resources) || (ORE_HYDROGEN in turf.resources))) \
			) \
		)
			found_ores = TRUE

		if(!found_ores)
			var/turf/simulated/mineral/mine_turf = turf
			if(istype(mine_turf, /turf/simulated/mineral))
				if((length(mine_turf.finds) && (MINOR_ARTIFACTS in search_ores)) || (mine_turf.artifact_find && (MAJOR_ARTIFACTS in search_ores)) || (mine_turf.mineral && (mine_turf.mineral.display_name in search_ores)))
					found_ores = TRUE

		if(found_ores)
			var/image/ore_ping = image(icon = 'icons/obj/item/tools/ore_scanner.dmi', icon_state = "signal_overlay", loc = our_turf, layer = UNDER_HUD_LAYER)
			ore_ping.pixel_x = rand(-6, 6)
			ore_ping.pixel_y = rand(-6, 6)
			ore_ping.alpha = rand(180, 255)
			pixel_shift_to_turf(ore_ping, our_turf, turf)
			if(M.client)
				M.client.images += ore_ping
			ore_pings += ore_ping

/obj/item/ore_detector/emp_act(severity)
	. = ..()

	deactivate()

/obj/item/ore_detector/proc/activate(var/mob/user)
	if(!length(search_ores))
		return
	START_PROCESSING(SSprocessing, src)
	our_user = WEAKREF(user)
	active = TRUE
	update_icon()

/obj/item/ore_detector/proc/deactivate()
	active = FALSE
	STOP_PROCESSING(SSprocessing, src)
	clear_images()
	our_user = null
	update_icon()

/obj/item/ore_detector/proc/clear_images()
	var/mob/M = our_user?.resolve()
	if(M?.client)
		M.client.images -= ore_pings
	ore_pings.Cut()

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

#undef SURFACE_MINERALS
#undef PRECIOUS_METALS
#undef NUCLEAR_FUEL
#undef EXOTIC_MATTER
