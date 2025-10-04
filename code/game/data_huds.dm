/*
 * Data HUDs have been rewritten in a more generic way.
 * In short, they now use an observer-listener pattern.
 * See code/datum/hud.dm for the generic hud datum.
 * Update the HUD icons when needed with the appropriate hook. (see below)
 */

/* DATA HUD DATUMS */

/atom/proc/add_to_all_human_data_huds()
	for(var/datum/atom_hud/data/human/hud in GLOB.huds)
		hud.add_atom_to_hud(src)

/atom/proc/remove_from_all_data_huds()
	for(var/datum/atom_hud/data/hud in GLOB.huds)
		hud.remove_atom_from_hud(src)

/datum/atom_hud/data

/datum/atom_hud/data/human/medical
	hud_icons = list(STATUS_HUD, HEALTH_HUD, STATUS_HUD_OOC, TRIAGE_HUD)

/datum/atom_hud/data/human/medical/basic

/datum/atom_hud/data/human/medical/basic/proc/check_sensors(mob/living/carbon/human/human)
	if(!istype(human))
		return FALSE
	var/obj/item/clothing/under/undersuit = human.w_uniform
	if(!istype(undersuit))
		return FALSE
	if(undersuit.has_sensor < SUIT_HAS_SENSORS)
		return FALSE
	if(undersuit.sensor_mode <= SUIT_SENSOR_BINARY)
		return FALSE
	return TRUE

/datum/atom_hud/data/human/medical/basic/add_atom_to_single_mob_hud(mob/M, mob/living/carbon/H)
	if(check_sensors(H))
		..()

/datum/atom_hud/data/human/medical/basic/proc/update_suit_sensors(mob/living/carbon/H)
	check_sensors(H) ? add_atom_to_hud(H) : remove_atom_from_hud(H)

/datum/atom_hud/data/human/medical/advanced

/datum/atom_hud/data/human/security

/datum/atom_hud/data/human/security/basic
	hud_icons = list(ID_HUD)

/datum/atom_hud/data/human/security/advanced
	hud_icons = list(ID_HUD, IMPCHEM_HUD, IMPLOYAL_HUD, IMPTRACK_HUD, WANTED_HUD)

/datum/atom_hud/data/human/antag
	hud_icons = list(ANTAG_HUD)

/* MED/SEC/DIAG HUD HOOKS */

/*
 * THESE HOOKS SHOULD BE CALLED BY THE MOB SHOWING THE HUD
 */

/***********************************************
Medical HUD! Basic mode needs suit sensors on.
************************************************/

//HOOKS

//called when a human changes suit sensors
/mob/living/carbon/proc/update_suit_sensors()
	var/datum/atom_hud/data/human/medical/basic/B = GLOB.huds[DATA_HUD_MEDICAL_BASIC]
	B.update_suit_sensors(src)

//called when a living mob changes health
/mob/living/proc/med_hud_set_health()
	if(stat == DEAD || (status_flags & FAKEDEATH))
		set_hud_image_state(HEALTH_HUD, "0")
	else if (is_asystole())
		set_hud_image_state(HEALTH_HUD, "flatline")
	else
		var/pulse = pulse()
		set_hud_image_state(HEALTH_HUD, "[pulse]")

/mob/living/silicon/med_hud_set_health()
	set_hud_image_inactive(HEALTH_HUD)

/mob/living/carbon/human/med_hud_set_health()
	. = ..()
	var/obj/item/clothing/under/uniform = w_uniform
	if(istype(uniform) && uniform.sensor_mode < SUIT_SENSOR_VITAL)
		set_hud_image_inactive(HEALTH_HUD)
	else
		set_hud_image_active(HEALTH_HUD)

// Called when a living mob changes stat or gets brain worms
// Returns TRUE if the mob is considered "perfectly healthy", FALSE otherwise
/mob/living/proc/med_hud_set_status()
	if(stat == DEAD || (status_flags & FAKEDEATH))
		set_hud_image_state(STATUS_HUD, "huddead")
		set_hud_image_state(STATUS_HUD_OOC, "huddead")
	else
		set_hud_image_state(STATUS_HUD, "hudhealthy")
		if(has_brain_worms())
			set_hud_image_state(STATUS_HUD_OOC, "hudbrainworm")
		else
			set_hud_image_state(STATUS_HUD_OOC, "hudhealthy")
		return TRUE
	return FALSE

/mob/living/silicon/med_hud_set_status()
	set_hud_image_inactive(STATUS_HUD)
	set_hud_image_inactive(STATUS_HUD_OOC)

/mob/living/proc/med_hud_set_triage()

/mob/living/carbon/human/med_hud_set_triage()
	set_hud_image_state(TRIAGE_HUD, triage_tag)

/***********************************************
Security HUDs! Basic mode shows only the job.
************************************************/

//HOOKS

/mob/living/proc/update_id_card()

/mob/living/carbon/human/update_id_card()
	var/sechud_icon_state = wear_id?.get_sechud_job_icon_state()
	set_hud_image_state(ID_HUD, sechud_icon_state)
	sec_hud_set_security_status()

