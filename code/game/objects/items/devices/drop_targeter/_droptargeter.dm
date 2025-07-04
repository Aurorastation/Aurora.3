/obj/item/device/orbital_dropper
	name = "laser targeting dropper"
	desc = "A device used to paint a target, which will then promptly orbitally drop the requested items."
	icon = 'icons/obj/item/device/binoculars.dmi'
	icon_state = "binoculars"
	item_state = "binoculars"
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	var/has_dropped = 0 // Counter of how many times the targeter has been used
	var/drop_amount = 2 // How many times can this item be used?

	var/tileoffset = 8 // How far can you zoom with these binocular targeters
	var/viewsize = 7 // How large the view is when you zoom

	var/paint_distance = 14 // From how far away can you paint a target?

	var/does_explosion = TRUE
	var/emagged = FALSE // If emagged, things can be dropped in on station areas

	var/drop_message_language = LANGUAGE_TCB
	var/drop_message = "Orbital package inbound, clear the targetted area immediately!"
	var/drop_message_emagged = "O*b$ital p&ck@ge in#)und, c-c-c-!"
	var/announcer_name = "Operations Long Range Package Delivery System"
	var/announcer_frequency = SUP_FREQ // If not emagged, will announce to this channel. If emagged, will always announce on the common channel.

	var/datum/map_template/map

/obj/item/device/orbital_dropper/attack_self(mob/user)
	zoom(user, tileoffset, viewsize)

/obj/item/device/orbital_dropper/attack(mob/living/target_mob, mob/living/user, target_zone)
	laser_act(target_mob, user)

/obj/item/device/orbital_dropper/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)	//we're placing the targetter on a table or in backpack
		return
	laser_act(target, user)

/obj/item/device/orbital_dropper/proc/laser_act(var/atom/target, var/mob/living/user)
	if(has_dropped >= drop_amount)
		to_chat(user, SPAN_WARNING("You can't use this device again!"))
		return

	var/turf/targloc = get_turf(target)
	if(!emagged)
		for(var/turf/t in block(locate(targloc.x+3,targloc.y+3,targloc.z), locate(targloc.x-3,targloc.y-3,targloc.z)))
			if (is_station_level(targloc.z))
				to_chat(user, SPAN_WARNING("You can't request this orbital drop on the ship!"))
				return
			if (!isfloor(targloc))
				to_chat(user, SPAN_WARNING("You cannot request this on unstable flooring!"))
				return
	if(!(user in (viewers(paint_distance, target))) )
		to_chat(user, SPAN_WARNING("You can't paint the target that far away!"))
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return
	add_fingerprint(user)

	//laser pointer image
	icon_state = "binoculars_high"
	var/list/showto = list()
	for(var/mob/M in viewers(targloc))
		if(M.client)
			showto += M.client
	var/image/I = image('icons/obj/projectiles.dmi', targloc, "red_laser", 10)
	I.pixel_x = target.pixel_x + rand(-5,5)
	I.pixel_y = target.pixel_y + rand(-5,5)

	to_chat(user, SPAN_NOTICE("You paint the target at [target]."))

	var/datum/language/language = GLOB.all_languages[drop_message_language]

	if(!istype(GLOB.global_announcer.announcer))
		GLOB.global_announcer.announcer = new()
	GLOB.global_announcer.announcer.PrepareBroadcast(announcer_name, language, announcer_name)

	var/turf/current_turf = get_turf(src)
	var/datum/signal/subspace/vocal/signal = new(src, emagged ? PUB_FREQ : announcer_frequency, WEAKREF(GLOB.global_announcer.announcer), language, emagged ? drop_message_emagged : drop_message, "says")
	signal.data["compression"] = 0
	signal.transmission_method = TRANSMISSION_SUBSPACE
	signal.levels = GetConnectedZlevels(current_turf.z)
	signal.broadcast()

	GLOB.global_announcer.announcer.ResetAfterBroadcast()

	has_dropped++
	if(does_explosion)
		addtimer(CALLBACK(GLOBAL_PROC, /proc/explosion, targloc, 1, 2, 4, 6), 100) //YEEHAW
	addtimer(CALLBACK(src, PROC_REF(orbital_drop), targloc, user), 105)

	flick_overlay(I, showto, 20) //2 seconds of the red dot appearing
	icon_state = "binoculars"

/obj/item/device/orbital_dropper/proc/orbital_drop(var/turf/target, var/user)
	if(!map)
		return
	log_and_message_admins("[key_name_admin(user)] has used a [src] at <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>.")
	map.load(target, TRUE) //Target must be the center!


/obj/item/device/orbital_dropper/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, SPAN_DANGER("You override \the [src]'s area safety checks!"))
		return TRUE
	else
		to_chat(user, SPAN_DANGER("\The [src]'s area safety checks have already been disabled."))
