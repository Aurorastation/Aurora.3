/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	if(istype(src, /obj/item/clothing/gloves/boxing))			//quick fix for stunglove overlay not working nicely with boxing gloves.
		to_chat(user, SPAN_NOTICE("That won't work."))	//i'm not putting my lips on that!)
		..()
		return
	else if(istype(src, /obj/item/clothing/gloves/force))
		to_chat(user, SPAN_NOTICE("That seems like a terrible idea."))
		..()
		return

	//add wires
	if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if (clipped)
			to_chat(user, SPAN_NOTICE("The [src] are too badly mangled for wiring."))
			return

		if(wired)
			to_chat(user, SPAN_NOTICE("The [src] are already wired."))
			return

		if(C.amount < 2)
			to_chat(user, SPAN_NOTICE("There is not enough wire to cover [src]."))
			return

		C.use(2)
		wired = 1
		siemens_coefficient = 3.0
		to_chat(user, SPAN_NOTICE("You wrap some wires around [src]."))
		update_icon()
		return

	//add cell
	else if(wired && istype(W, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_NOTICE("A [cell] is already attached to [src]."))
			return
		user.drop_from_inventory(W,src)
		cell = W
		w_class = 3.0
		to_chat(user, SPAN_NOTICE("You attach the [cell] to [src]."))
		update_icon()
		return

	else if((cell || wired) && (W.iswirecutter() || istype(W, /obj/item/surgery/scalpel)))

		//stunglove stuff
		if(cell)
			cell.update_icon()
			to_chat(user, SPAN_NOTICE("You cut the [cell] away from [src]."))
			cell.forceMove(get_turf(src.loc))
			cell = null
			w_class = 2.0
			update_icon()
			return
		if(wired) //wires disappear into the void because fuck that shit
			wired = 0
			siemens_coefficient = initial(siemens_coefficient)
			to_chat(user, SPAN_NOTICE("You cut the wires away from [src]."))
			update_icon()
			return

	..()

/obj/item/clothing/gloves/update_icon()
	..()
	cut_overlays()
	if(wired)
		add_overlay("gloves_wire")
	if(cell)
		add_overlay("gloves_cell")
