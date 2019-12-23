//This could either be split into the proper DM files or placed somewhere else all together, but it'll do for now -Nodrak

/*

A list of items and costs is stored under the datum of every game mode, alongside the number of crystals, and the welcoming message.

*/

/obj/item/device/uplink
	var/welcome = "Welcome, Operative"	// Welcoming menu message
	var/uses 							// Numbers of crystals
	var/list/ItemsCategory				// List of categories with lists of items
	var/list/ItemsReference				// List of references with an associated item
	var/list/nanoui_items				// List of items for NanoUI use
	var/nanoui_menu = 0					// The current menu we are in
	var/list/nanoui_data = new 			// Additional data for NanoUI use

	var/list/purchase_log = new
	var/datum/mind/uplink_owner = null
	var/used_TC = 0

/obj/item/device/uplink/ui_host()
	return loc

/obj/item/device/uplink/New(var/location, var/datum/mind/owner, var/telecrystals = DEFAULT_TELECRYSTAL_AMOUNT)
	..()
	src.uplink_owner = owner
	purchase_log = list()
	world_uplinks += src
	uses = telecrystals

/obj/item/device/uplink/Destroy()
	world_uplinks -= src
	return ..()

// HIDDEN UPLINK - Can be stored in anything but the host item has to have a trigger for it.
/* How to create an uplink in 3 easy steps!

 1. All obj/item 's have a hidden_uplink var. By default it's null. Give the item one with "new(src)", it must be in it's contents. Feel free to add "uses".

 2. Code in the triggers. Use check_trigger for this, I recommend closing the item's menu with "user << browse(null, "window=windowname") if it returns true.)
 The var/value is the value that will be compared with the var/target. If they are equal it will activate the menu.

 3. If you want the menu to stay until the users locks his uplink, add an active_uplink_check(mob/user as mob) in your interact/attack_hand proc.
 Then check if it's true, if true return. This will stop the normal menu appearing and will instead show the uplink menu.
*/

/obj/item/device/uplink/hidden
	name = "hidden uplink"
	desc = "There is something wrong if you're examining this."
	var/active = 0
	var/datum/uplink_category/category 	= 0		// The current category we are in
	var/exploit_id								// Id of the current exploit record we are viewing
	// Messaging stuff.
	var/list/messages = list()
	var/list/conversations = list()
	var/uplink_type
	var/active_conversation = null
	var/last_text


// The hidden uplink MUST be inside an obj/item's contents.
/obj/item/device/uplink/hidden/New()
	spawn(2)
		if(!istype(src.loc, /obj/item))
			qdel(src)
	..()
	nanoui_data = list()
	update_nano_data()
	if(uplink_owner && uplink_owner.special_role == "Syndicate Commander")
		uplink_type = "Commander"
	else if(uplink_owner && uplink_owner.current.faction == "syndicate")
		uplink_type = "Operative"
	else
		uplink_type = "Unknown"

// Toggles the uplink on and off. Normally this will bypass the item's normal functions and go to the uplink menu, if activated.
/obj/item/device/uplink/hidden/proc/toggle()
	active = !active

// Directly trigger the uplink. Turn on if it isn't already.
/obj/item/device/uplink/hidden/proc/trigger(mob/user as mob)
	if(!active)
		toggle()
	interact(user)

// Checks to see if the value meets the target. Like a frequency being a traitor_frequency, in order to unlock a headset.
// If true, it accesses trigger() and returns 1. If it fails, it returns false. Use this to see if you need to close the
// current item's menu.
/obj/item/device/uplink/hidden/proc/check_trigger(mob/user as mob, var/value, var/target)
	if(value == target)
		trigger(user)
		return 1
	return 0

/*
	NANO UI FOR UPLINK WOOP WOOP
*/
/obj/item/device/uplink/hidden/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "Remote Uplink"
	var/data[0]

	data["welcome"] = welcome
	data["crystals"] = uses
	data["menu"] = nanoui_menu
	data["commanders"] = list()
	for(var/datum/mind/cmdr in get_antags("commander"))
		data["commanders"] += cmdr

	data += nanoui_data

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)	// No auto-refresh
		var/sel_state
		if(istype(loc, /obj/item/modular_computer))
			sel_state = default_state
		else
			sel_state = inventory_state

		ui = new(user, src, ui_key, "uplink.tmpl", title, 450, 600, state = sel_state)
		ui.set_initial_data(data)
		ui.open()


