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

	var/DBQuery/original_ban = dbcon.NewQuery("SELECT ckey, ip, computerid FROM ss13_ban WHERE id = :ban_id:")
	original_ban.Execute(list("ban_id" = ban_id))

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
			var/DBQuery/mirrored_bans = dbcon.NewQuery("SELECT ckey, ip, computerid FROM ss13_ban_mirrors WHERE isnull(deleted_at) AND ban_id = :ban_id:")
			mirrored_bans.Execute(list("ban_id" = ban_id))

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
				apply_ban_mirror(ckey, address, computer_id, ban_id, 3)

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

	var/DBQuery/initial_query = dbcon.NewQuery("SELECT DISTINCT ban_id FROM ss13_ban_mirrors WHERE isnull(deleted_at) AND (ckey = :ckey: OR ip = :address: OR computerid = :computerid:)")
	initial_query.Execute(list("ckey" = ckey, "address" = address, "computerid" = computer_id))

	var/list/ban_ids = list()

	while (initial_query.NextRow())
		ban_ids += text2num(initial_query.item[1])

	// No mirrors exist.
	if (!ban_ids.len)
		return null

	var/DBQuery/search_query = dbcon.NewQuery("SELECT id FROM ss13_ban WHERE id IN :vars: AND isnull(unbanned) AND (bantype = 'PERMABAN' OR (bantype = 'TEMPBAN' AND expiration_time > Now()))")
	search_query.Execute(list("vars" = ban_ids))

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

/proc/apply_ban_mirror(var/ckey, var/address, var/computer_id, var/ban_id, var/source = 1, var/list/extra_info = list())
	if (!ckey || !address || !computer_id || !ban_id)
		return

	. = list()
	for (var/i = 1; i <= extra_info.len && i <= 50; i++)
		. |= extra_info[i][1]

	var/DBQuery/new_mirror = dbcon.NewQuery("INSERT INTO ss13_ban_mirrors (id, ban_id, ckey, ip, computerid, source, extra_info, datetime) VALUES (NULL, :ban_id:, :ckey:, :address:, :computerid:, :source:, :info:, NOW())")
	new_mirror.Execute(list("ban_id" = ban_id, "ckey" = ckey, "address" = address, "computerid" = computer_id, "source" = source, "info" = json_encode(.)))

	log_misc("Mirrored ban #[ban_id] for player [ckey] from [address]-[computer_id].")

/proc/get_ban_mirrors(var/ban_id)
	if (!ban_id)
		return null

	establish_db_connection(dbcon)

	if (!dbcon.IsConnected())
		return null

	var/DBQuery/query = dbcon.NewQuery("SELECT id, ckey, ip, computerid, date(datetime) as datetime, source, extra_info, deleted_at FROM ss13_ban_mirrors WHERE ban_id = :ban_id:")
	query.Execute(list("ban_id" = ban_id))

	var/list/mirrors = list()
	while (query.NextRow())
		var/list/items = list(7)
		items["id"] = text2num(query.item[1])
		items["ckey"] = query.item[2]
		items["ip"] = query.item[3]
		items["computerid"] = query.item[4]
		items["date"] = query.item[5]
		items["source"] = query.item[6]

		items["extra"] = FALSE
		if (query.item[7])
			try
				var/list/temp = json_decode(query.item[7])
				if (temp.len)
					items["extra"] = TRUE
			catch()

		if (query.item[8])
			items["inactive"] = TRUE
		else
			items["inactive"] = FALSE

		mirrors += list(items)

	return mirrors

/proc/display_mirrors_panel(mob/user, ban_id)
	if (!user || !check_rights(R_MOD|R_ADMIN) || !ban_id)
		return

	var/list/mirrors = get_ban_mirrors(ban_id)

	if (!mirrors)
		to_chat(user, "<span class='warning'>Something went horribly wrong.</span>")
		return

	if (!mirrors.len)
		to_chat(user, "<span class='warning'>No mirrors for this ban found.</span>")
		return

	var/output = "<b><center>Ban mirrors for ban #[ban_id]</center></b><br>"
	output += "<center>Each line indicates a new bypass attempt.</center><br>"

	output += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
	output += "<tr>"
	output += "<th width='25%'><b>TYPE</b></th>"
	output += "<th width='25%'><b>CKEY</b></th>"
	output += "<th width='30%'><b>TIME APPLIED</b></th>"
	output += "<th width='20%'><b>OPTIONS</b></th>"
	output += "</tr>"

	var/static/list/bg_colors = list("#ffeeee", "#ffdddd")
	var/i = 0
	for (var/mirror in mirrors)
		var/list/details = mirror
		var/bg = details["inactive"] ? "#aaaaaa" : bg_colors[i + 1]

		output += "<tr bgcolor='[bg]'>"
		output += "<td align='center'>[details["source"]]</td>"
		output += "<td align='center'>[details["ckey"]]</td>"
		output += "<td align='center'>[details["date"]]</td>"
		output += "<td align='center'><a href='?_src_=holder;dbbanmirroract=[details["id"]];mirrorstatus=[details["inactive"]]'>[details["inactive"] ? "Reactivate" : "Deactivate"]</a>"
		if (details["extra"])
			output += " | <a href='?_src_=holder;dbbanmirroract=[details["id"]];mirrorckeys=1'>View Ckeys</a>"
		output += "</td></tr>"

		output += "<tr bgcolor='[bg]'>"
		output += "<td align='center' colspan='2'>IP: [details["ip"]]</td>"
		output += "<td align='center' colspan='2'>CID: [details["computerid"]]</td>"
		output += "</tr>"

		i = (++i % 2)

	output += "</table>"
	to_chat(user, browse(output, "window=banmirrors;size=600x400"))

