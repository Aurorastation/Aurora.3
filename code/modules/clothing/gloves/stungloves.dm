/obj/item/clothing/gloves/attackby(obj/item/W, mob/user)
	if(istype(src, /obj/item/clothing/gloves/boxing))			//quick fix for stunglove overlay not working nicely with boxing gloves.
		to_chat(user, "<span class='notice'>That won't work.</span>")	//i'm not putting my lips on that!)
		..()
		return
	else if(istype(src, /obj/item/clothing/gloves/force))
		to_chat(user, "<span class='notice'>That seems like a terrible idea.</span>")
		..()
		return

	//add wires
	if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if (clipped)
			to_chat(user, "<span class='notice'>The [src] are too badly mangled for wiring.</span>")
			return

		if(wired)
			to_chat(user, "<span class='notice'>The [src] are already wired.</span>")
			return

		if(C.amount < 2)
			to_chat(user, "<span class='notice'>There is not enough wire to cover the [src].</span>")
			return

		C.use(2)
		wired = 1
		siemens_coefficient = 3.0
		to_chat(user, "<span class='notice'>You wrap some wires around the [src].</span>")
		update_icon()
		return

	//add cell
	else if(wired && istype(W, /obj/item/cell))
		if(cell)
			to_chat(user, "<span class='notice'>A [cell] is already attached to the [src].</span>")
			return
		user.drop_from_inventory(W,src)
		cell = W
		w_class = 3.0
		to_chat(user, "<span class='notice'>You attach the [cell] to the [src].</span>")
		update_icon()
		return

	else if((cell || wired) && (W.iswirecutter() || istype(W, /obj/item/surgery/scalpel)))

		//stunglove stuff
		if(cell)
			cell.update_icon()
			to_chat(user, "<span class='notice'>You cut the [cell] away from the [src].</span>")
			cell.forceMove(get_turf(src.loc))
			cell = null
			w_class = 2.0
			update_icon()
			return
		if(wired) //wires disappear into the void because fuck that shit
			wired = 0
			siemens_coefficient = initial(siemens_coefficient)
			to_chat(user, "<span class='notice'>You cut the wires away from the [src].</span>")
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
