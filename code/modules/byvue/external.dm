/client/verb/byvueclose(var/uiref as text)
    set hidden = 1	// hide this verb from the user's panel
    set name = "byvueclose"

    var/datum/byvueui/ui = locate(uiref)

    if (istype(ui))
        ui.close()

/mob/var/list/open_byvue_uis = list()