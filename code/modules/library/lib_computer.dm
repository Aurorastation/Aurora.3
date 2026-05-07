/*
 * Borrowbook datum
 */
/// Tracks a single book checkout: what was borrowed, by whom, and when it is due.
/datum/borrowbook
	var/book_name
	var/mob_name
	var/get_date
	var/due_date

/*
 * Library Computer
 */
/obj/machinery/librarycomp
	name = "library computer"
	desc = "A computer."
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/upload_category = "Fiction"
	/// Active book checkouts
	var/list/datum/borrowbook/checkouts = list()
	/// Weakrefs to physical books currently in the library's physical inventory
	var/list/datum/weakref/inventory = list()
	/// How long a checkout lasts, in minutes
	var/checkout_period_minutes = 5
	var/bible_on_cooldown = FALSE
	var/is_public = FALSE
	var/buffer_book // Set by barcode scanner mode 1
	/// Title of the last successfully uploaded book, shown in the UI as confirmation
	var/last_uploaded_title
	var/datum/weakref/scanner_ref // Weakref to the nearest anchored book scanner
	/// Current page of archive results (one page = 20 entries)
	var/list/archive_results = list()
	var/archive_loading = FALSE
	var/archive_error = FALSE
	var/archive_page = 1
	/// Total number of archive entries matching the current search
	var/archive_total = 0
	var/archive_search = ""
	var/archive_sort_field = "title"
	var/archive_sort_dir = "asc"

/obj/machinery/librarycomp/attack_hand(var/mob/user)
	. = ..()
	if(.)
		return TRUE
	ui_interact(user)

/obj/machinery/librarycomp/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/title = is_public ? "[SSatlas.current_map.station_name] Library" : "[SSatlas.current_map.station_name] Library Management"
		ui = new(user, src, "LibraryComputer", title, 750, 600)
		ui.open()

/obj/machinery/librarycomp/ui_data(mob/user)
	var/obj/machinery/libraryscanner/scanner = scanner_ref?.resolve()
	if(!scanner)
		scanner_ref = null
		for(var/obj/machinery/libraryscanner/nearby_scanner in range(9))
			if(nearby_scanner.anchored)
				scanner_ref = WEAKREF(nearby_scanner)
				scanner = nearby_scanner
				break

	var/list/data = list()
	data["is_public"] = is_public
	data["is_emagged"] = emagged
	data["bible_on_cooldown"] = bible_on_cooldown
	data["checkout_period_minutes"] = checkout_period_minutes
	data["archive_loading"] = archive_loading
	data["archive_error"] = archive_error
	data["archive_results"] = archive_results
	data["archive_page"] = archive_page
	data["archive_total"] = archive_total
	data["archive_search"] = archive_search
	data["archive_sort_field"] = archive_sort_field
	data["archive_sort_dir"] = archive_sort_dir
	data["archive_page_size"] = 20
	data["upload_category"] = upload_category
	data["buffer_book"] = buffer_book
	data["last_uploaded_title"] = last_uploaded_title

	var/list/inv = list()
	var/list/stale = list()
	for(var/datum/weakref/wref in inventory)
		var/obj/item/book/book = wref.resolve()
		if(book)
			inv += list(list("ref" = REF(book), "name" = book.name))
		else
			stale += wref
	inventory -= stale
	data["inventory"] = inv

	var/list/co = list()
	for(var/datum/borrowbook/checkout in checkouts)
		var/taken_minutes = round((world.time - checkout.get_date) / 1 MINUTES)
		var/due_raw = (checkout.due_date - world.time) / 1 MINUTES
		co += list(list(
			"ref" = REF(checkout),
			"book_name" = checkout.book_name,
			"mob_name" = checkout.mob_name,
			"taken_minutes" = taken_minutes,
			"due_minutes" = abs(round(due_raw)),
			"overdue" = (due_raw <= 0)
		))
	data["checkouts"] = co

	var/list/scanner_data = list()
	scanner_data["found"] = !!(scanner?.anchored)
	scanner_data["title"] = scanner?.cache ? scanner.cache.name : null
	scanner_data["author"] = scanner?.cache ? (scanner.cache.author ? scanner.cache.author : "Anonymous") : null
	data["scanner"] = scanner_data

	var/list/crew_names = list()
	var/list/manifest = SSrecords.get_manifest_list()
	for(var/dept in manifest)
		for(var/list/entry in manifest[dept])
			if(!entry["ooc_role"] && entry["name"])
				crew_names |= entry["name"]
	data["crew_names"] = crew_names

	return data

