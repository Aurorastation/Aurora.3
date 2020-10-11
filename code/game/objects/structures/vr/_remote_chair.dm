/obj/structure/bed/chair/remote
	name = "virtual reality centre"
	desc = "A comfortable chair with full audio-visual transposition centres."
	icon_state = "shuttlechair_down"
	var/portable_type
	can_dismantle = FALSE
	var/remote_network // Which network does this remote control belong to?

/obj/structure/bed/chair/remote/Initialize()
	. = ..()
	if(portable_type)
		name = "portable [name]"

/obj/structure/bed/chair/remote/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/bed/chair/remote/examine(mob/user)
	..()
	if(portable_type)
		to_chat(user, FONT_SMALL(SPAN_NOTICE("Can be packed up by using a wrench on it.")))

/obj/structure/bed/chair/remote/update_icon()
	return

/obj/structure/bed/chair/remote/attackby(obj/item/W, mob/user)
	if(portable_type && W.iswrench())
		user.visible_message(SPAN_NOTICE("\The [user] starts dismantling \the [src]..."), SPAN_NOTICE("You start dismantling \the [src]..."))
		if(do_after(user, 20 SECONDS, TRUE, src))
			user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
			var/obj/kit = new portable_type(get_turf(src))
			user.put_in_hands(kit)
			qdel(src)
		return
	..()

/obj/structure/bed/chair/remote/user_buckle_mob(mob/user)
	..()
	var/area/A = get_area(src)
	if(!A.powered(EQUIP))
		to_chat(user, SPAN_WARNING("\The [src] is not powered."))
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.old_mob)
			to_chat(H, SPAN_WARNING("The chair rejects you! You cannot recursively control bodies."))
			return
	add_overlay(image('icons/obj/furniture.dmi', src, "vr_helmet", MOB_LAYER + 1))
	START_PROCESSING(SSprocessing, src)


/obj/structure/bed/chair/remote/process()
	..()
	if(buckled_mob)
		var/area/A = get_area(src)
		if(!A.powered(EQUIP))
			user_unbuckle_mob(buckled_mob)

// Return to our body in the unfortunate event that we get unbuckled while plugged in
/obj/structure/bed/chair/remote/user_unbuckle_mob(mob/user)
	if(buckled_mob)
		var/mob/M = buckled_mob
		if(istype(M) && M.vr_mob)
			M.vr_mob.body_return()
		cut_overlays()
		STOP_PROCESSING(SSprocessing, src)
	..()