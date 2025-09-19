/obj/item/pinpointer
	name = "pinpointer"
	icon = 'icons/obj/item/pinpointer.dmi'
	icon_state = "pinoff"
	item_state = "electronic"
	contained_sprite = TRUE
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 4
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/obj/item/disk/nuclear/the_disk = null
	var/active = 0

/obj/item/pinpointer/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	for(var/obj/machinery/nuclearbomb/bomb in SSmachinery.machinery)
		if(bomb.timing)
			. += "Extreme danger. Arming signal detected. Time remaining: [bomb.timeleft]"

/obj/item/pinpointer/attack_self()
	if(!active)
		active = 1
		START_PROCESSING(SSfast_process, src)
		to_chat(usr, SPAN_NOTICE("You activate the pinpointer."))
	else
		active = 0
		STOP_PROCESSING(SSfast_process, src)
		to_chat(usr, SPAN_NOTICE("You deactivate the pinpointer."))

/obj/item/pinpointer/process()
	if (active)
		workdisk()
	else
		STOP_PROCESSING(SSfast_process, src)

/obj/item/pinpointer/proc/workdisk()
	ClearOverlays()
	if(!active) return
	if(!the_disk)
		the_disk = locate()
		if(!the_disk)
			AddOverlays("pinonnull")
			return
	set_dir(get_dir(src,the_disk))
	switch(get_dist(src,the_disk))
		if(0)
			AddOverlays("pinondirect")
		if(1 to 8)
			AddOverlays("pinonclose")
		if(9 to 16)
			AddOverlays("pinonmedium")
		if(16 to INFINITY)
			AddOverlays("pinonfar")
	return TRUE

/obj/item/pinpointer/Destroy()
	active = 0
	STOP_PROCESSING(SSfast_process, src)
	return ..()

/obj/item/pinpointer/advpinpointer
	name = "advanced pinpointer"
	desc = "A larger version of the normal pinpointer, this unit features a helpful quantum entanglement detection system to locate various objects that do not broadcast a locator signal."
	var/mode = 0  // Mode 0 locates disk, mode 1 locates coordinates.
	var/turf/location = null
	var/obj/target = null

/obj/item/pinpointer/advpinpointer/attack_self()
	if(!active)
		active = 1
		if(mode == 0)
			workdisk()
		if(mode == 1)
			worklocation()
		if(mode == 2)
			workobj()
		START_PROCESSING(SSfast_process, src)
		to_chat(usr, SPAN_NOTICE("You activate the pinpointer"))
	else
		active = 0
		icon_state = "pinoff"
		ClearOverlays()
		to_chat(usr, SPAN_NOTICE("You deactivate the pinpointer"))

/obj/item/pinpointer/advpinpointer/process()
	switch(mode)
		if (0)
			workdisk()
		if (1)
			worklocation()
		if (2)
			workobj()

/obj/item/pinpointer/advpinpointer/proc/worklocation()
	ClearOverlays()
	if(!active)
		STOP_PROCESSING(SSfast_process, src)
		return
	if(!location)
		AddOverlays("pinonnull")
		return
	set_dir(get_dir(src,location))
	set_z_overlays(location)
	switch(get_dist(src,location))
		if(0)
			AddOverlays("pinondirect")
		if(1 to 8)
			AddOverlays("pinonclose")
		if(9 to 16)
			AddOverlays("pinonmedium")
		if(16 to INFINITY)
			AddOverlays("pinonfar")

/obj/item/pinpointer/advpinpointer/proc/set_z_overlays(var/atom/target)
	if(AreConnectedZLevels(src.loc.z, target.z))
		if(src.loc.z > target.z)
			AddOverlays("pinzdown")
		else if(src.loc.z < target.z)
			AddOverlays("pinzup")
	else
		active = 0
		if(ismob(loc))
			var/mob/holder = loc
			to_chat(holder, "<span class='notice>\The [src] cannot locate chosen target, shutting down.</span>")

/obj/item/pinpointer/advpinpointer/workdisk()
	if(..())
		set_z_overlays(the_disk)

/obj/item/pinpointer/advpinpointer/proc/workobj()
	ClearOverlays()
	if(!active)
		STOP_PROCESSING(SSfast_process, src)
		return
	if(!target)
		AddOverlays("pinonnull")
		return
	set_dir(get_dir(src,target))
	set_z_overlays(target)
	switch(get_dist(src,target))
		if(0)
			AddOverlays("pinondirect")
		if(1 to 8)
			AddOverlays("pinonclose")
		if(9 to 16)
			AddOverlays("pinonmedium")
		if(16 to INFINITY)
			AddOverlays("pinonfar")

