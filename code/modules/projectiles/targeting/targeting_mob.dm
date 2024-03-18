/mob/living
	///The obj to overlay on the aim target
	var/obj/aiming_overlay/aiming

	///A list of mobs the target is being aimed at by
	var/list/aimed_at_by

/mob/verb/toggle_gun_mode()
	set name = "Toggle Gun Mode"
	set desc = "Begin or stop aiming."
	set category = "IC"

	if(isliving(src))
		var/mob/living/M = src
		if(!M.aiming)
			M.aiming = new(src)
		M.aiming.toggle_active()
	else
		FEEDBACK_FAILURE(src, "This verb may only be used by living mobs, sorry.")
	return

/mob/living/proc/stop_aiming(obj/item/thing, no_message = FALSE)
	if(!aiming)
		aiming = new(src)
	if(thing && aiming.aiming_with != thing)
		return
	aiming.cancel_aiming(no_message)

/mob/living/death(gibbed,deathmessage="seizes up and falls limp...")
	. = ..()

	SEND_SIGNAL(src, COMSIG_LIVING_DEATH, gibbed)

	if(.)
		stop_aiming(no_message=1)

/mob/living/update_canmove()
	..()
	if(lying)
		stop_aiming(no_message=TRUE)

/mob/living/Weaken(amount)
	stop_aiming(no_message=TRUE)
	..()

/mob/living/Destroy()
	if(aiming)
		qdel(aiming)
		aiming = null

	QDEL_LIST(aimed_at_by)

	if(vr_mob)
		vr_mob = null
	if(old_mob)
		old_mob = null
	return ..()

