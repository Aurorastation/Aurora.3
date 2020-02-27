
/**********************Ore box**************************/

/obj/structure/ore_box
	name = "ore box"
	desc = "A heavy box used for storing ore."
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	density = TRUE
	var/last_update = 0
	var/list/stored_ore = list()

/obj/structure/ore_box/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ore))
		user.remove_from_mob(W)
		src.contents += W
	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		S.hide_from(user)
		for(var/obj/item/ore/O in S.contents)
			S.remove_from_storage_deferred(O, src, user) //This will move the item to this item's contents
			CHECK_TICK

		S.post_remove_from_storage_deferred(loc, user)
		to_chat(user, span("notice", "You empty the satchel into the box."))

	update_ore_count()
	return

/obj/structure/ore_box/proc/update_ore_count()
	stored_ore = list()
	for(var/obj/item/ore/O in contents)
		if(stored_ore[O.name])
			stored_ore[O.name]++
		else
			stored_ore[O.name] = 1

/obj/structure/ore_box/examine(mob/user)
	..()
	// Borgs can now check contents too.
	if((!istype(user, /mob/living/carbon/human)) && (!istype(user, /mob/living/silicon/robot)))
		return
	if(!Adjacent(user)) //Can only check the contents of ore boxes if you can physically reach them.
		return

	add_fingerprint(user)

	if(!LAZYLEN(contents))
		to_chat(user, SPAN_NOTICE("It is empty."))
		return

	if(world.time > last_update + 10)
		update_ore_count()
		last_update = world.time

	to_chat(user, SPAN_NOTICE("It holds:"))
	for(var/ore in stored_ore)
		to_chat(user, SPAN_NOTICE("- [stored_ore[ore]] [ore]"))
	return

/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human)) //Only living, intelligent creatures with hands can empty ore boxes.
		to_chat(usr, SPAN_WARNING("You are physically incapable of emptying \the [src]."))
		return

	if(use_check_and_message(usr))
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		to_chat(usr, SPAN_NOTICE("You cannot reach \the [src]."))
		return

	add_fingerprint(usr)

	if(!LAZYLEN(contents))
		to_chat(usr, SPAN_WARNING("\The [src] is empty."))
		return

	for(var/obj/item/ore/O in contents)
		contents -= O
		O.forceMove(get_turf(src))
	to_chat(usr, SPAN_NOTICE("You empty \the [src]."))

	return

/obj/structure/ore_box/ex_act(severity)
	if(severity == 1.0 || (severity < 3.0 && prob(50)))
		for(var/obj/item/ore/O in contents)
			O.forceMove(src.loc)
			O.ex_act(severity++)
			CHECK_TICK
		qdel(src)
		return