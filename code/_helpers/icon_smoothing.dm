
//generic (by snowflake) tile smoothing code; smooth your icons with this!
/*
	Each tile is divided in 4 corners, each corner has an image associated to it; the tile is then overlayed by these 4 images
	To use this, just set your atom's 'smooth' var to 1. If your atom can be moved/unanchored, set its 'can_be_unanchored' var to 1.
	If you don't want your atom's icon to smooth with anything but atoms of the same type, set the list 'canSmoothWith' to null;
	Otherwise, put all types you want the atom icon to smooth with in 'canSmoothWith' INCLUDING THE TYPE OF THE ATOM ITSELF.

	Each atom has its own icon file with all the possible corner states. See ExampleInput.dmi in tools/SS13SmoothingCutter for a template.

	DIAGONAL SMOOTHING INSTRUCTIONS
	To make your atom smooth diagonally you need all the proper icon states (see 'tools/SS13SmoothingCutter/ExampleDiagInput.dmi' for a template) and
	to add the 'SMOOTH_DIAGONAL' flag to the atom's smooth var (in addition to either SMOOTH_TRUE or SMOOTH_MORE).

	For turfs, what appears under the diagonal corners depends on the turf that was in the same position previously: if you make a wall on
	a plating floor, you will see plating under the diagonal wall corner, if it was space, you will see space.

	If you wish to map a diagonal wall corner with a fixed underlay, you must configure the turf's 'fixed_underlay' list var, like so:
		fixed_underlay = list("icon"='icon_file.dmi', "icon_state"="iconstatename")
	A non null 'fixed_underlay' list var will skip copying the previous turf appearance and always use the list. If the list is
	not set properly, the underlay will default to regular floor plating.
*/

//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH	2
#define N_SOUTH	4
#define N_EAST	16
#define N_WEST	256
#define N_NORTHEAST	32
#define N_NORTHWEST	512
#define N_SOUTHEAST	64
#define N_SOUTHWEST	1024

#define SMOOTH_FALSE          0 // not smooth
#define SMOOTH_TRUE           1 // smooths with exact specified types or just itself
#define SMOOTH_MORE           2 // smooths with all subtypes of specified types or just itself (this value can replace SMOOTH_TRUE)
#define SMOOTH_DIAGONAL       4 // if atom should smooth diagonally, this should be present in 'smooth' var
#define SMOOTH_BORDER         8 // atom will smooth with the borders of the map
#define SMOOTH_QUEUED        16 // atom is currently queued to smooth.
#define SMOOTH_NO_CLEAR_ICON 32 // don't clear the atom's icon_state on smooth.

#define SMOOTHHINT_CUT_F              1 // Don't draw the 'F' state. Useful with SMOOTH_NO_CLEAR_ICON.
#define SMOOTHHINT_ONLY_MATCH_TURF    2 // Only try to match turfs (this is faster than matching all atoms)
#define SMOOTHHINT_TARGETS_NOT_UNIQUE 4 // The smoother can assume that all atoms of this type will have the same canSmoothWith value.

#define NULLTURF_BORDER 123456789

#define DEFAULT_UNDERLAY_ICON 			'icons/turf/floors.dmi'
#define DEFAULT_UNDERLAY_ICON_STATE 	"plating"
#define DEFAULT_UNDERLAY_IMAGE			image(DEFAULT_UNDERLAY_ICON, DEFAULT_UNDERLAY_ICON_STATE)

/atom
	var/smooth = SMOOTH_FALSE
	var/smoothing_hints = SMOOTHHINT_TARGETS_NOT_UNIQUE
	var/tmp/top_left_corner
	var/tmp/top_right_corner
	var/tmp/bottom_left_corner
	var/tmp/bottom_right_corner
	var/list/canSmoothWith = null // TYPE PATHS I CAN SMOOTH WITH~~~~~ If this is null and atom is smooth, it smooths only with itself

