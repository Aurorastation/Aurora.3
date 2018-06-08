var/datum/controller/subsystem/processing/vueui/SSvueui

#define NULL_OR_EQUAL(self,other) (!(self) || (self) == (other))

/datum/controller/subsystem/processing/vueui
    name = "VueUI"
    flags = SS_NO_INIT
    priority = SS_PRIORITY_NANOUI
    stat_tag = "O"

    var/list/open_uis

/datum/controller/subsystem/processing/vueui/New()
    LAZYINITLIST(open_uis)
    NEW_SS_GLOBAL(SSvueui)

/datum/controller/subsystem/processing/vueui/proc/get_open_ui(mob/user, src_object)
    var/src_object_key = SOFTREF(src_object)
    if (!LAZYLEN(open_uis[src_object_key]))
        return null

    for (var/datum/vueuiui/ui in open_uis[src_object_key])
        if (ui.user == user)
            return ui

    return null

/datum/controller/subsystem/processing/vueui/proc/check_uis_for_change(src_object)
    var/src_object_key = SOFTREF(src_object)
    if (!LAZYLEN(open_uis[src_object_key]))
        return

    var/ret = list()
    for (var/datum/vueuiui/ui in open_uis[src_object_key])
        ui.check_for_change()

/datum/controller/subsystem/processing/vueui/proc/close_user_uis(mob/user, src_object)
    if (!LAZYLEN(user.open_vueui_uis))
        return 0

    for (var/datum/vueuiui/ui in user.open_vueui_uis)
        if (NULL_OR_EQUAL(src_object, ui.object))
            ui.close()
            .++

/datum/controller/subsystem/processing/vueui/proc/ui_opened(datum/vueuiui/ui)
    var/src_object_key = SOFTREF(ui.object)
    LAZYINITLIST(open_uis[src_object_key])
    if(!ui.user.open_vueui_uis)
        LAZYINITLIST(ui.user.open_vueui_uis)
    LAZYADD(ui.user.open_vueui_uis, ui)
    LAZYADD(open_uis[src_object_key], ui)
    START_PROCESSING(SSvueui, ui)

/datum/controller/subsystem/processing/vueui/proc/ui_closed(datum/vueuiui/ui)
    var/src_object_key = SOFTREF(ui.object)

    if (!LAZYLEN(open_uis[src_object_key]))
        return 0	// Wasn't open.

    STOP_PROCESSING(SSvueui, ui)
    if(ui.user)	// Sanity check in case a user has been deleted (say a blown up borg watching the alarm interface)
        LAZYREMOVE(ui.user.open_vueui_uis, ui)

    open_uis[src_object_key] -= ui

    if (!LAZYLEN(open_uis[src_object_key]))
        open_uis -= src_object_key
    return 1

/datum/controller/subsystem/processing/vueui/proc/user_logout(mob/user)
    return close_user_uis(user)

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