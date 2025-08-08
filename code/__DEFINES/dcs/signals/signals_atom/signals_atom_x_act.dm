// Atom x_act() procs signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of atom/emp_act(): (severity). return EMP protection flags
#define COMSIG_ATOM_PRE_EMP_ACT "atom_emp_act"
///from base of atom/emp_act(): (severity, protection)
#define COMSIG_ATOM_EMP_ACT "atom_emp_act"
///from base of atom/fire_act(): (exposed_temperature, exposed_volume)
#define COMSIG_ATOM_FIRE_ACT "atom_fire_act"
///from base of atom/bullet_act(): (/obj/projectile, def_zone)
#define COMSIG_ATOM_PRE_BULLET_ACT "pre_atom_bullet_act"
	/// All this does is prevent default bullet on_hit from being called, [BULLET_ACT_HIT] being return is implied
	#define COMPONENT_BULLET_ACTED (1<<0)
	/// Forces bullet act to return [BULLET_ACT_BLOCK], takes priority over above
	#define COMPONENT_BULLET_BLOCKED (1<<1)
	/// Forces bullet act to return [BULLET_ACT_FORCE_PIERCE], takes priority over above
	#define COMPONENT_BULLET_PIERCED (1<<2)
///from base of atom/bullet_act(): (/obj/projectile, def_zone)
#define COMSIG_ATOM_BULLET_ACT "atom_bullet_act"
/// Sent from [atom/proc/item_interaction], when this atom is left-clicked on by a mob with an item
/// Sent from the very beginning of the click chain, intended for generic atom-item interactions
/// Args: (mob/living/user, obj/item/tool, list/modifiers)
/// Return any ITEM_INTERACT_ flags as relevant (see tools.dm)
#define COMSIG_ATOM_ITEM_INTERACTION "atom_item_interaction"
