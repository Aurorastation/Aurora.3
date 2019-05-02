#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key,address,computer_id)
	if(ckey(key) in admin_datums)
		return ..()

	//Guest Checking
	if(!config.guests_allowed && IsGuestKey(key) && !config.external_auth)
		log_access("Failed Login: [key] - Guests not allowed",ckey=key_name(key))
		message_admins("<span class='notice'>Failed Login: [key] - Guests not allowed</span>")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	if(config.ban_legacy_system)
		//Ban Checking
		. = CheckBan( ckey(key), computer_id, address )
		if(.)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]",ckey=key_name(key))
			message_admins("<span class='notice'>Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]</span>")
			return .

		return ..()	//default pager ban stuff

	else

		if (!address)
			log_access("Failed Login: [key] null-[computer_id] - Denied access: No IP address broadcast.",ckey=key_name(key))
			message_admins("[key] tried to connect without an IP address.")
			return list("reason" = "Temporary ban", "desc" = "Your connection did not broadcast an IP address to check.")

		if (!computer_id)
			log_access("Failed Login: [key] [address]-null - Denied access: No computer ID broadcast.",ckey=key_name(key))
			message_admins("[key] tried to connect without a computer ID.")
			return list("reason" = "Temporary ban", "desc" = "Your connection did not broadcast an computer ID to check.")

		var/ckey = ckey(key)

		if(!establish_db_connection(dbcon))
			error("Ban database connection failure. Key [ckey] not checked")
			log_misc("Ban database connection failure. Key [ckey] not checked")
			return

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

		var/DBQuery/query = dbcon.NewQuery(query_content)
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
			if (config.forum_passphrase)
				desc += "\nTo register on the forums, please use the following passphrase: [config.forum_passphrase]"

			return list("reason"="[bantype]", "desc"="[desc]", "id" = ban_id)

		return ..()	//default pager ban stuff
#endif
#undef OVERRIDE_BAN_SYSTEM
