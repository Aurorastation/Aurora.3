
/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lights.dmi'
	icon_state = "tube-construct-stage1"
	anchored = TRUE
	layer = 5
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

/obj/machinery/light_construct/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/machinery/light_construct/examine(mob/user)
	if(!..(user, 2))
		return

	switch(stage)
		if(1)
			to_chat(user, SPAN_NOTICE("It's an empty frame."))
		if(2)
			to_chat(user, SPAN_NOTICE("It's wired."))
		if(3)
			to_chat(user, SPAN_NOTICE("The casing is closed."))

	if (cell_connectors)
		if (cell)
			to_chat(user, SPAN_NOTICE("You see [cell] inside the casing."))
		else
			to_chat(user, SPAN_NOTICE("The casing has no power cell installed."))
	else
		to_chat(user, SPAN_WARNING("This casing doesn't support a backup power cell."))

/obj/machinery/light_construct/attackby(obj/item/W, mob/living/user)
	add_fingerprint(user)
	if(W.iswrench())
		switch(stage)
			if(1)
				to_chat(user, SPAN_NOTICE("You begin taking \the [src] apart..."))
				if(!W.use_tool(src, usr, 30, volume = 50))
					return
				new /obj/item/stack/material/steel(get_turf(src), sheets_refunded)
				user.visible_message(SPAN_NOTICE("\The [user] takes \the [src] apart."), SPAN_WARNING("You take \the [src] apart."))
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

	if(W.iswirecutter())
		if(stage != 2)
			return
		stage = 1
		switch(fixture_type)
			if("tube")
				icon_state = "tube-construct-stage1"
			if("bulb")
				icon_state = "bulb-construct-stage1"
		new /obj/item/stack/cable_coil(get_turf(src), 1, "red")
		user.visible_message(SPAN_NOTICE("\The [user] removes the wiring from \the [src]."), SPAN_NOTICE("You remove the wiring from [src]."), SPAN_WARNING("You hear something being cut."))
		playsound(get_turf(src), 'sound/items/wirecutter.ogg', 100, TRUE)
		return

	if(W.iscoil())
		if(stage != 1)
			return
		var/obj/item/stack/cable_coil/coil = W
		if(coil.use(1))
			switch(fixture_type)
				if("tube")
					icon_state = "tube-construct-stage2"
				if("bulb")
					icon_state = "bulb-construct-stage2"
			stage = 2
			user.visible_message(SPAN_NOTICE("\The [user] adds wires to \the [src]."), SPAN_NOTICE("You add wires to \the [src]."))
		return

	if(W.isscrewdriver())
		if(stage == 2)
			switch(fixture_type)
				if("tube")
					icon_state = "tube_empty"
				if("bulb")
					icon_state = "bulb_empty"
			stage = 3
			user.visible_message(SPAN_NOTICE("\The [user] closes \the [src]'s casing."), SPAN_NOTICE("You close \the [src]'s casing."), SPAN_WARNING("You hear something being screwed in."))
			playsound(get_turf(src), W.usesound, 75, TRUE)

			switch(fixture_type)
				if("tube")
					newlight = new /obj/machinery/light/built(get_turf(src))
				if("bulb")
					newlight = new /obj/machinery/light/small/built(get_turf(src))

			newlight.dir = src.dir
			if(cell)
				newlight.cell = cell
				cell.forceMove(newlight)
				cell = null

			transfer_fingerprints_to(newlight)
			qdel(src)
			return

	if(istype(W, /obj/item/cell))
		if(!cell_connectors)
			to_chat(user, SPAN_WARNING("\The [src] does not have power cell connectors."))
			return
		if(!user.unEquip(W))
			return
		if(cell)
			user.visible_message(SPAN_NOTICE("\The [user] swaps \the [W] out for \the [src]'s cell."), SPAN_NOTICE("You swap out \the [src]'s cell out for \the [W]."))
			user.drop_from_inventory(W, src)
			cell.forceMove(get_turf(src))
			user.put_in_hands(cell)
		else
			user.visible_message(SPAN_NOTICE("\The [user] installs \the [W] into \the [src]."), SPAN_NOTICE("You hook up \the [W] to \the [src]'s cell terminals."))
			user.drop_from_inventory(W, src)
		cell = W
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, TRUE)
		return

	if(W.iscrowbar())
		if(!cell_connectors)
			to_chat(user, SPAN_WARNING("\The [src] does not have a power cell connector."))
			return
		if(!cell)
			to_chat(user, SPAN_WARNING("\The [src] does not have a power cell installed."))
			return

		playsound(get_turf(src), W.usesound, 50, TRUE)
		visible_message(SPAN_NOTICE("\The [user] removes \the [cell] from the [src]."), SPAN_NOTICE("You remove \the [cell] from \the [src]."))
		cell.forceMove(get_turf(src))
		user.put_in_hands(cell)
		cell = null
		return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lights.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = TRUE
	layer = 5
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1
