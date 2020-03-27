/datum/computer_file/program/civilian/cargocontrol
	filename = "cargocontrol"
	filedesc = "Cargo Control"
	extended_desc = "Application to Control Cargo Orders"
	size = 12
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access_download = access_hop
	required_access_run = access_cargo
	usage_flags = PROGRAM_CONSOLE | PROGRAM_TELESCREEN
	nanomodule_path = /datum/nano_module/program/civilian/cargocontrol/

/datum/nano_module/program/civilian/cargocontrol/
	name = "Cargo Control"
	var/page = "overview_main" //overview_main - Main Menu, overview_submitted - Submitted Order Overview, overview_approved - Approved Order Overview, settings - Settings, details - order details, bounties - centcom bounties
	var/last_user_name = "" //Name of the User that last used the computer
	var/status_message = null //A status message that can be displayed
	var/list/order_details = list() //Order Details for the order
	var/list/shipment_details = list() //Shipment Details for a selected shipment

/datum/nano_module/program/civilian/cargocontrol/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()
	var/obj/item/modular_computer/console = host

	post_signal("supply")

	//Send the page to display
	data["page"] = page
	//Send the status message
	data["status_message"] = status_message

	//Pass the ID Data
	var/obj/item/card/id/user_id_card = user.GetIdCard()
	last_user_name = GetNameAndAssignmentFromId(user_id_card)
	data["username"] = last_user_name

	var/list/submitted_orders = SScargo.get_orders_by_status("submitted",1)
	data["order_submitted_number"] = submitted_orders.len
	data["order_submitted_value"] = SScargo.get_orders_value_by_status("submitted",1)
	data["order_submitted_suppliers"] = SScargo.get_order_suppliers_by_status("submitted",1)
	data["order_submitted_shuttle_time"] = SScargo.get_pending_shipment_time("submitted")
	data["order_submitted_shuttle_price"] = SScargo.get_pending_shipment_cost("submitted")
	if(page == "overview_submitted")
		data["order_list"] = submitted_orders

	var/list/approved_orders = SScargo.get_orders_by_status("approved",1)
	data["order_approved_number"] = approved_orders.len
	data["order_approved_value"] = SScargo.get_orders_value_by_status("approved",1)
	data["order_approved_suppliers"] = SScargo.get_order_suppliers_by_status("approved",1)
	data["order_approved_shuttle_time"] = SScargo.get_pending_shipment_time("approved")
	data["order_approved_shuttle_price"] = SScargo.get_pending_shipment_cost("approved")
	if(page == "overview_approved")
		data["order_list"] = approved_orders

	var/list/shipped_orders = SScargo.get_orders_by_status("shipped",1)
	data["order_shipped_number"] = shipped_orders.len
	data["order_shipped_value"] = SScargo.get_orders_value_by_status("shipped",1)
	if(page == "overview_shipped")
		data["order_list"] = shipped_orders

	var/list/delivered_orders = SScargo.get_orders_by_status("delivered",1)
	data["order_delivered_number"] = shipped_orders.len
	data["order_delivered_value"] = SScargo.get_orders_value_by_status("delivered",1)
	if(page == "overview_delivered")
		data["order_list"] = delivered_orders

	if(page == "order_details")
		data["order_details"] = order_details

	if(page == "overview_shipments")
		data["shipment_list"] = SScargo.get_shipment_list()

	if(page == "shipment_details")
		data["shipment_details"] = shipment_details

	data["cargo_money"] = SScargo.get_cargo_money()
	data["handling_fee"] = SScargo.get_handlingfee()
	data["bounties"] = SScargo.get_bounty_list()

	if(console)
		data["have_printer"] = !!console.nano_printer
	else
		data["have_printer"] = 0

	//Shuttle Stuff
	var/datum/shuttle/autodock/ferry/supply/shuttle = SScargo.shuttle
	if(shuttle)
		data["shuttle_available"] = 1
		data["shuttle_has_arrive_time"] = shuttle.has_arrive_time()
		data["shuttle_eta_minutes"] = shuttle.eta_minutes()
		data["shuttle_can_launch"] = shuttle.can_launch()
		data["shuttle_can_cancel"] = shuttle.can_cancel()
		data["shuttle_can_force"] = shuttle.can_force()
		data["shuttle_at_station"] = shuttle.at_station()
		if(shuttle.active_docking_controller)
			data["shuttle_docking_status"] = shuttle.active_docking_controller.get_docking_status()
		else
			data["shuttle_docking_status"] = "error"
	else
		data["shuttle_available"] = 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cargo_control.tmpl", name, 850, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/civilian/cargocontrol/Topic(href, href_list)
	var/datum/shuttle/autodock/ferry/supply/shuttle = SScargo.shuttle
	var/obj/item/modular_computer/console = host
	if (!shuttle)
		world.log <<  "## ERROR: Eek. The supply/shuttle datum is missing somehow."
		return
	if(..())
		return 1

	//Page switch between main, submitted, approved and settings
	if(href_list["page"])
		switch(href_list["page"])
			if("overview_main")
				page = "overview_main" //Main overview page with links to the different sub overview pages - submitted, approved, shipped
			if("overview_submitted")
				page = "overview_submitted" //Overview page listing the orders that have been submitted with options to view them, approve them and reject them
			if("overview_approved")
				page = "overview_approved" //Overview page listing the current shuttle price and time as well as orders that have been approved, with options to view the details
			if("overview_shipped")
				page = "overview_shipped" //Overview page listing the orders that have been shipped to the station but not delivered
			if("overview_delivered")
				page = "overview_delivered" //Overview page listing the orders that have been delivered
			if("order_details")
				page = "order_details" //Details page for a specific order - Lists the contents of the orde with the suppliers, prices and required access levels
				//Fetch the order details and store it for the order. No need to fetch it again every 2 seconds
				var/datum/cargo_order/co = SScargo.get_order_by_id(text2num(href_list["order_details"]))
				order_details = co.get_list()
			if("overview_shipments") //Overview of the shipments to / from the station
				page = "overview_shipments"
			if("shipment_details") //Details of a Shipment to / from the station
				page = "shipment_details"
			if("settings")
				page = "settings" //Settings page that allows to tweak various settings such as the cargo handling fee
			if("bounties")
				page = "bounties" //Page listing the currently available centcom bounties
			else
				page = "overview_main" //fall back to overview_main if a unknown page has been supplied
		return 1

	//Approve a order
	if(href_list["order_approve"])
		var/datum/cargo_order/co = SScargo.get_order_by_id(text2num(href_list["order_approve"]))
		if(co)
			var/message = co.set_approved(last_user_name)
			if(message)
				status_message = message
		return 1

	//Reject a order
	if(href_list["order_reject"])
		var/datum/cargo_order/co = SScargo.get_order_by_id(text2num(href_list["order_reject"]))
		if(co)
			var/message = co.set_rejected()
			if(message)
				status_message = message
		return 1

	//Send shuttle
	if(href_list["shuttle_send"])
		var/message = SScargo.shuttle_call(last_user_name)
		if(message)
			status_message = message
		return 1

	//Cancel shuttle
	if(href_list["shuttle_cancel"])
		var/message = SScargo.shuttle_cancel()
		if(message)
			status_message = message
		return 1

	//Force shuttle
	if(href_list["shuttle_force"])
		var/message = SScargo.shuttle_force()
		if(message)
			status_message = message
		return 1

	//Clear Status Message
	if(href_list["clear_message"])
		status_message = null
		return 1
	//Change the handling fee
	if(href_list["handling_fee"])
		var/handling_fee = sanitize(input(usr,"Handling Fee:","Set the new handling fee?",SScargo.get_handlingfee()) as null|text)
		status_message = SScargo.set_handlingfee(text2num(handling_fee))
		return 1

	//Claim a bounty
	if(href_list["claim_bounty"])
		for(var/datum/bounty/b in SScargo.bounties_list)
			if(b.name == href_list["claim_bounty"])
				if(b.claim())
					status_message = "Bounty for [b.name] claimed successfully"
				else
					status_message = "Could not claim Bounty for [b.name]"
				return
	//Print functions
	if(href_list["order_print"])
		//Get the order
		var/datum/cargo_order/co = SScargo.get_order_by_id(text2num(href_list["order_print"]))
		if(co && console && console.nano_printer)
			if(!console.nano_printer.print_text(co.get_report_invoice(),"Order Invoice #[co.order_id]"))
				to_chat(usr,"<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
				return
			else
				console.visible_message("<span class='notice'>\The [console] prints out paper.</span>")
	if(href_list["shipment_print"])
		var/datum/cargo_shipment/cs = SScargo.get_shipment_by_id(text2num(href_list["shipment_print"]))
		if(cs && cs.completed && console && console.nano_printer)
			var/obj/item/paper/P = console.nano_printer.print_text(cs.get_invoice(),"Shipment Invoice #[cs.shipment_num]")
			if(!P)
				to_chat(usr,"<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
				return
			else
				//stamp the paper
				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-cent"
				if(!P.stamped)
					P.stamped = new
				P.stamped += /obj/item/stamp
				P.add_overlay(stampoverlay)
				P.stamps += "<HR><i>This paper has been stamped by the Shipping Server.</i>"
				console.visible_message("<span class='notice'>\The [console] prints out paper.</span>")
	if(href_list["bounty_print"])
		if(console && console.nano_printer)
			var/text = "<h2>Nanotrasen Cargo Bounties</h2></br>"
			for(var/datum/bounty/B in SScargo.bounties_list)
				if(B.claimed)
					continue
				text += "<h3>[B.name]</h3>"
				text += "<ul><li>Reward: [B.reward_string()]</li>"
				text += "<li>Completed: [B.completion_string()]</li></ul>"
			if(!console.nano_printer.print_text(text,"paper - Bounties"))
				to_chat(usr,"<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
				return
			else
				console.visible_message("<span class='notice'>\The [console] prints out paper.</span>")


/datum/nano_module/program/civilian/cargocontrol/proc/post_signal(var/command) //Old code right here - Used to send a refresh command to the status screens incargo

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)