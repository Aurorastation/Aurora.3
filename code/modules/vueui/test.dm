/client/var/datum/vueuiuitest/tui

/client/verb/testvueui()
    set name = "test-vueui"
    if(!tui)
        tui = new()
    tui.open_ui()

/datum/vueuiuitest

/datum/vueuiuitest/proc/open_ui()
    var/vueui/ui = SSvueui.get_open_ui(usr, src)
    if (!ui)
        ui = new(usr, src, "?<h1>{{ $root.$data.wtime }}</h1>", 400, 400, "Test ui title", null, interactive_state)
    ui.add_asset("testimg", getFlatIcon(SSmob.get_mannequin()))
    ui.open()

/datum/vueuiuitest/vueui_data_change(var/list/newdata, var/mob/user, var/vueui/ui)
    if(!newdata)
        // generate new data
        return list("c" = 0)
    if(newdata["c"] >= 10)
        return list("c" = 0)
    return


/datum/vueuiuitest/Topic(href, href_list)
    if(href_list["action"] == "test")
        world << "VueUiTest got action Test called with data [href_list["data"]]"
    return