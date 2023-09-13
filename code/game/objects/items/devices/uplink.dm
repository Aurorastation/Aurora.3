//This could either be split into the proper DM files or placed somewhere else all together, but it'll do for now -Nodrak

/*

A list of items and costs is stored under the datum of every game mode, alongside the number of crystals, and the welcoming message.

*/

/obj/item/device/uplink
	/// Welcoming menu message.
	var/welcome = "Welcome, Operative"
	/// Number of telecrystals.
	var/telecrystals
	/// Number of bluecrystals.
	var/bluecrystals
	/// Counter of used telecrystals.
	var/used_telecrystals = 0
	/// Counter of used bluecrystals.
	var/used_bluecrystals = 0
	/// List of categories with lists of items.
	var/list/ItemsCategory
	/// List of references with an associated item.
	var/list/ItemsReference
	/// List of items for NanoUI use.
	var/list/nanoui_items
	/// The current menu we are in.
	var/nanoui_menu = 0
	/// Additional data for NanoUI use.
	var/list/nanoui_data = list()
	// Assoc list of item to times bought; shared/referenced by child uplinks
	var/list/purchase_log = list()
	/// Mind of the uplink's owner.
	var/datum/mind/uplink_owner = null

/obj/item/device/uplink/ui_host()
	return loc

/obj/item/device/uplink/Initialize(var/mapload, var/datum/mind/owner, var/new_telecrystals = DEFAULT_TELECRYSTAL_AMOUNT, var/new_bluecrystals = DEFAULT_BLUECRYSTAL_AMOUNT)
	. = ..()
	src.uplink_owner = owner
	purchase_log = list()
	world_uplinks += src
	telecrystals = new_telecrystals
	bluecrystals = new_bluecrystals

/obj/item/device/uplink/Destroy()
	world_uplinks -= src
	src.uplink_owner = null
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
	var/pda_code = ""


// The hidden uplink MUST be inside an obj/item's contents.
/obj/item/device/uplink/hidden/New()
	spawn(2)
		if(!istype(loc, /obj/item))
			qdel(src)
	..()
	nanoui_data = list()
	update_nano_data()

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
	TGUI FOR UPLINK WOOP WOOP
*/
/obj/item/device/uplink/hidden/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Uplink", capitalize_first_letters(name))
		ui.open()

/obj/item/device/uplink/hidden/ui_data(mob/user)
	var/list/data = list()
	data["welcome"] = welcome
	data["telecrystals"] = telecrystals
	data["bluecrystals"] = bluecrystals
	data["menu"] = nanoui_menu
	data += nanoui_data
	return data

// Interaction code. Gathers a list of items purchasable from the paren't uplink and displays it. It also adds a lock button.
/obj/item/device/uplink/hidden/interact(mob/user)
	ui_interact(user, null)

// /obj/item/device/uplink/hidden/CanUseTopic()
// 	if(!active)
// 		return STATUS_CLOSE
// 	return ..()

/obj/item/device/uplink/hidden/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return 1

	var/mob/user = usr
	if(action == "buy_item")
		var/datum/uplink_item/UI = (locate(params["buy_item"]) in uplink.items)
		UI.buy(src, usr)
	else if(action == "lock")
		toggle()
		// var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")
		// ui.close()
	else if(action == "return")
		nanoui_menu = round(nanoui_menu/10)
	else if(action == "menu")
		nanoui_menu = text2num(params["menu"])
		if(params["id"])
			exploit_id = params["id"]
		if(params["category"])
			category = locate(params["category"]) in uplink.categories
	// if(action == ["contract_interact"])
	// 	var/list/params = list("location" = "contract_details", "contract" = params["contract_interact"])
	// 	usr.client.process_webint_link("interface/login/sso_server", list2params(params))
	if(action == "contract_page")
		nanoui_data["contracts_current_page"] = text2num(params["contract_page"])
		update_nano_data()
	if(action == "contract_view")
		nanoui_data["contracts_view"] = text2num(params["contract_view"])
		nanoui_data["contracts_current_page"] = 1
		update_nano_data()

	// update_nano_data()
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
				var/tc_cost = item.telecrystal_cost(telecrystals)
				var/bc_cost = item.bluecrystal_cost(bluecrystals)
				var/can_buy = item.can_buy_telecrystals(src) || item.can_buy_bluecrystals(src)
				items[++items.len] = list(
					"name" = item.name,
					"description" = replacetext(item.description(), "\n", "<br>"),
					"can_buy" = can_buy,
					"tc_cost" = tc_cost,
					"bc_cost" = bc_cost,
					"left" = item.items_left(src),
					"ref" = "\ref[item]"
				)
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

		if(establish_db_connection(dbcon))
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

	if(nanoui_menu == 31)
		nanoui_data["contracts_found"] = 0

		if (config.sql_enabled && establish_db_connection(dbcon))
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
	hidden_uplink.telecrystals = DEFAULT_TELECRYSTAL_AMOUNT
	hidden_uplink.bluecrystals = DEFAULT_BLUECRYSTAL_AMOUNT

