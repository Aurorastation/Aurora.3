//System will now support SQL pulls for fetching player notes.
//Yay!

/proc/notes_add_sql(var/player_ckey, var/note, var/mob/user, var/player_address, var/player_computerid)
	if(!player_ckey || !note)
		return

	var/list/query_details = list(":ckey" = player_ckey, ":address" = player_address ? player_address : null, ":computer_id" = player_computerid ? player_computerid : null, ":a_ckey" = null, ":note" = note)

	if (!user)
		query_details[":a_ckey"] = "Adminbot"
	else
		query_details[":a_ckey"] = user.ckey

	establish_db_connection()
	if (!dbcon.IsConnected())
		alert("SQL connection failed while trying to add a note!")
		return

	if (!player_address || !player_computerid)
		var/DBQuery/init_query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = :ckey")
		init_query.Execute(list(":ckey" = player_ckey))
		if (init_query.NextRow())
			if (!query_details[":address"])
				query_details[":address"] = init_query.item[1]
			if (!query_details[":computer_id"])
				query_details[":computer_id"] = init_query.item[2]

	var/DBQuery/insert_query = dbcon.NewQuery("INSERT INTO ss13_notes (id, adddate, ckey, ip, computerid, a_ckey, content) VALUES (null, Now(), :ckey, :address, :computer_id, :a_ckey, :note)")
	insert_query.Execute(query_details)

	message_admins("\blue [key_name_admin(user)] has edited [player_ckey]'s notes.")
	log_admin("[key_name(user)] has edited [player_ckey]'s notes.")

/proc/notes_edit_sql(var/note_id, var/note_edit)
	if (!note_id || !note_edit)
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		error("SQL connection failed while attempting to delete a note!")
		return

	var/count = 0 //failsafe from unban procs
	var/ckey
	var/note

	var/DBQuery/init_query = dbcon.NewQuery("SELECT ckey, content FROM ss13_notes WHERE id = :note_id")
	init_query.Execute(list(":note_id" = note_id))
	while (init_query.NextRow())
		ckey = init_query.item[1]
		note = init_query.item[2]
		count++

	if (count == 0)
		usr << "\red Database update failed due to a note id not being present in the database."
		error("Database update failed due to a note id not being present in the database.")
		return

	if (count > 1)
		usr << "\red Database update failed due to multiple notes having the same ID. Contact the database admin."
		error("Database update failed due to multiple notes having the same ID. Contact the database admin.")
		return

	switch (note_edit)
		if ("delete")
			if(alert("Delete this note?", "Delete?", "Yes", "No") == "Yes")
				var/DBQuery/deletequery = dbcon.NewQuery("UPDATE ss13_notes SET visible = 0 WHERE id = :note_id")
				deletequery.Execute(list(":note_id" = note_id))

				message_admins("\blue [key_name_admin(usr)] deleted one of [ckey]'s notes.")
				log_admin("[key_name(usr)] deleted one of [ckey]'s notes.")
			else
				usr << "Cancelled"
				return
		if ("content")
			var/new_content = input("Edit this note's contents.", "New Contents", note, null) as null|text
			if (!new_content)
				usr << "Cancelled"
				return
			var/DBQuery/editquery = dbcon.NewQuery("UPDATE ss13_notes SET content = :new_content, lasteditor = :a_ckey, lasteditdate = Now(), edited = 1 WHERE id = :note_id")
			editquery.Execute(list(":new_content" = new_content, ":a_ckey" = usr.client.ckey, ":note_id" = note_id))

