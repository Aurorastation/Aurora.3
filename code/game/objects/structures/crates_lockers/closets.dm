/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "closed"
	density = 1
	w_class = 5
	layer = OBJ_LAYER - 0.01
	var/icon_closed = "closed"
	var/icon_opened = "open"
	var/welded_overlay_state = "welded"
	var/opened = 0
	var/welded = 0
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/health = 100
	var/breakout = 0 //if someone is currently breaking out. mutex
	var/storage_capacity = 40 //Tying this to mob sizes was dumb
	//This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/open_sound = 'sound/effects/closet_open.ogg'
	var/close_sound = 'sound/effects/closet_close.ogg'

	var/store_misc = 1
	var/store_items = 1
	var/store_mobs = 1

	var/const/default_mob_size = 15

/obj/structure/closet/LateInitialize()
	if (opened)	// if closed, any item at the crate's loc is put in the contents
		return
	var/obj/I
	for(I in loc)
		if (!istype(I, /obj/item) && !istype(I, /obj/random))
			continue
		if (I.density || I.anchored || I == src)
			continue
		I.forceMove(src)
	// adjust locker size to hold all items with 5 units of free store room
	var/content_size = 0
	for(I in contents)
		content_size += Ceiling(I.w_class/2)
	if(content_size > storage_capacity-5)
		storage_capacity = content_size + 5

/obj/structure/closet/Initialize(mapload)
	..()
	fill()
	return mapload ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_NORMAL

// Fill lockers with this.
/obj/structure/closet/proc/fill()

/obj/structure/closet/examine(mob/user)
	if(..(user, 1) && !opened)
		var/content_size = 0
		for(var/obj/item/I in contents)
			if(!I.anchored)
				content_size += Ceiling(I.w_class/2)
		if(!content_size)
			to_chat(user, "It is empty.")
		else if(storage_capacity > content_size*4)
			to_chat(user, "It is barely filled.")
		else if(storage_capacity > content_size*2)
			to_chat(user, "It is less than half full.")
		else if(storage_capacity > content_size)
			to_chat(user, "There is still some free space.")
		else
			to_chat(user, "It is full.")

/obj/structure/closet/proc/stored_weight()
	var/content_size = 0
	for(var/obj/item/I in contents)
		if(!I.anchored)
			content_size += Ceiling(I.w_class/2)
	return content_size

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0 || wall_mounted)) return 1
	return (!density)

/obj/structure/closet/proc/can_open()
	if(welded)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 0
	return 1

/obj/structure/closet/proc/dump_contents()
	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in src)
		AD.forceMove(loc)

	for(var/obj/I in src)
		I.forceMove(loc)

	for(var/mob/M in src)
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/open()
	if(opened)
		return 0

	if(!can_open())
		return 0

	dump_contents()

	icon_state = icon_opened
	opened = 1
	playsound(loc, open_sound, 25, 0, -3)
	density = 0
	return 1

/obj/structure/closet/proc/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	var/stored_units = 0

	if(store_misc)
		stored_units += store_misc(stored_units)
	if(store_items)
		stored_units += store_items(stored_units)
	if(store_mobs)
		stored_units += store_mobs(stored_units)

	icon_state = icon_closed
	opened = 0

	playsound(loc, close_sound, 25, 0, -3)
	density = 1
	return 1

//Cham Projector Exception
/obj/structure/closet/proc/store_misc(var/stored_units)
	var/added_units = 0
	for(var/obj/effect/dummy/chameleon/AD in loc)
		if((stored_units + added_units) > storage_capacity)
			break
		AD.forceMove(src)
		added_units++
	return added_units

/obj/structure/closet/proc/store_items(var/stored_units)
	var/added_units = 0
	for(var/obj/item/I in loc)
		var/item_size = Ceiling(I.w_class / 2)
		if(stored_units + added_units + item_size > storage_capacity)
			continue
		if(!I.anchored)
			I.forceMove(src)
			added_units += item_size
	return added_units

