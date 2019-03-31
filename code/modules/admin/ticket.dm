var/global/list/tickets = list()
var/global/list/ticket_panels = list()

/datum/ticket
	var/owner
	var/list/assigned_admins = list()
	var/status = TICKET_OPEN
	var/list/msgs = list()
	var/closed_by
	var/id
	var/opened_time

	// Real time references for SQL based logging.
	var/opened_rt
	var/closed_rt
	var/response_time

	var/reminder_timer

/datum/ticket/New(var/owner)
	src.owner = owner
	tickets |= src
	id = tickets.len
	opened_time = world.time
	opened_rt = world.realtime

	if (config.ticket_reminder_period)
		reminder_timer = addtimer(CALLBACK(src, .proc/remind), config.ticket_reminder_period SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)

/datum/ticket/proc/broadcast_closure(closing_user)
	var/client/owner_client = client_by_ckey(owner)
	if(owner_client && owner_client.adminhelped == ADMINHELPED_DISCORD)
		discord_bot.send_to_admins("[key_name(owner_client)]'s request for help has been closed/deemed unnecessary by [closing_user].")
		owner_client.adminhelped = ADMINHELPED

/datum/ticket/proc/set_to_closed(closing_key)
	src.status = TICKET_CLOSED
	src.closed_by = closing_key
	src.closed_rt = world.realtime

	update_ticket_panels()

	if (reminder_timer)
		deltimer(reminder_timer)

	log_to_db()

/datum/ticket/proc/close(var/client/closed_by)
	if(!closed_by)
		return FALSE

	if(status == TICKET_CLOSED)
		return FALSE

	if(status == TICKET_ASSIGNED && !((closed_by.ckey in assigned_admins) || owner == closed_by.ckey) && alert(closed_by, "You are not assigned to this ticket. Are you sure you want to close it?",  "Close ticket?" , "Yes" , "No") != "Yes")
		return FALSE

	if(status == TICKET_ASSIGNED && !closed_by.holder) // non-admins can only close a ticket if no admin has taken it
		return FALSE

	broadcast_closure(key_name(closed_by))

	to_chat(client_by_ckey(src.owner), "<span class='notice'><b>Your ticket has been closed by [closed_by].</b></span>")
	message_admins("<span class='notice'><b>[src.owner]</b>'s ticket has been closed by <b>[key_name(closed_by)]</b>.</span>")

	set_to_closed(closed_by.ckey)

	return TRUE

/datum/ticket/proc/close_remotely(closing_user)
	if (!closing_user)
		return FALSE

	if (status != TICKET_OPEN)
		return FALSE

	broadcast_closure("[closing_user] (Remotely)")

	to_chat(client_by_ckey(src.owner), "<span class='notice'><b>Your ticket has been closed by [closing_user] (remotely).</b></span>")
	message_admins("<span class='notice'><b>[src.owner]</b>'s ticket has been closed by <b>[closing_user] (remotely)</b>.</span>")

	set_to_closed(closing_user)

	return TRUE

/datum/ticket/proc/take(var/client/assigned_admin)
	if(!assigned_admin)
		return

	if(status == TICKET_CLOSED)
		return

	if(assigned_admin.ckey == owner)
		return

	if(status == TICKET_ASSIGNED && ((assigned_admin.ckey in assigned_admins) || alert(assigned_admin, "This ticket is already assigned. Do you want to add yourself to the ticket?",  "Join ticket?" , "Yes" , "No") != "Yes"))
		return

	assigned_admins |= assigned_admin.ckey
	src.status = TICKET_ASSIGNED

	var/client/owner_client = client_by_ckey(src.owner)
	if(owner_client && owner_client.adminhelped == ADMINHELPED_DISCORD)
		discord_bot.send_to_admins("[key_name(owner_client)]'s request for help has been taken by [key_name(assigned_admin)].")
		owner_client.adminhelped = ADMINHELPED

	message_admins("<span class='danger'><b>[key_name(assigned_admin)]</b> has assigned themself to <b>[src.owner]'s</b> ticket.</span>")
	to_chat(owner_client, "<span class='notice'><b>[assigned_admin] has added themself to your ticket and should respond shortly. Thanks for your patience!</b></span>")
	to_chat(assigned_admin, get_options_bar(owner_client, 2, 1, 1))

	update_ticket_panels()

	return 1

