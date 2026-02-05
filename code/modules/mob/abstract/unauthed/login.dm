GLOBAL_LIST_EMPTY(unauthed)

/mob/abstract/unauthed
	authed = FALSE
	var/token = ""
	var/timeout_timer

/mob/abstract/unauthed/New()
	remove_verb(src, typesof(/mob/verb))

/mob/abstract/unauthed/LateLogin()
	SHOULD_CALL_PARENT(FALSE)

	//Don't redo this if they have already been authenticated
	if(client?.authed)
		return

	update_Login_details()
	token = md5("[client.ckey][client.computer_id][world.time][rand()]")
	GLOB.unauthed[token] = src
	remove_verb(client, typesof(/client/verb))
	var/uihtml = "<html><head><style>body * {display: block;text-align:center;margin: 14px 0;font-size:24px;text-decoration:none;font-family:Segoe UI Variable,Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;}h1{color: #ff0000;font-family:Segoe UI Variable,Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;}</style></head>"
	uihtml += "<body><h1>You need to authenticate before you can continue.</h1><br/><p>Please select:</p>"
	if(GLOB.config.guests_allowed)
		uihtml += "<a href='byond://?src=[REF(src)];authaction=guest'>Login as guest</a>"
	if(GLOB.config.webint_url && GLOB.config.external_auth)
		uihtml += "<a href='byond://?src=[REF(src)];authaction=forums'>Login via forums</a>"
	if(!GLOB.config.guests_allowed && GLOB.config.webint_url && GLOB.config.external_auth)
		src.OpenForumAuthWindow()
	uihtml += "</body>"
	show_browser(src, uihtml, "window=mainwindow.guestbrowser")
	winset(src, "mainwindow.guestbrowser", "is-visible=true")
	winset(src, "mainwindow.guestbrowser", "is-disabled=false")
	timeout_timer = addtimer(CALLBACK(src, PROC_REF(timeout)), 90 SECONDS, TIMER_STOPPABLE)

/mob/abstract/unauthed/proc/timeout()
	if (client)
		var/alert = "<html><head><title>Login Timeout</title><style>body * {display: block;text-align:center;margin: 14px 0;font-size:24px;text-decoration:none;font-family:Segoe UI Variable,Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;}h1{color: #ff0000;font-family:Segoe UI Variable,Segoe UI,Frutiger,Frutiger Linotype,Dejavu Sans,Helvetica Neue,Arial,sans-serif;}</style></head>"
		alert += "<body><h1>Your login time has expired. Please relog and try again.</h1></body>"
		show_browser(src, alert, "window=mainwindow.guestbrowser;")
	qdel(client)
	qdel(src)

/mob/abstract/unauthed/proc/ClientLogin(var/newkey, var/ckey_is_external)
	if(!client)
		qdel(src)
	deltimer(timeout_timer)
	winset(src, "mainwindow.guestbrowser", "is-visible=false")
	winset(src, "mainwindow.guestbrowser", "is-disabled=true")
	var/client/c = client // so we don't lose the client in the current mob.

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
		c.ckey_is_external = ckey_is_external
		c.key = newkey // Try setting ckey
		// ^^^^ THIS INVOKES mob/Login()!
		// and also modifies the c.mob to the actual mob they disconnected out of.

	GLOB.directory[c.ckey] = c
	// Init the client and give it a new_player mob.
	// Note that modifying the key variable does not invoke client/New() or client/Login() again.
	c.InitClient()
	c.InitPrefs()
	c.InitUI()
	c.mob.LateLogin()

	if(istype(c.mob, /mob/abstract/unauthed))
		c.mob = new /mob/abstract/new_player()

	GLOB.unauthed -= token

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

