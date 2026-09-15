
//How far from the edge of overmap zlevel could randomly placed objects spawn
#define OVERMAP_EDGE 4

/// All sector overmap objects.
/// Assoc list of stringified zlevel integer value (like `"1"` or `"42"` etc)
/// to an instance of `/obj/effect/overmap/visitable`.
/// Prefer to use the `get_map_template` proc instead of accessing this list directly.
GLOBAL_LIST_EMPTY(map_sectors)

/// All sector map templates. Analogous to the list above.
/// Assoc list of stringified zlevel integer value
/// to an instance of `/datum/map_template`.
/// Prefer to use the `get_map_sector` proc instead of accessing this list directly.
GLOBAL_LIST_EMPTY(map_templates)

/area/overmap
	name = "System Map"
	icon_state = "start"
	requires_power = 0
	base_turf = /turf/unsimulated/map
	base_lighting_alpha = 255

/turf/unsimulated/map
	icon = 'icons/obj/overmap/overmap.dmi'
	icon_state = "map"

/turf/unsimulated/map/edge
	opacity = 1
	density = 1

/turf/unsimulated/map/Initialize(mapload)
	. = ..()

	icon_state = "map_[rand(1,6)]"

	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == SSatlas.current_map.overmap_size)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == SSatlas.current_map.overmap_size)
			numbers += "-"
	if(y == 1 || y == SSatlas.current_map.overmap_size)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == SSatlas.current_map.overmap_size)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == SSatlas.current_map.overmap_size)
			I.pixel_x = 5*i + 2
		overlays += I

///list used to track which zlevels are being 'moved' by the `toggle_move_stars` proc
GLOBAL_LIST_EMPTY(moving_levels)

//Proc to 'move' stars in spess
//yes it looks ugly, but it should only fire when state actually change.
//null direction stops movement
/proc/toggle_move_stars(zlevel, direction)
	if(!zlevel)
		return

	var/gen_dir = null
	if(direction & (NORTH|SOUTH))
		gen_dir += "ns"
	else if(direction & (EAST|WEST))
		gen_dir += "ew"
	if(!direction)
		gen_dir = null

	if (GLOB.moving_levels["[zlevel]"] != gen_dir)
		GLOB.moving_levels["[zlevel]"] = gen_dir

		var/list/spaceturfs = block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel))
		for(var/turf/space/T in spaceturfs)
			if(!gen_dir)
				T.icon_state = "white"
			else
				T.icon_state = "speedspace_[gen_dir]_[rand(1,15)]"
				for(var/atom/movable/AM in T)
					if (AM.simulated && !AM.anchored)
						AM.throw_at(get_step(T,REVERSE_DIR(direction)), 5, 1)
						CHECK_TICK
			CHECK_TICK

/// Returns the map_template.
/// Arg can be the z-level number or atom instance.
/// Returns the corresponding `/datum/map_template` instance.
/proc/get_map_template(z_or_atom)
	dbg_assert(!isnull(z_or_atom), "Argument cannot be null")
	dbg_assert(isnum(z_or_atom) || isatom(z_or_atom), "Expected atom or number, got [ispath(z_or_atom) ? "[z_or_atom] (path)" : "[z_or_atom]"]")

	var/resolved_z = z_or_atom

	if(isatom(z_or_atom))
		var/atom/A = z_or_atom
		dbg_assert(A.z > 0, "Atom [A] ([A.type]) is in nullspace or unplaced (z = [A.z])")
		resolved_z = A.z

	dbg_assert(isnum(resolved_z) && resolved_z > 0 && resolved_z <= world.maxz, "Target z-level [resolved_z] out of bounds (1..[world.maxz])")
	dbg_assert(round(resolved_z) == resolved_z, "Z-level must be an integer, got [resolved_z]")

	return GLOB.map_templates["[resolved_z]"]

/// Returns the map sector.
/// Arg can be the z-level number or atom instance.
/// Returns the corresponding `/obj/effect/overmap/visitable` instance.
/proc/get_map_sector(z_or_atom)
	dbg_assert(!isnull(z_or_atom), "Argument cannot be null")
	dbg_assert(isnum(z_or_atom) || isatom(z_or_atom), "Expected atom or number, got [ispath(z_or_atom) ? "[z_or_atom] (path)" : "[z_or_atom]"]")

	var/resolved_z = z_or_atom

	if(isatom(z_or_atom))
		var/atom/A = z_or_atom
		dbg_assert(A.z > 0, "Atom [A] ([A.type]) is in nullspace or unplaced (z = [A.z])")
		resolved_z = A.z

	dbg_assert(isnum(resolved_z) && resolved_z > 0 && resolved_z <= world.maxz, "Target z-level [resolved_z] out of bounds (1..[world.maxz])")
	dbg_assert(round(resolved_z) == resolved_z, "Z-level must be an integer, got [resolved_z]")

	return GLOB.map_sectors["[resolved_z]"]
