var/datum/controller/subsystem/processing/vueui/SSvueui

/*
Byond Vue UI framework's management subsystem
*/
/datum/controller/subsystem/processing/vueui
	name = "VueUI"
	flags = 0
	init_order = SS_INIT_MISC_FIRST
	priority = SS_PRIORITY_NANOUI
	stat_tag = "O"

	var/list/open_uis
	var/list/var_monitor_map

/datum/controller/subsystem/processing/vueui/New()
	LAZYINITLIST(open_uis)
	NEW_SS_GLOBAL(SSvueui)

/datum/controller/subsystem/processing/vueui/Initialize(timeofday)
	var_monitor_map = list()
	for (var/path in subtypesof(/datum/vueui_var_monitor))
		var/datum/vueui_var_monitor/VM = new path()
		var_monitor_map[VM.subject_type] = VM
	..()

/**
  * Gets a vueui_var_monitor associated with the given source type.
  *
  * @param subject - the object we're querying a monitor for.
  *
  * @return a vueui_var_monitor associated with the type, or null.
  */
/datum/controller/subsystem/processing/vueui/proc/get_var_monitor(datum/subject)
	return var_monitor_map[subject.type]

/**
  * Gets open ui for specified object and user
  *
  * @param user - user that has that ui open
  * @param src_object - object that hosts the ui we are looking for
  *
  * @return ui datum or null
  */
/datum/controller/subsystem/processing/vueui/proc/get_open_ui(var/mob/user, var/src_object)
	for (var/datum/vueui/ui in get_open_uis(src_object))
		if (ui.user == user)
			return ui

	return null

/**
  * Gets open uis for specified object
  *
  * @param src_object - object that hosts the ui we are looking for
  *
  * @return list of UI datums or null
  */
/datum/controller/subsystem/processing/vueui/proc/get_open_uis(var/src_object)
	var/src_object_key = SOFTREF(src_object)
	if (!LAZYLEN(open_uis[src_object_key]))
		return null

	return open_uis[src_object_key]

/**
  * Closes open uis for that object
  *
  * @param src_object - object that hosts the uis that we want to close
  *
  * @return number of uis closed
  */
/datum/controller/subsystem/processing/vueui/proc/close_uis(var/src_object)
	. = 0
	for (var/tui in get_open_uis(src_object))
		var/datum/vueui/ui = tui
		ui.close()
		.++

/**
  * Initiates check for data change of specified object
  *
  * @param src_object - object that hosts ui that should be updated
  */
/datum/controller/subsystem/processing/vueui/proc/check_uis_for_change(var/src_object)
	for (var/datum/vueui/ui in get_open_uis(src_object))
		ui.update_status(TRUE, TRUE)

/**
  * Initiates check for data change of specified object
  *
  * @param user - user who's ui's has to be closed
  * @param src_object - object that hosts ui that should be closed. Optional
  *
  * @return number of uis closed
  */
/datum/controller/subsystem/processing/vueui/proc/close_user_uis(var/mob/user, var/src_object)
	if (!LAZYLEN(user.open_vueui_uis))
		return 0

	for (var/datum/vueui/ui in user.open_vueui_uis)
		if (NULL_OR_EQUAL(src_object, ui.object))
			ui.close()
			.++

/**
  * Alerts of subsystem of opened ui, and starts processing it.
  *
  * @param ui - ui that got opened
  */
/datum/controller/subsystem/processing/vueui/proc/ui_opened(var/datum/vueui/ui)
	var/src_object_key = SOFTREF(ui.object)
	LAZYINITLIST(open_uis[src_object_key])
	LAZYINITLIST(ui.user.open_vueui_uis)
	LAZYADD(ui.user.open_vueui_uis, ui)
	LAZYADD(open_uis[src_object_key], ui)
	START_PROCESSING(SSvueui, ui)

/**
  * Alerts of subsystem of closed ui, and stops processing it.
  *
  * @param ui - ui that got closed
  *
  * @return 0 if failed, 1 if success
  */
/datum/controller/subsystem/processing/vueui/proc/ui_closed(var/datum/vueui/ui)
	var/src_object_key = SOFTREF(ui.object)

	if (!LAZYLEN(open_uis[src_object_key]))
		return 0	// Wasn't open.

	STOP_PROCESSING(SSvueui, ui)
	if(!QDELETED(ui.user))	// Sanity check in case a user has been deleted (say a blown up borg watching the alarm interface)
		LAZYREMOVE(ui.user.open_vueui_uis, ui)

	open_uis[src_object_key] -= ui

	if (!LAZYLEN(open_uis[src_object_key]))
		open_uis -= src_object_key
	return 1

/**
  * Alerts of subsystem of logged off user and closes there uis.
  *
  * @param ui - ui that got closed
  *
  * @return number of uis closed
  */
/datum/controller/subsystem/processing/vueui/proc/user_logout(var/mob/user)
	return close_user_uis(user)

/**
  * Alerts of subsystem of user client transfer to other mob.
  *
  * @param oldMob - mob that had ui opened
  * @param newMob - mob to whome ui was transfered
  *
  * @return 0 if failed, 1 if success
  */
/datum/controller/subsystem/processing/vueui/proc/user_transferred(var/mob/oldMob, var/mob/newMob)
	if (!oldMob || !LAZYLEN(oldMob.open_vueui_uis) || !LAZYLEN(open_uis))
		return 0

	for (var/thing in oldMob.open_vueui_uis)
		var/datum/vueui/ui = thing
		ui.user = newMob
		LAZYADD(newMob.open_vueui_uis, ui)

	oldMob.open_vueui_uis = null

	return 1 // success

/**
  * Transfers ui from one object to other
  *
  * @param old_object - object from whom uis should be transfered
  * @param new_object - object that receves uis
  * @param new_activeui - Vue component name to be used in ui with new object
  * @param new_data - initial data for this transfered ui
  *
  * @return list of transfered uis
  */
/datum/controller/subsystem/processing/vueui/proc/transfer_uis(var/old_object, var/new_object, var/new_activeui = null, var/nwidth = 0, var/nheight = 0, var/new_title = null, var/new_data = null)
	var/old_object_key = SOFTREF(old_object)
	var/new_object_key = SOFTREF(new_object)
	. = list()
	LAZYINITLIST(open_uis[new_object_key])

	for(var/datum/vueui/ui in open_uis[old_object_key])
		ui.object.vueui_on_transfer(ui)
		ui.object = new_object
		if(new_activeui) {ui.activeui = new_activeui}
		if(new_title) {ui.title = new_title}
		ui.data = new_data
		open_uis[old_object_key] -= ui
		LAZYADD(open_uis[new_object_key], ui)
		ui.resize(nwidth, nheight)
		ui.update_status(1)
		. += ui

	if (!LAZYLEN(open_uis[old_object_key]))
		open_uis -= old_object_key

#undef NULL_OR_EQUAL
