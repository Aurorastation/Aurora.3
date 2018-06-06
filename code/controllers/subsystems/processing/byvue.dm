var/datum/controller/subsystem/processing/byvue/SSbyvue

#define NULL_OR_EQUAL(self,other) (!(self) || (self) == (other))

/datum/controller/subsystem/processing/byvue
    name = "ByVue"
    flags = SS_NO_INIT
    priority = SS_PRIORITY_NANOUI
    stat_tag = "A"

    var/list/open_uis

/datum/controller/subsystem/processing/byvue/New()
    LAZYINITLIST(open_uis)
    NEW_SS_GLOBAL(SSbyvue)

/datum/controller/subsystem/processing/byvue/proc/get_open_ui(mob/user, src_object)
    var/src_object_key = SOFTREF(src_object)
    if (!LAZYLEN(open_uis[src_object_key]))
        return null

    for (var/datum/byvueui/ui in open_uis[src_object_key])
        if (ui.user == user)
            return ui

    return null

/datum/controller/subsystem/processing/byvue/proc/close_user_uis(mob/user, src_object)
    if (!LAZYLEN(user.open_byvue_uis))
        return 0

    for (var/datum/byvueui/ui in user.open_byvue_uis)
        if (NULL_OR_EQUAL(src_object, ui.object))
            ui.close()
            .++

/datum/controller/subsystem/processing/byvue/proc/ui_opened(datum/byvueui/ui)
    var/src_object_key = SOFTREF(ui.object)
    LAZYINITLIST(open_uis[src_object_key])

    LAZYADD(ui.user.open_byvue_uis, ui)
    LAZYADD(open_uis[src_object_key], ui)
    START_PROCESSING(SSbyvue, ui)

/datum/controller/subsystem/processing/byvue/proc/ui_closed(datum/byvueui/ui)
    var/src_object_key = SOFTREF(ui.object)
    var/list/obj_uis = open_uis[src_object_key]

    if (!LAZYLEN(obj_uis))
        return 0	// Wasn't open.

    STOP_PROCESSING(SSbyvue, ui)
    if(ui.user)	// Sanity check in case a user has been deleted (say a blown up borg watching the alarm interface)
        LAZYREMOVE(ui.user.open_byvue_uis, ui)

    obj_uis -= ui

    if (!LAZYLEN(obj_uis))
        open_uis -= src_object_key
    world << "Closed ui \ref[ui]"
    return 1

/datum/controller/subsystem/processing/byvue/proc/user_logout(mob/user)
    return close_user_uis(user)

/datum/controller/subsystem/processing/byvue/proc/user_transferred(mob/oldMob, mob/newMob)
    if (!oldMob || !LAZYLEN(oldMob.open_byvue_uis) || !LAZYLEN(open_uis))
        return 0

    for (var/thing in oldMob.open_byvue_uis)
        var/datum/byvueui/ui = thing
        ui.user = newMob
        LAZYADD(newMob.open_byvue_uis, ui)

    oldMob.open_byvue_uis = null

    return 1 // success

#undef NULL_OR_EQUAL