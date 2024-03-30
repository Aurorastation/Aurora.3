/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "generic"
	density = TRUE
	build_amt = 2
	slowdown = 5

	var/icon_door = null
	var/icon_door_override = FALSE //override to have open overlay use icon different to its base's
	var/icon_door_overlay = "" //handles secure locker overlays like the locking lights

	var/secure = FALSE //secure locker or not. typically it shouldn't need lights if it's insecure
	var/secure_lights = FALSE // whether to display secure lights when open.
	var/opened = FALSE
	var/welded = FALSE
	var/locked = FALSE
	var/broken = FALSE

	var/large = TRUE // if you can shove people in it
	var/canbemoved = FALSE // if it can be moved by people using the right tools. basically means if you can change the anchored var.
	var/screwed = TRUE // if its screwed in place
	var/wrenched = TRUE // if its wrenched down

	var/wall_mounted = FALSE //never solid (You can always pass over it)
	var/health = 100
	var/breakout = 0 //if someone is currently breaking out. mutex

	var/storage_capacity = 45 //Tying this to mob sizes was dumb
	//This is so that someone can't pack hundreds of items in a locker/crate
							//then open it in a populated area to crash clients.

	var/open_sound = 'sound/effects/closet_open.ogg'
	var/close_sound = 'sound/effects/closet_close.ogg'
	var/open_sound_volume = 35
	var/close_sound_volume = 50

	var/store_misc = TRUE
	var/store_items = TRUE
	var/store_mobs = TRUE
	var/store_structure = FALSE
	var/dense_when_open = FALSE
	var/maximum_mob_size = 15

	var/const/default_mob_size = 15
	var/obj/item/closet_teleporter/linked_teleporter

	var/double_doors = FALSE

	var/obj/effect/overlay/closet_door/door_obj
	var/obj/effect/overlay/closet_door/door_obj_alt
	var/is_animating_door = FALSE
	var/door_underlay = FALSE //used if you want to have an overlay below the door. used for guncabinets.
	var/door_anim_squish = 0.12 // Multiplier on proc/get_door_transform. basically, how far you want this to swing out. value of 1 means the length of the door is unchanged (and will swing out of the tile), 0 means it will just slide back and forth.
	var/door_anim_angle = 147
	var/door_hinge = -6.5 // for closets, x away from the centre of the closet. typically good to add a 0.5 so it's centered on the edge of the closet.
	var/door_hinge_alt = 6.5 // for closets with two doors. why a seperate var? because some closets may be weirdly shaped or something.
	var/door_anim_time = 2.5 // set to 0 to make the door not animate at all


/obj/structure/closet/LateInitialize()
	if(opened)	// if closed, any item at the crate's loc is put in the contents
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

/obj/structure/closet/Initialize(mapload, var/no_fill)
	. = ..()
	update_icon()
	if(!no_fill)
		fill()
	if(secure)
		verbs += /obj/structure/closet/proc/verb_togglelock
	return mapload ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_NORMAL

// Fill lockers with this.
/obj/structure/closet/proc/fill()

/obj/structure/closet/proc/content_info(mob/user, content_size)
	if(!content_size)
		. = "\The [src] is empty."
	else if(storage_capacity > content_size*4)
		. = "\The [src] is barely filled."
	else if(storage_capacity > content_size*2)
		. = "\The [src] is less than half full."
	else if(storage_capacity > content_size)
		. = "\The [src] still has some free space."
	else
		. = "\The [src] is full."

/obj/structure/closet/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1 && !src.opened)
		var/content_size = 0
		for(var/obj/item/I in contents)
			if(!I.anchored)
				content_size += Ceiling(I.w_class/2)
		. += content_info(user, content_size)

	if(!src.opened && isobserver(user))
		. += "It contains: [counting_english_list(contents)]"

	if(src.opened && linked_teleporter && is_adjacent)
		. += FONT_SMALL(SPAN_NOTICE("There appears to be a device attached to the interior backplate of \the [src]..."))

/obj/structure/closet/proc/stored_weight()
	var/content_size = 0
	for(var/obj/item/I in contents)
		if(!I.anchored)
			content_size += Ceiling(I.w_class/2)
	return content_size

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0 || wall_mounted)) return 1
	if(istype(mover) && mover.checkpass(PASSTRACE))
		return 1
	return (!density)

