/*
 * A simple datum for storing notifications for dispaly.
 */
/datum/client_notification
	var/datum/preferences/owner = null

	var/list/note_wrapper = list()
	var/note_text = ""

	var/proc_src = null
	var/proc_name = ""
	var/proc_args = null

	var/persistent = 0

/datum/client_notification/New(var/datum/preferences/prefs, var/list/new_wrapper, var/new_text, var/new_persistence)
	if (!prefs)
		qdel(src)
		return

	if (!new_wrapper || new_wrapper.len != 2)
		qdel(src)
		return

	if (!new_text)
		qdel(src)
		return

	owner = prefs

	note_wrapper = new_wrapper
	note_text = new_text

	note_text = replacetextEx(note_text, ":src_ref", SOFTREF(src))
	note_wrapper[1] = replacetextEx(note_wrapper[1], ":src_ref", SOFTREF(src))

	if (new_persistence)
		persistent = new_persistence

/datum/client_notification/Destroy()
	if (owner)
		owner.notifications -= src
		owner = null

	return ..()

/*
 * Associates a callback to be executed whenever a notification is dismissed.
 */
/datum/client_notification/proc/tie_callback(var/dismiss_proc_src, var/dismiss_proc, var/dismiss_proc_args)
	if (!dismiss_proc_src || !dismiss_proc)
		return

	proc_src = dismiss_proc_src
	proc_name = dismiss_proc

	if (dismiss_proc_args)
		proc_args = dismiss_proc_args

/*
 * Returns the HTML required to display this alert.
 */
/datum/client_notification/proc/get_html()
	var/html = "<div class=\"row\">[note_wrapper[1]]"

	if (!persistent)
		html += "<a href=\"#\" class=\"close\" data-dismiss=\"alert\" aria-label=\"close\">&times;</a>"

	html += note_text
	html += "[note_wrapper[2]]</div>"

	return html

/*
 * Dismisses the notification, executing the proc that was set up as necessary.
 */
/datum/client_notification/proc/dismiss()
	if (proc_src && proc_name)
		call(proc_src, proc_name)(proc_args)

	if (!persistent)
		qdel(src)

/*
 * Adds a new notification datum for later processing.
 */
/datum/preferences/proc/new_notification(var/type, var/text, var/persistent, var/callback_src, var/callback_proc, var/callback_args)
	if (!text)
		return

	var/list/wrapper
	switch (type)
		if ("success")
			wrapper = list("<div class=\"alert alert-success\" notification=\":src_ref\">", "</div>")
		if ("info")
			wrapper = list("<div class=\"alert alert-info\" notification=\":src_ref\">", "</div>")
		if ("warning")
			wrapper = list("<div class=\"alert alert-warning\" notification=\":src_ref\">", "</div>")
		if ("danger")
			wrapper = list("<div class=\"alert alert-danger\" notification=\":src_ref\">", "</div>")
		else
			wrapper = list("<div class=\"alert alert-info\" notification=\":src_ref\">", "</div>")

	var/datum/client_notification/note = new(src, wrapper, text, persistent)

	if (callback_src && callback_proc)
		note.tie_callback(callback_src, callback_proc, callback_args)

	notifications += note

/*
 * Gathers all notifications relevant to the client.
 */
/datum/preferences/proc/gather_notifications(var/client/user)
	if (!user)
		return

	if (user.byond_version < config.client_warn_version)
		var/version_warn = ""
		version_warn += "<b>Your version of BYOND may be out of date!</b><br>"
		version_warn += config.client_warn_message
		version_warn += "Your version: [user.byond_version].<br>"
		version_warn += "Required version to remove this message: [config.client_warn_version] or later.<br>"
		version_warn += "Visit http://www.byond.com/download/ to get the latest version of BYOND."

		new_notification("danger", version_warn)

	if (custom_event_msg && custom_event_msg != "")
		var/custom_event_warn = "<b><center>A custom event is taking place!</center></b><br>"
		custom_event_warn += "<b>OOC Info:</b><br>[custom_event_msg]"

		new_notification("danger", custom_event_warn)

	if (lastchangelog != changelog_hash)
		winset(user, "rpane.changelog", "background-color=#eaeaea;font-style=bold")
		if (config.aggressive_changelog)
			new_notification("info", "You have unread updates in the changelog.", callback_src = user, callback_proc = "changes")
		else
			new_notification("info", "You have unread updates in the changelog.")

	if (config.sql_enabled)

		var/list/warnings = user.warnings_gather()
		if (warnings["unread"])
			new_notification("danger", warnings["unread"], 1)
		if (warnings["expired"])
			new_notification("info", warnings["expired"])

		var/linking = user.gather_linking_requests()
		if (linking)
			new_notification("info", linking, callback_src = user, callback_proc = "check_linking_requests")

		var/cciaa_actions = count_ccia_actions(user)
		if (cciaa_actions)
			new_notification("info", cciaa_actions)
		
		add_active_notifications(user)