/atom/movable
	var/can_be_unanchored = 0

/turf
	var/list/fixed_underlay
	var/smooth_underlays	// Determines if we should attempt to generate turf underlays for this type.

/turf/simulated/wall/shuttle
	smooth_underlays = TRUE

/turf/simulated/wall
	smooth_underlays = TRUE

/turf/unsimulated/wall
	smooth_underlays = TRUE

/atom/proc/calculate_adjacencies()
	if (!loc)
		return 0

	var/adjacencies = 0

	if (smoothing_hints & SMOOTHHINT_ONLY_MATCH_TURF)
		var/turf/T
		var/list/tcache
		if (smoothing_hints & SMOOTHHINT_TARGETS_NOT_UNIQUE)
			tcache = SSicon_smooth.typecachecache[type]
			if (!tcache)
				tcache = typecacheof(canSmoothWith || type, FALSE, !(smooth & SMOOTH_MORE))
				SSicon_smooth.typecachecache[type] = tcache
		else
			tcache = typecacheof(canSmoothWith || type, FALSE, !(smooth & SMOOTH_MORE))

		if (smooth & SMOOTH_BORDER)
			CALCULATE_NEIGHBORS(src, adjacencies, T, !T || tcache[T.type])
		else
			CALCULATE_NEIGHBORS(src, adjacencies, T, T && tcache[T.type])
	else
		var/atom/movable/AM

		for(var/direction in cardinal)
			AM = find_type_in_direction(src, direction)
			if(AM == NULLTURF_BORDER)
				if((smooth & SMOOTH_BORDER))
					adjacencies |= 1 << direction
			else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
				adjacencies |= 1 << direction

		if(adjacencies & N_NORTH)
			if(adjacencies & N_WEST)
				AM = find_type_in_direction(src, NORTHWEST)
				if(AM == NULLTURF_BORDER)
					if((smooth & SMOOTH_BORDER))
						adjacencies |= N_NORTHWEST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_NORTHWEST
			if(adjacencies & N_EAST)
				AM = find_type_in_direction(src, NORTHEAST)
				if(AM == NULLTURF_BORDER)
					if((smooth & SMOOTH_BORDER))
						adjacencies |= N_NORTHEAST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_NORTHEAST

		if(adjacencies & N_SOUTH)
			if(adjacencies & N_WEST)
				AM = find_type_in_direction(src, SOUTHWEST)
				if(AM == NULLTURF_BORDER)
					if((smooth & SMOOTH_BORDER))
						adjacencies |= N_SOUTHWEST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_SOUTHWEST
			if(adjacencies & N_EAST)
				AM = find_type_in_direction(src, SOUTHEAST)
				if(AM == NULLTURF_BORDER)
					if((smooth & SMOOTH_BORDER))
						adjacencies |= N_SOUTHEAST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_SOUTHEAST

	return adjacencies

/atom/movable/calculate_adjacencies()
	if (can_be_unanchored && !anchored)
		return 0

	return ..()

//do not use, use queue_smooth(atom)
/proc/smooth_icon(atom/A)
	if(!A || !A.smooth)
		return
	A.smooth &= ~SMOOTH_QUEUED
	if (!A.z)
		return
	if(QDELETED(A))
		return
	if((A.smooth & SMOOTH_TRUE) || (A.smooth & SMOOTH_MORE))
		var/adjacencies = A.calculate_adjacencies()

		if(A.smooth & SMOOTH_DIAGONAL)
			A.diagonal_smooth(adjacencies)
		else
			cardinal_smooth(A, adjacencies)