// Interaction code. Gathers a list of items purchasable from the paren't uplink and displays it. It also adds a lock button.
/obj/item/device/uplink/hidden/interact(mob/user)
	ui_interact(user)

/obj/item/device/uplink/hidden/CanUseTopic()
	if(!active)
		return STATUS_CLOSE
	return ..()

// The purchasing code.
/obj/item/device/uplink/hidden/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	if(href_list["buy_item"])
		var/datum/uplink_item/UI = (locate(href_list["buy_item"]) in uplink.items)
		UI.buy(src, usr)
	else if(href_list["lock"])
		toggle()
		var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")
		ui.close()
	else if(href_list["return"])
		nanoui_menu = round(nanoui_menu/10)
	else if(href_list["menu"])
		nanoui_menu = text2num(href_list["menu"])
		if(href_list["id"])
			exploit_id = href_list["id"]
		if(href_list["category"])
			category = locate(href_list["category"]) in uplink.categories
	// #TODO-MERGE: Check NanoUI on PDAs
	if(href_list["contract_interact"])
		var/list/params = list("location" = "contract_details", "contract" = href_list["contract_interact"])
		usr.client.process_webint_link("interface/login/sso_server", list2params(params))
	if(href_list["contract_page"])
		nanoui_data["contracts_current_page"] = text2num(href_list["contract_page"])
		update_nano_data()
	if(href_list["contract_view"])
		nanoui_data["contracts_view"] = text2num(href_list["contract_view"])
		nanoui_data["contracts_current_page"] = 1
		update_nano_data()

	if(href_list["Messenger"])
		if(href_list["Messenger"] == "Message")
			var/obj/item/device/uplink/hidden/U = locate(href_list["target"])
			src.create_message(usr, U)
			if(nanoui_menu == 4)
				if(href_list["target"] in conversations)
					active_conversation = href_list["target"]
					nanoui_menu = 41

		if(href_list["Messenger"] == "View")
			if(href_list["target"] in conversations)
				active_conversation = href_list["target"]
				nanoui_menu = 41

		if(href_list["Messenger"] == "Clear")
			var/new_messages[0]
			for(var/i in messages)
				if(i["target"] != active_conversation)
					new_messages[++new_messages.len] = i
			messages = new_messages
			conversations.Remove(active_conversation)
			active_conversation = null

			if(nanoui_menu == 41)
				nanoui_menu = 4

	update_nano_data()
	return 1

