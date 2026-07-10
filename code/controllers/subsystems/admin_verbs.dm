GENERAL_PROTECT_DATUM(/datum/controller/subsystem/admin_verbs)

SUBSYSTEM_DEF(admin_verbs)
	name = "Admin Verbs"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_ADMIN_VERBS
	init_stage = INITSTAGE_EARLY

	/// All admin verb singleton datums, indexed by type.
	var/list/datum/admin_verb/admin_verbs_by_type = list()
	/// Admin verb singleton datums grouped by visibility flag.
	var/list/list/datum/admin_verb/admin_verbs_by_visibility_flag = list()
	/// Associated clients and their enabled visibility flags.
	var/list/admin_visibility_flags = list()
	/// Clients waiting for this subsystem to finish initialization.
	var/list/admins_pending_subsystem_init = list()

/datum/controller/subsystem/admin_verbs/Initialize()
	if(!length(admin_verbs_by_type))
		setup_verb_list()
	process_pending_admins()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/admin_verbs/Recover()
	admin_verbs_by_type = SSadmin_verbs.admin_verbs_by_type
	admin_verbs_by_visibility_flag = SSadmin_verbs.admin_verbs_by_visibility_flag
	admin_visibility_flags = SSadmin_verbs.admin_visibility_flags
	admins_pending_subsystem_init = SSadmin_verbs.admins_pending_subsystem_init

/datum/controller/subsystem/admin_verbs/stat_entry(msg)
	msg = "V:[length(admin_verbs_by_type)]"
	return ..()

/datum/controller/subsystem/admin_verbs/proc/process_pending_admins()
	var/list/pending_admins = admins_pending_subsystem_init
	admins_pending_subsystem_init = null
	for(var/admin_ckey in pending_admins)
		var/client/admin = GLOB.directory[admin_ckey]
		if(admin)
			assosciate_admin(admin)

/datum/controller/subsystem/admin_verbs/proc/setup_verb_list()
	if(length(admin_verbs_by_type))
		CRASH("Attempting to setup admin verbs twice.")

	for(var/datum/admin_verb/verb_type as anything in subtypesof(/datum/admin_verb))
		var/datum/admin_verb/verb_singleton = new verb_type
		if(!verb_singleton.__avd_check_should_exist())
			qdel(verb_singleton, force = TRUE)
			continue

		admin_verbs_by_type[verb_type] = verb_singleton
		if(verb_singleton.visibility_flag)
			if(!(verb_singleton.visibility_flag in admin_verbs_by_visibility_flag))
				admin_verbs_by_visibility_flag[verb_singleton.visibility_flag] = list()
			admin_verbs_by_visibility_flag[verb_singleton.visibility_flag] |= list(verb_singleton)

/datum/controller/subsystem/admin_verbs/proc/get_valid_verbs_for_client(client/admin)
	if(!admin?.holder && !isstoryteller(admin?.mob))
		CRASH("Attempted to get admin verbs for a non-admin client.")

	var/list/valid_verbs = list()
	for(var/verb_type in admin_verbs_by_type)
		var/datum/admin_verb/verb_singleton = admin_verbs_by_type[verb_type]
		if(!verify_visibility(admin, verb_singleton))
			continue
		if(verb_singleton.can_assign_to_client(admin))
			valid_verbs += verb_singleton

	return valid_verbs

/datum/controller/subsystem/admin_verbs/proc/verify_visibility(client/admin, datum/admin_verb/verb_singleton)
	var/needed_flag = verb_singleton.visibility_flag
	if(!needed_flag)
		return TRUE

	var/list/visibility_flags = admin_visibility_flags[admin.ckey]
	return visibility_flags && (needed_flag in visibility_flags)

/datum/controller/subsystem/admin_verbs/proc/default_visibility_flags(client/admin)
	var/list/flags = list(ADMIN_VERB_VISIBLITY_FLAG_HIDEABLE)
	if(isnull(admin.address) || GLOB.localhost_addresses[admin.address])
		flags |= ADMIN_VERB_VISIBLITY_FLAG_LOCALHOST
	return flags

/datum/controller/subsystem/admin_verbs/proc/ensure_visibility_flags(client/admin)
	if(!(admin.ckey in admin_visibility_flags))
		admin_visibility_flags[admin.ckey] = default_visibility_flags(admin)
		return

	var/list/visibility_flags = admin_visibility_flags[admin.ckey]
	if(isnull(admin.address) || GLOB.localhost_addresses[admin.address])
		visibility_flags |= ADMIN_VERB_VISIBLITY_FLAG_LOCALHOST
	else
		visibility_flags -= ADMIN_VERB_VISIBLITY_FLAG_LOCALHOST

