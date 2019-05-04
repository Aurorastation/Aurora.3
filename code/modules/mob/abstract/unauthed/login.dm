/var/list/unauthed = list()

/mob/abstract/unauthed
    authed = FALSE
    var/client/my_client
    var/token = ""

/mob/abstract/unauthed/New()
    verbs -= typesof(/mob/verb)

/mob/abstract/unauthed/Login()
    update_Login_details()
    to_chat(src, "<span class='danger'><b>You need to authenticate before you can continue.</b></span>")
    token = md5("[client.ckey][client.computer_id][world.time]")
    unauthed[token] = src
    my_client = client
    client.verbs -= typesof(/client/verb)
    var/uihtml = "<html><head><style>body * {display: block;text-align:center;margin: 14px 0;font-size:24px;text-decoration:none;font-family:Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;}</style></head><body><p>Please select:</p>"
    var/authmethods = 0
    if(config.guests_allowed)
        uihtml += "<a href='?src=\ref[src];authaction=guest'>Login as guest</a>"
        authmethods += 1
    if(config.webint_url)
        uihtml += "<a href='?src=\ref[src];authaction=forums'>Login over forums</a>"
        authmethods += 1
    if(authmethods == 0)
        src.Del()
    if(authmethods == 1)
        if(config.guests_allowed)
            src.ClientLogin(null)
        if(config.webint_url)
            src.OpenForumAuthWindow()
    src << browse(uihtml, "window=auth;size=300x300;border=0;can_close=0;can_resize=0;can_minimize=0;titlebar=1")

/mob/abstract/unauthed/proc/ClientLogin(var/newkey)
    src << browse(null, "window=auth;")
    my_client.verbs += typesof(/client/verb) // Let's return regular client verbs
    my_client.authed = TRUE // We declare client as authed now
    if(newkey != null)
        my_client.ckey = newkey // Try seeting ckey
    // If mob exists for that ckey, then BYOND will transfer client to it.
    if(istype(my_client.mob, /mob/abstract/unauthed))
        my_client.mob = new /mob/abstract/new_player() // Else we just treat them as new player
    my_client.InitClient() // And now we shal continue client initilization (permissions and stuff)
    unauthed -= token

/mob/abstract/unauthed/Topic(href, href_list)
    switch(href_list["authaction"])
        if("guest")
            src.ClientLogin(null)
        if("forums")
            src.OpenForumAuthWindow()

/mob/abstract/unauthed/proc/OpenForumAuthWindow()
    src << link("[config.webint_url]server/auth?token=[token]")

