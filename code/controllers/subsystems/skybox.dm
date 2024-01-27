SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = SS_INIT_PARALLAX
	flags = SS_NO_FIRE
	var/background_color
	var/skybox_icon = 'icons/skybox/skybox.dmi' //Path to our background. Lets us use anything we damn well please. Skyboxes need to be 736x736
	var/background_icon = "ceti"
	var/use_stars = FALSE
	var/use_overmap_details = TRUE
	var/star_path = 'icons/skybox/skybox.dmi'
	var/star_state = "stars"
	var/list/skybox_cache = list()
	var/list/space_appearance_cache


/datum/controller/subsystem/skybox/proc/build_space_appearances()
	space_appearance_cache = new(26)
	for (var/i in 0 to 25)
		var/mutable_appearance/dust = mutable_appearance('icons/turf/space_dust.dmi', "[i]")
		dust.plane = PLANE_SPACE_DUST
		dust.alpha = 80
		dust.blend_mode = BLEND_ADD

		var/mutable_appearance/space = new /mutable_appearance(/turf/space)
		space.name = "space"
		space.plane = PLANE_SPACE_BACKGROUND
		space.icon_state = "white"
		space.overlays += dust
		space_appearance_cache[i + 1] = space.appearance
		background_color = SSatlas.current_sector.starlight_color

/datum/controller/subsystem/skybox/Initialize()
	build_space_appearances()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/skybox/Recover()
	skybox_cache = SSskybox.skybox_cache

/datum/controller/subsystem/skybox/proc/get_skybox(z)
	if(!skybox_cache["[z]"])
		skybox_cache["[z]"] = generate_skybox(z)
		if(current_map.use_overmap)
			var/obj/effect/overmap/visitable/O = GLOB.map_sectors["[z]"]
			if(istype(O))
				for(var/zlevel in O.map_z)
					skybox_cache["[zlevel]"] = skybox_cache["[z]"]
	return skybox_cache["[z]"]

/datum/controller/subsystem/skybox/proc/generate_skybox(z)
	var/image/res = image(skybox_icon)
	res.appearance_flags = KEEP_TOGETHER

	var/sector_icon = SSatlas.current_sector.skybox_icon
	var/image/base = overlay_image(skybox_icon, sector_icon)

	if(use_stars)
		var/image/stars = overlay_image(skybox_icon, star_state, flags = RESET_COLOR)
		base.overlays += stars

	res.overlays += base

	if(current_map.use_overmap && use_overmap_details)
		var/obj/effect/overmap/visitable/O = GLOB.map_sectors["[z]"]
		if(istype(O))
			var/image/overmap = image(skybox_icon)
			overmap.overlays += O.generate_skybox()
			for(var/obj/effect/overmap/visitable/other in O.loc)
				if(other != O)
					overmap.overlays += other.get_skybox_representation()
			overmap.appearance_flags |= RESET_COLOR
			res.overlays += overmap

	for(var/datum/event/E in SSevents.active_events)
		if(E.has_skybox_image && E.isRunning && (z in E.affecting_z))
			var/image/skybox_effect = E.get_skybox_image()
			res.overlays += skybox_effect

	return res

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(var/list/zlevels)
	for(var/z in zlevels)
		skybox_cache["[z]"] = generate_skybox(z)

	for(var/client/C in GLOB.clients)
		C.update_skybox(1)

//Update skyboxes. Called by universes, for now.
/datum/controller/subsystem/skybox/proc/change_skybox(new_state, new_color, new_use_stars, new_use_overmap_details)
	var/need_rebuild = FALSE
	if(new_state != background_icon)
		background_icon = new_state
		need_rebuild = TRUE

	if(new_color != background_color)
		background_color = new_color
		need_rebuild = TRUE

	if(new_use_stars != use_stars)
		use_stars = new_use_stars
		need_rebuild = TRUE

	if(new_use_overmap_details != use_overmap_details)
		use_overmap_details = new_use_overmap_details
		need_rebuild = TRUE

	if(need_rebuild)
		skybox_cache.Cut()

		for(var/client/C)
			C.update_skybox(1)
