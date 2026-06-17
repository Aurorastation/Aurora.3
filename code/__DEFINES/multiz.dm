/// Attempt to get the turf below the provided one according to Z traits
#define GET_TURF_BELOW(turf) ( \
	(!(turf)) ? null : \
	((turf).turf_flags & RESERVATION_TURF) ? SSmapping.get_reservation_from_turf(turf)?.get_turf_below(turf) : \
	(!length(SSmapping.multiz_levels) || (turf).z < 1 || (turf).z > length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z] || !SSmapping.multiz_levels[(turf).z][Z_LEVEL_DOWN]) ? null : get_step((turf), DOWN))
/// Attempt to get the turf above the provided one according to Z traits
#define GET_TURF_ABOVE(turf) ( \
	(!(turf)) ? null : \
	((turf).turf_flags & RESERVATION_TURF) ? SSmapping.get_reservation_from_turf(turf)?.get_turf_above(turf) : \
	(!length(SSmapping.multiz_levels) || (turf).z < 1 || (turf).z > length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z] || !SSmapping.multiz_levels[(turf).z][Z_LEVEL_UP]) ? null : get_step((turf), UP))
