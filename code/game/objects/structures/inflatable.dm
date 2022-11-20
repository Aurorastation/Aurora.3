#define STATE_CLOSED 0
#define STATE_OPEN 1

/obj/item/inflatable
	name = "inflatable"
	desc_info = "Inflate by using it in your hand. The inflatable barrier will inflate on the turf you are standing on. To deflate it, use the 'deflate' verb."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/item/inflatables.dmi'
	var/deploy_path = null

/obj/item/inflatable/attack_self(mob/user)
	if(!deploy_path)
		return
	playsound(loc, 'sound/items/zip.ogg', 75, TRUE)
	to_chat(user, SPAN_NOTICE("You press the toggle button on \the [src] and it inflates."))
	var/obj/structure/inflatable/R = new deploy_path(user.loc)
	transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/inflatable/wall
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon_state = "folded_wall"
	deploy_path = /obj/structure/inflatable/wall

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door

/obj/structure/inflatable
	name = "inflatable"
	desc = "An inflated membrane. Do not puncture."
	desc_info = "To remove these safely, use the 'deflate' verb.  Hitting these with any objects will probably puncture and break it forever."
	icon = 'icons/obj/item/inflatables.dmi'
	icon_state = "wall"

	density = TRUE
	anchored = TRUE
	atmos_canpass = CANPASS_DENSITY

	var/deflating = FALSE
	var/undeploy_path = null
	var/torn_path = null
	var/health = 15

/obj/structure/inflatable/wall
	name = "inflatable wall"
	undeploy_path = /obj/item/inflatable/wall
	torn_path = /obj/item/inflatable/torn

/obj/structure/inflatable/Initialize(mapload)
	. = ..()
	update_nearby_tiles(need_rebuild = TRUE)

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/inflatable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(isprojectile(mover))
		visible_message(SPAN_DANGER("\The [src] rapidly deflates!"))
		deflate(TRUE)
		return TRUE
	return FALSE

/obj/structure/inflatable/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage)
		return

	bullet_ping(Proj)

	health -= proj_damage
	..()
	if(health <= 0)
		deflate(TRUE)
	return

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			deflate(TRUE, FALSE)
			return
		if(3.0)
			if(prob(50))
				deflate(TRUE, FALSE)
				return

/obj/structure/inflatable/attack_hand(mob/user)
	add_fingerprint(user)
	return

/obj/structure/inflatable/attackby(obj/item/W, mob/user)
	if(!istype(W) || istype(W, /obj/item/inflatable_dispenser))
		return
	if(deflating)
		return

	if(W.can_puncture())
		user.visible_message(SPAN_DANGER("[user] pierces \the [src] with \the [W]!"), SPAN_WARNING("You pierce \the [src] with \the [W]!"))
		deflate(TRUE)
	else if(W.damtype == BRUTE || W.damtype == BURN)
		hit(W.force)
		..()

/obj/structure/inflatable/proc/hit(var/damage, var/sound_effect = TRUE)
	health = max(0, health - damage)
	if(sound_effect)
		playsound(loc, 'sound/effects/glass_hit.ogg', 75, 1)
	if(health <= 0)
		deflate(TRUE)

/obj/structure/inflatable/CtrlClick()
	hand_deflate()

/obj/structure/inflatable/proc/deflate(var/violent = FALSE, msg = TRUE)
	if(deflating)
		return
	playsound(loc, 'sound/machines/hiss.ogg', 75, TRUE)
	if(violent)
		if(!torn_path)
			return
		deflating = TRUE
		if(msg)
			visible_message(SPAN_WARNING("\The [src] rapidly deflates!"))
		var/matrix/M = new
		M.Scale(0.6)
		M.Turn(pick(-40, 40))
		animate(src, 0.2 SECONDS, transform = M)
		addtimer(CALLBACK(src, .proc/post_tear), 0.2 SECONDS)
	else
		if(!undeploy_path)
			return
		deflating = TRUE
		if(msg)
			visible_message(SPAN_NOTICE("\The [src] slowly deflates."))
		var/matrix/M = new
		M.Scale(0.6)
		animate(src, 2.6 SECONDS, transform = M)
		addtimer(CALLBACK(src, .proc/post_deflate), 2.6 SECONDS)

