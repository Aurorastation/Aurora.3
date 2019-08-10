/client/proc/returntobody()
	set name = "Return to mob"
	set desc = "The Agent's work is done, return to your original mob"
	set category = "Special Verbs"

	if(!check_rights(0))		return

	if (!mob.mind || !(mob.mind.special_role in list("CCIA Agent", "ERT Commander")))
		verbs -= /client/proc/returntobody
		return

	if(!holder)		return

	var/mob/M = mob
	var/area/A = get_area(M)

	if(M.stat == DEAD)
		if(holder.original_mob)
			if(holder.original_mob.client)
				if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
					M.mind.special_role = null
					mob.ghostize(1)
					return
				else
					return
			holder.original_mob.key = key
			holder.original_mob = null
			return
		M.mind.special_role = null
		mob.ghostize(1)
		return

	if(!is_type_in_list(A,centcom_areas))
		to_chat(src, "<span class='warning'>You need to be back at central to do this.</span>")
		return

	if(holder.original_mob)
		if(holder.original_mob == M)
			verbs -= /client/proc/returntobody
			return

		if(holder.original_mob.client)
			if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
				M.mind.special_role = null
				mob.ghostize(0)
			else
				return
		else
			holder.original_mob.key = key

		holder.original_mob = null
	else
		if(mob.mind.admin_mob_placeholder)
			if(mob.mind.admin_mob_placeholder.client)
				if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
					M.mind.special_role = null
					mob.ghostize(0)
				else
					return
			else
				mob.mind.admin_mob_placeholder.key = key
			M.mind.admin_mob_placeholder = null
		else
			M.mind.special_role = null
			mob.ghostize(0)
	verbs -= /client/proc/returntobody
	qdel(M)

/proc/clear_cciaa_job(var/mob/living/carbon/human/M)
	addtimer(CALLBACK(GLOBAL_PROC, /proc/actual_clear_ccia_job, M), 9000)

/proc/actual_clear_ccia_job(mob/living/carbon/human/H)
	if (!H.client)
		var/oldjob = H.mind.assigned_role
		SSjobs.FreeRole(oldjob)

/datum/admins/proc/create_admin_fax(var/department in alldepartments)
	set name = "Send admin fax"
	set desc = "Send a fax from Central Command"
	set category = "Special Verbs"

	if (!check_rights(R_ADMIN|R_CCIAA|R_FUN))
		to_chat(usr, "<span class='warning'>You do not have enough powers to do this.</span>")
		return

	if (!department)
		to_chat(usr, "<span class='warning'>No target department specified!</span>")
		return

	var/obj/machinery/photocopier/faxmachine/fax = null

	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if (F.department == department)
			fax = F
			break

	if (!fax)
		to_chat(usr, "<span class='warning'>Couldn't find a fax machine to send this to!</span>")
		return

	//todo: sanitize
	var/input = input(usr, "Please enter a message to reply to via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Centcomm", "") as message|null
	if (!input)
		to_chat(usr, "<span class='warning'>Cancelled.</span>")
		return

	var/customname = input(usr, "Pick a title for the report", "Title") as text|null
	if (!customname)
		to_chat(usr, "<span class='warning'>Cancelled.</span>")
		return
	var/announce = alert(usr, "Do you wish to announce the fax being sent?", "Announce Fax", "Yes", "No")
	if(announce == "Yes")
		announce = 1

	// Create the reply message
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( null ) //hopefully the null loc won't cause trouble for us
	P.name = "[current_map.boss_name] - [customname]"
	P.info = input
	P.update_icon()

	// Stamps
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.stamped += /obj/item/weapon/stamp
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