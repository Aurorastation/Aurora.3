/var/list/unauthed = list()

/mob/abstract/unauthed
	authed = FALSE
	var/token = ""
	var/timeout_timer

/mob/abstract/unauthed/New()
	remove_verb(src, typesof(/mob/verb))

/mob/abstract/unauthed/LateLogin()
	SHOULD_CALL_PARENT(FALSE)

	update_Login_details()
	to_chat(src, "<span class='danger'><b>You need to authenticate before you can continue.</b></span>")
	token = md5("[client.ckey][client.computer_id][world.time][rand()]")
	unauthed[token] = src
	remove_verb(client, typesof(/client/verb))
	var/uihtml = "<html><head><style>body * {display: block;text-align:center;margin: 14px 0;font-size:24px;text-decoration:none;font-family:Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;}</style></head><body><p>Please select:</p>"
	if(GLOB.config.guests_allowed)
		uihtml += "<a href='?src=\ref[src];authaction=guest'>Login as guest</a>"
	if(GLOB.config.webint_url && GLOB.config.external_auth)
		uihtml += "<a href='?src=\ref[src];authaction=forums'>Login via forums</a>"
	if(!GLOB.config.guests_allowed && GLOB.config.webint_url && GLOB.config.external_auth)
		src.OpenForumAuthWindow()
	show_browser(src, uihtml, "window=externalauth;size=300x300;border=0;can_close=1;can_resize=0;can_minimize=0;titlebar=1")
	timeout_timer = addtimer(CALLBACK(src, PROC_REF(timeout)), 900, TIMER_STOPPABLE)

/mob/abstract/unauthed/proc/timeout()
	if (client)
		to_chat_immediate(client, "Your login time has expired. Please relog and try again.")
	qdel(client)
	qdel(src)

/mob/abstract/unauthed/proc/ClientLogin(var/newkey)
	if(!client)
		qdel(src)
	deltimer(timeout_timer)
	var/client/c = client // so we don't lose the client in the current mob.

	show_browser(src, null, "window=externalauth")
	add_verb(c,  typesof(/client/verb)) // Let's return regular client verbs
	c.authed = TRUE // We declare client as authed now
	c.prefs = null //Null them so we can load them from the db again for the correct ckey
	// Check for bans
	var/list/ban_data = world.IsBanned(ckey(newkey), c.address, c.computer_id, 1, real_bans_only = TRUE, log_connection = TRUE)
	if(ban_data)
		to_chat_immediate(c, "You are banned for this server.")
		to_chat_immediate(c, "Reason: [ban_data["reason"]]")
		to_chat_immediate(c, "Description: [ban_data["desc"]]")
		del(c)
		return

	GLOB.directory -= c.ckey
	if(newkey)
		c.key = newkey // Try seeting ckey
		// ^^^^ THIS INVOKES mob/Login()!
		// and also modifies the c.mob to the actual mob they disconnected out of.

	GLOB.directory[c.ckey] = c
	// Init the client and give it a new_player mob.
	// Note that modifying the key variable does not invoke client/New() or client/Login() again.
	c.InitClient()
	c.InitPrefs()
	c.mob.LateLogin()

	if(istype(c.mob, /mob/abstract/unauthed))
		c.mob = new /mob/abstract/new_player()

	unauthed -= token

/mob/abstract/unauthed/Topic(href, href_list)
	if(!src.client)
		qdel(src)
		return
	switch(href_list["authaction"])
		if("guest")
			if(GLOB.config.guests_allowed)
				src.ClientLogin(null)
			else
				qdel(src)
		if("forums")
			if(GLOB.config.external_auth)
				src.OpenForumAuthWindow()
			else
				qdel(src)

/mob/abstract/unauthed/proc/OpenForumAuthWindow()
	src << link("[GLOB.config.webint_url]server/auth?token=[token]")

