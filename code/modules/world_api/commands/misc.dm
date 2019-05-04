// Gets the currently configured access levels
/datum/topic_command/get_access_levels
	name = "get_access_levels"
	description = "Gets the currently configured access levels."

/datum/topic_command/get_access_levels/run_command()
	var/list/access_levels = list()
	for(var/datum/access/acc in get_all_access_datums())
		access_levels.Add(list(acc.get_info_list()))

	data = access_levels
	statuscode = 200
	response = "Levels Sent"
	return TRUE

//Gets a overview of all polls (title, id, type)
/datum/topic_command/get_polls
	name = "get_polls"
	description = "Gets a overview of all polls."
	params = list(
		"current_only" = list("name"="current_only","desc"="Only get information about the current polls","type"="int","req"=0),
		"admin_only" = list("name"="admin_only","desc"="Only get information about the admin_only polls","type"="int","req"=0)
	)

/datum/topic_command/get_polls/run_command(queryparams)
	var/current_only = text2num(queryparams["current_only"])
	var/admin_only = text2num(queryparams["admin_only"])

	if(!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB-Connection unavailable"
		return TRUE

	var/list/polldata = list()

	var/DBQuery/select_query = dbcon.NewQuery("SELECT id, polltype, starttime, endtime, question, multiplechoiceoptions, adminonly FROM ss13_poll_question [(current_only || admin_only) ? "WHERE" : ""] [(admin_only ? "adminonly = true " : "")][(current_only && admin_only ? "AND " : "")][(current_only ? "Now() BETWEEN starttime AND endtime" : "")]")
	select_query.Execute()
	while(select_query.NextRow())
		polldata["[select_query.item[1]]"] = list(
			"id"=select_query.item[1],
			"polltype"=select_query.item[2],
			"starttime"=select_query.item[3],
			"endtime"=select_query.item[4],
			"question"=select_query.item[5],
			"multiplechoiceoptions"=select_query.item[6],
			"adminonly"=select_query.item[7]
			)

	statuscode = 200
	response = "Polldata sent"
	data = polldata
	return TRUE


// Gets infos about a poll
/datum/topic_command/get_poll_info
	name = "get_poll_info"
	description = "Gets Information about a poll."
	params = list(
		"poll_id" = list("name"="poll_id","desc"="The poll id that should be queried","type"="int","req"=1)
	)

/datum/topic_command/get_poll_info/run_command(queryparams)
	var/poll_id = text2num(queryparams["poll_id"])

	if(!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB-Connection unavailable"
		return TRUE

	//Get general data about the poll
	var/DBQuery/select_query = dbcon.NewQuery("SELECT id, polltype, starttime, endtime, question, multiplechoiceoptions, adminonly, publicresult, viewtoken FROM ss13_poll_question WHERE id = :poll_id:")
	select_query.Execute(list("poll_id"=poll_id))

	//Check if the poll exists
	if(!select_query.NextRow())
		statuscode = 404
		response = "The requested poll does not exist"
		data = null
		return TRUE
	var/list/poll_data = list(
		"id"=select_query.item[1],
		"polltype"=select_query.item[2],
		"starttime"=select_query.item[3],
		"endtime"=select_query.item[4],
		"question"=select_query.item[5],
		"multiplechoiceoptions"=select_query.item[6],
		"adminonly"=select_query.item[7],
		"publicresult"=select_query.item[8]
		)

	//Lets add a WI link to the poll, if we have the WI configured
	if(config.webint_url)
		poll_data["link"]="[config.webint_url]server/poll/[select_query.item[1]]/[select_query.item[9]]"

	var/list/result_data = list()

	/** Return different data based on the poll type: */
	//If we have a option or a multiple choice poll, return the number of options
	if(poll_data["polltype"] == "OPTION" || poll_data["polltype"] == "MULTICHOICE")
		var/DBQuery/result_query = dbcon.NewQuery({"SELECT ss13_poll_vote.optionid, ss13_poll_option.text, COUNT(*) as option_count
			FROM ss13_poll_vote
			LEFT JOIN ss13_poll_option ON ss13_poll_vote.optionid = ss13_poll_option.id
			WHERE ss13_poll_vote.pollid = :poll_id:
			GROUP BY ss13_poll_vote.optionid"})
		result_query.Execute(list("poll_id"=poll_id))

		while(result_query.NextRow())
			result_data["[result_query.item[1]]"] = list(
				"option_id"=result_query.item[1],
				"option_question"=result_query.item[2],
				"option_count"=result_query.item[3]
			)
		if(!length(result_data))
			statuscode = 500
			response = "No data returned by result query."
			data = null
			return TRUE

	//If we have a numval poll, return the options with the min, max, and average
	else if(poll_data["polltype"] == "NUMVAL")
		var/DBQuery/result_query = dbcon.NewQuery({"SELECT ss13_poll_vote.optionid, ss13_poll_option.text, ss13_poll_option.minval, ss13_poll_option.maxval, ss13_poll_option.descmin, ss13_poll_option.descmid, ss13_poll_option.descmax, AVG(rating) as option_rating_avg, MIN(rating) as option_rating_min, MAX(rating) as option_rating_max
		FROM ss13_poll_vote
		LEFT JOIN ss13_poll_option ON ss13_poll_vote.optionid = ss13_poll_option.id
		WHERE ss13_poll_vote.pollid = :poll_id:
		GROUP BY ss13_poll_vote.optionid"})
		result_query.Execute(list("poll_id"=poll_id))
		while(result_query.NextRow())
			result_data["[result_query.item[1]]"] = list(
				"option_id"=result_query.item[1],
				"option_question"=result_query.item[2],
				"option_minval"=result_query.item[3],
				"option_maxval"=result_query.item[4],
				"option_descmin"=result_query.item[5],
				"option_descmid"=result_query.item[6],
				"option_descmax"=result_query.item[7],
				"option_rating_min"=result_query.item[8],
				"option_rating_max"=result_query.item[9],
				"option_rating_avg"=result_query.item[10] //TODO: Expand that with MEDIAN once we upgrade mariadb
			)
		if(!length(result_data))
			statuscode = 500
			response = "No data returned by result query."
			data = null
			return TRUE

	//If we have a textpoll, return the number of answers
	else if(poll_data["polltype"] == "TEXT")
		var/DBQuery/result_query = dbcon.NewQuery({"SELECT COUNT(*) as count FROM ss13_poll_textreply WHERE pollid = :poll_id:"})
		result_query.Execute(list("poll_id"=poll_id))
		if(result_query.NextRow())
			result_data = list(
				"response_count"=result_query.item[1]
			)
		else
			statuscode = 500
			response = "No data returned by result query."
			data = null
			return TRUE
	else
		statuscode = 500
		response = "Unknown Poll Type"
		data = poll_data
		return TRUE


	poll_data["results"] = result_data

	statuscode = 200
	response = "Poll data fetched"
	data = poll_data
	return TRUE

// Authenticates client from external system
/datum/topic_command/auth_client
	name = "auth_client"
	description = "Authenticates client from external system."
	params = list(
		"key" = list("name"="key","desc"="Verfiied key for to be set for client","type"="str","req"=0),
		"clienttoken" = list("name"="clienttoken","desc"="Token for indetifying unique client","type"="str","req"=1),
	)

/datum/topic_command/auth_client/run_command(queryparams)
	if(!queryparams["clienttoken"] in unauthed)
		statuscode = 404
		response = "Client with such token is not found."
		return TRUE

	var/mob/abstract/unauthed/una = unauthed[queryparams["clienttoken"]]
	if(!istype(una) || !una.my_client)
		statuscode = 500
		response = "Somethnig went horribly wrong."
		return TRUE
	

	una.ClientLogin(queryparams["key"])
	statuscode = 200
	response = "Client has been authenticated sucessfully."
	data = list(
		"address" = una.my_client.address,
		"cid" = una.my_client.computer_id,
		"ckey" = una.my_client.ckey
	)