/obj/machinery/librarycomp/emag_act(var/remaining_charges, var/mob/user)
	if(src.density && !src.emagged)
		src.emagged = TRUE
		return 1

/obj/machinery/librarycomp/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/barcode_scanner = attacking_item
		barcode_scanner.computer_ref = REF(src)
		to_chat(user, "[barcode_scanner]'s associated machine has been set to [src].")
		for(var/mob/hearer in hearers(src))
			hearer.show_message("[src] lets out a low, short blip.", 2)
	else
		..()

/obj/machinery/librarycomp/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	add_fingerprint(usr)
	switch(action)
		if("print_bible")
			if(!bible_on_cooldown)
				var/obj/item/storage/bible/bible = new /obj/item/storage/bible(src.loc)
				bible.verbs += /obj/item/storage/bible/verb/Set_Religion
				var/rand_book = "book" + pick("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16")
				bible.icon_state = rand_book
				bible.item_state = rand_book
				bible.name = "religious book"
				bible_on_cooldown = TRUE
				addtimer(CALLBACK(src, PROC_REF(end_bible_cooldown)), 6 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)
			. = TRUE
		if("arcane_confirm")
			if(emagged && !bible_on_cooldown)
				new /obj/item/book/tome(get_turf(src))
				to_chat(usr, SPAN_WARNING("Your sanity barely endures the seconds spent in the vault's browsing window. The only thing to remind you of this when you stop browsing is a dusty old tome sitting on the desk. You don't really remember printing it."))
				usr.visible_message(
					SPAN_NOTICE("\The [usr] stares at the blank screen for a few moments, [usr.get_pronoun("his")] expression frozen in fear. When [usr.get_pronoun("he")] finally awakens from it, [usr.get_pronoun("he")] looks a lot older."),
					range = 2)
				bible_on_cooldown = TRUE
				addtimer(CALLBACK(src, PROC_REF(end_bible_cooldown)), 6 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)
			. = TRUE
		if("increase_checkout_period")
			checkout_period_minutes += 1
			. = TRUE
		if("decrease_checkout_period")
			checkout_period_minutes = max(1, checkout_period_minutes - 1)
			. = TRUE
		if("checkout_book")
			var/book_title = sanitizeSafe(params["book_title"])
			var/recipient = sanitize(params["recipient"], MAX_NAME_LEN)
			if(book_title && recipient)
				var/datum/borrowbook/new_checkout = new /datum/borrowbook
				new_checkout.book_name = book_title
				new_checkout.mob_name = recipient
				new_checkout.get_date = world.time
				new_checkout.due_date = world.time + (checkout_period_minutes * 1 MINUTES)
				checkouts.Add(new_checkout)
			. = TRUE
		if("checkin_book")
			var/datum/borrowbook/checkout = locate(params["ref"])
			if(checkout && (checkout in checkouts))
				checkouts.Remove(checkout)
			. = TRUE
		if("delete_inventory_book")
			var/obj/item/book/book = locate(params["ref"])
			if(book && !QDELETED(book))
				inventory.Remove(WEAKREF(book))
			. = TRUE
		if("set_upload_category")
			var/new_category = params["value"]
			if(new_category in list("Fiction", "Non-Fiction", "Reference", "Religion"))
				upload_category = new_category
			. = TRUE
		if("set_upload_author")
			var/obj/machinery/libraryscanner/sc = get_scanner()
			if(sc?.cache)
				sc.cache.author = sanitize(params["value"])
			. = TRUE
		if("clear_scanner_cache")
			var/obj/machinery/libraryscanner/sc = get_scanner()
			if(sc)
				sc.cache = null
				SStgui.update_uis(sc)
				last_uploaded_title = null
			. = TRUE
		if("upload_book")
			var/obj/machinery/libraryscanner/sc = get_scanner()
			if(!is_public && sc?.anchored && sc.cache)
				if(sc.cache.unique)
					to_chat(usr, SPAN_WARNING("This book has been rejected from the database."))
				else
					INVOKE_ASYNC(src, PROC_REF(async_upload_book), usr)
			. = TRUE
		if("fetch_archive")
			if(!archive_loading)
				archive_page = 1
				archive_search = ""
				INVOKE_ASYNC(src, PROC_REF(async_fetch_archive))
			. = TRUE
		if("archive_go_to_page")
			var/new_page = text2num(params["page"])
			if(isnum(new_page) && new_page >= 1 && !archive_loading)
				archive_page = round(new_page)
				INVOKE_ASYNC(src, PROC_REF(async_fetch_archive))
			. = TRUE
		if("archive_set_search")
			if(!archive_loading)
				archive_search = sanitize(params["query"])
				archive_page = 1
				INVOKE_ASYNC(src, PROC_REF(async_fetch_archive))
			. = TRUE
		if("archive_set_sort")
			var/field = params["field"]
			if(field in list("title", "author", "category"))
				var/direction = params["dir"]
				archive_sort_field = field
				archive_sort_dir = (direction == "desc") ? "desc" : "asc"
				archive_page = 1
				if(!archive_loading)
					INVOKE_ASYNC(src, PROC_REF(async_fetch_archive))
			. = TRUE
		if("order_book")
			var/book_id = text2num(params["id"])
			if(isnum(book_id) && book_id > 0)
				if(!bible_on_cooldown)
					INVOKE_ASYNC(src, PROC_REF(async_order_book), book_id)
				else
					visible_message("\The [src]'s monitor flashes: \"Printer unavailable. Please allow a short time before attempting to print.\"")
			. = TRUE
		if("extend_checkout")
			var/datum/borrowbook/checkout = locate(params["ref"])
			if(checkout && (checkout in checkouts))
				checkout.due_date += checkout_period_minutes * 1 MINUTES
			. = TRUE
		if("print_inventory")
			var/dat = "<B>Library Inventory</B><BR><BR>"
			var/printed = 0
			for(var/datum/weakref/wref in inventory)
				var/obj/item/book/book = wref.resolve()
				if(book)
					dat += "- [book.name]<BR>"
					printed++
			if(!printed)
				dat += "No books in inventory.<BR>"
			var/obj/item/paper/printout = new /obj/item/paper(src.loc)
			printout.info = dat
			printout.name = "paper- 'Library Inventory'"
			. = TRUE
		if("print_checkouts")
			var/dat = "<B>Active Checkouts</B><BR><BR>"
			if(checkouts.len)
				for(var/datum/borrowbook/checkout in checkouts)
					var/taken_minutes = round((world.time - checkout.get_date) / 1 MINUTES)
					var/due_raw = (checkout.due_date - world.time) / 1 MINUTES
					var/status = due_raw <= 0 ? "OVERDUE by [abs(round(due_raw))] min" : "due in [round(due_raw)] min"
					dat += "- <B>[checkout.book_name]</B> ([checkout.mob_name]) — taken [taken_minutes] min ago, [status]<BR>"
			else
				dat += "No books currently checked out.<BR>"
			var/obj/item/paper/printout = new /obj/item/paper(src.loc)
			printout.info = dat
			printout.name = "paper- 'Active Checkouts'"
			. = TRUE

