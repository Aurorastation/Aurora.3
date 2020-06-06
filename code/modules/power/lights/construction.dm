
/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
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

	switch(src.stage)
		if(1)
			to_chat(user, "It's an empty frame.")
		if(2)
			to_chat(user, "It's wired.")
		if(3)
			to_chat(user, "The casing is closed.")

	if (cell_connectors)
		if (cell)
			to_chat(user, "You see [cell] inside the casing.")
		else
			to_chat(user, "The casing has no power cell installed.")
	else
		to_chat(user, "This casing doesn't support a backup power cell.")

/obj/machinery/light_construct/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if (W.iswrench())
		if (src.stage == 1)
			playsound(src.loc, W.usesound, 75, 1)
			to_chat(usr, "You begin deconstructing [src].")
			if (!do_after(usr, 30, act_target = src))
				return
			new /obj/item/stack/material/steel(get_turf(src.loc), sheets_refunded)
			user.visible_message(
				"[user] deconstructs [src].",
				"You deconstruct [src]."
			)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
			if (cell)
				cell.forceMove(get_turf(src))
				cell = null
			qdel(src)
		if (src.stage == 2)
			to_chat(usr, "You have to remove the wires first.")
			return

		if (src.stage == 3)
			to_chat(usr, "You have to unscrew the case first.")
			return

	if(W.iswirecutter())
		if (src.stage != 2) return
		src.stage = 1
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage1"
			if("bulb")
				src.icon_state = "bulb-construct-stage1"
		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message(
			"[user] removes the wiring from [src].",
			"You remove the wiring from [src].",
			"You hear something being cut."
		)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return

	if(W.iscoil())
		if (src.stage != 1) return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-construct-stage2"
				if("bulb")
					src.icon_state = "bulb-construct-stage2"
			src.stage = 2
			user.visible_message(
				"[user] adds wires to [src].",
				"You add wires to [src]."
			)
		return

	if(W.isscrewdriver())
		if (stage == 2)
			switch(fixture_type)
				if("tube")
					icon_state = "tube_empty"
				if("bulb")
					icon_state = "bulb_empty"
			stage = 3
			user.visible_message(
				"[user] closes [src]'s casing.",
				"You close [src]'s casing.",
				"You hear something being screwed in."
			)
			playsound(src.loc, W.usesound, 75, 1)

			switch(fixture_type)
				if("tube")
					newlight = new /obj/machinery/light/built(src.loc)
				if("bulb")
					newlight = new /obj/machinery/light/small/built(src.loc)

			newlight.dir = src.dir
			if (cell)
				newlight.cell = cell
				cell.forceMove(newlight)
				cell = null

			src.transfer_fingerprints_to(newlight)
			qdel(src)
			return

	if (istype(W, /obj/item/cell))
		if (!cell_connectors)
			to_chat(user, "<span class='notice'>[src] does not have power cell connectors.</span>")
			return
		if (!user.unEquip(W))
			return
		if (cell)
			user.visible_message(
				"<span class='notice'>[user] swaps [W] out for [src]'s cell.</span>",
				"<span class='notice'>You swap out [src]'s cell out for [W].</span>"
			)
			cell.forceMove(get_turf(src))
			user.put_in_hands(cell)
		else
			user.visible_message(
				"<span class='notice'>[user] installs [W] in [src].</span>",
				"<span class='notice'>You hook up [W] to [src]'s cell terminals.</span>"
			)
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			W.forceMove(src)
			cell = W
			add_fingerprint(user)
			return

	if (W.iscrowbar())
		if (!cell_connectors)
			to_chat(user, "<span class='notice'>[src] does not have a power cell connector.</span>")
			return

		if (!cell)
			to_chat(user, "<span class='notice'>[src] does not have a power cell installed.</span>")
			return

		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, TRUE)
		visible_message(
			"[user] removes [cell] from [src].",
			"<span class='notice'>You remove [cell] from [src].</span>"
		)
		cell.forceMove(get_turf(src))
		cell = null
		return

	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	layer = 5
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1
