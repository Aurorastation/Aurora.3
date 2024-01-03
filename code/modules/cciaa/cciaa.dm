/datum/admins/proc/create_admin_fax()
	set name = "Send Admin Fax"
	set desc = "Send a fax from Central Command."
	set category = "Special Verbs"

	if (!check_rights(R_ADMIN|R_CCIAA|R_FUN))
		to_chat(usr, "<span class='warning'>You do not have enough powers to do this.</span>")
		return

	var/list/faxes = list()
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		faxes[F.department] = F

	if(!length(faxes))
		to_chat(usr, SPAN_WARNING("No valid fax machines located!"))
		return

	var/department = tgui_input_list(usr, "Pick a fax machine.", "Send Admin Fax", faxes)
	var/obj/machinery/photocopier/faxmachine/fax = faxes[department]
	if (!istype(fax))
		to_chat(usr, "<span class='warning'>Couldn't find a fax machine to send this to!</span>")
		return

	//todo: sanitize
	var/input = tgui_input_text(usr, "Please enter a message to reply to via secure connection. BBCode and HTML allowed.", \
				"Outgoing message from Centcomm", "", MAX_BOOK_MESSAGE_LEN, TRUE)
	if (!input)
		to_chat(usr, "<span class='warning'>Cancelled.</span>")
		return

	var/customname = tgui_input_text(usr, "Pick a title for the report.", "Title")
	if (!customname)
		to_chat(usr, "<span class='warning'>Cancelled.</span>")
		return

	var/announce = alert(usr, "Do you wish to announce the fax being sent?", "Announce Fax", "Yes", "No")
	if(announce == "Yes")
		announce = TRUE

	// Create the reply message
	var/obj/item/paper/P = new /obj/item/paper(null) //hopefully the null loc won't cause trouble for us
	P.set_content("[current_map.boss_name] - [customname]", input)

	// Stamps
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.stamped += /obj/item/stamp
	P.add_overlay(stampoverlay)
	P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

	if(fax.receivefax(P))
		if(announce == 1)
			command_announcement.Announce("A fax has been sent to the [department] fax machine.", "Fax Sent")
		to_chat(usr, "<span class='notice'>Message transmitted successfully.</span>")
		log_and_message_admins("sent a fax message to the [department] fax machine. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[fax.x];Y=[fax.y];Z=[fax.z]'>JMP</a>)")

		sent_faxes += P
	else
		to_chat(usr, "<span class='warning'>Message reply failed.</span>")
		qdel(P)
	return

/client/proc/check_fax_history()
	set name = "Check fax history"
	set desc = "Look up the faxes sent this round."
	set category = "Special Verbs"

	if (!check_rights(R_ADMIN|R_CCIAA|R_FUN))
		to_chat(usr, "<span class='warning'>You do not have enough powers to do this.</span>")
		return

	var/data = "<center><a href='?_src_=holder;CentcommFaxReply=1'>Send New Fax</a></center>"
	data += "<hr>"
	data += "<center><b>Received Faxes:</b></center><br>"

	if (arrived_faxes && arrived_faxes.len)
		for (var/obj/item/item in arrived_faxes)
			data += "[item.name] - <a href='?_src_=holder;AdminFaxView=\ref[item]'>view message</a><br>"
	else
		data += "<center>No faxes have been received.</center>"

	data += "<hr><center><b>Sent Faxes:</b></center><br>"

	if (sent_faxes && sent_faxes.len)
		for (var/obj/item/item in sent_faxes)
			data += "[item.name] - <a href='?_src_=holder;AdminFaxView=\ref[item]'>view message</a><br>"
	else
		data += "<center>No faxes have been sent out.</center>"

	usr << browse("<HTML><HEAD><TITLE>Centcomm Fax History</TITLE></HEAD><BODY>[data]</BODY></HTML>", "window=Centcomm Fax History")


/client/proc/launch_ccia_shuttle()
	set name = "Launch CCIA Shuttle"
	set desc = "Launches the CCIA Shuttle."
	set category = "Special Verbs"

	var/datum/shuttle/autodock/ferry/S = SSshuttle.shuttles["SCC Shuttle"]
	S.launch(usr)