/atom/proc/diagonal_smooth(adjacencies)
	switch(adjacencies)
		if(N_NORTH|N_WEST)
			replace_smooth_overlays("d-se","d-se-0")
		if(N_NORTH|N_EAST)
			replace_smooth_overlays("d-sw","d-sw-0")
		if(N_SOUTH|N_WEST)
			replace_smooth_overlays("d-ne","d-ne-0")
		if(N_SOUTH|N_EAST)
			replace_smooth_overlays("d-nw","d-nw-0")

		if(N_NORTH|N_WEST|N_NORTHWEST)
			replace_smooth_overlays("d-se","d-se-1")
		if(N_NORTH|N_EAST|N_NORTHEAST)
			replace_smooth_overlays("d-sw","d-sw-1")
		if(N_SOUTH|N_WEST|N_SOUTHWEST)
			replace_smooth_overlays("d-ne","d-ne-1")
		if(N_SOUTH|N_EAST|N_SOUTHEAST)
			replace_smooth_overlays("d-nw","d-nw-1")

		else
			cardinal_smooth(src, adjacencies)
			return

	icon_state = ""
	return adjacencies

/turf/diagonal_smooth(adjacencies)
	adjacencies = reverse_ndir(..())
	if (smooth_underlays && adjacencies)
		// This should be a mutable_appearance, but we're still on 510.
		// Alas.
		var/mutable_appearance/underlay_appearance = mutable_appearance(null, layer = TURF_LAYER)
		var/list/U = list(underlay_appearance)
		if(fixed_underlay)
			if(fixed_underlay["space"])
				var/istate = "[((x + y) ^ ~(x * y) + z) % 25]"
				underlay_appearance.icon = 'icons/turf/space.dmi'
				underlay_appearance.icon_state = istate
				underlay_appearance.plane = PLANE_SPACE_BACKGROUND

				var/image/dust = image('icons/turf/space_parallax1.dmi', istate)
				dust.plane = PLANE_SPACE_DUST
				dust.alpha = 80
				dust.blend_mode = BLEND_ADD
				U += dust
			else
				underlay_appearance.icon = fixed_underlay["icon"]
				underlay_appearance.icon_state = fixed_underlay["icon_state"]
		else
			var/turned_adjacency = turn(adjacencies, 180)
			var/turf/T = get_step(src, turned_adjacency)
			if(!T.get_smooth_underlay_icon(underlay_appearance, src, turned_adjacency))
				T = get_step(src, turn(adjacencies, 135))
				if(!T.get_smooth_underlay_icon(underlay_appearance, src, turned_adjacency))
					T = get_step(src, turn(adjacencies, 225))

			//if all else fails, ask our own turf
			if(!T.get_smooth_underlay_icon(underlay_appearance, src, turned_adjacency) && !get_smooth_underlay_icon(underlay_appearance, src, turned_adjacency))
				underlay_appearance.icon = DEFAULT_UNDERLAY_ICON
				underlay_appearance.icon_state = DEFAULT_UNDERLAY_ICON_STATE

		underlays = U

