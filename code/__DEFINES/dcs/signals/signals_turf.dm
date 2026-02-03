// Turf signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of atom/has_gravity(): (atom/asker, list/forced_gravities)
#define COMSIG_TURF_HAS_GRAVITY "turf_has_gravity"

///from base of datum/thrownthing/finalize(): (turf/turf, atom/movable/thrownthing) when something is thrown and lands on us
#define COMSIG_TURF_MOVABLE_THROW_LANDED "turf_movable_throw_landed"

///from base of /datum/turf_reservation/proc/Release: (datum/turf_reservation/reservation)
#define COMSIG_TURF_RESERVATION_RELEASED "turf_reservation_released"

///from base of turf/proc/on_shuttle_move(): (turf/new_turf)
#define COMSIG_TURF_ON_SHUTTLE_MOVE "turf_on_shuttle_move"

///from /turf/proc/after_shuttle_move() : (/turf/old_turf)
#define COMSIG_TURF_AFTER_SHUTTLE_MOVE "turf_after_shuttle_move"

///from /proc/create_shuttle() and /proc/expand_shuttle() : (obj/docking_port/mobile/shuttle)
#define COMSIG_TURF_ADDED_TO_SHUTTLE "turf_added_to_shuttle"

///from /proc/clear_empty_shuttle_turfs() : (obj/docking_port/mobile/shuttle)
#define COMSIG_TURF_REMOVED_FROM_SHUTTLE "turf_removed_from_shuttle"
