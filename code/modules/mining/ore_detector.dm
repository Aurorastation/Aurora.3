#define MINOR_ARTIFACTS "Minor Artifacts" // defined solely so someone doesn't typo it
#define MAJOR_ARTIFACTS "Major Artifacts"

#define SURFACE_MINERALS "Surface Minerals"
#define PRECIOUS_METALS "Precious Metals"
#define NUCLEAR_FUEL "Nuclear Fuel"
#define EXOTIC_MATTER "Exotic Matter"

/obj/item/ore_detector
	name = "ore detector"
	desc = "A device capable of locating and displaying ores to the average untrained hole explorer."
	icon = 'icons/obj/item/adv_mining_scanner.dmi'
	icon_state = "advmining0"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	force = 1
	var/active = FALSE
	var/datum/weakref/our_user
	var/list/ore_pings = list()
	var/list/search_ores = list()
	var/ping_rate = 4 SECONDS
	var/last_ping = 0

	var/list/ore_names

	/// The anchor used to render the ore pings on top of, this follows us around as the ore detector resets its blips
	var/obj/item/detector_anchor/anchor

/obj/item/ore_detector/Initialize(mapload, ...)
	. = ..()
	anchor = new /obj/item/detector_anchor(src)

/obj/item/ore_detector/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += FONT_SMALL(SPAN_NOTICE("Alt-click to set the ore you wish to search for."))

/obj/item/ore_detector/Destroy()
	deactivate()
	QDEL_NULL(anchor)
	return ..()

/obj/item/ore_detector/update_icon()
	icon_state = "advmining[active]"

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
	anchor.forceMove(our_turf)
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
			var/image/ore_ping = image(icon = 'icons/obj/item/adv_mining_scanner.dmi', icon_state = "signal_overlay", loc = anchor, layer = UNDER_HUD_LAYER)
			ore_ping.appearance_flags |= KEEP_APART|RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM
			ore_ping.pixel_x = rand(-6, 6)
			ore_ping.pixel_y = rand(-6, 6)
			ore_ping.alpha = rand(180, 255)
			ore_ping.plane = HUD_PLANE
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

// horrendous hack, but it's an engine limitation
// the way images work is that it's only show to a client when you add it via client.images += I
// the problem with that is it needs a loc to attach to, and if you attach it to a turf, the image is only visible if that turf is visible
// meaning that you can't see it through walls, which is the whole point of the detector
// so, what we do instead, is spawn this anchor beneath the player and attach all the images to the anchor, then pixel shift them to the turf it needs to render over
// the reason we're making the anchor instead of just making the loc our turf, is that clicking on an image passes the click through to whatever it's attached to, it works like an overlay
// so the right click menu gets messed up, and clicking on the ore blip means you actually click beneath yourself, which can be disastrous
// so, by having an anchor with MOUSE_OPACITY_TRANSPARENT, we can circumvent ALL those issues
/obj/item/detector_anchor
	icon = null
	icon_state = null
	alpha = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	density = FALSE

#undef MINOR_ARTIFACTS
#undef MAJOR_ARTIFACTS

#undef SURFACE_MINERALS
#undef PRECIOUS_METALS
#undef NUCLEAR_FUEL
#undef EXOTIC_MATTER
