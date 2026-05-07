/datum/event/ccia_general_notice
	var/reporttitle = "CCIA Title"
	var/reportbody = "CCIA Message"
	var/announce = 0
	no_fake = 1

/datum/event/ccia_general_notice/start()
	..()

	if (!SSdbcore.Connect())
		LOG_DEBUG("CCIA Automatic General Notice - Could not establish database connection")
		return
	var/datum/db_query/query = SSdbcore.NewQuery("SELECT SQL_NO_CACHE title, message FROM ss13_ccia_general_notice_list WHERE deleted_at IS NULL AND automatic = 1 ORDER BY RAND() LIMIT 1;")
	query.Execute()
	if (query.NextRow())
		reporttitle = query.item[1]
		reportbody = query.item[2]
		reportbody += "\n\n- CCIAAMS, [commstation_name()]"
		announce = 1
	qdel(query)

/datum/event/ccia_general_notice/announce()
	if(announce)
		command_announcement.Announce("[reportbody]", reporttitle, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1, do_newscast=1, do_print=1)