/datum/ticket/proc/remind()
	if (status == TICKET_CLOSED)
		reminder_timer = null
		return

	var/admin_found = FALSE

	for (var/ckey in assigned_admins)
		var/client/C = client_by_ckey(ckey)
		if (C)
			admin_found = TRUE
			to_chat(C, "<span class='danger'><b>You have yet to close [owner]'s ticket!</b></span>")
			sound_to(C, 'sound/admin/bwoink.ogg')

	if (!admin_found)
		message_admins("<span class='danger'><b>[owner]'s ticket has yet to be closed!</b></span>")
		for(var/client/C in admins)
			if((C.holder.rights & (R_ADMIN|R_MOD)) && (C.prefs.toggles & SOUND_ADMINHELP))
				sound_to(C, 'sound/admin/bwoink.ogg')

	reminder_timer = addtimer(CALLBACK(src, .proc/remind), config.ticket_reminder_period SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)

/proc/get_open_ticket_by_ckey(var/owner)
	for(var/datum/ticket/ticket in tickets)
		if(ticket.owner == owner && (ticket.status == TICKET_OPEN || ticket.status == TICKET_ASSIGNED))
			return ticket // there should only be one open ticket by a client at a time, so no need to keep looking

/proc/get_ticket_by_id(id)
	for (var/datum/ticket/ticket in tickets)
		if (ticket.id == id)
			return ticket

	return null

/datum/ticket/proc/is_active()
	if(status != TICKET_ASSIGNED)
		return 0

	for(var/admin in assigned_admins)
		var/client/admin_client = client_by_ckey(admin)
		if(admin_client && !admin_client.is_afk())
			return 1

	return 0