/datum/preferences/proc/add_active_notifications(var/client/user)
	if(!user)
		return null

	if (!establish_db_connection(dbcon))
		error("Error initiatlizing database connection while getting notifications.")
		return null

	var/DBQuery/query = dbcon.NewQuery({"SELECT
		message, type, id
		FROM ss13_player_notifications
		WHERE acked_at IS NULL AND ckey = :ckey:
	"})
	query.Execute(list("ckey" = user.ckey))

	var/chat_notification=0
	var/panel_notification=0
	var/notification_count=0

	while(query.NextRow())
		var/autoack=0
		//Lets loop through the results
		switch(query.item[2])
			if("player_greeting")
				panel_notification=1
				notification_count++
			if("player_greeting_chat")
				chat_notification=1
				panel_notification=1
				notification_count++
			if("admin")
				discord_bot.send_to_admins("Server Notification for [user.ckey]: [query.item[1]]")
				post_webhook_event(WEBHOOK_ADMIN, list("title"="Server Notification for: [user.ckey]", "message"="Server Notification Triggered for [user.ckey]: [query.item[1]]"))
				//Immediately ack the notification
				autoack=1
			if("ccia")
				discord_bot.send_to_cciaa("Server Notification for [user.ckey]: [query.item[1]]")
				post_webhook_event(WEBHOOK_CCIAA_EMERGENCY_MESSAGE, list("title"="Server Notification for: [user.ckey]", "message"="Server Notification Triggered for [user.ckey]: [query.item[1]]"))
				//Immeidately ack the notification
				autoack=1
		if(autoack)
			var/DBQuery/ackquery = dbcon.NewQuery({"UPDATE ss13_player_notifications
				SET acked_by = 'autoack-server', acked_at = NOW()
				WHERE id = :id:
			"})
			ackquery.Execute(list("id" = query.item[3]))
	if(panel_notification)
		new_notification("warning","You have <b>[notification_count] unread notifications!</b> Click <a href='?JSlink=warnings;notification=:src_ref'>here</a> to review and acknowledge them!")
	if(chat_notification)
		to_chat(user,"<font color='red'><BIG><B>You have unacknowledged notifications.</B></BIG><br>Click <a href='?JSlink=warnings;notification=:src_ref'>here</a> to review and acknowledge them!</font>")

/*
 * Helper proc for getting a count of active CCIA actions against the player's characters.
 */
/datum/preferences/proc/count_ccia_actions(var/client/user)
	if (!user)
		return null

	if (!establish_db_connection(dbcon))
		error("Error initiatlizing database connection while counting CCIA actions.")
		return null

	var/DBQuery/prep_query = dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey = :ckey:")
	prep_query.Execute(list("ckey" = user.ckey))
	var/list/chars = list()

	while (prep_query.NextRow())
		chars += text2num(prep_query.item[1])

	if (!chars.len)
		return null

	var/DBQuery/query = dbcon.NewQuery({"SELECT
		COUNT(act_chr.action_id) AS action_count
	FROM ss13_ccia_action_char act_chr
	JOIN ss13_characters chr ON act_chr.char_id = chr.id
	JOIN ss13_ccia_actions act ON act_chr.action_id = act.id
	WHERE
		act_chr.char_id IN :char_id: AND
		(act.expires_at IS NULL OR act.expires_at >= CURRENT_DATE()) AND
		act.deleted_at IS NULL;"})
	query.Execute(list("char_id" = chars))

	if (query.NextRow())
		var/action_count = text2num(query.item[1])

		if (action_count == 0)
			return null

		var/string = "There are [action_count] active CCIA actions currently active against your character(s)."
		return string

	return null