/obj/structure/closet/proc/can_open()
	if(welded || locked)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 1
	return 1

/obj/structure/closet/dump_contents()
	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in contents)
		AD.forceMove(loc)

	for(var/obj/I in contents - linked_teleporter)
		I.forceMove(loc)

	for(var/mob/M in contents)
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/open()
	if(opened)
		return 0
	if(!can_open())
		return 0

	if(climbable)
		structure_shaken()
	opened = TRUE
	dump_contents()
	animate_door(FALSE)
	if(double_doors)
		animate_door_alt(FALSE)
	update_icon()
	playsound(loc, open_sound, open_sound_volume, 0, -3)
	if(!dense_when_open)
		density = FALSE
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
	if(store_structure)
		stored_units += store_structure(stored_units)
	opened = FALSE
	animate_door(TRUE)
	if(double_doors)
		animate_door_alt(TRUE)
	update_icon()

	if(linked_teleporter)
		if(linked_teleporter.last_use + 600 > world.time)
			return
		var/did_teleport = FALSE
		for(var/mob/M in contents)
			if(linked_teleporter.do_teleport(M))
				did_teleport = TRUE
		if(did_teleport)
			linked_teleporter.last_use = world.time

	playsound(get_turf(src), close_sound, close_sound_volume, 0, -3)
	density = initial(density)
	return TRUE

//Chem Projector Exception
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

/obj/structure/closet/proc/store_mobs(var/stored_units, var/mob_limit)
	var/added_units = 0
	for(var/mob/living/M in loc)
		if(M.buckled_to || M.pinned.len)
			continue
		if(M.mob_size >= maximum_mob_size)
			continue
		if(stored_units + added_units + M.mob_size > storage_capacity)
			break
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		added_units += M.mob_size
		if(mob_limit) //We only want to store one valid mob
			break
	return added_units

/obj/structure/closet/proc/store_structure(var/stored_units)
	var/added_units = 0
	for(var/obj/O in loc)
		if((stored_units + added_units) > storage_capacity)
			break
		if(O.density || O.anchored || istype(O,/obj/structure/closet))
			continue
		if(istype(O, /obj/structure/bed))
			var/obj/structure/bed/B = O
			if(B.buckled)
				continue
		O.forceMove(src)
		added_units++
	return added_units

/obj/structure/closet/proc/toggle(mob/user as mob)
	if(!(opened ? close(user) : open(user)))
		to_chat(user, SPAN_WARNING("It won't budge!"))
		return
	return 1

/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			health -= rand(120, 240)
		if(2)
			health -= rand(60, 120)
		if(3)
			health -= rand(30, 60)

	if(health <= 0)
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

