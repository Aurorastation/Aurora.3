#define PARALLAX_NONE "parallax_none"

SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	init_order = INIT_ORDER_PARALLAX
	flags = SS_NO_FIRE
	var/planet_x_offset = 128
	var/planet_y_offset = 128
	var/starlight_color
	/// Path to our background. Lets us use anything we damn well please. Must be 480x480
	var/skybox_icon = 'icons/skybox/skybox.dmi'
	var/background_icon
	var/use_stars = FALSE
	var/use_overmap_details = TRUE
	var/star_path = 'icons/skybox/skybox.dmi'
	var/star_state = "stars"
	var/list/skybox_layer_cache = list()
	var/list/space_appearance_cache
	/// A round-global random parallax layer copied into player HUDs.
	var/atom/movable/screen/parallax_layer/random/random_layer
	/// Weighted list with the parallax layers we can spawn.
	var/random_parallax_weights = list(
		/atom/movable/screen/parallax_layer/random/space_gas = 35,
		PARALLAX_NONE = 30,
	)

/datum/controller/subsystem/parallax/Initialize()
	build_space_appearances()
	set_random_parallax_layer(pick_weight(random_parallax_weights))
	planet_y_offset = rand(100, 160)
	planet_x_offset = rand(100, 160)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/parallax/Recover()
	skybox_layer_cache = SSparallax.skybox_layer_cache
	space_appearance_cache = SSparallax.space_appearance_cache
	random_layer = SSparallax.random_layer

/// Screen-space skybox layer order, back to front. Generated layers consume data built by build_skybox_layer_data().
/datum/controller/subsystem/parallax/proc/get_skybox_layer_types()
	var/static/list/skybox_layer_types = list(
		/atom/movable/screen/parallax_layer/skybox/backdrop,
		/atom/movable/screen/parallax_layer/skybox/stars,
		/atom/movable/screen/parallax_layer/skybox/field_debris,
		/atom/movable/screen/parallax_layer/skybox/planet,
		/atom/movable/screen/parallax_layer/skybox/ships_stations,
		/atom/movable/screen/parallax_layer/skybox/wrecks,
		/atom/movable/screen/parallax_layer/skybox/events,
		/atom/movable/screen/parallax_layer/skybox/warp,
	)
	return skybox_layer_types

/datum/controller/subsystem/parallax/proc/build_space_appearances()
	starlight_color = SSatlas.current_sector.starlight_color
	space_appearance_cache = new(26)
	for (var/i in 0 to 25)
		var/mutable_appearance/dust = mutable_appearance('icons/turf/space_dust.dmi', "[i]")
		dust.plane = PLANE_SPACE_PARALLAX
		dust.alpha = 80
		dust.blend_mode = BLEND_ADD

		var/mutable_appearance/space = new /mutable_appearance(/turf/space)
		space.name = "space"
		space.plane = PLANE_SPACE
		space.icon_state = "white"
		space.overlays += dust
		space_appearance_cache[i + 1] = space.appearance

/datum/controller/subsystem/parallax/proc/get_skybox_layer_data(z)
	if(!z)
		return

	var/z_key = "[z]"
	if(!skybox_layer_cache[z_key])
		var/list/layer_data = build_skybox_layer_data(z)
		skybox_layer_cache[z_key] = layer_data
		if(SSatlas.current_map.use_overmap)
			var/obj/effect/overmap/visitable/O = GLOB.map_sectors[z_key]
			if(istype(O))
				for(var/zlevel in O.map_z)
					skybox_layer_cache["[zlevel]"] = layer_data
	return skybox_layer_cache[z_key]

/datum/controller/subsystem/parallax/proc/build_skybox_layer_data(z)
	var/list/layer_data = list()

	layer_data["sector_icon"] = background_icon || SSatlas.current_sector.skybox_icon
	layer_data["use_stars"] = use_stars

	if(SSatlas.current_map.use_overmap && use_overmap_details)
		var/obj/effect/overmap/visitable/O = GLOB.map_sectors["[z]"]
		if(istype(O))
			append_skybox_layer_entry(layer_data, O.generate_skybox(), get_overmap_skybox_layer_type(O))
			for(var/obj/effect/overmap/visitable/other in O.loc)
				if(other != O)
					append_skybox_layer_entry(layer_data, other.get_skybox_representation(), get_overmap_skybox_layer_type(other))

	for(var/datum/event/E in SSevents.active_events)
		if(E.has_skybox_image && E.isRunning && (z in E.affecting_z))
			var/event_layer_type = istype(E, /datum/event/bluespace_jump) ? /atom/movable/screen/parallax_layer/skybox/warp : /atom/movable/screen/parallax_layer/skybox/events
			append_skybox_layer_entry(layer_data, E.get_skybox_image(), event_layer_type)

	return layer_data

/datum/controller/subsystem/parallax/proc/append_skybox_layer_entry(list/target, entry, layer_type = /atom/movable/screen/parallax_layer/skybox/field_debris)
	if(!target || !entry)
		return
	if(islist(entry))
		for(var/subentry in entry)
			append_skybox_layer_entry(target, subentry, layer_type)
		return

	var/resolved_layer_type = get_appearance_skybox_layer_type(entry, layer_type)
	if(istype(entry, /image))
		var/image/I = entry
		I.appearance_flags |= RESET_COLOR

	var/list/layer_entries = target[resolved_layer_type]
	if(!layer_entries)
		layer_entries = list()
		target[resolved_layer_type] = layer_entries
	layer_entries += entry

