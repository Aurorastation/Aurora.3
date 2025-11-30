// Atom movable signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of atom/movable/Moved(): (/atom)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move"
	#define COMPONENT_MOVABLE_BLOCK_PRE_MOVE (1<<0)
///from base of atom/movable/Moved(): (atom/old_loc, dir, forced, list/old_locs)
#define COMSIG_MOVABLE_MOVED "movable_moved"
///from base of atom/movable/Cross(): (/atom/movable)
#define COMSIG_MOVABLE_CROSS "movable_cross"
///from base of atom/movable/Move(): (/atom/movable)
#define COMSIG_MOVABLE_CROSS_OVER "movable_cross_am"
///from base of atom/movable/Bump(): (/atom)
#define COMSIG_MOVABLE_BUMP "movable_bump"
///from base of atom/movable/newtonian_move(): (inertia_direction, start_delay)
#define COMSIG_MOVABLE_NEWTONIAN_MOVE "movable_newtonian_move"
	#define COMPONENT_MOVABLE_NEWTONIAN_BLOCK (1<<0)

///from datum/component/drift/allow_final_movement(): ()
#define COMSIG_MOVABLE_DRIFT_BLOCK_INPUT "movable_drift_block_input"
	#define DRIFT_ALLOW_INPUT (1<<0)
///from base of atom/movable/throw_impact(): (/atom/hit_atom, /datum/thrownthing/throwingdatum)
#define COMSIG_MOVABLE_PRE_IMPACT "movable_pre_impact"
	#define COMPONENT_MOVABLE_IMPACT_FLIP_HITPUSH (1<<0) //if true, flip if the impact will push what it hits
	#define COMPONENT_MOVABLE_IMPACT_NEVERMIND (1<<1) //return true if you destroyed whatever it was you're impacting and there won't be anything for hitby() to run on
///from base of atom/movable/throw_impact() after confirming a hit: (/atom/hit_atom, /datum/thrownthing/throwingdatum)
#define COMSIG_MOVABLE_IMPACT "movable_impact"

///from base of atom/movable/throw_at(): (list/args)
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"
	#define COMPONENT_CANCEL_THROW (1<<0)
///from base of atom/movable/throw_at(): (datum/thrownthing, spin)
#define COMSIG_MOVABLE_POST_THROW "movable_post_throw"
///from base of datum/thrownthing/finalize(): (obj/thrown_object, datum/thrownthing) used for when a throw is finished
#define COMSIG_MOVABLE_THROW_LANDED "movable_throw_landed"

/// from base of atom/movable/Process_Spacemove(): (movement_dir, continuous_move)
#define COMSIG_MOVABLE_SPACEMOVE "spacemove"
	#define COMSIG_MOVABLE_STOP_SPACEMOVE (1<<0)

/// From base of area/Exited(): (area/left, direction)
#define COMSIG_MOVABLE_EXITED_AREA "movable_exited_area"
