/obj/item/frame_holder
	matter = list(DEFAULT_WALL_MATERIAL = 65000, MATERIAL_PLASTIC = 10000, MATERIAL_OSMIUM = 10000)

/obj/item/frame_holder/Initialize(mapload, var/newloc)
	..()
	new /obj/structure/heavy_vehicle_frame(newloc)
	return  INITIALIZE_HINT_QDEL

/obj/structure/heavy_vehicle_frame
	name = "exosuit frame"
	desc = "The frame for am exosuit, apparently."
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

/obj/structure/heavy_vehicle_frame/examine(mob/user)
	. = ..()
	if(!arms)
		to_chat(user, "<span class='warning'>It is missing some manipulators.</span>")
	if(!legs)
		to_chat(user, "<span class='warning'>It is missing a means of propulsion.</span>")
	if(!head)
		to_chat(user, "<span class='warning'>It is missing some sensors.</span>")
	if(!body)
		to_chat(user, "<span class='warning'>It is missing a chassis.</span>")
	if(is_wired == FRAME_WIRED)
		to_chat(user, "<span class='warning'>Its wiring is unadjusted.</span>")
	else if(!is_wired)
		to_chat(user, "<span class='warning'>It has not yet been wired.</span>")
	if(is_reinforced == FRAME_REINFORCED)
		to_chat(user, "<span class='warning'>It has not had its internal reinforcement secured.</span>")
	else if(is_reinforced == FRAME_REINFORCED_SECURE)
		to_chat(user, "<span class='warning'>It has not had its internal reinforcement welded in.</span>")
	else if(!is_reinforced)
		to_chat(user, "<span class='warning'>It does not have any internal reinforcement.</span>")


/obj/structure/heavy_vehicle_frame/update_icon()
	var/list/new_overlays = get_mech_icon(list(body, head), MECH_BASE_LAYER)
	if(body)
		density = TRUE
		overlays += get_mech_image("[body.icon_state]_cockpit", body.icon, body.color)
		if(body.pilot_coverage < 100 || body.transparent_cabin)
			new_overlays += get_mech_image("[body.icon_state]_open_overlay", body.icon, body.color)
	else
		density = FALSE
	if(arms)
		new_overlays += get_mech_image(arms.icon_state, arms.on_mech_icon, arms.color, MECH_ARM_LAYER)
	if(legs)
		new_overlays += get_mech_image(legs.icon_state, legs.on_mech_icon, legs.color, MECH_LEG_LAYER)
	overlays = new_overlays
	if(density != opacity)
		set_opacity(density)

/obj/structure/heavy_vehicle_frame/set_dir()
	..(SOUTH)

