/var/datum/controller/subsystem/statistics/SSfeedback

/datum/controller/subsystem/statistics
	name = "Statistics & Inactivity"
	wait = 1 MINUTE
	flags = SS_NO_TICK_CHECK | SS_BACKGROUND
	priority = SS_PRIORITY_STATISTICS

	var/kicked_clients = 0

	var/list/messages = list()		//Stores messages of non-standard frequencies
	var/list/messages_admin = list()

	var/list/msg_common = list()
	var/list/msg_science = list()
	var/list/msg_command = list()
	var/list/msg_medical = list()
	var/list/msg_engineering = list()
	var/list/msg_security = list()
	var/list/msg_deathsquad = list()
	var/list/msg_syndicate = list()
	var/list/msg_raider = list()
	var/list/msg_burglar = list()
	var/list/msg_ninja = list()
	var/list/msg_bluespace = list()
	var/list/msg_cargo = list()
	var/list/msg_service = list()
	var/list/msg_ship = list()

	var/list/datum/statistic/simple_statistics = list()

	var/list/datum/feedback_variable/feedback = list()

	var/status_needs_update = FALSE

/datum/controller/subsystem/statistics/New()
	NEW_SS_GLOBAL(SSfeedback)

/datum/controller/subsystem/statistics/Initialize(timeofday)
	for (var/type in subtypesof(/datum/statistic) - list(/datum/statistic/numeric, /datum/statistic/grouped))
		var/datum/statistic/S = new type
		if (!S.name)
			qdel(S)
			continue

		simple_statistics[S.key] = S

	sortTim(simple_statistics, /proc/cmp_name_asc, TRUE)

/datum/controller/subsystem/statistics/fire()
	// Handle AFK.
	if(config.kick_inactive)
		var/inactivity_threshold = config.kick_inactive MINUTES
		for(var/client/C in clients)
			if(!isobserver(C.mob) && !C.holder)
				if(C.is_afk(inactivity_threshold))
					log_access("AFK: [key_name(C)]")
					to_chat_immediate(C, SPAN_WARNING("You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected."))
					qdel(C)
					kicked_clients++

	// Handle population polling.
	if (config.sql_enabled && config.sql_stats)
		var/admincount = staff.len
		var/playercount = 0
		for(var/mob/M in player_list)
			if(M.client)
				playercount += 1
		if(!establish_db_connection(dbcon))
			log_game("SQL ERROR during population polling. Failed to connect.")
		else
			var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
			var/DBQuery/query = dbcon.NewQuery("INSERT INTO `ss13_population` (`playercount`, `admincount`, `time`) VALUES ([playercount], [admincount], '[sqltime]')")
			if(!query.Execute())
				var/err = query.ErrorMsg()
				log_game("SQL ERROR during population polling. Error : \[[err]\]\n")

	if (status_needs_update)
		// Update world status.
		world.update_status()
		status_needs_update = FALSE

/datum/controller/subsystem/statistics/proc/update_status()
	status_needs_update = TRUE

/datum/controller/subsystem/statistics/Recover()
	src.messages = SSfeedback.messages
	src.messages_admin = SSfeedback.messages_admin

	src.msg_common = SSfeedback.msg_common
	src.msg_science = SSfeedback.msg_science
	src.msg_command = SSfeedback.msg_command
	src.msg_medical = SSfeedback.msg_medical
	src.msg_engineering = SSfeedback.msg_engineering
	src.msg_security = SSfeedback.msg_security
	src.msg_deathsquad = SSfeedback.msg_deathsquad
	src.msg_syndicate = SSfeedback.msg_syndicate
	src.msg_cargo = SSfeedback.msg_cargo
	src.msg_service = SSfeedback.msg_service

	src.feedback = SSfeedback.feedback

/datum/controller/subsystem/statistics/proc/find_feedback_datum(variable)
	for (var/datum/feedback_variable/FV in feedback)
		if (FV.get_variable() == variable)
			return FV

	var/datum/feedback_variable/FV = new(variable)
	feedback += FV
	return FV

/datum/controller/subsystem/statistics/proc/get_round_feedback()
	return feedback

/datum/controller/subsystem/statistics/proc/round_end_data_gathering()
	var/pda_msg_amt = 0
	var/rc_msg_amt = 0

	for(var/obj/machinery/telecomms/message_server/MS in telecomms_list)
		if(MS.pda_msgs.len > pda_msg_amt)
			pda_msg_amt = MS.pda_msgs.len
		if(MS.rc_msgs.len > rc_msg_amt)
			rc_msg_amt = MS.rc_msgs.len

	feedback_set_details("radio_usage","")

	feedback_add_details("radio_usage","COM-[msg_common.len]")
	feedback_add_details("radio_usage","SCI-[msg_science.len]")
	feedback_add_details("radio_usage","HEA-[msg_command.len]")
	feedback_add_details("radio_usage","MED-[msg_medical.len]")
	feedback_add_details("radio_usage","ENG-[msg_engineering.len]")
	feedback_add_details("radio_usage","SEC-[msg_security.len]")
	feedback_add_details("radio_usage","DTH-[msg_deathsquad.len]")
	feedback_add_details("radio_usage","SYN-[msg_syndicate.len]")
	feedback_add_details("radio_usage","CAR-[msg_cargo.len]")
	feedback_add_details("radio_usage","SRV-[msg_service.len]")
	feedback_add_details("radio_usage","OTH-[messages.len]")
	feedback_add_details("radio_usage","RC-[rc_msg_amt]")

	for (var/key in simple_statistics)
		var/datum/statistic/S = simple_statistics[key]
		if (S.write_to_db && S.key)
			S.write_to_database()

	feedback_set_details("round_end","[time2text(world.realtime)]") //This one MUST be the last one that gets set.