/datum/ticket/proc/log_to_db()
	if (status != TICKET_CLOSED)
		return

	if (!establish_db_connection(dbcon))
		return

	var/DBQuery/Q = dbcon.NewQuery({"INSERT INTO ss13_tickets
		(game_id, message_count, admin_count, admin_list, opened_by, taken_by,
		 closed_by, response_delay, opened_at, closed_at)
	VALUES
		(:g_id:, :m_count:, :a_count:, :a_list:, :opened_by:, :taken_by:,
		 :closed_by:, :delay:, :opened_at:, :closed_at:)"})
	Q.Execute(list(
		"g_id" = game_id,
		"m_count" = length(msgs),
		"a_count" = length(assigned_admins),
		"a_list" = json_encode(assigned_admins),
		"opened_by" = owner,
		"taken_by" = length(assigned_admins) ? assigned_admins[1] : null,
		"closed_by" = closed_by,
		"delay" = response_time || -1,
		"opened_at" = SQLtime(opened_rt),
		"closed_at" = SQLtime(closed_rt)
	))

/datum/ticket/proc/append_message(m_from, m_to, msg)
	msgs += new /datum/ticket_msg(m_from, m_to, msg)

	if (!response_time && m_from != owner)
		response_time = round((world.time - opened_time) / 10)

	update_ticket_panels()

/datum/ticket_msg
	var/msg_from
	var/msg_to
	var/msg
	var/time_stamp

/datum/ticket_msg/New(var/msg_from, var/msg_to, var/msg)
	src.msg_from = msg_from
	src.msg_to = msg_to
	src.msg = msg
	src.time_stamp = time_stamp()

/datum/ticket_panel
	var/datum/ticket/open_ticket = null
	var/datum/browser/ticket_panel_window

/datum/ticket_panel/proc/get_dat()
	var/client/C = ticket_panel_window.user.client
	if(!C)
		return

	var/list/dat = list()

	var/valid_holder = check_rights(R_MOD|R_ADMIN, FALSE, ticket_panel_window.user)

	var/list/ticket_dat = list()
	for(var/id = tickets.len, id >= 1, id--)
		var/datum/ticket/ticket = tickets[id]
		if(valid_holder || ticket.owner == C.ckey)
			var/client/owner_client = client_by_ckey(ticket.owner)
			var/status = "Unknown status"
			var/color = "#6aa84f"
			switch(ticket.status)
				if(TICKET_OPEN)
					status = "Opened [round((world.time - ticket.opened_time) / (1 MINUTE))] minute\s ago, unassigned"
				if(TICKET_ASSIGNED)
					status = "Assigned to [english_list(ticket.assigned_admins, "no one")]"
					color = "#ffffff"
				if(TICKET_CLOSED)
					status = "Closed by [ticket.closed_by]"
					color = "#cc2222"
			ticket_dat += "<li style='padding-bottom:10px;color:[color]'>"
			if(open_ticket && open_ticket == ticket)
				ticket_dat += "<i>"
			ticket_dat += "Ticket #[id] - [ticket.owner] [owner_client ? "" : "(DC)"] - [status]<br /><a href='byond://?src=\ref[src];action=view;ticket=\ref[ticket]'>VIEW</a>"
			if(ticket.status)
				ticket_dat += " - <a href='byond://?src=\ref[src];action=pm;ticket=\ref[ticket]'>PM</a>"
				if(valid_holder)
					ticket_dat += " - <a href='byond://?src=\ref[src];action=take;ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>"
				if(ticket.status != TICKET_CLOSED && (valid_holder || ticket.status == TICKET_OPEN))
					ticket_dat += " - <a href='byond://?src=\ref[src];action=close;ticket=\ref[ticket]'>CLOSE</a>"
			if(valid_holder)
				var/ref_mob = ""
				if(owner_client)
					ref_mob = "\ref[owner_client.mob]"
				ticket_dat += " - <A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A> - <A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A> - <A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A> - <A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>[owner_client ? "- [admin_jump_link(owner_client.mob, src)]" : ""]"
			if(open_ticket && open_ticket == ticket)
				ticket_dat += "</i>"
			ticket_dat += "</li>"

	if(ticket_dat.len)
		dat += "<br /><div style='width:50%;float:left;'><p><b>Available tickets:</b></p><ul>[jointext(ticket_dat, null)]</ul></div>"

		if(open_ticket)
			dat += "<div style='width:50%;float:left;'><p><b>\[<a href='byond://?src=\ref[src];action=unview;'>X</a>\] Messages for ticket #[open_ticket.id]:</b></p>"

			var/list/msg_dat = list()
			for(var/datum/ticket_msg/msg in open_ticket.msgs)
				var/msg_to = msg.msg_to ? msg.msg_to : "Adminhelp"
				msg_dat += "<li>\[[msg.time_stamp]\] [msg.msg_from] -> [msg_to]: [C.holder ? generate_ahelp_key_words(C.mob, msg.msg) : msg.msg]</li>"

			if(msg_dat.len)
				dat += "<ul>[jointext(msg_dat, null)]</ul></div>"
			else
				dat += "<p>No messages to display.</p></div>"
	else
		dat += "<p>No tickets to display.</p>"
	dat += "</body></html>"

	return jointext(dat, null)

/datum/ticket_panel/Topic(href, href_list)
	..()

	if(href_list["close"])
		ticket_panels -= usr.client

	switch(href_list["action"])
		if("unview")
			open_ticket = null
			ticket_panel_window.set_content(get_dat())
			ticket_panel_window.update()

	var/datum/ticket/ticket = locate(href_list["ticket"])
	if(!istype(ticket))
		return

	switch(href_list["action"])
		if("view")
			open_ticket = ticket
			ticket_panel_window.set_content(get_dat())
			ticket_panel_window.update()
		if("take")
			ticket.take(usr.client)
		if("close")
			ticket.close(usr.client)
		if("pm")
			if(check_rights(R_MOD|R_ADMIN) && ticket.owner != usr.ckey)
				usr.client.cmd_admin_pm(client_by_ckey(ticket.owner), ticket = ticket)
			else if(ticket.status == TICKET_ASSIGNED)
				// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
				var/admin_found = 0
				for(var/admin in ticket.assigned_admins)
					var/client/admin_client = client_by_ckey(admin)
					if(admin_client)
						admin_found = 1
						usr.client.cmd_admin_pm(admin_client, ticket = ticket)
						break
				if(!admin_found)
					to_chat(usr, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
			else
				usr.client.adminhelp(input(usr,"", "adminhelp \"text\"") as text)

/client/verb/view_tickets()
	set name = "View Tickets"
	set category = "Admin"

	var/datum/ticket_panel/ticket_panel = new()
	ticket_panels[src] = ticket_panel
	ticket_panel.ticket_panel_window = new(src.mob, "ticketpanel", "Ticket Manager", 1024, 768, ticket_panel)

	ticket_panel.ticket_panel_window.set_content(ticket_panel.get_dat())
	ticket_panel.ticket_panel_window.open()

/proc/update_ticket_panels()
	for(var/client/C in ticket_panels)
		var/datum/ticket_panel/ticket_panel = ticket_panels[C]
		if(C.mob != ticket_panel.ticket_panel_window.user)
			C.view_tickets()
		else
			ticket_panel.ticket_panel_window.set_content(ticket_panel.get_dat())
			ticket_panel.ticket_panel_window.update()