/obj/structure/closet/proc/store_mobs(var/stored_units)
	var/added_units = 0
	for(var/mob/living/M in loc)
		if(M.buckled || M.pinned.len)
			continue
		if(stored_units + added_units + M.mob_size > storage_capacity)
			break
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		added_units += M.mob_size
	return added_units

/obj/structure/closet/proc/toggle(mob/user as mob)
	if(!(opened ? close() : open()))
		to_chat(user, "<span class='notice'>It won't budge!</span>")
		return
	update_icon()
	return 1

/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			health -= rand(120, 240)
		if(2)
			health -= rand(60, 120)
		if(3)
			health -= rand(30, 60)

	if (health <= 0)
		for (var/atom/movable/A as mob|obj in src)
			A.ex_act(severity + 1)
		dump_contents()
		new /obj/item/stack/material/steel(get_turf(src))
		qdel(src)

/obj/structure/closet/proc/damage(var/damage)
	health -= damage
	if(health <= 0)
		dump_contents()
		new /obj/item/stack/material/steel(get_turf(src))
		qdel(src)

/obj/structure/closet/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage)
		return

	if(Proj.penetrating || istype(Proj, /obj/item/projectile/bullet))
		var/distance = get_dist(Proj.starting, get_turf(loc))
		for(var/mob/living/L in contents)
			Proj.attack_mob(L, distance)

	..()
	damage(proj_damage)

