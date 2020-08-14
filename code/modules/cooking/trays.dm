/*
 * Trays - Nanako, ported by Jade
 */
 //Use tray on an item to load it.
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

	var/safedrop = 0//Used to tell when we should or shouldn't spill if the tray is dropped.
	//Safedrop is set true when throwing, because it will spill on impact. And when placing on a table

/obj/item/tray/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	// Drop all the things. All of them.
	spill(user, M.loc)

	//Note: Added a robot check to all stun/weaken procs, beccause weakening a robot causes its active modules to bug out
	var/mob/living/carbon/human/H = M      ///////////////////////////////////// /Let's have this ready for later.


	if(!(target_zone == (BP_EYES || BP_HEAD))) //////////////hitting anything else other than the eyes
		if(prob(33) && !issilicon(M))//robots dont bleed
			add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)     ///Plik plik, the sound of blood

		admin_attack_log(user, M, "Bashed with a tray.", "Has been bashed with a tray.", "bashed with a tray")

		if(prob(15))
			if(!issilicon(M)) M.Weaken(3)
			M.take_organ_damage(3)
		else
			M.take_organ_damage(5)
		playsound(M, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, 1)
		visible_message(SPAN_DANGER("[user] slams [M] with the tray!"), SPAN_DANGER("You hear metal crashing."))
		return

	var/protected = 0
	for(var/slot in list(slot_head, slot_wear_mask, slot_glasses))
		var/obj/item/protection = M.get_equipped_item(slot)
		if(istype(protection) && (protection.body_parts_covered & FACE))
			protected = 1
			break

	if(protected)
		to_chat(M, SPAN_WARNING("You get slammed in the face with the tray, against your mask!"))
		if(prob(33) && !issilicon(M))
			add_blood(H)
			if (H.wear_mask)
				H.wear_mask.add_blood(H)
			if (H.head)
				H.head.add_blood(H)
			if (H.glasses && prob(33))
				H.glasses.add_blood(H)
			var/turf/location = get_turf(H)
			if (istype(location))     //Addin' blood! At least on the floor and item :v
				location.add_blood(H)

		playsound(M, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, 1)
		visible_message(SPAN_DANGER("[user] slams [M] with the tray!"), SPAN_DANGER("You hear metal crashing."))
		if(prob(10))
			if(!istype(M,/mob/living/silicon))
				M.Stun(rand(1,3))
			M.take_organ_damage(3)
			return
		else
			M.take_organ_damage(5)
			return

	else if (!issilicon(M))//No eye or head protection, tough luck!
		to_chat(M, SPAN_DANGER("You get slammed in the face with the tray!"))
		if(prob(33))
			add_blood(M)
			var/turf/location = get_turf(H)
			if (istype(location))
				location.add_blood(H)

		playsound(M, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, 1)
		visible_message(SPAN_DANGER("[user] slams [M] with the tray!"), SPAN_DANGER("You hear metal crashing."))
		M.take_organ_damage(4)
		if(prob(30))
			M.Stun(rand(2,4))
			return
		if(prob(30))
			M.Weaken(2)

/obj/item/tray/var/cooldown = 0	//shield bash cooldown. based on world.time

