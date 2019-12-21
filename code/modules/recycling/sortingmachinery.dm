/obj/structure/bigDelivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycloset"
	var/obj/wrapped = null
	density = 1
	var/sortTag = null
	flags = NOBLUDGEON
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/examtext = null
	var/nameset = 0
	var/label_y
	var/label_x
	var/tag_x

/obj/structure/bigDelivery/attack_hand(mob/user as mob)
	unwrap()

/obj/structure/bigDelivery/proc/unwrap()
	playsound(loc, 'sound/items/package_unwrap.ogg', 50, 1)
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove(get_turf(src.loc))
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
	qdel(src)

/obj/structure/bigDelivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, "<span class='notice'>You have labeled the destination as [O.currTag].</span>")
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			else
				to_chat(user, "<span class='warning'>The package is already labeled for [O.currTag].</span>")
		else
			to_chat(user, "<span class='warning'>You need to set a destination first!</span>")

	else if(W.ispen())
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = sanitizeSafe(input(usr,"Label text?","Set label",""), MAX_NAME_LEN)
				if(!str || !length(str))
					to_chat(usr, "<span class='warning'>Invalid text.</span>")
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
				"<span class='notice'>You title \the [src]: \"[str]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
				name = "[name] ([str])"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1
			if("Description")
				var/str = sanitize(input(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(usr, "<span class='warning'>Invalid text.</span>")
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
				"<span class='notice'>You label \the [src]: \"[examtext]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
	return

/obj/structure/bigDelivery/update_icon()
	cut_overlays()
	if(nameset || examtext)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycloset")
			I.pixel_x = 2
			if(label_y == null)
				label_y = rand(-6, 11)
			I.pixel_y = label_y
		else if(icon_state == "deliverycrate")
			if(label_x == null)
				label_x = rand(-8, 6)
			I.pixel_x = label_x
			I.pixel_y = -3
		add_overlay(I)
	if(src.sortTag)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_tag")
		if(icon_state == "deliverycloset")
			if(tag_x == null)
				tag_x = rand(-2, 3)
			I.pixel_x = tag_x
			I.pixel_y = 9
		else if(icon_state == "deliverycrate")
			if(tag_x == null)
				tag_x = rand(-8, 6)
			I.pixel_x = tag_x
			I.pixel_y = -3
		add_overlay(I)

/obj/structure/bigDelivery/examine(mob/user)
	if(..(user, 4))
		if(sortTag)
			to_chat(user, "<span class='notice'>It is labeled \"[sortTag]\"</span>")
		if(examtext)
			to_chat(user, "<span class='notice'>It has a note attached which reads, \"[examtext]\"</span>")
	return

/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate3"
	drop_sound = 'sound/items/drop/box.ogg'
	var/obj/item/wrapped = null
	var/sortTag = null
	var/examtext = null
	var/nameset = 0
	var/tag_x

/obj/item/smallDelivery/attack_self(mob/user as mob)
	if (src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove(user.loc)
		if(ishuman(user))
			user.put_in_hands(wrapped)
		else
			wrapped.forceMove(get_turf(src))

	qdel(src)
	return

/obj/item/smallDelivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, "<span class='notice'>You have labeled the destination as [O.currTag].</span>")
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			else
				to_chat(user, "<span class='warning'>The package is already labeled for [O.currTag].</span>")
		else
			to_chat(user, "<span class='warning'>You need to set a destination first!</span>")

	else if(W.ispen())
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = sanitizeSafe(input(usr,"Label text?","Set label",""), MAX_NAME_LEN)
				if(!str || !length(str))
					to_chat(usr, "<span class='warning'>Invalid text.</span>")
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
				"<span class='notice'>You title \the [src]: \"[str]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
				name = "[name] ([str])"
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1

			if("Description")
				var/str = sanitize(input(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(usr, "<span class='warning'>Invalid text.</span>")
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
				"<span class='notice'>You label \the [src]: \"[examtext]\"</span>",\
				"You hear someone scribbling a note.")
				playsound(src, pick('sound/bureaucracy/pen1.ogg','sound/bureaucracy/pen2.ogg'), 20)
	return

/obj/item/smallDelivery/update_icon()
	cut_overlays()
	if((nameset || examtext) && icon_state != "deliverycrate1")
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycrate5")
			I.pixel_y = -1
		add_overlay(I)
	if(src.sortTag)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_tag")
		switch(icon_state)
			if("deliverycrate1")
				I.pixel_y = -5
			if("deliverycrate2")
				I.pixel_y = -2
			if("deliverycrate3")
				I.pixel_y = 0
			if("deliverycrate4")
				if(tag_x == null)
					tag_x = rand(0,5)
				I.pixel_x = tag_x
				I.pixel_y = 3
			if("deliverycrate5")
				I.pixel_y = -3
		add_overlay(I)

/obj/item/smallDelivery/examine(mob/user)
	if(..(user, 4))
		if(sortTag)
			to_chat(user, "<span class='notice'>It is labeled \"[sortTag]\"</span>")
		if(examtext)
			to_chat(user, "<span class='notice'>It has a note attached which reads, \"[examtext]\"</span>")
	return

/obj/structure/bigDelivery/Destroy()
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.forceMove((get_turf(loc)))
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(T)
	return ..()

/obj/item/device/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon_state = "dest_tagger"
	var/currTag = 0
	matter = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 140)
	w_class = 2
	item_state = "electronic"
	flags = CONDUCT
	slot_flags = SLOT_BELT

/obj/item/device/destTagger/proc/openwindow(mob/user as mob)
	var/dat = "<tt><center><h1><b>TagMaster 2.3</b></h1></center>"

	dat += "<table style='width:100%; padding:4px;'><tr>"
	for(var/i = 1, i <= SSdisposals.tagger_locations.len, i++)
		dat += "<td><a href='?src=\ref[src];nextTag=[SSdisposals.tagger_locations[i]]'>[SSdisposals.tagger_locations[i]]</a></td>"

		if (i % 4==0)
			dat += "</tr><tr>"

	dat += "</tr></table><br>Current Selection: [currTag ? currTag : "None"]</tt>"
	dat += "<br><a href='?src=\ref[src];nextTag=CUSTOM'>Enter custom location.</a>"
	user << browse(dat, "window=destTagScreen;size=450x375")
	onclose(user, "destTagScreen")

/obj/item/device/destTagger/attack_self(mob/user as mob)
	openwindow(user)
	return

/obj/item/device/destTagger/Topic(href, href_list)
	src.add_fingerprint(usr)
	if(href_list["nextTag"] && href_list["nextTag"] in SSdisposals.tagger_locations)
		src.currTag = href_list["nextTag"]
	if(href_list["nextTag"] == "CUSTOM")
		var/dest = input("Please enter custom location.", "Location", src.currTag ? src.currTag : "None")
		if(dest != "None")
			src.currTag = dest
		else
			src.currTag = 0
	openwindow(usr)

/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = 1
	icon_state = "intake"

	var/c_mode = 0

/obj/machinery/disposal/deliveryChute/Initialize()
	. = ..()
	trunk = locate() in src.loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

/obj/machinery/disposal/deliveryChute/interact()
	return

/obj/machinery/disposal/deliveryChute/update()
	return

/obj/machinery/disposal/deliveryChute/CollidedWith(var/atom/movable/AM) //Go straight into the chute
	if(istype(AM, /obj/item/projectile) || istype(AM, /obj/effect))	return
	switch(dir)
		if(NORTH)
			if(AM.loc.y != src.loc.y+1) return
		if(EAST)
			if(AM.loc.x != src.loc.x+1) return
		if(SOUTH)
			if(AM.loc.y != src.loc.y-1) return
		if(WEST)
			if(AM.loc.x != src.loc.x-1) return

	if(istype(AM, /obj))
		var/obj/O = AM
		O.forceMove(src)
	else if(istype(AM, /mob))
		var/mob/M = AM
		M.forceMove(src)
	src.flush()

/obj/machinery/disposal/deliveryChute/flush()
	flushing = 1
	flick("intake-closing", src)
	var/obj/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	air_contents = new()		// new empty gas resv.

	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	sleep(5) // wait for animation to finish

	H.init(src)	// copy the contents of disposer to holder

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return

/obj/machinery/disposal/deliveryChute/attackby(var/obj/item/I, var/mob/user)
	if(!I || !user)
		return

	if(I.isscrewdriver())
		if(c_mode==0)
			c_mode=1
			playsound(src.loc, I.usesound, 50, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(c_mode==1)
			c_mode=0
			playsound(src.loc, I.usesound, 50, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(I.iswelder() && c_mode==1)
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(1,user))
			to_chat(user, "You start slicing the floorweld off the delivery chute.")
			if(do_after(user,20/W.toolspeed))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				if(!src || !W.isOn()) return
				to_chat(user, "You sliced the floorweld off the delivery chute.")
				var/obj/structure/disposalconstruct/C = new (src.loc)
				C.ptype = 8 // 8 =  Delivery chute
				C.update()
				C.anchored = 1
				C.density = 1
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return

/obj/machinery/disposal/deliveryChute/Destroy()
	if(trunk)
		trunk.linked = null
	return ..()
