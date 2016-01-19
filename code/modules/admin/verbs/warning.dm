/*
 * DB based warning proc
 */

/client/proc/warn(warned_ckey)
	if (!check_rights(R_ADMIN|R_MOD))
		return

	if (!warned_ckey || !istext(warned_ckey))
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		usr << "<font color='red'>Error: warn(): Database Connection failed, reverting to legacy systems.</font>"
		usr.client.warn_legacy(warned_ckey)
		return

	var/warning_reason = input("Add Warning Reason. This is visible to the player.") as null|text

	if (!warning_reason)
		return

	var/warning_notes = input("Add additional informatoin. This is visible only to staff.") as null|text

	var/warning_severity
	switch (alert("Set warning severity", null, "Standard", "Severe"))
		if ("standard")
			warning_severity = 0
		if ("Severe")
			warning_severity = 1

	var/warned_computerid = null
	var/warned_ip = null
	var/client/C = directory[warned_ckey]
	if (C)
		warned_computerid = C.computer_id
		warned_ip = C.address
	else
		var/DBQuery/lookup_query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = :ckey")
		lookup_query.Execute(list(":ckey" = warned_ckey))

		if (lookup_query.NextRow())
			warned_ip = lookup_query.item[1]
			warned_computerid = lookup_query.item[2]

	var/DBQuery/insert_query = dbcon.NewQuery("INSERT INTO ss13_warnings (id, time, severity, reason, notes, ckey, computerid, ip, a_ckey, a_ip, a_computerid) VALUES (null, Now(), :warning_severity, :warning_reason, :warning_notes, :warned_ckey, :warned_computerid, :warned_ip, :a_ckey, :a_ip, :a_computerid)")
	insert_query.Execute(list(":warning_severity" = warning_severity, ":warning_reason" = warning_reason, ":warning_notes" = warning_notes, ":warned_ckey" = warned_ckey, ":warned_computerid" = warned_computerid, ":warned_ip" = warned_ip, ":a_ckey" = ckey, ":a_ip" = address, ":a_computerid" = computer_id))

	notes_add_sql(warned_ckey, "Warning added by [ckey], for: [warning_reason]. || Notes regarding the warning: [warning_notes].", src, warned_ip, warned_computerid)

	feedback_add_details("admin_verb", "WARN-DB")
	if (C)
		C << "<font color='red'><BIG><B>You have been warned by an administrator.</B></BIG><br>Click <a href='byond://?src=\ref[src];warnview=1'>here</a> to review and acknowledge them!</font>"

	message_admins("[key_name_admin(src)] has warned [warned_ckey] for: [warning_reason].")

/*
 * Legacy warning proc
 */