/obj/structure/inflatable/proc/post_deflate()
	var/obj/item/inflatable/R = new undeploy_path(loc)
	transfer_fingerprints_to(R)
	qdel(src)

/obj/structure/inflatable/proc/post_tear()
	var/obj/item/inflatable/torn/R = new torn_path(loc)
	transfer_fingerprints_to(R)
	qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr) || usr.restrained() || !usr.Adjacent(src))
		return

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()

/obj/structure/inflatable/attack_generic(var/mob/user, var/damage, var/attack_verb)
	health -= damage
	user.do_attack_animation(src)
	if(health <= 0)
		user.visible_message(SPAN_DANGER("[user] [attack_verb] open the [src]!"))
		INVOKE_ASYNC(src, .proc/deflate, TRUE)
	else
		user.visible_message(SPAN_DANGER("[user] [attack_verb] at [src]!"))
	return TRUE

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	desc_info = "Click the door to open or close it.  It only stops air while closed.<br>\
	To remove these safely, use the 'deflate' verb.  Hitting these with any objects will probably puncture and break it forever."
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	icon_state = "door_closed"
	undeploy_path = /obj/item/inflatable/door
	torn_path = /obj/item/inflatable/door/torn

	var/state = STATE_CLOSED
	var/isSwitchingStates = FALSE

/obj/structure/inflatable/door/attack_ai(mob/user)
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user) && Adjacent(user)) //but cyborgs can
		return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return state
	if(istype(mover, /obj/effect/beam))
		return !opacity
	if(isprojectile(mover))
		visible_message(SPAN_DANGER("\The [src] rapidly deflates!"))
		deflate(TRUE)
		return TRUE
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(mob/user)
	if(isSwitchingStates)
		return
	if(use_check_and_message(user))
		return
	SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	update_nearby_tiles()

/obj/structure/inflatable/door/proc/Open()
	set waitfor = FALSE

	if(isSwitchingStates)
		return
	isSwitchingStates = TRUE
	density = FALSE
	state = STATE_OPEN
	flick("door_opening",src)
	addtimer(CALLBACK(src, .proc/ResetOpen), 1 SECOND)

/obj/structure/inflatable/door/proc/ResetOpen()
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/inflatable/door/proc/Close()
	set waitfor = FALSE

	if(isSwitchingStates)
		return
	isSwitchingStates = TRUE
	flick("door_closing", src)
	addtimer(CALLBACK(src, .proc/ResetClose), 1 SECOND)

/obj/structure/inflatable/door/proc/ResetClose()
	density = TRUE
	state = STATE_CLOSED
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/inflatable/door/update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon_state = "folded_wall_torn"

/obj/item/inflatable/torn/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("The inflatable wall is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon_state = "folded_door_torn"

/obj/item/inflatable/door/torn/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("The inflatable door is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/storage/bag/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon = 'icons/obj/item/inflatables.dmi'
	icon_state = "inf_box"
	item_state = "inf_box"
	contained_sprite = TRUE
	w_class = ITEMSIZE_NORMAL
	display_contents_with_number = TRUE
	max_storage_space = 28
	force_column_number = 3 // we want 4 slots to appear, so 3 columns + 1 free (to insert stuff)
	storage_slots = 14
	can_hold = list(/obj/item/inflatable)
	starts_with = list(/obj/item/inflatable/door = 5, /obj/item/inflatable/wall = 7)

	use_sound = 'sound/items/storage/briefcase.ogg'
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/storage/bag/inflatable/emergency
	name = "emergency inflatable barrier box"
	desc = "Contains inflatable walls and doors. This box has emergency labelling on it and outlines that there's only enough inflatables within to secure a small area."
	starts_with = list(/obj/item/inflatable/door = 2, /obj/item/inflatable/wall = 3)

#undef STATE_CLOSED
#undef STATE_OPEN
