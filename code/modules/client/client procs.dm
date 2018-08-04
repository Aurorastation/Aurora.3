	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	// asset_cache
	if(href_list["asset_cache_confirm_arrival"])
		//to_chat(src, "ASSET JOB [href_list["asset_cache_confirm_arrival"]] ARRIVED.")
		var/job = text2num(href_list["asset_cache_confirm_arrival"])
		//because we skip the limiter, we have to make sure this is a valid arrival and not somebody tricking us
		//	into letting append to a list without limit.
		if (job && job <= last_asset_job && !(job in completed_asset_jobs))
			completed_asset_jobs += job
			return

	if (href_list["EMERG"] && href_list["EMERG"] == "action")
		if (!info_sent)
			handle_connection_info(src, href_list["data"])
			info_sent = 1
		else
			server_greeting.close_window(src, "Your greeting window has malfunctioned and has been shut down.")

		return

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		world.log << "Attempted use of scripts within a topic call, by [src]"
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//del(usr)
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		var/datum/ticket/ticket = locate(href_list["ticket"])

		if (!isnull(ticket) && !istype(ticket))
			return

		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client

		cmd_admin_pm(C, null, ticket)
		return

	if(href_list["close_ticket"])
		var/datum/ticket/ticket = locate(href_list["close_ticket"])

		if(!istype(ticket))
			return

		ticket.close(src)

	if(href_list["discord_msg"])
		if(!holder && received_discord_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			usr << "<span class='warning'>You are no longer able to use this, it's been more then 10 minutes since an admin on Discord has responded to you</span>"
			return
		if(mute_discord)
			usr << "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on Discord</span>"
			return
		cmd_admin_discord_pm(href_list["discord_msg"])
		return

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)

	if(href_list["warnacknowledge"])
		var/queryid = text2num(href_list["warnacknowledge"])
		warnings_acknowledge(queryid)
	
	if(href_list["notifacknowledge"])
		var/queryid = text2num(href_list["notifacknowledge"])
		notifications_acknowledge(queryid)

	if(href_list["warnview"])
		warnings_check()

	if(href_list["linkingrequest"])
		if (!config.webint_url)
			return

		if (!href_list["linkingaction"])
			return

		var/request_id = text2num(href_list["linkingrequest"])

		establish_db_connection(dbcon)
		if (!dbcon.IsConnected())
			src << "<span class='warning'>Action failed! Database link could not be established!</span>"
			return


		var/DBQuery/check_query = dbcon.NewQuery("SELECT player_ckey, status FROM ss13_player_linking WHERE id = :id:")
		check_query.Execute(list("id" = request_id))

		if (!check_query.NextRow())
			src << "<span class='warning'>No request found!</span>"
			return

		if (ckey(check_query.item[1]) != ckey || check_query.item[2] != "new")
			src << "<span class='warning'>Request authentication failed!</span>"
			return

		var/query_contents = ""
		var/list/query_details = list("new_status", "id")
		var/feedback_message = ""
		switch (href_list["linkingaction"])
			if ("accept")
				query_contents = "UPDATE ss13_player_linking SET status = :new_status:, updated_at = NOW() WHERE id = :id:"
				query_details["new_status"] = "confirmed"
				query_details["id"] = request_id

				feedback_message = "<font color='green'><b>Account successfully linked!</b></font>"
			if ("deny")
				query_contents = "UPDATE ss13_player_linking SET status = :new_status:, deleted_at = NOW() WHERE id = :id:"
				query_details["new_status"] = "rejected"
				query_details["id"] = request_id

				feedback_message = "<font color='red'><b>Link request rejected!</b></font>"
			else
				src << "<span class='warning'>Invalid command sent.</span>"
				return

		var/DBQuery/update_query = dbcon.NewQuery(query_contents)
		update_query.Execute(query_details)

		if (href_list["linkingaction"] == "accept" && alert("To complete the process, you have to visit the website. Do you want to do so now?",,"Yes","No") == "Yes")
			process_webint_link("interface/user/link")

		src << feedback_message
		check_linking_requests()
		return

	if (href_list["routeWebInt"])
		process_webint_link(href_list["routeWebInt"], href_list["routeAttributes"])

		return

	// JSlink switch.
	if (href_list["JSlink"])
		switch (href_list["JSlink"])
			// Warnings panel for each user.
			if ("warnings")
				src.warnings_check()

			// Linking request handling.
			if ("linking")
				src.check_linking_requests()

			// Notification dismissal from the server greeting.
			if ("dismiss")
				if (href_list["notification"])
					var/datum/client_notification/a = locate(href_list["notification"])
					if (!QDELETED(a))
						a.dismiss()

			// Forum link from various panels.
			if ("github")
				if (!config.githuburl)
					src << "<span class='danger'>Github URL not set in the config. Unable to open the site.</span>"
				else if (alert("This will open the issue tracker in your browser. Are you sure?",, "Yes", "No") == "Yes")
					src << link(config.githuburl)

			// Forum link from various panels.
			if ("forums")
				src.forum()

			// Wiki link from various panels.
			if ("wiki")
				src.wiki()

			// Web interface href link from various panels.
			if ("webint")
				src.open_webint()

			// Forward appropriate topics to the server greeting datum.
			if ("greeting")
				if (server_greeting)
					server_greeting.handle_call(href_list, src)

			// Handle the updating of MotD and Memo tabs upon click.
			if ("updateHashes")
				var/save = 0
				if (href_list["#motd-tab"])
					src.prefs.motd_hash = href_list["#motd-tab"]
					save = 1
				if (href_list["#memo-tab"])
					src.prefs.memo_hash = href_list["#memo-tab"]
					save = 1

				if (save)
					src.prefs.save_preferences()

		return

	if (href_list["view_jobban"])
		var/reason = jobban_isbanned(ckey, href_list["view_jobban"])
		if (!reason)
			to_chat(src, span("notice", "You do not appear jobbanned from this job. If you are still stopped from entering the role however, please adminhelp."))
			return

		var/data = "<center>Jobbanned from: <b>[href_list["view_jobban"]]</b><br>"
		data += "Reason:<br>"
		data += reason
		data += "</center>"

		show_browser(src, data, "jobban_reason")
		return

	..()	//redirect to hsrc.()

