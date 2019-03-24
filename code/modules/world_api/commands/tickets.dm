/datum/topic_command/tickets_info
	name = "get_ticketsinfo"
	description = "Lists a general overview of tickets in the current round."

/datum/topic_command/tickets_info/run_command(queryparams)
	statuscode = 200
	response = "General tickets overview."

	var/list/ticket_data = list(
		"total" = tickets.len,
		"assigned" = 0,
		"unassigned" = 0,
		"closed" = 0
	)

	for (var/id in tickets)
		var/datum/ticket/ticket = tickets[id]
		switch (ticket.status)
			if (TICKET_OPEN)
				ticket_data["unassigned"]++
			if (TICKET_ASSIGNED)
				ticket_data["assigned"]++
			if (TICKET_CLOSED)
				ticket_data["closed"]++

	data = ticket_data
	return TRUE


/datum/topic_command/tickets_list
	name = "get_ticketslist"
	description = "Lists tickets in the current round."
	params = list(
		"only_open" = list("name"="only_open","desc"="If present, only opened tickets are listed.","req"=0,"type"="int")
	)

/datum/topic_command/tickets_list/run_command(queryparams)
	statuscode = 200
	response = "Tickets list."

	var/only_open = !!queryparams["only_open"]

	var/list/ticket_data = list()

	for (var/datum/ticket/ticket in tickets)
		if (!only_open || ticket.status == TICKET_CLOSED)
			continue

		ticket_data["[ticket.id]"] = serialize_ticket(ticket)

	data = ticket_data
	return TRUE

/datum/topic_command/tickets_list/proc/serialize_ticket(datum/ticket/ticket)
	return list(
		"id" = ticket.id,
		"owner" = ticket.owner,
		"status" = ticket.status,
		"closed_by" = ticket.closed_by,
		"opened_time" = ticket.opened_time,
		"assigned_admins" = ticket.assigned_admins,
		"message_count" = ticket.msgs.len
	)

/datum/topic_command/tickets_close
	name = "tickets_close"
	description = "Closes the listed ticket."
	params = list(
		"id" = list("name"="id","desc"="The ID of the ticket to be closed.","req"=1,"type"="int"),
		"admin" = list("name"="admin","desc"="Ckey of the admin who is closing the ticket.","req"=1,"type"="str")
	)

/datum/topic_command/tickets_close/run_command(queryparams)
	if (!queryparams["id"] || !isnum(queryparams["id"]))
		response = "No or invalid ID provided."
		statuscode = 400
		data = null
		return TRUE

	var/id = text2num(queryparams["id"])

	if (!queryparams["admin"] || !ckey(queryparams["admin"]))
		response = "No administrator ckey provided."
		statuscode = 400
		data = null
		return TRUE

	var/ckey = ckey(queryparams["admin"])

	var/datum/ticket/ticket = get_ticket_by_id(id)

	if (!ticket)
		response = "Ticket not found with the given ID."
		statuscode = 404
		data = null
		return TRUE

	if (ticket.close_remotely(ckey))
		response = "Ticket successfully closed."
		statuscode = 200
		return TRUE
	else
		response = "Unable to close the ticket."
		statuscode = 500
		return TRUE
