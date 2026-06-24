/// Decides if parallax should be rendered and sets it up for this HUD
/datum/hud/proc/check_parallax()
	if(!mymob)
		return

	var/client/displaying_client = mymob.canon_client || mymob.client
	if(!displaying_client)
		return

	if(isnull(displaying_client.parallax_rock))
		displaying_client.parallax_rock = new(null, null, displaying_client)

	apply_parallax_pref()
	var/atom/movable/screen/parallax_home/rock = displaying_client.parallax_rock

	if(rock.displaying_layers)
		ADD_TRAIT(src, TRAIT_PARALLAX_DISPLAYED, TRAIT_GENERIC)
		displaying_client.screen |= rock
	else
		REMOVE_TRAIT(src, TRAIT_PARALLAX_DISPLAYED, TRAIT_GENERIC)
		displaying_client.screen -= rock

/datum/hud/proc/apply_parallax_pref()
	var/client/displaying_client = mymob.canon_client || mymob.client
	var/atom/movable/screen/parallax_home/rock = displaying_client?.parallax_rock
	if(!rock)
		return

	if(displaying_client.prefs?.toggles_secondary & PARALLAX_DISABLED)
		rock.set_layer_settings(layers_to_draw = 0, draw_aurora_skybox = FALSE, animate_parallax = FALSE)
		return

	if(displaying_client.prefs?.toggles_secondary & PARALLAX_IS_STATIC)
		rock.set_layer_settings(layers_to_draw = 1, draw_aurora_skybox = TRUE, animate_parallax = FALSE)
		return

	rock.set_layer_settings(layers_to_draw = 4, draw_aurora_skybox = TRUE, animate_parallax = TRUE)

/datum/hud/proc/update_parallax_pref()
	var/client/displaying_client = mymob?.canon_client || mymob?.client
	if(!displaying_client)
		return
	check_parallax()
	update_parallax()

/// This sets which way the current area wants parallax to move
/datum/hud/proc/set_parallax_movedir(new_parallax_movedir = NONE, skip_windups = FALSE)
	var/client/displaying_client = mymob?.canon_client || mymob?.client
	if(!displaying_client?.parallax_rock)
		return FALSE
	if(new_parallax_movedir == displaying_client.parallax_movedir)
		return FALSE

	var/animation_dir = new_parallax_movedir || displaying_client.parallax_movedir
	var/matrix/new_transform
	switch(animation_dir)
		if(NORTH)
			new_transform = matrix(1, 0, 0, 0, 1, 480)
		if(SOUTH)
			new_transform = matrix(1, 0, 0, 0, 1, -480)
		if(EAST)
			new_transform = matrix(1, 0, 480, 0, 1, 0)
		if(WEST)
			new_transform = matrix(1, 0, -480, 0, 1, 0)

	var/longest_timer = 0
	for(var/key in displaying_client.parallax_animate_timers)
		deltimer(displaying_client.parallax_animate_timers[key])
	displaying_client.parallax_animate_timers = list()

	for(var/atom/movable/screen/parallax_layer/layer as anything in displaying_client.parallax_rock.parallax_layers)
		var/scaled_time = PARALLAX_LOOP_TIME / max(layer.speed, 0.1)
		if(new_parallax_movedir == NONE)
			scaled_time = PARALLAX_LOOP_TIME
		longest_timer = max(longest_timer, scaled_time)

		if(skip_windups)
			update_parallax_motionblur(displaying_client, layer, new_parallax_movedir, new_transform)
			continue

		layer.transform = new_transform
		animate(layer, transform = matrix(), time = scaled_time, easing = QUAD_EASING | (new_parallax_movedir ? EASE_IN : EASE_OUT))
		if(new_parallax_movedir == NONE)
			continue

		animate(transform = new_transform, time = 0)
		animate(transform = matrix(), time = scaled_time / 2)
		displaying_client.parallax_animate_timers[layer] = addtimer(CALLBACK(src, PROC_REF(update_parallax_motionblur), displaying_client, layer, new_parallax_movedir, new_transform), scaled_time, TIMER_CLIENT_TIME|TIMER_STOPPABLE)

	displaying_client.dont_animate_parallax = world.time + min(longest_timer, PARALLAX_LOOP_TIME)
	displaying_client.parallax_movedir = new_parallax_movedir
	return TRUE

/datum/hud/proc/update_parallax_motionblur(client/displaying_client, atom/movable/screen/parallax_layer/layer, new_parallax_movedir, matrix/new_transform)
	if(!displaying_client || QDELETED(layer))
		return
	displaying_client.parallax_animate_timers -= layer

	var/scaled_time = (PARALLAX_LOOP_TIME / max(layer.speed, 0.1)) / 2
	animate(layer, transform = new_transform, time = 0, loop = -1, flags = ANIMATION_END_NOW)
	animate(transform = matrix(), time = scaled_time)

