ABSTRACT_TYPE(/turf/closed)
	//layer = CLOSED_TURF_LAYER wildtodo
	//plane = WALL_PLANE
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	pass_flags_self = PASSCLOSEDTURF

/turf/closed/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE
