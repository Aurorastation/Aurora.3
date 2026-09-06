
/obj/effect/map_effect/marker/mapmanip/submap/extract
	name = "mapmanip marker, extract submap"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "mapmanip_extract"
	pixel_x = -32
	pixel_y = -32
	/// If set, it allows extract markers to have a shared name, even across submap operations,
	/// eliminating submaps with the same name from the selection pool.
	/// If null, ignored.
	///
	/// Must be set in map, as mapmanip does not read code.
	var/singleton_id = null
	/// The higher the weight, the more likely the marker is to be selected.
	/// Default is 1 if unset.
	/// Weight must be 0 or positive.
	///
	/// If specifically set to 0, the marker will never be selected,
	/// unless, and only if, all the remaining markers have a weight of 0.
	/// Or in other words, it'll be selected last.
	///
	/// Must be set in map, as mapmanip does not read code.
	var/weight = 1

/obj/effect/map_effect/marker/mapmanip/submap/insert
	name = "mapmanip marker, insert submap"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "mapmanip_insert"
	pixel_x = -32
	pixel_y = -32
	/// Direction of submap insertion.
	/// Default is NORTHEAST, meaning the marker is the bottom-left corner,
	/// and the submap is inserted to the north-east starting from the marker.
	/// Directions such as NORTH means the marker is bottom-center,
	/// and the submap is inserted to the north starting from the marker.
	///
	/// Must be set in map (if anything other than NORTHEAST), as mapmanip does not read code.
	dir = NORTHEAST

/obj/effect/map_effect/marker_helper/mapmanip/submap/edge
	name = "mapmanip helper marker, edge of submap"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "mapmanip_submap_edge"