/obj/structure/heavy_vehicle_frame/attackby(var/obj/item/thing, var/mob/user)

	// Removing components.
	if(thing.iscrowbar())
		if(is_reinforced == FRAME_REINFORCED)
			user.visible_message("<span class='notice'>\The [user] crowbars \the reinforcement off \the [src].</span>")
			is_reinforced = 0
			return

		var/to_remove = input("Which component would you like to remove") as null|anything in list(arms, body, legs, head)

		if(!to_remove)
			to_chat(user, "<span class='warning'>There are no components to remove..</span>")
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
	else if(thing.isscrewdriver())

		// Check for basic components.
		if(!(arms && legs && head && body))
			to_chat(user, "<span class='warning'>There are still parts missing from \the [src].</span>")
			return

		// Check for wiring.
		if(is_wired < FRAME_WIRED_ADJUSTED)
			if(is_wired == FRAME_WIRED)
				to_chat(user, "<span class='warning'>\The [src]'s wiring has not been adjusted!</span>")
			else
				to_chat(user, "<span class='warning'>\The [src] is not wired!</span>")
			return

		// Check for basing metal internal plating.
		if(is_reinforced < FRAME_REINFORCED_WELDED)
			if(is_reinforced == FRAME_REINFORCED)
				to_chat(user, "<span class='warning'>\The [src]'s internal reinforcement has not been secured!</span>")
			else if(is_reinforced == FRAME_REINFORCED_SECURE)
				to_chat(user, "<span class='warning'>\The [src]'s internal reinforcement has not been welded down!</span>")
			else
				to_chat(user, "<span class='warning'>\The [src] has no internal reinforcement!</span>")
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
	else if(thing.iscoil())

		if(is_wired)
			to_chat(user, "<span class='warning'>\The [src] has already been wired.</span>")
			return

		var/obj/item/stack/cable_coil/CC = thing
		if(CC.amount < 10)
			to_chat(user, "<span class='warning'>You need at least ten units of cable to complete the exosuit.</span>")
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
	else if(thing.iswirecutter())
		if(!is_wired)
			to_chat(user, "There is no wiring in \the [src] to neaten.")
			return

		visible_message("\The [user] [(is_wired == FRAME_WIRED_ADJUSTED) ? "snips some of" : "neatens"] the wiring in \the [src].")
		playsound(user.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		is_wired = (is_wired == FRAME_WIRED_ADJUSTED) ? FRAME_WIRED : FRAME_WIRED_ADJUSTED
	// Installing metal.
	else if(istype(thing, /obj/item/stack/material))
		var/obj/item/stack/material/M = thing
		if(M.material && M.material.name == "steel")
			if(is_reinforced)
				to_chat(user, "<span class='warning'>There is already metal reinforcement installed in \the [src].</span>")
				return
			if(M.amount < 15)
				to_chat(user, "<span class='warning'>You need at least fifteen sheets of steel to reinforce \the [src].</span>")
				return
			visible_message("\The [user] reinforces \the [src] with \the [M].")
			playsound(user.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			is_reinforced = FRAME_REINFORCED
			M.use(15)
		else
			return ..()
	// Securing metal.
	else if(thing.iswrench())
		if(!is_reinforced)
			to_chat(user, "<span class='warning'>There is no metal to secure inside \the [src].</span>")
			return
		if(is_reinforced == FRAME_REINFORCED_WELDED)
			to_chat(user, "<span class='warning'>\The [src]'s internal reinforcement has been welded in.</span>")
			return
		visible_message("\The [user] [(is_reinforced == 2) ? "unsecures" : "secures"] the metal reinforcement in \the [src].")
		playsound(user.loc, 'sound/items/Ratchet.ogg', 100, 1)
		is_reinforced = (is_reinforced == FRAME_REINFORCED_SECURE) ? FRAME_REINFORCED : FRAME_REINFORCED_SECURE
	// Welding metal.
	else if(thing.iswelder())
		var/obj/item/weldingtool/WT = thing
		if(!is_reinforced)
			to_chat(user, "<span class='warning'>There is no metal to secure inside \the [src].</span>")
			return
		if(is_reinforced == FRAME_REINFORCED)
			to_chat(user, "<span class='warning'>The reinforcement inside \the [src] has not been secured.</span>")
			return
		if(!WT.isOn())
			to_chat(user, "<span class='warning'>Turn \the [WT] on, first.</span>")
			return
		if(WT.remove_fuel(1, user))
			visible_message("\The [user] [(is_reinforced == 3) ? "unwelds the reinforcement from" : "welds the reinforcement into"] \the [src].")
			is_reinforced = (is_reinforced == FRAME_REINFORCED_WELDED) ? FRAME_REINFORCED_SECURE : FRAME_REINFORCED_WELDED
			playsound(user.loc, 'sound/items/Welder.ogg', 50, 1)
		else
			to_chat(user, "<span class='warning'>Not enough fuel!</span>")
			return
	// Installing basic components.
	else if(istype(thing,/obj/item/mech_component/manipulators))
		if(arms)
			to_chat(user, "<span class='warning'>\The [src] already has manipulators installed.</span>")
			return
		if(install_component(thing, user))
			if(arms)
				thing.dropInto(loc)
				return
			arms = thing
	else if(istype(thing,/obj/item/mech_component/propulsion))
		if(legs)
			to_chat(user, "<span class='warning'>\The [src] already has a propulsion system installed.</span>")
			return
		if(install_component(thing, user))
			if(legs)
				thing.dropInto(loc)
				return
			legs = thing
	else if(istype(thing,/obj/item/mech_component/sensors))
		if(head)
			to_chat(user, "<span class='warning'>\The [src] already has a sensor array installed.</span>")
			return
		if(install_component(thing, user))
			if(head)
				thing.dropInto(loc)
				return
			head = thing
	else if(istype(thing,/obj/item/mech_component/chassis))
		if(body)
			to_chat(user, "<span class='warning'>\The [src] already has an outer chassis installed.</span>")
			return
		if(install_component(thing, user))
			if(body)
				thing.dropInto(loc)
				return
			body = thing
	else
		return ..()
	update_icon()

/obj/structure/heavy_vehicle_frame/proc/install_component(var/obj/item/thing, var/mob/user)
	var/obj/item/mech_component/MC = thing
	if(istype(MC) && !MC.ready_to_install())
		if(user) to_chat(user, "<span class='warning'>\The [MC] is not ready to install.</span>")
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