#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn_legacy(warned_ckey)
	if (!warned_ckey)
		usr << "<font color='red'>Error: warn_legacy(): No ckey passed!</font>"
		return

	var/datum/preferences/D
	var/client/C = directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = preferences_datums[warned_ckey]

	if(!D)
		src << "<font color='red'>Error: warn_legacy(): No such ckey found.</font>"
		return

	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			C << "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes."
			qdel(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)
		feedback_inc("ban_warn",1)
	else
		if(C)
			C << "<font color='red'><BIG><B>You have been warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>"
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-D.warns] strikes remaining.")

	feedback_add_details("admin_verb","WARN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#undef MAX_WARNS
#undef AUTOBANTIME

/*
 * A proc for a player to check their own warnings
 */

/client/verb/warnings_check()
	set name = "My warnings"
	set category = "OOC"
	set desc = "Display warnings issued to you."

	var/lcolor = "#ffeeee"	//light colour, severity = 0
	var/dcolor = "#ffaaaa"	//dark colour, severity = 1
	var/ecolor = "#e3e3e3"	//gray colour, expired = 1

	establish_db_connection()
	if (!dbcon.IsConnected())
		alert("Connection to the SQL database lost. Aborting. Please alert an Administrator or a member of staff.")
		return

	var/dat = "<div align='center'><h3>Warnings received</h3></div><br>"

	dat += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
	dat += "<tr>"
	dat += "<th width='20%'>ADMIN</th>"
	dat += "<th width='20%'>TIME ISSUED</th>"
	dat += "<th width='60%'>REASON</th>"
	dat += "</tr>"

	var/DBQuery/search_query = dbcon.NewQuery("SELECT id, time, severity, reason, a_ckey, acknowledged, expired FROM ss13_warnings WHERE visible = 1 AND (ckey = :ckey OR computerid = :computer_id OR ip = :address) ORDER BY time DESC;")
	search_query.Execute(list(":ckey" = ckey, ":computer_id" = computer_id, ":address" = address))

	while (search_query.NextRow())
		var/id = text2num(search_query.item[1])
		var/time = search_query.item[2]
		var/severity = text2num(search_query.item[3])
		var/reason = search_query.item[4]
		var/a_ckey = search_query.item[5]
		var/ackn = text2num(search_query.item[6])
		var/expired = text2num(search_query.item[7])

		var/bgcolor = lcolor

		if (severity)
			bgcolor = dcolor

		if (expired)
			bgcolor = ecolor

		dat += "<tr bgcolor='[bgcolor]' align='center'>"
		dat += "<td>[a_ckey]</td>"
		dat += "<td>[time]</td>"
		dat += "<td>[reason]</td>"
		dat += "</tr>"

		if (!ackn)
			dat += "<tr><td align='center' colspan='3'><b>(<a href='byond://?src=\ref[src];warnacknowledge=[id]'>Acknowledge Warning</a>)</b></td></tr>"
		else if (expired)
			dat += "<tr><td align='center' colspan='3'><b>Warning expired and no longer active!</b></td></tr>"
		else
			dat += "<tr><td align='center' colspan='3'><b>Warning acknowledged!</b></td></tr>"

		dat += "<tr>"
		dat += "<td colspan='5' bgcolor='white'>&nbsp</td>"
		dat += "</tr>"

	dat += "</table>"
	usr << browse(dat, "window=mywarnings;size=900x500")

/*
 * A proc for acknowledging a warning
 */

/client/proc/warnings_acknowledge(warning_id)
	if (!warning_id)
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		alert("Connection to SQL database failed while attempting to update your warning's status!")
		return

	var/DBQuery/query = dbcon.NewQuery("UPDATE ss13_warnings SET acknowledged = 1 WHERE id = :warning_id;")
	query.Execute(list(":warning_id" = warning_id))

	warnings_check()

/*
 * A proc to alert you if you have unacknowledged warnings.
 * Called in /client/New (client procs.dm)
 */

/client/proc/warnings_alert()
	var/count = 0
	var/count_expire = 0

	establish_db_connection()
	if (!dbcon.IsConnected())
		return

	var/list/client_details = list(":ckey" = ckey, ":computer_id" = computer_id, ":address" = address)

	var/DBQuery/expire_query = dbcon.NewQuery("SELECT id FROM ss13_warnings WHERE (acknowledged = 1 AND expired = 0 AND DATE_SUB(CURDATE(),INTERVAL 3 MONTH) > time) AND (ckey = :ckey OR computerid = :computer_id OR ip = :address)")
	expire_query.Execute(client_details)
	while (expire_query.NextRow())
		var/warning_id = text2num(expire_query.item[1])
		var/DBQuery/update_query = dbcon.NewQuery("UPDATE ss13_warnings SET expired = 1 WHERE id = :warning_id")
		update_query.Execute(list(":warning_id" = warning_id))
		count_expire++

	var/DBQuery/query = dbcon.NewQuery("SELECT id FROM ss13_warnings WHERE (visible = 1 AND acknowledged = 0 AND expired = 0) AND (ckey = :ckey OR computerid = :computer_id OR ip = :address)")
	query.Execute(client_details)
	while (query.NextRow())
		count++

	if (count)
		src << "<br>"
		src << "<font color=red><b>You have [count] unread [count > 1 ? "warnings" : "warning"]! Click <a href='byond://?src=\ref[src];warnview=1'>here</a> to review and acknowledge them!</b></font>"
	if (count_expire)
		src << "<br>"
		src << "<font color=blue><b>[count_expire] of your warnings expired.</b></font>"

/*
 * A proc for an admin/moderator to look up a member's warnings.
 */

/client/proc/warning_panel()
	set category = "Admin"
	set name = "Warnings Panel"
	set desc = "Look-up warnings assigned to players."

	if(!holder)
		return

	holder.warning_panel()

/datum/admins/proc/warning_panel(var/adminckey = null, var/playerckey = null)
	if (!check_rights(R_ADMIN|R_MOD))
		return

	var/lcolor = "#ffeeee"	//light colour, severity = 0
	var/dcolor = "#ffdddd"	//dark colour, severity = 1
	var/ecolor = "#e3e3e3"	//gray colour, expired = 1

	establish_db_connection()
	if (!dbcon.IsConnected())
		alert("Connection to the SQL database lost. Aborting. Please alert the database admin!")
		return

	var/dat = "<div align='center'><h3>Warning Look-up Panel</h3><br>"

	//Totally not stealing code from the DB_ban_panel

	dat += "<form method='GET' action='?src=\ref[src]'><b>Search:</b> "
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += "<b>Ckey:</b> <input type='text' name='warnsearchckey' value='[playerckey]'>"
	dat += "<b>Admin ckey:</b> <input type='text' name='warnsearchadmin' value='[adminckey]'>"
	dat += "<input type='submit' value='search'>"
	dat += "</form></div>"

	if (adminckey || playerckey)

		dat += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
		dat += "<tr>"
		dat += "<th width='10%'>ISSUED TO</th>"
		dat += "<th width='10%'>ISSUED BY</th>"
		dat += "<th width='10%'>TIME ISSUED</th>"
		dat += "<th width='60%'>REASON</th>"
		dat += "</tr>"

		var/list/query_details = list("a_ckey", "ckey")
		var/paramone = ""
		var/paramtwo = ""
		if(adminckey)
			paramone = "AND a_ckey = :a_ckey "
			query_details["a_ckey"] = adminckey
		if(playerckey)
			paramtwo = "AND ckey = :ckey "
			query_details["ckey"] = playerckey

		var/DBQuery/search_query = dbcon.NewQuery("SELECT id, time, severity, reason, notes, ckey, a_ckey, acknowledged, expired, edited, lasteditor, lasteditdate FROM ss13_warnings WHERE visible = 1 [paramone] [paramtwo] ORDER BY time DESC;")
		search_query.Execute(query_details, 1)

		while (search_query.NextRow())
			var/id = text2num(search_query.item[1])
			var/time = search_query.item[2]
			var/severity = text2num(search_query.item[3])
			var/reason = search_query.item[4]
			var/notes = search_query.item[5]
			var/ckey = search_query.item[6]
			var/a_ckey = search_query.item[7]
			var/ackn = text2num(search_query.item[8])
			var/expired = text2num(search_query.item[9])
			var/edited = text2num(search_query.item[10])

			var/bgcolor = lcolor

			if(severity)
				bgcolor = dcolor
			if(expired)
				bgcolor = ecolor

			dat += "<tr bgcolor='[bgcolor]' align='center'>"
			dat += "<td>[ckey]</td>"
			dat += "<td>[a_ckey]</td>"
			dat += "<td>[time]</td>"
			dat += "<td>[reason]</td>"
			dat += "</tr>"
			dat += "<tr>"
			dat += "<td align='center' colspan='5'><b>Staff Notes:</b> <cite>\"[notes]\"</cite></td>"
			dat += "</tr>"
			if(!ackn)
				dat += "<tr><td align='center' colspan='5'>Warning has not been acknolwedged by recipient.</td></tr>"
			if(expired)
				dat += "<tr><td align='center' colspan='5'>The warning has expired.</td></tr>"
			if(edited)
				var/lastEditor = search_query.item[11]
				var/lastEditDate = search_query.item[12]
				dat += "<tr><td align='center' colspan='5'><b>Warning last edited: [lastEditDate], by: [lastEditor].</b></td></tr>"
			dat += "<tr>"
			dat += "<td align='center' colspan='5'><b>Options:</b> "
			if(check_rights(R_ADMIN) || a_ckey == sanitizeSQL(ckey))
				dat += "<a href=\"byond://?src=\ref[src];dbwarningedit=editReason;dbwarningid=[id]\">Edit Reason</a> "
				dat += "<a href=\"byond://?src=\ref[src];dbwarningedit=editNotes;dbwarningid=[id]\">Edit Note</a> "
				dat += "<a href=\"byond://?src=\ref[src];dbwarningedit=delete;dbwarningid=[id]\">Delete Warning</a>"
			else
				dat += "You can only edit or delete notes that you have issued."
			dat += "</td>"
			dat += "</tr>"

			dat += "<tr>"
			dat += "<td colspan='5' bgcolor='white'>&nbsp</td>"
			dat += "</tr>"

		dat +="</table>"

	usr << browse(dat, "window=lookupwarns;size=900x500")
	feedback_add_details("admin_verb","WARN-LKUP")

/*
 * A proc for editing and deleting warnings issued
 */

/proc/warningsEdit(var/warning_id, var/warning_edit)
	if(!warning_id || !warning_edit)
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		alert("Connection to the SQL database lost. Aborting. Please alert the database admin!")
		return

	var/count = 0 //failsafe
	var/ckey
	var/reason
	var/notes
	var/list/query_details = list(":warning_id" = warning_id, ":a_ckey" = usr.ckey)

	var/DBQuery/initial_query = dbcon.NewQuery("SELECT ckey, reason, notes FROM ss13_warnings WHERE id = :warning_id")
	initial_query.Execute(query_details, 1)
	while (initial_query.NextRow())
		ckey = initial_query.item[1]
		reason = initial_query.item[2]
		notes = initial_query.item[3]
		count++

	if (count == 0)
		usr << "\red Database update failed due to a warning id not being present in the database."
		error("Database update failed due to a warning id not being present in the database.")
		return

	if (count > 1)
		usr << "\red Database update failed due to multiple warnings having the same ID. Contact the database admin."
		error("Database update failed due to multiple warnings having the same ID. Contact the database admin.")
		return

	switch (warning_edit)
		if ("delete")
			if(alert("Delete this warning?", "Delete?", "Yes", "No") == "Yes")
				var/DBQuery/deleteQuery = dbcon.NewQuery("UPDATE ss13_warnings SET visible = 0 WHERE id = :warning_id")
				deleteQuery.Execute(query_details)

				message_admins("\blue [key_name_admin(usr)] deleted one of [ckey]'s warnings.")
				log_admin("[key_name(usr)] deleted one of [ckey]'s warnings.")
			else
				usr << "Cancelled"
				return

		if ("editReason")
			query_details += ":new_reason"
			query_details[":new_reason"] = input("Edit this warning's reason.", "New Reason", reason, null) as null|text

			if(!query_details[":new_reason"] || query_details[":new_reason"] == reason)
				usr << "Cancelled"
				return

			var/DBQuery/reason_query = dbcon.NewQuery("UPDATE ss13_warnings SET reason = :new_reason, edited = 1, lasteditor = :a_ckey, lasteditdate = NOW() WHERE id = :warning_id")
			reason_query.Execute(query_details, 1)

			message_admins("\blue [key_name_admin(usr)] edited one of [ckey]'s warning reasons.")
			log_admin("[key_name(usr)] edited one of [ckey]'s warning reasons.")

		if("editNotes")
			query_details += ":new_notes"
			query_details[":new_notes"] = input("Edit this warning's notes.", "New Notes", notes, null) as null|text

			if(!query_details[":new_notes"] || query_details[":new_notes"] == notes)
				usr << "Cancelled"
				return

			var/DBQuery/notes_query = dbcon.NewQuery("UPDATE ss13_warnings SET notes = :new_notes, edited = 1, lasteditor = :a_ckey, lasteditdate = NOW() WHERE id = :warning_id")
			notes_query.Execute(query_details, 1)

			message_admins("\blue [key_name_admin(usr)] edited one of [ckey]'s warning notes.")
			log_admin("[key_name(usr)] edited one of [ckey]'s warning notes.")