/proc/cardinal_smooth(atom/A, adjacencies)
	//NW CORNER
	var/nw = "1-i"
	if((adjacencies & N_NORTH) && (adjacencies & N_WEST))
		if(adjacencies & N_NORTHWEST)
			nw = "1-f"
		else
			nw = "1-nw"
	else
		if(adjacencies & N_NORTH)
			nw = "1-n"
		else if(adjacencies & N_WEST)
			nw = "1-w"

	//NE CORNER
	var/ne = "2-i"
	if((adjacencies & N_NORTH) && (adjacencies & N_EAST))
		if(adjacencies & N_NORTHEAST)
			ne = "2-f"
		else
			ne = "2-ne"
	else
		if(adjacencies & N_NORTH)
			ne = "2-n"
		else if(adjacencies & N_EAST)
			ne = "2-e"

	//SW CORNER
	var/sw = "3-i"
	if((adjacencies & N_SOUTH) && (adjacencies & N_WEST))
		if(adjacencies & N_SOUTHWEST)
			sw = "3-f"
		else
			sw = "3-sw"
	else
		if(adjacencies & N_SOUTH)
			sw = "3-s"
		else if(adjacencies & N_WEST)
			sw = "3-w"

	//SE CORNER
	var/se = "4-i"
	if((adjacencies & N_SOUTH) && (adjacencies & N_EAST))
		if(adjacencies & N_SOUTHEAST)
			se = "4-f"
		else
			se = "4-se"
	else
		if(adjacencies & N_SOUTH)
			se = "4-s"
		else if(adjacencies & N_EAST)
			se = "4-e"

	var/list/New
	var/list/Old
	var/cut_f = A.smoothing_hints & SMOOTHHINT_CUT_F

	if(A.top_left_corner != nw)
		if (A.top_left_corner)
			LAZYADD(Old, A.top_left_corner)
		A.top_left_corner = nw
		if (!cut_f || nw != "1-f")
			LAZYADD(New, nw)

	if(A.top_right_corner != ne)
		if (A.top_right_corner)
			LAZYADD(Old, A.top_right_corner)
		A.top_right_corner = ne
		if (!cut_f || ne != "2-f")
			LAZYADD(New, ne)

	if(A.bottom_right_corner != sw)
		if (A.bottom_right_corner)
			LAZYADD(Old, A.bottom_right_corner)
		A.bottom_right_corner = sw
		if (!cut_f || sw != "3-f")
			LAZYADD(New, sw)

	if(A.bottom_left_corner != se)
		if (A.bottom_left_corner)
			LAZYADD(Old, A.bottom_left_corner)
		A.bottom_left_corner = se
		if (!cut_f || se != "4-f")
			LAZYADD(New, se)

	if(Old)
		A.cut_overlay(Old)

	if(New)
		A.add_overlay(New)

	if (A.icon_state && !(A.smooth & SMOOTH_NO_CLEAR_ICON))
		A.icon_state = null

// A more stripped down version of the above, meant for using images to apply multiple smooth overlays
//    at once.
/proc/cardinal_smooth_fromicon(icon/I, adjacencies)
	//NW CORNER
	var/nw = "1-i"
	if((adjacencies & N_NORTH) && (adjacencies & N_WEST))
		if(adjacencies & N_NORTHWEST)
			nw = "1-f"
		else
			nw = "1-nw"
	else
		if(adjacencies & N_NORTH)
			nw = "1-n"
		else if(adjacencies & N_WEST)
			nw = "1-w"

	//NE CORNER
	var/ne = "2-i"
	if((adjacencies & N_NORTH) && (adjacencies & N_EAST))
		if(adjacencies & N_NORTHEAST)
			ne = "2-f"
		else
			ne = "2-ne"
	else
		if(adjacencies & N_NORTH)
			ne = "2-n"
		else if(adjacencies & N_EAST)
			ne = "2-e"

	//SW CORNER
	var/sw = "3-i"
	if((adjacencies & N_SOUTH) && (adjacencies & N_WEST))
		if(adjacencies & N_SOUTHWEST)
			sw = "3-f"
		else
			sw = "3-sw"
	else
		if(adjacencies & N_SOUTH)
			sw = "3-s"
		else if(adjacencies & N_WEST)
			sw = "3-w"

	//SE CORNER
	var/se = "4-i"
	if((adjacencies & N_SOUTH) && (adjacencies & N_EAST))
		if(adjacencies & N_SOUTHEAST)
			se = "4-f"
		else
			se = "4-se"
	else
		if(adjacencies & N_SOUTH)
			se = "4-s"
		else if(adjacencies & N_EAST)
			se = "4-e"

	var/image/nw_i = image(I, nw)
	var/image/ne_i = image(I, ne)
	var/image/sw_i = image(I, sw)
	var/image/se_i = image(I, se)

	return list(nw_i, ne_i, sw_i, se_i)

