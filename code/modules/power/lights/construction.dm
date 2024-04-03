
/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/machinery/light.dmi'
	icon_state = "tube-construct-stage1"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	var/stage = 1
	var/fixture_type = "tube"
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null
	var/obj/item/cell/cell
	var/cell_connectors = TRUE

/obj/machinery/light_construct/Initialize()
	. = ..()
	if (fixture_type == "bulb")
		icon_state = "bulb-construct-stage1"
	if (fixture_type == "spotlight")
		icon_state = "slight-construct-stage1"
	if (fixture_type == "floorbulb")
		icon_state = "floor-construct-stage1"
	if (fixture_type == "floorlight")
		icon_state = "floortube-construct-stage1"

/obj/machinery/light_construct/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/machinery/light_construct/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(is_adjacent)
		switch(stage)
			if(1)
				. += SPAN_NOTICE("It's an empty frame.")
			if(2)
				. += SPAN_NOTICE("It's wired.")
			if(3)
				. += SPAN_NOTICE("The casing is closed.")

		if (cell_connectors)
			if (cell)
				. += SPAN_NOTICE("You see [cell] inside the casing.")
			else
				. += SPAN_NOTICE("The casing has no power cell installed.")
		else
			. += SPAN_WARNING("This casing doesn't support a backup power cell.")

