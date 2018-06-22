var/datum/controller/subsystem/processing/vueui/SSvueui

#define NULL_OR_EQUAL(self,other) (!(self) || (self) == (other))

/*
Byond Vue UI framework's management subsystem
*/
/datum/controller/subsystem/processing/vueui
    name = "VueUI"
    flags = SS_NO_INIT
    priority = SS_PRIORITY_NANOUI
    stat_tag = "O"

    var/list/open_uis

/datum/controller/subsystem/processing/vueui/New()
    LAZYINITLIST(open_uis)
    NEW_SS_GLOBAL(SSvueui)


/**
  * Gets open ui for specified object and user
  *
  * @param user - user that has that ui open
  * @param src_object - object that hosts the ui we are looking for
  *
  * @return ui datum
  */ 
/datum/controller/subsystem/processing/vueui/proc/get_open_ui(mob/user, src_object)
    for (var/datum/vueuiui/ui in get_open_uis(src_object))
        if (ui.user == user)
            return ui

    return null

/**
  * Gets open uis for specified object
  *
  * @param src_object - object that hosts the ui we are looking for
  *
  * @return list of ui datums
  */ 
/datum/controller/subsystem/processing/vueui/proc/get_open_uis(src_object)
    var/src_object_key = SOFTREF(src_object)
    if (!LAZYLEN(open_uis[src_object_key]))
        return null
        
    return open_uis[src_object_key]

/**
  * Initiates check for data change of specified object
  *
  * @param src_object - object that hosts ui that should be updated
  *
  * @return nothing
  */ 
/datum/controller/subsystem/processing/vueui/proc/check_uis_for_change(src_object)
    for (var/datum/vueuiui/ui in get_open_uis(src_object))
        ui.check_for_change()

/**
  * Initiates check for data change of specified object
  *
  * @param user - user who's ui's has to be closed
  * @param src_object - object that hosts ui that should be closed. Optional
  *
  * @return number of uis closed
  */ 
/datum/controller/subsystem/processing/vueui/proc/close_user_uis(mob/user, src_object)
    if (!LAZYLEN(user.open_vueui_uis))
        return 0

    for (var/datum/vueuiui/ui in user.open_vueui_uis)
        if (NULL_OR_EQUAL(src_object, ui.object))
            ui.close()
            .++

/**
  * Alerts of subsystem of opened ui, and starts processing it.
  *
  * @param ui - ui that got opened
  *
  * @return nothing
  */ 
/datum/controller/subsystem/processing/vueui/proc/ui_opened(datum/vueuiui/ui)
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
/datum/controller/subsystem/processing/vueui/proc/ui_closed(datum/vueuiui/ui)
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
/datum/controller/subsystem/processing/vueui/proc/user_logout(mob/user)
    return close_user_uis(user)

/**
  * Alerts of subsystem of user client transfer to other mob.
  *
  * @param oldMob - mob that had ui opened
  * @param newMob - mob to whome ui was transfered
  *
  * @return 0 if failed, 1 if success
  */ 
/datum/controller/subsystem/processing/vueui/proc/user_transferred(mob/oldMob, mob/newMob)
    if (!oldMob || !LAZYLEN(oldMob.open_vueui_uis) || !LAZYLEN(open_uis))
        return 0

    for (var/thing in oldMob.open_vueui_uis)
        var/datum/vueuiui/ui = thing
        ui.user = newMob
        LAZYADD(newMob.open_vueui_uis, ui)

    oldMob.open_vueui_uis = null

    return 1 // success

#undef NULL_OR_EQUAL