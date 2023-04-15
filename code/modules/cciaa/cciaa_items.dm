//CCIAA's tape recorder
/obj/item/device/taperecorder/cciaa
	name = "Human Resources Recorder"
	desc = "A modified recorder used for interviews by human resources personnel around the galaxy."
	desc_extended = "This recorder is a modified version of a standard universal recorder. It features additional audit-proof records keeping, access controls and is tied to a central management system."
	desc_info = "This recorder records the fingerprints of the interviewee, to do so, interact with this recorder when asked."
	w_class = ITEMSIZE_TINY
	timestamp = list()	//This actually turns timestamp into a string later on

	//Redundent
	matter = list()
	recording = FALSE
	playing = FALSE
	emagged = FALSE
	time_recorded = FALSE
	play_sleep_seconds = FALSE
	stored_info = list()
	can_print = TRUE

	//Specific for Duty Officers
	var/paused = FALSE
	var/sLogFile = null
	var/last_file_loc = null

	var/antag_involvement = FALSE
	var/antag_involvement_text = null

	var/datum/ccia_report/selected_report = null
	var/interviewer_id = null
	var/interviewee_id = null
	var/interviewee_name = null
	var/date_string = null

/obj/item/device/taperecorder/cciaa/hear_talk(mob/living/M as mob, msg, var/verb="says")
	if(recording && !paused)
		timestamp = "[get_time()]"
		var/fmsg = "\[[timestamp]\] [M.name] [verb], \"[msg]\""
		sLogFile << fmsg
	return

/obj/item/device/taperecorder/cciaa/proc/get_time()
	return "[round(world.time / 36000)+12]:[(world.time / 600 % 60) < 10 ? add_zero(world.time / 600 % 60, 1) : world.time / 600 % 60]:[(world.time / 60 % 60) < 10 ? add_zero(world.time / 60 % 60, 1) : world.time / 60 % 60]"

/obj/item/device/taperecorder/cciaa/record()
	set name = "Start Recording"
	set category = "Recorder"

	if(!check_rights(R_CCIAA,FALSE))
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Unauthorised user.\".</span>")
		return
	if(use_check_and_message(usr))
		return
	if(recording)
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Already recording, Aborting\".</span>")
		return

	//If nothing has been done with the device yet
	if(!selected_report && !interviewee_id)
		if(config.sql_ccia_logs)
			//Get the active cases from the database and display them
			var/list/reports = list()
			var/DBQuery/report_query = dbcon.NewQuery("SELECT id, report_date, title, public_topic, internal_topic, game_id, status FROM ss13_ccia_reports WHERE status IN ('in progress', 'approved') AND deleted_at IS NULL")
			report_query.Execute()
			while(report_query.NextRow())
				CHECK_TICK
				var/datum/ccia_report/R = new(report_query.item[1], report_query.item[2], report_query.item[3], report_query.item[4], report_query.item[5], report_query.item[6], report_query.item[7])
				reports["[report_query.item[1]] - [report_query.item[2]] - [report_query.item[3]]"] = R

			var/selection = input(usr, "Select Report","Report Name") as null|anything in reports
			if(!selection)
				to_chat(usr, "<span class='notice'>The device beeps and flashes \"No data entered, Aborting\".</span>")
				return
			selected_report = reports[selection]
			to_chat(usr,"<span class='notice'>The device flashes \"Report [selected_report.title] selected, fingerprint of interviewee required\"</span>")
			if(selected_report.internal_topic)
				send_link(usr, selected_report.internal_topic)
		else
			var/report_name = input(usr, "Select Report Name","Report Name") as null|text
			if(!report_name || report_name == "")
				to_chat(usr, "<span class='notice'>The device beeps and flashes \"No data entered, Aborting\".</span>")
				return
			var/report_id = input(usr, "Select Report ID","Report ID") as null|text
			if(!report_id || report_id == "")
				to_chat(usr, "<span class='notice'>The device beeps and flashes \"No data entered, Aborting\".</span>")
				return
			selected_report = new(report_id, time2text(world.realtime, "YYYY_MM_DD"), report_name)
		var/mob/living/carbon/human/H = usr
		if(istype(H))
			interviewer_id = H.character_id
		return
	//If we are ready to record, but no interviewee is selected
	else if(selected_report && !interviewee_id)
		to_chat(usr,"<span class='notice'>The device beeps and flashes \"Fingerprint of interviewee required\"</span>")
		return
	//If the report has been selected and the person scanned their frinterprint
	else if(selected_report && interviewee_id)
		date_string = time2text(world.realtime, "YYYY_MM_DD")
		var/fileLoc = "data/dutylogs/[usr.ckey]/[date_string]-[selected_report.id]-[interviewee_id].log"
		var/fileName = "[date_string]-[selected_report.id]-[interviewee_id].log"
		if(fexists(fileLoc))
			var/safe = 0
			var/i = 1
			while(!safe)
				fileLoc = "data/dutylogs/[usr.ckey]/[date_string]-[selected_report.id]-[interviewee_id]-[i].log"
				if(!fexists(fileLoc))
					fileName = "[date_string]-[selected_report.id]-[interviewee_id]-[i].log"
					safe = 1
					break
				i++
		last_file_loc = fileLoc
		sLogFile = file(fileLoc)
		sLogFile << "[selected_report.id]-[interviewee_id]"
		sLogFile << "Case file: [selected_report.title]"
		sLogFile << "--------------------------------"
		sLogFile << "Date: [date_string]"
		sLogFile << "--------------------------------"
		sLogFile << "Interviewer: [usr.name]"
		sLogFile << "Interviewee: [interviewee_name]"
		sLogFile << "Antag involvement: [antag_involvement]"
		sLogFile << "Recorder started: [get_time()]"
		sLogFile << "--------------------------------"

		recording = 1
		icon_state = "taperecorderrecording"
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Writing to [fileName]\".</span>")

		return