/datum/controller/subsystem/admin_verbs/proc/remove_registered_verbs(client/admin)
	for(var/verb_type in admin_verbs_by_type)
		var/datum/admin_verb/verb_singleton = admin_verbs_by_type[verb_type]
		verb_singleton.unassign_from_client(admin)
	remove_verb(admin, /client/proc/show_verbs)

/datum/controller/subsystem/admin_verbs/proc/update_visibility_flag(client/admin, flag, state)
	if(!istype(admin))
		return

	if(!isnull(admins_pending_subsystem_init))
		admins_pending_subsystem_init |= admin.ckey
		return

	ensure_visibility_flags(admin)

	if(state)
		admin_visibility_flags[admin.ckey] |= list(flag)
		assosciate_admin(admin)
		return

	admin_visibility_flags[admin.ckey] -= list(flag)
	for(var/datum/admin_verb/verb_singleton as anything in admin_verbs_by_visibility_flag[flag])
		verb_singleton.unassign_from_client(admin)
	admin.init_verbs()

/datum/controller/subsystem/admin_verbs/proc/dynamic_invoke_verb(client/admin, datum/admin_verb/verb_type, ...)
	if(ismob(admin))
		var/mob/admin_mob = admin
		admin = admin_mob.client

	if(!istype(admin))
		CRASH("Attempted to dynamically invoke admin verb '[verb_type]' without a valid client.")
	if(!ispath(verb_type, /datum/admin_verb) || verb_type == /datum/admin_verb)
		CRASH("Attempted to dynamically invoke admin verb with invalid typepath '[verb_type]'.")

	var/list/verb_args = args.Copy()
	verb_args.Cut(2, 3)
	verb_args[1] = admin

	var/datum/admin_verb/verb_singleton = admin_verbs_by_type[verb_type]
	if(isnull(verb_singleton))
		CRASH("Attempted to dynamically invoke admin verb '[verb_type]' that does not exist.")

	if(!verb_singleton.can_assign_to_client(admin) || !verify_visibility(admin, verb_singleton))
		to_chat(admin, SPAN_WARNING("You lack the permissions to do this."))
		return

	var/old_usr = usr
	usr = admin.mob
	verb_singleton.__avd_do_verb(arglist(verb_args))
	usr = old_usr

/**
 * Associates or resyncs an admin or storyteller with their accessible admin verbs.
 */
/datum/controller/subsystem/admin_verbs/proc/assosciate_admin(client/admin)
	if(!istype(admin))
		return

	if(!isnull(admins_pending_subsystem_init))
		to_chat(admin, SPAN_NOTICE("Admin verbs are still initializing. Your verbs will be assigned automatically."))
		admins_pending_subsystem_init |= admin.ckey
		return

	if(!admin.holder && !isstoryteller(admin.mob))
		return

	ensure_visibility_flags(admin)
	remove_registered_verbs(admin)
	if(!admin.holder || !(admin.holder.rights & (R_DEBUG|R_DEV)))
		remove_verb(admin, GLOB.debug_verbs)

	for(var/datum/admin_verb/verb_singleton as anything in get_valid_verbs_for_client(admin))
		verb_singleton.assign_to_client(admin)

	admin.add_aooc_if_necessary()
	admin.init_verbs()

/datum/controller/subsystem/admin_verbs/proc/associate_admin(client/admin)
	return assosciate_admin(admin)

/**
 * Unassociates a client from all registered admin verbs.
 */
/datum/controller/subsystem/admin_verbs/proc/deassosciate_admin(client/admin, clear_visibility_flags = TRUE, refresh_verbs = TRUE, restore_aooc = TRUE)
	if(!istype(admin))
		return

	if(!isnull(admins_pending_subsystem_init))
		admins_pending_subsystem_init -= admin.ckey

	remove_registered_verbs(admin)
	remove_verb(admin, GLOB.debug_verbs)
	remove_verb(admin, /client/proc/show_verbs)

	if(clear_visibility_flags)
		admin_visibility_flags -= list(admin.ckey)

	if(restore_aooc)
		admin.add_aooc_if_necessary()
	if(refresh_verbs)
		admin.init_verbs()

/datum/controller/subsystem/admin_verbs/proc/deassociate_admin(client/admin, clear_visibility_flags = TRUE, refresh_verbs = TRUE, restore_aooc = TRUE)
	return deassosciate_admin(admin, clear_visibility_flags, refresh_verbs, restore_aooc)

/datum/controller/subsystem/admin_verbs/proc/hide_all_verbs(client/admin)
	deassosciate_admin(admin, clear_visibility_flags = FALSE, refresh_verbs = FALSE)
	add_verb(admin, /client/proc/show_verbs)
	admin.init_verbs()