/obj/item/device/uplink/hidden/proc/update_nano_data()
	if(nanoui_menu == 0)
		var/categories[0]
		for(var/datum/uplink_category/category in uplink.categories)
			if(category.can_view(src))
				categories[++categories.len] = list("name" = category.name, "ref" = "\ref[category]")
		nanoui_data["categories"] = categories
	else if(nanoui_menu == 1)
		var/items[0]
		for(var/datum/uplink_item/item in category.items)
			if(item.can_view(src))
				var/cost = item.cost(uses)
				if(!cost) cost = "???"
				items[++items.len] = list("name" = item.name, "description" = replacetext(item.description(), "\n", "<br>"), "can_buy" = item.can_buy(src), "cost" = cost, "ref" = "\ref[item]")
		nanoui_data["items"] = items
	else if(nanoui_menu == 2)
		var/permanentData[0]
		for(var/datum/record/general/locked/L in sortRecord(SSrecords.records_locked))
			permanentData[++permanentData.len] = list(Name = L.name,"id" = L.id)
		nanoui_data["exploit_records"] = permanentData
	else if(nanoui_menu == 21)
		nanoui_data["exploit_exists"] = 0

		for(var/datum/record/general/locked/L in SSrecords.records_locked)
			if(L.id == exploit_id)
				nanoui_data["exploit"] = list()  // Setting this to equal L.fields passes it's variables that are lists as reference instead of value.
								 // We trade off being able to automatically add shit for more control over what gets passed to json
								 // and if it's sanitized for html.
				nanoui_data["exploit"]["nanoui_exploit_record"] = html_encode(L.exploit_record) // Change stuff into html
				nanoui_data["exploit"]["nanoui_exploit_record"] = replacetext(nanoui_data["exploit"]["nanoui_exploit_record"], "\n", "<br>") // change line breaks into <br>
				nanoui_data["exploit"]["name"] =  html_encode(L.name)
				nanoui_data["exploit"]["sex"] =  html_encode(L.sex)
				nanoui_data["exploit"]["age"] =  html_encode(L.age)
				nanoui_data["exploit"]["species"] =  html_encode(L.species)
				nanoui_data["exploit"]["rank"] =  html_encode(L.rank)
				nanoui_data["exploit"]["citizenship"] =  html_encode(L.citizenship)
				nanoui_data["exploit"]["employer"] =  html_encode(L.employer)
				nanoui_data["exploit"]["religion"] =  html_encode(L.religion)
				nanoui_data["exploit"]["fingerprint"] =  html_encode(L.fingerprint)

				nanoui_data["exploit_exists"] = 1
				break

	else if(nanoui_menu == 3)
		nanoui_data["contracts_found"] = 0

		establish_db_connection(dbcon)

		if (dbcon.IsConnected())
			nanoui_data["contracts"] = list()

			if (!nanoui_data["contracts_current_page"])
				nanoui_data["contracts_current_page"] = 1

			if (!nanoui_data["contracts_view"])
				nanoui_data["contracts_view"] = 1

			var/query_details[0]

			switch (nanoui_data["contracts_view"])
				if (1)
					query_details["status"] = "open"
				if (2)
					query_details["status"] = "closed"
				else
					nanoui_data["contracts_view"] = 1
					query_details["status"] = "open"

			var/DBQuery/index_query = dbcon.NewQuery("SELECT count(*) as Total_Contracts FROM ss13_syndie_contracts WHERE deleted_at IS NULL AND status = :status:")
			index_query.Execute(query_details)

			var/pages = 0

			if (index_query.NextRow())
				var/total_contracts = text2num(index_query.item[1])

				pages = total_contracts / 10

				if (total_contracts % 10)
					pages++

				pages = round(pages)

				var/list/contracts_pages = list()

				for (var/i = 1, i <= pages, i++)
					contracts_pages.Add(i)

				for (var/a in contracts_pages)

				nanoui_data["contracts_pages"] = contracts_pages

				if (nanoui_data["contracts_current_page"] > pages)
					return

				query_details["offset"] = (nanoui_data["contracts_current_page"] - 1) * 10

				var/DBQuery/list_query = dbcon.NewQuery("SELECT contract_id, contractee_name, title FROM ss13_syndie_contracts WHERE deleted_at IS NULL AND status = :status: LIMIT 10 OFFSET :offset:")
				list_query.Execute(query_details)

				var/list/contracts = list()
				while (list_query.NextRow())
					contracts.Add(list(list("id" = list_query.item[1],
											"contractee" = list_query.item[2],
											"title" = list_query.item[3])))

				nanoui_data["contracts"] = contracts

				nanoui_data["contracts_found"] = 1

	else if(nanoui_menu == 31)
		nanoui_data["contracts_found"] = 0

		establish_db_connection(dbcon)

		if (dbcon.IsConnected())
			nanoui_data["contracts"] = list()

			if (!nanoui_data["contracts_current_page"])
				nanoui_data["contracts_current_page"] = 1

			if (!nanoui_data["contracts_view"])
				nanoui_data["contracts_view"] = 1

			var/query_details[0]
			query_details["contract_id"] = exploit_id

			var/DBQuery/select_query = dbcon.NewQuery("SELECT contract_id, contractee_name, status, title, description, reward_other FROM ss13_syndie_contracts WHERE contract_id = :contract_id:")
			select_query.Execute(query_details)

			if (select_query.NextRow())
				nanoui_data["contracts_found"] = 1

				var/contract[0]
				contract["id"] = select_query.item[1]
				contract["contractee"] = select_query.item[2]

				switch (select_query.item[3])
					if ("open")
						contract["status"] = "1"
					else
						contract["status"] = "0"

				contract["title"] = html_encode(select_query.item[4])
				contract["description"] = select_query.item[5]

				contract["description"] = html_encode(contract["description"])
				contract["description"] = replacetext(contract["description"], "\n", "<br>")
				contract["description"] = replacetext(contract["description"], ascii2text(13), "")
				contract["reward_other"] = select_query.item[6]

				nanoui_data["contract"] = contract

	else if(nanoui_menu == 4)
		var/list/signals = list()
		var/list/convos = list()
		var/comm_type

		for(var/obj/item/device/uplink/hidden/U in world_uplinks)
			if(!istype(U) || U == src)
				continue

			if(istype(U.loc, /obj/item/device/pda))
				comm_type = "PDA"
			else if(istype(U.loc, /obj/item/device/radio/headset))
				comm_type = "Headset"
			else if (istype(U.loc, /obj/machinery/computer))
				comm_type = "Terminal"
			else
				comm_type = ""

			if(!U.uplink_type)
				continue

			if(conversations.Find("\ref[U]"))
				convos[U.uplink_type] += list(list("Name" = "[U.uplink_owner.name]", "Reference" = "\ref[U]", "Type" = "[comm_type ? comm_type : "Unknown Uplink"]"))
			else
				signals[U.uplink_type] += list(list("Name" = "[U.uplink_owner.name]", "Reference" = "\ref[U]", "Type" = "[comm_type ? comm_type : "Unknown Uplink"]"))

		nanoui_data["signals"] = signals
		nanoui_data["convos"] = convos
		nanoui_data["cmdr_count"] = convos["Commander"].len + signals["Commander"].len
		nanoui_data["op_count"] = convos["Operative"].len + signals["Operative"].len

	if(nanoui_menu == 41)
		nanoui_data["messagescount"] = messages.len
		nanoui_data["messages"] = messages
	else
		nanoui_data["messagescount"] = null
		nanoui_data["messages"] = null

	if(active_conversation)
		nanoui_data["active_conversation"] = active_conversation
		for(var/c in messages)
			if(c["target"] == active_conversation)
				nanoui_data["convo_name"] = sanitize(c["owner"])
				nanoui_data["convo_job"] = sanitize(c["job"])
				break
	else
		nanoui_data["active_conversation"] = null

