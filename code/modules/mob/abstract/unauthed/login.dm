/var/list/unauthed = list()

/mob/abstract/unauthed
	authed = FALSE
	var/token = ""
	var/timeout_timer

/mob/abstract/unauthed/New()
	verbs -= typesof(/mob/verb)

/mob/abstract/unauthed/Login()
	update_Login_details()
	to_chat(src, "<span class='danger'><b>You need to authenticate before you can continue.</b></span>")
	token = md5("[client.ckey][client.computer_id][world.time][rand()]")
	unauthed[token] = src
	client.verbs -= typesof(/client/verb)
	var/uihtml = "<html><head><style>body * {display: block;text-align:center;margin: 14px 0;font-size:24px;text-decoration:none;font-family:Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;}</style></head><body><p>Please select:</p>"
	if(config.guests_allowed)
		uihtml += "<a href='?src=\ref[src];authaction=guest'>Login as guest</a>"
	if(config.webint_url && config.external_auth)
		uihtml += "<a href='?src=\ref[src];authaction=forums'>Login via forums</a>"
	if(!config.guests_allowed && config.webint_url && config.external_auth)
		src.OpenForumAuthWindow()
	show_browser(src, uihtml, "window=auth;size=300x300;border=0;can_close=0;can_resize=0;can_minimize=0;titlebar=1")
	timeout_timer = addtimer(CALLBACK(src, .proc/timeout), 900, TIMER_STOPPABLE)

/mob/abstract/unauthed/proc/timeout()
	if (client)
		to_chat(client, "Your login time has expired. Please relog and try again.")
	qdel(client)
	qdel(src)

/mob/abstract/unauthed/proc/ClientLogin(var/newkey)
	if(!client)
		qdel(src)
	deltimer(timeout_timer)
	var/client/c = client
	show_browser(src, null, "window=auth;")
	client.verbs += typesof(/client/verb) // Let's return regular client verbs
	client.authed = TRUE // We declare client as authed now
	client.prefs = null //Null them so we can load them from the db again for the correct ckey
	// Check for bans
	var/list/ban_data = world.IsBanned(ckey(newkey), c.address, c.computer_id, 1, TRUE)
	if(ban_data)
		to_chat(c, "You are banned for this server.")
		to_chat(c, "Reason: [ban_data["reason"]]")
		to_chat(c, "Description: [ban_data["desc"]]")
		del(c)
		return
	directory -= client.ckey
	if(newkey)
		client.key = newkey // Try seeting ckey
	directory[c.ckey] = c
	// If mob exists for that ckey, then BYOND will transfer client to it.
	if(istype(c.mob, /mob/abstract/unauthed))
		c.mob = new /mob/abstract/new_player() // Else we just treat them as new player
	c.InitClient() // And now we shall continue client initilization (permissions and stuff)
	c.InitPrefs() // We init prefs just in case mob transfer didn't
	unauthed -= token

/mob/abstract/unauthed/Topic(href, href_list)
	if(!src.client)
		qdel(src)
		return
	switch(href_list["authaction"])
		if("guest")
			if(config.guests_allowed)
				src.ClientLogin(null)
			else
				qdel(src)
		if("forums")
			if(config.external_auth)
				src.OpenForumAuthWindow()
			else
				qdel(src)

/mob/abstract/unauthed/proc/OpenForumAuthWindow()
	src << link("[config.webint_url]server/auth?token=[token]")