/datum/hud/proc/update_parallax()
	var/client/displaying_client = mymob?.canon_client || mymob?.client
	var/atom/movable/screen/parallax_home/rock = displaying_client?.parallax_rock
	if(!rock || !rock.displaying_layers)
		return

	var/turf/posobj = get_turf(displaying_client.eye)
	if(!posobj)
		return

	rock.set_skybox_z(posobj.z)

	var/area/areaobj = posobj.loc
	set_parallax_movedir(areaobj?.parallax_movedir || NONE)

	if(!displaying_client.previous_turf || (displaying_client.previous_turf.z != posobj.z))
		displaying_client.previous_turf = posobj

	var/offset_x = posobj.x - displaying_client.previous_turf.x
	var/offset_y = posobj.y - displaying_client.previous_turf.y

	var/glide_size = max(mymob.glide_size, 1)
	var/glide_rate = round(ICON_SIZE_ALL / glide_size * world.tick_lag, world.tick_lag)
	displaying_client.previous_turf = posobj

	var/largest_change = max(abs(offset_x), abs(offset_y))
	var/max_allowed_dist = (glide_rate / world.tick_lag) + 1
	var/run_parallax = (rock.animate_parallax && glide_rate && !areaobj?.parallax_movedir && displaying_client.dont_animate_parallax <= world.time && largest_change <= max_allowed_dist)

	for(var/atom/movable/screen/parallax_layer/parallax_layer as anything in rock.parallax_layers)
		var/our_speed = parallax_layer.speed
		var/change_x
		var/change_y
		var/old_x = parallax_layer.offset_x
		var/old_y = parallax_layer.offset_y
		if(parallax_layer.absolute)
			change_x = (posobj.x - SSparallax.planet_x_offset) * our_speed + old_x
			change_y = (posobj.y - SSparallax.planet_y_offset) * our_speed + old_y
		else
			change_x = offset_x * our_speed
			change_y = offset_y * our_speed

			if(parallax_layer.tile_layer)
				if(old_x - change_x > 240)
					parallax_layer.offset_x -= 480
					parallax_layer.pixel_w = parallax_layer.base_pixel_w + parallax_layer.offset_x
				else if(old_x - change_x < -240)
					parallax_layer.offset_x += 480
					parallax_layer.pixel_w = parallax_layer.base_pixel_w + parallax_layer.offset_x
				if(old_y - change_y > 240)
					parallax_layer.offset_y -= 480
					parallax_layer.pixel_z = parallax_layer.base_pixel_z + parallax_layer.offset_y
				else if(old_y - change_y < -240)
					parallax_layer.offset_y += 480
					parallax_layer.pixel_z = parallax_layer.base_pixel_z + parallax_layer.offset_y

		parallax_layer.offset_x -= change_x
		parallax_layer.offset_y -= change_y

		var/new_pixel_w = parallax_layer.base_pixel_w + round(parallax_layer.offset_x, 1)
		var/new_pixel_z = parallax_layer.base_pixel_z + round(parallax_layer.offset_y, 1)
		if(run_parallax && (largest_change * our_speed > 1))
			animate(parallax_layer, pixel_w = new_pixel_w, pixel_z = new_pixel_z, time = glide_rate)
		else
			parallax_layer.pixel_w = new_pixel_w
			parallax_layer.pixel_z = new_pixel_z

/atom/movable/proc/update_parallax_contents()
	var/list/client_mobs = LAZYACCESS(important_recursive_contents, RECURSIVE_CONTENTS_CLIENT_MOBS)
	for(var/mob/client_mob as anything in client_mobs)
		if(client_mob?.client?.parallax_rock?.displaying_layers && client_mob.hud_used)
			client_mob.hud_used.update_parallax()

/mob/proc/update_parallax_teleport()
	if(client?.eye && hud_used && client?.parallax_rock?.displaying_layers)
		var/area/areaobj = get_area(client.eye)
		hud_used.set_parallax_movedir(areaobj?.parallax_movedir || NONE, TRUE)

/client/proc/refresh_parallax_skybox()
	if(parallax_rock)
		parallax_rock.refresh_aurora_layers()
	mob?.hud_used?.update_parallax_pref()