/proc/display_mirrors_ckeys(mob/user, mirror_id)
	if (!user || !check_rights(R_MOD|R_ADMIN) || !mirror_id)
		return

	if (!establish_db_connection(dbcon))
		to_chat(user, "<span class='warning'>Database connection failed!</span>")
		return

	var/DBQuery/query = dbcon.NewQuery("SELECT extra_info, ban_id FROM ss13_ban_mirrors WHERE id = :id:")
	query.Execute(list("id" = mirror_id))

	if (!query.NextRow())
		to_chat(user, "<span class='notice'>Unable to locate mirror with ID #[mirror_id].</span>")
		return

	if (!query.item[1] || !length(query.item[1]))
		to_chat(user, "<span class='notice'>No attached ckeys were found.</span>")
		return

	var/output = "<a href='?_src_=holder;dbbanmirrors=[query.item[2]];'>Back</a><br><br>"
	try
		var/list/ckeys = json_decode(query.item[1])

		if (!ckeys.len)
			to_chat(user, "<span class='notice'>No alternate ckeys to report.</span>")
			return

		output += ckeys.Join("<br>")
	catch()
		to_chat(user, "<span class='notice'>Maligned data found. Please alert the system administrator.</span>")
		return

	output += "<br><br><a href='?_src_=holder;dbbanmirrors=[query.item[2]];'>Back</a>"
	to_chat(user, browse(output, "window=banmirrors"))

/proc/toggle_mirror_status(mob/user, mirror_id, inactive = FALSE)
	if (!user || !check_rights(R_MOD|R_ADMIN) || !mirror_id)
		return

	if (!establish_db_connection(dbcon))
		to_chat(user, "<span class='warning'>Database connection failed!</span>")
		return

	var/query_text = inactive ? "UPDATE ss13_ban_mirrors SET deleted_at = NULL WHERE id = :id:" : "UPDATE ss13_ban_mirrors SET deleted_at = NOW() WHERE id = :id:"

	var/DBQuery/query = dbcon.NewQuery(query_text)
	query.Execute(list("id" = mirror_id))

	if (query.ErrorMsg())
		to_chat(user, "<span class='warning'>An error occured while toggling mirror status!</span>")
	else
		to_chat(user, "<span class='notice'>Mirror set to [inactive ? "ACTIVE" : "INACTIVE"].</span>")

/proc/handle_connection_info(var/client/C, var/data)
	if (!C)
		return

	if (!data)
		update_connection_data(C)
		return

	var/list/data_object

	try
		data_object = json_decode(data)

	catch(var/exception/E)
		data_object = list()
		log_debug("CONN DATA: [E] encountered when loading data for [C.ckey].")

	if (!data_object || !data_object.len)
		log_debug("CONN DATA: [C.ckey] has no connection data to showcase.")
		return

	if (data_object["vms"])
		var/A = data_object["vms"]
		var/count = 0
		if (A & 1)
			count++
		if (A & 2)
			count++

		if (config.access_deny_vms && count >= config.access_deny_vms)
			log_access("Failed Login: [C.ckey] [C.address] [C.computer_id] - Matching [count]/[config.access_deny_vms] VM identifiers. IDs: [A].", ckey = C.ckey)
			message_admins("Failed Login: [C.ckey] [C.address] [C.computer_id] - Matching [count]/[config.access_deny_vms] VM identifiers. IDs: [A].")
			spawn(20)
				if (C)
					del(C)
			return

		if (config.access_warn_vms && count >= config.access_warn_vms)
			log_access("Notice: [key_name(C)] [C.address] [C.computer_id] - Matching [count] VM identifiers. IDs: [A].", ckey = C.ckey)
			message_admins("Notice: [key_name(C)] [C.address] [C.computer_id] - Matching [count] VM identifiers. IDs: [A].")

	var/list/conn_info = data_object["conn"]

	if (!conn_info || !conn_info.len)
		return
	else if (conn_info.len > 100)
		log_debug("MIRROR BANS: [C.ckey] has [conn_info.len] unique sets. They were dropped and not processed.")
		update_connection_data(C)
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
		if (!C.holder)
			log_and_message_admins("[C.ckey] from [C.address]-[C.computer_id] was caught bandodging. Mirror applied for ban #[ding_bannu], kicking shortly.")
			apply_ban_mirror(C.ckey, C.address, C.computer_id, ding_bannu, 2, conn_info)
			spawn(20)
				del(C)
		else
			// Stop kicking me off my test server, fuck.
			log_and_message_admins("[C.ckey] is a staff but was caught bandodging! Ban ID: #[ding_bannu].")

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
