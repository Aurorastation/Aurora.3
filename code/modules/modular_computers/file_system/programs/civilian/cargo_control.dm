/datum/computer_file/program/civilian/cargocontrol
	filename = "cargocontrol"
	filedesc = "Cargo Control"
	extended_desc = "Application to Control Cargo Orders"
	size = 2 //TODO: Increase this
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access_download = access_hop
	required_access_run = access_cargo
	nanomodule_path = /datum/nano_module/program/civilian/cargocontrol/

/datum/nano_module/program/civilian/cargocontrol/
	name = "Cargo Control"
	var/page = "main" //main - Main Menu, overview_submitted - Submitted Order Overview, overview_approved - Approved Order Overview, settings - Settings, details - order details
	var/last_user_name = "" //Name of the User that last used the computer
	var/status_message = null //A status message that can be displayed

/datum/nano_module/program/civilian/cargocontrol/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()
	
	post_signal("supply")

	//Send the page to display
	data["page"] = page

	//Pass the ID Data
	var/obj/item/weapon/card/id/user_id_card = user.GetIdCard()
	last_user_name = GetNameAndAssignmentFromId(user_id_card)
	data["username"] = last_user_name

	var/list/submitted_orders = SScargo.get_orders_by_status("submitted",1)
	data["submitted_orders"] = submitted_orders
	data["order_submitted_number"] = submitted_orders.len
	data["order_submitted_value"] = SScargo.get_orders_value_by_status("submitted",1)

	var/list/approved_orders = SScargo.get_orders_by_status("approved",1)
	data["approved_orders"] = approved_orders
	data["order_approved_number"] = approved_orders.len
	data["order_approved_value"] = SScargo.get_orders_value_by_status("approved",1)

	data["cargo_money"] = SScargo.get_cargo_money()

	//Shuttle Stuff
	var/datum/shuttle/ferry/supply/shuttle = SScargo.shuttle
	if(shuttle)
		data["shuttle_available"] = 1
		data["shuttle_has_arrive_time"] = shuttle.has_arrive_time()
		data["shuttle_eta_minutes"] = shuttle.eta_minutes()
		data["shuttle_can_launch"] = shuttle.can_launch()
		data["shuttle_can_cancel"] = shuttle.can_cancel()
		data["shuttle_can_force"] = shuttle.can_force()
		data["shuttle_at_station"] = shuttle.at_station()
		if(shuttle.docking_controller)
			data["shuttle_docking_status"] = shuttle.docking_controller.get_docking_status()
		else
			data["shuttle_docking_status"] = "error"
	else
		data["shuttle_available"] = 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cargo_control.tmpl", name, 500, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/civilian/cargocontrol/Topic(href, href_list)
	//TODO: Implement return message to notify user of whats going on

	if(!SScargo)
		world.log << "## ERROR: Eek. The SScargo controller datum is missing somehow."
		return
	var/datum/shuttle/ferry/supply/shuttle = SScargo.shuttle
	if (!shuttle)
		world.log << "## ERROR: Eek. The supply/shuttle datum is missing somehow."
		return
	if(..())
		return 1

	//Page switch between main, submitted, approved and settings
	if(href_list["page"])
		switch(href_list["page"])
			if("overview_submitted")
				page = "overview_submitted"
			if("overview_approved")
				page = "overview_approved"
			if("settings")
				page = "settings"
			if("details")
				page = "details"
			else
				page = "main"
		return 1
	
	//Show order details
	if(href_list["order_details"])
		return 1

	//Approve a order
	if(href_list["order_approve"])
		var/datum/cargo_order/co = SScargo.get_order_by_id(text2num(href_list["order_approve"]))
		if(co)
			var/message = SScargo.approve_order(co)
			if(message)
				status_message = message
		return 1

	//Reject a order
	if(href_list["order_reject"])
		var/datum/cargo_order/co = SScargo.get_order_by_id(text2num(href_list["order_reject"]))
		if(co)
			var/message = SScargo.reject_order(co)
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

	//Change Settings

/datum/nano_module/program/civilian/cargocontrol/proc/post_signal(var/command) //Old code right here - Used to send a refresh command to the status screens incargo

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)