/// Root object for parallax. All parallax layers are drawn onto this and managed here.
/atom/movable/screen/parallax_home
	icon = null
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/list/atom/movable/screen/parallax_layer/parallax_layers = list()
	var/list/atom/movable/screen/parallax_layer/parallax_layers_cached = list()
	var/layers_to_draw = 0
	var/draw_aurora_skybox = TRUE
	var/displaying_layers = FALSE
	var/animate_parallax = FALSE
	var/client/owner
	var/current_skybox_z

/atom/movable/screen/parallax_home/Initialize(mapload, datum/hud/hud_owner, client/owner)
	. = ..()
	src.owner = owner

/atom/movable/screen/parallax_home/Destroy()
	clear_layers()
	owner = null
	return ..()

/atom/movable/screen/parallax_home/proc/display_layers()
	if(displaying_layers || !length(parallax_layers_cached))
		return
	parallax_layers = parallax_layers_cached
	vis_contents = parallax_layers_cached
	displaying_layers = TRUE

/atom/movable/screen/parallax_home/proc/hide_layers()
	if(!displaying_layers)
		return
	parallax_layers = list()
	vis_contents = list()
	displaying_layers = FALSE

/atom/movable/screen/parallax_home/proc/set_layer_settings(layers_to_draw, draw_aurora_skybox, animate_parallax)
	src.animate_parallax = animate_parallax
	if(src.layers_to_draw == layers_to_draw && src.draw_aurora_skybox == draw_aurora_skybox)
		return
	src.layers_to_draw = layers_to_draw
	src.draw_aurora_skybox = draw_aurora_skybox
	regenerate_layers()

/atom/movable/screen/parallax_home/proc/generate_space_layer(index)
	switch(index)
		if(1)
			return new /atom/movable/screen/parallax_layer/layer_1(null, null, owner)
		if(2)
			return new /atom/movable/screen/parallax_layer/layer_2(null, null, owner)
		if(3)
			return new /atom/movable/screen/parallax_layer/planet(null, null, owner)
		if(4)
			if(SSparallax.random_layer)
				return new SSparallax.random_layer.type(null, null, owner, FALSE, SSparallax.random_layer)
			return new /atom/movable/screen/parallax_layer/layer_3(null, null, owner)
		if(5)
			return new /atom/movable/screen/parallax_layer/layer_3(null, null, owner)

/atom/movable/screen/parallax_home/proc/regenerate_layers()
	clear_layers()
	if(layers_to_draw == 0 && !draw_aurora_skybox)
		return

	parallax_layers_cached = list()
	if(draw_aurora_skybox)
		var/atom/movable/screen/parallax_layer/aurora_skybox/aurora_layer = new(null, null, owner)
		if(current_skybox_z)
			aurora_layer.set_z(current_skybox_z)
		parallax_layers_cached += aurora_layer

	for(var/space_layer in 1 to layers_to_draw)
		var/atom/movable/screen/parallax_layer/parallax = generate_space_layer(space_layer)
		if(parallax)
			parallax_layers_cached += parallax

	display_layers()

/atom/movable/screen/parallax_home/proc/clear_layers()
	hide_layers()
	QDEL_LIST(parallax_layers_cached)

/atom/movable/screen/parallax_home/proc/set_skybox_z(new_z)
	if(current_skybox_z == new_z)
		return
	current_skybox_z = new_z
	refresh_aurora_layers()

/atom/movable/screen/parallax_home/proc/refresh_aurora_layers()
	for(var/atom/movable/screen/parallax_layer/aurora_skybox/layer as anything in parallax_layers_cached)
		layer.set_z(current_skybox_z)

/atom/movable/screen/parallax_layer
	icon = 'icons/effects/parallax.dmi'
	var/speed = 1
	var/offset_x = 0
	var/offset_y = 0
	var/base_pixel_w = 0
	var/base_pixel_z = 0
	var/absolute = FALSE
	var/tile_layer = TRUE
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER
	blend_mode = BLEND_ADD
	plane = PLANE_SPACE_PARALLAX
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/working_view = ""
	var/client/owner

/atom/movable/screen/parallax_layer/Initialize(mapload, datum/hud/hud_owner, client/owner, template = FALSE)
	. = ..()
	if(template)
		return
	if(!owner)
		return INITIALIZE_HINT_QDEL

	src.owner = owner
	update_o(owner.view || world.view)

/atom/movable/screen/parallax_layer/Destroy()
	owner = null
	return ..()

/atom/movable/screen/parallax_layer/proc/update_o(new_view)
	if(working_view == new_view)
		return
	working_view = new_view
	rebuild_overlays()