/obj/item/tray/attackby(obj/item/I as obj, mob/user as mob, var/click_params)
	if (istype(user,/mob/living/silicon/robot))//safety to stop robots losing their items
		return

	if(istype(I, /obj/item/material/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_DANGER("[user] bashes [src] with [I]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
		return
	attempt_load_item(I, user, click_params=click_params)

/*
============~~~~~======================~~~~~=============
=														=
=  Code for trays carrying things. By Nanako. And Jade.
=														=
============~~~~~====================~~~~~===============
*/

//Clicking an item individually loads it. clicking a table places the tray on it safely
/obj/item/tray/afterattack(atom/target, mob/user as mob, proximity)
	if (proximity)
		if (istype(target, /obj/item))
			var/obj/item/I = target
			attempt_load_item(I,user)

	if (istype(target,/obj/structure/table))
		safedrop = 1

/obj/item/tray/AltClick(var/mob/user)
	if (user.stat || user.incapacitated() || !user.Adjacent(src)) return
	unload_at_loc(user=user)

/obj/item/tray/proc/attempt_load_item(var/obj/item/I, var/mob/user, var/messages = TRUE, var/click_params)
	if(I in carrying || !I)
		return
	if( I != src && !I.anchored && !istype(I, /obj/item/projectile) )
		if(istype(I, /obj/item/tray))
			var/obj/item/tray/T = I
			if(current_weight || T.current_weight) // Just an easter egg for people who try to cheat.
				T.spill()
				spill()
				user.visible_message(
					SPAN_WARNING("[user] tries to stack two trays and spills their contents everywhere!"),
					SPAN_WARNING("You spill both the trays' contents!"),
					SPAN_WARNING("You hear the sound of metal crashing!")
				)
			return
		var/remaining = max_carry - current_weight
		if (remaining >= I.w_class)
			load_item(I,user, click_params)
			if (messages)
				to_chat(user, SPAN_NOTICE("You place [I] on the tray."))
			return 1
		if (messages)
			to_chat(user, SPAN_NOTICE("The tray can't take that much weight!"))
	return 0


/obj/item/tray/proc/load_item(var/obj/item/I, var/mob/user, var/click_params)
	user.remove_from_mob(I)
	I.forceMove(src)
	auto_align(I, click_params)
	current_weight += I.w_class
	carrying += I
	vis_contents += I
	I.vis_flags |= VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	item_equipped_event.register(I, src, /obj/item/tray/proc/pick_up)
	destroyed_event.register(I, src, /obj/item/tray/proc/unload_item)

/obj/item/tray/verb/unload()
	set name = "Unload Tray"
	set category = "Object"
	set src in view(1)
	unload_at_loc(user = usr)

#define CELLS 8								//Amount of cells per row/column in grid
#define CELLSIZE (world.icon_size/CELLS)	//Size of a cell in pixels

/obj/item/tray/proc/auto_align(obj/item/W, click_parameters)
	if(!W.center_of_mass)
		W.randpixel_xy()
		return

	if(!click_parameters)
		return

	var/list/mouse_control = mouse_safe_xy(click_parameters)
	var/mouse_x = mouse_control["icon-x"]
	var/mouse_y = mouse_control["icon-y"]

	if(isnum(mouse_x) && isnum(mouse_y))
		var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
		var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

		W.pixel_x = (CELLSIZE * (0.5 + cell_x)) - W.center_of_mass["x"]
		W.pixel_y = (CELLSIZE * (0.5 + cell_y)) - W.center_of_mass["y"]

#undef CELLS
#undef CELLSIZE

/obj/item/tray/proc/pick_up(var/obj/item/contained, var/mob/moved_to, var/slot)
	unload_item(contained, moved_to)

/obj/item/tray/proc/unload_item(var/obj/item/contained, var/atom/dropspot = null)
	item_equipped_event.unregister(contained, src)
	if(dropspot)
		contained.forceMove(dropspot)
	vis_contents.Remove(contained)
	contained.vis_flags = initial(contained.vis_flags)
	carrying.Remove(contained)
	current_weight -= min(contained.w_class, current_weight)

/obj/item/tray/proc/unload_at_loc(var/turf/dropspot = null, var/mob/user)
	if (!current_weight)
		return
	if (!istype(loc,/turf) && !dropspot)//check that we're not being held by a mob
		to_chat(user, SPAN_NOTICE("Place the tray down first!"))
		return
	if (!dropspot)
		dropspot = get_turf(src)

	for(var/obj/item/I in carrying)
		unload_item(I, dropspot)
	user.visible_message("[user] unloads the tray.", "You unload the tray.")


/obj/item/tray/proc/spill(var/mob/user = null, var/turf/dropspot = null)
	//This proc is called when a tray is thrown or dropped on the floor
	//its also called when a cyborg uses its tray on the floor
	if (!current_weight)//can't spill a tray with nothing on it
		return

	//First we have to find where the items are being dropped, unless a location has been passed in
	if (!dropspot)
		dropspot = get_turf(src)

	for(var/obj/item/I in carrying)
		unload_item(I, dropspot)
		I.throw_at(get_edge_target_turf(src, pick(alldirs)), rand(0, 2), 10)
	if (user)
		user.visible_message(SPAN_NOTICE("[user] spills their tray all over the floor."))
	else
		visible_message(SPAN_NOTICE("The tray scatters its contents all over the area."))
	playsound(dropspot, pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg'), 50, 1)

/obj/item/tray/throw_impact(atom/hit_atom)
	spill(null, loc)

/obj/item/tray/throw_at(atom/target, throw_range, throw_speed, mob/user)
	safedrop = 1//we dont want the tray to spill when thrown, it will spill on impact instead
	..()

/obj/item/tray/dropped(mob/user)
	spawn(1)//A hack to avoid race conditions. Dropped procs too quickly
		if (istype(loc, /mob))
			//If this is true, then the tray has just switched hands and is still held by a mob
			return

		if (!safedrop)
			spill(user, loc)

		safedrop = 0

/obj/item/tray/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(istype(A,/obj/structure/table))
		safedrop = 1
	..(A, user, click_parameters)
