//CCIAA's PDA.
/obj/item/device/pda/central
	default_cartridge = /obj/item/cartridge/captain
	icon_state = "pda-h"
	detonate = 0

//CCIAA's tape recorder
/obj/item/device/taperecorder/cciaa
	w_class = 1.0
	recording = 0
	timestamp = list()	//This actually turns timestamp into a string later on

	//Redundent
	matter = list()
	playing = 0
	emagged = 0
	timerecorded = 0
	playsleepseconds = 0
	storedinfo = list()
	canprint = 1

	//Specific for Duty Officers
	var/paused = FALSE
	var/sLogFile = null
	var/last_file_loc = null

	var/report_id = null
	var/report_name = null
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
	if(!report_id && !interviewee_id)
		if(config.sql_ccia_logs)
			//Get the active cases from the database and display them
			var/list/reports = list()
			var/DBQuery/report_query = dbcon.NewQuery("SELECT id, report_date, title FROM ss13_ccia_reports WHERE status = 'approved' AND deleted_at IS NULL")
			report_query.Execute()
			while(report_query.NextRow())
				CHECK_TICK
				reports["[report_query.item[2]] - [report_query.item[3]]"] = "[report_query.item[1]]"

			report_name = input(usr, "Select Report","Report Name") as null|anything in reports
			if(!report_name || report_name == "")
				to_chat(usr, "<span class='notice'>The device beeps and flashes \"No data entered, Aborting\".</span>")
				return
			report_id = reports[report_name]
			to_chat(usr,"<span class='notice'>The device flashes \"Report [report_name] selected, Finterprint of interviwee required\"</span>")
		else
			report_name = input(usr, "Select Report Name","Report Name") as null|text
			if(!report_name || report_name == "")
				to_chat(usr, "<span class='notice'>The device beeps and flashes \"No data entered, Aborting\".</span>")
				return
			report_id = input(usr, "Select Report ID","Report ID") as null|text
			if(!report_name || report_name == "")
				to_chat(usr, "<span class='notice'>The device beeps and flashes \"No data entered, Aborting\".</span>")
				return
		return
	//If we are ready to record, but no interviewee is selected
	else if(report_id && !interviewee_id)
		to_chat(usr,"<span class='notice'>The device beeps and flashes \"Fingerprint of interviewee required\"</span>")
		return
	//If the report has been selected and the person scanned their frinterprint
	else if(report_id && interviewee_id)
		date_string = time2text(world.realtime, "YYYY_MM_DD")
		var/fileLoc = "data/dutylogs/[usr.ckey]/[date_string]-[report_id]-[interviewee_id].log"
		var/fileName = "[date_string]-[report_id]-[interviewee_id].log"
		if(fexists(fileLoc))
			var/safe = 0
			var/i = 1
			while(!safe)
				fileLoc = "data/dutylogs/[usr.ckey]/[date_string]-[report_id]-[interviewee_id]-[i].log"
				if(!fexists(fileLoc))
					fileName = "[date_string]-[report_id]-[interviewee_id]-[i].log"
					safe = 1
					break
				i++
		last_file_loc = fileLoc
		sLogFile = file(fileLoc)
		sLogFile << "[report_id]-[interviewee_id]"
		sLogFile << "Case file: [report_name]"
		sLogFile << "--------------------------------"
		sLogFile << "Date: [date_string]"
		sLogFile << "--------------------------------"
		sLogFile << "Interviewer: [usr.name]"
		sLogFile << "Interviewee: [interviewee_name]"
		sLogFile << "Recorder started: [get_time()]"
		sLogFile << "--------------------------------"

		recording = 1
		icon_state = "taperecorderrecording"
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Writing to [fileName]\".</span>")

		return

/obj/item/device/taperecorder/cciaa/stop()
	set name = "Stop"
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
		var/DBQuery/save_log = dbcon.NewQuery("INSERT INTO ss13_ccia_reports_transcripts (id, report_id, character_id, interviewer, text) VALUES (NULL, :report_id:, :character_id:, :interviewer:, :text:)")
		save_log.Execute(list("report_id" = report_id, "character_id" = interviewee_id, "interviewer" = usr.name, "text" = P.info))

	sLogFile = null
	report_id = null
	report_name = null
	interviewee_id = null
	interviewee_name = null
	date_string = null
	to_chat(usr, "<span class='notice'>The device beeps and flashes \"Recording stopped log saved.\".</span>")
	icon_state = "taperecorderidle"
	return


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
	set name = "Pause"
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
	else
		sLogFile << "Recorder resumed at: [get_time()]"
		sLogFile << "--------------------------------"
		to_chat(usr, "<span class='notice'>The device beeps and flashes \"Recording resumed\".</span>")
		paused = FALSE
	return

/obj/item/device/taperecorder/cciaa/attack_self(mob/user)
	if(!report_id)
		record()
		return

	if(interviewee_id)
		to_chat(user,"<span class='notice'>The device beeps and flashes \"A interviewee has already been associated with this interview\".</span>")
		return
	
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.character_id)
			to_chat(user,"<span class='notice'>The device beeps and flashes \"Fingerprint is not recognized\".</span>")
			return
		else
			interviewee_id = H.character_id
			interviewee_name = H.name
			to_chat(user,"<span class='notice'>The device beeps and flashes \"Fingerprint recognized, Employee: [interviewee_name], ID: [interviewee_id]\".</span>")
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			return
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
	channels = list("Response Team" = 1, "Science" = 0, "Command" = 1, "Medical" = 0, "Engineering" = 0, "Security" = 0, "Supply" = 0, "Service" = 0)

/obj/item/clothing/suit/storage/toggle/internalaffairs/cciaa
	name = "central command internal affairs jacket"

/obj/item/storage/lockbox/cciaa
	req_access = list(access_cent_captain)
	name = "CCIA agent briefcase"
	desc = "A smart looking briefcase with a NT logo on the side"
	storage_slots = 8
	max_storage_space = 16

