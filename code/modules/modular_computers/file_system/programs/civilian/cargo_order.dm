/datum/computer_file/program/civilian/cargoorder
	filename = "cargoorder"
	filedesc = "Cargo Order"
	extended_desc = "Application to Order Items from Cargo"
	size = 10
	requires_ntnet = 1
	available_on_ntnet = 1
	usage_flags = PROGRAM_LAPTOP | PROGRAM_TELESCREEN | PROGRAM_CONSOLE
	nanomodule_path = /datum/nano_module/program/civilian/cargoorder/

/datum/nano_module/program/civilian/cargoorder/
	name = "Cargo Order"
	var/page = "main" //main - Main Menu, order - Order Page, item_details - Item Details Page, tracking - Tracking Page
	var/selected_category = "" // Category that is currently selected
	var/selected_item = "" // Path of the currently selected item
	var/datum/cargo_order/co
	var/last_user_name = "" //Name of the user that used the program
	var/status_message = null //Status Message to be displayed to the user
	var/user_tracking_id = 0 //Tracking id of the user
	var/user_tracking_code = 0 //Tracking Code of the user

/datum/nano_module/program/civilian/cargoorder/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	//Check if a cargo order exists. If not create a new one
	if(!co)
		var/datum/cargo_order/crord = new
		co = crord
	
	var/list/data = host.initial_data()

	//Pass the ID Data
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	if(!user_id_card)
		last_user_name = "Unknown"
	else
		last_user_name = user_id_card.registered_name


	data["username"] = last_user_name

	//Pass the list of all ordered items and the order value
	data["order_items"] = co.get_item_list()
	data["order_value"] = co.get_value(0)
	data["order_item_count"] = co.get_item_count()
	data["order_shuttle_fee"] = co.get_max_shipment_cost()

	//Pass Data for Main page
	if(page == "main")
		//Pass all available categories and the selected category
		data["cargo_categories"] = SScargo.get_category_list()
		data["selected_category"] = selected_category

		//Pass a list of items in the selected category
		data["category_items"] = SScargo.get_items_for_category(selected_category)

	//Pass Data for Item Details Page
	else if(page == "item_details")
		var/datum/cargo_item/ci = SScargo.cargo_items[selected_item]
		if(ci)
			data["item_details"] = ci.get_list()

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
					data["tracked_order_report"] = co.get_report()
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

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cargo_order.tmpl", name, 500, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/civilian/cargoorder/Topic(href, href_list)
	if(..())
		return 1

	//Send the order to cargo
	if(href_list["submit_order"])
		if(co.items.len == 0)
			return 1 //Only submit the order if there are items in it

		if(last_user_name == "Unknown")
			status_message = "Unable to submit order. ID could not be located"
			return 1

		var/reason = sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text)
		if(!reason)
			status_message = "Unable to submit order. No reason supplied."
			return 1

		co.customer = last_user_name
		co.reason = reason
		SScargo.submit_order(co)
		status_message = "Order submitted successfully. Order ID: [co.order_id] Tracking code: [co.get_tracking_code()]" 
		//TODO: Print a list with the order data
		co = null
		return 1

	//Add item to the order list
	if(href_list["add_item"])
		var/datum/cargo_order_item/coi = new
		coi.ci = SScargo.cargo_items[href_list["add_item"]]
		coi.supplier = href_list["supplier"]
		//Check if the selected supplier exists for the item and get the price for the supplier
		var/supplier_details = coi.ci.suppliers[coi.supplier]
		if(supplier_details)
			coi.cs = SScargo.get_supplier_by_name(coi.supplier)
			coi.calculate_price()
			if(coi.price > 0)
				status_message = co.add_item(coi)
			else
				status_message = "Unable to add item [coi.ci.name] - Internal Error 602."
				log_debug("Cargo Order: Warning - Attempted to order item [coi.ci.name] from supplier [href_list["supplier"]] with invalid purchase price")
				qdel(coi)
		else
			status_message = "Unable to add item [coi.ci.name] - Internal Error 605."
			log_debug("Cargo Order: Warning - Attempted to order item [coi.ci.name] from non existant supplier [href_list["supplier"]]")
			qdel(coi)

		//Reset page to main page - TODO: Maybe add a way to disable jumping back to the main page - Commented out for now
		//page = "main"
		//selected_item = ""
		return 1
	
	//Remove item from the order list
	if(href_list["remove_item"])
		status_message = co.remove_item(text2num(href_list["remove_item"]))
		return 1

	//Clear the items in the order list
	if(href_list["clear_order"])
		status_message = "Order Cleared"
		qdel(co)
		co = new
		return 1

	//Change the selected page
	if(href_list["item_details"])
		page = "item_details"
		selected_item = href_list["item_details"]
		return 1
	if(href_list["page"])
		page = href_list["page"]
		return 1
	//Tracking Stuff
	if(href_list["trackingid"])
		var/trackingid = text2num(sanitize(input(usr,"Order ID:","ID of the Order that you want to track","") as null|text))
		if(trackingid)
			user_tracking_id = trackingid
		return 1
	if(href_list["trackingcode"])
		var/trackingcode = text2num(sanitize(input(usr,"Tracking Code:","Tracking Code of the Order that you want to track","") as null|text))
		if(trackingcode)
			user_tracking_code = trackingcode
		return 1
	//Change the displayed item category
	if(href_list["select_category"])
		selected_category = href_list["select_category"]
		return 1
	
	if(href_list["clear_message"])
		status_message = null
		return 1