/mob/living/proc/sec_hud_set_implants()
	for(var/hud_type in (list(IMPCHEM_HUD, IMPLOYAL_HUD, IMPTRACK_HUD) & hud_list))
		set_hud_image_inactive(hud_type)

	for(var/obj/item/implant/I in src)
		if(I.implanted)
			if(istype(I,/obj/item/implant/tracking))
				set_hud_image_state(IMPTRACK_HUD, "hud_imp_tracking")
				set_hud_image_active(IMPTRACK_HUD)

			if(istype(I,/obj/item/implant/mindshield) && !istype(I,/obj/item/implant/mindshield/loyalty))
				set_hud_image_state(IMPLOYAL_HUD, "hud_imp_loyal")
				set_hud_image_active(IMPLOYAL_HUD)

			if(istype(I,/obj/item/implant/chem))
				set_hud_image_state(IMPCHEM_HUD, "hud_imp_chem")
				set_hud_image_active(IMPCHEM_HUD)

/mob/living/carbon/human/proc/sec_hud_set_security_status()
	if(!hud_list)
		// We haven't finished initializing yet, huds will be updated once we are
		return

	var/perp_name = get_face_name(get_id_name(""))

	if(!perp_name || !SSrecords.initialized)
		set_hud_image_inactive(WANTED_HUD)
		return

	var/datum/record/general/target = SSrecords.find_record("name", perp_name)
	if(!target || !istype(target.security) || target.security.criminal == "None")
		set_hud_image_inactive(WANTED_HUD)
		return

	switch(target.security.criminal)
		if("*Arrest*")
			set_hud_image_state(WANTED_HUD, "hudwanted")
		if("Incarcerated")
			set_hud_image_state(WANTED_HUD, "hudprisoner")
		if("Search")
			set_hud_image_state(WANTED_HUD, "hudsearch")
		if("Parolled")
			set_hud_image_state(WANTED_HUD, "hudparolled")
		if("Released")
			set_hud_image_state(WANTED_HUD, "hudreleased")

	set_hud_image_active(WANTED_HUD)

/// Antag Hud
/mob/living/proc/antag_hud_set_role()
	if(!hud_list)
		return

	if(mind && mind.special_role)
		set_hud_image_active(ANTAG_HUD)
		if(GLOB.hud_icon_reference[mind.special_role])
			set_hud_image_state(ANTAG_HUD, GLOB.hud_icon_reference[mind.special_role])
		else
			set_hud_image_state(ANTAG_HUD, "hudsyndicate")
	else
		set_hud_image_inactive(ANTAG_HUD)

//Utility functions

/**
 * Updates the visual security huds on all mobs in GLOB.human_mob_list that match the name passed to it.
 */
/proc/update_matching_security_huds(perp_name)
	for (var/mob/living/carbon/human/h as anything in GLOB.human_mob_list)
		if (h.get_face_name(h.get_id_name("")) == perp_name)
			h.sec_hud_set_security_status()

/**
 * Updates the visual security huds on all mobs in GLOB.human_mob_list
 */
/proc/update_all_security_huds()
	for(var/mob/living/carbon/human/h as anything in GLOB.human_mob_list)
		h.sec_hud_set_security_status()

#define CACHED_WIDTH_INDEX "width"
#define CACHED_HEIGHT_INDEX "height"

/atom/proc/get_cached_width()
	if (isnull(icon))
		return 0
	var/list/dimensions = get_icon_dimensions(icon)
	return dimensions[CACHED_WIDTH_INDEX]

/atom/proc/get_cached_height()
	if (isnull(icon))
		return 0
	var/list/dimensions = get_icon_dimensions(icon)
	return dimensions[CACHED_HEIGHT_INDEX]

#undef CACHED_WIDTH_INDEX
#undef CACHED_HEIGHT_INDEX

/atom/proc/get_visual_width()
	var/width = get_cached_width()
	var/height = get_cached_height()
	var/scale_list = list(
		width * transform.a + height * transform.b + transform.c,
		width * transform.a + transform.c,
		height * transform.b + transform.c,
		transform.c
	)
	return max(scale_list) - min(scale_list)

/atom/proc/get_visual_height()
	var/width = get_cached_width()
	var/height = get_cached_height()
	var/scale_list = list(
		width * transform.d + height * transform.e + transform.f,
		width * transform.d + transform.f,
		height * transform.e + transform.f,
		transform.f
	)
	return max(scale_list) - min(scale_list)

/atom/proc/adjust_hud_position(image/holder, animate_time = null)
	if (animate_time)
		animate(holder, pixel_w = -(get_cached_width() - ICON_SIZE_X) / 2, pixel_z = get_cached_height() - ICON_SIZE_Y, time = animate_time)
		return
	holder.pixel_w = -(get_cached_width() - ICON_SIZE_X) / 2
	holder.pixel_z = get_cached_height() - ICON_SIZE_Y

/atom/proc/set_hud_image_state(hud_type, hud_state, x_offset = 0, y_offset = 0)
	if (!hud_list) // Still initializing
		return
	var/image/holder = hud_list[hud_type]
	if (!holder)
		return
	if (!istype(holder)) // Can contain lists for HUD_LIST_LIST hinted HUDs, if someone fucks up and passes this here we wanna know about it
		CRASH("[src] ([type]) had a HUD_LIST_LIST hud_type [hud_type] passed into set_hud_image_state!")
	holder.icon_state = hud_state
	adjust_hud_position(holder)
	if (x_offset || y_offset)
		holder.pixel_w += x_offset
		holder.pixel_z += y_offset