/obj/machinery/librarycomp/proc/end_bible_cooldown()
	bible_on_cooldown = FALSE
	SStgui.update_uis(src)

/obj/machinery/librarycomp/proc/get_scanner()
	var/obj/machinery/libraryscanner/scanner = scanner_ref?.resolve()
	if(!scanner)
		scanner_ref = null
		for(var/obj/machinery/libraryscanner/nearby_scanner in range(9))
			if(nearby_scanner.anchored)
				scanner_ref = WEAKREF(nearby_scanner)
				return nearby_scanner
		return null
	return scanner

/obj/machinery/librarycomp/proc/async_fetch_archive()
	archive_loading = TRUE
	archive_error = FALSE
	archive_total = 0
	archive_results = list()
	SStgui.update_uis(src)

	// Build WHERE clause — keep % wildcards out of params via CONCAT so
	// the param value is the raw search term without special characters
	var/sql_where = ""
	var/list/count_args
	var/list/select_args
	if(length(archive_search))
		sql_where = "WHERE (title LIKE CONCAT('%', :search, '%') OR author LIKE CONCAT('%', :search, '%') OR category LIKE CONCAT('%', :search, '%'))"
		count_args = list("search" = archive_search)
		select_args = list("search" = archive_search)
	else
		count_args = list()
		select_args = list()

	// Validate sort field and direction before interpolating into SQL
	var/safe_field
	switch(archive_sort_field)
		if("author")   safe_field = "author"
		if("category") safe_field = "category"
		else           safe_field = "title"
	var/safe_dir = (archive_sort_dir == "desc") ? "DESC" : "ASC"

	// COUNT query to get total matching entries
	var/datum/db_query/count_query = SSdbcore.NewQuery(
		"SELECT COUNT(*) FROM ss13_library [sql_where]",
		count_args)
	if(!count_query.Execute())
		archive_error = TRUE
		qdel(count_query)
		archive_loading = FALSE
		SStgui.update_uis(src)
		return
	archive_total = count_query.NextRow() ? text2num(count_query.item[1]) : 0
	qdel(count_query)

	// Clamp page to valid range now that we know the total
	var/total_pages = max(1, CEILING(archive_total, 20) / 20)
	archive_page = clamp(archive_page, 1, total_pages)
	var/sql_offset = (archive_page - 1) * 20

	// Paginated SELECT
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, author, title, category FROM ss13_library [sql_where] ORDER BY [safe_field] [safe_dir] LIMIT 20 OFFSET [sql_offset]",
		select_args)
	if(!query.Execute())
		archive_error = TRUE
		qdel(query)
		archive_loading = FALSE
		SStgui.update_uis(src)
		return

	var/list/results = list()
	while(query.NextRow())
		results += list(list(
			"id" = text2num(query.item[1]),
			"author" = query.item[2],
			"title" = query.item[3],
			"category" = query.item[4]
		))
	qdel(query)
	archive_results = results
	archive_loading = FALSE
	SStgui.update_uis(src)

