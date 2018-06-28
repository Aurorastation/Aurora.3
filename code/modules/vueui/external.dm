/client/verb/vueuiclose(var/uiref as text)
    set hidden = 1	// hide this verb from the user's panel
    set name = "vueuiclose"

    var/vueui/ui = locate(uiref)

    if (istype(ui))
        ui.close()


 /**
  * Alert UI host of data change made by Ui and gather initial data
  *
  * @param newdata - a list containing current ui data, null obtaining initial data
  * @param user - mob that has opened ui and get this data shown
  * @param ui - that is alerting of change / requesting initial data
  *
  * @return list containing changed data, null if data wasn't changed by host
  */
/datum/proc/vueui_data_change(var/list/newdata, var/mob/user, var/vueui/ui)
    return

/mob/var/list/open_vueui_uis