/obj/machinery/light_construct/attackby(obj/item/attacking_item, mob/user)
	add_fingerprint(user)
	if(attacking_item.iswrench())
		switch(stage)
			if(1)
				to_chat(user, SPAN_NOTICE("You begin taking \the [src] apart..."))
				if(!attacking_item.use_tool(src, usr, 30, volume = 50))
					return
				new /obj/item/stack/material/steel(get_turf(src), sheets_refunded)
				user.visible_message(SPAN_NOTICE("\The [user] takes \the [src] apart."),
										SPAN_WARNING("You take \the [src] apart."))
				if(cell)
					cell.forceMove(get_turf(src))
					cell = null
				qdel(src)
			if(2)
				to_chat(user, SPAN_WARNING("You have to remove the wires first."))
				return
			if(3)
				to_chat(user, SPAN_WARNING("You have to unscrew the case first."))
				return

	if(attacking_item.iswirecutter())
		if(stage != 2)
			return
		stage = 1
		switch(fixture_type)
			if("tube")
				icon_state = "tube-construct-stage1"
			if("bulb")
				icon_state = "bulb-construct-stage1"
			if("spotlight")
				icon_state = "slight-construct-stage1"
			if ("floorbulb")
				icon_state = "floor-construct-stage1"
			if ("floorlight")
				icon_state = "floortube-construct-stage1"
		new /obj/item/stack/cable_coil(get_turf(src), 1, "red")
		user.visible_message(SPAN_NOTICE("\The [user] removes the wiring from \the [src]."),
								SPAN_NOTICE("You remove the wiring from [src]."),
								SPAN_WARNING("You hear something being cut."))
		playsound(get_turf(src), 'sound/items/Wirecutter.ogg', 100, TRUE)
		return

	if(attacking_item.iscoil())
		if(stage != 1)
			return
		var/obj/item/stack/cable_coil/coil = attacking_item
		if(coil.use(1))
			switch(fixture_type)
				if("tube")
					icon_state = "tube-construct-stage2"
				if("bulb")
					icon_state = "bulb-construct-stage2"
				if("spotlight")
					icon_state = "slight-construct-stage2"
				if ("floorbulb")
					icon_state = "floor-construct-stage2"
				if ("floorlight")
					icon_state = "floortube-construct-stage2"
			stage = 2
			user.visible_message(SPAN_NOTICE("\The [user] adds wires to \the [src]."),
									SPAN_NOTICE("You add wires to \the [src]."))
		return

	if(attacking_item.isscrewdriver())
		if(stage == 2)
			switch(fixture_type)
				if("tube")
					icon_state = "tube_empty"
				if("bulb")
					icon_state = "bulb_empty"
				if("slight")
					icon_state = "slight_empty"
				if ("floorbulb")
					icon_state = "floor_empty"
				if ("floorlight")
					icon_state = "floortube_empty"
			stage = 3
			user.visible_message(SPAN_NOTICE("\The [user] closes \the [src]'s casing."),
									SPAN_NOTICE("You close \the [src]'s casing."),
									SPAN_WARNING("You hear something being screwed in."))
			attacking_item.play_tool_sound(get_turf(src), 75)

			switch(fixture_type)
				if("tube")
					newlight = new /obj/machinery/light/built(get_turf(src))
				if("bulb")
					newlight = new /obj/machinery/light/small/built(get_turf(src))
				if("slight")
					newlight = new /obj/machinery/light/spot/built(get_turf(src))
				if("floorbulb")
					newlight = new /obj/machinery/light/small/floor/built(get_turf(src))
				if("floorlight")
					newlight = new /obj/machinery/light/floor/built(get_turf(src))

			newlight.dir = src.dir
			if(cell)
				newlight.cell = cell
				cell.forceMove(newlight)
				cell = null

			transfer_fingerprints_to(newlight)
			qdel(src)
			return

	if(istype(attacking_item, /obj/item/cell))
		if(!cell_connectors)
			to_chat(user, SPAN_WARNING("\The [src] does not have power cell connectors."))
			return
		if(!user.unEquip(attacking_item))
			return
		if(cell)
			user.visible_message(SPAN_NOTICE("\The [user] swaps \the [attacking_item] out for \the [src]'s cell."),
									SPAN_NOTICE("You swap out \the [src]'s cell out for \the [attacking_item]."))
			user.drop_from_inventory(attacking_item, src)
			cell.forceMove(get_turf(src))
			user.put_in_hands(cell)
		else
			user.visible_message(SPAN_NOTICE("\The [user] installs \the [attacking_item] into \the [src]."),
									SPAN_NOTICE("You hook up \the [attacking_item] to \the [src]'s cell terminals."))
			user.drop_from_inventory(attacking_item, src)
		cell = attacking_item
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, TRUE)
		return

	if(attacking_item.iscrowbar())
		if(!cell_connectors)
			to_chat(user, SPAN_WARNING("\The [src] does not have a power cell connector."))
			return
		if(!cell)
			to_chat(user, SPAN_WARNING("\The [src] does not have a power cell installed."))
			return

		attacking_item.play_tool_sound(get_turf(src), 50)
		visible_message(SPAN_NOTICE("\The [user] removes \the [cell] from the [src]."),
						SPAN_NOTICE("You remove \the [cell] from \the [src]."))
		cell.forceMove(get_turf(src))
		user.put_in_hands(cell)
		cell = null
		return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/machinery/light.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = TRUE
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1

/obj/machinery/light_construct/spot
	name = "spotlight fixture frame"
	desc = "A spotlight fixture under construction."
	icon = 'icons/obj/machinery/light.dmi'
	icon_state = "slight-construct-stage1"
	anchored = TRUE
	stage = 1
	fixture_type = "spotlight"
	sheets_refunded = 3

/obj/machinery/light_construct/small/floor
	name = "small floor light fixture frame"
	desc = "A small floor light fixture under construction."
	icon = 'icons/obj/machinery/light.dmi'
	icon_state = "floor-construct-stage1"
	anchored = TRUE
	layer = TURF_DETAIL_LAYER
	stage = 1
	fixture_type = "floorbulb"
	sheets_refunded = 1

/obj/machinery/light_construct/floor
	name = "floor light fixture frame"
	desc = "A floor light fixture under construction."
	icon = 'icons/obj/machinery/light.dmi'
	icon_state = "floortube-construct-stage1"
	anchored = TRUE
	layer = TURF_DETAIL_LAYER
	stage = 1
	fixture_type = "floorlight"