/obj/machinery/librarycomp/proc/async_upload_book(mob/uploader)
	var/obj/machinery/libraryscanner/scanner = get_scanner()
	var/obj/item/book/book = scanner?.cache
	if(!book)
		return
	var/datum/db_query/query = SSdbcore.NewQuery(
		"INSERT INTO ss13_library (author, title, content, category, uploadtime, uploader) VALUES (:author, :title, :content, :category, NOW(), :uploader)",
		list(
			"author" = book.author ? book.author : "Anonymous",
			"title" = book.name,
			"content" = book.dat,
			"category" = upload_category,
			"uploader" = ckey(uploader.client.ckey)
		))
	if(!query.Execute())
		to_chat(uploader, SPAN_WARNING("Upload failed: [query.last_error]"))
		qdel(query)
		return
	qdel(query)
	log_and_message_admins("has uploaded the book titled [book.name], [length(book.dat)] signs")
	log_game("[uploader.name]/[uploader.key] has uploaded the book titled [book.name], [length(book.dat)] signs")
	to_chat(uploader, SPAN_NOTICE("Upload complete."))
	last_uploaded_title = book.name
	SStgui.update_uis(src)

/obj/machinery/librarycomp/proc/async_order_book(var/book_id)
	bible_on_cooldown = TRUE
	addtimer(CALLBACK(src, PROC_REF(end_bible_cooldown)), 6 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)
	SStgui.update_uis(src)

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, author, title, content FROM ss13_library WHERE id = :id",
		list("id" = book_id))
	if(!query.Execute() || !query.NextRow())
		qdel(query)
		return
	var/obj/item/book/ordered_book = new(src.loc)
	ordered_book.author = query.item[2]
	ordered_book.title = query.item[3]
	ordered_book.name = "Book: [query.item[3]]"
	ordered_book.dat = query.item[4]
	ordered_book.icon_state = "book[rand(1,16)]"
	ordered_book.item_state = ordered_book.icon_state
	qdel(query)
	src.visible_message("\The [src]'s printer hums as it produces a book.")

// Public Related Code
/obj/machinery/librarycomp/public
	name = "public library computer"
	is_public = TRUE
