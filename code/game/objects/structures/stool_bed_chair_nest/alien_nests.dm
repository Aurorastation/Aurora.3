//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.
#define NEST_RESIST_TIME 1200

/obj/structure/bed/nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "nest"
	var/health = 100

/obj/structure/bed/nest/update_icon()
	return

/obj/structure/bed/nest/user_unbuckle_mob(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"<span class='notice'>[user.name] pulls [buckled_mob.name] free from the sticky nest!</span>",\
					"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
					"<span class='notice'>You hear squelching...</span>")
				buckled_mob.pixel_y = 0
				buckled_mob.old_y = 0
				unbuckle_mob()
			else
				if(world.time <= buckled_mob.last_special+NEST_RESIST_TIME)
					return
				buckled_mob.last_special = world.time
				buckled_mob.visible_message(\
					"<span class='warning'>[buckled_mob.name] struggles to break free of the gelatinous resin...</span>",\
					"<span class='warning'>You struggle to break free from the gelatinous resin...</span>",\
					"<span class='notice'>You hear squelching...</span>")
				spawn(NEST_RESIST_TIME)
					if(user && buckled_mob && user.buckled == src)
						buckled_mob.last_special = world.time
						buckled_mob.pixel_y = 0
						buckled_mob.old_y = 0
						unbuckle_mob()
			src.add_fingerprint(user)
	return

/obj/structure/bed/nest/attackby(obj/item/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	for(var/mob/M in viewers(src, 7))
		M.show_message("<span class='warning'>[user] hits [src] with [W]!</span>", 1)
	healthcheck()

/obj/structure/bed/nest/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return