/obj/item/device/uplink/hidden/proc/create_message(mob/user, obj/item/device/uplink/hidden/recipient)
	var/t = input(user, "Please enter message", "Uplink Communications", null) as text|null
	t = sanitize(t)
	t = replace_characters(t, list("&#34;" = "\""))

	if (!t || !istype(recipient) || loc.loc != user)
		return

	if (last_text && world.time < last_text + 5)
		return

	if(use_check_and_message(user))
		return

	last_text = world.time

	messages.Add(list(list("sent" = 1, "owner" = "[recipient.uplink_owner.name]", "job" = "[recipient.uplink_type]", "message" = "[t]", "target" = "\ref[recipient]")))
	recipient.messages.Add(list(list("sent" = 0, "owner" = "[recipient.uplink_owner.name]", "job" = "[uplink_type]", "message" = "[t]", "target" = "\ref[src]")))
	for(var/mob/M in player_list)
		if(M.stat == DEAD && M.client && (M.client.prefs.toggles & CHAT_GHOSTEARS)) // src.client is so that ghosts don't have to listen to rats
			if(istype(M, /mob/abstract/new_player))
				continue
			M.show_message("<span class='game say'>Syndicate Uplink - <span class='name'>[uplink_type] [uplink_owner.name]</span> -> <span class='name'>[uplink_type] [recipient.uplink_owner.name]</span>: <span class='message'>[t]</span></span>")

	if(!conversations.Find("\ref[recipient]"))
		conversations.Add("\ref[recipient]")
	if(!recipient.conversations.Find("\ref[src]"))
		recipient.conversations.Add("\ref[src]")

	recipient.receive_message(src, t)
	SSnanoui.update_user_uis(user, src)