/atom/movable/screen/parallax_layer/proc/rebuild_overlays()
	overlays.Cut()
	if(!tile_layer)
		return

	var/overlay_view = working_view || world.view
	var/pixel_grid_size = ICON_SIZE_ALL * 15
	var/parallax_scaler = ICON_SIZE_ALL / pixel_grid_size
	var/list/viewscales = getviewsize(overlay_view)
	var/countx = (CEILING((viewscales[1] / 2) * parallax_scaler, 1) + 1)
	var/county = (CEILING((viewscales[2] / 2) * parallax_scaler, 1) + 1)
	for(var/x in -countx to countx)
		for(var/y in -county to county)
			if(x == 0 && y == 0)
				continue
			var/mutable_appearance/texture_overlay = tileable_appearance()
			texture_overlay.pixel_w += pixel_grid_size * x
			texture_overlay.pixel_z += pixel_grid_size * y
			overlays += texture_overlay

/atom/movable/screen/parallax_layer/proc/tileable_appearance()
	return mutable_appearance(icon, icon_state)

/atom/movable/screen/parallax_layer/layer_1
	icon_state = "layer1"
	speed = 0.6
	layer = 1

/atom/movable/screen/parallax_layer/layer_2
	icon_state = "layer2"
	speed = 1
	layer = 2

/atom/movable/screen/parallax_layer/layer_3
	icon_state = "layer3"
	speed = 1.4
	layer = 3

/atom/movable/screen/parallax_layer/planet
	icon_state = "planet"
	blend_mode = BLEND_OVERLAY
	absolute = TRUE
	speed = 3
	layer = 30

/atom/movable/screen/parallax_layer/planet/Initialize(mapload, datum/hud/hud_owner, client/owner)
	. = ..()
	if(!owner)
		return
	var/static/list/connections = list(
		COMSIG_MOVABLE_Z_CHANGED = PROC_REF(on_z_change),
		COMSIG_MOB_LOGOUT = PROC_REF(on_mob_logout),
	)
	AddComponent(/datum/component/connect_mob_behalf, owner, connections)
	on_z_change(owner.mob)

/atom/movable/screen/parallax_layer/planet/proc/on_mob_logout(mob/source)
	SIGNAL_HANDLER
	var/client/boss = source.canon_client
	on_z_change(boss?.mob)

/atom/movable/screen/parallax_layer/planet/proc/on_z_change(mob/source)
	SIGNAL_HANDLER
	var/client/boss = source?.client || source?.canon_client
	var/turf/posobj = get_turf(boss?.eye)
	if(!posobj)
		return
	set_invisibility(is_station_level(posobj.z) ? 0 : INVISIBILITY_ABSTRACT)

/atom/movable/screen/parallax_layer/planet/update_o()
	return

/// Aurora's current static skybox composite, hosted as a tg-style parallax layer.
/atom/movable/screen/parallax_layer/aurora_skybox
	icon = null
	icon_state = null
	speed = 1
	layer = 0
	tile_layer = FALSE
	blend_mode = BLEND_DEFAULT
	base_pixel_w = -128
	base_pixel_z = -128
	var/current_z

/atom/movable/screen/parallax_layer/aurora_skybox/proc/set_z(new_z)
	if(!new_z || current_z == new_z)
		return
	current_z = new_z
	overlays.Cut()
	overlays += SSskybox.get_skybox(current_z)

/// Parallax layers that vary between rounds
/atom/movable/screen/parallax_layer/random
	blend_mode = BLEND_OVERLAY
	speed = 2
	layer = 3

/atom/movable/screen/parallax_layer/random/Initialize(mapload, datum/hud/hud_owner, client/owner, template, atom/movable/screen/parallax_layer/random/twin)
	. = ..()
	if(twin)
		copy_parallax(twin)

/atom/movable/screen/parallax_layer/random/proc/get_random_look()
	return

/atom/movable/screen/parallax_layer/random/proc/copy_parallax(atom/movable/screen/parallax_layer/random/twin)
	return

/atom/movable/screen/parallax_layer/random/space_gas
	icon_state = "space_gas"
	var/possible_colors = list(COLOR_TEAL, COLOR_GREEN, COLOR_SILVER, COLOR_YELLOW, COLOR_CYAN, COLOR_ORANGE, COLOR_PURPLE)
	var/parallax_color

/atom/movable/screen/parallax_layer/random/space_gas/get_random_look()
	parallax_color = parallax_color || pick(possible_colors)

/atom/movable/screen/parallax_layer/random/space_gas/copy_parallax(atom/movable/screen/parallax_layer/random/space_gas/twin)
	parallax_color = twin.parallax_color
	add_atom_colour(parallax_color, ADMIN_COLOUR_PRIORITY)

/atom/movable/screen/parallax_layer/random/asteroids
	icon_state = "asteroids"
	layer = 4
