/obj/item/device/memorywiper
	name = "portable memory wiper"
	desc = "Inset into a sturdy pelican case, this computer holds the software and wiring necessary to wipe and factory reset any IPC."
	icon = 'icons/obj/memorywiper.dmi'
	icon_state = "portable_memorywiper"
	item_state = "portable_memorywiper"
	anchored = FALSE
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'
	var/mob/living/carbon/human/attached = null
	var/wiping = FALSE
	var/datum/progressbar/wipe_bar
	var/wipe_start_time = 0

/obj/item/device/memorywiper/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "ALT-click the device while it's set down on a surface to open or close it."
	. += "Left-click on it while it is open to operate it."

/obj/item/device/memorywiper/Destroy()
	if(attached)
		attached = null
	wiping = FALSE
	return ..()

/obj/item/device/memorywiper/AltClick()
	if(use_check(usr))
		return
	if(!isturf(loc))
		to_chat(usr, SPAN_NOTICE("\The [src] has to be on a stable surface first!"))
		return
	anchored = !anchored
	if(attached)
		unplug()
	playsound(src.loc, 'sound/items/storage/briefcase.ogg', 50, 1, -5)
	update_icon()

/obj/item/device/memorywiper/update_icon()
	ClearOverlays()
	if(anchored)
		icon_state = "[initial(icon_state)]_opened"
		if(attached)
			AddOverlays("wireout")
		if(wiping)
			AddOverlays("screen")
	else
		icon_state = initial(icon_state)

/obj/item/device/memorywiper/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	..()
	if(use_check_and_message(usr))
		return
	if(in_range(src, usr) && isipc(over) && in_range(over, src))
		if(attached)
			if(attached == usr)
				to_chat(usr, "You unplug \the [src] from your maintenace port.")
			else
				visible_message("[usr] unplugs \the [src] from [attached]'s maintenance port.")
			unplug()
			return
		else
			if(over == usr)
				plug(over)
				to_chat(usr, "You plug \the [src] into your maintenace port.")
			else
				visible_message("<b>[usr]</b> begins hunting for the maintenance port on \the [over]'s chassis.") // The age old question of "where do I put it in!?"
				if(do_after(usr, 5 SECONDS))
					plug(over)
					visible_message("[usr] plugs \the [src] into \the [attached]'s maintenance port.")

/obj/item/device/memorywiper/attack_hand(user as mob)
	if(attached)
		to_chat(user, SPAN_NOTICE("You initialize the memory wipe protocols. This procedure will take approximately 30 seconds."))
		to_chat(attached, SPAN_WARNING("The computer hums to life and you feel your memories bleed away into nothingness."))
		playsound(src.loc, /singleton/sound_category/keyboard_sound, 30, TRUE)
		wiping = TRUE
		update_icon()
		if(wipe_bar)
			to_chat(src, SPAN_WARNING("The memory wipe protocol is already in progress!"))
			return

		var/wipe_time = rand(20 SECONDS, 40 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(memorywipe)), wipe_time)
		wipe_bar = new /datum/progressbar(src, wipe_time, attached)
		wipe_start_time = world.time
		wipe_bar.update(0)
	if(anchored)
		return
	if(..())
		return

/obj/item/device/memorywiper/proc/memorywipe()
	if(attached && wiping)
		visible_message(SPAN_NOTICE("\The [src] pings, \"Memory wipe protocols complete.\""))
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
		to_chat(attached, "<b>The process finishes, leaving you with nothing beyond your base programming and databases.</b>")
		wiping = FALSE
		switch(alert(attached, "You've lost your memories! You can choose to ghost, or stay and be manipulated for someone else's ulterior motives...", "Memory Loss", "Ghost", "Stay"))
			if("Ghost")
				attached.ghostize(0)

/obj/item/device/memorywiper/process()
	if(attached)
		if(!attached.Adjacent(src))
			attached.visible_message(SPAN_WARNING("The cable rips out of [attached]'s maintenace port."), SPAN_DANGER("\The [src]'s cable rips out of your maintenace port."))
			unplug()
			return

/obj/item/device/memorywiper/proc/unplug()
	if(wiping)
		visible_message(SPAN_WARNING("\The [src]'s screen flashes, \"ERROR : IPC NOT FOUND, TERMINATING PROTOCOL.\""))
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
		wiping = FALSE
	playsound(src.loc, 'sound/machines/id_swipe.ogg', 25, 1)
	attached = null
	STOP_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/device/memorywiper/proc/plug(over_object)
	playsound(src.loc, 'sound/weapons/click.ogg', 25, 1)
	attached = over_object
	START_PROCESSING(SSprocessing, src)
	update_icon()
