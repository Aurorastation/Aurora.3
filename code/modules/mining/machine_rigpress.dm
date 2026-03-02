/obj/machinery/mineral/rigpress
	name = "hardsuit module press"
	desc = "This machine converts certain items permanently into hardsuit modules."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 15
	active_power_usage = 50
	var/pressing

	var/list/press_types = list(
	/obj/item/tank/jetpack = /obj/item/rig_module/maneuvering_jets,
	/obj/item/mining_scanner = /obj/item/rig_module/device/orescanner,
	/obj/item/pickaxe/drill = /obj/item/rig_module/device/basicdrill,
	/obj/item/gun/energy/plasmacutter = /obj/item/rig_module/mounted/plasmacutter,
	/obj/item/pickaxe/diamond = /obj/item/rig_module/device/drill,
	/obj/item/gun/energy/vaurca/thermaldrill = /obj/item/rig_module/mounted/thermalldrill
	)

/obj/machinery/mineral/rigpress/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The following devices can be made:"
	for(var/press_type in press_types)
		var/obj/item/base = press_type
		var/obj/item/product = press_types[press_type]
		. += "[initial(base.name)] -> [initial(product.name)]"

/obj/machinery/mineral/rigpress/update_icon()
	if(pressing)
		icon_state = "coinpress1"
	else
		icon_state = "coinpress0"

/**
 * If a compatible item is fed into the machine, begin conversion. Only allow one at a time.
 */
/obj/machinery/mineral/rigpress/attackby(obj/item/attacking_item, mob/user)
	if(!pressing)
		var/outcome_path
		// Check that the item is compatible.
		for(var/press_type in press_types)
			if(istype(attacking_item, press_type))
				outcome_path = press_types[press_type]
				break
		// It's not.
		if(!outcome_path)
			..()
			return

		to_chat(user, SPAN_NOTICE("You start feeding [attacking_item] into \the [src]"))
		if(do_after(user, 30))
			// Extra !pressing check here to protect against button-mashers. Naughty naughty.
			if(!pressing)
				src.visible_message(SPAN_NOTICE("\The [src] begins to print out a modsuit."))
				pressing = TRUE
				update_icon()
				use_power_oneoff(500)
				qdel(attacking_item)
				spawn(300)
					ping("\The [src] pings, \"Module successfuly produced!\"")

					new outcome_path(get_turf(src))

					use_power_oneoff(500)
					pressing = FALSE
					update_icon()
			else
				src.visible_message(SPAN_WARNING("\The [src] is already printing something!"))
	else
		..()
