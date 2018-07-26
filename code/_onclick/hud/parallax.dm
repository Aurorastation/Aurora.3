/*
 * This file handles all parallax-related business once the parallax itself is initialized with the rest of the HUD
 */
#define PARALLAX_IMAGE_WIDTH 8
#define PARALLAX_IMAGE_TILES (PARALLAX_IMAGE_WIDTH**2)
#define GRID_WIDTH 3
#define PARALLAX_SCALED_WIDTH (PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE)
#define PARALLAX_SCALED_GRID_WIDTH (PARALLAX_SCALED_WIDTH*GRID_WIDTH)

/obj/screen/parallax
	var/base_offset_x = 0
	var/base_offset_y = 0
	mouse_opacity = 0
	icon = 'icons/turf/space.dmi'
	icon_state = "blank"
	name = "space parallax"
	screen_loc = "CENTER,CENTER"
	blend_mode = BLEND_ADD
	layer = AREA_LAYER
	plane = PLANE_SPACE_PARALLAX
	var/parallax_speed = 0

/obj/screen/plane_master
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	screen_loc = "CENTER,CENTER"

/obj/screen/plane_master/parallax_master
	plane = PLANE_SPACE_PARALLAX
	blend_mode = BLEND_MULTIPLY
	color = list(
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		0,0,0,0,
		0,0,0,1
	)

/obj/screen/plane_master/parallax_spacemaster //Turns space white, causing the parallax to only show in areas with opacity. Somehow
	plane = PLANE_SPACE_BACKGROUND
	color = list(
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		1,1,1,1
	)

/obj/screen/plane_master/parallax_spacemaster/New()
	..()
	overlays += image(icon = 'icons/mob/screen/generic.dmi', icon_state = "blank")
	if(universe)
		universe.convert_parallax(src)

/obj/screen/plane_master/parallax_dustmaster
	plane = PLANE_SPACE_DUST
	color = list(0,0,0,0)

/datum/hud/proc/update_parallax_existence()
	if(!SSparallax.parallax_initialized)
		return
	initialize_parallax()
	update_parallax()
	update_parallax_values()

/datum/hud/proc/initialize_parallax()
	var/client/C = mymob.client

	if(!C.parallax_master)
		C.parallax_master = new /obj/screen/plane_master/parallax_master
	if(!C.parallax_spacemaster)
		C.parallax_spacemaster = new /obj/screen/plane_master/parallax_spacemaster
	if(!C.parallax_dustmaster)
		C.parallax_dustmaster = new /obj/screen/plane_master/parallax_dustmaster

	if(!C.parallax.len)
		for(var/obj/screen/parallax/bgobj in SSparallax.parallax_icon)
			var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax
			parallax_layer.appearance = bgobj.appearance
			parallax_layer.base_offset_x = bgobj.base_offset_x
			parallax_layer.base_offset_y = bgobj.base_offset_y
			parallax_layer.parallax_speed = bgobj.parallax_speed
			parallax_layer.screen_loc = bgobj.screen_loc
			C.parallax += parallax_layer
			if(bgobj.parallax_speed)
				C.parallax_movable += parallax_layer

	C.screen |= C.parallax_dustmaster

/datum/hud/proc/update_parallax()
	var/client/C = mymob.client
	if(C.prefs.toggles_secondary & PARALLAX_SPACE)
		for(var/obj/screen/parallax/bgobj in C.parallax)
			C.screen |= bgobj
		C.screen |= C.parallax_master
		C.screen |= C.parallax_spacemaster
		if(C.prefs.toggles_secondary & PARALLAX_DUST)
			C.parallax_dustmaster.color = list(
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			0,0,0,1)
		else
			C.parallax_dustmaster.color = list(0,0,0,0)
	else
		for(var/obj/screen/parallax/bgobj in C.parallax)
			C.screen -= bgobj
		C.screen -= C.parallax_master
		C.screen -= C.parallax_spacemaster
		C.parallax_dustmaster.color = list(0,0,0,0)

/datum/hud/proc/update_parallax_values()
	var/client/C = mymob.client
	if(!SSparallax.parallax_initialized)
		return

	if (C.prefs.toggles_secondary & PARALLAX_IS_STATIC)
		return

	//ACTUALLY MOVING THE PARALLAX
	var/turf/posobj = C.eye ? C.eye:loc : C.mob:loc
	if (!isturf(posobj))
		posobj = get_turf(posobj)

	if(!posobj || (!(locate(/turf/space) in RANGE_TURFS(C.view, posobj)) && !(locate(/turf/simulated/open) in RANGE_TURFS(C.view, posobj))))
		return

	if(!C.previous_turf || (C.previous_turf.z != posobj.z))
		C.previous_turf = posobj

	//Doing it this way prevents parallax layers from "jumping" when you change Z-Levels.
	C.parallax_offset_x += posobj.x - C.previous_turf.x
	C.parallax_offset_y += posobj.y - C.previous_turf.y

	C.previous_turf = posobj

	var/offsetx = C.parallax_offset_x * C.prefs.parallax_speed
	var/offsety = C.parallax_offset_y * C.prefs.parallax_speed

	for(var/thing in C.parallax_movable)
		var/obj/screen/parallax/bgobj = thing
		var/accumulated_offset_x = bgobj.base_offset_x - round(offsetx * bgobj.parallax_speed)
		var/accumulated_offset_y = bgobj.base_offset_y - round(offsety * bgobj.parallax_speed)

		if(accumulated_offset_x > PARALLAX_SCALED_WIDTH)
			accumulated_offset_x -= PARALLAX_SCALED_GRID_WIDTH //3x3 grid, 15 tiles * 64 icon_size * 3 grid size
		if(accumulated_offset_x < -(PARALLAX_SCALED_WIDTH*2))
			accumulated_offset_x += PARALLAX_SCALED_GRID_WIDTH

		if(accumulated_offset_y > PARALLAX_SCALED_WIDTH)
			accumulated_offset_y -= PARALLAX_SCALED_GRID_WIDTH
		if(accumulated_offset_y < -(PARALLAX_SCALED_WIDTH*2))
			accumulated_offset_y += PARALLAX_SCALED_GRID_WIDTH

		bgobj.screen_loc = "CENTER:[accumulated_offset_x],CENTER:[accumulated_offset_y]"

