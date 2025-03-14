
/// Exoplanet turfs try to take the atmos and area of the exoplanet they were spawned on,
/// so that exoplanets have consistent atmosphere everywhere on the surface.
/// If not located on an exoplanet, default or mapped in atmos is kept.
/turf/simulated/floor/exoplanet
	name = "space land"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	has_resources = TRUE
	footstep_sound = /singleton/sound_category/asteroid_footstep
	turf_flags = TURF_FLAG_BACKGROUND

	var/diggable = 1
	var/dirt_color = "#7c5e42"
	var/has_edge_icon = TRUE

/turf/simulated/floor/exoplanet/New()
	// try to get the the atmos and area of the planet
	if(SSatlas.current_map.use_overmap)
		// if exoplanet
		var/datum/site = GLOB.map_sectors["[z]"]
		var/datum/template = GLOB.map_templates["[z]"]
		if(istype(site, /obj/effect/overmap/visitable/sector/exoplanet))
			var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = site
			if(exoplanet.atmosphere)
				initial_gas = exoplanet.atmosphere.gas.Copy()
				temperature = exoplanet.atmosphere.temperature
			else
				initial_gas = list()
				temperature = T0C
			//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
			set_light(MINIMUM_USEFUL_LIGHT_RANGE, exoplanet.lightlevel, exoplanet.lightcolor)
			if(exoplanet.planetary_area && istype(loc, world.area))
				change_area(loc, exoplanet.planetary_area)
		// if away site
		else if(istype(template, /datum/map_template/ruin/away_site))
			var/datum/map_template/ruin/away_site/away_site = template
			if(away_site.exoplanet_atmosphere)
				initial_gas = away_site.exoplanet_atmosphere.gas.Copy()
				temperature = away_site.exoplanet_atmosphere.temperature
			if(away_site.exoplanet_lightlevel && is_outside())
				set_light(MINIMUM_USEFUL_LIGHT_RANGE, away_site.exoplanet_lightlevel, away_site.exoplanet_lightcolor)

	// if not on an exoplanet, instead just keep the default or mapped in atmos
	..()

/turf/simulated/floor/exoplanet/attackby(obj/item/attacking_item, mob/user)
	if(diggable && istype(attacking_item, /obj/item/shovel))
		visible_message(SPAN_NOTICE("\The [user] starts digging \the [src]"))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			to_chat(user,SPAN_NOTICE("You dig a deep pit."))
			new /obj/structure/pit(src)
			diggable = 0
		else
			to_chat(user,SPAN_NOTICE("You stop shoveling."))
	else if(istype(attacking_item, /obj/item/stack/tile))
		var/obj/item/stack/tile/T = attacking_item
		if(T.use(1))
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			ChangeTurf(/turf/simulated/floor, FALSE, FALSE, FALSE, TRUE)
	else if(diggable && istype(attacking_item,/obj/item/material/minihoe))
		visible_message(SPAN_NOTICE("\The [user] starts clearing \the [src]"))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			to_chat(user, SPAN_NOTICE("You make a small clearing."))
			new /obj/structure/clearing(src)
			diggable = FALSE
		else
			to_chat(user, SPAN_NOTICE("You stop shoveling."))

/turf/simulated/floor/exoplanet/ex_act(severity)
	switch(severity)
		if(1)
			ChangeTurf(get_base_turf_by_area(src))
		if(2)
			if(prob(40))
				ChangeTurf(get_base_turf_by_area(src))

/turf/simulated/floor/exoplanet/Initialize()
	. = ..()
	footprint_color = dirt_color
	update_icon(1)

/turf/simulated/floor/exoplanet/update_icon(var/update_neighbors)
	if(initial_flooring)
		. = ..()

	else if(has_edge_icon)
		ClearOverlays()
		if(resource_indicator)
			AddOverlays(resource_indicator)
		if(LAZYLEN(decals))
			AddOverlays(decals)
		for(var/direction in GLOB.cardinals)
			var/turf/turf_to_check = get_step(src,direction)
			if(!istype(turf_to_check, type))
				var/image/rock_side = image(icon, "edge[pick(0,1,2)]", dir = turn(direction, 180))
				switch(direction)
					if(NORTH)
						rock_side.pixel_y += world.icon_size
					if(SOUTH)
						rock_side.pixel_y -= world.icon_size
					if(EAST)
						rock_side.pixel_x += world.icon_size
					if(WEST)
						rock_side.pixel_x -= world.icon_size
				overlays += rock_side
			else if(update_neighbors)
				turf_to_check.update_icon()

/turf/simulated/floor/exoplanet/water/shallow
	name = "shallow water"
	desc = "Some water shallow enough to wade through."
	icon = 'icons/misc/beach.dmi'
	icon_state = "seashallow"
	footstep_sound = /singleton/sound_category/water_footstep

/turf/simulated/floor/exoplanet/permafrost
	name = "permafrost"
	desc = "The ground here is frozen solid by the cold."
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "permafrost"
	footstep_sound = /singleton/sound_category/asteroid_footstep

/turf/simulated/floor/exoplanet/mineral
	name = "sand"
	desc = "It's coarse and gets everywhere."
	dirt_color = "#544c31"
	footstep_sound = /singleton/sound_category/sand_footstep

//Concrete
/turf/simulated/floor/exoplanet/concrete
	name = "concrete"
	desc = "Stone-like artificial material."
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete0"

//Special world edge turf,
/turf/unsimulated/planet_edge
	name = "world's edge"
	desc = "Government didn't want you to see this!"
	density = TRUE
	blocks_air = TRUE
	dynamic_lighting = FALSE
	icon = null
	icon_state = null

/turf/unsimulated/planet_edge/Initialize()
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
	if(!istype(E))
		return
	var/nx = x
	if (x <= TRANSITIONEDGE)
		nx = x + (E.maxx - 2*TRANSITIONEDGE) - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		nx = x - (E.maxx  - 2*TRANSITIONEDGE) + 1

	var/ny = y
	if(y <= TRANSITIONEDGE)
		ny = y + (E.maxy - 2*TRANSITIONEDGE) - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		ny = y - (E.maxy - 2*TRANSITIONEDGE) + 1

	var/turf/NT = locate(nx, ny, z)
	if(NT)
		vis_contents = list(NT)

	//Need to put a mouse-opaque overlay there to prevent people turning/shooting towards ACTUAL location of vis_content things
	var/obj/effect/overlay/O = new(src)
	O.mouse_opacity = MOUSE_OPACITY_OPAQUE
	O.name = "distant terrain"
	O.desc = "You need to come over there to take a better look."

/turf/unsimulated/planet_edge/CollidedWith(atom/bumped_atom)
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
	if(!istype(E))
		return
	if(E.planetary_area && istype(loc, world.area))
		change_area(loc, E.planetary_area)
	var/new_x = bumped_atom.x
	var/new_y = bumped_atom.y
	if(x <= TRANSITIONEDGE)
		new_x = E.maxx - TRANSITIONEDGE - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		new_x = TRANSITIONEDGE + 1
	else if (y <= TRANSITIONEDGE)
		new_y = E.maxy - TRANSITIONEDGE - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		new_y = TRANSITIONEDGE + 1

	var/turf/T = locate(new_x, new_y, bumped_atom.z)
	if(T && !T.density)
		if(ismovable(bumped_atom))
			var/atom/movable/AM = bumped_atom
			AM.forceMove(T)
			if(isliving(AM))
				var/mob/living/L = bumped_atom
				if(L.pulling)
					var/atom/movable/pulling = L.pulling
					pulling.forceMove(T)