/obj/item/device/uplink/hidden/proc/receive_message(var/obj/item/device/uplink/hidden/sender, message)
	var/reception_message = "\icon[src] <b>Uplink Message from [sender.uplink_type] [sender.uplink_owner.name], </b>\"[message]\" (<a href='byond://?src=\ref[src];choice=Message;skiprefresh=1;target=\ref[sender]'>Reply</a>)"
	var/mob/living/L = loc.loc
	if(!istype(L))
		return

	if(active)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		to_chat(L, reception_message)
	else
		to_chat(L, span("notice", "Your uplink vibrates for a moment."))
	SSnanoui.update_user_uis(L, src)

// I placed this here because of how relevant it is.
// You place this in your uplinkable item to check if an uplink is active or not.
// If it is, it will display the uplink menu and return 1, else it'll return false.
// If it returns true, I recommend closing the item's normal menu with "user << browse(null, "window=name")")
/obj/item/proc/active_uplink_check(mob/user as mob)
	// Activates the uplink if it's active
	if(src.hidden_uplink)
		if(src.hidden_uplink.active)
			src.hidden_uplink.trigger(user)
			return 1
	return 0

// PRESET UPLINKS
// A collection of preset uplinks.
//
// Includes normal radio uplink, multitool uplink,
// implant uplink (not the implant tool) and a preset headset uplink.

/obj/item/device/radio/uplink/New(var/loc, var/mind)
	hidden_uplink = new(src, mind)
	icon_state = "radio"

/obj/item/device/radio/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/multitool/uplink/New(var/loc, var/mind)
	hidden_uplink = new(src, mind)

/obj/item/device/multitool/uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/radio/headset/uplink
	traitor_frequency = 1445

/obj/item/device/radio/headset/uplink/New(var/loc, var/mind)
	..()
	hidden_uplink = new(src, mind)
	hidden_uplink.uses = DEFAULT_TELECRYSTAL_AMOUNT

/*
 * A simple device for accessing the SQL based contract database
 */

/obj/item/device/contract_uplink
	name = "contract uplink"
	desc = "A small device used for access restricted sites in the remote corners of the Extranet."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	flags = CONDUCT
	w_class = 2

/obj/item/device/contract_uplink/New(var/loc, var/mind)
	..()
	hidden_uplink = new(src, mind)
	hidden_uplink.uses = 0
	hidden_uplink.nanoui_menu = 3

/obj/item/device/contract_uplink/attack_self(mob/user as mob)
	if (hidden_uplink)
		hidden_uplink.trigger(user)


//for revs to create their own central command reports
/obj/item/device/announcer
	name = "relay positioning device"
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	description_antag = "This device allows you to create a single central command report. It has only one use."
	w_class = 2

/obj/item/device/announcer/attack_self(mob/user as mob)
	if(!player_is_antag(user.mind))
		return

	var/title = sanitize(input("Enter your announcement title.", "Announcement Title") as null|text)
	if(!title)
		return

	var/message = sanitize(input("Enter your announcement message.", "Announcement Title") as message|null)
	if(!message)
		return

	command_announcement.Announce("[message]", title, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
	discord_bot.send_to_cciaa("Announcer - Fake announcement:`[title]` - `[message]`, sent by [user]!")
	qdel(src)

//ninja
/obj/item/device/ninja_uplink
	name = "infiltrator uplink"
	desc = "A small device used for access to a restricted cache of specialized items."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	flags = CONDUCT
	w_class = 2

/obj/item/device/ninja_uplink/New(var/loc, var/mind)
	..()
	hidden_uplink = new(src, mind)
	hidden_uplink.uses = DEFAULT_TELECRYSTAL_AMOUNT
	hidden_uplink.nanoui_menu = 1

/obj/item/device/ninja_uplink/attack_self(mob/user as mob)
	if (hidden_uplink)
		hidden_uplink.trigger(user)
