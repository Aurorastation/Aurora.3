/client/var/datum/byvueuitest/tui

/client/verb/testbyvue()
    set name = "test-byvue"
    if(!tui)
        tui = new()
    tui.open_ui()

/datum/byvueuitest

/datum/byvueuitest/proc/open_ui()
    var/datum/byvueui/ui = SSbyvue.get_open_ui(usr, src)
    if (!ui)
        ui = new(usr, src, "test", 200, 200)
    ui.open()

/datum/byvueuitest/byvue_state_change(var/list/newstate, var/mob/user, var/datum/byvueui/ui)
    if(!newstate)
        // generate new state
        return list("c" = 0)
    world << newstate
    return


/datum/byvueuitest/Topic(href, href_list)
    return