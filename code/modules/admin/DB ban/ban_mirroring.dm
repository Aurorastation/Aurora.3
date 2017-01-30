#define BAD_CKEY 1
#define BAD_IP 2
#define BAD_CID 4

/proc/handle_ban_mirroring(var/ckey, var/address, var/computer_id, var/ban_id)
	if (!ckey || !address || !computer_id || !ban_id)
		return

	establish_db_connection(dbcon)

	if (!dbcon.IsConnected())
		error("Ban database connection failure while attempting to mirror. Key passed for mirror handling: [ckey].")
		log_misc("Ban database connection failure while attempting to mirror. Key passed for mirror handling: [ckey].")
		return

	var/bad_data = BAD_CKEY|BAD_IP|BAD_CID

	var/DBQuery/original_ban = dbcon.NewQuery("SELECT ckey, ip, computerid FROM ss13_ban WHERE id = :ban_id")
	original_ban.Execute(list(":ban_id" = ban_id))

	if (original_ban.NextRow())
		var/original_ckey = original_ban.item[1]
		var/original_address = original_ban.item[2]
		var/original_computerid = original_ban.item[3]
		if (original_ckey == ckey)
			bad_data &= ~BAD_CKEY
		if (original_address == address)
			bad_data &= ~BAD_IP
		if (original_computerid == computer_id)
			bad_data &= ~BAD_CID

		if (bad_data)
			var/DBQuery/mirrored_bans = dbcon.NewQuery("SELECT player_ckey, ban_mirror_ip, ban_mirror_computerid FROM ss13_ban_mirrors WHERE ban_id = :ban_id")
			mirrored_bans.Execute(list(":ban_id" = ban_id))

			while (mirrored_bans.NextRow())
				var/mirrored_ckey = mirrored_bans.item[1]
				var/mirrored_address = mirrored_bans.item[2]
				var/mirrored_computerid = mirrored_bans.item[3]

				if ((bad_data & BAD_CKEY) && mirrored_ckey == ckey)
					bad_data &= ~BAD_CKEY
				if ((bad_data & BAD_IP) && mirrored_address == address)
					bad_data &= ~BAD_IP
				if ((bad_data & BAD_CID) && mirrored_computerid == computer_id)
					bad_data &= ~BAD_CID

			if (bad_data)
				apply_ban_mirror(ckey, address, computer_id, ban_id)

		return

	else
		error("No ban retreived while attempting to handle ban mirroring. Passed ban_id: [ban_id], ckey: [ckey].")
		log_misc("No ban retreived while attempting to handle ban mirroring. Passed ban_id: [ban_id], ckey: [ckey].")
		return

/proc/get_active_mirror(var/ckey, var/address, var/computer_id)
	if (!ckey || !address || !computer_id)
		return null

	establish_db_connection(dbcon)

	if (!dbcon.IsConnected())
		error("Ban database connection failure while attempting to check mirrors. Key passed for mirror checking: [ckey].")
		log_misc("Ban database connection failure while attempting to check mirrors. Key passed for mirror checking: [ckey].")
		return null

	var/DBQuery/initial_query = dbcon.NewQuery("SELECT DISTINCT ban_id FROM ss13_ban_mirrors WHERE player_ckey = :ckey OR ban_mirror_ip = :address OR ban_mirror_computerid = :computerid")
	initial_query.Execute(list(":ckey" = ckey, ":address" = address, ":computerid" = computer_id))

	var/list/ban_ids = list()

	while (initial_query.NextRow())
		ban_ids += text2num(initial_query.item[1])

	// No mirrors exist.
	if (!ban_ids.len)
		return null

	var/DBQuery/search_query = dbcon.NewQuery("SELECT id FROM ss13_ban WHERE id IN :vars AND (bantype = 'PERMABAN' OR (bantype = 'TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")
	search_query.Execute(list(":vars" = ban_ids))

	var/list/active_bans = list()

	while (search_query.NextRow())
		active_bans += text2num(search_query.item[1])

	if (!active_bans.len)
		// None are active.
		return null
	else
		// Return the latest entry, if multiple bans are active.
		// Just in case.
		return active_bans[active_bans.len]

/proc/get_ban_mirrors(var/ban_id)
	if (!ban_id)
		return null

	establish_db_connection(dbcon)

	if (!dbcon.IsConnected())
		return null

	var/DBQuery/query = dbcon.NewQuery("SELECT ban_mirror_id, player_ckey, ban_mirror_ip, ban_mirror_computerid, date(ban_mirror_datetime) as datetime FROM ss13_ban_mirrors WHERE ban_id = :ban_id")
	query.Execute(list(":ban_id" = ban_id))

	var/mirrors[] = list()
	while (query.NextRow())
		var/items[] = list()
		items["ckey"] = query.item[2]
		items["ip"] = query.item[3]
		items["computerid"] = query.item[4]
		items["date"] = query.item[5]

		mirrors[query.item[1]] = items

	return mirrors

/proc/apply_ban_mirror(var/ckey, var/address, var/computer_id, var/ban_id)
	if (!ckey || !address || !computer_id || !ban_id)
		return

	var/DBQuery/new_mirror = dbcon.NewQuery("INSERT INTO ss13_ban_mirrors (ban_id, player_ckey, ban_mirror_ip, ban_mirror_computerid, ban_mirror_datetime) VALUES (:ban_id, :ckey, :address, :computerid, NOW())")
	new_mirror.Execute(list(":ban_id" = ban_id, ":ckey" = ckey, ":address" = address, ":computerid" = computer_id))

	log_misc("Mirrored ban #[ban_id] for player [ckey] from [address]-[computer_id].")

/proc/handle_connection_info(var/client/C, var/data)
	if (!C)
		return

	if (!data)
		update_connection_data(C)
		return

	var/list/conn_info = json_decode(data)

	if (!conn_info || !conn_info.len)
		return

	var/ding_bannu = 0
	var/new_info = BAD_CKEY|BAD_IP|BAD_CID

	for (var/A in conn_info)
		var/list/dset = A
		if (dset.len != 3)
			continue

		if (new_info)
			if (dset[1] == C.ckey)
				new_info &= ~BAD_CKEY
			if (dset[2] == C.address)
				new_info &= ~BAD_IP
			if (dset[3] == C.computer_id)
				new_info &= ~BAD_CID

		var/list/bdata = world.IsBanned(dset[1], dset[2], dset[3], 1)
		if (bdata && bdata.len && !isnull(bdata["id"]))
			ding_bannu = bdata["id"]
			break

	if (new_info)
		update_connection_data(C, conn_info)

	if (ding_bannu)
		log_and_message_admins("[C.ckey] from [C.address]-[C.computer_id] was caught bandodging. Mirror applied for ban #[ding_bannu], kicking shortly.")
		apply_ban_mirror(C.ckey, C.address, C.computer_id, ding_bannu)
		spawn(20)
			del(C)

	return

/proc/update_connection_data(var/client/C, var/list/data = list())
	if (!C)
		return

	data += list(list(C.ckey, C.address, C.computer_id))

	var/data_str = json_encode(data)
	C << output(list2params(list("E-DAT", data_str, 900)), "greeting.browser:setCookie")

#undef BAD_CID
#undef BAD_IP
#undef BAD_CKEY
