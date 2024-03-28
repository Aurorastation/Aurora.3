/turf/simulated/floor/asphalt
	name = "asphalt"
	desc = "Once-hot asphalt."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "asphalt0"

/turf/simulated/floor/asphalt/Initialize(mapload)
	. = ..()
	icon_state = "asphalt[rand(0,3)]"

/turf/simulated/floor/sidewalk
	name = "weathered tiling"
	desc = "Great for speeding on."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "sidewalk-tile"

/turf/simulated/floor/sidewalk/detail
	icon_state = "sidewalk-tile-detail"

/turf/simulated/floor/sidewalk/paved
	name = "paved tiles"
	icon_state = "brick-paver"

/turf/simulated/floor/sidewalk/flat
	name = "flat paved tiles"
	icon_state = "flat"

/turf/simulated/floor/sidewalk/flat/Initialize(mapload)
	. = ..()
	icon_state = "flat[rand(1,3)]"

/turf/simulated/floor/sidewalk/blocks
	name = "blocked sidewalk tiles"
	icon_state = "blocks"

/turf/simulated/floor/sidewalk/blocks/Initialize(mapload)
	. = ..()
	icon_state = "blocks[rand(1,3)]"

/turf/simulated/floor/sidewalk/dark
	icon_state = "sidewalk_alt"

/turf/simulated/floor/sidewalk/dark/detail
	icon_state = "sidewalk_alt_detail"

/turf/simulated/floor/sidewalk/dark/grid
	icon_state = "sidewalk_alt_grid"

/turf/simulated/floor/foundation
	name = "foundation"
	desc = "The unclean but highly compacted solid foundation for a building or structure."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "rust"

/turf/simulated/floor/foundation/Initialize(mapload)
	. = ..()
	icon_state = "rust[rand(1,12)]"

/turf/simulated/floor/roofing_tiles
	name = "roofing tiles"
	desc = "You're on top of the world!"
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "rooftop"

/turf/simulated/floor/roofing_tiles/Initialize(mapload)
	. = ..()
	icon_state = "rooftop[rand(1,3)]"

/obj/structure/ledge
	name = "tall ledge"
	desc = "A tall ledge that seems difficult to surpass. You'd need some effort to get over this!"
	icon = 'icons/obj/structure/urban/ledges.dmi'
	icon_state = "half-height"
	layer = 2
	anchored = TRUE
	density = FALSE
	climbable = TRUE

/obj/structure/ledge/corner
	icon_state = "half-corner"

/obj/structure/ledge/quarter
	name = "short ledge"
	desc = "A short ledge that an adult-sized Human wouldn't have much trouble traversing. At best, an oversized step."
	icon_state = "quarter-height"

/obj/structure/ledge/quarter/corner
	icon_state = "quarter-corner"

/obj/structure/ledge/roof
	name = "roof ledge"
	desc = "A basic roofing ledge to mark the edge of a rooftop. Don't trip!"
	icon_state = "roof_ledge"
	layer = ABOVE_HUMAN_LAYER

/obj/structure/ledge/roof/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSRAILING))
		return TRUE
	if(mover.throwing)
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/ledge/roof/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && CanPass(O, target))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return TRUE
		return FALSE
	return TRUE

/obj/structure/ledge/roof/corner
	icon_state = "roof_ledge_corner"

/turf/simulated/floor/concrete // The more conk they crete the more brutalismer it is
	name = "concrete"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete0"
	initial_flooring = /singleton/flooring/concrete

/turf/simulated/floor/concrete/square
	icon_state = "concrete3"
	tile_outline = "tiled"
	tile_decal_state = "tiled_light"
	tile_outline_alpha = 125
	broken_overlay = "tiled"
	burned_overlay = "tiled"
	initial_flooring = /singleton/flooring/concrete/square
