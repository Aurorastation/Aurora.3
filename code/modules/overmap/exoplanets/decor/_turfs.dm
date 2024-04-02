
/// Exoplanet turfs try to take the atmos and area of the exoplanet they were spawned on,
/// so that exoplanets have consistent atmosphere everywhere on the surface.
/// If not located on an exoplanet, default or mapped in atmos is kept.
/turf/simulated/floor/exoplanet
	name = "space land"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	has_resources = 1
	footstep_sound = /singleton/sound_category/asteroid_footstep
	turf_flags = TURF_FLAG_BACKGROUND

	does_footprint = TRUE

	var/diggable = 1
	var/dirt_color = "#7c5e42"
	var/has_edge_icon = TRUE

/turf/simulated/floor/exoplanet/New()
	// try to get the the atmos and area of the exoplanet
	if(SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
		if(istype(E))
			if(E.atmosphere)
				initial_gas = E.atmosphere.gas.Copy()
				temperature = E.atmosphere.temperature
			else
				initial_gas = list()
				temperature = T0C
			//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
			set_light(MINIMUM_USEFUL_LIGHT_RANGE, E.lightlevel, COLOR_WHITE)
			if(E.planetary_area && istype(loc, world.area))
				ChangeArea(src, E.planetary_area)
	// if not on an exoplanet, instead just keep the default or mapped in atmos
	..()

/turf/simulated/floor/exoplanet/attackby(obj/item/attacking_item, mob/user)
	if(diggable && istype(attacking_item, /obj/item/shovel))
		visible_message("<span class='notice'>\The [user] starts digging \the [src]</span>")
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			to_chat(user,"<span class='notice'>You dig a deep pit.</span>")
			new /obj/structure/pit(src)
			diggable = 0
		else
			to_chat(user,"<span class='notice'>You stop shoveling.</span>")
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
	if(has_edge_icon)
		cut_overlays()
		if(resource_indicator)
			add_overlay(resource_indicator)
		if(LAZYLEN(decals))
			add_overlay(decals)
		for(var/direction in GLOB.cardinal)
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

//Water
/turf/simulated/floor/exoplanet/water/update_icon()
	return

/turf/simulated/floor/exoplanet/water/shallow
	name = "shallow water"
	icon = 'icons/misc/beach.dmi'
	icon_state = "seashallow"
	footstep_sound = /singleton/sound_category/water_footstep

/turf/simulated/floor/exoplanet/water/shallow/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/reagent_containers/RG = attacking_item
	if (reagent_type && istype(RG) && RG.is_open_container() && RG.reagents)
		RG.reagents.add_reagent(reagent_type, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] from \the [src].</span>","<span class='notice'>You fill \the [RG] from \the [src].</span>")
	else
		return ..()

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty

//Snow
/turf/simulated/floor/exoplanet/snow
	name = "snow"
	icon = 'icons/turf/smooth/snow40.dmi'
	icon_state = "snow0"
	dirt_color = "#e3e7e8"
	footstep_sound = /singleton/sound_category/snow_footstep
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	canSmoothWith = list(
		/turf/simulated/floor/exoplanet/snow,
		/turf/simulated/wall,
		/turf/unsimulated/wall
	) //Smooths with walls but not the inverse. This way to avoid layering over walls.

/turf/simulated/floor/exoplanet/snow/Initialize()
	. = ..()
	pixel_x = -4
	pixel_y = -4
	icon_state = pick("snow[rand(1,2)]","snow0","snow0")
	SSicon_smooth.add_to_queue_neighbors(src)
	SSicon_smooth.add_to_queue(src)

/turf/simulated/floor/exoplanet/snow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	melt()

/turf/simulated/floor/exoplanet/snow/melt()
	ChangeTurf(/turf/simulated/floor/exoplanet/permafrost)

/turf/simulated/floor/exoplanet/permafrost
	name = "permafrost"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "permafrost"
	footstep_sound = /singleton/sound_category/asteroid_footstep

//Grass
/turf/simulated/floor/exoplanet/grass
	name = "grass"
	icon = 'icons/turf/jungle.dmi'
	icon_state = "greygrass"
	color = "#799c4b"
	footstep_sound = /singleton/sound_category/grass_footstep

/turf/simulated/floor/exoplanet/grass/Initialize()
	. = ..()
	if(SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
		if(istype(E) && E.grass_color)
			color = E.grass_color
	if(!resources)
		resources = list()
	if(prob(5))
		resources[ORE_URANIUM] = rand(1,3)
	if(prob(2))
		resources[ORE_DIAMOND] = 1

/turf/simulated/floor/exoplanet/grass/grove
	icon_state = "grove_grass1"
	color = null
	has_edge_icon = FALSE

/turf/simulated/floor/exoplanet/grass/grove/Initialize()
	. = ..()
	icon_state = "grove_grass[rand(1,2)]"

//Sand
/turf/simulated/floor/exoplanet/desert
	name = "sand"
	desc = "It's coarse and gets everywhere."
	dirt_color = "#ae9e66"
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/simulated/floor/exoplanet/desert/Initialize()
	. = ..()
	icon_state = "desert[rand(0,4)]"

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

/turf/unsimulated/planet_edge/CollidedWith(atom/movable/A)
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
	if(!istype(E))
		return
	if(E.planetary_area && istype(loc, world.area))
		ChangeArea(src, E.planetary_area)
	var/new_x = A.x
	var/new_y = A.y
	if(x <= TRANSITIONEDGE)
		new_x = E.maxx - TRANSITIONEDGE - 1
	else if (x >= (E.maxx - TRANSITIONEDGE))
		new_x = TRANSITIONEDGE + 1
	else if (y <= TRANSITIONEDGE)
		new_y = E.maxy - TRANSITIONEDGE - 1
	else if (y >= (E.maxy - TRANSITIONEDGE))
		new_y = TRANSITIONEDGE + 1

	var/turf/T = locate(new_x, new_y, A.z)
	if(T && !T.density)
		A.forceMove(T)
		if(isliving(A))
			var/mob/living/L = A
			if(L.pulling)
				var/atom/movable/AM = L.pulling
				AM.forceMove(T)
