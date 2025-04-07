
/obj/effect/map_effect/marker/mapmanip/submap/extract
	name = "mapmanip marker, extract submap"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "mapmanip_extract"
	pixel_x = -32
	pixel_y = -32

	/// Allows extract markers to have a shared name, even across submap operations,
	/// eliminating submaps with the same name from the selection pool.
	/// For example, allows having a map with 4 submaps, where each of them has 4 different
	/// and unique versions of different departments, but they won't repeat (and for example, have 3 medbays).
	/// Should be a string if enabled, or null. Multiple different submap markers need to be set to the same singleton id for this to work.
	var/singleton_id

/obj/effect/map_effect/marker/mapmanip/submap/insert
	name = "mapmanip marker, insert submap"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "mapmanip_insert"
	pixel_x = -32
	pixel_y = -32

/obj/effect/map_effect/marker_helper/mapmanip/submap/edge
	name = "mapmanip helper marker, edge of submap"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "mapmanip_submap_edge"
