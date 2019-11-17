/*
 * Trays - Nanako
 */
 //Use tray on an item to load it, alt+click on anything to attempt to load all the stuff on the tile
 //To unload, place on a table, then rightclic > Unload tray. Alternatively, alt+click on the tray to unload it
 //Tray will spill if thrown, dropped on the floor, or used to hit someone with. Spilling scatters contents

/obj/item/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	throwforce = 12.0
	force = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	flags = CONDUCT
	matter = list(DEFAULT_WALL_MATERIAL = 3000)
	var/list/carrying = list() // List of things on the tray. - Doohl
	var/max_carry = 20
	var/current_weight = 0
	drop_sound = 'sound/items/trayhit1.ogg'

	var/safedrop = 0//Used to tell when we should or shouldn't spill if the tray is dropped.
	//Safedrop is set true when throwing, because it will spill on impact. And when placing on a table
	var/list/valid = list(
		/obj/item/reagent_containers,
		/obj/item/material/kitchen/utensil,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/clothing/mask/smokable,
		/obj/item/storage/box/matches,
		/obj/item/flame/match,
		/obj/item/material/ashtray
	)

/obj/item/tray/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	// Drop all the things. All of them.
	spill(user, M.loc)

	//Note: Added a robot check to all stun/weaken procs, beccause weakening a robot causes its active modules to bug out
	if((user.is_clumsy()) && prob(50))              //What if he's a clown?
		to_chat(M, "<span class='warning'>You accidentally slam yourself with the [src]!</span>")
		if (!issilicon(M))
			M.Weaken(1)
		user.take_organ_damage(2)
		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			return
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1) //sound playin'
			return //it always returns, but I feel like adding an extra return just for safety's sakes. EDIT; Oh well I won't :3

	var/mob/living/carbon/human/H = M      ///////////////////////////////////// /Let's have this ready for later.


	if(!(target_zone == ("eyes" || "head"))) //////////////hitting anything else other than the eyes
		if(prob(33) && !issilicon(M))//robots dont bleed
			src.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)     ///Plik plik, the sound of blood

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
		msg_admin_attack("[key_name_admin(user)] used the [src.name] to attack [key_name_admin(M)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

		if(prob(15))
			if(!issilicon(M)) M.Weaken(3)
			M.take_organ_damage(3)
		else
			M.take_organ_damage(5)
		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
			return
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //we applied the damage, we played the sound, we showed the appropriate messages. Time to return and stop the proc
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
			return


	var/protected = 0
	for(var/slot in list(slot_head, slot_wear_mask, slot_glasses))
		var/obj/item/protection = M.get_equipped_item(slot)
		if(istype(protection) && (protection.body_parts_covered & FACE))
			protected = 1
			break

	if(protected)
		to_chat(M, "<span class='warning'>You get slammed in the face with the tray, against your mask!</span>")
		if(prob(33) && !issilicon(M))
			src.add_blood(H)
			if (H.wear_mask)
				H.wear_mask.add_blood(H)
			if (H.head)
				H.head.add_blood(H)
			if (H.glasses && prob(33))
				H.glasses.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))     //Addin' blood! At least on the floor and item :v
				location.add_blood(H)

		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin'
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
		if(prob(10))
			if(!istype(M,/mob/living/silicon))M.Stun(rand(1,3))
			M.take_organ_damage(3)
			return
		else
			M.take_organ_damage(5)
			return

	else if (!issilicon(M))//No eye or head protection, tough luck!
		to_chat(M, "<span class='danger'>You get slammed in the face with the tray!</span>")
		if(prob(33))
			src.add_blood(M)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)

		if(prob(50))
			playsound(M, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] in the face with the tray!</span>", user, M), 1)
		else
			playsound(M, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin' again
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] in the face with the tray!</span>", user, M), 1)
		if(prob(30))
			M.Stun(rand(2,4))
			M.take_organ_damage(4)
			return
		else
			M.take_organ_damage(8)
			if(prob(30))
				M.Weaken(2)
				return
			return

/obj/item/tray/var/cooldown = 0	//shield bash cooldown. based on world.time

