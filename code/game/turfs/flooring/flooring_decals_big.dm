/// Big Floor Decals
/obj/effect/floor_decal/big
	name = "big floor decal"
	outline = FALSE
	var/decal_path
	var/list/decals

/obj/effect/floor_decal/big/Initialize()
	..()
	for(var/coordinate in decals)
		var/list/split_coordinate = splittext(coordinate, ",")
		var/turf/decal_turf = loc
		for(var/i = 1 to text2num(split_coordinate[1]))
			decal_turf = get_step(decal_turf, EAST)
		for(var/i = 1 to text2num(split_coordinate[2]))
			decal_turf = get_step(decal_turf, NORTH)
		new decal_path(decal_turf, null, null, FALSE, coordinate)
	return INITIALIZE_HINT_QDEL

/// SCC Preview
/obj/effect/floor_decal/big/scc_full
	name = "full 5x4 SCC logo"
	icon = 'icons/turf/decals/big/scc_5x4_preview.dmi'
	icon_state = "scc_preview"

	decal_path = "/obj/effect/floor_decal/scc"
	decals = list(
		"0,0", "1,0", "2,0", "3,0", "4,0",
		"0,1", "1,1", "2,1", "3,1", "4,1",
		"0,2", "1,2", "2,2", "3,2", "4,2",
		"0,3", "2,3", "4,3"
	)

// SCC
/obj/effect/floor_decal/scc
	name = "\improper 5x4 SCC logo"
	icon = 'icons/turf/decals/big/scc_5x4.dmi'
	icon_state = "0,0"

/// Sol Preview
/obj/effect/floor_decal/big/sol_full
	name = "full 5x5 Sol Alliance logo"
	icon = 'icons/turf/decals/big/sol_5x5_preview.dmi'
	icon_state = "sol_preview"

	decal_path = "/obj/effect/floor_decal/sol"
	decals = list(
		"0,0", "1,0", "2,0", "3,0", "4,0",
		"0,1", "1,1", "2,1", "3,1", "4,1",
		"0,2", "1,2", "2,2", "3,2", "4,2",
		"0,3", "1,3", "2,3", "3,3", "4,3",
		"0,4", "1,4", "2,4", "3,4", "4,4"
	)

/// Sol
/obj/effect/floor_decal/sol
	name = "\improper 5x5 Sol Alliance logo"
	icon = 'icons/turf/decals/big/sol_5x5.dmi'
	icon_state = "0,0"

/// Orion Express Preview
/obj/effect/floor_decal/big/ox_full
	name = "full 2x2 Orion Express logo"
	icon = 'icons/turf/decals/big/ox_2x2_preview.dmi'
	icon_state = "ox_preview"

	decal_path = "/obj/effect/floor_decal/ox"
	decals = list(
		"0,0", "1,0",
		"0,1", "1,1",
	)

/// Orion Express
/obj/effect/floor_decal/ox
	name = "\improper 2x2 Orion Express logo"
	icon = 'icons/turf/decals/big/ox_2x2.dmi'
	icon_state = "0,0"
