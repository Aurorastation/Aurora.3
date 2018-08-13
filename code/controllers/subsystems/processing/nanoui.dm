var/datum/controller/subsystem/processing/nanoui/SSnanoui

#define NULL_OR_EQUAL(self,other) (!(self) || (self) == (other))

/datum/controller/subsystem/processing/nanoui
	// Subsystem stuff.
	name = "NanoUI"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_NANOUI
	stat_tag = "A"

	// NanoUI stuff.
	var/list/open_uis = list()

/datum/controller/subsystem/processing/nanoui/New()
	NEW_SS_GLOBAL(SSnanoui)

 /**
  * Get an open /nanoui ui for the current user, src_object and ui_key and try to update it with data
  *
  * @param user /mob The mob who opened/owns the ui
  * @param src_object /obj|/mob The obj or mob which the ui belongs to
  * @param ui_key string A string key used for the ui
  * @param ui /datum/nanoui An existing instance of the ui (can be null)
  * @param data list The data to be passed to the ui, if it exists
  * @param force_open boolean The ui is being forced to (re)open, so close ui if it exists (instead of updating)
  *
  * @return /nanoui Returns the found ui, for null if none exists
  */
/datum/controller/subsystem/processing/nanoui/proc/try_update_ui(mob/user, src_object, ui_key, datum/nanoui/ui, data, force_open = FALSE)
	if (!ui) // no ui has been passed, so we'll search for one
		ui = get_open_ui(user, src_object, ui_key)

	if (ui)
		// The UI is already open
		if (!force_open)
			ui.push_data(data)
			return ui
		else
			ui.reinitialise(new_initial_data=data)
			return ui

	return null

 /**
  * Get an open /nanoui ui for the current user, src_object and ui_key
  *
  * @param user /mob The mob who opened/owns the ui
  * @param src_object /obj|/mob The obj or mob which the ui belongs to
  * @param ui_key string A string key used for the ui
  *
  * @return /nanoui Returns the found ui, or null if none exists
  */
/datum/controller/subsystem/processing/nanoui/proc/get_open_ui(mob/user, src_object, ui_key)
	var/src_object_key = SOFTREF(src_object)
	if (!LAZYLEN(open_uis[src_object_key]) || !LAZYLEN(open_uis[src_object_key][ui_key]))
		return null

	for (var/datum/nanoui/ui in open_uis[src_object_key][ui_key])
		if (ui.user == user)
			return ui

	//testing("nanomanager/get_open_ui mob [user.name] [src_object:name] [ui_key] - ui not found")
	return null

 /**
  * Update all /nanoui uis attached to src_object
  *
  * @param src_object /obj|/mob The obj or mob which the uis are attached to
  *
  * @return int The number of uis updated
  */
/datum/controller/subsystem/processing/nanoui/proc/update_uis(src_object)
	var/src_object_key = SOFTREF(src_object)
	if (!LAZYLEN(open_uis[src_object_key]))
		return 0

	. = 0
	var/list/obj_uis = open_uis[src_object_key]
	for (var/ui_key in obj_uis)
		for (var/thing in obj_uis[ui_key])
			var/datum/nanoui/ui = thing
			if(ui && ui.src_object && ui.user && ui.src_object.ui_host())
				ui.process(1)
				.++

 /**
  * Close all /nanoui uis attached to src_object
  *
  * @param src_object /obj|/mob The obj or mob which the uis are attached to
  *
  * @return int The number of uis close
  */
/datum/controller/subsystem/processing/nanoui/proc/close_uis(src_object)
	var/src_object_key = SOFTREF(src_object)
	if (!open_uis[src_object_key] || !islist(open_uis[src_object_key]))
		return 0

	. = 0
	var/list/obj_uis = open_uis[src_object_key]
	for (var/ui_key in obj_uis)
		for (var/thing in obj_uis[ui_key])
			var/datum/nanoui/ui = thing
			if(ui && ui.src_object && ui.user && ui.src_object.ui_host())
				ui.close()
				.++

 /**
  * Update /nanoui uis belonging to user
  *
  * @param user /mob The mob who owns the uis
  * @param src_object /obj|/mob If src_object is provided, only update uis which are attached to src_object (optional)
  * @param ui_key string If ui_key is provided, only update uis with a matching ui_key (optional)
  *
  * @return int The number of uis updated
  */
/datum/controller/subsystem/processing/nanoui/proc/update_user_uis(mob/user, src_object, ui_key)
	if (!LAZYLEN(user.open_uis))
		return 0 // has no open uis

	. = 0
	for (var/thing in user.open_uis)
		var/datum/nanoui/ui = thing
		if (NULL_OR_EQUAL(src_object, ui.src_object) && NULL_OR_EQUAL(ui_key, ui.ui_key))
			ui.process(1)
			.++

