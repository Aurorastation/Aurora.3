//Get available Fax Machines
/datum/topic_command/get_faxmachines
	name = "get_faxmachines"
	description = "Gets all available fax machines"

/datum/topic_command/get_faxmachines/run_command(queryparams)
	var/list/faxlocations = list()

	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		faxlocations.Add(F.department)

	statuscode = 200
	response = "Fax machines fetched"
	data = faxlocations
	return TRUE

//Get Fax List
/datum/topic_command/get_faxlist
	name = "get_faxlist"
	description = "Gets the list of faxes sent / received"
	params = list(
		"faxtype" = list("name"="faxtype","desc"="Type of the faxes that should be retrieved","req"=1,"type"="slct","options"=list("sent","received"))
		)

/datum/topic_command/get_faxlist/run_command(queryparams)
	var/list/faxes = list()
	switch (queryparams["faxtype"])
		if ("received")
			faxes = arrived_faxes
		if ("sent")
			faxes = sent_faxes

	if (!faxes || !faxes.len)
		statuscode = 404
		response = "No faxes found"
		data = null
		return TRUE

	var/list/output = list()
	for (var/i = 1, i <= faxes.len, i++)
		var/obj/item/a = faxes[i]
		output += "[i]"
		output[i] = a.name ? a.name : "Untitled Fax"

	statuscode = 200
	response = "Fetched Fax List"
	data = output
	return TRUE

//Get Specific Fax
/datum/topic_command/get_fax
	name = "get_fax"
	description = "Gets a specific fax that has been sent or received"
	params = list(
		"faxtype" = list("name"="faxtype","desc"="Type of the faxes that should be retrieved","req"=1,"type"="slct","options"=list("sent","received")),
		"faxid" = list("name"="faxid","desc"="ID of the fax that should be retrieved","req"=1,"type"="int")
		)

/datum/topic_command/get_fax/run_command(queryparams)
	var/list/faxes = list()
	switch (queryparams["faxtype"])
		if ("received")
			faxes = arrived_faxes
		if ("sent")
			faxes = sent_faxes

	if (!faxes || !faxes.len)
		statuscode = 500
		response = "No faxes found!"
		data = null
		return TRUE

	var/fax_id = text2num(queryparams["faxid"])
	if (fax_id > faxes.len || fax_id < 1)
		statuscode = 404
		response = "Invalid Fax ID"
		data = null
		return TRUE

	var/output = list()
	if (istype(faxes[fax_id], /obj/item/paper))
		var/obj/item/paper/a = faxes[fax_id]
		output["title"] = a.name ? a.name : "Untitled Fax"

		var/content = replacetext(a.info, "<br>", "\n")
		content = strip_html_properly(content, 0)
		output["content"] = content

		statuscode = 200
		response = "Fax (Paper) with id [fax_id] retrieved"
		data = output
		return TRUE
	else if (istype(faxes[fax_id], /obj/item/photo))
		statuscode = 501
		response = "Fax is a Photo - Unable to send"
		data = null
		return TRUE
	else if (istype(faxes[fax_id], /obj/item/paper_bundle))
		var/obj/item/paper_bundle/b = faxes[fax_id]
		output["title"] = b.name ? b.name : "Untitled Paper Bundle"

		if (!b.pages || !b.pages.len)
			statuscode = 500
			response = "Fax Paper Bundle is empty - This should not happen"
			data = null
			return TRUE

		var/i = 0
		for (var/obj/item/paper/c in b.pages)
			i++
			var/content = replacetext(c.info, "<br>", "\n")
			content = strip_html_properly(content, 0)
			output["content"] += "Page [i]:\n[content]\n\n"

			statuscode = 200
			response = "Fax (PaperBundle) retrieved"
			data = output
			return TRUE

	statuscode = 500
	response = "Unable to recognize the fax type. Cannot send contents!"
	data = null
	return TRUE

//Send a Command Report
/datum/topic_command/send_commandreport
	name = "send_commandreport"
	description = "Sends a command report"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that sent the commandreport","req"=1,"type"="senderkey"),
		"title" = list("name"="title","desc"="The message title that should be sent, Defaults to NanoTrasen Update if not specified","req"=0,"type"="str"),
		"body" = list("name"="body","desc"="The message body that should be sent","req"=1,"type"="str"),
		"type" = list("name"="type","desc"="The type of the message that should be sent, Defaults to freeform","req"=0,"type"="slct","options"=list("freeform","ccia")),
		"sendername" = list("name"="sendername","desc"="IC Name of the sender for the CCIA Report, Defaults to CCIAAMS, \[Command-StationName\]","req"=0,"type"="str"),
		"announce" = list("name"="announce","desc"="If the report should be announce 1 -> Yes, 0 -> No, Defaults to 1","req"=0,"type"="int")
		)

