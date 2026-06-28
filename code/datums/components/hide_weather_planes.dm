/datum/component/hide_weather_planes
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/list/atom/movable/screen/plane_master/plane_masters = list()
	var/datum/hud/attached_hud

/datum/component/hide_weather_planes/Initialize(atom/movable/screen/plane_master/care_about)
	if(!istype(parent, /datum/plane_master_group))
		return COMPONENT_INCOMPATIBLE

	track_plane(care_about)
	RegisterSignals(SSweather, list(
		COMSIG_WEATHER_SYSTEM_REGISTERED,
		COMSIG_WEATHER_SYSTEM_UNREGISTERED,
		COMSIG_WEATHER_SYSTEM_UPDATED
	), PROC_REF(weather_system_changed))

	var/datum/plane_master_group/home = parent
	if(home.our_hud)
		attach_hud(home.our_hud)
	else
		RegisterSignal(home, COMSIG_GROUP_HUD_CHANGED, PROC_REF(new_hud_attached))

	addtimer(CALLBACK(src, PROC_REF(update_planes)), 0)

/datum/component/hide_weather_planes/Destroy(force)
	hide_planes()
	if(attached_hud)
		UnregisterSignal(attached_hud, list(COMSIG_HUD_EYE_CHANGED, COMSIG_HUD_Z_CHANGED, COMSIG_HUD_OFFSET_CHANGED))
		attached_hud = null
	if(parent)
		UnregisterSignal(parent, COMSIG_GROUP_HUD_CHANGED)
	UnregisterSignal(SSweather, list(
		COMSIG_WEATHER_SYSTEM_REGISTERED,
		COMSIG_WEATHER_SYSTEM_UNREGISTERED,
		COMSIG_WEATHER_SYSTEM_UPDATED
	))
	for(var/atom/movable/screen/plane_master/plane as anything in plane_masters)
		if(QDELETED(plane))
			continue
		UnregisterSignal(plane, COMSIG_QDELETING)
	plane_masters = null
	return ..()

/datum/component/hide_weather_planes/InheritComponent(datum/component/new_comp, i_am_original, atom/movable/screen/plane_master/care_about)
	if(!i_am_original)
		return
	track_plane(care_about)
	update_planes()

/datum/component/hide_weather_planes/proc/track_plane(atom/movable/screen/plane_master/care_about)
	if(!istype(care_about))
		return
	plane_masters |= care_about
	RegisterSignal(care_about, COMSIG_QDELETING, PROC_REF(plane_master_deleted))

/datum/component/hide_weather_planes/proc/new_hud_attached(datum/source, datum/hud/old_hud, datum/hud/new_hud)
	SIGNAL_HANDLER
	attach_hud(new_hud)

/datum/component/hide_weather_planes/proc/attach_hud(datum/hud/new_hud)
	if(attached_hud == new_hud)
		update_planes()
		return

	if(attached_hud)
		UnregisterSignal(attached_hud, list(COMSIG_HUD_EYE_CHANGED, COMSIG_HUD_Z_CHANGED, COMSIG_HUD_OFFSET_CHANGED))
	attached_hud = new_hud

	if(!attached_hud)
		hide_planes()
		return

	RegisterSignals(attached_hud, list(COMSIG_HUD_EYE_CHANGED, COMSIG_HUD_Z_CHANGED, COMSIG_HUD_OFFSET_CHANGED), PROC_REF(hud_view_changed))
	update_planes()

/datum/component/hide_weather_planes/proc/hud_view_changed(datum/source, ...)
	SIGNAL_HANDLER
	update_planes()

/datum/component/hide_weather_planes/proc/weather_system_changed(datum/source, ...)
	SIGNAL_HANDLER
	update_planes()

/datum/component/hide_weather_planes/proc/plane_master_deleted(atom/movable/screen/plane_master/source)
	SIGNAL_HANDLER
	plane_masters -= source

/datum/component/hide_weather_planes/proc/get_viewing_turf()
	if(!attached_hud)
		return null
	var/client/viewer = attached_hud.mymob?.canon_client || attached_hud.mymob?.client
	var/atom/eye = viewer?.eye || attached_hud.mymob
	return get_turf(eye)

/datum/component/hide_weather_planes/proc/update_planes()
	if(has_visible_weather())
		display_planes()
	else
		hide_planes()

/datum/component/hide_weather_planes/proc/has_visible_weather()
	if(!attached_hud)
		return FALSE

	var/turf/viewing_from = get_viewing_turf()
	if(!viewing_from)
		return FALSE

	var/list/connected_levels = SSmapping.z_level_to_stack?[viewing_from.z]
	if(!length(connected_levels))
		connected_levels = GetConnectedZlevels(viewing_from.z)

	for(var/obj/abstract/weather_system/weather as anything in SSweather.weather_systems)
		if(QDELETED(weather) || !weather.has_visible_weather())
			continue
		if(length(connected_levels & weather.affecting_zs))
			return TRUE

	return FALSE

/datum/component/hide_weather_planes/proc/display_planes()
	var/mob/our_mob = attached_hud?.mymob
	var/turf/viewing_from = get_viewing_turf()
	if(!viewing_from)
		return
	var/our_offset = GET_TURF_PLANE_OFFSET(viewing_from) || 0
	for(var/atom/movable/screen/plane_master/weather_conscious as anything in plane_masters)
		if(QDELETED(weather_conscious))
			continue
		if(weather_conscious.force_hidden)
			weather_conscious.unhide_plane(our_mob)
		else
			weather_conscious.show_to(our_mob)

		if(weather_conscious.offset >= our_offset)
			weather_conscious.enable_alpha()
		else
			weather_conscious.disable_alpha()

/datum/component/hide_weather_planes/proc/hide_planes()
	var/mob/our_mob = attached_hud?.mymob
	for(var/atom/movable/screen/plane_master/weather_conscious as anything in plane_masters)
		if(QDELETED(weather_conscious))
			continue
		weather_conscious.hide_plane(our_mob)