/obj/item/tray/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(user,/mob/living/silicon/robot))//safety to stop robots losing their items
		return

	if (istype(W, /obj/item/tray))//safety to prevent tray stacking
		return

	if(istype(W, /obj/item/material/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time

	else
		var/obj/item/I = W
		attempt_load_item(I, user)
		//..()

/*
============~~~~~==============~~~~~=============
=												=
=  Code for trays carrying things. By Nanako.
=												=
============~~~~~============~~~~~===============
*/

//Clicking an item individually loads it. clicking a table places the tray on it safely
/obj/item/tray/afterattack(atom/target, mob/user as mob, proximity)
	if (proximity)
		if (istype(target, /obj/item))
			var/obj/item/I = target
			attempt_load_item(I,user,1)

	if (istype(target,/obj/structure/table))
		safedrop = 1


//Alt+click with the tray in hand attempts to grab everything on the tile
/obj/item/tray/alt_attack(var/atom/A, var/mob/user)
	var/dist
	var/tile
	if (istype(A,/turf))
		dist = get_dist(A,user.loc)
		tile = A
	else
		dist = get_dist(A.loc,user.loc)
		tile = A.loc

	if (dist == 1)//checking that we're adjacent
		var/addedSomething = 0
		for(var/obj/item/I in tile)
			if (attempt_load_item(I, usr,0))
				addedSomething++
		if ( addedSomething == 1)
			usr.visible_message("<span class='notice'>[user] loads an item onto their service tray.</span>")
		else if ( addedSomething )
			usr.visible_message("<span class='notice'>[user] loads [addedSomething] items onto their service tray.</span>")
		else
			to_chat(user, "The tray is full or there's nothing valid here")
			return 1
		return 0//This prevents the alt-click from doing any farther actions
	return 1

/obj/item/tray/AltClick(var/mob/user)
	if (use_check(user)) return
	unload(user)

/obj/item/tray/proc/attempt_load_item(var/obj/item/I, var/mob/user, var/messages = 1)
	if( I != src && !I.anchored && !istype(I, /obj/item/projectile) )
		var/match = 0
		for (var/T in valid)
			if (istype(I,T))
				match = 1
				var/remaining = max_carry - current_weight
				if (remaining >= I.w_class)
					load_item(I,user)
					if (messages)to_chat(user, "You place [I] on the tray")
					return 1
				else
					if (messages)
						to_chat(user, "The tray can't take that much weight")
		if (!match && messages)to_chat(user, "That item isn't suitable for a tray")
	return 0


/obj/item/tray/proc/load_item(var/obj/item/I, var/mob/user)
	user.remove_from_mob(I)
	I.forceMove(src)
	current_weight += I.w_class
	carrying += I
	var/mutable_appearance/MA = new(I)
	MA.layer = FLOAT_LAYER
	add_overlay(MA)
	//rand(0, (max_offset_y*2)-3)-(max_offset_y)-3

/obj/item/tray/verb/unload()
	set name = "Unload Tray"
	set category = "Object"
	set src in view(1)

	if (!istype(loc,/turf))//check that we're not being held by a mob
		to_chat(usr, "Place the tray down first!")
		return
	else
		var/turf/dropspot = loc

		for(var/obj/item/I in carrying)
			I.forceMove(dropspot)
			carrying -= I

		cut_overlays()
		current_weight = 0
		usr.visible_message("[usr] unloads the tray.", "You unload the tray.")

/obj/item/tray/proc/unload_at_loc(var/turf/dropspot = null, var/mob/user)
	if (!istype(loc,/turf) && !dropspot)//check that we're not being held by a mob
		to_chat(user, "Place the tray down first!")
		return
	else
		if (!dropspot)
			dropspot = loc

		for(var/obj/item/I in carrying)
			I.forceMove(dropspot)
			carrying -= I

		cut_overlays()
		current_weight = 0
		user.visible_message("[user] unloads the tray.", "You unload the tray.")


/obj/item/tray/proc/spill(var/mob/user = null, var/turf/dropspot = null)
	//This proc is called when a tray is thrown or dropped on the floor
	//its also called when a cyborg uses its tray on the floor
	if (current_weight > 0)//can't spill a tray with nothing on it

		cut_overlays()

		//First we have to find where the items are being dropped, unless a location has been passed in
		if (!dropspot)
			if (istype(src.loc, /mob))//If the tray is still held by a mob
				dropspot = src.loc.loc
			else
				dropspot = src.loc


		for(var/obj/item/I in carrying)
			I.forceMove(dropspot)
			carrying.Remove(I)
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(NORTH,SOUTH,EAST,WEST))
						sleep(rand(2,4))
		if (user)
			user.visible_message("<span class='notice'>[user] spills their tray all over the floor.</span>")
		else
			src.visible_message("<span class='notice'>The tray scatters its contents all over the area.</span>")
		current_weight = 0
		if(prob(50))
			playsound(dropspot, 'sound/items/trayhit1.ogg', 50, 1)
		else
			playsound(dropspot, 'sound/items/trayhit2.ogg', 50, 1)

/obj/item/tray/throw_impact(atom/hit_atom)
	spill(null, src.loc)

/obj/item/tray/throw_at(atom/target, throw_range, throw_speed, mob/user)
	safedrop = 1//we dont want the tray to spill when thrown, it will spill on impact instead
	..()

/obj/item/tray/dropped(mob/user)
	spawn(1)//A hack to avoid race conditions. Dropped procs too quickly
		if (istype(src.loc, /mob))
			//If this is true, then the tray has just switched hands and is still held by a mob
			return

		if (!safedrop)
			spill(user, src.loc)

		safedrop = 0

/obj/item/tray/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(istype(A,/obj/structure/table))
		safedrop = 1
	..(A, user, click_parameters)