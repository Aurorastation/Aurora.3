/datum/computer_file/program/civilian/cargodelivery
	filename = "cargodelivery"
	filedesc = "Cargo Delivery"
	extended_desc = "Application to Control Delivery and Payment of Cargo orders."
	program_icon_state = "supply"
	program_key_icon_state = "yellow_key"
	size = 6
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_download = access_hop
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/civilian/cargodelivery

/datum/nano_module/program/civilian/cargodelivery
	name = "Cargo Delivery"
	var/page = "overview_main" //overview_main - Main Menu, order_overview - Overview page for a specific order, order_payment - Payment page for a specific order
	var/status_message //A status message that can be displayed
	var/list/order_details = list() //Order Details for the order
	var/datum/cargo_order/co
	var/mod_mode = TRUE //If it can be used to pay for orders

/datum/nano_module/program/civilian/cargodelivery/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = TRUE, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	if(program && program.computer)
		data["have_id_slot"] = !!program.computer.card_slot
		data["have_printer"] = !!program.computer.nano_printer
		data["authenticated"] = program.can_run(user)
		if(!program.computer.card_slot || !program.computer.network_card)
			mod_mode = FALSE //We can't pay for orders when there is no card reader or no network card

	if(program && program.computer && program.computer.card_slot)
		var/obj/item/card/id/id_card = program.computer.card_slot.stored_card
		data["has_id"] = !!id_card
		data["id_account_number"] = id_card ? id_card.associated_account_number : null
		data["id_owner"] = id_card && id_card.registered_name ? id_card.registered_name : "-----"
		data["id_name"] = id_card ? id_card.name : "-----"

	//Pass the shipped orders
	data["order_list"] = SScargo.get_orders_by_status("shipped",1) + SScargo.get_orders_by_status("approved",1)

	//Pass along the order details
	data["order_details"] = order_details

	//Pass the current page
	data["page"] = page

	//Pass the status message along
	data["status_message"] = status_message

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cargo_delivery.tmpl", name, 500, 600, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)


/datum/nano_module/program/civilian/cargodelivery/Topic(href, href_list)
	if(..())
		return TRUE

	var/obj/item/card/id/I = usr.GetIdCard()

	//Check if we want to deliver or pay
	//If we are at the status shipped, then only the confirm delivery and pay button should be shown (deliver)
	//If the status is not shipped, then only show the pay button as we can not confirm that it has been paid so far
	//Everyone can pay / confirm delivery
	if(href_list["deliver"])
		order_details = co.get_list()

		//Check if its already delivered
		if(order_details["status"] == "delivered" && !order_details["needs_payment"])
			status_message = "Unable to Deliver - Order has already been delivered and paid for."
			return TRUE

		if(program && program.computer && program.computer.card_slot && program.computer.network_card)
			var/using_id = FALSE
			var/obj/item/card/id/id_card
			if(program.computer.card_slot?.stored_card)
				using_id = TRUE
				id_card = program.computer.card_slot.stored_card
			if(!id_card?.registered_name)
				using_id = FALSE
				status_message = "Card Error: Invalid ID Card in Card Reader"

			var/obj/item/spacecash/ewallet/charge_card
			if(!using_id)
				if(isliving(usr))
					var/mob/living/L = usr
					charge_card = L.get_active_hand()
				if(!istype(charge_card))
					return TRUE

			//Check if a payment is required
			if(order_details["needs_payment"])
				var/transaction_amount = order_details["price_customer"]
				var/transaction_purpose = "Cargo Order #[order_details["order_id"]]"
				var/transaction_terminal = "Modular Computer #[program.computer.network_card.identification_id]"

				if(using_id)
					var/status = SSeconomy.transfer_money(id_card.associated_account_number, SScargo.supply_account.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)
					if(status)
						status_message = status
						return TRUE
				else
					if(charge_card.worth < transaction_amount)
						status_message = "Insufficient Funds in Charge Card"
						return TRUE
					if(!SSeconomy.charge_to_account(SScargo.supply_account.account_number, charge_card.owner_name, transaction_purpose, transaction_terminal, transaction_amount))
						status_message = "Account Error: Failed to Deposit Credits into Cargo Account"
						return TRUE
					charge_card.worth -= transaction_amount

				playsound(program.computer, 'sound/machines/chime.ogg', 50, TRUE)

				//Check if we have delivered it aswell or only paid
				if(order_details["status"] == "shipped")
					status_message = co.set_delivered(GetNameAndAssignmentFromId(I), usr.character_id, 1)
				else
					status_message = co.set_paid(GetNameAndAssignmentFromId(I), usr.character_id)
				order_details = co.get_list()

			else
				//If a payment is not needed and we are at the status shipped, then confirm the delivery
				if(order_details["status"] == "shipped")
					playsound(program.computer, 'sound/machines/chime.ogg', 50, TRUE)
					status_message = co.set_delivered(GetNameAndAssignmentFromId(I), usr.character_id, 0)
			order_details = co.get_list()
		else
			status_message = "Unable to process - Network Card or Cardreader Missing"
			return TRUE


	//But only cargo can switch between the pages
	if(!istype(I) || !I.registered_name || !(access_cargo in I.access) || issilicon(usr))
		to_chat(usr, SPAN_WARNING("Authentication error: Unable to locate ID with appropriate access to allow this operation."))
		return

	if(href_list["page"])
		status_message = null //Null the previous status, so its not confusing
		switch(href_list["page"])
			if("overview_main")
				page = "overview_main" //Main overview page that shows all the orders with the status shipped
			if("order_overview")
				page = "order_overview" //Details page for a specific order - Lists the contents of the orde with the suppliers, prices and required access levels
				//Fetch the order details and store it for the order. No need to fetch it again every 2 seconds
				co = SScargo.get_order_by_id(text2num(href_list["order_overview"]))
				order_details = co.get_list()
			if("order_payment")
				page = "order_payment"
				co = SScargo.get_order_by_id(text2num(href_list["order_payment"]))
				order_details = co.get_list()
			else
				page = "overview_main" //fall back to overview_main if a unknown page has been supplied
		return TRUE
