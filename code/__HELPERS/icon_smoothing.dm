
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

/* smoothing_hints */

///Don't draw the 'F' state. Useful with SMOOTH_NO_CLEAR_ICON.
#define SMOOTHHINT_CUT_F              1
///Only try to match turfs (this is faster than matching all atoms)
#define SMOOTHHINT_ONLY_MATCH_TURF    2
///The smoother can assume that all atoms of this type will have the same canSmoothWith value.
#define SMOOTHHINT_TARGETS_NOT_UNIQUE 4


#define NULLTURF_BORDER 123456789

#define DEFAULT_UNDERLAY_ICON 			'icons/turf/floors.dmi'
#define DEFAULT_UNDERLAY_ICON_STATE 	"plating"
#define DEFAULT_UNDERLAY_IMAGE			image(DEFAULT_UNDERLAY_ICON, DEFAULT_UNDERLAY_ICON_STATE)

/atom
	var/smoothing_flags = SMOOTH_FALSE
	var/smoothing_hints = SMOOTHHINT_TARGETS_NOT_UNIQUE
	var/tmp/top_left_corner
	var/tmp/top_right_corner
	var/tmp/bottom_left_corner
	var/tmp/bottom_right_corner
	/// TYPE PATHS I CAN SMOOTH WITH - If this is null and atom is smooth, it smooths only with itself
	var/list/canSmoothWith = null
	var/list/can_blend_with = null
	/// Icon state of the blending overlay.
	var/blend_overlay
	/// Icon state of the overlay this object uses to attach to other objects.
	var/attach_overlay

/atom/movable
	var/can_be_unanchored = 0
	var/obj/buckled_to
	var/can_be_buckled = FALSE

/turf
	var/list/fixed_underlay
	/// Determines if we should attempt to generate turf underlays for this type.
	var/smooth_underlays
	/// Override if you don't want decals to cut from the icon state directly but something else. Used for coloring decals, mostly
	var/tile_decal_state
	/// Decal effect for "sinking in" the edges.
	var/tile_outline
	/// How dark you want the sinking in to be. Set this if you want above to do stuff.
	var/tile_outline_alpha
	var/tile_outline_blend_process = ICON_OVERLAY

/turf/simulated/wall/shuttle
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
				tcache = typecacheof(canSmoothWith || type, FALSE, !(smoothing_flags & SMOOTH_MORE))
				SSicon_smooth.typecachecache[type] = tcache
		else
			tcache = typecacheof(canSmoothWith || type, FALSE, !(smoothing_flags & SMOOTH_MORE))

		if (smoothing_flags & SMOOTH_BORDER)
			CALCULATE_NEIGHBORS(src, adjacencies, T, !T || tcache[T.type])
		else
			CALCULATE_NEIGHBORS(src, adjacencies, T, T && tcache[T.type])
	else
		var/atom/movable/AM

		for(var/direction in GLOB.cardinals)
			AM = find_type_in_direction(src, direction)
			if(AM == NULLTURF_BORDER)
				if((smoothing_flags & SMOOTH_BORDER))
					adjacencies |= 1 << direction
			else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
				adjacencies |= 1 << direction

		if(adjacencies & N_NORTH)
			if(adjacencies & N_WEST)
				AM = find_type_in_direction(src, NORTHWEST)
				if(AM == NULLTURF_BORDER)
					if((smoothing_flags & SMOOTH_BORDER))
						adjacencies |= N_NORTHWEST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_NORTHWEST
			if(adjacencies & N_EAST)
				AM = find_type_in_direction(src, NORTHEAST)
				if(AM == NULLTURF_BORDER)
					if((smoothing_flags & SMOOTH_BORDER))
						adjacencies |= N_NORTHEAST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_NORTHEAST

		if(adjacencies & N_SOUTH)
			if(adjacencies & N_WEST)
				AM = find_type_in_direction(src, SOUTHWEST)
				if(AM == NULLTURF_BORDER)
					if((smoothing_flags & SMOOTH_BORDER))
						adjacencies |= N_SOUTHWEST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_SOUTHWEST
			if(adjacencies & N_EAST)
				AM = find_type_in_direction(src, SOUTHEAST)
				if(AM == NULLTURF_BORDER)
					if((smoothing_flags & SMOOTH_BORDER))
						adjacencies |= N_SOUTHEAST
				else if( (AM && !istype(AM)) || (istype(AM) && AM.anchored) )
					adjacencies |= N_SOUTHEAST

	return adjacencies

/atom/movable/calculate_adjacencies()
	if (can_be_unanchored && !anchored)
		return 0

	return ..()

///Do not use, use QUEUE_SMOOTH(atom)
/atom/proc/smooth_icon()
	SHOULD_NOT_SLEEP(TRUE)
	if(QDELETED(src))
		return
	if(!smoothing_flags)
		return
	if (!z)
		return
	smoothing_flags &= ~SMOOTH_QUEUED
	atom_flags |= ATOM_FLAG_HTML_USE_INITIAL_ICON
	if((smoothing_flags & (SMOOTH_TRUE|SMOOTH_MORE)))
		var/adjacencies = calculate_adjacencies()

		if(smoothing_flags & SMOOTH_DIAGONAL)
			diagonal_smooth(adjacencies)
		else
			cardinal_smooth(adjacencies)

/atom/proc/diagonal_smooth(adjacencies)
	SHOULD_NOT_SLEEP(TRUE)

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
			cardinal_smooth(adjacencies)
			return

	icon_state = ""
	return adjacencies

/turf/diagonal_smooth(adjacencies)
	adjacencies = REVERSE_DIR(..())
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
				underlay_appearance.plane = SPACE_PLANE

				var/image/dust = image('icons/turf/space_parallax1.dmi', istate)
				dust.plane = DUST_PLANE
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

