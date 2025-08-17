/obj/machinery/slime_extractor
	name = "slime core extractor"
	desc = "A bulky machine that, when fed a slime corpse, rapidly extracts the held cores."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "slime_extractor"
	density = TRUE
	anchored = TRUE
	var/slime_limit = 2 // how many slimes we can process at a time
	var/extraction_speed = 150
	idle_power_usage = 15
	active_power_usage = 50
	var/list/mob/living/carbon/slime/extract_slimes = list()

	component_types = list(
		/obj/item/circuitboard/slime_extractor,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stack/cable_coil{amount = 5}
	)

/obj/machinery/slime_extractor/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It will place slime extracts into a slime extract bag automatically if it's adjacent to the machine."

/obj/machinery/slime_extractor/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>matter bins</b> will increase slime capacity."
	. += "Upgraded <b>micro-lasers</b> will increase extraction speed."

/obj/machinery/slime_extractor/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It can hold <b>[slime_limit] slime\s</b> at a time."
	if(length(extract_slimes))
		. += "It is currently processing <b>[length(extract_slimes)] slime\s</b>."

/obj/machinery/slime_extractor/update_icon()
	ClearOverlays()
	if(panel_open)
		var/mutable_appearance/panel_overlay = mutable_appearance(icon, "[icon_state]-panel")
		AddOverlays(panel_overlay)
	if(length(extract_slimes))
		var/mutable_appearance/interior_overlay = mutable_appearance(icon, "[icon_state]-interior", plane = EFFECTS_ABOVE_LIGHTING_PLANE)
		AddOverlays(interior_overlay)
		var/mutable_appearance/spinning_overlay = mutable_appearance(icon, "[icon_state]-running", plane = EFFECTS_ABOVE_LIGHTING_PLANE)
		AddOverlays(spinning_overlay)
		set_light(2.5, 1, COLOR_VIOLET)
	else
		set_light(FALSE)

/obj/machinery/slime_extractor/RefreshParts()
	..()
	slime_limit = initial(slime_limit)
	extraction_speed = initial(extraction_speed)

	for(var/obj/item/stock_parts/P in component_parts)
		if(ismatterbin(P))
			slime_limit *= P.rating
		else if(ismicrolaser(P))
			extraction_speed = extraction_speed / P.rating

/obj/machinery/slime_extractor/attackby(obj/item/attacking_item, mob/user)
	if(length(extract_slimes))
		to_chat(user, SPAN_WARNING("You can't modify \the [src] while it's busy. Please wait for the completion of previous operation."))
		return

	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return

/obj/machinery/slime_extractor/mouse_drop_receive(atom/dropped, mob/user, params)
	if(!Adjacent(user))
		to_chat(user, SPAN_WARNING("You can't reach \the [src]!"))
		return
	if(isslime(dropped))
		var/mob/living/carbon/slime/slimey = dropped
		if(length(extract_slimes) >= slime_limit)
			to_chat(user, SPAN_WARNING("\The [src] is fully loaded!"))
			return
		user.visible_message(SPAN_NOTICE("\The [user] starts loading \the [slimey] into \the [src]..."), SPAN_NOTICE("You start loading \the [slimey] into \the [src]..."))
		if(do_after(user, 20))
			user.visible_message(SPAN_NOTICE("\The user loads \the [slimey] into \the [src]."), SPAN_NOTICE("You load \the [slimey] into \the [src]."))
			slimey.forceMove(src)
			extract_slimes[slimey] = slimey
			addtimer(CALLBACK(src, PROC_REF(extraction_process), slimey), extraction_speed)
			update_icon()

/obj/machinery/slime_extractor/proc/extraction_process(var/slime)
	var/mob/living/carbon/slime/extracted_slime = extract_slimes[slime]
	if(!extracted_slime)
		extract_slimes -= slime
		update_icon()
		return
	for(var/i = 1 to extracted_slime.cores + 1)
		var/obj/extract = new extracted_slime.coretype(get_turf(src))
		var/obj/item/storage/slimes/slime_bag = locate() in range(1, get_turf(src))
		if(slime_bag && Adjacent(slime_bag))
			slime_bag.handle_item_insertion(extract)
		else
			extract.pixel_y = -10 // to make it layer beneath the overlay
			extract.pixel_x = rand(-6, 6)
	playsound(get_turf(src), 'sound/effects/splat.ogg', 50, TRUE)
	extract_slimes -= extracted_slime
	qdel(extracted_slime)
	update_icon()

#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/slime_extractor
	name = T_BOARD("slime extractor")
	build_path = "/obj/machinery/slime_extractor"
	board_type = BOARD_MACHINE
	origin_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 1, TECH_BLUESPACE = 1)
	req_components = list(
		"/obj/item/stock_parts/matter_bin" = 1,
		"/obj/item/stock_parts/micro_laser" = 1,
		"/obj/item/stack/cable_coil" = 5
	)
