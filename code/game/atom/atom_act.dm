/*
 * +++++++++++++++++++++++++++++++++++++++++ ABOUT THIS FILE +++++++++++++++++++++++++++++++++++++++++++++
 * Not everything here necessarily has the name pattern of [x]_act()
 * This is a file for various atom procs that simply get called when something is happening to that atom.
 * If you're adding something here, you likely want a signal and SHOULD_CALL_PARENT(TRUE)
 * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */

/**
 * Respond to fire being used on our atom
 *
 * Default behaviour is to send [COMSIG_ATOM_FIRE_ACT] and return
 *
 * * exposed_temperature - The temperature the atom was exposed to, in kelvin
 * * exposed_volume - The volume the atom was exposed to, in units
 */
/atom/proc/fire_act(exposed_temperature, exposed_volume)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_FIRE_ACT, exposed_temperature, exposed_volume)
	return


/*
	THESE ARE LEGACY ONES, NOT UPDATED YET
*/

/atom/proc/ex_act()
	set waitfor = FALSE
	return

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT
