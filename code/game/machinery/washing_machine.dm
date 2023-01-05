/obj/machinery/washing_machine
	name = "washing machine"
	desc = "A washing machine with special decontamination procedures. It can fit everything from clothes to even rifles."
	icon = 'icons/obj/machinery/washing_machine.dmi'
	icon_state = "wm_10"
	density = 1
	anchored = 1.0
	clicksound = /decl/sound_category/button_sound
	clickvol = 40

	var/state = 1
	//1 = empty, open door
	//2 = empty, closed door
	//3 = full, open door
	//4 = full, closed door
	//5 = running
	//6 = blood, open door
	//7 = blood, closed door
	//8 = blood, running
	var/panel = 0
	//0 = closed
	//1 = open
	var/hacked = 1 //Bleh, screw hacking, let's have it hacked by default.
	//0 = not hacked
	//1 = hacked
	var/gibs_ready = 0
	var/obj/crayon

/obj/machinery/washing_machine/verb/start()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)

	if(!istype(usr, /mob/living)) //ew ew ew usr, but it's the only way to check.
		return

	if(state != 4)
		to_chat(usr, "The washing machine cannot run in this state.")
		return

	if(locate(/mob,contents))
		state = 8
	else
		state = 5
	update_icon()
	sleep(200)
	for(var/atom/A in contents)
		A.clean_blood()

	for(var/obj/item/I in contents)
		I.decontaminate()

	//Tanning!
	for(var/obj/item/stack/material/animalhide/barehide/BH in contents)
		var/obj/item/stack/material/animalhide/wetleather/WL = new(src)
		WL.amount = BH.amount
		contents -= BH
		qdel(BH)

	if( locate(/mob,contents) )
		state = 7
		gibs_ready = 1
	else
		state = 4
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc

	sleep(20)
	if(state in list(1,3,6) )
		usr.forceMove(src.loc)

/obj/machinery/washing_machine/AltClick(mob/user)
	if(Adjacent(user))
		start()

/obj/machinery/washing_machine/update_icon()
	icon_state = "wm_[state][panel]"

/obj/machinery/washing_machine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pen/crayon) || istype(W,/obj/item/stamp))
		if( state in list(	1, 3, 6 ) )
			if(!crayon)
				user.drop_from_inventory(W,src)
				crayon = W
			else
				return ..()
		else
			return ..()
	else if(istype(W,/obj/item/grab))
		if( (state == 1) && hacked)
			var/obj/item/grab/G = W
			if(ishuman(G.assailant) && iscorgi(G.affecting))
				G.affecting.forceMove(src)
				qdel(G)
				state = 3
		else
			return ..()
	else
		if(contents.len < 5)
			if (state in list(1, 3))
				user.drop_from_inventory(W,src)
				state = 3
			else
				to_chat(user, "<span class='notice'>You can't put the item in right now.</span>")
		else
			to_chat(user, "<span class='notice'>The washing machine is full.</span>")
	update_icon()
	return ..()

/obj/machinery/washing_machine/attack_hand(mob/user as mob)
	switch(state)
		if(1)
			state = 2
		if(2)
			state = 1
			for(var/atom/movable/O in contents)
				O.forceMove(src.loc)
		if(3)
			state = 4
		if(4)
			state = 3
			for(var/atom/movable/O in contents)
				O.forceMove(src.loc)
			crayon = null
			state = 1
		if(5)
			to_chat(user, "<span class='warning'>The [src] is busy.</span>")
		if(6)
			state = 7
		if(7)
			if(gibs_ready)
				gibs_ready = 0
				if(locate(/mob,contents))
					var/mob/M = locate(/mob,contents)
					M.gib()
			for(var/atom/movable/O in contents)
				O.forceMove(src.loc)
			crayon = null
			state = 1


	update_icon()