/obj/item/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "Object.Held"
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	active = 0
	target = null
	location = null

	switch(alert("Please select the mode you want to put the pinpointer in.", "Pinpointer Mode Select", "Location", "Disk Recovery", "Other Signature"))
		if("Location")
			mode = 1

			var/locationx = tgui_input_number(usr, "Please input the x coordinate to search for.", "Pinpointer")
			if(!locationx || !(usr in view(1,src)))
				return
			var/locationy = tgui_input_number(usr, "Please input the y coordinate to search for.", "Pinpointer?")
			if(!locationy || !(usr in view(1,src)))
				return

			var/turf/Z = get_turf(src)

			location = locate(locationx,locationy,Z.z)

			to_chat(usr, "You set the pinpointer to locate [locationx],[locationy]")


			return attack_self()

		if("Disk Recovery")
			mode = 0
			return attack_self()

		if("Other Signature")
			mode = 2
			switch(alert("Search for item signature or DNA fragment?" , "Signature Mode Select" , "" , "Item" , "DNA"))
				if("Item")
					var/datum/objective/steal/itemlist
					itemlist = itemlist // To supress a 'variable defined but not used' error.
					var/targetitem = tgui_input_list(usr, "Select the item to search for.", "Pinpointer", itemlist.possible_items)
					if(!targetitem)
						return
					target=locate(itemlist.possible_items[targetitem])
					if(!target)
						to_chat(usr, "Failed to locate [targetitem]!")
						return
					to_chat(usr, "You set the pinpointer to locate [targetitem]")
				if("DNA")
					var/DNAstring = tgui_input_text(usr, "Input the DNA string to search.", "Pinpointer")
					if(!DNAstring)
						return
					for(var/mob/living/carbon/M in GLOB.mob_list)
						if(!M.dna)
							continue
						if(M.dna.unique_enzymes == DNAstring)
							target = M
							break

			return attack_self()


///////////////////////
//nuke op pinpointers//
///////////////////////


/obj/item/pinpointer/nukeop
	var/mode = 0	//Mode 0 locates disk, mode 1 locates the shuttle
	var/obj/machinery/computer/shuttle_control/multi/antag/syndicate/home = null

/obj/item/pinpointer/nukeop/attack_self(mob/user as mob)
	if(!active)
		active = 1
		START_PROCESSING(SSfast_process, src)
		if(!mode)
			workdisk()
			to_chat(user, SPAN_NOTICE("Authentication Disk Locator active."))
		else
			worklocation()
			to_chat(user, SPAN_NOTICE("Shuttle Locator active."))
	else
		active = 0
		STOP_PROCESSING(SSfast_process, src)
		to_chat(user, SPAN_NOTICE("You deactivate the pinpointer."))

/obj/item/pinpointer/nukeop/process()
	if (mode)
		workdisk()
	else
		worklocation()

/obj/item/pinpointer/nukeop/workdisk()
	ClearOverlays()
	if(!active) return
	if(mode)		//Check in case the mode changes while operating
		worklocation()
		return
	if(GLOB.bomb_set)	//If the bomb is set, lead to the shuttle
		mode = 1	//Ensures worklocation() continues to work
		worklocation()
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)	//Plays a beep
		visible_message("Shuttle Locator active.")			//Lets the mob holding it know that the mode has changed
		return		//Get outta here
	if(!the_disk)
		the_disk = locate()
		if(!the_disk)
			AddOverlays("pinonnull")
			return
//	if(loc.z != the_disk.z)	//If you are on a different z-level from the disk
//		icon_state = "pinonnull"
//	else
	set_dir(get_dir(src, the_disk))
	switch(get_dist(src, the_disk))
		if(0)
			AddOverlays("pinondirect")
		if(1 to 8)
			AddOverlays("pinonclose")
		if(9 to 16)
			AddOverlays("pinonmedium")
		if(16 to INFINITY)
			AddOverlays("pinonfar")

/obj/item/pinpointer/nukeop/proc/worklocation()
	if(!active)	return
	if(!mode)
		workdisk()
		return
	if(!GLOB.bomb_set)
		mode = 0
		workdisk()
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		visible_message(SPAN_NOTICE("Authentication Disk Locator active."))
		return
	if(!home)
		home = locate()
		if(!home)
			AddOverlays("pinonnull")
			return
	if(loc.z != home.z)	//If you are on a different z-level from the shuttle
		AddOverlays("pinonnull")
	else
		set_dir(get_dir(src, home))
		switch(get_dist(src, home))
			if(0)
				AddOverlays("pinondirect")
			if(1 to 8)
				AddOverlays("pinonclose")
			if(9 to 16)
				AddOverlays("pinonmedium")
			if(16 to INFINITY)
				AddOverlays("pinonfar")
