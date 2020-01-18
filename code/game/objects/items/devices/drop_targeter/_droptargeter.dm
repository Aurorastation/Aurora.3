/obj/item/device/orbital_dropper
	name = "laser targeting dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items."
	icon = 'icons/obj/device.dmi'
	icon_state = "drillpointer"
	item_state = "binoculars"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	var/has_dropped = 0 // Counter of how many times the targeter has been used
	var/drop_amount = 2 // How many times can this item be used?

	var/tileoffset = 8 // How far can you zoom with these binocular targeters
	var/viewsize = 7 // How large the view is when you zoom

	var/paint_distance = 14 // From how far away can you paint a target?

	var/emagged = FALSE // If emagged, things can be dropped in on station areas

	var/drop_message = "Orbital package inbound, clear the targetted area immediately!"
	var/drop_message_emagged = "O*b$ital p&ck@ge in#)und, c-c-c-!"
	var/announcer_name = "Mining Requests Console"
	var/announcer_channel = "Supply" // If not emagged, will announce to this channel. If emagged, will always announce on the common channel.

	var/datum/map_template/map

/obj/item/device/orbital_dropper/attack_self(mob/user)
	zoom(user, tileoffset, viewsize)

/obj/item/device/orbital_dropper/attack(mob/living/M, mob/user)
	laser_act(M, user)

/obj/item/device/orbital_dropper/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)	//we're placing the targetter on a table or in backpack
		return
	laser_act(target, user)

/obj/item/device/orbital_dropper/proc/laser_act(var/atom/target, var/mob/living/user)
	if(has_dropped >= drop_amount)
		to_chat(user, span("warning", "You can't use this device again!"))
		return

	var/turf/targloc = get_turf(target)
	if(!emagged)
		for(var/turf/t in block(locate(targloc.x+3,targloc.y+3,targloc.z), locate(targloc.x-3,targloc.y-3,targloc.z)))
			if (!istype(t.loc, /area/mine))
				to_chat(user, span("warning", "You can't do this so close to the station, point the laser further into the mine!"))
				return
			if (!isfloor(targloc))
				to_chat(user, span("warning", "You cannot request this on unstable flooring!"))
				return
	if(!(user in (viewers(paint_distance, target))) )
		to_chat(user, span("warning", "You can't paint the target that far away!"))
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, span("warning", "You don't have the dexterity to do this!"))
		return
	add_fingerprint(user)

	//laser pointer image
	icon_state = "drillpointer_on"
	var/list/showto = list()
	for(var/mob/M in viewers(targloc))
		if(M.client)
			showto += M.client
	var/image/I = image('icons/obj/projectiles.dmi', targloc, "red_laser", 10)
	I.pixel_x = target.pixel_x + rand(-5,5)
	I.pixel_y = target.pixel_y + rand(-5,5)

	to_chat(user, span("notice", "You paint the target at [target]."))

	var/obj/item/device/radio/intercom/announcer = new /obj/item/device/radio/intercom(null)
	announcer.config(list("Common" = FALSE, "Entertainment" = FALSE, "Response Team" = FALSE, "Science" = FALSE, "Command" = FALSE, "Medical" = FALSE, "Engineering" = FALSE, "Security" = FALSE, "Supply" = FALSE, "Service" = FALSE, "Mercenary" = FALSE, "Raider" = FALSE, "Ninja" = FALSE, "AI Private" = FALSE))
	if(announcer)
		if(!emagged)
			announcer.autosay(drop_message, announcer_name, announcer_channel)
		else
			announcer.autosay(drop_message_emagged, announcer_name, "Common")

	has_dropped++
	addtimer(CALLBACK(GLOBAL_PROC, /proc/explosion, targloc, 1, 2, 4, 6), 100) //YEEHAW
	addtimer(CALLBACK(src, .proc/orbital_drop, targloc, user), 105)

	flick_overlay(I, showto, 20) //2 seconds of the red dot appearing
	icon_state = "drillpointer"

/obj/item/device/orbital_dropper/proc/orbital_drop(var/turf/target, var/user)
	if(!map)
		return
	log_and_message_admins("[key_name_admin(src)] has used a [src] at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>.")
	map.load(target, TRUE) //Target must be the center!
	

/obj/item/device/orbital_dropper/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, span("danger", "You override \the [src]'s area safety checks!"))
		return TRUE
	else
		to_chat(user, span("danger", "\The [src]'s area safety checks have already been disabled."))