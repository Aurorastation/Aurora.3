/*
Byond Vue UI framework
main ui datum.
*/
/datum/byvueui
    // title of ui window
    var/title = "HTML5 UI"
    // user that opened this ui
    var/mob/user
    // object that contains this ui
    var/datum/object
    // apperant object that contains ui, used for checks
    var/atom/wobject = null
    // browser window width
    var/width = 100
    // browser window height
    var/height = 100
    // current state of ui
    var/list/state
    // currently used server generated assets
    var/list/assets
    // current status of ui
    var/status = STATUS_INTERACTIVE
    // currently active ui component
    var/activeui = "test"
    // window id
    var/windowid

/datum/byvueui/New(var/nuser, var/nobject, var/nactiveui = 0, var/nwidth = 0, var/nheight = 0, var/atom/nwobject = null)
    user = nuser
    object = nobject

    if (nactiveui)
        activeui = sanitize(nactiveui)
    if (nwidth)
        width = nwidth
    if (nheight)
        height = nheight
    if (nwobject)
        wobject = nwobject

    SSvueui.ui_opened(src)
    windowid = "byvue\ref[src]"

/datum/byvueui/proc/open()
    if(!object)
        return
    if(!user.client)
        return
    
    if(!state)
        state = object.byvue_state_change(null, user, src)

    var/params = "window=[windowid];"
    if(width && height)
        params += "size=[width]x[height];"
    send_resources_and_assets(user.client)
    user << browse(generate_html(), params)
    winset(user, "mapwindow.map", "focus=true")
    spawn(1)
        winset(user, windowid, "on-close=\"byvueclose \ref[src]\"")

/datum/byvueui/proc/close()
    SSvueui.ui_closed(src)
    user << browse(null, "window=[windowid]")
    status = null
    
/datum/byvueui/proc/generate_html()
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
    <script type="text/javascript" src="byvue.js"></script>
</html>
    "}

/datum/byvueui/proc/generate_data_json()
    var/list/data = list()
    data["state"] = state    
    data["assets"] = list()
    data["active"] = activeui
    data["uiref"] = "\ref[src]"
    for(var/ass in assets)
        data["assets"].add(sanitize("\ref[ass]" + ".png"))
    return json_encode(data)
     
/datum/byvueui/proc/send_resources_and_assets(var/client/cl)
    cl << browse_rsc(file("byvue/dist/main.js"), "byvue.js")
    for(var/ass in assets)
        cl << browse_rsc(ass, sanitize("\ref[ass]") + ".png")

/datum/byvueui/Topic(href, href_list)
    if(href_list["byvuestateupdate"])
        var/data = json_decode(href_list["byvuestateupdate"])
        var/nstate = data["state"]
        var/ret = object.byvue_state_change(nstate, user, src)
        if(ret)
            nstate = ret
            push_change(ret)
        state = nstate
    object.Topic(href, href_list)

/datum/byvueui/proc/push_change(var/list/nstate)
    state = nstate
    user << output(list2params(list(generate_data_json())),"[windowid].browser:receveUIState")

/datum/byvueui/proc/check_for_change()
    var/ret = object.byvue_state_change(state, user, src)
    if(ret)
        push_change(ret)