/obj/item/device/taperecorder/cciaa/stop()
	set name = "Stop Recording"
	set category = "Recorder"

	if(use_check_and_message(usr))
		return
	if(!check_rights(R_CCIAA,FALSE))
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Unauthorised user.\".</span>")
		return
	if(!recording)
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Not recording, Aborting\".</span>")
		return

	recording = FALSE
	paused = FALSE
	sLogFile << "--------------------------------"
	sLogFile << "Recorder stopped: [get_time()]"
	sLogFile << "--------------------------------"

	var/obj/item/paper/P = get_last_transcript()
	P.forceMove(get_turf(src.loc))

	//If we have sql ccia logs enabled, then persist it here
	if(config.sql_ccia_logs && establish_db_connection(dbcon))
		//This query is split up into multiple parts due to the length limitations of byond.
		//To avoid this the text and the antag_involvement_text are saved separately
		var/DBQuery/save_log = dbcon.NewQuery("INSERT INTO ss13_ccia_reports_transcripts (id, report_id, character_id, interviewer, antag_involvement, text) VALUES (NULL, :report_id:, :character_id:, :interviewer:, :antag_involvement:, :text:)")
		save_log.Execute(list("report_id" = selected_report.id, "character_id" = interviewee_id, "interviewer" = usr.name, "antag_involvement" = antag_involvement, "text" = P.info))

		//Run the query to get the inserted id
		var/transcript_id = null
		var/DBQuery/tid = dbcon.NewQuery("SELECT LAST_INSERT_ID() AS log_id")
		tid.Execute()
		if (tid.NextRow())
			transcript_id = text2num(tid.item[1])

		if(tid)
			var/DBQuery/add_text = dbcon.NewQuery("UPDATE ss13_ccia_reports_transcripts SET text = :text: WHERE id = :id:")
			add_text.Execute(list("id" = transcript_id, "text" = P.info))
			var/DBQuery/add_antag_involvement_text = dbcon.NewQuery("UPDATE ss13_ccia_reports_transcripts SET antag_involvement_text = :antag_involvement_text: WHERE id = :id:")
			add_antag_involvement_text.Execute(list("id" = transcript_id, "antag_involvement_text" = antag_involvement_text))
		else
			message_cciaa("Transcript could not be saved correctly. TiD Missing")

		//Check if we need to update the status to review required
		if(antag_involvement && selected_report.status == "in progress")
			to_chat(usr, "<span class='notice'>The device beeps and flashes \"Liaison Review Required. Interviewee claimed antag involvement.\".</span>")
			var/DBQuery/update_db = dbcon.NewQuery("UPDATE ss13_ccia_reports SET status = 'review required' WHERE id = :id:")
			update_db.Execute(list("id" = selected_report.id))

	sLogFile = null
	selected_report = null
	interviewee_id = null
	interviewee_name = null
	date_string = null
	antag_involvement = null
	to_chat(usr, "<span class='notice'>The device beeps and flashes \"Recording stopped log saved.\".</span>")
	icon_state = "taperecorderidle"

	return

/obj/item/device/taperecorder/cciaa/verb/reset_recorder()
	set name = "Reset Recorder"
	set category = "Recorder"

	if(!check_rights(R_CCIAA,FALSE))
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Unauthorised user.\".</span>")
		return

	var/confirmation = alert("Do you want to reset the recorder without saving?", "Reset Recorder", "Yes", "No")
	if(confirmation != "Yes")
		return

	sLogFile = null
	selected_report = null
	interviewee_id = null
	interviewee_name = null
	date_string = null
	antag_involvement = null
	to_chat(usr, "<span class='notice'>The device beeps and flashes \"Recorder Reset.\".</span>")
	icon_state = "taperecorderidle"

