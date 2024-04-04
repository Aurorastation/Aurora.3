#define OVERLAY_CACHE_LEN 50

/obj/item/device/t_scanner
	name = "\improper T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	icon = 'icons/obj/item/tools/t_scanner.dmi'
	icon_state = "t-ray0"
	item_state = "t-ray"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 100, MATERIAL_ALUMINIUM = 50)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	action_button_name = "Toggle T-Ray scanner"

	var/scan_range = 3

	var/on = 0
	var/list/active_scanned = list() //assoc list of objects being scanned, mapped to their overlay
	var/client/user_client //since making sure overlays are properly added and removed is pretty important, so we track the current user explicitly

	var/global/list/overlay_cache = list() //cache recent overlays

/obj/item/device/t_scanner/Destroy()
	. = ..()
	if(on)
		set_active(FALSE)

/obj/item/device/t_scanner/update_icon()
	icon_state = "t-ray[on]"

/obj/item/device/t_scanner/emp_act(severity)
	. = ..()

	audible_message(src, SPAN_NOTICE("\The [src] buzzes oddly."))
	set_active(FALSE)

/obj/item/device/t_scanner/attack_self(mob/user)
	set_active(!on)
	user.update_action_buttons()

/obj/item/device/t_scanner/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	var/obj/structure/disposalpipe/D = target
	if(istype(D))
		to_chat(user, SPAN_INFO("Pipe segment integrity: [(D.health / 10) * 100]%"))

/obj/item/device/t_scanner/proc/set_active(var/active)
	on = active
	if(on)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
		set_user_client(null)
	update_icon()

//If reset is set, then assume the client has none of our overlays, otherwise we only send new overlays.
/obj/item/device/t_scanner/process()
	if(!on)
		return

	//handle clients changing
	var/client/loc_client = null
	if(ismob(loc))
		var/mob/M = loc
		loc_client = M.client
	set_user_client(loc_client)

	//no sense processing if no-one is going to see it.
	if(!user_client)
		return

	//get all objects in scan range
	var/list/scanned = get_scanned_objects(scan_range)
	var/list/update_add = scanned - active_scanned
	var/list/update_remove = active_scanned - scanned

	//Add new overlays
	for(var/thing in update_add)
		var/obj/O = thing
		var/image/overlay = get_overlay(O)
		active_scanned[O] = overlay
		user_client.images += overlay

	//Remove stale overlays
	for(var/thing in update_remove)
		var/obj/O = thing
		user_client.images -= active_scanned[O]
		active_scanned -= O

//creates a new overlay for a scanned object
/obj/item/device/t_scanner/proc/get_overlay(obj/scanned)
	//Use a cache so we don't create a whole bunch of new images just because someone's walking back and forth in a room.
	//Also means that images are reused if multiple people are using t-rays to look at the same objects.
	if(scanned in overlay_cache)
		. = overlay_cache[scanned]
	else
		var/image/I = image(scanned.icon, scanned.loc, scanned.icon_state, UNDER_HUD_LAYER, scanned.dir)

		//Pipes are special
		if(istype(scanned, /obj/machinery/atmospherics/pipe))
			var/obj/machinery/atmospherics/pipe/P = scanned
			I.color = P.pipe_color
			I.overlays += P.overlays
			I.underlays += P.underlays

		else if(istype(scanned, /obj/structure/cable))
			var/obj/structure/cable/C = scanned
			I.color = C.color

		I.alpha = 100
		I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		. = I

	// Add it to cache, cutting old entries if the list is too long
	overlay_cache[scanned] = .
	if(overlay_cache.len > OVERLAY_CACHE_LEN)
		overlay_cache.Cut(1, overlay_cache.len-OVERLAY_CACHE_LEN-1)

/obj/item/device/t_scanner/proc/get_scanned_objects(var/scan_dist)
	. = list()

	var/turf/center = get_turf(src.loc)
	if(!center)
		return

	for(var/thing in RANGE_TURFS(scan_range, center))
		var/turf/T = thing
		if(!!T.is_plating())
			continue

		for(var/obj/O in T.contents)
			if(O.level != 1)
				continue
			if(!O.invisibility)
				continue //if it's already visible don't need an overlay for it
			. += O


/obj/item/device/t_scanner/proc/set_user_client(var/client/new_client)
	if(new_client == user_client)
		return
	if(user_client)
		for(var/scanned in active_scanned)
			user_client.images -= active_scanned[scanned]
	if(new_client)
		for(var/scanned in active_scanned)
			new_client.images += active_scanned[scanned]
	else
		active_scanned.Cut()

	user_client = new_client

/obj/item/device/t_scanner/dropped(mob/user)
	set_user_client(null)
	..()

#undef OVERLAY_CACHE_LEN
