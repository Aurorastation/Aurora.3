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

	ckey = ckey(ckey)

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
				var/DBQuery/new_mirror = dbcon.NewQuery("INSERT INTO ss13_ban_mirrors (ban_id, player_ckey, ban_mirror_ip, ban_mirror_computerid, ban_mirror_datetime) VALUES (:ban_id, :ckey, :address, :computerid, NOW())")
				new_mirror.Execute(list(":ban_id" = ban_id, ":ckey" = ckey, ":address" = address, ":computerid" = computer_id))

				log_misc("Mirrored ban #[ban_id] for player [ckey] from [address]-[computer_id].")

		return

	else
		error("No ban retreived while attempting to handle ban mirroring. Passed ban_id: [ban_id], ckey: [ckey].")
		log_misc("No ban retreived while attempting to handle ban mirroring. Passed ban_id: [ban_id], ckey: [ckey].")
		return

#undef BAD_CID
#undef BAD_IP
#undef BAD_CKEY