/obj/item/device/taperecorder/cciaa/proc/get_last_transcript()
	var/list/lFile = file2list(last_file_loc)
	var/dat = ""
	var/firstLine = null
	for(var/line in lFile)
		if(!line)
			continue
		if(!firstLine)
			firstLine = "[line]"
			continue

		dat += "[line]<br>\n"

	var/obj/item/paper/P = new /obj/item/paper(src)
	var/pname = "[firstLine]"
	var/info = "[dat]"
	P.set_content_unsafe(pname, info)
	return P

/obj/item/device/taperecorder/cciaa/print_transcript()
	set name = "Print Transcript"
	set category = "Recorder"

	if(use_check_and_message(usr))
		return
	if(!check_rights(R_CCIAA,FALSE))
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Unauthorised user\".</span>")
		return
	if(recording)
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Device recording, Aborting\".</span>")
		return

	message_admins("[key_name_admin(usr)] accessed file: [last_file_loc]")
	var/obj/item/paper/P = get_last_transcript()
	P.forceMove(get_turf(src.loc))
	return

/obj/item/device/taperecorder/cciaa/verb/pause_recording()
	set name = "Pause Recording"
	set category = "Recorder"

	if(use_check_and_message(usr))
		return
	if(!check_rights(R_CCIAA,FALSE))
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Unauthorised user\".</span>")
		return
	if(!recording)
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Not recording, Aborting\".</span>")
		return

	if(!paused)
		sLogFile << "--------------------------------"
		sLogFile << "Recorder paused at: [get_time()]"
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Recording paused\".</span>")
		paused = TRUE
		icon_state = "taperecorderpause"
	else
		sLogFile << "Recorder resumed at: [get_time()]"
		sLogFile << "--------------------------------"
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Recording resumed\".</span>")
		paused = FALSE
		icon_state = "taperecorderrecording"
	return

/obj/item/device/taperecorder/cciaa/attack_self(mob/user)
	//If we are a ccia agent, then always go to the record function (to prompt for the report or start the recording)
	if(check_rights(R_CCIAA,FALSE) && !selected_report)
		record()
		return

	//Otherwise check if we already registered a interviewee
	if(interviewee_id)
		to_chat(user,"<span class='notice'>The device beeps and flashes \"A interviewee has already been associated with this interview\".</span>")
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.character_id)
			to_chat(user,"<span class='notice'>The device beeps and flashes \"Fingerprint is not recognized\".</span>")
			return

		if(H.character_id == interviewer_id)
			to_chat(user,"<span class='notice'>You need to pass the recorder to the interviewee to scan their fingerprint.</span>")
			return

		//Sync the intervieweee_id and interviewee_name
		interviewee_id = H.character_id
		interviewee_name = H.name

		//Show them the report they are interviewed about
		if(selected_report.public_topic)
			send_link(usr, selected_report.public_topic)

		//Ask them if there was antag involvement
		var/a = input(user, "Were your actions influenced by antagonists or OOC issues/concerns ?", "Antagonist involvement / OOC Issue") in list("yes","no")
		if(a == "yes")
			antag_involvement = TRUE
			antag_involvement_text = sanitizeSafe(input("Describe how your actions were influenced by the antagonists or OOC issues/concerns.", "Antag involvement / OOC Issue") as message|null)
			message_cciaa("CCIA Interview: [user] claimed their actions were influenced by antagonists or OOC issues.", R_CCIAA)
			message_cciaa("CCIA Interview: [antag_involvement_text]")
		else
			antag_involvement = FALSE

		to_chat(user,"<span class='notice'>The device beeps and flashes \"Fingerprint recognized, Employee: [interviewee_name], ID: [interviewee_id]\".</span>")
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)


	else
		to_chat(user,"<span class='notice'>The device beeps and flashes \"Unrecognized entity - Aborting\".</span>")
		return

//redundent for now
/obj/item/device/taperecorder/cciaa/clear_memory()
	set name = "Clear Memory"
	set category = null

	return

/obj/item/device/taperecorder/cciaa/playback_memory()
	set name = "Playback Memory"
	set category = null

	return

/obj/item/device/taperecorder/cciaa/explode()
	return

//ccia headset, only command and ert channel are on by default

/obj/item/device/radio/headset/ert/ccia
	name = "central command internal affairs radio headset"
	ks2type = /obj/item/device/encryptionkey/ccia

/obj/item/device/encryptionkey/ccia
	name = "\improper CCIA radio encryption key"
	channels = list("Response Team" = 1, "Science" = 0, "Command" = 1, "Medical" = 0, "Engineering" = 0, "Security" = 0, "Operations" = 0, "Service" = 0)

/obj/item/clothing/suit/storage/toggle/internalaffairs/cciaa
	name = "central command internal affairs jacket"

/obj/item/storage/lockbox/cciaa
	req_access = list(access_cent_ccia)
	name = "CCIA agent briefcase"
	desc = "A smart looking briefcase with a NT logo on the side"
	storage_slots = 8
	max_storage_space = 16

/obj/item/storage/lockbox/cciaa/fib
	name = "FIB agent briefcase"
	desc = "A smart looking ID locked briefcase."