/datum/admins/proc/show_notes_sql(var/player_ckey = null, var/admin_ckey = null)
	if (!check_rights(R_ADMIN|R_MOD))
		return

	if (admin_ckey == "Adminbot")
		usr << "Adminbot is not an actual admin. You were lied to."
		//The fucking size of this request would be astronomical. Please do not!
		return

	player_ckey = ckey(player_ckey)
	admin_ckey = ckey(admin_ckey)

	establish_db_connection()
	if (!dbcon.IsConnected())
		error("SQL connection failed while attempting to view a player's notes!")
		return

	var/dat = "<div align='center'><h3>Notes Look-up Panel</h3><br>"

	//Totally not stealing code from the DB_ban_panel

	dat += "<form method='GET' action='?src=\ref[src]'><b>Search:</b> "
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += "<b>Ckey:</b> <input type='text' name='notessearchckey' value='[player_ckey]'>"
	dat += "<b>Admin ckey:</b> <input type='text' name='notessearchadmin' value='[admin_ckey]'>"
	dat += "<input type='submit' value='search'>"
	dat += "</form></div>"

	dat += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
	dat += "<tr>"
	dat += "<th width='10%'>ISSUED TO</th>"
	dat += "<th width='10%'>ISSUED BY</th>"
	dat += "<th width='20%'>TIME ISSUED</th>"
	dat += "<th width='50%'>CONTENT</th>"
	dat += "</tr>"

	if (player_ckey)
		var/list/query_details = list(":player_ckey" = player_ckey)

		dat += "<tr><td align='center' colspan='4' bgcolor='white'><b><a href='?src=\ref[src];add_player_info=[player_ckey]'>Add Note</a></b></td></tr>"

		var/DBQuery/init_query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = :player_ckey")
		init_query.Execute(query_details)
		if (init_query.NextRow())
			query_details += ":player_address"
			query_details += ":player_computerid"
			query_details[":player_address"] = init_query.item[1]
			query_details[":player_computerid"] = init_query.item[2]

		var/query_content = "SELECT id, adddate, ckey, a_ckey, content, edited, lasteditor, lasteditdate FROM ss13_notes WHERE ckey = :player_ckey AND visible = '1'"

		if (query_details[":player_address"])
			query_content += " OR ip = :player_address AND visible = '1'"
		if (query_details[":player_computerid"])
			query_content += " OR computerid = :player_computerid AND visible = '1'"

		query_content += " ORDER BY adddate ASC"
		var/DBQuery/query = dbcon.NewQuery(query_content)
		query.Execute(query_details, 1)

		while (query.NextRow())
			var/id = text2num(query.item[1])
			var/date = query.item[2]
			var/p_ckey = query.item[3]
			var/a_ckey = query.item[4]
			var/content = query.item[5]
			var/edited = text2num(query.item[6])

			if (admin_ckey && ckey(a_ckey) != ckey(admin_ckey))
				continue
			else
				dat += "<tr bgcolor='#ffeeee'><td align='center'><b>[p_ckey]</b></td><td align='center'><b>[a_ckey]</b></td><td align='center'>[date]</td><td align='center'>[content]</td></tr>"
				if (edited)
					var/lasteditor = query.item[7]
					var/editdate = query.item[8]
					dat += "<tr><td align='center' colspan='4'><b>Note last edited: [editdate], by: [lasteditor].</b></td></tr>"
				dat += "<tr><td align='center' colspan='4'><b>(<a href=\"byond://?src=\ref[src];dbnoteedit=delete;dbnoteid=[id]\">Delete</a>) (<a href=\"byond://?src=\ref[src];dbnoteedit=content;dbnoteid=[id]\">Edit</a>)</b></td></tr>"
				dat += "<tr><td colspan='4' bgcolor='white'>&nbsp</td></tr>"

	else if (admin_ckey && !player_ckey)
		var/aquery_content = "SELECT id, adddate, ckey, content, edited, lasteditor, lasteditdate FROM ss13_notes WHERE a_ckey = :a_ckey AND visible = '1' ORDER BY adddate ASC"
		var/DBQuery/admin_query = dbcon.NewQuery(aquery_content)
		admin_query.Execute(list(":a_ckey" = admin_ckey))

		while (admin_query.NextRow())
			var/id = text2num(admin_query.item[1])
			var/date = admin_query.item[2]
			var/p_ckey = admin_query.item[3]
			var/content = admin_query.item[4]
			var/edited = text2num(admin_query.item[5])

			dat += "<tr bgcolor='#ffeeee'><td align='center'><b>[p_ckey]</b></td><td align='center'><b>[admin_ckey]</b></td><td align='center'>[date]</td><td align='center'>[content]</td></tr>"
			if (edited)
				var/lasteditor = admin_query.item[6]
				var/editdate = admin_query.item[7]
				dat += "<tr><td align='center' colspan='4'><b>Note last edited: [editdate], by: [lasteditor].</b></td></tr>"
			dat += "<tr><td align='center' colspan='4'><b>(<a href=\"byond://?src=\ref[src];dbnoteedit=delete;dbnoteid=[id]\">Delete</a>) (<a href=\"byond://?src=\ref[src];dbnoteedit=content;dbnoteid=[id]\">Edit</a>)</b></td></tr>"
			dat += "<tr><td colspan='4' bgcolor='white'>&nbsp</td></tr>"

	dat += "</table>"
	usr << browse(dat,"window=lookupnotes;size=900x500")

