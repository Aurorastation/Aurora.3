/*
 * Trays - Nanako
 */
 //Use tray on an item to load it, alt+click on anything to attempt to load all the stuff on the tile
 //To unload, place on a table, then rightclic > Unload tray. Alternatively, alt+click on the tray to unload it
 //Tray will spill if thrown, dropped on the floor, or used to hit someone with. Spilling scatters contents

/obj/item/tray
	name = "tray"
	desc = "A metal tray to lay food on."
	icon = 'icons/obj/food.dmi'
	icon_state = "tray"
	throwforce = 12
	force = 10
	throw_speed = 1
	throw_range = 5
	layer = OBJ_LAYER - 0.01
	flags = CONDUCT
	matter = list(DEFAULT_WALL_MATERIAL = 3000)
	var/cooldown = 0	//shield bash cooldown. based on world.time
	var/list/carrying = list() // List of things on the tray. - Doohl
	var/max_carry = 20
	var/current_weight = 0
	drop_sound = 'sound/items/trayhit1.ogg'

	var/safedrop = FALSE //Used to tell when we should or shouldn't spill if the tray is dropped.
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

/obj/item/tray/attack(mob/living/carbon/M, mob/living/carbon/user, var/target_zone)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	// Drop all the things. All of them.
	spill(user, get_turf(M))

	//Note: Added a robot check to all stun/weaken procs, beccause weakening a robot causes its active modules to bug out
	if((user.is_clumsy()) && prob(50))              //What if he's a clown?
		to_chat(M, SPAN_WARNING("You accidentally slam yourself with the [src]!"))
		if(!issilicon(M))
			M.Weaken(1)
		user.take_organ_damage(2)
		playsound(M, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, TRUE)
		return

	var/mob/living/carbon/human/H = M //Let's have this ready for later.

	if(!(target_zone == (BP_EYES || BP_HEAD))) // hitting anything else other than the eyes
		if(prob(33) && !issilicon(M)) // robots dont bleed
			src.add_blood(H)
			var/turf/location = H.loc
			if(istype(location, /turf/simulated))
				location.add_blood(H) // Plik plik, the sound of blood

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
		msg_admin_attack("[key_name_admin(user)] used the [src.name] to attack [key_name_admin(M)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

		if(prob(15))
			if(!issilicon(M))
				M.Weaken(3)
			M.take_organ_damage(3)
		else
			M.take_organ_damage(5)
		playsound(M, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, TRUE)
		visible_message("\The [user] slams \the [M] with \the [src]!")
		return


	var/protected = FALSE
	for(var/slot in list(slot_head, slot_wear_mask, slot_glasses))
		var/obj/item/protection = M.get_equipped_item(slot)
		if(istype(protection) && (protection.body_parts_covered & FACE))
			protected = TRUE
			break

	if(protected)
		to_chat(M, SPAN_WARNING("The tray slams against your mask!"))
		if(prob(33) && !issilicon(M))
			src.add_blood(H)
			if(H.wear_mask)
				H.wear_mask.add_blood(H)
			if(H.head)
				H.head.add_blood(H)
			if(H.glasses && prob(33))
				H.glasses.add_blood(H)
			var/turf/location = get_turf(H)
			if(istype(location, /turf/simulated)) //Addin' blood! At least on the floor and item :v
				location.add_blood(H)

		playsound(M, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, 1)
		visible_message(SPAN_DANGER("\The [user] slams \the [M] with the tray!"))
		if(prob(10))
			if(!issilicon(M))
				M.Stun(rand(1,3))
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
			if(istype(location, /turf/simulated))
				location.add_blood(H)
		playsound(M, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, TRUE)
		visible_message(SPAN_DANGER("\The [user] slams \the [M] in the face with the tray!"))
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

/obj/item/tray/attackby(obj/item/W, mob/user)
	if(isrobot(user)) //safety to stop robots losing their items
		return
	if(istype(W, /obj/item/tray)) //safety to prevent tray stacking
		return
	if(istype(W, /obj/item/material/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("\The [user] bashes \the [W] against their [src]!"))
			playsound(get_turf(user), 'sound/effects/shieldbash.ogg', 50, TRUE)
			cooldown = world.time
	else
		var/obj/item/I = W
		attempt_load_item(I, user)

/obj/item/tray/attack_hand(mob/user)
	if(length(carrying) && user.get_inactive_hand() == src)
		var/obj/item/chosen_item = input(user, "Which item do you want to remove?", "Tray Items") as null|anything in carrying
		if(!chosen_item)
			to_chat(user, SPAN_NOTICE("You decide to not take anything off the tray."))
			return
		chosen_item.forceMove(get_turf(user))
		carrying.Remove(chosen_item)
		user.put_in_hands(chosen_item)
		cut_overlays()
		for(var/obj/item in carrying)
			var/mutable_appearance/MA = new(item)
			MA.layer = FLOAT_LAYER
			MA.pixel_x = rand(-12, 12)
			MA.pixel_y = rand(-12, 12)
			add_overlay(MA)
	else
		..()

/*
============~~~~~==============~~~~~=============
=												=
=  Code for trays carrying things. By Nanako.
=												=
============~~~~~============~~~~~===============
*/

//Clicking an item individually loads it. clicking a table places the tray on it safely
/obj/item/tray/afterattack(atom/target, mob/user, proximity)
	if(proximity)
		if(istype(target, /obj/item))
			var/obj/item/I = target
			attempt_load_item(I,user,1)

	if(istype(target,/obj/structure/table))
		safedrop = TRUE

//Alt+click with the tray in hand attempts to grab everything on the tile
/obj/item/tray/alt_attack(var/atom/A, var/mob/user)
	var/dist
	var/tile
	if(istype(A, /turf))
		dist = get_dist(A, get_turf(user))
		tile = A
	else
		dist = get_dist(get_turf(A), get_turf(user))
		tile = get_turf(A)

	if(dist == 1)//checking that we're adjacent
		var/addedSomething = 0
		for(var/obj/item/I in tile)
			if(attempt_load_item(I, usr, 0))
				addedSomething++
		if(addedSomething)
			user.visible_message(SPAN_NOTICE("\The [user] loads [addedSomething > 1 ? "some things" : "an item"] onto their service tray."))
		else
			to_chat(user, SPAN_WARNING("The tray is full or there's nothing to load here."))
			return TRUE
		return FALSE //This prevents the alt-click from doing any further actions
	return TRUE

/obj/item/tray/AltClick(var/mob/user)
	if(use_check_and_message(user))
		return
	unload(user)

/obj/item/tray/proc/attempt_load_item(var/obj/item/I, var/mob/user, var/messages = TRUE)
	if(I != src && !I.anchored && !istype(I, /obj/item/projectile))
		var/match = FALSE
		for(var/T in valid)
			if(istype(I, T))
				match = TRUE
				var/remaining = max_carry - current_weight
				if(remaining >= I.w_class)
					load_item(I, user)
					if(messages)
						to_chat(user, SPAN_NOTICE("You place \the [I] on \the [src]."))
					return TRUE
				else
					if(messages)
						to_chat(user, SPAN_WARNING("\The [src] can't take hold that much weight."))
					break
		if(!match && messages)
			to_chat(user, SPAN_WARNING("That item isn't suitable for a tray."))
	return FALSE


/obj/item/tray/proc/load_item(var/obj/item/I, var/mob/user)
	user.remove_from_mob(I) // these two lines need to stay for borgcode trays to work i hate it i hate it - geeves
	I.forceMove(src)
	current_weight += I.w_class
	carrying += I
	var/mutable_appearance/MA = new(I)
	MA.layer = FLOAT_LAYER
	MA.pixel_x = rand(-12, 12)
	MA.pixel_y = rand(-12, 12)
	add_overlay(MA)

/obj/item/tray/verb/unload()
	set name = "Unload Tray"
	set category = "Object"
	set src in view(1)

	if(!isturf(loc))//check that we're not being held by a mob
		to_chat(usr, SPAN_WARNING("Place \the [src] down first!"))
		return
	else
		var/turf/dropspot = get_turf(src)
		for(var/obj/item/I in carrying)
			I.forceMove(dropspot)
			carrying -= I
		cut_overlays()
		current_weight = 0
		usr.visible_message(SPAN_NOTICE("[usr] unloads \the [src]."), SPAN_NOTICE("You unload \the [src]."))

/obj/item/tray/proc/unload_at_loc(var/turf/dropspot = null, var/mob/user)
	if(!isturf(loc) && !dropspot)//check that we're not being held by a mob
		to_chat(user, SPAN_WARNING("Place \the [src] down first!"))
		return
	else
		if(!dropspot)
			dropspot = get_turf(src)

		for(var/obj/item/I in carrying)
			I.forceMove(dropspot)
			carrying -= I

		cut_overlays()
		current_weight = 0
		user.visible_message(SPAN_NOTICE("\The [user] unloads \the [src]."), SPAN_NOTICE("You unload \the [src]."))


/obj/item/tray/proc/spill(var/mob/user = null, var/turf/dropspot = null)
	//This proc is called when a tray is thrown or dropped on the floor
	//its also called when a cyborg uses its tray on the floor
	if (current_weight > 0)//can't spill a tray with nothing on it
		cut_overlays()

		//First we have to find where the items are being dropped, unless a location has been passed in
		if(!dropspot)
			dropspot = get_turf(src)

		for(var/obj/item/I in carrying)
			I.forceMove(dropspot)
			carrying.Remove(I)
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(cardinal))
						sleep(rand(2, 4))
		if(user)
			user.visible_message(SPAN_WARNING("\The [user] spills the contents of their tray all over the floor."))
		else
			src.visible_message(SPAN_WARNING("The tray scatters its contents all over the area."))
		current_weight = 0
		playsound(dropspot, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, TRUE)

/obj/item/tray/throw_impact(atom/hit_atom)
	spill(null, get_turf(src))

/obj/item/tray/throw_at(atom/target, throw_range, throw_speed, mob/user)
	safedrop = TRUE //we dont want the tray to spill when thrown, it will spill on impact instead
	..()

/obj/item/tray/dropped(mob/user)
	spawn(1)//A hack to avoid race conditions. Dropped procs too quickly
		if(ismob(loc))
			//If this is true, then the tray has just switched hands and is still held by a mob
			return

		if(!safedrop)
			spill(user, get_turf(src))
		safedrop = FALSE

/obj/item/tray/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(istype(A,/obj/structure/table))
		safedrop = TRUE
	..(A, user, click_parameters)
