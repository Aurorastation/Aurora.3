/client/verb/byvueclose(var/uiref as text)
    set hidden = 1	// hide this verb from the user's panel
    set name = "byvueclose"

    var/datum/byvueui/ui = locate(uiref)

    if (istype(ui))
        ui.close()


 /**
  * Alert UI host of state change made by Ui and gather initial state
  *
  * @param newstate - a list containing current ui state, null obtaining initial state
  * @param user - mob that has opened ui and get this data shown
  * @param ui - that is alerting of change / requesting initial data
  *
  * @return list containing changed state, null if state wasn't changed by host
  */
/datum/proc/byvue_state_change(var/list/newstate, var/mob/user, var/datum/byvueui/ui)
    return

/mob/var/list/open_byvue_uis = list()