/*/proc/notes_transfer()
	msg_scopes("Locating master list.")
	var/savefile/note_list = new("data/player_notes.sav")
	var/list/note_keys
	note_list >> note_keys

	msg_scopes("Establishing DB connection!")
	establish_db_connection()
	if(!dbcon.IsConnected())
		msg_scopes("No DB connection!")
		return

	for(var/t in note_keys)
		var/IP = null
		var/CID = null
		var/DBQuery/query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = '[t]'")
		query.Execute()
		if(query.NextRow())
			IP = query.item[1]
			CID = query.item[2]

		var/savefile/info = new("data/player_saves/[copytext(t, 1, 2)]/[t]/info.sav")
		var/list/infos
		info >> infos

		for(var/datum/player_info/I in infos)
			var/a_ckey = sanitizeSQL(I.author)
			var/timeY = copytext(I.timestamp, findtext(I.timestamp, "of") + 3)
			var/timeM
			var/timeD = copytext(I.timestamp, findtext(I.timestamp, " ", 6) + 1, findtext(I.timestamp, " ", 6) + 3)
			if(findtext(timeD, "s") || findtext(timeD, "n") || findtext(timeD, "r") || findtext(timeD, "t"))
				timeD = "0[copytext(timeD, 1, 2)]"

//			msg_scopes("Timestamp: [I.timestamp].")
			var/temp = copytext(I.timestamp, 6, findtext(I.timestamp, " ", 6))
//			msg_scopes("The day? [timeD].")
//			msg_scopes("The month? [temp].")
//			msg_scopes("The year? [timeY].")
			switch(temp)
				if("January")
					timeM = "01"
				if("February")
					timeM = "02"
				if("March")
					timeM = "03"
				if("April")
					timeM = "04"
				if("May")
					timeM = "05"
				if("June")
					timeM = "06"
				if("July")
					timeM = "07"
				if("August")
					timeM = "08"
				if("September")
					timeM = "09"
				if("October")
					timeM = "10"
				if("November")
					timeM = "11"
				if("December")
					timeM = "12"

			var/DTG = "[timeY]-[timeM]-[timeD] 00:00:00"
//			msg_scopes("Full DTG: [DTG]")
			var/insertionstuff
			if(IP && CID)
				insertionstuff = "INSERT INTO ss13_notes (id, adddate, ckey, ip, computerid, a_ckey, content) VALUES (null, '[DTG]', '[t]', '[IP]', '[CID]', '[a_ckey]', '[I.content]')"
			else
				insertionstuff = "INSERT INTO ss13_notes (id, adddate, ckey, ip, computerid, a_ckey, content) VALUES (null, '[DTG]', '[t]', null, null, '[a_ckey]', '[I.content]')"
			var/DBQuery/insertquery = dbcon.NewQuery(insertionstuff)
			insertquery.Execute()
			if(insertquery.ErrorMsg())
				msg_scopes(insertquery.ErrorMsg())
			else
				msg_scopes("Transfer successful.")*/
