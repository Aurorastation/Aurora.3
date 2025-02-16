#define MAX_AREA_SIZE 300

/mob/abstract/eye/blueprints
	/// Associative list of turfs -> boolean validity that the player has selected for new area creation.
	var/list/selected_turfs = list()
	///The overlayed images of the user's selection.
	var/list/selection_images = list()
	///The last turf selected.
	var/turf/last_selected_turf
	///The image overlayed on the last selected turf
	var/image/last_selected_image

	///On what z-levels the blueprints can be used to modify or create areas.
	var/list/valid_z_levels = list()

	///Displayed to the user to allow them to see what area they're hovering over
	var/obj/effect/overlay/area_name_effect
	///The prefix of the area name effect display
	var/area_prefix

	///Displayed to the user on failed area creation
	var/list/errors = list()

/mob/abstract/eye/blueprints/Initialize(mapload, var/list/valid_zs, var/area_p)
	. = ..(mapload)
	if(valid_zs)
		valid_z_levels = valid_zs.Copy()
	area_prefix = area_p
	area_name_effect = new(src)

	area_name_effect.icon_state = "nothing"
	area_name_effect.maptext_height = 64
	area_name_effect.maptext_width = 128
	area_name_effect.layer = FLOAT_LAYER
	area_name_effect.plane = HUD_PLANE
	area_name_effect.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	area_name_effect.screen_loc = "LEFT+1,BOTTOM+2"

	last_selected_image = image('icons/effects/blueprints.dmi', "selected")
	last_selected_image.plane = HUD_PLANE
	last_selected_image.appearance_flags = NO_CLIENT_COLOR|RESET_COLOR

/mob/abstract/eye/blueprints/Destroy()
	QDEL_NULL(area_name_effect)
	errors = null
	selected_turfs = null
	valid_z_levels = null
	last_selected_turf = null
	. = ..()

/mob/abstract/eye/blueprints/release(var/mob/user)
	if(owner && owner.client && user == owner)
		owner.client.images.Cut()
	. = ..()

/mob/abstract/eye/blueprints/proc/create_area()
	var/area_name = sanitizeSafe(tgui_input_text(owner, "New area name: ", "Area Creation", "", MAX_NAME_LEN))
	if(!area_name || !length(area_name))
		return
	if(length(area_name) > 50)
		to_chat(owner, SPAN_WARNING("That name is too long!"))
		return

	if(!check_selection_validity())
		to_chat(owner, SPAN_WARNING("Could not mark area: [english_list(errors)]!"))
		return

	var/area/A = finalize_area(area_name)
	for(var/turf/T in selected_turfs)
		T.change_area(T.loc, A)
	remove_selection() // Reset the selection for clarity.

/mob/abstract/eye/blueprints/proc/finalize_area(var/area_name)
	var/area/A = new()
	A.name = area_name
	var/area/old_area = get_area(selected_turfs[1])
	if(old_area.area_flags & AREA_FLAG_INDESTRUCTIBLE_TURFS) //to prevent new areas on exoplanets being ventable
		A.area_flags |= AREA_FLAG_INDESTRUCTIBLE_TURFS
	A.power_equip = FALSE
	A.power_light = FALSE
	A.power_environ = FALSE
	A.always_unpowered = FALSE
	return A

/mob/abstract/eye/blueprints/proc/remove_area()
	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	if(A.apc)
		to_chat(owner, SPAN_WARNING("You must remove the APC from this area before you can remove it from the blueprints!"))
		return
	to_chat(owner, SPAN_NOTICE("You scrub [A.name] off the blueprints."))
	log_and_message_admins("deleted area [A.name] via station blueprints.")
	var/background_area = world.area
	var/obj/effect/overmap/visitable/sector/sector = GLOB.map_sectors["[A.z]"]
	var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = sector
	if(istype(exoplanet))
		background_area = exoplanet.planetary_area
	if(SSodyssey.scenario && (GET_Z(owner) in SSodyssey.scenario_zlevels))
		background_area = SSodyssey.scenario.base_area
	for(var/turf/T in A.contents)
		T.change_area(T.loc, background_area)
	if(!locate(/turf) in A)
		qdel(A)

