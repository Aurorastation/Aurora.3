/datum/map_template/ruin/exoplanet/crashed_pod
	name = "crashed survival pod" //This map is not very elaborate and is meant to be an example on how to make a ruin.
	id = "crashed_pod"
	description = "A crashed survival pod from a destroyed ship."
	suffix = "crashed_pod/crashed_pod.dmm"
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	spawn_weight = 0.33

/decl/submap_archetype/crashed_pod
	descriptor = "crashed survival pod"

/datum/submap/crashed_pod/sync_cell(var/obj/effect/overmap/visitable/cell)
	return

/area/map_template/crashed_pod
    name = "Crashed Pod"
    icon_state = "blue"