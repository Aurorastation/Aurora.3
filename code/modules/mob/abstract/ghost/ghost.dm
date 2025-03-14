/mob/abstract/ghost
	stat = DEAD
	layer = OBSERVER_LAYER
	plane = OBSERVER_PLANE

	/// Toggle darkness.
	var/see_darkness = FALSE
	/// Is the ghost able to see things humans can't?
	var/ghostvision = FALSE
	/// This variable generally controls whether a ghost has restrictions on where it can go or not (ex. if the ghost can bypass holy places).
	var/has_ghost_restrictions = TRUE
	/// If the ghost has antagHUD.
	var/antagHUD = 0
	/// Necessary for seeing wires.
	var/obj/item/device/multitool/ghost_multitool
	/// The POI we're orbiting.
	var/orbiting_ref

/mob/abstract/ghost/Initialize(mapload)
	. = ..()
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	add_verb(src, /mob/abstract/ghost/proc/dead_tele)
	ghost_multitool = new(src)

/mob/abstract/ghost/Destroy()
	QDEL_NULL(ghost_multitool)
	return ..()

/mob/abstract/ghost/Topic(href, href_list)
	if (href_list["track"])
		if(istype(href_list["track"],/mob))
			var/mob/target = locate(href_list["track"]) in GLOB.mob_list
			if(target)
				ManualFollow(target)
		else
			var/atom/target = locate(href_list["track"])
			if(istype(target))
				ManualFollow(target)

/mob/abstract/ghost/ClickOn(atom/A, params)
	if(!canClick())
		return
	setClickCooldown(4)
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

/mob/abstract/ghost/Post_Incorpmove()
	orbiting?.end_orbit(src)

/mob/abstract/ghost/orbit()
	set_dir(2)//reset dir so the right directional sprites show up
	return ..()

/mob/abstract/ghost/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"

	see_darkness = !see_darkness
	update_sight()

/mob/abstract/ghost/proc/update_sight()
	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	if (!see_darkness)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else
		set_see_invisible(ghostvision ? SEE_INVISIBLE_OBSERVER : SEE_INVISIBLE_LIVING)

/mob/abstract/ghost/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set category = "Ghost"
	set desc = "Toggles your ability to see things only ghosts can see, like ghosts."

	ghostvision = !ghostvision
	update_sight()
	to_chat(usr, SPAN_NOTICE("You [(ghostvision ? "now" : "no longer")] have ghost vision."))

/mob/abstract/ghost/proc/dead_tele()
	set name = "Teleport"
	set category = "Ghost"
	set desc= "Teleport to a location."

	if(!istype(usr, /mob/abstract/ghost))
		to_chat(usr, SPAN_WARNING("You need to be a ghost!"))
		return

	var/area_name = tgui_input_list(src, "Select an area to teleport to.", "Teleport", GLOB.ghostteleportlocs)

	remove_verb(usr, /mob/abstract/ghost/proc/dead_tele)
	ADD_VERB_IN(usr, 30, /mob/abstract/ghost/proc/dead_tele)

	var/area/thearea = GLOB.ghostteleportlocs[area_name]
	if(!thearea)
		return

	var/list/L = list()
	var/holyblock = FALSE

	if(usr.invisibility <= SEE_INVISIBLE_LIVING || (usr.mind in GLOB.cult.current_antagonists))
		for(var/turf/T in get_area_turfs(thearea))
			if(!T.holy && has_ghost_restrictions)
				L+=T
			else
				holyblock = TRUE
	else
		for(var/turf/T in get_area_turfs(thearea))
			L+=T

	if(!L || !L.len)
		if(holyblock && has_ghost_restrictions)
			to_chat(usr, SPAN_WARNING("This area has been entirely made into sacred grounds, you cannot enter it while you are in this plane of existence!"))
			return
		else
			to_chat(usr, "No area available.")
			return

	var/turf/P = pick(L)
	if(on_restricted_level(P.z) && has_ghost_restrictions)
		to_chat(usr, "You can not teleport to this area.")
		return

	orbiting?.end_orbit(src)
	usr.forceMove(pick(L))

/mob/abstract/ghost/verb/follow()
	set name = "Follow"
	set category = "Ghost"
	set desc = "Follow and haunt a mob."

	var/datum/tgui_module/follow_menu/GM = new /datum/tgui_module/follow_menu(usr)
	GM.ui_interact(usr)

// This is the ghost's follow verb with an argument
/mob/abstract/ghost/proc/ManualFollow(var/atom/movable/target)
	if(!target)
		return

	//Stops orbit if there's any; TG doesn't do this, but if you don't it breaks the orbiting reference
	//if you are jumping from one mob to another, hence why we're doing it here
	orbiting?.end_orbit(src)

	var/list/icon_dimensions = get_icon_dimensions(target.icon)
	var/orbitsize = (icon_dimensions["width"] + icon_dimensions["height"]) * 0.5
	orbitsize -= (orbitsize/ICON_SIZE_ALL)*(ICON_SIZE_ALL*0.25)

	var/rot_seg = 30 //Let's make it simple and it's just a circle

	orbit(target,orbitsize, FALSE, 20, rot_seg)

	to_chat(src, SPAN_NOTICE("Now following \the <b>[target]</b>."))
	update_sight()

/mob/abstract/ghost/proc/on_restricted_level(var/check)
	if(!check)
		check = z
	//Check if they are a staff member
	if(check_rights(R_MOD|R_ADMIN|R_DEV, show_msg=FALSE, user=src))
		return FALSE

	//Check if the z level is in the restricted list
	if (!(check in SSatlas.current_map.restricted_levels))
		return FALSE

	return TRUE

/mob/abstract/ghost/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	// Shamelessly copied from the Gas Analyzers
	if(!isturf(loc))
		return

	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	to_chat(src, SPAN_NOTICE("<B>Results:</B>"))
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(src, SPAN_NOTICE("Pressure: [round(pressure,0.1)] kPa"))
	else
		to_chat(src, SPAN_WARNING("Pressure: [round(pressure,0.1)] kPa"))
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(src, SPAN_NOTICE("[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]% ([round(environment.gas[g], 0.01)] moles)"))
		to_chat(src, SPAN_NOTICE("Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)"))
		to_chat(src, SPAN_NOTICE("Heat Capacity: [round(environment.heat_capacity(),0.1)]"))

/mob/abstract/ghost/verb/view_manifest()
	set name = "Show Crew Manifest"
	set category = "Ghost"
	SSrecords.open_manifest_tgui(usr)
