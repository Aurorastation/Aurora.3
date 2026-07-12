// Turf signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of atom/has_gravity(): (atom/asker, list/forced_gravities)
#define COMSIG_TURF_HAS_GRAVITY "turf_has_gravity"

///from base of turf/multiz_turf_del(): (turf/source, direction)
#define COMSIG_TURF_MULTIZ_DEL "turf_multiz_del"

///from base of turf/multiz_turf_new(): (turf/source, direction)
#define COMSIG_TURF_MULTIZ_NEW "turf_multiz_new"

///from base of datum/thrownthing/finalize(): (turf/turf, atom/movable/thrownthing) when something is thrown and lands on us
#define COMSIG_TURF_MOVABLE_THROW_LANDED "turf_movable_throw_landed"

/// Sent to turf contents when the turf no longer fully blocks light.
#define COMSIG_TURF_NO_LONGER_BLOCK_LIGHT "turf_no_longer_block_light"
