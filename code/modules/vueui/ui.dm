/*
Byond Vue UI framework
main ui datum.
*/
/datum/vueuiui
    // title of ui window
    var/title = "HTML5 UI"
    // user that opened this ui
    var/mob/user
    // object that contains this ui
    var/datum/object
    // browser window width
    var/width = 100
    // browser window height
    var/height = 100
    // current state of ui data
    var/list/data
    // currently used server generated assets
    var/list/assets
    // current status of ui
    var/status = STATUS_INTERACTIVE
    var/datum/topic_state/state = null
    // currently active ui component
    var/activeui = "test"
    // window id
    var/windowid

/datum/vueuiui/New(var/nuser, var/nobject, var/nactiveui = 0, var/nwidth = 0, var/nheight = 0, var/list/ndata, var/datum/topic_state/nstate = default_state)
    user = nuser
    object = nobject
    data = ndata
    state = nstate

    if (nactiveui)
        activeui = sanitize(nactiveui)
    if (nwidth)
        width = nwidth
    if (nheight)
        height = nheight

    SSvueui.ui_opened(src)
    windowid = "vueui\ref[src]"

/datum/vueuiui/proc/open()
    if(!object)
        return
    if(!user.client)
        return
    
    if(!data)
        data = object.vueui_data_change(null, user, src)
    update_status()
    if(status == STATUS_CLOSE)
		return

    var/params = "window=[windowid];"
    if(width && height)
        params += "size=[width]x[height];"
    send_resources_and_assets(user.client)
    user << browse(generate_html(), params)
    winset(user, "mapwindow.map", "focus=true")
    spawn(1)
        winset(user, windowid, "on-close=\"vueuiclose \ref[src]\"")

/datum/vueuiui/proc/close()
    SSvueui.ui_closed(src)
    user << browse(null, "window=[windowid]")
    status = null
    
/datum/vueuiui/proc/generate_html()
    return {"
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=11">
        <meta charset="UTF-8">
    </head>
    <body class="theme-nanoui">
        <div id="app">

        </div>
        <div id="dapp"></div>
        <noscript>
            <div id='uiNoScript'>
                <h2>JAVASCRIPT REQUIRED</h2>
                <p>Your Internet Explorer's Javascript is disabled (or broken).<br/>
                Enable Javascript and then open this UI again.</p>
            </div>
        </noscript>
    </body>
    <script type="application/json" id="initialstate">
        [generate_data_json()]
    </script>
    <script type="text/javascript" src="vueui.js"></script>
</html>
    "}

/datum/vueuiui/proc/generate_data_json()
    var/list/data = list()
    data["state"] = data    
    data["assets"] = list()
    data["active"] = activeui
    data["uiref"] = "\ref[src]"
    for(var/ass in assets)
        data["assets"].add(sanitize("\ref[ass]" + ".png"))
    return json_encode(data)
     
/datum/vueuiui/proc/send_resources_and_assets(var/client/cl)
    cl << browse_rsc(file("vueui/dist/main.js"), "vueui.js")
    for(var/ass in assets)
        cl << browse_rsc(ass, sanitize("\ref[ass]") + ".png")

/datum/vueuiui/Topic(href, href_list)
    update_status()
    if(status < STATUS_INTERACTIVE || user != usr)
        return
    if(href_list["vueuistateupdate"])
        var/data = json_decode(href_list["vueuistateupdate"])
        var/ndata = data["state"]
        var/ret = object.vueui_data_change(ndata, user, src)
        if(ret)
            ndata = ret
            push_change(ret)
        data = ndata
    object.Topic(href, href_list)

/datum/vueuiui/proc/push_change(var/list/ndata)
    if(ndata && status > STATUS_DISABLED)
        data = ndata
    user << output(list2params(list(generate_data_json())),"[windowid].browser:receveUIState")

/datum/vueuiui/proc/check_for_change(var/force = 0)
    var/ret = object.vueui_data_change(data, user, src)
    if(ret)
        push_change(ret)
    else if(force)
        push_change(null)

/**
  * Set the current status (also known as visibility) of this ui.
  *
  * @param state int The status to set, see the defines at the top of this file
  *
  * @return nothing
  */
/datum/vueuiui/proc/set_status(nstatus)
        if (nstatus != status) // Only update if it is different
        status = nstatus
        if(nstatus > STATUS_DISABLED)
            check_for_change(1) // Gather data and update it
        else if (nstatus == STATUS_DISABLED)
            push_change(null) // Only update ui data
        else
            close()

/**
  * Update the status (visibility) of this ui based on the user's status
  *
  * @return nothing
  */
/datum/vueuiui/proc/update_status()
    set_status(object.CanUseTopic(user, state))

/**
  * Preocess this ui
  *
  * @return nothing
  */
/datum/vueuiui/process()
    if (!object || !user || status < 0)
        close()
        return
    update_status()