/obj/structure/closet/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(W.iswelder())
			var/obj/item/weldingtool/WT = W
			if(WT.isOn())
				user.visible_message(
					"<span class='warning'>[user] begins cutting [src] apart.</span>",
					"<span class='notice'>You begin cutting [src] apart.</span>",
					"You hear a welding torch on metal."
				)
				playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
				if (!do_after(user, 2 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_open)))
					return
				if(!WT.remove_fuel(0,user))
					to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
					return
				else
					new /obj/item/stack/material/steel(loc)
					user.visible_message(
						"<span class='notice'>[src] has been cut apart by [user] with [WT].</span>",
						"<span class='notice'>You cut apart [src] with [WT].</span>"
					)
					qdel(src)
					return
		if(istype(W, /obj/item/storage/laundry_basket) && W.contents.len)
			var/obj/item/storage/laundry_basket/LB = W
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T)
			user.visible_message(
				"<span class='notice'>[user] empties \the [LB] into \the [src].</span>",
				"<span class='notice'>You empty \the [LB] into \the [src].</span>",
				"<span class='notice'>You hear rustling of clothes.</span>"
			)
			return
		if(!dropsafety(W))
			return
		if(W)
			user.drop_from_inventory(W,loc)
		else
			user.drop_item()
	else if(istype(W, /obj/item/stack/packageWrap))
		return
	else if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(WT.isOn())
			user.visible_message(
				"<span class='warning'>[user] begins welding [src] [welded ? "open" : "shut"].</span>",
				"<span class='notice'>You begin welding [src] [welded ? "open" : "shut"].</span>",
				"You hear a welding torch on metal."
			)
			playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
			if (!do_after(user, 2/W.toolspeed SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
				return
			if(!WT.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
				return
			welded = !welded
			update_icon()
			user.visible_message(
				"<span class='warning'>[src] has been [welded ? "welded shut" : "unwelded"] by [user].</span>",
				"<span class='notice'>You weld [src] [!welded ? "open" : "shut"].</span>"
			)
		else
			attack_hand(user)
	else
		attack_hand(user)
	return


// helper procs for callbacks
/obj/structure/closet/proc/is_closed()
	. = !opened

/obj/structure/closet/proc/is_open()
	. = opened

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
		return
	if(O.loc == user)
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if((!( istype(O, /atom/movable) ) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O) || user.contents.Find(src)))
		return
	if(!isturf(user.loc)) // are you in a container/closet/pod/etc?
		return
	if(!opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	step_towards(O, loc)
	if(user != O)
		user.show_viewers("<span class='danger'>[user] stuffs [O] into [src]!</span>")
	add_fingerprint(user)
	return

/obj/structure/closet/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Robots can open/close it, but not the AI.
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(loc))
		return

	if(!open())
		to_chat(user, "<span class='notice'>It won't budge!</span>")

/obj/structure/closet/attack_hand(mob/user as mob)
	add_fingerprint(user)
	return toggle(user)

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr))
		add_fingerprint(usr)
		toggle(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	cut_overlays()
	if(!opened)
		icon_state = icon_closed
		if(welded)
			add_overlay(welded_overlay_state)
	else
		icon_state = icon_opened

/obj/structure/closet/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	for (var/atom/A in src)
		if(istype(A,/obj/))
			var/obj/O = A
			O.hear_talk(M, text, verb, speaking)

/obj/structure/closet/attack_generic(var/mob/user, var/damage, var/attack_message = "destroys", var/wallbreaker)
	if(!damage || !wallbreaker)
		return
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	dump_contents()
	QDEL_IN(src, 1)
	return 1

/obj/structure/closet/proc/req_breakout()

	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if(welded)
		return 1 //closed but not welded...
	if(breakout)
		return -1 //Already breaking out.
	return 0

/obj/structure/closet/proc/mob_breakout(var/mob/living/escapee)

	//Improved by nanako
	//Now it actually works, also locker breakout time stacks with locking and welding
	//This means secure lockers are more useful for imprisoning people
	var/breakout_time = 1.5 * req_breakout()//1.5 minutes if locked or welded, 3 minutes if both
	if(breakout_time <= 0)
		return



	//okay, so the closet is either welded or locked... resist!!!
	escapee.next_move = world.time + 100
	escapee.last_special = world.time + 100
	to_chat(escapee, "<span class='warning'>You lean on the back of \the [src] and start pushing the door open. (this will take about [breakout_time] minutes)</span>")
	visible_message("<span class='danger'>\The [src] begins to shake violently!</span>")

	var/time = 6 * breakout_time * 2

	var/datum/progressbar/bar
	if (escapee.client && escapee.client.prefs.toggles_secondary & PROGRESS_BARS)
		bar = new(escapee, time, src)

	breakout = 1
	for(var/i in 1 to time) //minutes * 6 * 5seconds * 2
		playsound(loc, 'sound/effects/grillehit.ogg', 100, 1)
		animate_shake()

		if (bar)
			bar.update(i)

		if(!do_after(escapee, 50, display_progress = FALSE)) //5 seconds
			breakout = 0
			qdel(bar)
			return

		if(!escapee || escapee.stat || escapee.loc != src)
			breakout = 0
			qdel(bar)
			return //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened

		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(!req_breakout())
			breakout = 0
			qdel(bar)
			return

	//Well then break it!
	breakout = 0
	to_chat(escapee, "<span class='warning'>You successfully break out!</span>")
	visible_message("<span class='danger'>\the [escapee] successfully broke out of \the [src]!</span>")
	playsound(loc, 'sound/effects/grillehit.ogg', 100, 1)
	break_open()
	animate_shake()
	qdel(bar)

/obj/structure/closet/proc/break_open()
	welded = 0
	update_icon()
	//Do this to prevent contents from being opened into nullspace (read: bluespace)
	if(istype(loc, /obj/structure/bigDelivery))
		var/obj/structure/bigDelivery/BD = loc
		BD.unwrap()
	open()

/obj/structure/closet/onDropInto(var/atom/movable/AM)
	return

/obj/structure/closet/crush_act()
	for (var/atom/movable/A in src)
		if(istype(A, /mob/living))
			var/mob/living/M = A
			M.gib()
		else if(A.simulated)
			A.ex_act(1)
	dump_contents()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)