/datum/controller/subsystem/parallax/proc/get_overmap_skybox_layer_type(obj/effect/overmap/overmap_object)
	if(istype(overmap_object, /obj/effect/overmap/visitable/sector/exoplanet))
		return /atom/movable/screen/parallax_layer/skybox/planet
	if(istype(overmap_object, /obj/effect/overmap/visitable/ship))
		return /atom/movable/screen/parallax_layer/skybox/ships_stations
	if(istype(overmap_object, /obj/effect/overmap/visitable/sector))
		return /atom/movable/screen/parallax_layer/skybox/wrecks
	return /atom/movable/screen/parallax_layer/skybox/field_debris

/datum/controller/subsystem/parallax/proc/get_appearance_skybox_layer_type(entry, fallback_layer_type)
	if(!istype(entry, /image))
		return fallback_layer_type

	var/image/I = entry
	if(I.icon == 'icons/skybox/planet.dmi' || I.icon == 'icons/skybox/lore_planets.dmi')
		return /atom/movable/screen/parallax_layer/skybox/planet
	if(I.icon == 'icons/skybox/subcapital_ships.dmi')
		return /atom/movable/screen/parallax_layer/skybox/ships_stations
	if(I.icon == 'icons/skybox/wrecks.dmi')
		return /atom/movable/screen/parallax_layer/skybox/wrecks
	if(I.icon == 'icons/skybox/skybox_rock_128.dmi')
		return /atom/movable/screen/parallax_layer/skybox/field_debris

	return fallback_layer_type

/datum/controller/subsystem/parallax/proc/rebuild_skybox_layers(var/list/zlevels)
	for(var/z in zlevels)
		var/list/affected_z = list(z)
		if(SSatlas.current_map.use_overmap)
			var/obj/effect/overmap/visitable/O = GLOB.map_sectors["[z]"]
			if(istype(O))
				affected_z |= O.map_z
		for(var/zlevel in affected_z)
			skybox_layer_cache -= "[zlevel]"

	for(var/client/C in GLOB.clients)
		C.refresh_parallax_skybox_layers()

/datum/controller/subsystem/parallax/proc/update_starlight()
	if(GLOB.config.starlight)
		for(var/turf/T in world)
			if(!T.use_starlight)
				continue
			var/area/turf_area = T.loc
			if(!istype(T, /turf/space) && !turf_area?.needs_starlight)
				continue
			T.update_starlight()
			CHECK_TICK

	for(var/obj/effect/map_effect/perma_light/perma_light in world)
		if(!perma_light.uses_starlight_color)
			continue
		perma_light.set_light(perma_light.light_range, SSatlas.current_sector.starlight_power, starlight_color)
		CHECK_TICK

//Update skyboxes. Called by universes, for now.
/datum/controller/subsystem/parallax/proc/change_skybox(new_state = background_icon, new_color, new_use_stars, new_use_overmap_details)
	if(isnull(new_color))
		new_color = starlight_color
	if(isnull(new_use_stars))
		new_use_stars = use_stars
	if(isnull(new_use_overmap_details))
		new_use_overmap_details = use_overmap_details

	var/need_rebuild = FALSE
	var/need_starlight_update = FALSE
	if(new_state != background_icon)
		background_icon = new_state
		need_rebuild = TRUE

	if(new_color != starlight_color)
		starlight_color = new_color
		need_starlight_update = TRUE

	if(new_use_stars != use_stars)
		use_stars = new_use_stars
		need_rebuild = TRUE

	if(new_use_overmap_details != use_overmap_details)
		use_overmap_details = new_use_overmap_details
		need_rebuild = TRUE

	if(need_rebuild)
		skybox_layer_cache.Cut()

		for(var/client/C in GLOB.clients)
			C.refresh_parallax_skybox_layers()

	if(need_starlight_update)
		update_starlight()

/// Generate a random layer for parallax.
/datum/controller/subsystem/parallax/proc/set_random_parallax_layer(picked_parallax)
	QDEL_NULL(random_layer)
	if(picked_parallax == PARALLAX_NONE)
		return

	random_layer = new picked_parallax(null, null, null, TRUE)
	RegisterSignal(random_layer, COMSIG_QDELETING, PROC_REF(clear_references))
	random_layer.get_random_look()

/// Change the random parallax layer after it has already been set.
/datum/controller/subsystem/parallax/proc/swap_out_random_parallax_layer(atom/movable/screen/parallax_layer/new_type, update_player_huds = TRUE)
	set_random_parallax_layer(new_type)

	if(!update_player_huds)
		return

	for(var/client/client as anything in GLOB.clients)
		client?.parallax_rock?.set_layer_settings(0, FALSE, TRUE)
		client.mob?.hud_used?.update_parallax_pref()

/datum/controller/subsystem/parallax/proc/clear_references()
	SIGNAL_HANDLER
	random_layer = null

/// Return the most dominant color, if the random layer has one.
/datum/controller/subsystem/parallax/proc/get_parallax_color()
	var/atom/movable/screen/parallax_layer/random/space_gas/gas = random_layer
	if(!istype(gas))
		return

	return gas.parallax_color

#undef PARALLAX_NONE
