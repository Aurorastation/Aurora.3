GENERAL_PROTECT_DATUM(/datum/admin_verb)

/**
 * Singleton datum describing one admin verb assignment.
 * New admin tooling should use ADMIN_VERB() so this datum and the client verb stay together.
 */
/datum/admin_verb
	var/name
	var/description
	var/category
	var/permissions = R_NONE
	var/visibility_flag
	var/allows_storyteller = FALSE
	var/paranoid_debug = FALSE
	VAR_PROTECTED/verb_path

/datum/admin_verb/New()
	. = ..()
	var/procpath/path = verb_path
	if(path)
		if(isnull(name))
			name = path.name
		if(isnull(description))
			description = path.desc
		if(isnull(category))
			category = path.category

/datum/admin_verb/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	return ..()

/datum/admin_verb/proc/effective_permissions(client/admin)
	var/verb_permissions = permissions
	if(paranoid_debug && GLOB.config?.debugparanoid && !(admin.holder?.rights & R_ADMIN))
		verb_permissions &= ~R_DEBUG
	return verb_permissions

/datum/admin_verb/proc/can_assign_to_client(client/admin)
	if(!istype(admin))
		return FALSE

	if(admin.holder)
		if(permissions == R_NONE)
			return TRUE

		var/verb_permissions = effective_permissions(admin)
		if(verb_permissions && (admin.holder.rights & verb_permissions))
			return TRUE

	return allows_storyteller && isstoryteller(admin.mob)

/// Assigns the verb to the admin.
/datum/admin_verb/proc/assign_to_client(client/admin)
	add_verb(admin, verb_path)

/// Unassigns the verb from the admin.
/datum/admin_verb/proc/unassign_from_client(client/admin)
	remove_verb(admin, verb_path)
