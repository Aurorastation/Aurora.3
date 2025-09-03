#define STATE_CLOSED 0
#define STATE_OPEN 1

/obj/item/inflatable
	name = "inflatable"
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/item/inflatables.dmi'
	var/deploy_path = null

/obj/item/inflatable/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Inflate by using it in your hand. The inflatable barrier will inflate on the turf you are standing on."
	. += "To deflate it, use the 'deflate' verb or ctrl-click on it."
	. += "<b>When passing through an airlock made of inflatables, GO SLOWLY!</b>"

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
	icon = 'icons/obj/item/inflatables.dmi'
	icon_state = "wall"

	density = TRUE
	anchored = TRUE
	atmos_canpass = CANPASS_DENSITY

	var/deflating = FALSE
	var/undeploy_path = null
	var/torn_path = null
	var/health = 15

/obj/structure/inflatable/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "To deflate it safely, use the 'deflate' verb or ctrl-click on it."
	. += "Hitting these with any objects will probably puncture and break it forever."

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
	if(mover?.movement_type & PHASING)
		return TRUE

	if(isprojectile(mover))
		visible_message(SPAN_DANGER("\The [src] rapidly deflates!"))
		deflate(TRUE)
		return TRUE
	return FALSE

/obj/structure/inflatable/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	var/proj_damage = hitting_projectile.get_structure_damage()
	if(!proj_damage)
		return

	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	bullet_ping(hitting_projectile)

	health -= proj_damage

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

/obj/structure/inflatable/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item) || istype(attacking_item, /obj/item/inflatable_dispenser))
		return
	if(deflating)
		return

	if(attacking_item.can_puncture())
		user.visible_message(SPAN_DANGER("[user] pierces \the [src] with \the [attacking_item]!"), SPAN_WARNING("You pierce \the [src] with \the [attacking_item]!"))
		deflate(TRUE)
	else if(attacking_item.damtype == DAMAGE_BRUTE || attacking_item.damtype == DAMAGE_BURN)
		hit(attacking_item.force)
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
		addtimer(CALLBACK(src, PROC_REF(post_tear)), 0.2 SECONDS)
	else
		if(!undeploy_path)
			return
		deflating = TRUE
		if(msg)
			visible_message(SPAN_NOTICE("\The [src] slowly deflates."))
		var/matrix/M = new
		M.Scale(0.6)
		animate(src, 2.6 SECONDS, transform = M)
		addtimer(CALLBACK(src, PROC_REF(post_deflate)), 2.6 SECONDS)

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

	if(isghost(usr) || usr.restrained() || !usr.Adjacent(src))
		return

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()

/obj/structure/inflatable/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	health -= damage
	user.do_attack_animation(src)
	if(health <= 0)
		user.visible_message(SPAN_DANGER("[user] [attack_verb] open the [src]!"))
		INVOKE_ASYNC(src, PROC_REF(deflate), TRUE)
	else
		user.visible_message(SPAN_DANGER("[user] [attack_verb] at [src]!"))
	return TRUE

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	icon_state = "door_closed"
	undeploy_path = /obj/item/inflatable/door
	torn_path = /obj/item/inflatable/door/torn

	var/state = STATE_CLOSED
	var/isSwitchingStates = FALSE

/obj/structure/inflatable/door/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click the door to open or close it. It only stops air while closed."
	. += "<b>When passing through an airlock made of inflatables, GO SLOWLY!</b>"
	. += "To deflate it safely, use the 'deflate' verb or ctrl-click on it."
	. += "Hitting these with any objects will probably puncture and break it forever."
	. += "<b>FOR THE SECOND TIME: GO SLOWLY TO MAKE SURE THE DOORS ARE FULLY CLOSED!</b>"

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
	if(mover?.movement_type & PHASING)
		return TRUE
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
	addtimer(CALLBACK(src, PROC_REF(ResetOpen)), 1 SECOND)

/obj/structure/inflatable/door/proc/ResetOpen()
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/inflatable/door/proc/Close()
	set waitfor = FALSE

	if(isSwitchingStates)
		return
	isSwitchingStates = TRUE
	flick("door_closing", src)
	addtimer(CALLBACK(src, PROC_REF(ResetClose)), 1 SECOND)

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
	icon_state = "folded_wall-torn"
	persistency_considered_trash = TRUE

/obj/item/inflatable/torn/persistence_apply_content(content, x, y, z)
	src.x = x
	src.y = y
	src.z = z

/obj/item/inflatable/torn/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("The inflatable wall is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon_state = "folded_door-torn"
	persistency_considered_trash = TRUE

/obj/item/inflatable/door/torn/persistence_apply_content(content, x, y, z)
	src.x = x
	src.y = y
	src.z = z

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
	w_class = WEIGHT_CLASS_NORMAL
	display_contents_with_number = TRUE
	max_storage_space = DEFAULT_BACKPACK_STORAGE
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