/proc/find_type_in_direction(atom/source, direction)
	var/turf/target_turf = get_step(source, direction)
	if(!target_turf)
		return NULLTURF_BORDER

	if (source.smoothing_hints & SMOOTHHINT_TARGETS_NOT_UNIQUE)
		var/list/tcache = SSicon_smooth.typecachecache[source.type]
		if (!tcache)
			tcache = typecacheof(source.canSmoothWith || source.type, FALSE, !(source.smooth & SMOOTH_MORE))
			SSicon_smooth.typecachecache[source.type] = tcache

		if (is_type_in_typecache(target_turf, tcache))
			return target_turf
		return typecache_first_match(target_turf.contents, tcache)
	else
		if(source.canSmoothWith)
			var/atom/A
			if(source.smooth & SMOOTH_MORE)
				for(var/a_type in source.canSmoothWith)
					if( istype(target_turf, a_type) )
						return target_turf
					if (ispath(a_type, /turf))
						continue
					A = locate(a_type) in target_turf
					if(A)
						return A
				return null

			for(var/a_type in source.canSmoothWith)
				if(a_type == target_turf.type)
					return target_turf
				if (ispath(a_type, /turf))
					continue
				A = locate(a_type) in target_turf
				if(A && A.type == a_type)
					return A
			return null
		else
			if(isturf(source))
				return source.type == target_turf.type ? target_turf : null
			var/atom/A = locate(source.type) in target_turf
			return A && A.type == source.type ? A : null

//Icon smoothing helpers
/proc/smooth_zlevel(var/zlevel, now = FALSE)
	for(var/V in Z_ALL_TURFS(zlevel))
		var/turf/T = V
		if(T.smooth)
			if(now)
				smooth_icon(T)
			else
				queue_smooth(T)
		for(var/R in T)
			var/atom/A = R
			if(A.smooth)
				if(now)
					smooth_icon(A)
				else
					queue_smooth(A)

/atom/proc/clear_smooth_overlays()
	cut_overlay(list(top_left_corner, top_right_corner, bottom_left_corner, bottom_right_corner))
	top_left_corner = null
	top_right_corner = null
	bottom_right_corner = null
	bottom_left_corner = null

/atom/proc/replace_smooth_overlays(nw, ne, sw, se)
	clear_smooth_overlays()
	var/list/O = list()
	top_left_corner = nw
	O += nw
	top_right_corner = ne
	O += ne
	bottom_left_corner = sw
	O += sw
	bottom_right_corner = se
	O += se
	add_overlay(O)

/proc/reverse_ndir(ndir)
	switch(ndir)
		if(N_NORTH)
			return NORTH
		if(N_SOUTH)
			return SOUTH
		if(N_WEST)
			return WEST
		if(N_EAST)
			return EAST
		if(N_NORTHWEST)
			return NORTHWEST
		if(N_NORTHEAST)
			return NORTHEAST
		if(N_SOUTHEAST)
			return SOUTHEAST
		if(N_SOUTHWEST)
			return SOUTHWEST
		if(N_NORTH|N_WEST)
			return NORTHWEST
		if(N_NORTH|N_EAST)
			return NORTHEAST
		if(N_SOUTH|N_WEST)
			return SOUTHWEST
		if(N_SOUTH|N_EAST)
			return SOUTHEAST
		if(N_NORTH|N_WEST|N_NORTHWEST)
			return NORTHWEST
		if(N_NORTH|N_EAST|N_NORTHEAST)
			return NORTHEAST
		if(N_SOUTH|N_WEST|N_SOUTHWEST)
			return SOUTHWEST
		if(N_SOUTH|N_EAST|N_SOUTHEAST)
			return SOUTHEAST
		else
			return 0

//SSicon_smooth
/proc/queue_smooth_neighbors(atom/A)
	for(var/V in orange(1,A))
		var/atom/T = V
		if(T.smooth)
			queue_smooth(T)

//SSicon_smooth
/proc/queue_smooth(atom/A)
	if(!A.smooth || A.smooth & SMOOTH_QUEUED)
		return

	SSicon_smooth.smooth_queue += A
	SSicon_smooth.wake()
	A.smooth |= SMOOTH_QUEUED
