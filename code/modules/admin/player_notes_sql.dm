//System will now support SQL pulls for fetching player notes.
//Yay!

/proc/notes_add_sql(var/player_ckey, var/note, var/mob/user, var/player_address, var/player_computerid)
	if(!player_ckey || !note)
		return

	var/list/query_details = list("game_id" = game_id, "ckey" = player_ckey, "address" = player_address ? player_address : null, "computer_id" = player_computerid ? player_computerid : null, "a_ckey" = null, "note" = note)

	if (!user)
		query_details["a_ckey"] = "Adminbot"
	else
		query_details["a_ckey"] = user.ckey

	if (!establish_db_connection(dbcon))
		alert("SQL connection failed while trying to add a note!")
		return

	if (!player_address || !player_computerid)
		var/DBQuery/init_query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = :ckey:")
		init_query.Execute(list("ckey" = player_ckey))
		if (init_query.NextRow())
			if (!query_details["address"])
				query_details["address"] = init_query.item[1]
			if (!query_details["computer_id"])
				query_details["computer_id"] = init_query.item[2]

	var/DBQuery/insert_query = dbcon.NewQuery("INSERT INTO ss13_notes (id, adddate, game_id, ckey, ip, computerid, a_ckey, content) VALUES (null, Now(), :game_id:, :ckey:, :address:, :computer_id:, :a_ckey:, :note:)")
	insert_query.Execute(query_details)

	message_admins("<span class='notice'>[key_name_admin(user)] has edited [player_ckey]'s notes.</span>")
	log_admin("[key_name(user)] has edited [player_ckey]'s notes.",admin_key=key_name(user),ckey=player_ckey)

/proc/notes_edit_sql(var/note_id, var/note_edit)
	if (!note_id || !note_edit)
		return

	if (!establish_db_connection(dbcon))
		error("SQL connection failed while attempting to delete a note!")
		return

	var/count = 0 //failsafe from unban procs
	var/ckey
	var/note

	var/DBQuery/init_query = dbcon.NewQuery("SELECT ckey, content FROM ss13_notes WHERE id = :note_id:")
	init_query.Execute(list("note_id" = note_id))
	while (init_query.NextRow())
		ckey = init_query.item[1]
		note = init_query.item[2]
		count++

	if (count == 0)
		to_chat(usr, "<span class='warning'>Database update failed due to a note id not being present in the database.</span>")
		error("Database update failed due to a note id not being present in the database.")
		return

	if (count > 1)
		to_chat(usr, "<span class='warning'>Database update failed due to multiple notes having the same ID. Contact the database admin.</span>")
		error("Database update failed due to multiple notes having the same ID. Contact the database admin.")
		return

	switch (note_edit)
		if ("delete")
			if(alert("Delete this note?", "Delete?", "Yes", "No") == "Yes")
				var/DBQuery/deletequery = dbcon.NewQuery("UPDATE ss13_notes SET visible = 0 WHERE id = :note_id:")
				deletequery.Execute(list("note_id" = note_id))

				message_admins("<span class='notice'>[key_name_admin(usr)] deleted one of [ckey]'s notes.</span>")
				log_admin("[key_name(usr)] deleted one of [ckey]'s notes.",admin_key=key_name(usr),ckey=ckey)
			else
				to_chat(usr, "Cancelled")
				return
		if ("content")
			var/new_content = input("Edit this note's contents.", "New Contents", note, null) as null|text
			if (!new_content)
				to_chat(usr, "Cancelled")
				return
			var/DBQuery/editquery = dbcon.NewQuery("UPDATE ss13_notes SET content = :new_content:, lasteditor = :a_ckey:, lasteditdate = Now(), edited = 1 WHERE id = :note_id:")
			editquery.Execute(list("new_content" = new_content, "a_ckey" = usr.client.ckey, "note_id" = note_id))

/datum/admins/proc/show_notes_sql(var/player_ckey = null, var/admin_ckey = null)
	if (!check_rights(R_ADMIN|R_MOD))
		return

	if (admin_ckey == "Adminbot")
		to_chat(usr, "Adminbot is not an actual admin. You were lied to.")
		//The fucking size of this request would be astronomical. Please do not!
		return

	player_ckey = ckey(player_ckey)
	admin_ckey = ckey(admin_ckey)

	if (!establish_db_connection(dbcon))
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
		var/list/query_details = list("player_ckey" = player_ckey)

		dat += "<tr><td align='center' colspan='4' bgcolor='white'><b><a href='?src=\ref[src];add_player_info=[player_ckey]'>Add Note</a></b></td></tr>"

		var/DBQuery/init_query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = :player_ckey:")
		init_query.Execute(query_details)
		if (init_query.NextRow())
			query_details["player_address"] = init_query.item[1]
			query_details["player_computerid"] = init_query.item[2]

		var/query_content = "SELECT id, adddate, ckey, a_ckey, content, edited, lasteditor, lasteditdate FROM ss13_notes WHERE ckey = :player_ckey: AND visible = '1'"

		if (query_details["player_address"])
			query_content += " OR ip = :player_address: AND visible = '1'"
		if (query_details["player_computerid"])
			query_content += " OR computerid = :player_computerid: AND visible = '1'"

		query_content += " ORDER BY adddate ASC"
		var/DBQuery/query = dbcon.NewQuery(query_content)
		query.Execute(query_details)

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
		var/aquery_content = "SELECT id, adddate, ckey, content, edited, lasteditor, lasteditdate FROM ss13_notes WHERE a_ckey = :a_ckey: AND visible = '1' ORDER BY adddate ASC"
		var/DBQuery/admin_query = dbcon.NewQuery(aquery_content)
		admin_query.Execute(list("a_ckey" = admin_ckey))

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

/proc/show_player_info_discord(var/ckey)
	if (!ckey)
		return "No ckey given!"

	if (!establish_db_connection(dbcon))
		return "Unable to establish database connection! Aborting!"

	var/DBQuery/info_query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = :ckey:")
	info_query.Execute(list("ckey" = ckey))

	var/address = null
	var/computer_id = null
	if (info_query.NextRow())
		address = info_query.item[1]
		computer_id = info_query.item[2]

	var/query_content = "SELECT a_ckey, adddate, content FROM ss13_notes WHERE visible = '1' AND ckey = :ckey:"
	var/query_details = list("ckey" = ckey, "address" = address, "computerid" = computer_id)
	if (address)
		query_content += " OR ip = :address:"
	if (computer_id)
		query_content += " OR computerid = :computerid:"

	var/DBQuery/query = dbcon.NewQuery(query_content)
	query.Execute(query_details)

	var/notes
	while (query.NextRow())
		notes += "\"[query.item[3]]\" - by [query.item[1]] on [query.item[2]]\n\n"

	if (!notes)
		return "[ckey] has no notes that could be retreived!"
	else
		var/content = "Displaying [ckey]'s notes:\n\n"
		content += "```\n"
		content += notes
		content += "```"
		return content
