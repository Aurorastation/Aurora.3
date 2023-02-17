// Target stakes for the firing range.
/obj/structure/target_stake
	name = "target stake"
	desc = "A thin platform with negatively-magnetized wheels."
	icon = 'icons/obj/target_stake.dmi'
	icon_state = "target_stake"
	density = TRUE
	w_class = ITEMSIZE_IMMENSE
	build_amt = 10
	var/obj/item/target/pinned_target

/obj/structure/target_stake/Initialize(mapload)
	. = ..()
	material = SSmaterials.get_material_by_name(MATERIAL_STEEL)

/obj/structure/target_stake/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/target))
		if(pinned_target)
			to_chat(user, SPAN_WARNING("\The [src] already has a target."))
			return
		if(user.unEquip(W, FALSE, get_turf(src)))
			to_chat(user, SPAN_NOTICE("You slide \the [W] into the stake."))
			set_target(W)
		return
	if(W.iswrench())
		if(pinned_target)
			to_chat(user, SPAN_WARNING("You cannot dismantle \the [src] while it has a target attached."))
			return
		dismantle()

/obj/structure/target_stake/attack_hand(var/mob/user)
	. = ..()
	if(pinned_target && ishuman(user))
		var/obj/item/target/T = pinned_target
		to_chat(user, SPAN_NOTICE("You take \the [T] out of the stake."))
		set_target(null)
		user.put_in_hands(T)

/obj/structure/target_stake/proc/set_target(var/obj/item/target/T)
	if(T)
		density = FALSE
		T.density = TRUE
		T.pixel_x = 0
		T.pixel_y = 0
		T.layer = ABOVE_OBJ_LAYER
		moved_event.register(T, src, TYPE_PROC_REF(/atom/movable, move_to_turf))
		moved_event.register(src, T, TYPE_PROC_REF(/atom/movable, move_to_turf))
		T.stake = src
		pinned_target = T
	else
		density = TRUE
		if(pinned_target)
			pinned_target.density = FALSE
			pinned_target.layer = OBJ_LAYER
			moved_event.unregister(pinned_target, src)
			moved_event.unregister(src, pinned_target)
			pinned_target.stake = null
		pinned_target = null

/obj/structure/target_stake/Destroy()
	set_target(null)
	return ..()