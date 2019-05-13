/*
 * A file containing the admin commands for interfacing with the server_greeting datum.
 */
/client/proc/admin_edit_motd()
	set name = "Edit MotD"
	set category = "Server"

	if (!check_rights(R_SERVER))
		return

	var/new_message = input(usr, "Please edit the Message of the Day as necessary.", "Message of the Day", server_greeting.motd) as message

	if (!new_message)
		new_message = "<center>This is a palceholder. Pester your staff to change it!</center>"

	server_greeting.update_value("motd", new_message)
	message_admins("[ckey] has edited the message of the day:<br>[html_encode(new_message)]")

/client/proc/admin_memo_control(task in list("write", "delete"))
	set name = "Edit Memos"
	set category = "Server"

	if (!check_rights(R_ADMIN))
		return

	switch (task)
		if ("write")
			admin_memo_write()
		if ("delete")
			admin_memo_delete()

/client/proc/admin_memo_write()
	var/current_memo = ""
	if (server_greeting.memo_list.len && server_greeting.memo_list[ckey])
		current_memo = server_greeting.memo_list[ckey]

	var/new_memo = input(usr, "Please write your memo.", "Memo", current_memo) as message

	if (server_greeting.update_value("memo_write", list(ckey, new_memo)))
		to_chat(src, "<span class='notice'>Operation carried out successfully.</span>")
		message_admins("[ckey] wrote a new memo:<br>[html_encode(new_memo)]")
	else
		to_chat(src, "<span class='danger'>Error carrying out desired operation.</span>")

	return

/client/proc/admin_memo_delete()
	if (!server_greeting.memo_list.len)
		to_chat(src, "<span class='notice'>No memos are currently saved.</span>")
		return

	if (!check_rights(R_SERVER))
		if (!server_greeting.memo_list[ckey])
			to_chat(src, "<span class='warning'>You do not have a memo saved. Cancelling.</span>")

		else if (alert("Do you wish to delete your own memo, written on [server_greeting.memo_list[ckey]["date"]]?", "Choices", "Yes", "No") == "Yes")
			if (server_greeting.update_value("memo_delete", ckey))
				to_chat(src, "<span class='notice'>Operation carried out successfully.</span>")
				message_admins("[ckey] has deleted their own memo.")
			else
				to_chat(src, "<span class='danger'>Error carrying out desired operation.</span>")

		else
			to_chat(src, "<span class='notice'>Cancelled.</span>")

		return
	else
		var/input = input(usr, "Whose memo shall we delete?", "Remove Memo", null) as null|anything in server_greeting.memo_list

		if (!input)
			to_chat(src, "<span class='notice'>Cancelled.</span>")
			return

		if (server_greeting.update_value("memo_delete", input))
			to_chat(src, "<span class='notice'>Operation carried out successfully.</span>")
			message_admins("[ckey] has deleted the memo of [input].")
		else
			to_chat(src, "<span class='danger'>Error carrying out desired operation.</span>")

		return