//Parallax generation code below

#define PARALLAX4_ICON_NUMBER 20
#define PARALLAX3_ICON_NUMBER 14
#define PARALLAX2_ICON_NUMBER 10

/proc/create_global_parallax_icons()
	var/list/plane1 = list()
	var/list/plane2 = list()
	var/list/plane3 = list()
	var/list/pixel_x = list()
	var/list/pixel_y = list()
	var/index = 1
	for(var/i = 0 to (PARALLAX_IMAGE_TILES-1))
		for(var/j = 1 to GRID_WIDTH**2)
			plane1 += rand(1,26)
			plane2 += rand(1,26)
			plane3 += rand(1,26)
		pixel_x += WORLD_ICON_SIZE * (i%PARALLAX_IMAGE_WIDTH)
		pixel_y += WORLD_ICON_SIZE * round(i/PARALLAX_IMAGE_WIDTH)

	for(var/i in 0 to ((GRID_WIDTH**2)-1))
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax

		var/list/L = list()
		for(var/j in 1 to PARALLAX_IMAGE_TILES)
			if(plane1[j+i*PARALLAX_IMAGE_TILES] <= PARALLAX4_ICON_NUMBER)
				var/image/I = image('icons/turf/space_parallax4.dmi',"[plane1[j+i*PARALLAX_IMAGE_TILES]]")
				I.pixel_x = pixel_x[j]
				I.pixel_y = pixel_y[j]
				L += I

		parallax_layer.overlays = L
		parallax_layer.parallax_speed = 0
		parallax_layer.calibrate_parallax(i+1)
		SSparallax.parallax_icon[index] = parallax_layer
		index++

	for(var/i in 0 to ((GRID_WIDTH**2)-1))
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax

		var/list/L = list()
		for(var/j in 1 to PARALLAX_IMAGE_TILES)
			if(plane2[j+i*PARALLAX_IMAGE_TILES] <= PARALLAX3_ICON_NUMBER)
				var/image/I = image('icons/turf/space_parallax3.dmi',"[plane2[j+i*PARALLAX_IMAGE_TILES]]")
				I.pixel_x = pixel_x[j]
				I.pixel_y = pixel_y[j]
				L += I

		parallax_layer.overlays = L
		parallax_layer.parallax_speed = 0.5
		parallax_layer.calibrate_parallax(i+1)
		SSparallax.parallax_icon[index] = parallax_layer
		index++

	for(var/i in 0 to ((GRID_WIDTH**2)-1))
		var/obj/screen/parallax/parallax_layer = new /obj/screen/parallax
		var/list/L = list()
		for(var/j in 1 to PARALLAX_IMAGE_TILES)
			if(plane3[j+i*PARALLAX_IMAGE_TILES] <= PARALLAX2_ICON_NUMBER)
				var/image/I = image('icons/turf/space_parallax2.dmi',"[plane3[j+i*PARALLAX_IMAGE_TILES]]")
				I.pixel_x = pixel_x[j]
				I.pixel_y = pixel_y[j]
				L += I

		parallax_layer.overlays = L
		parallax_layer.parallax_speed = 1
		parallax_layer.calibrate_parallax(i+1)
		SSparallax.parallax_icon[index] = parallax_layer
		index++

	SSparallax.parallax_initialized = 1

/obj/screen/parallax/proc/calibrate_parallax(var/i)
	if(!i)
		return

	/* Placement of screen objects
	1	2	3
	4	5	6
	7	8	9
	*/

	base_offset_x = -PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE/2
	base_offset_y = -PARALLAX_IMAGE_WIDTH*WORLD_ICON_SIZE/2

//TODO: switch to grid size defines... somehow
	switch(i)
		if(1,4,7) //1 mod grid_size
			base_offset_x -= WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH
		if(3,6,9) //0 mod grid_size
			base_offset_x += WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH
	switch(i)
		if(1,2,3) //round(i/grid_size) = 0
			base_offset_y += WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH
		if(7,8,9) //round(i/grid_size) = 2
			base_offset_y -= WORLD_ICON_SIZE*PARALLAX_IMAGE_WIDTH

	screen_loc = "CENTER:[base_offset_x],CENTER:[base_offset_y]"

/client/proc/cleanup_parallax_references()
	parallax_dustmaster = null
	parallax_master = null
	parallax_spacemaster = null
	LAZYCLEARLIST(parallax)
	LAZYCLEARLIST(parallax_movable)

#undef GRID_WIDTH
#undef PARALLAX4_ICON_NUMBER
#undef PARALLAX3_ICON_NUMBER
#undef PARALLAX2_ICON_NUMBER
#undef PARALLAX_IMAGE_WIDTH
#undef PARALLAX_IMAGE_TILES
#undef PARALLAX_SCALED_WIDTH
#undef PARALLAX_SCALED_GRID_WIDTH
