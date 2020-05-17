/client/verb/vueuiclose(var/uiref as text)
	set hidden = 1	// hide this verb from the user's panel
	set name = "vueuiclose"

	var/datum/vueui/ui = locate(uiref)

	if (istype(ui))
		ui.close()


/**
 * Alert UI host of data change made by Ui and gather initial data
 *
 * @param data - a list containing current ui data, null obtaining initial data
 * @param user - mob that has opened ui and get this data shown
 * @param ui - that is alerting of change / requesting initial data
 *
 * @return list containing changed data, null if data wasn't changed by host
 */
/datum/proc/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = null

	var/datum/vueui_var_monitor/VM = SSvueui.get_var_monitor(src)
	if (VM)
		LAZYINITLIST(data)
		. = VM.update_data(src, data.Copy(), user, ui)

/**
 * If some object wants to trasnfer it's uis to us, then we have to implemnt this proc to make transfer sucessfull
 * It is recommended to use `SSvueui.transfer_uis` to perform ui transfer
 *
 * @param srcObject - Object that wanted to give away it's uis
 *
 * @return 0 if failed, 1 if success
 */
/datum/proc/vueui_transfer(var/srcObject)
	return FALSE

/**
 * Callback to object when UI is being transfered away from it
 *
 * @param ui - that is being transfered
 */
/datum/proc/vueui_on_transfer(var/datum/vueui/ui)
	return

/**
 * Callback to object when UI is closed
 *
 * @param ui - that is being closed
 */
/datum/proc/vueui_on_close(var/datum/vueui/ui)
	return

/mob/var/list/open_vueui_uis