/datum/topic_command/send_commandreport/run_command(queryparams)
	var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
	var/reporttitle = sanitizeSafe(queryparams["title"]) //Title of the report
	var/reportbody = nl2br(sanitize(queryparams["body"],encode=0,extra=0,max_length=0)) //Body of the report
	var/reporttype = queryparams["type"] //Type of the report: freeform / ccia / admin
	var/reportsender = sanitizeSafe(queryparams["sendername"]) //Name of the sender
	var/reportannounce = text2num(queryparams["announce"]) //Announce the contents report to the public: 1 / 0

	if(!reporttitle)
		reporttitle = "NanoTrasen Update"
	if(!reporttype)
		reporttype = "freeform"
	if(!reportannounce)
		reportannounce = 1

	//Set the report footer for CCIA Announcements
	if (reporttype == "ccia")
		if (reportsender)
			reportbody += "<br><br>- [reportsender], Central Command Internal Affairs Agent, [commstation_name()]"
		else
			reportbody += "<br><br>- CCIAAMS, [commstation_name()]"

	//Send the message to the communications consoles
	post_comm_message(reporttitle, reportbody)

	if(reportannounce == 1)
		command_announcement.Announce(reportbody, reporttitle, new_sound = 'sound/AI/commandreport.ogg', do_newscast = 1, msg_sanitized = 1);
	if(reportannounce == 0)
		to_world("<span class='alert'>New NanoTrasen Update available at all communication consoles.</span>")
		to_world(sound('sound/AI/commandreport.ogg'))


	log_admin("[senderkey] has created a command report via the api: [reportbody]",admin_key=senderkey)
	message_admins("[senderkey] has created a command report via the api", 1)

	statuscode = 200
	response = "Command Report sent"
	data = null
	return TRUE

//Send Fax
/datum/topic_command/send_fax
	name = "send_fax"
	description = "Sends a fax"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that sent the fax","req"=1,"type"="senderkey"),
		"title" = list("name"="title","desc"="The message title that should be sent","req"=1,"type"="str"),
		"body" = list("name"="body","desc"="The message body that should be sent","req"=1,"type"="str"),
		"target" = list("name"="target","desc"="The target faxmachines the fax should be sent to","req"=1,"type"="lst")
		)

/datum/topic_command/send_fax/run_command(queryparams)
	var/list/responselist = list()
	var/list/sendsuccess = list()
	var/list/targetlist = queryparams["target"] //Target locations where the fax should be sent to
	var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
	var/faxtitle = sanitizeSafe(queryparams["title"]) //Title of the report
	var/faxbody = sanitize(queryparams["body"],max_length=0) //Body of the report
	var/faxannounce = text2num(queryparams["announce"]) //Announce the contents report to the public: 0 - Dont announce, 1 - Announce, 2 - Only if pda not linked

	if(!targetlist || targetlist.len < 1)
		statuscode = 400
		response = "Parameter target not set"
		data = null
		return TRUE

	var/sendresult = 0
	var/notifyresult = 1

	//Send the fax
	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if (F.department in targetlist)
			sendresult = send_fax(F, faxtitle, faxbody, senderkey)
			if (sendresult == 1)
				sendsuccess.Add(F.department)
				if(!LAZYLEN(F.alert_pdas))
					notifyresult = 0
					responselist[F.department] = "notlinked"
				else
					responselist[F.department] = "success"
			else
				responselist[F.department] = "failed"

	//Announce that the fax has been sent
	if(faxannounce == 1 || (faxannounce==2 && notifyresult==0))
		if(sendsuccess.len < 1)
			command_announcement.Announce("A fax message from Central Command could not be delivered because all of the following fax machines are inoperational: <br>"+jointext(targetlist, ", "), "Fax Delivery Failure", new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
		else
			command_announcement.Announce("A fax message from Central Command has been sent to the following fax machines: <br>"+jointext(sendsuccess, ", "), "Fax Received", new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);

	log_admin("[senderkey] sent a fax via the API: : [faxbody]",admin_key=senderkey)
	message_admins("[senderkey] sent a fax via the API", 1)

	statuscode = 200
	response = "Fax sent"
	data = responselist
	return TRUE

/datum/topic_command/send_fax/proc/send_fax(var/obj/machinery/photocopier/faxmachine/F, title, body, senderkey)
	// Create the reply message
	var/obj/item/paper/P = new /obj/item/paper( null ) //hopefully the null loc won't cause trouble for us
	P.name = "[current_map.boss_name] - [title]"
	P.info = body
	P.update_icon()

	// Stamps
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.stamped += /obj/item/stamp
	P.add_overlay(stampoverlay)
	P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

	if(F.receivefax(P))
		log_and_message_admins("[senderkey] sent a fax message to the [F.department] fax machine via the api. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[F.x];Y=[F.y];Z=[F.z]'>JMP</a>)")
		sent_faxes += P
		return TRUE
	else
		qdel(P)
		return FALSE
