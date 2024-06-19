// Turf signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of atom/has_gravity(): (atom/asker, list/forced_gravities)
#define COMSIG_TURF_HAS_GRAVITY "turf_has_gravity"

///from base of datum/thrownthing/finalize(): (turf/turf, atom/movable/thrownthing) when something is thrown and lands on us
#define COMSIG_TURF_MOVABLE_THROW_LANDED "turf_movable_throw_landed"