/obj/structure/closet/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/closet_teleporter))
		if(linked_teleporter)
			to_chat(user, SPAN_WARNING("\The [src] already has a linked teleporter!"))
			return
		var/obj/item/closet_teleporter/CT = attacking_item
		user.visible_message(SPAN_NOTICE("\The [user] starts attaching \the [CT] to \the [src]..."), SPAN_NOTICE("You begin attaching \the [CT] to \the [src]..."), range = 3)
		if(do_after(user, 30, src, DO_REPAIR_CONSTRUCT))
			user.visible_message(SPAN_NOTICE("\The [user] attaches \the [CT] to \the [src]."), SPAN_NOTICE("You attach \the [CT] to \the [src]."), range = 3)
			linked_teleporter = CT
			CT.attached_closet = src
			user.drop_from_inventory(CT, src)
		return
	if(opened)
		if(istype(attacking_item, /obj/item/grab))
			var/obj/item/grab/G = attacking_item
			MouseDrop_T(G.affecting, user) //act like they were dragged onto the closet
			return 0
		if(attacking_item.isscrewdriver()) // Moved here so you can only detach linked teleporters when the door is open. So you can like unscrew and bolt the locker normally in most circumstances.
			if(linked_teleporter)
				user.visible_message(SPAN_NOTICE("\The [user] starts detaching \the [linked_teleporter] from \the [src]..."), SPAN_NOTICE("You begin detaching \the [linked_teleporter] from \the [src]..."), range = 3)
				if(do_after(user, 30, src, DO_REPAIR_CONSTRUCT))
					user.visible_message(SPAN_NOTICE("\The [user] detaches \the [linked_teleporter] from \the [src]."), SPAN_NOTICE("You detach \the [linked_teleporter] from \the [src]."), range = 3)
					linked_teleporter.attached_closet = null
					user.put_in_hands(linked_teleporter)
					linked_teleporter = null
				return
		if(attacking_item.iswelder())
			var/obj/item/weldingtool/WT = attacking_item
			if(WT.isOn())
				user.visible_message(
					SPAN_WARNING("[user] begins cutting [src] apart."),
					SPAN_NOTICE("You begin cutting [src] apart."),
					"You hear a welding torch on metal."
				)
				playsound(loc, 'sound/items/welder_pry.ogg', 50, 1)
				if (!do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT))
					return
				if(!WT.use(0,user))
					to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
					return
				else
					user.visible_message(
						SPAN_NOTICE("[src] has been cut apart by [user] with [WT]."),
						SPAN_NOTICE("You cut apart [src] with [WT].")
					)
					if(linked_teleporter)
						linked_teleporter.forceMove(get_turf(src))
						linked_teleporter = null
					dismantle()
					return
		if(istype(attacking_item, /obj/item/storage/laundry_basket) && attacking_item.contents.len)
			var/obj/item/storage/laundry_basket/LB = attacking_item
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T)
			user.visible_message(
				SPAN_NOTICE("[user] empties \the [LB] into \the [src]."),
				SPAN_NOTICE("You empty \the [LB] into \the [src]."),
				SPAN_NOTICE("You hear rustling of clothes.")
			)
			return
		if(!attacking_item.dropsafety())
			return
		if(attacking_item)
			user.drop_from_inventory(attacking_item,loc)
		else
			user.drop_item()
	else if(istype(attacking_item, /obj/item/device/cratescanner))
		var/obj/item/device/cratescanner/Cscanner = attacking_item
		if(locked)
			to_chat(user, SPAN_WARNING("[attacking_item] refuses to scan [src]. Unlock it first!"))
			return
		if(welded)
			to_chat(user, SPAN_WARNING("[attacking_item] detects that [src] is welded shut, and refuses to scan."))
			return
		Cscanner.print_contents(name, contents, src.loc)
	else if(istype(attacking_item, /obj/item/stack/packageWrap))
		return
	else if(istype(attacking_item, /obj/item/ducttape))
		return
	else if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.isOn())
			user.visible_message(
				SPAN_WARNING("[user] begins welding [src] [welded ? "open" : "shut"]."),
				SPAN_NOTICE("You begin welding [src] [welded ? "open" : "shut"]."),
				"You hear a welding torch on metal."
			)
			playsound(loc, 'sound/items/welder_pry.ogg', 50, 1)
			if(!attacking_item.use_tool(src, user, 20, volume = 50, extra_checks = CALLBACK(src, PROC_REF(is_closed))))
				return
			if(!WT.use(0,user))
				to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
				return
			welded = !welded
			update_icon()
			user.visible_message(
				SPAN_WARNING("[src] has been [welded ? "welded shut" : "unwelded"] by [user]."),
				SPAN_NOTICE("You weld [src] [!welded ? "open" : "shut"].")
			)
		else
			attack_hand(user)
	else if(attacking_item.isscrewdriver() && canbemoved)
		if(screwed)
			to_chat(user,  SPAN_NOTICE("You start to unscrew \the [src] from the floor..."))
			attacking_item.play_tool_sound(get_turf(src), 50)
			if (do_after(user, 10/attacking_item.toolspeed SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user,  SPAN_NOTICE("You unscrew the locker!"))
				attacking_item.play_tool_sound(get_turf(src), 50)
				screwed = FALSE
		else if(!screwed && wrenched)
			to_chat(user,  SPAN_NOTICE("You start to screw the \the [src] to the floor..."))
			playsound(src, 'sound/items/Welder.ogg', 80, 1)
			if (do_after(user, 15/attacking_item.toolspeed SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user,  SPAN_NOTICE("You screw \the [src]!"))
				attacking_item.play_tool_sound(get_turf(src), 50)
				screwed = TRUE
	else if(attacking_item.iswrench() && canbemoved)
		if(wrenched && !screwed)
			to_chat(user,  SPAN_NOTICE("You start to unfasten the bolts holding \the [src] in place..."))
			attacking_item.play_tool_sound(get_turf(src), 50)
			if (do_after(user, 15/attacking_item.toolspeed SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user,  SPAN_NOTICE("You unfasten \the [src]'s bolts!"))
				attacking_item.play_tool_sound(get_turf(src), 50)
				wrenched = FALSE
				anchored = FALSE
		else if(!wrenched)
			to_chat(user,  SPAN_NOTICE("You start to fasten the bolts holding the locker in place..."))
			attacking_item.play_tool_sound(get_turf(src), 50)
			if (do_after(user, 15/attacking_item.toolspeed SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user,  SPAN_NOTICE("You fasten the \the [src]'s bolts!"))
				attacking_item.play_tool_sound(get_turf(src), 50)
				wrenched = TRUE
				anchored = TRUE
	else if(istype(attacking_item, /obj/item/device/hand_labeler))
		var/obj/item/device/hand_labeler/HL = attacking_item
		if(HL.mode == 1)
			return
		else
			attack_hand(user)
	else if(istype(attacking_item,/obj/item/card/id) && secure)
		togglelock(user)

// Secure locker cutting open stuff.
	else if(!opened && secure)
		if(!broken && istype(attacking_item,/obj/item/material/twohanded/chainsaw))
			var/obj/item/material/twohanded/chainsaw/ChainSawVar = attacking_item
			ChainSawVar.cutting = 1
			user.visible_message(\
				SPAN_DANGER("[user.name] starts cutting \the [src] with the [attacking_item]!"),\
				SPAN_WARNING("You start cutting the [src]..."),\
				SPAN_NOTICE("You hear a loud buzzing sound and metal grinding on metal...")\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, user, DO_REPAIR_CONSTRUCT))
				user.visible_message(\
					SPAN_WARNING("[user.name] finishes cutting open \the [src] with the [attacking_item]."),\
					SPAN_WARNING("You finish cutting open the [src]."),\
					SPAN_NOTICE("You hear a metal clank and some sparks.")\
				)
				emag_act(INFINITY, user, SPAN_DANGER("\The [src] has been sliced open by [user] with \an [attacking_item]!"), SPAN_DANGER("You hear metal being sliced and sparks flying."))
			ChainSawVar.cutting = 0
		else if(istype(attacking_item, /obj/item/melee/energy/blade))//Attempt to cut open locker if locked
			if(emag_act(INFINITY, user, SPAN_DANGER("\The [src] has been sliced open by [user] with \an [attacking_item]!"), SPAN_DANGER("You hear metal being sliced and sparks flying.")))
				playsound(loc, 'sound/weapons/blade.ogg', 50, 1)
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

/obj/structure/closet/MouseDrop_T(atom/dropping, mob/user)
	var/atom/movable/O = dropping
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
	if(user != O)
		var/turf/T = get_turf(src)
		if(ismob(O))
			if(large)
				user.visible_message(SPAN_DANGER("<b>[user]</b> stuffs \the [O] into \the [src]!"), SPAN_NOTICE("You stuff \the [O] into \the [src]."), range = 3)
				O.forceMove(T)
				close()
			else
				to_chat(user,  SPAN_NOTICE("\The [src] is too small to stuff [O] into!"))
		else
			O.forceMove(T)
	add_fingerprint(user)
	return

/obj/structure/closet/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Robots can open/close it, but not the AI.
		attack_hand(user)

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(loc))
		return

	if(!open())
		to_chat(user, SPAN_NOTICE("It won't budge!"))

/obj/structure/closet/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(locked)
		togglelock(user)
	else
		toggle(user)

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr) || (issilicon(usr) && Adjacent(usr)))
		add_fingerprint(usr)
		toggle(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/update_icon()
	if(!door_underlay)
		cut_overlays()

	if(!opened)
		layer = OBJ_LAYER
		if(welded)
			add_overlay("[icon_door_overlay]welded")
		if(!is_animating_door)
			if(icon_door)
				add_overlay("[icon_door]_door")
				if(double_doors)
					add_overlay("[icon_door]_door_alt")
			if(!icon_door)
				add_overlay("[icon_state]_door")
				if(double_doors)
					add_overlay("[icon_state]_door_alt")
			if(secure)
				update_secure_overlays()
		if(secure && secure_lights)
			update_secure_overlays()
	else if(opened)
		layer = BELOW_OBJ_LAYER
		if(!is_animating_door)
			add_overlay("[icon_door_override ? icon_door : icon_state]_open")
		if(secure && secure_lights)
			update_secure_overlays()

/obj/structure/closet/proc/update_secure_overlays()
	if(broken)
		add_overlay("[icon_door_overlay]emag")
	else
		if(locked)
			add_overlay("[icon_door_overlay]locked")
		else
			add_overlay("[icon_door_overlay]unlocked")

/obj/structure/closet/proc/animate_door(var/closing = FALSE)
	if(!door_anim_time)
		return
	if(!door_obj) door_obj = new
	vis_contents |= door_obj
	door_obj.icon = icon
	door_obj.icon_state = "[icon_door || icon_state]_door"
	is_animating_door = TRUE
	var/num_steps = door_anim_time / world.tick_lag
	for(var/I in 0 to num_steps)
		var/angle = door_anim_angle * (closing ? 1 - (I/num_steps) : (I/num_steps))
		var/matrix/M = get_door_transform(angle)
		var/door_state = angle >= 90 ? "[icon_door_override ? icon_door : icon_state]_back" : "[icon_door || icon_state]_door"
		var/door_layer = angle >= 90 ? FLOAT_LAYER : ABOVE_MOB_LAYER

		if(I == 0)
			door_obj.transform = M
			door_obj.icon_state = door_state
			door_obj.layer = door_layer
		else if(I == 1)
			animate(door_obj, transform = M, icon_state = door_state, layer = door_layer, time = world.tick_lag, flags = ANIMATION_END_NOW)
		else
			animate(transform = M, icon_state = door_state, layer = door_layer, time = world.tick_lag)
	addtimer(CALLBACK(src, PROC_REF(end_door_animation)),door_anim_time,TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/structure/closet/proc/end_door_animation()
	is_animating_door = FALSE // comment this out and the line below to manually tweak the animation end state by fiddling with the door_anim vars to match the open door icon
	remove_vis_contents(door_obj)
	update_icon()
	compile_overlays(src)

/obj/structure/closet/proc/animate_door_alt(var/closing = FALSE)
	if(!door_anim_time)
		return
	if(!door_obj_alt) door_obj_alt = new
	vis_contents |= door_obj_alt
	door_obj_alt.icon = icon
	door_obj_alt.icon_state = "[icon_door || icon_state]_door_alt"
	is_animating_door = TRUE
	var/num_steps = door_anim_time / world.tick_lag
	for(var/I in 0 to num_steps)
		var/angle = door_anim_angle * (closing ? 1 - (I/num_steps) : (I/num_steps))
		var/matrix/M = get_door_transform(angle, TRUE)
		var/door_state = angle >= 90 ? "[icon_door_override ? icon_door : icon_state]_back_alt" : "[icon_door || icon_state]_door_alt"
		var/door_layer = angle >= 90 ? FLOAT_LAYER : ABOVE_MOB_LAYER

		if(I == 0)
			door_obj_alt.transform = M
			door_obj_alt.icon_state = door_state
			door_obj_alt.layer = door_layer
		else if(I == 1)
			animate(door_obj_alt, transform = M, icon_state = door_state, layer = door_layer, time = world.tick_lag, flags = ANIMATION_END_NOW)
		else
			animate(transform = M, icon_state = door_state, layer = door_layer, time = world.tick_lag)
	addtimer(CALLBACK(src, PROC_REF(end_door_animation_alt)),door_anim_time,TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/structure/closet/proc/end_door_animation_alt()
	is_animating_door = FALSE // comment this out and the line below to manually tweak the animation end state by fiddling with the door_anim vars to match the open door icon
	remove_vis_contents(door_obj_alt)
	update_icon()
	compile_overlays(src)

/obj/structure/closet/proc/get_door_transform(angle, var/inverse_hinge = FALSE)
	var/matrix/M = matrix()
	var/matrix_door_hinge = inverse_hinge ? door_hinge_alt : door_hinge
	M.Translate(-matrix_door_hinge, 0)
	M.Multiply(matrix(cos(angle), 0, 0, ((matrix_door_hinge >= 0) ? sin(angle) : -sin(angle)) * door_anim_squish, 1, 0)) // this matrix door hinge >= 0 check is for door hinges on the right, so they swing out instead of upwards
	M.Translate(matrix_door_hinge, 0)
	return M

/obj/structure/closet/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	for (var/atom/A in src)
		if(istype(A,/obj/))
			var/obj/O = A
			O.hear_talk(M, text, verb, speaking)

/obj/structure/closet/attack_generic(var/mob/user, var/damage, var/attack_message = "attacks", var/wallbreaker)
	if(!damage || !wallbreaker)
		return
	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("[user] [attack_message] \the [src]!"))
	damage(damage)
	return TRUE

/obj/structure/closet/proc/req_breakout()
	if(!opened) //Door's open... wait, why are you in it's contents then?
		if(locked)
			if(welded)
				return 2
			else
				return 1
		if(breakout)
			return -1 //Already breaking out.
	else
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
	to_chat(escapee, SPAN_WARNING("You lean on the back of \the [src] and start pushing the door open. (This will take about [breakout_time] minutes.)"))
	visible_message(SPAN_DANGER("\The [src] begins to shake violently!"), SPAN_DANGER("You hear the sound of metal thrashing around nearby."), intent_message = THUNK_SOUND)

	var/time = 6 * breakout_time * 2

	var/datum/progressbar/bar
	if (escapee.client && escapee.client.prefs.toggles_secondary & PROGRESS_BARS)
		bar = new(escapee, time, src)

	breakout = 1
	for(var/i in 1 to time) //minutes * 6 * 5seconds * 2
		playsound(loc, 'sound/effects/grillehit.ogg', 100, 1)
		shake_animation()
		intent_message(THUNK_SOUND)

		if (bar)
			bar.update(i)

		if(!do_after(escapee, 50, do_flags = DO_DEFAULT & ~DO_SHOW_PROGRESS)) //5 seconds
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
	playsound(loc, 'sound/effects/grillehit.ogg', 100, 1)
	break_open(escapee)
	shake_animation()
	qdel(bar)

/obj/structure/closet/proc/break_open(mob/user)
	if(secure && !broken)
		to_chat(user, SPAN_WARNING("You successfully break out!"))
		welded = FALSE
		emag_act(INFINITY, user, SPAN_DANGER("\The [user] successfully breaks out of \the [src]!"), SPAN_DANGER("You hear the sound of metal being forced apart!"))
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
	if(linked_teleporter)
		linked_teleporter.forceMove(get_turf(src))
		linked_teleporter = null
	dump_contents()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/structure/closet/Destroy()
	if(linked_teleporter)
		QDEL_NULL(linked_teleporter)
	return ..()

/*
==========================
	Contents Scanner
==========================
*/
/obj/item/device/cratescanner
	name = "crate contents scanner"
	desc = "A  handheld device used to scan and print a manifest of a container's contents. Does not work on locked crates, for privacy reasons."
	icon_state = "cratescanner"
	matter = list(DEFAULT_WALL_MATERIAL = 250, MATERIAL_GLASS = 140)
	w_class = ITEMSIZE_SMALL
	item_state = "electronic"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT

/obj/item/device/cratescanner/proc/print_contents(targetname, targetcontents, targetloc)
	var/output = list()
	var/list/outputstring
	for(var/atom/item in targetcontents)
		if(item.name in output)
			output[item.name] = output[item.name] + 1
		else
			output[item.name] = 1
	for(var/entry in output)
		outputstring += "- [entry]: [output[entry]]x<br>"
	var/obj/item/paper/printout = new /obj/item/paper(targetloc)
	printout.info = "contents of [targetname]<br>"
	printout.info += "[outputstring]"