/mob/abstract/eye/blueprints/proc/edit_area()
	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	var/prevname = A.name
	var/new_area_name = sanitizeSafe(input("Edit area name:","Area Editing", prevname), MAX_NAME_LEN)
	if(!new_area_name || !LAZYLEN(new_area_name) || new_area_name==prevname)
		return
	if(length(new_area_name) > 50)
		to_chat(owner, SPAN_WARNING("Text too long."))
		return

	// Adjusting titles in the old area.
	var/static/list/types_to_rename = list(
		/obj/machinery/alarm,
		/obj/machinery/power/apc,
		/obj/machinery/atmospherics/unary/vent_pump,
		/obj/machinery/atmospherics/unary/vent_pump,
		/obj/machinery/door
	)
	for(var/obj/machinery/M in A)
		if(is_type_in_list(M, types_to_rename))
			M.name = replacetext(M.name, prevname, new_area_name)
	A.name = new_area_name
	to_chat(owner, SPAN_NOTICE("You set the area '[prevname]' title to '[new_area_name]'."))

/mob/abstract/eye/blueprints/ClickOn(atom/A, params)
	params = params2list(params)
	if(!canClick())
		return
	if(params["left"])
		update_selected_turfs(get_turf(A), params)
	if(params["ctrl"]) //Shift-click to clear the selection
		remove_selection()

/mob/abstract/eye/blueprints/proc/update_selected_turfs(var/turf/next_selected_turf, var/list/params)
	if(!next_selected_turf)
		return
	if(!last_selected_turf) //The player has only placed one corner of the block
		last_selected_turf = next_selected_turf
		last_selected_image.loc = last_selected_turf
		return
	if(last_selected_turf.z != next_selected_turf.z) // No multi-Z areas. Contiguity checks this as well, but this is cheaper.
		return

	var/list/new_selection = block(last_selected_turf, next_selected_turf)
	if(params["shift"]) //Right-click to remove areas from the selection
		selected_turfs -= new_selection
	else
		selected_turfs |= new_selection

	last_selected_image.loc = null //Remove last selected turf indicator image
	check_selection_validity()
	update_images()

/mob/abstract/eye/blueprints/proc/check_selection_validity()
	. = TRUE
	errors.Cut()

	if(!LAZYLEN(selected_turfs)) //Sanity check
		errors |= "no turfs are selected"
		return FALSE
	if(LAZYLEN(selected_turfs) > MAX_AREA_SIZE)
		errors |= "selection exceeds max size"
		return FALSE
	for(var/turf/T in selected_turfs)
		var/turf_valid = check_turf_validity(T)
		. = min(., turf_valid)
		selected_turfs[T] = turf_valid
	if(!.) return
	. = check_contiguity()

/mob/abstract/eye/blueprints/proc/check_turf_validity(var/turf/T)
	. = TRUE
	if(!T)
		return FALSE
	if(!(T.z in valid_z_levels))
		errors |= "selection isn't marked on the blueprints"
		. = FALSE
	var/area/A = T.loc
	if(!A) //Safety check
		errors |= "selection overlaps unknown location"
		return FALSE
	if(!(A.area_flags & AREA_FLAG_IS_BACKGROUND)) // Cannot create new areas over old ones.
		errors |= "selection overlaps other area"
		. = FALSE
	if(istype(T, (A.base_turf ? A.base_turf : /turf/space)))
		errors |= "selection is exposed to the outside"
		. = FALSE

/mob/abstract/eye/blueprints/proc/check_contiguity()
	var/turf/start_turf = pick(selected_turfs)
	var/list/pending_turfs = list(start_turf)
	var/list/checked_turfs = list()

	while(pending_turfs.len)
		if(LAZYLEN(checked_turfs) > MAX_AREA_SIZE)
			errors |= "selection exceeds max size"
			break
		var/turf/T = pending_turfs[1]
		pending_turfs -= T
		for(var/dir in GLOB.cardinals)	// Floodfill to find all turfs contiguous with the randomly chosen start_turf.
			var/turf/NT = get_step(T, dir)
			if(!isturf(NT) || !(NT in selected_turfs) || (NT in pending_turfs) || (NT in checked_turfs))
				continue
			pending_turfs += NT

		checked_turfs += T

	var/list/incontiguous_turfs = (selected_turfs.Copy() - checked_turfs)

	if(LAZYLEN(incontiguous_turfs)) // If turfs still remain in incontiguous_turfs, there are non-contiguous turfs in the selection.
		errors |= "selection must be contiguous"
		return FALSE

	return TRUE

/mob/abstract/eye/blueprints/proc/check_modification_validity()
	. = TRUE
	var/area/A = get_area(src)
	if(!(A.z in valid_z_levels))
		to_chat(owner, SPAN_WARNING("The markings on this are entirely irrelevant to your whereabouts!"))
		return FALSE
	if(A in SSshuttle.shuttle_areas)
		to_chat(owner, SPAN_WARNING("This segment of the blueprints looks far too complex. Best not touch it!"))
		return FALSE
	if(!A || (A.area_flags & AREA_FLAG_IS_BACKGROUND))
		to_chat(owner, SPAN_WARNING("This area is not marked on the blueprints!"))
		return FALSE

