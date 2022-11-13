// These are objects that destroy themselves and add themselves to the
// decal list of the floor under them. Use them rather than distinct icon_states
// when mapping in interesting floor designs.

/obj/effect/floor_decal
	name = "floor decal"
	icon = 'icons/turf/flooring/decals.dmi'
	layer = TURF_LAYER + 0.01
	var/supplied_dir

/obj/effect/floor_decal/LateInitialize()
	var/turf/T = get_turf(src)
	var/list/floor_decals = SSicon_cache.floor_decals
	if(istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		var/cache_key = "[alpha]-[color]-[dir]-[icon_state]-[layer]"
		if(!floor_decals[cache_key])
			var/image/I = image(icon = src.icon, icon_state = src.icon_state, dir = src.dir)
			I.color = src.color
			I.alpha = src.alpha
			floor_decals[cache_key] = I
		if(!T.decals) T.decals = list()
		T.decals |= floor_decals[cache_key]
		T.add_overlay(floor_decals[cache_key])
		if(desc)
			T.desc += "<br>There is \a [src] on it with the following inscription:<br><i>[desc]</i>"

	qdel(src)

/obj/effect/floor_decal/Initialize(mapload, var/newdir, var/newcolour, bypass = FALSE, var/set_icon_state)
	if (bypass && !mapload)
		return ..(mapload)

	if (newdir)
		supplied_dir = newdir

	if(newcolour)
		color = newcolour

	if (supplied_dir)
		set_dir(supplied_dir)

	if(set_icon_state)
		icon_state = set_icon_state

	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/floor_decal/reset
	name = "reset marker"

/obj/effect/floor_decal/reset/Initialize(mapload)
	..(mapload, bypass = TRUE)
	var/turf/T = get_turf(src)
	if(LAZYLEN(T.decals))
		T.decals.Cut()
		T.update_icon()
	qdel(src)

/obj/effect/floor_decal/corner
	icon_state = "corner_white"

/obj/effect/floor_decal/corner/black
	name = "black corner"
	color = "#333333"

/obj/effect/floor_decal/corner/black/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/black/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/blue
	name = "blue corner"
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/corner/blue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/blue/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/paleblue
	name = "pale blue corner"
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/floor_decal/corner/paleblue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/paleblue/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/green
	name = "green corner"
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/corner/green/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/green/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/light
	name = "light corner"
	icon_state = "corner_light"

/obj/effect/floor_decal/corner/light/full
	name = "full light corner"
	icon_state = "corner_light_full"

/obj/effect/floor_decal/corner/lime
	name = "lime corner"
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/corner/lime/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/lime/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/yellow
	name = "yellow corner"
	icon_state = "corner_light"
	color = COLOR_YELLOW_ENGI

/obj/effect/floor_decal/corner/yellow/diagonal
	icon_state = "corner_light_diagonal"

/obj/effect/floor_decal/corner/yellow/full
	icon_state = "corner_light_full"

/obj/effect/floor_decal/corner/beige
	name = "beige corner"
	color = COLOR_BEIGE

/obj/effect/floor_decal/corner/beige/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/beige/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/red
	name = "red corner"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/corner/red/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/red/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/pink
	name = "pink corner"
	color = COLOR_PALE_RED_GRAY

/obj/effect/floor_decal/corner/pink/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/pink/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/purple
	name = "purple corner"
	color = COLOR_PURPLE_GRAY

/obj/effect/floor_decal/corner/purple/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/purple/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/mauve
	name = "mauve corner"
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/corner/mauve/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/mauve/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/orange
	name = "orange corner"
	color = COLOR_ORANGE

/obj/effect/floor_decal/corner/orange/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/orange/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/brown
	name = "brown corner"
	color = COLOR_BROWN

/obj/effect/floor_decal/corner/brown/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/brown/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/white
	name = "white corner"
	icon_state = "corner_white"

/obj/effect/floor_decal/corner/white/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/white/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/grey
	name = "grey corner"
	color = "#8D8C8C"

/obj/effect/floor_decal/corner/grey/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/grey/full
	icon_state = "corner_white_full"


//Wide Corners// - Works better with some kinds of floors when you want the line of corner decals to connect

/obj/effect/floor_decal/corner_wide
	icon_state = "wide_corner"

/obj/effect/floor_decal/corner_wide/black
	name = "black corner"
	color = "#333333"

/obj/effect/floor_decal/corner_wide/black/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/black/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/blue
	name = "blue corner"
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/corner_wide/blue/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/blue/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/paleblue
	name = "pale blue corner"
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/floor_decal/corner_wide/paleblue/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/paleblue/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/green
	name = "green corner"
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/corner_wide/green/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/green/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/lime
	name = "lime corner"
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/corner_wide/lime/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/lime/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/light
	name = "light wide corner"
	icon_state = "wide_corner_light"

/obj/effect/floor_decal/corner_wide/light/full
	name = "full light wide corner"
	icon_state = "wide_corner_full_light"

/obj/effect/floor_decal/corner_wide/yellow
	name = "yellow corner"
	icon_state = "wide_corner_light"
	color = COLOR_YELLOW_ENGI

/obj/effect/floor_decal/corner_wide/yellow/diagonal
	icon_state = "wide_corner_diagonal_light"

/obj/effect/floor_decal/corner_wide/yellow/full
	icon_state = "wide_corner_full_light"

/obj/effect/floor_decal/corner_wide/beige
	name = "beige corner"
	color = COLOR_BEIGE

/obj/effect/floor_decal/corner_wide/beige/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/beige/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/red
	name = "red corner"
	color = COLOR_RED_GRAY

/obj/effect/floor_decal/corner_wide/red/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/red/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/pink
	name = "pink corner"
	color = COLOR_PALE_RED_GRAY

/obj/effect/floor_decal/corner_wide/pink/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/pink/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/purple
	name = "purple corner"
	color = COLOR_PURPLE_GRAY

/obj/effect/floor_decal/corner_wide/purple/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/purple/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/mauve
	name = "mauve corner"
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/corner_wide/mauve/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/mauve/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/orange
	name = "orange corner"
	color = COLOR_ORANGE

/obj/effect/floor_decal/corner_wide/orange/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/orange/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/brown
	name = "brown corner"
	color = COLOR_BROWN

/obj/effect/floor_decal/corner_wide/brown/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/brown/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/white
	name = "white corner"
	icon_state = "wide_corner"

/obj/effect/floor_decal/corner_wide/white/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/white/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_wide/grey
	name = "grey corner"
	color = "#8D8C8C"

/obj/effect/floor_decal/corner_wide/grey/diagonal
	icon_state = "wide_corner_diagonal"

/obj/effect/floor_decal/corner_wide/grey/full
	icon_state = "wide_corner_full"

/obj/effect/floor_decal/corner_full
	name = "full corner"
	icon_state = "full_corner"

/obj/effect/floor_decal/spline/plain
	name = "spline - plain"
	icon_state = "spline_plain"

/obj/effect/floor_decal/spline/plain/corner
	icon_state = "spline_plain_corner"

/obj/effect/floor_decal/spline/plain/cee
	icon_state = "spline_plain_cee"

/obj/effect/floor_decal/spline/plain/full
	icon_state = "spline_plain_full"

/obj/effect/floor_decal/spline/fancy
	name = "spline - fancy"
	icon_state = "spline_fancy"

/obj/effect/floor_decal/spline/fancy/corner
	icon_state = "spline_fancy_corner"

/obj/effect/floor_decal/spline/fancy/cee
	icon_state = "spline_fancy_cee"

/obj/effect/floor_decal/spline/fancy/full
	icon_state = "spline_fancy_full"

/obj/effect/floor_decal/spline/fancy/wood
	name = "spline - wood"
	color = "#CB9E04"

/obj/effect/floor_decal/spline/fancy/wood/corner
	icon_state = "spline_fancy_corner"

/obj/effect/floor_decal/spline/fancy/wood/cee
	icon_state = "spline_fancy_cee"

/obj/effect/floor_decal/spline/fancy/wood/full
	icon_state = "spline_fancy_full"

/obj/effect/floor_decal/industrial/warning
	name = "hazard stripes"
	icon_state = "warning"

/obj/effect/floor_decal/industrial/warning/corner
	icon_state = "warningcorner"

/obj/effect/floor_decal/industrial/warning/full
	icon_state = "warningfull"

/obj/effect/floor_decal/industrial/warning/cee
	icon_state = "warningcee"

/obj/effect/floor_decal/industrial/warning/dust
	name = "hazard stripes"
	icon_state = "warning_dust"

/obj/effect/floor_decal/industrial/warning/dust/corner
	name = "hazard stripes"
	icon_state = "warningcorner_dust"

/obj/effect/floor_decal/industrial/hatch
	name = "hatched marking"
	icon_state = "delivery"

/obj/effect/floor_decal/industrial/hatch/yellow
	color = "#CFCF55"

/obj/effect/floor_decal/industrial/hatch/grey
	color = "#808080"

/obj/effect/floor_decal/industrial/hatch/red
	color = "#990C0C"

//
// Outline
//
/obj/effect/floor_decal/industrial/outline
	name = "white outline"
	icon_state = "outline"

// Outline - Colours
/obj/effect/floor_decal/industrial/outline/blue
	name = "cyan outline"
	color = "#b6efe1"

/obj/effect/floor_decal/industrial/outline/yellow
	name = "yellow outline"
	color = "#CFCF55"

/obj/effect/floor_decal/industrial/outline/grey
	name = "grey outline"
	color = COLOR_GRAY

/obj/effect/floor_decal/industrial/outline/red
	name = "red outline"
	color = "#990C0C"

// Outline - Departmental
/obj/effect/floor_decal/industrial/outline/custodial
	name = "custodial purple outline"
	color = COLOR_PURPLE_GRAY

/obj/effect/floor_decal/industrial/outline/medical
	name = "medical lime outline"
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/floor_decal/industrial/outline/engineering
	name = "engineering yellow outline"
	color = COLOR_YELLOW_ENGI

/obj/effect/floor_decal/industrial/outline/service
	name = "service green outline"
	color = COLOR_GREEN_GRAY

/obj/effect/floor_decal/industrial/outline/research
	name = "research mauve outline"
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/floor_decal/industrial/outline/security
	name = "security blue outline"
	color = COLOR_BLUE_GRAY

// Outline - Informative
/obj/effect/floor_decal/industrial/outline/emergency_closet
	name = "blue emergency closet outline"
	color = "#618FBA"

/obj/effect/floor_decal/industrial/outline/firefighting_closet
	name = "red firefighting closet outline"
	color = "#C82D2D"

/obj/effect/floor_decal/industrial/loading
	name = "loading area"
	icon_state = "loadingarea"

/obj/effect/floor_decal/industrial/loading/yellow
	color = "#CFCF55"

/obj/effect/floor_decal/industrial/loading/grey
	color = COLOR_GRAY

/obj/effect/floor_decal/industrial/loading/security
	name = "security blue loading area"
	color = COLOR_BLUE_GRAY

/obj/effect/floor_decal/plaque
	name = "plaque"
	icon_state = "plaque"

/obj/effect/floor_decal/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet_edges"

/obj/effect/floor_decal/carpet/blue
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "bcarpet_edges"

/obj/effect/floor_decal/carpet/corners
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet_corners"

/obj/effect/floor_decal/asteroid
	name = "random asteroid rubble"
	icon_state = "asteroid0"

/obj/effect/floor_decal/asteroid/Initialize()
	..()
	icon_state = "asteroid[rand(0,9)]"

/obj/effect/floor_decal/chapel
	name = "chapel"
	icon_state = "chapel"

/obj/effect/floor_decal/ss13/l1
	name = "L1"
	icon_state = "L1"

/obj/effect/floor_decal/ss13/l2
	name = "L2"
	icon_state = "L2"

/obj/effect/floor_decal/ss13/l3
	name = "L3"
	icon_state = "L3"

/obj/effect/floor_decal/ss13/l4
	name = "L4"
	icon_state = "L4"

/obj/effect/floor_decal/ss13/l5
	name = "L5"
	icon_state = "L5"

/obj/effect/floor_decal/ss13/l6
	name = "L6"
	icon_state = "L6"

/obj/effect/floor_decal/ss13/l7
	name = "L7"
	icon_state = "L7"

/obj/effect/floor_decal/ss13/l8
	name = "L8"
	icon_state = "L8"

/obj/effect/floor_decal/ss13/l9
	name = "L9"
	icon_state = "L9"

/obj/effect/floor_decal/ss13/l10
	name = "L10"
	icon_state = "L10"

/obj/effect/floor_decal/ss13/l11
	name = "L11"
	icon_state = "L11"

/obj/effect/floor_decal/ss13/l12
	name = "L12"
	icon_state = "L12"

/obj/effect/floor_decal/ss13/l13
	name = "L13"
	icon_state = "L13"

/obj/effect/floor_decal/ss13/l14
	name = "L14"
	icon_state = "L14"

/obj/effect/floor_decal/ss13/odin1
	name = "odin1"
	icon_state = "odin1"

/obj/effect/floor_decal/ss13/odin2
	name = "odin2"
	icon_state = "odin2"

/obj/effect/floor_decal/ss13/odin3
	name = "odin3"
	icon_state = "odin3"

/obj/effect/floor_decal/ss13/odin4
	name = "odin4"
	icon_state = "odin4"

/obj/effect/floor_decal/ss13/odin5
	name = "odin5"
	icon_state = "odin5"

/obj/effect/floor_decal/ss13/odin6
	name = "odin6"
	icon_state = "odin6"

// Medbay floor signs

/obj/effect/floor_decal/sign
	name = "floor sign"
	icon_state = "white_1"

/obj/effect/floor_decal/sign/two
	icon_state = "white_2"

/obj/effect/floor_decal/sign/a
	icon_state = "white_a"

/obj/effect/floor_decal/sign/b
	icon_state = "white_b"

/obj/effect/floor_decal/sign/c
	icon_state = "white_c"

/obj/effect/floor_decal/sign/d
	icon_state = "white_d"

/obj/effect/floor_decal/sign/ex
	icon_state = "white_ex"

/obj/effect/floor_decal/sign/m
	icon_state = "white_m"

/obj/effect/floor_decal/sign/cmo
	icon_state = "white_cmo"

/obj/effect/floor_decal/sign/v
	icon_state = "white_v"

/obj/effect/floor_decal/sign/p
	icon_state = "white_p"

// New signs (New-map)

/obj/effect/floor_decal/sign/gtr
	icon_state = "white_gtr"

/obj/effect/floor_decal/sign/first_responder
	icon_state = "white_emt"

/obj/effect/floor_decal/sign/w
	icon_state = "white_w"

/obj/effect/floor_decal/sign/icu
	icon_state = "white_icu"

/obj/effect/floor_decal/sign/c2
	icon_state = "white_c2"

/obj/effect/floor_decal/sign/srg
	icon_state = "white_srg"

// the big SCC logo
/obj/effect/floor_decal/scc_full
	icon = 'icons/turf/flooring/scc_decal_preview.dmi'
	icon_state = "scc_decal_preview"

	var/list/decals = list(
		"0,0", "1,0", "2,0", "3,0", "4,0",
		"0,1", "1,1", "2,1", "3,1", "4,1",
		"0,2", "1,2", "2,2", "3,2","4,2",
		"0,3", "2,3", "4,3"
	)

/obj/effect/floor_decal/scc_full/Initialize()
	..()
	for(var/coordinate in decals)
		var/list/split_coordinate = splittext(coordinate, ",")
		var/turf/decal_turf = loc
		for(var/i = 1 to text2num(split_coordinate[1]))
			decal_turf = get_step(decal_turf, EAST)
		for(var/i = 1 to text2num(split_coordinate[2]))
			decal_turf = get_step(decal_turf, NORTH)
		new /obj/effect/floor_decal/scc(decal_turf, null, null, FALSE, coordinate)
	return INITIALIZE_HINT_QDEL

/obj/effect/floor_decal/scc
	icon = 'icons/turf/flooring/scc_decals.dmi'
	icon_state = "0,0"