/datum/controller/subsystem/processing/nanoui/proc/close_user_uis(mob/user, src_object, ui_key)
	if (!LAZYLEN(user.open_uis))
		return 0

	for (var/thing in user.open_uis)
		var/datum/nanoui/ui = thing
		if (NULL_OR_EQUAL(src_object, ui.src_object) && NULL_OR_EQUAL(ui_key, ui.ui_key))
			ui.close()
			.++

	//testing("nanomanager/close_user_uis mob [user.name] closed [open_uis.len] of [.] uis")

 /**
  * Add a /nanoui ui to the list of open uis
  * This is called by the /nanoui open() proc
  *
  * @param ui /nanoui The ui to add
  *
  * @return nothing
  */
/datum/controller/subsystem/processing/nanoui/proc/ui_opened(datum/nanoui/ui)
	var/src_object_key = SOFTREF(ui.src_object)
	LAZYINITLIST(open_uis[src_object_key])

	LAZYADD(ui.user.open_uis, ui)
	LAZYADD(open_uis[src_object_key][ui.ui_key], ui)
	START_PROCESSING(SSnanoui, ui)
	//testing("nanomanager/ui_opened mob [ui.user.name] [ui.src_object:name] [ui.ui_key] - user.open_uis [ui.user.open_uis.len] | uis [uis.len] | processing_uis [processing_uis.len]")

 /**
  * Remove a /nanoui ui from the list of open uis
  * This is called by the /nanoui close() proc
  *
  * @param ui /nanoui The ui to remove
  *
  * @return int 0 if no ui was removed, 1 if removed successfully
  */
/datum/controller/subsystem/processing/nanoui/proc/ui_closed(datum/nanoui/ui)
	var/src_object_key = SOFTREF(ui.src_object)
	var/ui_key = ui.ui_key
	var/list/obj_uis = open_uis[src_object_key]

	if (!LAZYLEN(obj_uis) || !obj_uis[ui_key])
		return 0	// Wasn't open.

	STOP_PROCESSING(SSnanoui, ui)
	if(ui.user)	// Sanity check in case a user has been deleted (say a blown up borg watching the alarm interface)
		LAZYREMOVE(ui.user.open_uis, ui)

	obj_uis[ui_key] -= ui

	if (!LAZYLEN(obj_uis[ui_key]))
		obj_uis -= ui_key

	if (!LAZYLEN(obj_uis))
		open_uis -= src_object_key

	//testing("nanomanager/ui_closed mob [ui.user.name] [ui.src_object:name] [ui.ui_key] - user.open_uis [ui.user.open_uis.len] | uis [uis.len] | processing_uis [processing_uis.len]")

	return 1

 /**
  * This is called on user logout
  * Closes/clears all uis attached to the user's /mob
  *
  * @param user /mob The user's mob
  *
  * @return nothing
  */
/datum/controller/subsystem/processing/nanoui/proc/user_logout(mob/user)
	return close_user_uis(user)

 /**
  * This is called when a player transfers from one mob to another
  * Transfers all open UIs to the new mob
  *
  * @param oldMob /mob The user's old mob
  * @param newMob /mob The user's new mob
  *
  * @return nothing
  */
/datum/controller/subsystem/processing/nanoui/proc/user_transferred(mob/oldMob, mob/newMob)
	//testing("nanomanager/user_transferred from mob [oldMob.name] to mob [newMob.name]")
	if (!oldMob || !LAZYLEN(oldMob.open_uis) || !LAZYLEN(open_uis))
		//testing("nanomanager/user_transferred mob [oldMob.name] has no open uis")
		return 0 // has no open uis

	for (var/thing in oldMob.open_uis)
		var/datum/nanoui/ui = thing
		ui.user = newMob
		LAZYADD(newMob.open_uis, ui)

	oldMob.open_uis = null

	return 1 // success

/datum/asset/nanoui_templates/register()
	var/list/nano_asset_dirs = list(
		"nano/images/",
		"nano/images/status_icons/",
		"nano/templates/"
	)

	var/list/filenames = null
	for (var/path in nano_asset_dirs)
		filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // filenames which end in "/" are actually directories, which we want to ignore
				var/fullpath = path + filename
				if(fexists(fullpath))
					register_asset(filename, fcopy_rsc(fullpath))

/datum/asset/simple/nanoui_common
	assets = list(
		"libraries.min.js" = 'nano/js/libraries.min.js',
		"nano_base_callbacks.js" = 'nano/js/nano_base_callbacks.js',
		"nano_base_helpers.js" = 'nano/js/nano_base_helpers.js',
		"nano_state.js" = 'nano/js/nano_state.js',
		"nano_state_default.js" = 'nano/js/nano_state_default.js',
		"nano_state_manager.js" = 'nano/js/nano_state_manager.js',
		"nano_template.js" = 'nano/js/nano_template.js',
		"nano_utility.js" = 'nano/js/nano_utility.js',
		"icons.css" = 'nano/css/icons.css',
		"layout_basic.css" = 'nano/css/layout_basic.css',
		"layout_default.css" = 'nano/css/layout_default.css',
		"shared.css" = 'nano/css/shared.css'
	)

#undef NULL_OR_EQUAL
