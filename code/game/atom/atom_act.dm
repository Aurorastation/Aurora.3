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

/**
 * React to being hit by a thrown object
 *
 * Default behaviour is to call [hitby_react][/atom/proc/hitby_react] on ourselves after 2 seconds if we are dense
 * and under normal gravity.
 *
 * Im not sure why this the case, maybe to prevent lots of hitby's if the thrown object is
 * deleted shortly after hitting something (during explosions or other massive events that
 * throw lots of items around - singularity being a notable example)
 */
/atom/proc/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	SEND_SIGNAL(src, COMSIG_ATOM_HITBY, hitting_atom, skipcatch, hitpush, blocked, throwingdatum)
	if(density && !has_gravity(hitting_atom)) //thrown stuff bounces off dense stuff in no grav, unless the thrown stuff ends up inside what it hit(embedding, bola, etc...).
		addtimer(CALLBACK(src, PROC_REF(hitby_react), hitting_atom), 0.2 SECONDS)

/**
 * React to a hit by a projectile object
 *
 * @params
 * * hitting_projectile - projectile
 * * def_zone - zone hit
 * * piercing_hit - is this hit piercing or normal?
 */
/atom/proc/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	var/sigreturn = SEND_SIGNAL(src, COMSIG_ATOM_PRE_BULLET_ACT, hitting_projectile, def_zone)
	if(sigreturn & COMPONENT_BULLET_PIERCED)
		return BULLET_ACT_FORCE_PIERCE
	if(sigreturn & COMPONENT_BULLET_BLOCKED)
		return BULLET_ACT_BLOCK
	if(sigreturn & COMPONENT_BULLET_ACTED)
		return BULLET_ACT_HIT

	SEND_SIGNAL(src, COMSIG_ATOM_BULLET_ACT, hitting_projectile, def_zone)
	if(QDELETED(hitting_projectile)) // Signal deleted it?
		return BULLET_ACT_BLOCK

	return hitting_projectile.on_hit(
		target = src,
		// This armor check only matters for the visuals and messages in on_hit(), it's not actually used to reduce damage since
		// only living mobs use armor to reduce damage, but on_hit() is going to need the value no matter what is shot.
		blocked = check_projectile_armor(def_zone, hitting_projectile),
		def_zone = def_zone) //Last param is the zone, unlike TG's one which is piercing hit

/**
 * We have have actually hit the passed in atom
 *
 * Default behaviour is to move back from the item that hit us
 */
/atom/proc/hitby_react(atom/movable/harmed_atom)
	if(harmed_atom && isturf(harmed_atom.loc))
		step(harmed_atom, REVERSE_DIR(harmed_atom.dir))


/*
	THESE ARE LEGACY ONES, NOT UPDATED YET
*/

/atom/proc/ex_act()
	set waitfor = FALSE
	return

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT
