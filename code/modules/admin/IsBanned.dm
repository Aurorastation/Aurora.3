#define STICKYBAN_MAX_MATCHES 15
#define STICKYBAN_MAX_EXISTING_USER_MATCHES 3 //ie, users who were connected before the ban triggered
#define STICKYBAN_MAX_ADMIN_MATCHES 1

#define ACCESS_STATUS_PERMITTED "permitted"
#define ACCESS_STATUS_ADMINPERMITTED "admin permitted"
#define ACCESS_STATUS_GUESTDENIED "guests denied"
#define ACCESS_STATUS_NOIP "no ip"
#define ACCESS_STATUS_NOCID "no cid"
#define ACCESS_STATUS_BANNED "banned"
#define ACCESS_STATUS_STICKYBANNED "sticky banned"


#define LOG_CLIENT_CONNECTION(STATUS)  if (log_connection) {log_connection(ckey(key), address, computer_id, byond_version, byond_build, game_id, STATUS)}

/world/proc/log_connection(ckey, ip, computerid, byond_version, byond_build, game_id, access_status)
	if(!establish_db_connection(GLOB.dbcon))
		log_access("Unable to Establish DB Connection for connection logging")
		return

	//Logging player access
	var/DBQuery/query_accesslog = GLOB.dbcon.NewQuery("INSERT INTO `ss13_connection_log`(`datetime`,`serverip`,`ckey`,`ip`,`computerid`,`byond_version`,`byond_build`,`game_id`, `status`) VALUES(Now(), :serverip:, :ckey:, :ip:, :computerid:, :byond_version:, :byond_build:, :game_id:, :status:);")
	query_accesslog.Execute(list(
		"serverip"="[world.internet_address]:[world.port]",
		"ckey"=ckey,
		"ip"=ip,
		"computerid"=computerid,
		"byond_version"=byond_version,
		"byond_build"=byond_build,
		"game_id"=game_id,
		"status"=access_status))


