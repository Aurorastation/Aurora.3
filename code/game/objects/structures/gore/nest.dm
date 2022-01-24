#define NEST_RESIST_TIME 1200

/obj/structure/bed/nest
	name = "gore nest"
	desc = "It's a gruesome pile of thick, sticky flesh shaped like a nest."
	icon = 'icons/obj/gore_structures.dmi'
	icon_state = "nest"
	var/destroy_message = "THE STRUCTURE collapses in on itself!"
	var/maxHealth = 100
	var/health = 100

/obj/structure/bed/nest/Initialize(mapload, new_material, new_padding_material)
	. = ..()
	health = maxHealth

/obj/structure/bed/nest/examine(mob/user)
	if(..(user, 2))
		var/health_div = health / maxHealth
		if(health_div >= 0.9)
			to_chat(user, SPAN_NOTICE("\The [src] appears completely intact."))
		else if(health_div >= 0.7)
			to_chat(user, SPAN_NOTICE("\The [src] is starting to tear somewhat."))
		else if(health_div >= 0.4)
			to_chat(user, SPAN_WARNING("\The [src] is starting to fall apart."))
		else
			to_chat(user, SPAN_WARNING("\The [src] is barely holding itself together!"))

/obj/structure/bed/nest/update_icon()
	return

/obj/structure/bed/nest/user_unbuckle(mob/user)
	if(buckled?.buckled_to == src)
		add_fingerprint(user)
		if(buckled != user)
			buckled.visible_message("<b>[user]</b> pulls [buckled] free from the sticky flesh!", SPAN_NOTICE("[user] pulls you free from the gelatinous flesh."), SPAN_WARNING("You hear squelching..."))
			unbuckle_buckled_mob(buckled)
		else if(istype(buckled, /mob/living))
			var/mob/living/M = buckled
			if(world.time <= M.last_special + NEST_RESIST_TIME)
				return
			M.last_special = world.time
			M.visible_message(SPAN_WARNING("[M] starts struggling to break free of the sticky flesh..."), SPAN_WARNING("You struggle to break free from the gelatinous flesh..."), SPAN_WARNING("You hear squelching..."))
			if(do_after(M, NEST_RESIST_TIME, TRUE))
				unbuckle_buckled_mob(M)

/obj/structure/bed/nest/proc/unbuckle_buckled_mob(var/mob/buck)
	if(buckled == buck && buck.buckled_to == src)
		buck.pixel_y = 0
		buck.old_y = 0
		unbuckle()

/obj/structure/bed/nest/attackby(obj/item/W, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src, W)
	var/force_damage = W.force
	if(W.damtype == BURN)
		force_damage *= 1.25
	health -= force_damage
	playsound(loc, 'sound/effects/attackblob.ogg', 80, TRUE)
	healthcheck()

/obj/structure/bed/nest/proc/healthcheck()
	if(health <= 0)
		var/final_message = replacetext(destroy_message, "THE STRUCTURE", "\The [src]")
		visible_message(SPAN_WARNING(final_message))
		qdel(src)