/proc/client_by_ckey(ckey)
	return directory[ckey]

/client/proc/handle_spam_prevention(var/message, var/mute_type)
	if (config.automute_on && !holder && length(message))
		if (last_message_time)
			if (world.time - last_message_time < config.macro_trigger)
				spam_alert++
				if (spam_alert > 3)
					if (!(prefs.muted & mute_type))
						cmd_admin_mute(src.mob, mute_type, 1)

					src << "<span class='danger'>You have tripped the macro filter. An auto-mute was applied.</span>"
					last_message_time = world.time
					spam_alert = 4
					return 1
			else
				spam_alert = max(0, spam_alert--)

		last_message_time = world.time

		if(last_message == message)
			last_message_count++
			if(last_message_count >= SPAM_TRIGGER_AUTOMUTE)
				src << "<span class='danger'>You have exceeded the spam filter limit for identical messages. An auto-mute was applied.</span>"
				cmd_admin_mute(src.mob, mute_type, 1)
				return 1
			if(last_message_count >= SPAM_TRIGGER_WARNING)
				src << "<span class='danger'>You are nearing the spam filter limit for identical messages.</span>"
				return 0

	last_message = message
	last_message_count = 0
	return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		src << "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>"
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		src << "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>"
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null
	if(byond_version < MIN_CLIENT_VERSION)		//Out of date client.
		return null

	if(!config.guests_allowed && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		del(src)
		return

	src << "<span class='alert'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</span>"


	clients += src
	directory[ckey] = src

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	log_client_to_db()

	// New player, and we don't want any.
	if (!holder)
		if (config.access_deny_new_players && player_age == -1)
			log_access("Failed Login: [key] [computer_id] [address] - New player attempting connection during panic bunker.", ckey = ckey)
			message_admins("Failed Login: [key] [computer_id] [address] - New player attempting connection during panic bunker.")
			to_chat(src, "<span class='danger'>Apologies, but the server is currently not accepting connections from never before seen players.</span>")
			del(src)
			return 0

		// Check if the account is too young.
		if (config.access_deny_new_accounts != -1 && account_age != -1 && account_age <= config.access_deny_new_accounts)
			log_access("Failed Login: [key] [computer_id] [address] - Account too young to play. [account_age] days.", ckey = ckey)
			message_admins("Failed Login: [key] [computer_id] [address] - Account too young to play. [account_age] days.")
			to_chat(src, "<span class='danger'>Apologies, but the server is currently not accepting connections from BYOND accounts this young.</span>")
			del(src)
			return 0

	if (byond_version < config.client_error_version)
		src << "<span class='danger'><b>Your version of BYOND is too old!</b></span>"
		src << config.client_error_message
		src << "Your version: [byond_version]."
		src << "Required version: [config.client_error_version] or later."
		src << "Visit http://www.byond.com/download/ to get the latest version of BYOND."
		if (holder)
			src << "Admins get a free pass. However, <b>please</b> update your BYOND as soon as possible. Certain things may cause crashes if you play with your present version."
		else
			log_access("Failed Login: [key] [computer_id] [address] - Outdated BYOND major version: [byond_version].")
			del(src)
			return 0

#if DM_VERSION > 511
	if (LAZYLEN(config.client_blacklist_version))
		var/client_version = "[byond_version].[byond_build]"
		if (client_version in config.client_blacklist_version)
			src << "<span class='danger'><b>Your version of BYOND is explicitly blacklisted from joining this server!</b></span>"
			src << "Your current version: [client_version]."
			src << "Visit http://www.byond.com/download/ to download a different version. Try looking for a newer one, or go one lower."
			log_access("Failed Login: [key] [computer_id] [address] - Blacklisted BYOND version: [client_version].")
			del(src)
			return 0
#endif

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs

		prefs.gather_notifications(src)
	prefs.client = src					// Safety reasons here.
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls mob.Login()

	if(holder)
		add_admin_verbs()

	// Forcibly enable hardware-accelerated graphics, as we need them for the lighting overlays.
	// (but turn them off first, since sometimes BYOND doesn't turn them on properly otherwise)
	spawn(5) // And wait a half-second, since it sounds like you can do this too fast.
		if(src)
			winset(src, null, "command=\".configure graphics-hwmode off\"")
			sleep(2) // wait a bit more, possibly fixes hardware mode not re-activating right
			winset(src, null, "command=\".configure graphics-hwmode on\"")

	send_resources()

	// Server greeting shenanigans.
	if (server_greeting.find_outdated_info(src, 1))
		server_greeting.display_to_client(src)

	// Check code/modules/admin/verbs/antag-ooc.dm for definition
	add_aooc_if_necessary()

	check_ip_intel()

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	ticket_panels -= src
	if(holder)
		holder.owner = null
		admins -= src
	directory -= ckey
	clients -= src
	SSassets.handle_disconnect(src)
	return ..()


// here because it's similar to below

// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database

/proc/get_player_age(key)
	establish_db_connection(dbcon)
	if(!dbcon.IsConnected())
		return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/DBQuery/query = dbcon.NewQuery("SELECT datediff(Now(),firstseen) as age FROM ss13_player WHERE ckey = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		return text2num(query.item[1])
	else
		return -1

/client/proc/log_client_to_db()
	if (IsGuestKey(src.key))
		return

	if(!establish_db_connection(dbcon))
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT datediff(Now(),firstseen) as age, whitelist_status, account_join_date, DATEDIFF(NOW(), account_join_date) FROM ss13_player WHERE ckey = '[sql_ckey]'")

	if(!query.Execute())
		return

	var/found = 0
	player_age = 0	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.

	if (query.NextRow())
		found = 1
		player_age = text2num(query.item[1])
		whitelist_status = text2num(query.item[2])
		account_join_date = query.item[3]
		account_age = text2num(query.item[4])
		if (!account_age)
			account_join_date = sanitizeSQL(findJoinDate())
			if (!account_join_date)
				account_age = -1
			else
				var/DBQuery/query_datediff = dbcon.NewQuery("SELECT DATEDIFF(NOW(), [account_join_date])")
				if (!query_datediff.Execute())
					return
				if (query_datediff.NextRow())
					account_age = text2num(query_datediff.item[1])

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT ckey FROM ss13_player WHERE ip = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		break

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT ckey FROM ss13_player WHERE computerid = '[computer_id]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
		break

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)
	var/sql_byond_version = text2num(byond_version)
	#if DM_VERSION >= 512
	var/sql_byond_build = text2num(byond_build)
	#else
	var/sql_byond_build = 0
	#endif


	if(found)
		//Player already identified previously, we need to just update the 'lastseen', 'ip', 'computer_id', 'byond_version' and 'byond_build' variables
		var/DBQuery/query_update = dbcon.NewQuery("UPDATE ss13_player SET lastseen = Now(), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]', account_join_date = [account_join_date ? "'[account_join_date]'" : "NULL"], byond_version = [sql_byond_version], byond_build = [sql_byond_build] WHERE ckey = '[sql_ckey]'")
		query_update.Execute()
	else if (!config.access_deny_new_players)
		//New player!! Need to insert all the stuff
		var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO ss13_player (ckey, firstseen, lastseen, ip, computerid, lastadminrank, account_join_date, byond_version, byond_build) VALUES ('[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]', [account_join_date ? "'[account_join_date]'" : "NULL"], [sql_byond_version], [sql_byond_build])")
		query_insert.Execute()
	else
		// Flag as -1 to know we have to kiiick them.
		player_age = -1

	if (!account_join_date)
		account_join_date = "Error"

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `ss13_connection_log`(`id`,`datetime`,`serverip`,`ckey`,`ip`,`computerid`,`byond_version`,`byond_build`) VALUES(null,Now(),'[serverip]','[sql_ckey]','[sql_ip]','[sql_computerid]','[sql_byond_version]','[sql_byond_build]');")
	query_accesslog.Execute()


#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
	SSassets.handle_connect(src)

/mob/proc/MayRespawn()
	return 0

/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0

/client/verb/character_setup()
	set name = "Character Setup"
	set category = "Preferences"
	if(prefs)
		prefs.ShowChoices(usr)

//I honestly can't find a good place for this atm.
//If the webint interaction gets more features, I'll move it. - Skull132
/client/verb/view_linking_requests()
	set name = "View Linking Requests"
	set category = "OOC"

	check_linking_requests()

/client/proc/check_linking_requests()
	if (!config.webint_url || !config.sql_enabled)
		return

	establish_db_connection(dbcon)
	if (!dbcon.IsConnected())
		return

	var/list/requests = list()
	var/list/query_details = list("ckey" = ckey)

	var/DBQuery/select_query = dbcon.NewQuery("SELECT id, forum_id, forum_username, datediff(Now(), created_at) as request_age FROM ss13_player_linking WHERE status = 'new' AND player_ckey = :ckey: AND deleted_at IS NULL")
	select_query.Execute(query_details)

	while (select_query.NextRow())
		requests.Add(list(list("id" = text2num(select_query.item[1]), "forum_id" = text2num(select_query.item[2]), "forum_username" = select_query.item[3], "request_age" = select_query.item[4])))

	if (!requests.len)
		return

	var/dat = "<center><b>You have active requests to check!</b></center>"
	var/i = 0
	for (var/list/request in requests)
		i++

		var/linked_forum_name = null
		if (config.forumurl)
			var/route_attributes = list2params(list("mode" = "viewprofile", "u" = request["forum_id"]))
			linked_forum_name = "<a href='byond://?src=\ref[src];routeWebInt=forums/members;routeAttributes=[route_attributes]'>[request["forum_username"]]</a>"

		dat += "<hr>"
		dat += "#[i] - Request to link your current key ([key]) to a forum account with the username of: <b>[linked_forum_name ? linked_forum_name : request["forum_username"]]</b>.<br>"
		dat += "The request is [request["request_age"]] days old.<br>"
		dat += "OPTIONS: <a href='byond://?src=\ref[src];linkingrequest=[request["id"]];linkingaction=accept'>Accept Request</a> | <a href='byond://?src=\ref[src];linkingrequest=[request["id"]];linkingaction=deny'>Deny Request</a>"

	src << browse(dat, "window=LinkingRequests")
	return

/client/proc/gather_linking_requests()
	if (!config.webint_url || !config.sql_enabled)
		return

	establish_db_connection(dbcon)
	if (!dbcon.IsConnected())
		return

	var/DBQuery/select_query = dbcon.NewQuery("SELECT COUNT(*) AS request_count FROM ss13_player_linking WHERE status = 'new' AND player_ckey = :ckey: AND deleted_at IS NULL")
	select_query.Execute(list("ckey" = ckey))

	if (select_query.NextRow())
		if (text2num(select_query.item[1]) > 0)
			return "You have [select_query.item[1]] account linking requests pending review. Click <a href='?JSlink=linking;notification=:src_ref'>here</a> to see them!"

	return null

/client/proc/process_webint_link(var/route, var/attributes)
	if (!route)
		return

	var/linkURL = ""

	switch (route)
		if ("forums/members")
			if (!webint_validate_attributes(list("mode", "u"), attributes_text = attributes))
				return

			if (!config.forumurl)
				return

			linkURL = "[config.forumurl]memberlist.php?"

			linkURL += attributes

		if ("interface/user/link")
			if (!config.webint_url)
				return

			linkURL = "[config.webint_url]user/link"

		if ("interface/login/sso_server")
			//This also validates the attributes as it runs
			var/new_attributes = webint_start_singlesignon(src, attributes)
			if (!new_attributes)
				return

			if (!config.webint_url)
				return

			linkURL = "[config.webint_url]login/sso_server?"
			linkURL += new_attributes

		else
			log_debug("Unrecognized process_webint_link() call used. Route sent: '[route]'.")
			return

	src << link(linkURL)
	return

/client/verb/show_greeting()
	set name = "Open Greeting"
	set category = "OOC"

	// Update the information just in case.
	server_greeting.find_outdated_info(src, 1)

	server_greeting.display_to_client(src)

/client/proc/check_ip_intel()
	set waitfor = 0 //we sleep when getting the intel, no need to hold up the client connection while we sleep
	if (config.ipintel_email)
		var/datum/ipintel/res = get_ip_intel(address)
		if (config.ipintel_rating_kick && res.intel >= config.ipintel_rating_kick)
			message_admins("Proxy Detection: [key_name_admin(src)] IP intel rated [res.intel*100]% likely to be a proxy/VPN. They are being kicked because of this.")
			log_admin("Proxy Detection: [key_name_admin(src)] IP intel rated [res.intel*100]% likely to be a proxy/VPN. They are being kicked because of this.")
			to_chat(src, "<span class='danger'>Usage of proxies is not permitted by the rules. You are being kicked because of this.</span>")
			del(src)
		else if (res.intel >= config.ipintel_rating_bad)
			message_admins("Proxy Detection: [key_name_admin(src)] IP intel rated [res.intel*100]% likely to be a Proxy/VPN.")
		ip_intel = res.intel

/client/proc/findJoinDate()
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_debug("ACCESS CONTROL: Failed to connect to byond age check for [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			. = R.group[1]
		else
			CRASH("Age check regex failed for [src.ckey]")

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	. = ..()
	if (holder)
		sleep(1)
	else
		stoplag(5)
