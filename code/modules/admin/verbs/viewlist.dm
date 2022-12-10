/client/proc/view_extended_list(var/list/L)
    if(!check_rights(R_VAREDIT|R_DEV))	return

    if(istype(L))
        new /datum/vueui_module/list_viewer(L, usr)

/datum/vueui_module/list_viewer
    var/list/viewed_list

/datum/vueui_module/list_viewer/New(var/list/L, mob/user)
    if(istype(L))
        viewed_list = L
    ui_interact(user)

/datum/vueui_module/list_viewer/ui_interact(mob/user)
    if(!check_rights(R_VAREDIT|R_DEV|R_MOD)) return

    var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
    if(!ui)
        ui = new(user, src, "admin-extended-list", 800, 600, "Extended List Viewer", state = interactive_state)
        ui.header = "minimal"

    ui.open()

/datum/vueui_module/list_viewer/vueui_data_change(list/data, mob/user, datum/vueui/ui)
    if (!data)
        . = data = list()

    if(!user.client.holder)
        return

    if(!check_rights(R_VAREDIT|R_DEV, FALSE, user)) return

    data["listvar"] = viewed_list

    return data
