/obj/item/mecha_equipment/mounted_system/rfd
	name = "mounted rfd"
	icon_state = "mecha_rfd"
	holding_type = /obj/item/rfd/construction/mounted/exosuit
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)

/obj/item/mecha_equipment/mounted_system/rfd/CtrlClick(mob/user)
	if(owner && istype(holding, /obj/item/rfd/construction/mounted/exosuit))
		var/obj/item/rfd/construction/mounted/exosuit/R = holding
		var/current_mode = show_radial_menu(user, owner, R.radial_modes, radius = 42, require_near = FALSE , tooltips = TRUE)
		switch(current_mode)
			if("Floors and Walls")
				R.mode = RFD_FLOORS_AND_WALL
			if("Windows and Grille")
				R.mode = RFD_WINDOW_AND_FRAME
			if("Airlock")
				R.mode = RFD_AIRLOCK
			if("Deconstruct")
				R.mode = RFD_DECONSTRUCT
			else
				R.mode = RFD_FLOORS_AND_WALL
		if(current_mode)
			to_chat(user, SPAN_NOTICE("You set the device to <i>\"[current_mode]\"</i>."))
			if(R.mode == 3)
				playsound(get_turf(src), 'sound/weapons/laser_safetyoff.ogg', 50, FALSE)
			else
				playsound(get_turf(src), 'sound/weapons/laser_safetyon.ogg', 50, FALSE)
	else
		return

/obj/item/rfd/construction/mounted/exosuit/attack_self(mob/user) //we don't want this attack_self, as it would target the pilot not the exosuit.
	return

/obj/item/rfd/construction/mounted/exosuit/get_hardpoint_maptext()
	var/obj/item/mecha_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner)
		var/obj/item/cell/C = MS.owner.get_cell()
		if(istype(C))
			return "[round(C.charge)]/[round(C.maxcharge)]"
	return null

/obj/item/rfd/construction/mounted/exosuit/get_hardpoint_status_value()
	var/obj/item/mecha_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner)
		var/obj/item/cell/C = MS.owner.get_cell()
		if(istype(C))
			return C.charge/C.maxcharge
	return null

/obj/item/extinguisher/mech
	name = "mounted fire extinguisher"
	max_water = 4000 //Good is gooder
	icon = 'icons/mecha/mech_equipment.dmi'
	icon_state = "mecha_exting"
	safety = FALSE

/obj/item/extinguisher/mech/New()
	reagents = new/datum/reagents(max_water)
	reagents.my_atom = src
	reagents.add_reagent(/singleton/reagent/toxin/fertilizer/monoammoniumphosphate, max_water)
	..()

/obj/item/extinguisher/mech/get_hardpoint_maptext()
	return "[reagents.total_volume]/[max_water]"

/obj/item/extinguisher/mech/get_hardpoint_status_value()
	return reagents.total_volume/max_water

/obj/item/mecha_equipment/mounted_system/extinguisher
	name = "mounted extinguisher"
	icon_state = "mecha_exting"
	holding_type = /obj/item/extinguisher/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)

