//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib(anim="gibbed-m",do_gibs)
	death(1)
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	update_canmove()
	dead_mob_list -= src

	var/atom/movable/overlay/animation = null
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)

	if(do_gibs)
		gibs(loc, viruses, dna, get_gibs_type())

	QDEL_IN(animation, 15)
	QDEL_IN(src, 15)

/mob/proc/get_gibs_type()
	return /obj/effect/gibspawner/generic

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(anim="dust-m",remains=/obj/effect/decal/cleanable/ash, iconfile = 'icons/mob/mob.dmi')
	death(1)
	if (istype(loc, /obj/item/holder))
		var/obj/item/holder/H = loc
		H.release_mob()
	var/atom/movable/overlay/animation = null
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101

	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = iconfile
	animation.master = src

	flick(anim, animation)
	new remains(loc)

	dead_mob_list -= src

	QDEL_IN(animation, 15)
	QDEL_IN(src, 15)

/mob/proc/death(gibbed,deathmessage="seizes up and falls limp...", messagerange = world.view)

	if(stat == DEAD)
		return 0

	facing_dir = null

	if(!gibbed && deathmessage != "no message") // This is gross, but reliable. Only brains use it.
		src.visible_message("<b>\The [src.name]</b> [deathmessage]", range = messagerange)

	exit_vr()

	stat = DEAD

	update_canmove()

	dizziness = 0
	jitteriness = 0

	layer = MOB_LAYER

	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	drop_r_hand()
	drop_l_hand()

	if(healths)
		healths.overlays.Cut() // This is specific to humans but the relevant code is here; shouldn't mess with other mobs.
		if("health7" in icon_states(healths.icon))
			healths.icon_state = "health7"

	timeofdeath = world.time
	set_respawn_time()
	if(mind)
		mind.store_memory("Time of death: [worldtime2text()]", 0)
	living_mob_list -= src
	dead_mob_list |= src

	update_icon()

	if(SSticker.mode)
		SSticker.mode.check_win()

	return 1

/mob/proc/set_respawn_time()
	return

/mob/proc/exit_vr()
	// If we have a remotely controlled mob, we come back to our body to die properly
	if(vr_mob)
		vr_mob.body_return()
	// Alternatively, if we are the remotely controlled mob, just kick our controller out
	if(old_mob)
		body_return()
