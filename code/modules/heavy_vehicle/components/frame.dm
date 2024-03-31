/obj/item/frame_holder
	matter = list(DEFAULT_WALL_MATERIAL = 65000, MATERIAL_PLASTIC = 10000, MATERIAL_OSMIUM = 10000)

/obj/item/frame_holder/Initialize(mapload, var/newloc)
	..()
	new /obj/structure/heavy_vehicle_frame(newloc)
	return  INITIALIZE_HINT_QDEL

/obj/structure/heavy_vehicle_frame
	name = "exosuit frame"
	desc = "The frame for an exosuit, apparently."
	icon = 'icons/mecha/mech_parts.dmi'
	icon_state = "backbone"
	density = 1
	pixel_x = -8

	// Holders for the final product.
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body
	var/is_wired = 0
	var/is_reinforced = 0
	var/set_name
	dir = SOUTH

/obj/structure/heavy_vehicle_frame/proc/set_colour(var/new_colour)
	var/painted_component = FALSE
	for(var/obj/item/mech_component/comp in list(body, arms, legs, head))
		if(comp.set_colour(new_colour))
			painted_component = TRUE
	if(painted_component)
		update_icon()

/obj/structure/heavy_vehicle_frame/Destroy()
	QDEL_NULL(arms)
	QDEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)
	. = ..()

/obj/structure/heavy_vehicle_frame/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!arms)
		. += SPAN_WARNING("It is missing some <a href='?src=\ref[src];info=manipulators'>manipulators</a>.")
	if(!legs)
		. += SPAN_WARNING("It is missing a means of <a href='?src=\ref[src];info=propulsion'>propulsion</a>.")
	if(!head)
		. += SPAN_WARNING("It is missing some <a href='?src=\ref[src];info=sensors'>sensors</a>.")
	if(!body)
		. += SPAN_WARNING("It is missing a <a href='?src=\ref[src];info=chassis'>chassis</a>.")
	if(is_wired == FRAME_WIRED)
		. += SPAN_WARNING("Its wiring is <a href='?src=\ref[src];info=wire'>unadjusted</a>.")
	else if(!is_wired)
		. += SPAN_WARNING("It has not yet been <a href='?src=\ref[src];info=wire'>wired</a>.")
	if(is_reinforced == FRAME_REINFORCED)
		. += SPAN_WARNING("It has not had its <a href='?src=\ref[src];info=reinforcement'>internal reinforcement</a> secured.")
	else if(is_reinforced == FRAME_REINFORCED_SECURE)
		. += SPAN_WARNING("It has not had its <a href='?src=\ref[src];info=reinforcement'>internal reinforcement</a> welded in.")
	else if(!is_reinforced)
		. += SPAN_WARNING("It does not have any <a href='?src=\ref[src];info=reinforcement'>internal reinforcement</a>.")

/obj/structure/heavy_vehicle_frame/Topic(href, href_list)
	. = ..()
	if(.)
		return
	switch(href_list["info"])
		if("manipulators")
			to_chat(usr, SPAN_NOTICE("Manipulators, the arms of the exosuit, can be created at a mechatronic fabricator."))
		if("propulsion")
			to_chat(usr, SPAN_NOTICE("Propulsion, the legs of the exosuit, can be created at a mechatronic fabricator."))
		if("sensors")
			to_chat(usr, SPAN_NOTICE("Sensors, the head of the exosuit, can be created at a mechatronic fabricator."))
		if("chassis")
			to_chat(usr, SPAN_NOTICE("A chassis, the body of the exosuit, can be created at a mechatronic fabricator."))
		if("wire")
			if(!is_wired)
				to_chat(usr, SPAN_NOTICE("The frame requires wiring between its components. This can be added with cable coil."))
			else if(is_wired == FRAME_WIRED)
				to_chat(usr, SPAN_NOTICE("The wiring of the frame is messy, and requires a wirecutter to trim it for use."))
		if("reinforcement")
			if(!is_reinforced)
				to_chat(usr, SPAN_NOTICE("The frame requires reinforcement, this can be added with steel sheets."))
			else if(is_reinforced == FRAME_REINFORCED)
				to_chat(usr, SPAN_NOTICE("The frame's reinforcement has been installed, now it must be wrenched into place."))
			else if(is_reinforced == FRAME_REINFORCED_SECURE)
				to_chat(usr, SPAN_NOTICE("The frame's reinforcement has been installed and secured, now it must be welded into place."))