/turf/proc/get_underlays(var/list/adjacencies)
	SHOULD_NOT_SLEEP(TRUE)

	// First of all, check if there are turfs like us we can ask for underlays.
	adjacencies = calculate_adjacencies()
	var/success = FALSE
	if (smooth_underlays)
		var/mutable_appearance/underlay_appearance = mutable_appearance(null, layer = TURF_LAYER)
		var/list/U = list(underlay_appearance)
		for(var/direction in GLOB.alldirs)
			if(adjacencies & direction)
				var/turf/T = get_step(src, direction)
				if(T)
					if(!T.get_smooth_underlay_icon(underlay_appearance, src, direction))
						continue
					else
						success = TRUE
						break

		// If all else fails, ask our own turf
		if(!success)
			underlay_appearance.icon = base_icon
			underlay_appearance.icon_state = base_icon_state

		underlays = U

#define ndir_to_initial(RET, ndir)\
	switch(ndir){\
		if(N_NORTH){\
			RET = "n";\
			}\
		if(N_SOUTH){\
			RET = "s";\
			}\
		if(N_EAST){\
			RET = "e";\
			}\
		if(N_WEST){\
			RET = "w";\
			}\
	}

/**
 * Blend atoms
 */
/atom/proc/handle_blending(adjacencies, var/list/dir_mods, var/overlay_layer = 3)
	SHOULD_NOT_SLEEP(TRUE)

	LAZYINITLIST(dir_mods)
	// Bitfield of the directions of walls we've found.
	var/walls_found = 0
	for(var/adjacency in list(N_NORTH, N_EAST, N_SOUTH, N_WEST))
		if(adjacencies & adjacency)
			var/turf/T = get_step(src, REVERSE_DIR(adjacency))
			if(is_type_in_list(T, can_blend_with))
				if(attach_overlay)
					AddOverlays("[REVERSE_DIR(adjacency)]_[attach_overlay]", overlay_layer)
				walls_found |= adjacency
				dir_mods["[adjacency]"] = "-[blend_overlay]"
	for(var/adjacency in list(N_NORTH, N_SOUTH))
		for(var/diagonal in list(N_WEST, N_EAST))
			//This shit is done to avoid checking twice, since the value is the same
			var/prefix
			ndir_to_initial(prefix, adjacency)
			var/suffix = prefix

			var/has_adjacency = walls_found & adjacency
			var/has_diagonal = walls_found & diagonal
			if(((adjacencies & adjacency) && (adjacencies && diagonal)) && (has_adjacency || has_diagonal))
				dir_mods["[adjacency][diagonal]"] = "-[prefix][has_adjacency ? "wall" : "win"]-[suffix][has_diagonal ? "wall" : "win"]"
				if(attach_overlay)
					AddOverlays("[prefix][suffix]_[attach_overlay]", overlay_layer)
	return dir_mods

#undef ndir_to_initial

/atom/proc/cardinal_smooth(adjacencies)
	SHOULD_NOT_SLEEP(TRUE)

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
	var/cut_f = smoothing_hints & SMOOTHHINT_CUT_F

	if(top_left_corner != nw)
		if (top_left_corner)
			LAZYADD(Old, top_left_corner)
		top_left_corner = nw
		if (!cut_f || nw != "1-f")
			LAZYADD(New, nw)

	if(top_right_corner != ne)
		if (top_right_corner)
			LAZYADD(Old, top_right_corner)
		top_right_corner = ne
		if (!cut_f || ne != "2-f")
			LAZYADD(New, ne)

	if(bottom_right_corner != sw)
		if (bottom_right_corner)
			LAZYADD(Old, bottom_right_corner)
		bottom_right_corner = sw
		if (!cut_f || sw != "3-f")
			LAZYADD(New, sw)

	if(bottom_left_corner != se)
		if (bottom_left_corner)
			LAZYADD(Old, bottom_left_corner)
		bottom_left_corner = se
		if (!cut_f || se != "4-f")
			LAZYADD(New, se)

	if(Old)
		CutOverlays(Old)

	if(New)
		AddOverlays(New)

	if (icon_state && !(smoothing_flags & SMOOTH_NO_CLEAR_ICON))
		icon_state = null

// A more stripped down version of the above, meant for using images to apply multiple smooth overlays
//    at once.
/proc/cardinal_smooth_fromicon(icon/I, adjacencies)
	SHOULD_NOT_SLEEP(TRUE)

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
			tcache = typecacheof(source.canSmoothWith || source.type, FALSE, !(source.smoothing_flags & SMOOTH_MORE))
			SSicon_smooth.typecachecache[source.type] = tcache

		if (is_type_in_typecache(target_turf, tcache))
			return target_turf
		return typecache_first_match(target_turf.contents, tcache)
	else
		if(source.canSmoothWith)
			var/atom/A
			if(source.smoothing_flags & SMOOTH_MORE)
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
/proc/smooth_zlevel(var/zlevel)
	SHOULD_NOT_SLEEP(TRUE)

	for(var/turf/T as anything in Z_TURFS(zlevel))
		QUEUE_SMOOTH(T)

		for(var/atom/movable/movable_to_smooth as anything in T)
			QUEUE_SMOOTH(movable_to_smooth)

/atom/proc/clear_smooth_overlays()
	SHOULD_NOT_SLEEP(TRUE)

	CutOverlays(list(top_left_corner, top_right_corner, bottom_left_corner, bottom_right_corner))
	top_left_corner = null
	top_right_corner = null
	bottom_right_corner = null
	bottom_left_corner = null

/atom/proc/replace_smooth_overlays(nw, ne, sw, se)
	SHOULD_NOT_SLEEP(TRUE)

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
	AddOverlays(O)
