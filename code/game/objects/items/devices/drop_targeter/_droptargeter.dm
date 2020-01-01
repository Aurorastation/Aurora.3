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

	// A list of things to spawn, will begin from first entry and work way around
	//7  8  9
	//6  1  2
	//5  4  3
	var/list/centre_items = list()
	var/list/east_items = list()
	var/list/south_east_items = list()
	var/list/south_items = list()
	var/list/south_west_items = list()
	var/list/west_items = list()
	var/list/north_west_items = list()
	var/list/north_items = list()
	var/list/north_east_items = list()

	var/turf/drop_turf // If you want to turn the area the drop drops in, to a certain turf. I recommend using airless tiles, otherwise items will be strewn about

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
		for(var/turf/t in block(locate(targloc.x+2,targloc.y+2,targloc.z), locate(targloc.x-2,targloc.y-2,targloc.z)))
			if (!istype(t.loc, /area/mine))
				to_chat(user, span("warning", "You can't do this so close to the station, point the laser further into the mine!"))
				return
			if (!isfloor(targloc))
				to_chat(user, span("warning", "You cannot request a drill on unstable flooring!"))
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
	addtimer(CALLBACK(src, .proc/drill_drop, targloc), 105)

	flick_overlay(I, showto, 20) //2 seconds of the red dot appearing
	icon_state = "drillpointer"

/obj/item/device/orbital_dropper/proc/drill_drop(var/turf/target)
	var/turf/east_turf
	var/turf/south_east_turf
	var/turf/south_turf
	var/turf/south_west_turf
	var/turf/west_turf
	var/turf/north_west_turf
	var/turf/north_turf
	var/turf/north_east_turf

	if(length(centre_items))
		spawn_items(centre_items, target)

	if(length(east_items))
		east_turf = locate(target.x+1, target.y, target.z)
		spawn_items(east_items, east_turf)

	if(length(south_east_items))
		south_east_turf = locate(target.x+1, target.y-1, target.z)
		spawn_items(south_east_items, south_east_turf)

	if(length(south_items))
		south_turf = locate(target.x, target.y-1, target.z)
		spawn_items(south_items, south_turf)

	if(length(south_west_items))
		south_west_turf = locate(target.x-1, target.y-1, target.z)
		spawn_items(south_west_items, south_west_turf)

	if(length(west_items))
		west_turf = locate(target.x-1, target.y, target.z)
		spawn_items(west_items, west_turf)

	if(length(north_west_items))
		north_west_turf = locate(target.x-1, target.y+1, target.z)
		spawn_items(north_west_items, north_west_turf)

	if(length(north_items))
		north_turf = locate(target.x, target.y+1, target.z)
		spawn_items(north_items, north_turf)

	if(length(north_east_items))
		north_east_turf = locate(target.x+1, target.y+1, target.z)
		spawn_items(north_east_items, north_east_turf)

/obj/item/device/orbital_dropper/proc/spawn_items(var/list/items, var/turf/T)
	for(var/spawn_item in items)
		new spawn_item(T)
	if(drop_turf)
		T.ChangeTurf(drop_turf)

/obj/item/device/orbital_dropper/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, span("danger", "You override \the [src]'s area safety checks!"))
		return TRUE
	else
		to_chat(user, span("danger", "\The [src]'s area safety checks have already been disabled."))