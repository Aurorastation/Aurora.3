/datum/computer_file/program/civilian/cargoorder
	filename = "cargoorder"
	filedesc = "Cargo Order"
	extended_desc = "Application to Order Items from Cargo."
	program_icon_state = "request"
	program_key_icon_state = "yellow_key"
	size = 10
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL
	tgui_id = "CargoOrder"
	ui_auto_update = FALSE

	var/page = "main" //main - Main Menu, order - Order Page, item_details - Item Details Page, tracking - Tracking Page
	var/selected_category = null // Category that is currently selected
	var/selected_item = "" // Path of the currently selected item
	var/datum/cargo_order/co
	var/status_message //Status Message to be displayed to the user
	var/user_tracking_id = 0 //Tracking id of the user
	var/user_tracking_code = 0 //Tracking Code of the user

/datum/computer_file/program/civilian/cargoorder/ui_data(mob/user)	//Check if a cargo order exists. If not create a new one
	if(!co)
		var/datum/cargo_order/crord = new
		co = crord

	var/list/data = initial_data()

	//Pass the ID Data
	data["username"] = GetNameAndAssignmentFromId(user.GetIdCard())

	//Pass the list of all ordered items and the order value
	data["order_items"] = co.get_item_list()
	data["order_value"] = co.get_value(0)
	data["order_item_count"] = co.get_item_count()

	if(!selected_category)
		selected_category = SScargo.get_default_category()

	//Pass Data for Main page
	if(page == "main")
		//Pass all available categories and the selected category
		data["cargo_categories"] = SScargo.get_category_list()
		data["selected_category"] = selected_category

		//Pass a list of items in the selected category
		data["category_items"] = SScargo.get_items_for_category(selected_category)

	else if (page == "tracking")
		data["tracking_id"] = user_tracking_id
		data["tracking_code"] = user_tracking_code
		//If no tracking id / code is entered the page the enter them should be displayed
		if(!user_tracking_id || !user_tracking_code)
			data["tracking_status"] = "Incomplete Input"
		//If we have a tracking id / code, then try to find a order with mathing details
		else if(user_tracking_id && user_tracking_code)
			//Now, lets try to find a order with a matching id
			var/datum/cargo_order/co = SScargo.get_order_by_id(user_tracking_id)
			if(co)
				if(co.tracking_code == user_tracking_code)
					data["tracking_status"] = "Success"
					data["tracked_order"] = co.get_list()
					data["tracked_order_report"] = co.get_report_invoice()
				else
					data["tracking_status"] = "Invalid Tracking Code"
			else
				data["tracking_status"] = "Invalid Order"

	//Pass the current page
	data["page"] = page

	//Pass the status message along
	data["status_message"] = status_message

	data["handling_fee"] = SScargo.get_handlingfee()
	data["crate_fee"] = SScargo.get_cratefee()

	return data

/datum/computer_file/program/civilian/cargoorder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/obj/item/card/id/I = usr.GetIdCard()

	switch(action)
		//Send the order to cargo
		if("submit_order")
			if(!co.items.len)
				return TRUE //Only submit the order if there are items in it

			if(!I)
				status_message = "Unable to submit order. ID could not be located."
				return TRUE

			var/reason = sanitize(input(usr, "Reason:", "Why do you require this item?", "") as null|text)
			if(!reason)
				status_message = "Unable to submit order. No reason supplied."
				return TRUE

			co.set_submitted(GetNameAndAssignmentFromId(I), usr.character_id, reason)
			status_message = "Order submitted successfully. Order ID: [co.order_id] Tracking code: [co.get_tracking_code()]"

			co = null
			return TRUE

		//Add item to the order list
		if("add_item")
			var/datum/cargo_order_item/coi = new
			var/singleton/cargo_item/ci = SScargo.cargo_items[params["add_item"]]
			if(ci)
				coi.ci = ci
				coi.calculate_price()
				if(coi.price > 0)
					status_message = co.add_item(coi)
				else
					status_message = "Unable to add item [text2num(params["add_item"])] - Internal Error 601."
					LOG_DEBUG("Cargo Order: Warning - Attempted to order item [coi.ci.name] with invalid purchase price")
					qdel(coi)
			else
				status_message = "Unable to locate item in sales database - Internal Error 602."
				LOG_DEBUG("Cargo Order: Warning - Attempted to order item with non-existant id: [params["add_item"]]")
				qdel(coi)
			return TRUE

		//Remove item from the order list
		if("remove_item")
			status_message = co.remove_item(text2num(params["remove_item"]))
			return TRUE

		//Clear the items in the order list
		if("clear_order")
			status_message = "Order Cleared"
			qdel(co)
			co = new
			return TRUE

		if("page")
			page = params["page"]
			return TRUE

		//Tracking Stuff
		if("trackingid")
			var/trackingid = text2num(sanitize(input(usr, "Order ID:", "ID of the Order that you want to track", "") as null|text))
			if(trackingid)
				user_tracking_id = trackingid
			return TRUE

		if("trackingcode")
			var/trackingcode = text2num(sanitize(input(usr, "Tracking Code:", "Tracking Code of the Order that you want to track", "") as null|text))
			if(trackingcode)
				user_tracking_code = trackingcode
			return TRUE

		//Change the displayed item category
		if("select_category")
			selected_category = params["select_category"]
			return TRUE

		if("clear_message")
			status_message = null
			return TRUE
