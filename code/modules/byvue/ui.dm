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

/datum/byvueui/New(var/nuser, var/nobject, var/ntitle = 0, var/nwidth = 0, var/nheight = 0, var/atom/nwobject = null)
    user = nuser
    object = nobject

    if (ntitle)
        title = sanitize(ntitle)
    if (nwidth)
        width = nwidth
    if (nheight)
        height = nheight
    if (nwobject)
        wobject = nwobject

/datum/byvueui/proc/open()
    if(!object)
        return
    if(!user.client)
        return

    var/params = "window=byvue_\ref[src]"
    if(width && height)
        params += "size=[width]x[height];"
    sendResourcesAndAssets(user.client)
    user << browse(generate_html(), params)
    winset(user, "mapwindow.map", "focus=true")
    winset(user, "byvue_\ref[src]", "on-close=\"byvueclose [params]\"")
    SSbyvue.ui_opened(src)

/datum/byvueui/proc/close()
    SSbyvue.ui_closed(src)
    user << browse(null, "window=byvue_\ref[src]")
    status = null
    
/datum/byvueui/proc/generate_html()
    return {"
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
    </head>
    <body>
        <div id="app">

        </div>
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
    for(var/ass in assets)
        data["assets"].add(sanitize("\ref[ass]" + ".png"))
    return json_encode(data)
     
/datum/byvueui/proc/sendResourcesAndAssets(var/client/cl)
    cl << browse_rsc(file("byvue/dist/main.js"), "byvue.js")
    for(var/ass in assets)
        cl << browse_rsc(ass, sanitize("\ref[ass]") + ".png")