/obj/structure/heavy_vehicle_frame/update_icon()
	//As mech icons uses a caching system, any changes here, particularly to layers, must be reflected in /mob/living/heavy_vehicle/update_icon().
	var/list/new_overlays = get_mech_icon(list(body), MECH_BASE_LAYER)
	if(body)
		density = TRUE
		new_overlays += get_mech_image("[body.icon_state]_cockpit", body.on_mech_icon, MECH_BASE_LAYER)
	else
		density = FALSE
	if(head)
		new_overlays += get_mech_image("[head.icon_state]", head.on_mech_icon, head.color, MECH_HEAD_LAYER)
		new_overlays += get_mech_image("[head.icon_state]_eyes", head.on_mech_icon, null, MECH_EYES_LAYER)
	if(arms)
		new_overlays += get_mech_image(arms.icon_state, arms.on_mech_icon, arms.color, MECH_ARM_LAYER)
	if(legs)
		new_overlays += get_mech_image(legs.icon_state, legs.on_mech_icon, legs.color, MECH_LEG_LAYER)
	overlays = new_overlays
	if(density != opacity)
		set_opacity(density)

/obj/structure/heavy_vehicle_frame/set_dir()
	..(SOUTH)

/obj/structure/heavy_vehicle_frame/attackby(obj/item/attacking_item, mob/user)

	// Removing components.
	if(attacking_item.iscrowbar())
		if(is_reinforced == FRAME_REINFORCED)
			user.visible_message(SPAN_NOTICE("\The [user] crowbars the reinforcement off \the [src]."))
			new /obj/item/stack/material/steel(loc, 15)
			is_reinforced = 0
			return

		var/to_remove = tgui_input_list(user, "Which component would you like to remove?", "Remove Component", list(arms, body, legs, head))

		if(!to_remove)
			to_chat(user, SPAN_WARNING("There are no components to remove.."))
			return

		if(uninstall_component(to_remove, user))
			if(to_remove == arms)
				arms = null
			else if(to_remove == body)
				body = null
			else if(to_remove == legs)
				legs = null
			else if(to_remove == head)
				head = null

		update_icon()
		return

	// Final construction step.
	else if(attacking_item.isscrewdriver())

		// Check for basic components.
		if(!(arms && legs && head && body))
			to_chat(user, SPAN_WARNING("There are still parts missing from \the [src]."))
			return

		// Check for wiring.
		if(is_wired < FRAME_WIRED_ADJUSTED)
			if(is_wired == FRAME_WIRED)
				to_chat(user, SPAN_WARNING("\The [src]'s wiring has not been adjusted!"))
			else
				to_chat(user, SPAN_WARNING("\The [src] is not wired!"))
			return

		// Check for basing metal internal plating.
		if(is_reinforced < FRAME_REINFORCED_WELDED)
			if(is_reinforced == FRAME_REINFORCED)
				to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcement has not been secured!"))
			else if(is_reinforced == FRAME_REINFORCED_SECURE)
				to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcement has not been welded down!"))
			else
				to_chat(user, SPAN_WARNING("\The [src] has no internal reinforcement!"))
			return

		if(is_reinforced < FRAME_REINFORCED_WELDED || is_wired < FRAME_WIRED_ADJUSTED || !(arms && legs && head && body) || QDELETED(src) || QDELETED(user))
			return

		// We're all done. Finalize the mech and pass the frame to the new system.
		var/mob/living/heavy_vehicle/M = new(get_turf(src), src)
		visible_message("\The [user] finishes off \the [M].")
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

		arms = null
		legs = null
		head = null
		body = null
		qdel(src)

		return

	// Installing wiring.
	else if(attacking_item.iscoil())

		if(is_wired)
			to_chat(user, SPAN_WARNING("\The [src] has already been wired."))
			return

		var/obj/item/stack/cable_coil/CC = attacking_item
		if(CC.amount < 10)
			to_chat(user, SPAN_WARNING("You need at least ten units of cable to complete the exosuit."))
			return

		user.visible_message("\The [user] begins wiring \the [src]...")

		if(!do_after(user, 30))
			return

		if(!CC || !user || !src || CC.amount < 10 || is_wired)
			return

		CC.use(10)
		user.visible_message("\The [user] installs wiring in \the [src].")
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		is_wired = FRAME_WIRED
	// Securing wiring.
	else if(attacking_item.iswirecutter())
		if(!is_wired)
			to_chat(user, "There is no wiring in \the [src] to neaten.")
			return

		visible_message("\The [user] [(is_wired == FRAME_WIRED_ADJUSTED) ? "snips some of" : "neatens"] the wiring in \the [src].")
		attacking_item.play_tool_sound(get_turf(src), 100)
		is_wired = (is_wired == FRAME_WIRED_ADJUSTED) ? FRAME_WIRED : FRAME_WIRED_ADJUSTED
	// Installing metal.
	else if(istype(attacking_item, /obj/item/stack/material))
		var/obj/item/stack/material/M = attacking_item
		if(M.material?.name == MATERIAL_STEEL)
			if(is_reinforced)
				to_chat(user, SPAN_WARNING("There is already metal reinforcement installed in \the [src]."))
				return
			if(M.amount < 15)
				to_chat(user, SPAN_WARNING("You need at least fifteen sheets of steel to reinforce \the [src]."))
				return
			visible_message("\The [user] reinforces \the [src] with \the [M].")
			playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			is_reinforced = FRAME_REINFORCED
			M.use(15)
		else
			return ..()
	// Securing metal.
	else if(attacking_item.iswrench())
		if(!is_reinforced)
			to_chat(user, SPAN_WARNING("There is no metal to secure inside \the [src]."))
			return
		if(is_reinforced == FRAME_REINFORCED_WELDED)
			to_chat(user, SPAN_WARNING("\The [src]'s internal reinforcement has been welded in."))
			return
		visible_message("\The [user] [(is_reinforced == 2) ? "unsecures" : "secures"] the metal reinforcement in \the [src].")
		attacking_item.play_tool_sound(get_turf(src), 100)
		is_reinforced = (is_reinforced == FRAME_REINFORCED_SECURE) ? FRAME_REINFORCED : FRAME_REINFORCED_SECURE
	// Welding metal.
	else if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(!is_reinforced)
			to_chat(user, SPAN_WARNING("There is no metal to secure inside \the [src]."))
			return
		if(is_reinforced == FRAME_REINFORCED)
			to_chat(user, SPAN_WARNING("The reinforcement inside \the [src] has not been secured."))
			return
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("Turn \the [WT] on, first."))
			return
		if(WT.use(1, user))
			visible_message("\The [user] [(is_reinforced == 3) ? "unwelds the reinforcement from" : "welds the reinforcement into"] \the [src].")
			is_reinforced = (is_reinforced == FRAME_REINFORCED_WELDED) ? FRAME_REINFORCED_SECURE : FRAME_REINFORCED_WELDED
			attacking_item.play_tool_sound(get_turf(src), 50)
		else
			to_chat(user, SPAN_WARNING("Not enough fuel!"))
			return
	// Installing basic components.
	else if(istype(attacking_item,/obj/item/mech_component/manipulators))
		if(arms)
			to_chat(user, SPAN_WARNING("\The [src] already has manipulators installed."))
			return
		if(install_component(attacking_item, user))
			if(arms)
				attacking_item.dropInto(loc)
				return
			arms = attacking_item
	else if(istype(attacking_item,/obj/item/mech_component/propulsion))
		if(legs)
			to_chat(user, SPAN_WARNING("\The [src] already has a propulsion system installed."))
			return
		if(install_component(attacking_item, user))
			if(legs)
				attacking_item.dropInto(loc)
				return
			legs = attacking_item
	else if(istype(attacking_item,/obj/item/mech_component/sensors))
		if(head)
			to_chat(user, SPAN_WARNING("\The [src] already has a sensor array installed."))
			return
		if(install_component(attacking_item, user))
			if(head)
				attacking_item.dropInto(loc)
				return
			head = attacking_item
	else if(istype(attacking_item,/obj/item/mech_component/chassis))
		if(body)
			to_chat(user, SPAN_WARNING("\The [src] already has an outer chassis installed."))
			return
		if(install_component(attacking_item, user))
			if(body)
				attacking_item.dropInto(loc)
				return
			body = attacking_item
	else
		return ..()
	update_icon()

/obj/structure/heavy_vehicle_frame/proc/install_component(var/obj/item/thing, var/mob/user)
	var/obj/item/mech_component/MC = thing
	if(istype(MC) && !MC.ready_to_install())
		if(user) to_chat(user, SPAN_WARNING("\The [MC] is not ready to install."))
		return 0
	user.unEquip(thing)
	thing.forceMove(src)
	visible_message("\The [user] installs \the [thing] into \the [src].")
	playsound(user.loc, 'sound/machines/click.ogg', 50, 1)
	return 1

/obj/structure/heavy_vehicle_frame/proc/uninstall_component(var/obj/item/component, var/mob/user)
	if(!istype(component) || (component.loc != src) || !istype(user))
		return FALSE

	user.visible_message("\The [user] crowbars \the [component] off \the [src].")
	component.forceMove(get_turf(src))
	user.put_in_hands(component)
	playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return TRUE
