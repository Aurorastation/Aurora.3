// Main atom signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// /atom signals
//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE "atom_init_success"
//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization and has a loc
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON "atom_init_success_on"
///from base of atom/examine(): (/mob, list/examine_text)
#define COMSIG_ATOM_EXAMINE "atom_examine"
///from base of atom/examine_tags(): (/mob, list/examine_tags)
#define COMSIG_ATOM_EXAMINE_TAGS "atom_examine_tags"
///from base of atom/Entered(): (atom/movable/arrived, atom/old_loc, list/atom/old_locs)
#define COMSIG_ATOM_ENTERED "atom_entered"
/// Sent from the atom that just Entered src. From base of atom/Entered(): (/atom/destination, atom/old_loc, list/atom/old_locs)
#define COMSIG_ATOM_ENTERING "atom_entering"
///from base of atom/Exit(): (/atom/movable/leaving, direction)
#define COMSIG_ATOM_EXIT "atom_exit"
	#define COMPONENT_ATOM_BLOCK_EXIT (1<<0)
///from base of atom/Exited(): (atom/movable/gone, direction)
#define COMSIG_ATOM_EXITED "atom_exited"
///from base of atom/Bumped(): (/atom) **DIFFERS FROM TG THAT IS /atom/movable**
#define COMSIG_ATOM_BUMPED "atom_bumped"
///from base of atom/has_gravity(): (turf/location, list/forced_gravities)
#define COMSIG_ATOM_HAS_GRAVITY "atom_has_gravity"

///from base of atom/set_dir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"

///called when an atom starts orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_BEGIN "atom_orbit_begin"
///called when an atom stops orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_STOP "atom_orbit_stop"

///from base of atom/throw_impact, sent by the target hit by a thrown object. (hit_atom, thrown_atom, datum/thrownthing/throwingdatum)
#define COMSIG_ATOM_PREHITBY "atom_pre_hitby"
	#define COMSIG_HIT_PREVENTED (1<<0)
///from base of atom/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
#define COMSIG_ATOM_HITBY "atom_hitby"

/// Called on [/atom/SpinAnimation()] : (speed, loops, segments, angle)
#define COMSIG_ATOM_SPIN_ANIMATION "atom_spin_animation"

/// Called when certain atoms are deconstructed, currently implemented on walls and floors
#define COMSIG_ATOM_DECONSTRUCTED "atom_deconstructed"

/// From /atom/proc/set_density(new_value) for when an atom changes density
#define COMSIG_ATOM_DENSITY_CHANGED "atom_density_change"

//from atom/set_light(): (l_range, l_power, l_color, l_on)
#define COMSIG_ATOM_SET_LIGHT "atom_set_light"
	#define COMPONENT_BLOCK_LIGHT_UPDATE (1<<0)

///Called right before the atom changes the value of light_range to a different one, from base atom/set_light_range(): (new_range)
#define COMSIG_ATOM_SET_LIGHT_RANGE "atom_set_light_range"
///Called right after the atom changes the value of light_range to a different one, from base atom/set_light_range(): (old_range)
#define COMSIG_ATOM_UPDATE_LIGHT_RANGE "atom_update_light_range"
///Called right before the atom changes the value of light_power to a different one, from base atom/set_light_power(): (new_power)
#define COMSIG_ATOM_SET_LIGHT_POWER "atom_set_light_power"
///Called right after the atom changes the value of light_power to a different one, from base atom/set_light_power(): (old_power)
#define COMSIG_ATOM_UPDATE_LIGHT_POWER "atom_update_light_power"
///Called right before the atom changes the value of light_color to a different one, from base atom/set_light_color(): (new_color)
#define COMSIG_ATOM_SET_LIGHT_COLOR "atom_set_light_color"
///Called right after the atom changes the value of light_color to a different one, from base atom/set_light_color(): (old_color)
#define COMSIG_ATOM_UPDATE_LIGHT_COLOR "atom_update_light_color"
///Called right before the atom changes the value of light_angle to a different one, from base atom/set_light_angle(): (new_angle)
#define COMSIG_ATOM_SET_LIGHT_ANGLE "atom_set_light_angle"
///Called right after the atom changes the value of light_angle to a different one, from base atom/set_light_angle(): (old_angle)
#define COMSIG_ATOM_UPDATE_LIGHT_ANGLE "atom_update_light_angle"
///Called right before the atom changes the value of light_dir to a different one, from base atom/set_light_dir(): (new_dir)
#define COMSIG_ATOM_SET_LIGHT_DIR "atom_set_light_dir"
///Called right after the atom changes the value of light_dir to a different one, from base atom/set_light_dir(): (old_dir)
#define COMSIG_ATOM_UPDATE_LIGHT_DIR "atom_update_light_dir"
///Called right before the atom changes the value of light_on to a different one, from base atom/set_light_on(): (new_value)
#define COMSIG_ATOM_SET_LIGHT_ON "atom_set_light_on"
///Called right after the atom changes the value of light_on to a different one, from base atom/set_light_on(): (old_value)
#define COMSIG_ATOM_UPDATE_LIGHT_ON "atom_update_light_on"
///Called right before the atom changes the value of light_height to a different one, from base atom/set_light_height(): (new_value)
#define COMSIG_ATOM_SET_LIGHT_HEIGHT "atom_set_light_height"
///Called right after the atom changes the value of light_height to a different one, from base atom/set_light_height(): (old_value)
#define COMSIG_ATOM_UPDATE_LIGHT_HEIGHT "atom_update_light_height"
///Called right before the atom changes the value of light_flags to a different one, from base atom/set_light_flags(): (new_value)
#define COMSIG_ATOM_SET_LIGHT_FLAGS "atom_set_light_flags"
///Called right after the atom changes the value of light_flags to a different one, from base atom/set_light_flags(): (old_flags)
#define COMSIG_ATOM_UPDATE_LIGHT_FLAGS "atom_update_light_flags"
///Called right before the atom changes the value of light_render_source to a different one, from base atom/set_light_render_source(): (new_render_source)
#define COMSIG_ATOM_SET_LIGHT_RENDER_SOURCE "atom_set_light_render_source"
///Called right after the atom changes the value of light_render_source to a different one, from base atom/set_light_render_source(): (old_render_source)
#define COMSIG_ATOM_UPDATE_LIGHT_RENDER_SOURCE "atom_update_light_render_source"

///Called when an atom's overlay component applies visuals: (image/mask, image/cone, atom/movable/light_holder)
#define COMSIG_ATOM_OVERLAY_LIGHT_APPLIED "atom_overlay_light_applied"
///Above, but sent to the holder of the light instead of the light source itself: (image/mask, image/cone, atom/movable/light_source)
#define COMSIG_ATOM_HOLDER_OVERLAY_LIGHT_APPLIED "atom_holder_overlay_light_applied"
///Called when an atom's overlay component hides visuals: (atom/movable/light_holder)
#define COMSIG_ATOM_OVERLAY_LIGHT_REMOVED "atom_overlay_light_removed"
///Above, but sent to the holder of the light instead of the light source itself: (atom/movable/light_source)
#define COMSIG_ATOM_HOLDER_OVERLAY_LIGHT_REMOVED "atom_holder_overlay_light_removed"
///Called when a light middleman captures or refreshes overlay light appearances.
#define COMSIG_LIGHT_MIDDLEMAN_UPDATED "light_middleman_updated"

///from base of atom/set_opacity(): (new_opacity)
#define COMSIG_ATOM_SET_OPACITY "atom_set_opacity"
