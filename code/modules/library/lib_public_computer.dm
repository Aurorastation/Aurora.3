/*
 * Library Public Computer
 */
/obj/machinery/librarypubliccomp
	name = "public library computer"
	desc = "A computer."
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/list/search_results = list()
	var/search_title = ""
	var/search_author = ""
	var/search_category = "Any"
	var/db_loading = FALSE
	var/db_error = FALSE

/obj/machinery/librarypubliccomp/attack_hand(var/mob/user)
	. = ..()
	if(.)
		return TRUE
	ui_interact(user)

/obj/machinery/librarypubliccomp/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LibraryPublicComputer", "Public Library Terminal", 650, 500)
		ui.open()

/obj/machinery/librarypubliccomp/ui_data(mob/user)
	var/list/data = list()
	data["search_title"] = search_title
	data["search_author"] = search_author
	data["search_category"] = search_category
	data["db_loading"] = db_loading
	data["db_error"] = db_error
	data["search_results"] = search_results
	return data

/obj/machinery/librarypubliccomp/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	add_fingerprint(usr)
	switch(action)
		if("search")
			if(!db_loading)
				search_title = sanitize(params["title"])
				search_author = sanitize(params["author"])
				var/new_category = params["category"]
				if(new_category in list("Any", "Fiction", "Non-Fiction", "Reference", "Religion"))
					search_category = new_category
				INVOKE_ASYNC(src, PROC_REF(async_search))
			. = TRUE

/obj/machinery/librarypubliccomp/proc/async_search()
	db_loading = TRUE
	db_error = FALSE
	search_results = list()
	SStgui.update_uis(src)

	var/sql
	var/list/query_args
	if(search_category != "Any")
		sql = "SELECT author, title, category, id FROM ss13_library WHERE author LIKE :author AND title LIKE :title AND category = :category"
		query_args = list(
			"title" = "%[search_title]%",
			"author" = "%[search_author]%",
			"category" = search_category
		)
	else
		sql = "SELECT author, title, category, id FROM ss13_library WHERE author LIKE :author AND title LIKE :title"
		query_args = list(
			"title" = "%[search_title]%",
			"author" = "%[search_author]%"
		)

	var/datum/db_query/query = SSdbcore.NewQuery(sql, query_args)
	if(!query.Execute())
		db_error = TRUE
		qdel(query)
		db_loading = FALSE
		SStgui.update_uis(src)
		return

	var/list/results = list()
	while(query.NextRow())
		results += list(list(
			"author" = query.item[1],
			"title" = query.item[2],
			"category" = query.item[3],
			"id" = text2num(query.item[4])
		))
	qdel(query)
	search_results = results
	db_loading = FALSE
	SStgui.update_uis(src)
