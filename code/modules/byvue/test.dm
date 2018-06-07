/client/var/datum/byvueuitest/tui

/client/verb/testbyvue()
    set name = "test-byvue"
    if(!tui)
        tui = new()
    tui.open_ui()

/datum/byvueuitest

/datum/byvueuitest/proc/open_ui()
    var/datum/byvueui/ui = SSvueui.get_open_ui(usr, src)
    if (!ui)
        ui = new(usr, src, "test", 300, 300)
    ui.open()

/datum/byvueuitest/byvue_state_change(var/list/newstate, var/mob/user, var/datum/byvueui/ui)
    if(!newstate)
        // generate new state
        return list("c" = 0)
    if(newstate["c"] >= 10)
        return list("c" = 0)
    return


/datum/byvueuitest/Topic(href, href_list)
    if(href_list["action"] == "test")
        world << "ByVueUi got action Test called with data [href_list["data"]]"
    return