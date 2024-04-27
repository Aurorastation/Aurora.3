/* Library Machines
 *
 * Contains:
 *		Borrowbook datum
 *		Library Public Computer
 *		Library Computer
 *		Library Scanner
 *		Book Binder
 */

/*
 * Borrowbook datum
 */
/datum/borrowbook // Datum used to keep track of who has borrowed what when and for how long.
	var/bookname
	var/mobname
	var/getdate
	var/duedate

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
	var/screenstate = 0
	var/title
	var/category = "Any"
	var/author
	var/SQLquery

/obj/machinery/librarypubliccomp/attack_hand(var/mob/user)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Library Visitor</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	switch(screenstate)
		if(0)
			dat += {"<h2>Search Settings</h2><br>
			<a href='?src=\ref[src];settitle=1'>Filter by Title: [title]</a><br>
			<a href='?src=\ref[src];setcategory=1'>Filter by Category: [category]</a><br>
			<a href='?src=\ref[src];setauthor=1'>Filter by Author: [author]</a><br>
			<a href='?src=\ref[src];search=1'>\[Start Search\]</a><br>"}
		if(1)
			if(!establish_db_connection(GLOB.dbcon))
				dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font><br>"
			else if(!SQLquery)
				dat += "<font color=red><b>ERROR</b>: Malformed search request. Please contact your system administrator for assistance.</font><br>"
			else
				dat += {"<table>
				<tr><td>AUTHOR</td><td>TITLE</td><td>CATEGORY</td><td>SS<sup>13</sup>BN</td></tr>"}

				var/DBQuery/query = GLOB.dbcon.NewQuery(SQLquery)
				query.Execute()

				while(query.NextRow())
					var/author = query.item[1]
					var/title = query.item[2]
					var/category = query.item[3]
					var/id = query.item[4]
					dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td>[id]</td></tr>"
				dat += "</table><br>"
			dat += "<a href='?src=\ref[src];back=1'>\[Go Back\]</a><br>"
	user << browse(dat, "window=publiclibrary")
	onclose(user, "publiclibrary")

/obj/machinery/librarypubliccomp/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=publiclibrary")
		onclose(usr, "publiclibrary")
		return

	if(href_list["settitle"])
		var/newtitle = input("Enter a title to search for:") as text|null
		if(newtitle)
			title = sanitize(newtitle)
		else
			title = null
		title = sanitizeSQL(title)
	if(href_list["setcategory"])
		var/newcategory = input("Choose a category to search for:") in list("Any", "Fiction", "Non-Fiction", "Reference", "Religion")
		if(newcategory)
			category = sanitize(newcategory)
		else
			category = "Any"
		category = sanitizeSQL(category)
	if(href_list["setauthor"])
		var/newauthor = input("Enter an author to search for:") as text|null
		if(newauthor)
			author = sanitize(newauthor)
		else
			author = null
		author = sanitizeSQL(author)
	if(href_list["search"])
		SQLquery = "SELECT author, title, category, id FROM ss13_library WHERE "
		if(category == "Any")
			SQLquery += "author LIKE '%[author]%' AND title LIKE '%[title]%'"
		else
			SQLquery += "author LIKE '%[author]%' AND title LIKE '%[title]%' AND category='[category]'"
		screenstate = 1

	if(href_list["back"])
		screenstate = 0

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

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
	var/arcanecheckout = FALSE
	var/screenstate = 0 // 0: Main Menu - 1: Inventory - 2: Checked Out - 3: Check Out
	var/sortby = "author"
	var/buffer_book
	var/buffer_mob
	var/upload_category = "Fiction"
	var/list/checkouts = list()
	var/list/inventory = list()
	var/checkoutperiod = 5 // In minutes
	var/bibledelay = 0
	var/is_public = FALSE
	var/obj/machinery/libraryscanner/scanner // Book scanner that will be used when uploading books to the Archive

/obj/machinery/librarycomp/attack_hand(var/mob/user)
	user.set_machine(src)
	var/dat
	// Public Related Code
	if(!is_public)
		dat = "<head><title>[SSatlas.current_map.station_name] Library Management</title></head><body>\n"
	else
		dat = "<head><title>[SSatlas.current_map.station_name] Library</title></head><body>\n"
	switch(screenstate)
		if(0)
			// Main Menu
			dat += "<a href='?src=\ref[src];switchscreen=1'>View Stock</a><br>"
			dat += "<a href='?src=\ref[src];switchscreen=2'>View Checked Out Books</a><br>"
			dat += "<a href='?src=\ref[src];switchscreen=3'>Check out a Book</a><br>"
			dat += "<a href='?src=\ref[src];switchscreen=4'>Order From Library Database</a><br>"
			if(!is_public)
				dat += "<a href='?src=\ref[src];switchscreen=5'>Upload New Title to Library Database</a><br>"
			dat += "<a href='?src=\ref[src];switchscreen=6'>Print a Bible</a><br>"
			if(emagged)
				dat += "<a href='?src=\ref[src];switchscreen=7'>7. Access the Forbidden Lore Vault</a><br>"
			if(arcanecheckout)
				new /obj/item/book/tome(get_turf(src))
				to_chat(user, "<span class='warning'>Your sanity barely endures the seconds spent in the vault's browsing window. The only thing to remind you of this when you stop browsing is a dusty old tome sitting on the desk. You don't really remember printing it.</span>")
				user.visible_message("<span class='notice'>\The [user] stares at the blank screen for a few moments, [user.get_pronoun("his")] expression frozen in fear. When [user.get_pronoun("he")] finally awakens from it, [user.get_pronoun("he")] looks a lot older.</span>", range = 2)
				arcanecheckout = FALSE
		if(1)
			// Inventory
			dat += "<H3>Inventory</H3><br>"
			for(var/obj/item/book/b in inventory)
				dat += "[b.name] <a href='?src=\ref[src];delbook=\ref[b]'>(Delete)</a><br>"
			dat += "<a href='?src=\ref[src];switchscreen=0'>(<-- Return to Main Menu)</a><br>"
		if(2)
			// Checked Out
			dat += "<h3>Checked Out Books</h3><br>"
			for(var/datum/borrowbook/b in checkouts)
				var/timetaken = world.time - b.getdate
				//timetaken *= 10
				timetaken /= 600
				timetaken = round(timetaken)
				var/timedue = b.duedate - world.time
				//timedue *= 10
				timedue /= 600
				if(timedue <= 0)
					timedue = "<font color=red><b>(OVERDUE)</b> [timedue]</font>"
				else
					timedue = round(timedue)
				dat += {"\"[b.bookname]\", Checked out to: [b.mobname]<br>--- Taken: [timetaken] minutes ago, Due: in [timedue] minutes<br>
				<a href='?src=\ref[src];checkin=\ref[b]'>(Check In)</a><br><br>"}
			dat += "<a href='?src=\ref[src];switchscreen=0'>(<-- Return to Main Menu)</a><br>"
		if(3)
			// Check Out a Book
			dat += {"<h3>Check Out a Book</h3><br>
			Book: [src.buffer_book]
			<a href='?src=\ref[src];editbook=1'>\[Edit\]</a><br>
			Recipient: [src.buffer_mob]
			<a href='?src=\ref[src];editmob=1'>\[Edit\]</a><br>
			Checkout Date: [world.time / 600]<br>
			Due Date: [(world.time + checkoutperiod) / 600]<br>
			(Checkout Period: [checkoutperiod] minutes) (<a href='?src=\ref[src];increasetime=1'>+</a>/<a href='?src=\ref[src];decreasetime=1'>-</a>)<br>
			<a href='?src=\ref[src];checkout=1'>(Commit Entry)</a><br>
			<a href='?src=\ref[src];switchscreen=0'>(<-- Return to Main Menu)</a><br>"}
		if(4)
			dat += "<h3>External Archive</h3>"
			if(!establish_db_connection(GLOB.dbcon))
				dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font>"
			else
				dat += {"<a href='?src=\ref[src];orderbyid=1'>(Order Book by ISBN)</a><br><br>
				<table>
				<tr><td><a href='?src=\ref[src];sort=author>AUTHOR</a></td><td><a href='?src=\ref[src];sort=title>TITLE</a></td><td><a href='?src=\ref[src];sort=category>CATEGORY</a></td><td></td></tr>"}
				var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT id, author, title, category FROM ss13_library ORDER BY [sortby]")
				query.Execute()

				while(query.NextRow())
					var/id = query.item[1]
					var/author = query.item[2]
					var/title = query.item[3]
					var/category = query.item[4]
					dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td><a href='?src=\ref[src];targetid=[id]'>\[Order\]</a></td></tr>"
				dat += "</table>"
			dat += "<br><a href='?src=\ref[src];switchscreen=0'>(<-- Return to Main Menu)</a><br>"
		if(5)
			dat += "<H3>Upload a New Title</H3>"
			if(!scanner)
				for(var/obj/machinery/libraryscanner/S in range(9))
					if(S.anchored)
						scanner = S
						break
			if(!(scanner?.anchored))
				dat += "<FONT color=red>No scanner found within wireless network range.</FONT><br>"
			else if(!scanner.cache)
				dat += "<FONT color=red>No data found in scanner memory.</FONT><br>"
			else
				dat += {"<TT>Data marked for upload...</TT><br>
				<TT>Title: </TT>[scanner.cache.name]<br>"}
				if(!scanner.cache.author)
					scanner.cache.author = "Anonymous"
				dat += {"<TT>Author: </TT><a href='?src=\ref[src];setauthor=1'>[scanner.cache.author]</a><br>
				<TT>Category: </TT><a href='?src=\ref[src];setcategory=1'>[upload_category]</a><br>
				<a href='?src=\ref[src];upload=1'>\[Upload\]</a><br>"}
			dat += "<a href='?src=\ref[src];switchscreen=0'>(<-- Return to Main Menu)</a><br>"
		if(7)
			dat += {"<h3>Accessing Forbidden Lore Vault v 1.3</h3>
			Are you absolutely sure you want to proceed? EldritchTomes Inc. takes no responsibilities for loss of sanity resulting from this action.<p>
			<a href='?src=\ref[src];arccheckout=1'>Yes.</a><br>
			<a href='?src=\ref[src];switchscreen=0'>No.</a><br>"}

	//dat += "<a HREF='?src=\ref[user];mach_close=library'>Close</a><br><br>"
	user << browse(dat, "window=library")
	onclose(user, "library")

/obj/machinery/librarycomp/emag_act(var/remaining_charges, var/mob/user)
	if (src.density && !src.emagged)
		src.emagged = 1
		return 1

/obj/machinery/librarycomp/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = attacking_item
		scanner.computer = src
		to_chat(user, "[scanner]'s associated machine has been set to [src].")
		for (var/mob/V in hearers(src))
			V.show_message("[src] lets out a low, short blip.", 2)
	else
		..()

/obj/machinery/librarycomp/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=library")
		onclose(usr, "library")
		return

	if(href_list["switchscreen"])
		switch(href_list["switchscreen"])
			if("0")
				screenstate = 0
			if("1")
				screenstate = 1
			if("2")
				screenstate = 2
			if("3")
				screenstate = 3
			if("4")
				screenstate = 4
			if("5")
				screenstate = 5
			if("6")
				if(!bibledelay)

					var/obj/item/storage/bible/B = new /obj/item/storage/bible(src.loc)
					B.verbs += /obj/item/storage/bible/verb/Set_Religion
					var/randbook = "book" + pick("1", "2", "3", "4", "5", "6" , "7", "8", "9", "10", "11", "12", "13" , "14", "15" , "16")
					B.icon_state = randbook
					B.item_state = randbook
					B.name = "religious book"

					bibledelay = 1
					spawn(60)
						bibledelay = 0

				else
					for (var/mob/V in hearers(src))
						V.show_message("<b>[src]</b>'s monitor flashes, \"Bible printer currently unavailable, please wait a moment.\"")

			if("7")
				screenstate = 7
	if(href_list["arccheckout"])
		if(src.emagged)
			src.arcanecheckout = 1
		src.screenstate = 0
	if(href_list["increasetime"])
		checkoutperiod += 1
	if(href_list["decreasetime"])
		checkoutperiod -= 1
		if(checkoutperiod < 1)
			checkoutperiod = 1
	if(href_list["editbook"])
		buffer_book = sanitizeSafe(input("Enter the book's title:") as text|null)
	if(href_list["editmob"])
		buffer_mob = sanitize(input("Enter the recipient's name:") as text|null, MAX_NAME_LEN)
	if(href_list["checkout"])
		var/datum/borrowbook/b = new /datum/borrowbook
		b.bookname = sanitizeSafe(buffer_book)
		b.mobname = sanitize(buffer_mob)
		b.getdate = world.time
		b.duedate = world.time + (checkoutperiod * 600)
		checkouts.Add(b)
	if(href_list["checkin"])
		var/datum/borrowbook/b = locate(href_list["checkin"])
		checkouts.Remove(b)
	if(href_list["delbook"])
		var/obj/item/book/b = locate(href_list["delbook"])
		inventory.Remove(b)
	if(href_list["setauthor"])
		var/newauthor = sanitize(input("Enter the author's name: ") as text|null)
		if(newauthor)
			scanner.cache.author = newauthor
	if(href_list["setcategory"])
		var/newcategory = input("Choose a category: ") in list("Fiction", "Non-Fiction", "Reference", "Religion")
		if(newcategory)
			upload_category = newcategory
	if(href_list["upload"])
		if(scanner?.anchored)
			if(scanner.cache)
				var/choice = input("Are you certain you wish to upload this title to the Archive?") in list("Confirm", "Abort")
				if(choice == "Confirm")
					if(scanner.cache.unique)
						alert("This book has been rejected from the database. Aborting!")
					else
						if(!establish_db_connection(GLOB.dbcon))
							alert("Connection to Archive has been severed. Aborting.")
						else
							var/sqltitle = sanitizeSQL(scanner.cache.name)
							var/sqlauthor = sanitizeSQL(scanner.cache.author)
							var/sqlcontent = sanitizeSQL(scanner.cache.dat)
							var/sqlcategory = sanitizeSQL(upload_category)
							var/sqlckey = sanitizeSQL(ckey(usr.client.ckey))
							var/DBQuery/query = GLOB.dbcon.NewQuery("INSERT INTO ss13_library (author, title, content, category, uploadtime, uploader) VALUES ('[sqlauthor]', '[sqltitle]', '[sqlcontent]', '[sqlcategory]', NOW(), '[sqlckey]')")
							if(!query.Execute())
								to_chat(usr, query.ErrorMsg())
							else
								log_and_message_admins("has uploaded the book titled [scanner.cache.name], [length(scanner.cache.dat)] signs")
								log_game("[usr.name]/[usr.key] has uploaded the book titled [scanner.cache.name], [length(scanner.cache.dat)] signs",ckey=key_name(usr))
								alert("Upload Complete.")

	if(href_list["targetid"])
		var/sqlid = sanitizeSQL(href_list["targetid"])
		if(!establish_db_connection(GLOB.dbcon))
			alert("Connection to Archive has been severed. Aborting.")
		if(bibledelay)
			for (var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"Printer unavailable. Please allow a short time before attempting to print.\"")
		else
			bibledelay = 1
			spawn(60)
				bibledelay = 0
			var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT * FROM ss13_library WHERE id=[sqlid]")
			query.Execute()

			while(query.NextRow())
				var/author = query.item[2]
				var/title = query.item[3]
				var/content = query.item[4]
				var/obj/item/book/B = new(src.loc)
				B.name = "Book: [title]"
				B.title = title
				B.author = author
				B.dat = content
				B.icon_state = "book[rand(1,7)]"
				src.visible_message("\The [src]\s printer hums as it produces a book.")
				break
	if(href_list["orderbyid"])
		var/orderid = input("Enter your order:") as num|null
		if(orderid)
			if(isnum(orderid))
				var/nhref = "src=\ref[src];targetid=[orderid]"
				spawn() src.Topic(nhref, params2list(nhref), src)
	if(href_list["sort"] in list("author", "title", "category"))
		sortby = href_list["sort"]
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

// Public Related Code
/obj/machinery/librarycomp/public
	name = "public library computer"
	is_public = TRUE

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "book scanner"
	desc = "A machine that scans books for upload to the library database."
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	var/insert_anim = "bigscanner1"
	anchored = TRUE
	density = TRUE
	var/obj/item/book/cache		// Last scanned book

/obj/machinery/libraryscanner/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/book))
		if(!anchored)
			to_chat(user, SPAN_WARNING("\The [src] must be secured to the floor first!"))
			return
		user.drop_from_inventory(attacking_item,src)
	if(attacking_item.iswrench())
		attacking_item.play_tool_sound(get_turf(src), 75)
		if(anchored)
			user.visible_message(SPAN_NOTICE("\The [user] unsecures \the [src] from the floor."),
								SPAN_NOTICE("You unsecure \the [src] from the floor."),
								SPAN_WARNING("You hear a ratcheting noise."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the floor."),
								SPAN_NOTICE("You secure \the [src] to the floor."),
								SPAN_WARNING("You hear a ratcheting noise."))
		anchored = !anchored

/obj/machinery/libraryscanner/attack_hand(var/mob/user)
	usr.set_machine(src)
	var/dat = "<HEAD><TITLE>Scanner Control Interface</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
	if(cache)
		dat += "<FONT color=#005500>Data stored in memory.</FONT><br>"
	else
		dat += "No data stored in memory.<br>"
	dat += "<a href='?src=\ref[src];scan=1'>\[Scan\]</a>"
	if(cache)
		dat += "       <a href='?src=\ref[src];clear=1'>\[Clear Memory\]</a><br><br><a href='?src=\ref[src];eject=1'>\[Remove Book\]</a>"
	else
		dat += "<br>"
	user << browse(dat, "window=scanner")
	onclose(user, "scanner")

/obj/machinery/libraryscanner/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=scanner")
		onclose(usr, "scanner")
		return

	if(href_list["scan"])
		flick(insert_anim, src)
		playsound(loc, 'sound/bureaucracy/scan.ogg', 75, 1)
		for(var/obj/item/book/B in contents)
			cache = B
			break
	if(href_list["clear"])
		cache = null
	if(href_list["eject"])
		for(var/obj/item/book/B in contents)
			B.forceMove(src.loc)
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "book binder"
	desc = "A machine that takes paper and binds them into books. Fascinating!"
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = TRUE
	density = TRUE
	var/binding = FALSE

/obj/machinery/bookbinder/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper))
		if(!anchored)
			to_chat(user, SPAN_WARNING("\The [src] must be secured to the floor first!"))
			return
		if(binding)
			to_chat(user, SPAN_WARNING("You must wait for \the [src] to finish its current operation!"))
			return
		var/turf/T = get_turf(src)
		user.drop_from_inventory(attacking_item,src)
		user.visible_message(SPAN_NOTICE("\The [user] loads some paper into \the [src]."), SPAN_NOTICE("You load some paper into \the [src]."))
		visible_message(SPAN_NOTICE("\The [src] begins to hum as it warms up its printing drums."))
		playsound(T, 'sound/bureaucracy/binder.ogg', 75, 1)
		binding = TRUE
		sleep(rand(200,400))
		binding = FALSE
		if(!anchored)
			visible_message(SPAN_WARNING("\The [src] buzzes and flashes an error light."))
			attacking_item.forceMove(T)
			return
		visible_message(SPAN_NOTICE("\The [src] whirs as it prints and binds a new book."))
		playsound(T, 'sound/bureaucracy/print.ogg', 75, 1)
		var/obj/item/book/b = new(T)
		b.dat = attacking_item:info
		b.name = "blank book"
		b.icon_state = "book[rand(1,7)]"
		qdel(attacking_item)
		return
	if(attacking_item.iswrench())
		attacking_item.play_tool_sound(get_turf(src), 75)
		if(anchored)
			user.visible_message(SPAN_NOTICE("\The [user] unsecures \the [src] from the floor."), \
				SPAN_NOTICE("You unsecure \the [src] from the floor."), \
				SPAN_WARNING("You hear a ratcheting noise."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the floor."), \
				SPAN_NOTICE("You secure \the [src] to the floor."), \
				SPAN_WARNING("You hear a ratcheting noise."))
		anchored = !anchored
