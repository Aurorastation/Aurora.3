// Atom movement signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of atom/relaymove(): (mob/living/user, direction)
#define COMSIG_ATOM_RELAYMOVE "atom_relaymove"
	///prevents the "you cannot move while buckled! message" -- At the moment, this doesn't do it in our codebase, pending to have driving and buckling implementation updated
	#define COMSIG_BLOCK_RELAYMOVE (1<<0)

///From base of /datum/move_loop/process() after attempting to move a movable: (datum/move_loop/loop, old_dir)
#define COMSIG_MOVABLE_MOVED_FROM_LOOP "movable_moved_from_loop"

/// From base of /atom/movable/before_shuttle_move (turf/newT, direction, move_mode, /obj/effect/shuttle_landmark/shuttle)
#define COMSIG_ATOM_BEFORE_SHUTTLE_MOVE "movable_before_shuttle_move"
	// Docking turf movement return values - return a combination of these to override the move_mode for the turf containing the atom
	#define COMPONENT_MOVE_TURF MOVE_TURF
	#define COMPONENT_MOVE_AREA MOVE_AREA
	#define COMPONENT_MOVE_CONTENTS MOVE_CONTENTS
/// From base of /atom/movable/after_shuttle_move (turf/oldT)
#define COMSIG_ATOM_AFTER_SHUTTLE_MOVE "movable_after_shuttle_move"
