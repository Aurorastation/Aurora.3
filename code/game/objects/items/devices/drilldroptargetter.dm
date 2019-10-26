/obj/item/device/drill_dropper
	name = "laser targeting dropper"
	desc = "This drill literally pierces the heavens."
	icon = 'icons/obj/device.dmi'
	icon_state = "drillpointer"
	item_state = "binoculars"
	slot_flags = SLOT_BELT
	w_class = 2
	var/has_dropped = 0
	var/tileoffset = 8
	var/viewsize = 7
	var/emagged = FALSE

/obj/item/device/drill_dropper/attack_self(mob/user)
	zoom(user,tileoffset,viewsize)

/obj/item/device/drill_dropper/attack(mob/living/M, mob/user)
	laser_act(M, user)

/obj/item/device/drill_dropper/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)	//we're placing the object on a table or in backpack
		return
	laser_act(target, user)

/obj/item/device/drill_dropper/proc/laser_act(var/atom/target, var/mob/living/user)

	if(has_dropped >= 2)
		to_chat(user, "<span class='warning'>You can't use this device again!</span>")
		return

	var/turf/targloc = get_turf(target)
	if(!emagged)
		for(var/turf/t in block(locate(targloc.x+2,targloc.y+2,targloc.z),locate(targloc.x-2,targloc.y-2,targloc.z)))
			if (!istype(t.loc, /area/mine))
				to_chat(user, "<span class='warning'>You can't do this so close to the station, point the laser further into the mine!</span>")
				return
			if (!isfloor(targloc))
				to_chat(user, "<span class='warning'>You cannot request a drill on unstable flooring!</span>")
				return
		for(var/turf/t2 in block(locate(targloc.x+2,targloc.y+2,targloc.z+1),locate(targloc.x-2,targloc.y-2,targloc.z+1)))
			if (!istype(t2.loc, /area/mine))
				to_chat(user, "<span class='warning'>You can't do this beneath the station, point the laser further away from it!</span>")
				return
	if(!(user in (viewers(14,target))) )
		to_chat(user, "<span class='warning'>You can't paint the target that far away!</span>")
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return
	add_fingerprint(user)

	//laser pointer image
	icon_state = "drillpointer_on"
	var/list/showto = list()
	for(var/mob/M in viewers(targloc))
		if(M.client)
			showto += M.client
	var/image/I = image('icons/obj/projectiles.dmi',targloc,"red_laser",10)
	I.pixel_x = target.pixel_x + rand(-5,5)
	I.pixel_y = target.pixel_y + rand(-5,5)

	to_chat(user, "<span class='notice'>You paint the target at [target].</span>")

	var/obj/item/device/radio/intercom/announcer = new /obj/item/device/radio/intercom(null)
	announcer.config(list("Supply" = 0, "Common" = 0))
	if(announcer)
		if(!emagged)
			announcer.autosay("Stand by for drillfall, ETA ten seconds, clear the targetted area.", "Mining Requests Console", "Supply")
		else
			announcer.autosay("St%n^ b* for dr$llfa#l, ETA t@n s*c%&ds, RUN.", "Mining Requests Console", "Common")

	has_dropped++
	addtimer(CALLBACK(GLOBAL_PROC, /proc/explosion, targloc, 1, 2, 4, 6), 100) //YEEHAW
	addtimer(CALLBACK(src, .proc/drill_drop, targloc), 105)

	flick_overlay(I, showto, 20) //2 seconds of the red dot appearing
	icon_state = "drillpointer"

/obj/item/device/drill_dropper/proc/drill_drop(var/turf/target)

	var/turf/lefttarget = locate(target.x-1, target.y, target.z)
	var/turf/righttarget = locate(target.x+1, target.y, target.z)

	var/turf/aboveturfleft = GetAbove(lefttarget)
	var/turf/aboveturf = GetAbove(target)
	var/turf/aboveturfright = GetAbove(righttarget)

	var/has_crashed = FALSE
	
	if(aboveturf)
		if(!aboveturf.is_hole)
			aboveturf.ChangeTurf(/turf/space)
			target.visible_message("<span class='danger'>The drill parts crash through the roof!</span>")
			has_crashed = TRUE
	if(aboveturfleft)
		if(!aboveturfleft.is_hole)
			aboveturfleft.ChangeTurf(/turf/space)
			if(!has_crashed)
				target.visible_message("<span class='danger'>The drill parts crash through the roof!</span>")
				has_crashed = TRUE
	if(aboveturfright)
		if(!aboveturfright.is_hole)
			aboveturfright.ChangeTurf(/turf/space)
			if(!has_crashed)
				target.visible_message("<span class='danger'>The drill parts crash through the roof!</span>")
				has_crashed = TRUE

	new /obj/machinery/mining/brace(lefttarget)
	new /obj/machinery/mining/drill(target)
	new /obj/machinery/mining/brace(righttarget)

/obj/item/device/drill_dropper/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, "<span class='danger'>You override \the [src]'s area safety checks!</span>")
		return 1
	else
		to_chat(user, "<span class='danger'>\The [src]'s area safety checks have already been disabled.</span>")