/*
 * A simple device for accessing the SQL based contract database
 */

/obj/item/device/contract_uplink
	name = "contract uplink"
	desc = "A small device used for access restricted sites in the remote corners of the Extranet."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	flags = CONDUCT
	w_class = ITEMSIZE_SMALL

/obj/item/device/contract_uplink/Initialize(var/mapload, var/mind)
	. = ..()
	hidden_uplink = new(src, mind)
	hidden_uplink.telecrystals = 0
	hidden_uplink.bluecrystals = 0
	hidden_uplink.nanoui_menu = 3

/obj/item/device/contract_uplink/attack_self(mob/user as mob)
	if (hidden_uplink)
		hidden_uplink.trigger(user)


//for revs to create their own central command reports
/obj/item/device/announcer
	name = "relay positioning device"
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	desc_antag = "This device allows you to create a single central command report. It has only one use."
	w_class = ITEMSIZE_SMALL

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

/obj/item/device/special_uplink
	name = "special uplink"
	desc = "A small device with knobs and switches."
	desc_antag = "This is hidden uplink! Use it in-hand to access the uplink interface and spend telecrystals to beam in items. Make sure to do it in private, it could look suspicious!"
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	flags = CONDUCT
	w_class = ITEMSIZE_SMALL
	 // Amount of starting telecrystals. Defaults to default amount if not set.
	var/starting_telecrystals
	/// Amount of starting bluecrystals, used to buy support/medical/gimmick items. Defaults to default amount if not set.
	var/starting_bluecrystals

/obj/item/device/special_uplink/New(var/loc, var/mind)
	..()
	hidden_uplink = new(src, mind)
	if(!starting_telecrystals)
		hidden_uplink.telecrystals = DEFAULT_TELECRYSTAL_AMOUNT
	else
		hidden_uplink.telecrystals = starting_telecrystals
	if(!starting_bluecrystals)
		hidden_uplink.bluecrystals = DEFAULT_BLUECRYSTAL_AMOUNT
	else
		hidden_uplink.bluecrystals = DEFAULT_BLUECRYSTAL_AMOUNT
	hidden_uplink.nanoui_menu = 1

/obj/item/device/special_uplink/attack_self(mob/user as mob)
	if(hidden_uplink)
		hidden_uplink.trigger(user)

/obj/item/device/special_uplink/ninja
	name = "infiltrator uplink"
	starting_telecrystals = 15

/obj/item/device/special_uplink/mercenary
	name = "milspec uplink"
	starting_telecrystals = 15

/obj/item/device/special_uplink/burglar
	name = "sponsored uplink"
	starting_telecrystals = 20

/obj/item/device/special_uplink/raider
	name = "underground uplink"
	starting_telecrystals = 3

/obj/item/device/special_uplink/rev
	name = "shortwave radio"
	desc = null // SBRs have no desc
	icon_state = "walkietalkie" // more incognito
	starting_telecrystals = DEFAULT_TELECRYSTAL_AMOUNT * 2
