/obj/machinery/slime_extractor
	name = "slime core extractor"
	desc = "A bulky machine that, when fed a slime corpse, rapidly extracts the held cores."
	desc_info = "This machine can be upgraded with a micro laser to increase its extraction speed, or a matter bin to increase its slime capacity. It will place slime extracts into a slime extract bag if it's adjacent to the machine."
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

/obj/machinery/slime_extractor/examine(mob/user)
	. = ..()
	to_chat(user, FONT_SMALL(SPAN_NOTICE("It can hold <b>[slime_limit] slime\s</b> at a time.")))
	if(length(extract_slimes))
		to_chat(user, FONT_SMALL(SPAN_WARNING("It is currently processing <b>[length(extract_slimes)] slime\s</b>.")))

/obj/machinery/slime_extractor/update_icon()
	cut_overlays()
	if(panel_open)
		var/mutable_appearance/panel_overlay = mutable_appearance(icon, "[icon_state]-panel")
		add_overlay(panel_overlay)
	if(length(extract_slimes))
		var/mutable_appearance/interior_overlay = mutable_appearance(icon, "[icon_state]-interior", EFFECTS_ABOVE_LIGHTING_LAYER)
		add_overlay(interior_overlay)
		var/mutable_appearance/spinning_overlay = mutable_appearance(icon, "[icon_state]-running", EFFECTS_ABOVE_LIGHTING_LAYER)
		add_overlay(spinning_overlay)
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

/obj/machinery/slime_extractor/attackby(obj/item/O, mob/user)
	if(length(extract_slimes))
		to_chat(user, SPAN_WARNING("You can't modify \the [src] while it's busy. Please wait for the completion of previous operation."))
		return

	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

/obj/machinery/slime_extractor/MouseDrop_T(atom/dropping, mob/user)
	if(!Adjacent(user))
		to_chat(user, SPAN_WARNING("You can't reach \the [src]!"))
		return
	if(isslime(dropping))
		var/mob/living/carbon/slime/slimey = dropping
		if(length(extract_slimes) >= slime_limit)
			to_chat(user, SPAN_WARNING("\The [src] is fully loaded!"))
			return
		user.visible_message(SPAN_NOTICE("\The [user] starts loading \the [slimey] into \the [src]..."), SPAN_NOTICE("You start loading \the [slimey] into \the [src]..."))
		if(do_after(user, 20))
			user.visible_message(SPAN_NOTICE("\The user loads \the [slimey] into \the [src]."), SPAN_NOTICE("You load \the [slimey] into \the [src]."))
			slimey.forceMove(src)
			extract_slimes[slimey] = slimey
			addtimer(CALLBACK(src, .proc/extraction_process, slimey), extraction_speed)
			update_icon()

/obj/machinery/slime_extractor/proc/extraction_process(var/slime)
	var/mob/living/carbon/slime/extracted_slime = extract_slimes[slime]
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
	board_type = "machine"
	origin_tech = list(TECH_BIO = 2, TECH_ENGINEERING = 1, TECH_BLUESPACE = 1)
	req_components = list(
		"/obj/item/stock_parts/matter_bin" = 1,
		"/obj/item/stock_parts/micro_laser" = 1,
		"/obj/item/stack/cable_coil" = 5
	)
