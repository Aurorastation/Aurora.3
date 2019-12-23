//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
	climbable = 1
//	mouse_drag_pointer = MOUSE_ACTIVE_POINTER	//???
	var/rigged = 0
	var/tablestatus = 0
	pass_flags = PASSTABLE


/obj/structure/closet/crate/can_open()
	if (tablestatus != -1)//Can't be opened while under a table
		return 1
	return 0

/obj/structure/closet/crate/can_close()
	return 1

/obj/structure/closet/crate/open()
	if(opened)
		return 0
	if(!can_open())
		return 0

	if(rigged && locate(/obj/item/device/radio/electropack) in src)
		if(isliving(usr))
			var/mob/living/L = usr
			var/touchy_hand
			if(L.hand)
				touchy_hand = BP_R_HAND
			else
				touchy_hand = BP_L_HAND
			if(L.electrocute_act(17, src, ground_zero = touchy_hand))
				spark(src, 5, alldirs)
				if(L.stunned)
					return 2

	playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)
	for(var/obj/O in src)
		O.forceMove(get_turf(src))

	if(climbable)
		structure_shaken()

	for (var/mob/M in src)
		M.forceMove(get_turf(src))
		if (M.stat == CONSCIOUS)
			M.visible_message(span("danger","\The [M.name] bursts out of the [src]!"), span("danger","You burst out of the [src]!"))
		else
			M.visible_message(span("danger","\The [M.name] tumbles out of the [src]!"))

	icon_state = icon_opened
	opened = 1
	pass_flags = 0
	return 1

/obj/structure/closet/crate/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	playsound(loc, 'sound/machines/click.ogg', 15, 1, -3)
	var/itemcount = 0
	for(var/obj/O in get_turf(src))
		if(itemcount >= storage_capacity)
			break
		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue
		if(istype(O, /obj/structure/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/bed/B = O
			if(B.buckled_mob)
				continue
		O.forceMove(src)
		itemcount++

	icon_state = icon_closed
	opened = 0
	pass_flags = PASSTABLE//Crates can only slide under tables when closed
	return 1




/obj/structure/closet/crate/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		return ..()
	else if(istype(W, /obj/item/stack/packageWrap))
		return
	else if(W.iscoil())
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, "<span class='notice'>[src] is already rigged!</span>")
			return
		if (C.use(1))
			to_chat(user, "<span class='notice'>You rig [src].</span>")
			rigged = 1
			return
	else if(istype(W, /obj/item/device/radio/electropack))
		if(rigged)
			to_chat(user, "<span class='notice'>You attach [W] to [src].</span>")
			user.drop_from_inventory(W,src)
			return
	else if(W.iswirecutter())
		if(rigged)
			to_chat(user, "<span class='notice'>You cut away the wiring.</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else if(istype(W, /obj/item/device/radio/beacon/fulton))
		return ..()
	else return attack_hand(user)

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1)
			health -= rand(120, 240)
		if(2)
			health -= rand(60, 120)
		if(3)
			health -= rand(30, 60)

	if (health <= 0)
		for (var/atom/movable/A as mob|obj in src)
			A.forceMove(loc)
			if (prob(50) && severity > 1)//Higher chance of breaking contents
				A.ex_act(severity-1)
			else
				A.ex_act(severity)
		qdel(src)





/*
