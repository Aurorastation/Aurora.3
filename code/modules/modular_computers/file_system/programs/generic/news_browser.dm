/datum/computer_file/program/newsbrowser
	filename = "newsbrowser"
	filedesc = "News Browser"
	extended_desc = "This program may be used to view and download news articles from the network."
	program_icon_state = "menu"
	program_key_icon_state = "black_key"
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_STATIONBOUND | PROGRAM_WRISTBOUND
	size = 2
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	color = LIGHT_COLOR_GREEN
	tgui_id = "NTOSNewsBrowser"

	var/datum/computer_file/data/news_article/loaded_article
	var/download_progress = 0
	var/download_netspeed = 0
	var/downloading = FALSE
	var/message = ""
	var/show_archived = FALSE

/datum/computer_file/program/newsbrowser/process_tick()
	if(!downloading)
		return
	download_netspeed = 0
	// Speed defines are found in misc.dm
	switch(ntnet_status)
		if(1)
			download_netspeed = NTNETSPEED_LOWSIGNAL
		if(2)
			download_netspeed = NTNETSPEED_HIGHSIGNAL
		if(3)
			download_netspeed = NTNETSPEED_ETHERNET
	download_progress += download_netspeed
	if(download_progress >= loaded_article.size)
		downloading = FALSE
		requires_ntnet = FALSE // Turn off NTNet requirement as we already loaded the file into local memory.

/datum/computer_file/program/newsbrowser/kill_program(forced)
	..()
	requires_ntnet = TRUE
	loaded_article = null
	download_progress = 0
	downloading = FALSE
	show_archived = FALSE

/datum/computer_file/program/newsbrowser/ui_data(mob/user)
	var/list/data = initial_data()

	data["message"] = message
	if(loaded_article && !downloading) 	// Viewing an article.
		data["title"] = loaded_article.filename
		data["article"] = loaded_article.stored_data
	else if(downloading)					// Downloading an article.
		data["download_running"] = TRUE
		data["download_progress"] = download_progress
		data["download_maxprogress"] = loaded_article.size
		data["download_rate"] = download_netspeed
	else										// Viewing list of articles
		data["showing_archived"] = show_archived

	return data

/datum/computer_file/program/newsbrowser/ui_static_data(mob/user)
	var/list/data = list()
	var/list/all_articles = list()
	for(var/datum/computer_file/data/news_article/F in GLOB.ntnet_global.available_news)
		if(!show_archived && F.archived)
			continue
		all_articles.Add(list(list(
			"name" = F.filename,
			"size" = F.size,
			"uid" = F.uid,
			"archived" = F.archived
		)))
	data["all_articles"] = all_articles
	return data

/datum/computer_file/program/newsbrowser/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	switch(action)
		if("PRG_openarticle")
			. = TRUE
			if(downloading || loaded_article)
				return TRUE

			for(var/datum/computer_file/data/news_article/N in GLOB.ntnet_global.available_news)
				if(N.uid == text2num(params["PRG_openarticle"]))
					loaded_article = N.clone()
					downloading = TRUE
					break

		if("PRG_reset")
			. = TRUE
			downloading = FALSE
			download_progress = 0
			requires_ntnet = TRUE
			loaded_article = null

		if("PRG_clearmessage")
			. = TRUE
			message = ""

		if("PRG_savearticle")
			. = TRUE
			if(downloading || !loaded_article)
				return

			var/savename = sanitize(input(usr, "Enter file name or leave blank to cancel:", "Save article", loaded_article.filename))
			if(!savename)
				return TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/data/news_article/N = loaded_article.clone()
			N.filename = savename
			HDD.store_file(N)

		if("PRG_toggle_archived")
			. = TRUE
			show_archived = !show_archived
			computer.update_static_data_for_all_viewers()
