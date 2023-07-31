#define MODE_WALL 0
#define MODE_DOOR 1

/obj/item/inflatable_dispenser
	name = "inflatables dispenser"
	desc = "Small device which allows rapid deployment and removal of inflatables."
	icon = 'icons/obj/item/inflatables.dmi'
	icon_state = "inf_deployer"
	w_class = ITEMSIZE_NORMAL
	var/deploying = FALSE
	var/max_walls = 10
	var/max_doors = 5
	var/stored_walls = 10
	var/stored_doors = 5
	var/mode = MODE_WALL // 0 - Walls 1 - Doors

/obj/item/inflatable_dispenser/Initialize(mapload, ...)
	. = ..()
	stored_walls = max_walls
	stored_doors = max_doors

/obj/item/inflatable_dispenser/examine(mob/user)
	if(!..(user))
		return
	to_chat(user, SPAN_NOTICE("It has [stored_walls] wall segment\s and [stored_doors] door segment\s stored."))
	to_chat(user, SPAN_NOTICE("It is set to deploy [mode ? "doors" : "walls"]"))

/obj/item/inflatable_dispenser/attack_self(mob/user)
	if(!deploying)
		mode = !mode
		to_chat(user, SPAN_NOTICE("You set \the [src] to deploy [mode ? "doors" : "walls"]."))
	else
		to_chat(user, SPAN_WARNING("You can't switch modes while deploying a [mode ? "door" : "wall"]!"))

/obj/item/inflatable_dispenser/afterattack(var/atom/A, var/mob/user)
	..(A, user)
	if(!user)
		return
	if(!user.Adjacent(A))
		to_chat(user, SPAN_WARNING("You can't reach!"))
		return
	if(istype(A, /turf))
		try_deploy_inflatable(A, user)
	if(istype(A, /obj/item/inflatable) || istype(A, /obj/structure/inflatable))
		pick_up(A, user)

/obj/item/inflatable_dispenser/proc/try_deploy_inflatable(var/turf/T, var/mob/living/user)
	if(deploying)
		return

	var/newtype
	if(mode) // Door deployment
		if(!stored_doors)
			to_chat(user, SPAN_WARNING("\The [src] is out of doors!"))
			return
		if(T && istype(T))
			newtype = /obj/structure/inflatable/door

	else // Wall deployment
		if(!stored_walls)
			to_chat(user, SPAN_WARNING("\The [src] is out of walls!"))
			return

		if(T && istype(T))
			newtype = /obj/structure/inflatable/wall

	deploying = 1
	user.visible_message("<b>[user]</b> starts deploying an inflatable [mode ? "door" : "wall"].", SPAN_NOTICE("You start deploying an inflatable [mode ? "door" : "wall"]!"))
	playsound(T, 'sound/items/zip.ogg', 75, TRUE)
	if(do_after(user, 30, needhand = FALSE))
		new newtype(T)
		if(mode)
			stored_doors--
		else
			stored_walls--
	deploying = FALSE

/obj/item/inflatable_dispenser/proc/pick_up(var/obj/A, var/mob/living/user)
	if(istype(A, /obj/structure/inflatable))
		if(istype(A, /obj/structure/inflatable/wall))
			if(stored_walls >= max_walls)
				to_chat(user, SPAN_WARNING("\The [src] is full."))
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(user, SPAN_WARNING("\The [src] is full."))
				return
			stored_doors++
			qdel(A)
		playsound(get_turf(src), 'sound/machines/hiss.ogg', 75, TRUE)
		visible_message("<b>[user]</b> deflates \the [A] with \the [src].", SPAN_NOTICE("You deinflate \the [A] with \the [src]."))
		return
	else if(istype(A, /obj/item/inflatable))
		if(istype(A, /obj/item/inflatable/wall))
			if(stored_walls >= max_walls)
				to_chat(user, SPAN_WARNING("\The [src] is full."))
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(usr, SPAN_WARNING("\The [src] is full!"))
				return
			stored_doors++
			qdel(A)
		visible_message("<b>[user]</b> picks up \the [A] with \the [src].", SPAN_NOTICE("You pick up \the [A] with \the [src]."))
		return

	to_chat(user, SPAN_WARNING("You fail to pick up \the [A] with \the [src]."))
	return

/obj/item/inflatable_dispenser/borg
	max_walls = 5
	max_doors = 3

#undef MODE_WALL
#undef MODE_DOOR
