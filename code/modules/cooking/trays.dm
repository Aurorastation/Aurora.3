/*
* Trays - Nanako, ported by Jade
*/
//Use tray on an item to load it.
//To unload, place on a table, then rightclic > Unload tray. Alternatively, alt+click on the tray to unload it
//Tray will spill if thrown, dropped on the floor, or used to hit someone with. Spilling scatters contents

/obj/item/tray
	name = "tray"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	throwforce = 12.0
	force = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	obj_flags = OBJ_FLAG_CONDUCTABLE
	matter = list(DEFAULT_WALL_MATERIAL = 3000)
	recyclable = TRUE
	hitsound = /singleton/sound_category/bottle_hit_broken
	drop_sound = /singleton/sound_category/bottle_hit_broken
	var/max_carry = 20
	var/current_weight = 0
	var/cooldown = 0	//shield bash cooldown. based on world.time
	var/safedrop = 0	//Used to tell when we should or shouldn't spill if the tray is dropped.
	//Safedrop is set true when throwing, because it will spill on impact. And when placing on a table

/obj/item/tray/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(isemptylist(contents))
		return
	spill(user, target.loc)

/obj/item/tray/attackby(obj/item/I, mob/user, var/click_params)
	if (isrobot(I.loc))//safety to stop robots losing their items
		return TRUE

	if(istype(I, /obj/item/material/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_DANGER("[user] bashes [src] with [I]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
		return TRUE
	attempt_load_item(I, user, click_params=click_params)

/*
============~~~~~======================~~~~~=============
=														=
=  Code for trays carrying things. By Nanako. And Jade.
=														=
============~~~~~====================~~~~~===============
*/

//Clicking a table places the tray on it safely.
/obj/item/tray/afterattack(atom/target, mob/user, proximity)
	if (istype(target,/obj/structure/table))
		safedrop = TRUE
	if (!proximity)
		return
	if (!istype(target,/obj/item))
		return
	. = ..()

/obj/item/tray/AltClick(var/mob/user)
	if (user.stat || user.incapacitated() || !user.Adjacent(src))
		return
	unload_at_loc(user=user)

/obj/item/tray/proc/attempt_load_item(var/obj/item/I, var/mob/user, var/messages = TRUE, var/click_params)
	if(!I || (I in contents))
		return
	if(I == src || I.anchored || istype(I, /obj/item/projectile))
		return
	if(istype(I, /obj/item/tray))
		var/obj/item/tray/T = I
		if(!(current_weight || T.current_weight))
			return
		T.spill()
		spill()
		user.visible_message(
			"<b>[user]</b> tries to stack two trays and spills their contents everywhere!",
			SPAN_WARNING("You spill both the trays' contents!"),
			SPAN_WARNING("You hear the sound of metal crashing!")
		)
		return
	var/remaining = max_carry - current_weight
	if (remaining >= I.w_class)
		load_item(I,user, click_params)
		if (messages)
			user.visible_message(
				"<b>[user]</b> places [I] on the tray.",
				SPAN_NOTICE("You place [I] on the tray."),
				SPAN_NOTICE("You hear something being placed on a tray.")
			)
		return TRUE
	if (messages)
		to_chat(user, SPAN_NOTICE("The tray can't take that much weight!"))
	return FALSE


/obj/item/tray/proc/load_item(var/obj/item/I, var/mob/user, var/click_params)
	user.remove_from_mob(I)
	I.forceMove(src)
	auto_align(I, click_params)
	current_weight += I.w_class
	vis_contents += I
	I.vis_flags |= VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	item_equipped_event.register(I, src, PROC_REF(pick_up))
	GLOB.destroyed_event.register(I, src, PROC_REF(unload_item))

/obj/item/tray/verb/unload()
	set name = "Unload Tray"
	set category = "Object"
	set src in view(1)
	unload_at_loc(user = usr)

#define CELLS 16							//Amount of cells per row/column in grid
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
	current_weight -= min(contained.w_class, current_weight)

/obj/item/tray/proc/unload_at_loc(var/turf/dropspot = null, var/mob/user)
	if (!current_weight)
		return
	if (!isturf(loc) && !dropspot)//check that we're not being held by a mob
		to_chat(user, SPAN_NOTICE("Place the tray down first!"))
		return
	if (!dropspot)
		dropspot = get_turf(src)

	for(var/obj/item/I in contents)
		unload_item(I, dropspot)
	user.visible_message("<b>[user]</b> unloads the tray.", SPAN_NOTICE("You unload the tray."))


/obj/item/tray/proc/spill(var/mob/user = null, var/turf/dropspot = null)
	//This proc is called when a tray is thrown or dropped on the floor
	//its also called when a cyborg uses its tray on the floor
	if (!current_weight)//can't spill a tray with nothing on it
		return

	//First we have to find where the items are being dropped, unless a location has been passed in
	if (!dropspot)
		dropspot = get_turf(src)

	for(var/obj/item/I in contents)
		unload_item(I, dropspot)
		I.throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(0, 2), 10)
	if (user)
		user.visible_message("<b>[user]</b> spills their tray all over the floor.", SPAN_WARNING("You spill the tray!"))
	else
		visible_message(SPAN_NOTICE("The tray scatters its contents all over the area."))
	playsound(dropspot, /singleton/sound_category/tray_hit_sound, 50, 1)

/obj/item/tray/throw_impact(atom/hit_atom)
	spill(null, loc)

/obj/item/tray/throw_at(atom/target, throw_range, throw_speed, mob/user)
	safedrop = 1//we dont want the tray to spill when thrown, it will spill on impact instead
	..()

/obj/item/tray/dropped(mob/user)
	. = ..()
	spawn(1)//A hack to avoid race conditions. Dropped procs too quickly
		if (ismob(loc))
			//If this is true, then the tray has just switched hands and is still held by a mob
			return

		if (!safedrop)
			spill(user, loc)

		safedrop = FALSE

/obj/item/tray/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(istype(A,/obj/structure/table))
		safedrop = TRUE
	return ..(A, user, click_parameters)

/obj/item/tray/plate
	name = "serving plate"
	desc = "A large plate for serving meals on."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "l_plate"
	throwforce = 4
	force = 3
	atom_flags = 0
	matter = list(DEFAULT_TABLE_MATERIAL = 1000)
	recyclable = TRUE
	max_carry = 7 // That's 3 dishes, a knife, spoon and fork and a glass

/obj/item/tray/tea
	name = "tea tray"
	desc = "A tray for serving tea."
	icon_state = "teatray"
	force = 3
	throwforce = 3
	atom_flags = 0
	matter = list(DEFAULT_TABLE_MATERIAL = 1000)
	recyclable = TRUE
	max_carry = 6
	contained_sprite = TRUE