/datum/controller/subsystem/statistics/proc/print_round_end_message()
	var/list/dat = list()
	dat += "<h3>Round Statistics</h3>"
	for (var/statistic in simple_statistics)
		var/datum/statistic/S = simple_statistics[statistic]
		if (S.broadcast_at_roundend && S.has_value())
			dat += SPAN_NOTICE("<b>[S]:</b> [S.get_roundend_lines()]")

	to_chat(world, dat.Join("\n"))

// Called on world reboot.
/datum/controller/subsystem/statistics/Shutdown()
	if(!feedback)
		return

	if (!config.sql_enabled || !config.sql_stats)
		return

	round_end_data_gathering() //round_end time logging and some other data processing
	if(!establish_db_connection(dbcon))
		return

	for(var/datum/feedback_variable/FV in feedback)
		var/sql = "INSERT INTO ss13_feedback VALUES (null, Now(), \"[game_id]\", \"[FV.get_variable()]\", [FV.get_value()], \"[FV.get_details()]\")"
		var/DBQuery/query_insert = dbcon.NewQuery(sql)
		query_insert.Execute()

// Sanitize inputs to avoid SQL injection attacks
/proc/sql_sanitize_text(var/text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text

/proc/feedback_set(var/variable,var/value)
	if(!SSfeedback)
		return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = SSfeedback.find_feedback_datum(variable)

	if(!FV) return

	FV.set_value(value)

/proc/feedback_inc(var/variable,var/value)
	if(!SSfeedback) return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = SSfeedback.find_feedback_datum(variable)

	if(!FV) return

	FV.inc(value)

/proc/feedback_dec(var/variable,var/value)
	if(!SSfeedback) return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = SSfeedback.find_feedback_datum(variable)

	if(!FV) return

	FV.dec(value)

/proc/feedback_set_details(var/variable,var/details)
	if(!SSfeedback) return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = SSfeedback.find_feedback_datum(variable)

	if(!FV) return

	FV.set_details(details)

/proc/feedback_add_details(var/variable,var/details)
	if(!SSfeedback) return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = SSfeedback.find_feedback_datum(variable)

	if(!FV) return

	FV.add_details(details)

/proc/sql_report_death(var/mob/living/H)
	if(!config.sql_enabled || !config.sql_stats)
		return
	if(!H)
		return
	if(!istype(H, /mob/living/carbon/human) && !istype(H, /mob/living/silicon/robot))
		return
	if(!H.key || !H.mind)
		return

	var/area/placeofdeath = get_area(H)
	var/podname = placeofdeath ? "[placeofdeath]" : "Unknown area"

	if(!establish_db_connection(dbcon))
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO ss13_death (name, ckey, char_id, job, special, pod, tod, laname, lackey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES \
		(:name:, :ckey:, :char_id:, :job:, :special:, :pod:, :tod:, :laname:, :lackey:, :gender:, :bruteloss:, :fireloss:, :brainloss:, :oxyloss:, :coord:')")
		if(!query.Execute(list(
			"name"=H.real_name,
			"ckey"=H.ckey,
			"char_id"=H.character_id,
			"job"=H?.mind.assigned_role,
			"special"=H?.mind.special_role,
			"pod"=podname,
			"tod"=time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"),
			"laname"=H?.lastattacker.real_name,
			"lackey"=H?.lastattacker.ckey,
			"gender"=H.gender,
			"bruteloss"=H.getBruteLoss(),
			"fireloss"=H.getFireLoss(),
			"brainloss"=H.getBrainLoss(),
			"oxyloss"=H.getOxyLoss(),
			"coord"="[H.x], [H.y], [H.z]")
			))
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")

/datum/controller/subsystem/statistics/proc/IncrementSimpleStat(stat)
	. = TRUE
	var/datum/statistic/numeric/S = simple_statistics[stat]
	if (!S)
		return FALSE
	S.increment_value()

/datum/controller/subsystem/statistics/proc/IncrementGroupedStat(stat, key)
	. = TRUE
	var/datum/statistic/grouped/S = simple_statistics[stat]
	if (!S)
		return FALSE
	S.increment_value(key)

/datum/controller/subsystem/statistics/stat_entry()
	..("Kicked: [kicked_clients]")