/mob/abstract/eye/blueprints/proc/remove_selection()
	selected_turfs.Cut()
	last_selected_turf = null
	update_images()

/mob/abstract/eye/blueprints/proc/update_images()
	if(!owner || !owner.client)
		return

	owner.client.images -= selection_images
	selection_images.Cut()
	if(LAZYLEN(selected_turfs))
		for(var/turf/T in selected_turfs)
			var/selection_icon_state = selected_turfs[T] ? "valid" : "invalid"
			var/image/I = image('icons/effects/blueprints.dmi', T, selection_icon_state)
			I.plane = HUD_PLANE
			I.appearance_flags = NO_CLIENT_COLOR
			selection_images += I

	owner.client.images |= last_selected_image
	owner.client.images += selection_images

/mob/abstract/eye/blueprints/setLoc(T)
	. = ..()
	var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
	var/area/A = get_area(src)
	if(!A)
		return
	area_name_effect.maptext = "<span style=\"[style]\">[area_prefix], [A.name]</span>"

/mob/abstract/eye/blueprints/additional_sight_flags()
	return SEE_TURFS|BLIND

/mob/abstract/eye/blueprints/apply_visual(mob/living/M)
	M.overlay_fullscreen("blueprints", /atom/movable/screen/fullscreen/blueprints)
	M.client.screen += area_name_effect
	M.add_client_color(/datum/client_color/monochrome)

/mob/abstract/eye/blueprints/remove_visual(mob/living/M)
	M.clear_fullscreen("blueprints", 0)
	M.client.screen -= area_name_effect
	M.remove_client_color(/datum/client_color/monochrome)

//Shuttle blueprint eye
/mob/abstract/eye/blueprints/shuttle
	var/shuttle_name

/mob/abstract/eye/blueprints/shuttle/Initialize(mapload, list/valid_zs, area_p, shuttle_name)
	. = ..()
	src.shuttle_name = shuttle_name

/mob/abstract/eye/blueprints/shuttle/check_modification_validity()
	. = TRUE
	var/area/A = get_area(src)
	if(!(A.z in valid_z_levels))
		to_chat(owner, SPAN_WARNING("The markings on this are entirely irrelevant to your whereabouts!"))
		return FALSE
	var/datum/shuttle/our_shuttle = SSshuttle.shuttles[shuttle_name]
	if(!(A in our_shuttle.shuttle_area))
		to_chat(owner, SPAN_WARNING("That's not a part of the [our_shuttle.name]!"))
		return FALSE
	if(!A || (A.area_flags & AREA_FLAG_IS_BACKGROUND))
		to_chat(owner, SPAN_WARNING("This area is not marked on the blueprints!"))
		return FALSE

/mob/abstract/eye/blueprints/shuttle/remove_area()
	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	if(A.apc)
		to_chat(owner, SPAN_WARNING("You must remove the APC from this area before you can remove it from the blueprints!"))
		return
	var/datum/shuttle/our_shuttle = SSshuttle.shuttles[shuttle_name]
	if(our_shuttle.shuttle_area.len == 1) //If it's the last shuttle area, make sure that we don't break the shuttle in question.
		to_chat(owner, SPAN_WARNING("You cannot delete the last area in a shuttle!"))
		return
	to_chat(owner, SPAN_NOTICE("You scrub [A.name] off the blueprints."))
	log_and_message_admins("deleted area [A.name] from [our_shuttle.name] via shuttle blueprints.")
	var/background_area = world.area
	var/obj/effect/overmap/visitable/sector/sector = GLOB.map_sectors["[A.z]"]
	var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = sector
	if(istype(exoplanet))
		background_area = exoplanet.planetary_area
	if(SSodyssey.scenario && (GET_Z(owner) in SSodyssey.scenario_zlevels))
		background_area = SSodyssey.scenario.base_area
	for(var/turf/T in A.contents)
		T.change_area(T.loc, background_area)
	if(!(locate(/turf) in A))
		qdel(A) // uh oh, is this safe?

/mob/abstract/eye/blueprints/shuttle/finalize_area(area_name)
	var/area/A = ..(area_name)
	var/datum/shuttle/our_shuttle = SSshuttle.shuttles[shuttle_name]
	our_shuttle.shuttle_area += A
	SSshuttle.shuttle_areas += A
	RegisterSignal(A, COMSIG_QDELETING, TYPE_PROC_REF(/datum/shuttle, remove_shuttle_area))
	return A

#undef MAX_AREA_SIZE
