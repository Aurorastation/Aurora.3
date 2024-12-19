/*
	AURORA NOTE: INTERACT_ATOM_MOUSEDROP_IGNORE_USABILITY is not implemented at the moment, it's kept only to keep the INTERACT_ATOM_MOUSEDROP_IGNORE_CHECKS the same
*/

/// Bypass all adjacency checks for mouse drop
#define INTERACT_ATOM_MOUSEDROP_IGNORE_ADJACENT (1<<11)
/// Bypass all can_perform_action checks for mouse drop
#define INTERACT_ATOM_MOUSEDROP_IGNORE_USABILITY (1<<12)
/// Bypass all adjacency and other checks for mouse drop
#define INTERACT_ATOM_MOUSEDROP_IGNORE_CHECKS (INTERACT_ATOM_MOUSEDROP_IGNORE_ADJACENT | INTERACT_ATOM_MOUSEDROP_IGNORE_USABILITY)