//Blocks an attempt to connect before even creating our client datum thing.
/world/IsBanned(key, address, computer_id, type, real_bans_only = FALSE, log_connection = TRUE)
	if (type == "world")
		return ..()

	if(ckey(key) in admin_datums)
		LOG_CLIENT_CONNECTION(ACCESS_STATUS_ADMINPERMITTED)
		return ..()

	var/ckey = ckey(key)
	var/admin = (ckey in admin_datums)
	var/client/C = GLOB.directory[ckey]

	if (C && ckey == C.ckey && computer_id == C.computer_id && address == C.address)
		return // Player is already connected, do not recheck.

	//IsBanned can get re-called on a user in certain situations, this prevents that leading to repeated messages to admins.
	var/static/list/checkedckeys = list()
	//magic voodo to check for a key in a list while also adding that key to the list without having to do two associated lookups
	var/message = !checkedckeys[ckey]++

	//Guest Checking
	if(!(GLOB.config.guests_allowed || GLOB.config.external_auth) && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed",ckey=key_name(key))
		message_admins("<span class='notice'>Failed Login: [key] - Guests not allowed</span>")
		LOG_CLIENT_CONNECTION(ACCESS_STATUS_GUESTDENIED)
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")
	if(GLOB.config.ban_legacy_system)
		//Ban Checking
		. = CheckBan(ckey, computer_id, address)
		if(.)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]",ckey=key_name(key))
			message_admins("<span class='notice'>Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]</span>")
			return .

		return ..()	//default pager ban stuff

	else
		if (!address)
			log_access("Failed Login: [key] null-[computer_id] - Denied access: No IP address broadcast.",ckey=key_name(key))
			message_admins("[key] tried to connect without an IP address.")
			LOG_CLIENT_CONNECTION(ACCESS_STATUS_NOIP)
			return list("reason" = "Temporary ban", "desc" = "Your connection did not broadcast an IP address to check.")

		if (!computer_id)
			log_access("Failed Login: [key] [address]-null - Denied access: No computer ID broadcast.",ckey=key_name(key))
			message_admins("[key] tried to connect without a computer ID.")
			LOG_CLIENT_CONNECTION(ACCESS_STATUS_NOCID)
			return list("reason" = "Temporary ban", "desc" = "Your connection did not broadcast an computer ID to check.")


		if(!establish_db_connection(GLOB.dbcon))
			log_world("ERROR: Ban database connection failure. Key [ckey] not checked")
			log_misc("Ban database connection failure. Key [ckey] not checked")
			return ..()

		var/pulled_ban_id = get_active_mirror(ckey, address, computer_id)

		var/params[] = list()
		var/query_content = ""
		if (pulled_ban_id)
			query_content = "SELECT id, ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM ss13_ban WHERE id = :ban_id: AND isnull(unbanned) AND (bantype = 'PERMABAN' OR (bantype = 'TEMPBAN' AND expiration_time > Now()))"
			params["ban_id"] = pulled_ban_id
		else
			query_content = "SELECT id, ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM ss13_ban WHERE isnull(unbanned) AND (bantype = 'PERMABAN' OR (bantype = 'TEMPBAN' AND expiration_time > Now())) AND (ckey = :ckey: OR computerid = :computerid: OR ip = :address:)"
			params["ckey"] = ckey
			params["computerid"] = computer_id
			params["address"] = address

		var/DBQuery/query = GLOB.dbcon.NewQuery(query_content)
		query.Execute(params)

		while(query.NextRow())
			var/ban_id = text2num(query.item[1])
			var/pckey = query.item[2]
			var/pip = query.item[3]
			var/pcid = query.item[4]
			var/ackey = query.item[5]
			var/reason = query.item[6]
			var/expiration = query.item[7]
			var/duration = query.item[8]
			var/bantime = query.item[9]
			var/bantype = query.item[10]

			if (pckey != ckey || (address && pip != address) || (computer_id && pcid != computer_id))
				handle_ban_mirroring(ckey, address, computer_id, ban_id)

			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

			var/desc = "\nReason: You, or another user of this computer or connection ([pckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [ackey] on [bantime], [expires]"
			if (GLOB.config.forum_passphrase)
				desc += "\nTo register on the forums, please use the following passphrase: [GLOB.config.forum_passphrase]"

			LOG_CLIENT_CONNECTION(ACCESS_STATUS_BANNED)
			return list("reason"="[bantype]", "desc"="[desc]", "id" = ban_id)

	var/list/ban = ..()	//default pager ban stuff

	if (ban) // stickyban management stuff.
		. = ban

		if (real_bans_only)
			return

		var/bannedckey = "ERROR"
		if (ban["ckey"])
			bannedckey = ban["ckey"]

		var/newmatch = FALSE
		var/list/cachedban = SSstickyban.cache[bannedckey]
		//rogue ban in the process of being reverted.
		if (cachedban && (cachedban["reverting"] || cachedban["timeout"]))
			world.SetConfig("ban", bannedckey, null)
			return null

		if (cachedban && ckey != bannedckey)
			newmatch = TRUE
			if (cachedban["keys"])
				if (cachedban["keys"][ckey])
					newmatch = FALSE
			if (cachedban["matches_this_round"][ckey])
				newmatch = FALSE

		if (newmatch && cachedban)
			var/list/newmatches = cachedban["matches_this_round"]
			var/list/pendingmatches = cachedban["matches_this_round"]
			var/list/newmatches_connected = cachedban["existing_user_matches_this_round"]
			var/list/newmatches_admin = cachedban["admin_matches_this_round"]

			if (C)
				newmatches_connected[ckey] = ckey
				newmatches_connected = cachedban["existing_user_matches_this_round"]
				pendingmatches[ckey] = ckey
				sleep(STICKYBAN_ROGUE_CHECK_TIME)
				pendingmatches -= ckey
			if (admin)
				newmatches_admin[ckey] = ckey

			if (cachedban["reverting"] || cachedban["timeout"])
				return null

			newmatches[ckey] = ckey


			if (\
				newmatches.len+pendingmatches.len > STICKYBAN_MAX_MATCHES || \
				newmatches_connected.len > STICKYBAN_MAX_EXISTING_USER_MATCHES || \
				newmatches_admin.len > STICKYBAN_MAX_ADMIN_MATCHES \
			)

				var/action
				if (ban["fromdb"])
					cachedban["timeout"] = TRUE
					action = "putting it on timeout for the remainder of the round"
				else
					cachedban["reverting"] = TRUE
					action = "reverting to its roundstart state"

				world.SetConfig("ban", bannedckey, null)

				//we always report this
				log_game("Stickyban on [bannedckey] detected as rogue, [action]")
				message_admins("Stickyban on [bannedckey] detected as rogue, [action]")
				//do not convert to timer.
				spawn (5)
					world.SetConfig("ban", bannedckey, null)
					sleep(1)
					world.SetConfig("ban", bannedckey, null)
					if (!ban["fromdb"])
						cachedban = cachedban.Copy() //so old references to the list still see the ban as reverting
						cachedban["matches_this_round"] = list()
						cachedban["existing_user_matches_this_round"] = list()
						cachedban["admin_matches_this_round"] = list()
						cachedban -= "reverting"
						SSstickyban.cache[bannedckey] = cachedban
						world.SetConfig("ban", bannedckey, list2stickyban(cachedban))
				return null

		if (ban["fromdb"])
			if(establish_db_connection(GLOB.dbcon))
				spawn()
					var/DBQuery/query = GLOB.dbcon.NewQuery("INSERT INTO ss13_stickyban_matched_ckey (matched_ckey, stickyban) VALUES ('[sanitizeSQL(ckey)]', '[sanitizeSQL(bannedckey)]') ON DUPLICATE KEY UPDATE last_matched = now()")
					query.Execute()

					query = GLOB.dbcon.NewQuery("INSERT INTO ss13_stickyban_matched_ip (matched_ip, stickyban) VALUES ( INET_ATON('[sanitizeSQL(address)]'), '[sanitizeSQL(bannedckey)]') ON DUPLICATE KEY UPDATE last_matched = now()")
					query.Execute()

					query = GLOB.dbcon.NewQuery("INSERT INTO ss13_stickyban_matched_cid (matched_cid, stickyban) VALUES ('[sanitizeSQL(computer_id)]', '[sanitizeSQL(bannedckey)]') ON DUPLICATE KEY UPDATE last_matched = now()")
					query.Execute()

		//byond will not trigger isbanned() for "global" host bans,
		//ie, ones where the "apply to this game only" checkbox is not checked (defaults to not checked)
		//So it's safe to let admins walk thru host/sticky bans here
		if (admin)
			log_admin("The admin [key] has been allowed to bypass a matching host/sticky ban on [bannedckey]")
			if (message)
				message_admins("<span class='adminnotice'>The admin [key] has been allowed to bypass a matching host/sticky ban on [bannedckey]</span>")
			return null

		if (C) //user is already connected!.
			to_chat(C, "You are about to get disconnected for matching a sticky ban after you connected. If this turns out to be the ban evasion detection system going haywire, we will automatically detect this and revert the matches. if you feel that this is the case, please wait EXACTLY 6 seconds then reconnect using file -> reconnect to see if the match was automatically reversed.")

		var/desc = "\nReason:(StickyBan) You, or another user of this computer or connection ([bannedckey]) is banned from playing here. The ban reason is:\n[ban["message"]]\nThis ban was applied by [ban["admin"]]\nThis is a BanEvasion Detection System ban, if you think this ban is a mistake, please wait EXACTLY 6 seconds, then try again before filing an appeal.\n"
		. = list("reason" = "Stickyban", "desc" = desc)
		log_access("Failed Login: [key] [computer_id] [address] - StickyBanned [ban["message"]] Target Username: [bannedckey] Placed by [ban["admin"]]")
		LOG_CLIENT_CONNECTION(ACCESS_STATUS_STICKYBANNED)

	LOG_CLIENT_CONNECTION(ACCESS_STATUS_PERMITTED)
	return .


#undef ACCESS_STATUS_ADMINPERMITTED
#undef ACCESS_STATUS_PERMITTED
#undef ACCESS_STATUS_GUESTDENIED
#undef ACCESS_STATUS_NOIP
#undef ACCESS_STATUS_NOCID
#undef ACCESS_STATUS_BANNED
#undef ACCESS_STATUS_STICKYBANNED

#undef LOG_CLIENT_CONNECTION

#undef STICKYBAN_MAX_MATCHES
#undef STICKYBAN_MAX_EXISTING_USER_MATCHES
#undef STICKYBAN_MAX_ADMIN_MATCHES
