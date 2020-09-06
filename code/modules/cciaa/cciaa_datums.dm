/datum/ccia_report
	var/id
	var/report_date
	var/title
	var/public_topic
	var/internal_topic
	var/game_id
	var/status

/datum/ccia_report/New(var/id, var/report_date, var/title, var/public_topic=null, var/internal_topic=null, var/game_id=null, var/status="new")
	src.id = text2num(id)
	src.report_date = report_date
	src.title = title
	src.public_topic = public_topic
	src.internal_topic = internal_topic
	src.game_id = game_id
	src.status = status