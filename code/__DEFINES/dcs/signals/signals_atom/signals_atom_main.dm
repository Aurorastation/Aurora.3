// Main atom signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// /atom signals
//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE "atom_init_success"
//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization and has a loc
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON "atom_init_success_on"
///from base of atom/Entered(): (atom/movable/arrived, atom/old_loc, list/atom/old_locs)
#define COMSIG_ATOM_ENTERED "atom_entered"
/// Sent from the atom that just Entered src. From base of atom/Entered(): (/atom/destination, atom/old_loc, list/atom/old_locs)
#define COMSIG_ATOM_ENTERING "atom_entering"
///from base of atom/Exit(): (/atom/movable/leaving, direction)
#define COMSIG_ATOM_EXIT "atom_exit"
	#define COMPONENT_ATOM_BLOCK_EXIT (1<<0)
///from base of atom/Exited(): (atom/movable/gone, direction)
#define COMSIG_ATOM_EXITED "atom_exited"
