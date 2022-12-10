/obj/machinery/mineral/rigpress
	name = "hardsuit module press"
	desc = "This machine converts certain items permanently into hardsuit modules."
	desc_info = "The following devices can be made:"
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
		
/obj/machinery/mineral/rigpress/Initialize()
	. = ..()
	for(var/press_type in press_types)
		var/obj/item/base = press_type
		var/obj/item/product = press_types[press_type]
		desc_info += "\n[initial(base.name)] -> [initial(product.name)]"

/obj/machinery/mineral/rigpress/update_icon()
	if(pressing)
		icon_state = "coinpress1"
	else
		icon_state = "coinpress0"

/obj/machinery/mineral/rigpress/attackby(obj/item/W, mob/user)
	if(!pressing)
		var/outcome_path
		for(var/press_type in press_types)
			if(istype(W, press_type))
				outcome_path = press_types[press_type]
				break

		if(!outcome_path)
			..()
			return

		to_chat(user, SPAN_NOTICE("You start feeding [W] into \the [src]"))
		if(do_after(user, 30))
			src.visible_message(SPAN_NOTICE("\The [src] begins to print out a modsuit."))
			pressing = TRUE
			update_icon()
			use_power_oneoff(500)
			qdel(W)
			spawn(300)
				ping("\The [src] pings, \"Module successfuly produced!\"")

				new outcome_path(get_turf(src))

				use_power_oneoff(500)
				pressing = FALSE
				update_icon()

	else
		..()
