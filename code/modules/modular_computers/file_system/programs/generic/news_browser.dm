/datum/computer_file/program/newsbrowser
	filename = "newsbrowser"
	filedesc = "NTNet/ExoNet News Browser"
	extended_desc = "This program may be used to view and download news articles from the network."
	program_icon_state = "generic"
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE

	nanomodule_path = /datum/nano_module/program/computer_newsbrowser
	var/datum/computer_file/data/news_article/loaded_article
	var/download_progress = 0
	var/download_netspeed = 0
	var/downloading = FALSE
	var/message = ""
	var/show_archived = FALSE
	color = LIGHT_COLOR_GREEN

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
	SSnanoui.update_uis(NM)

/datum/computer_file/program/newsbrowser/kill_program()
	..()
	requires_ntnet = TRUE
	loaded_article = null
	download_progress = 0
	downloading = FALSE
	show_archived = FALSE

/datum/computer_file/program/newsbrowser/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["PRG_openarticle"])
		. = TRUE
		if(downloading || loaded_article)
			return TRUE

		for(var/datum/computer_file/data/news_article/N in ntnet_global.available_news)
			if(N.uid == text2num(href_list["PRG_openarticle"]))
				loaded_article = N.clone()
				downloading = TRUE
				break
	if(href_list["PRG_reset"])
		. = TRUE
		downloading = FALSE
		download_progress = 0
		requires_ntnet = TRUE
		loaded_article = null
	if(href_list["PRG_clearmessage"])
		. = TRUE
		message = ""
	if(href_list["PRG_savearticle"])
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
	if(href_list["PRG_toggle_archived"])
		. = TRUE
		show_archived = !show_archived
	if(.)
		SSnanoui.update_uis(NM)


/datum/nano_module/program/computer_newsbrowser
	name = "NTNet/ExoNet News Browser"

/datum/nano_module/program/computer_newsbrowser/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)

	var/datum/computer_file/program/newsbrowser/PRG
	var/list/data = list()
	if(program)
		data = list("_PC" = program.get_header_data())
		PRG = program
	else
		return

	data["message"] = PRG.message
	if(PRG.loaded_article && !PRG.downloading) 	// Viewing an article.
		data["title"] = PRG.loaded_article.filename
		data["article"] = PRG.loaded_article.stored_data
	else if(PRG.downloading)					// Downloading an article.
		data["download_running"] = 1
		data["download_progress"] = PRG.download_progress
		data["download_maxprogress"] = PRG.loaded_article.size
		data["download_rate"] = PRG.download_netspeed
	else										// Viewing list of articles
		var/list/all_articles[0]
		for(var/datum/computer_file/data/news_article/F in ntnet_global.available_news)
			if(!PRG.show_archived && F.archived)
				continue
			all_articles.Add(list(list(
				"name" = F.filename,
				"size" = F.size,
				"uid" = F.uid,
				"archived" = F.archived
			)))
		data["all_articles"] = all_articles
		data["showing_archived"] = PRG.show_archived

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "news_browser.tmpl", "NTNet/ExoNet News Browser", 575, 700, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()