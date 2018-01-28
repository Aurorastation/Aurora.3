/datum/computer_file/program/civilian/cargodelivery
	filename = "cargodelivery"
	filedesc = "Cargo Delivery"
	extended_desc = "Application to Control Delivery and Payment of Cargo orders"
	size = 12
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access_download = access_hop
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/civilian/cargodelivery/

/datum/nano_module/program/civilian/cargodelivery/
	name = "Cargo Delivery"
	var/page = "overview_main" //overview_main - Main Menu, order_overview - Overview page for a specific order, order_payment - Payment page for a specific order
	var/last_user_name = "" //Name of the User that last used the computer
	var/status_message = null //A status message that can be displayed
	var/list/order_details = list() //Order Details for the order
	var/datum/cargo_order/co
	var/mod_mode = 1 //If it can be used to pay for orders

/datum/nano_module/program/civilian/cargodelivery/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	if(program && program.computer)
		data["have_id_slot"] = !!program.computer.card_slot
		data["have_printer"] = !!program.computer.nano_printer
		data["authenticated"] = program.can_run(user)
		if(!program.computer.card_slot || !program.computer.network_card)
			mod_mode = 0 //We can't pay for orders when there is no card reader and no network card

	if(program && program.computer && program.computer.card_slot)
		var/obj/item/weapon/card/id/id_card = program.computer.card_slot.stored_card
		data["has_id"] = !!id_card
		data["id_account_number"] = id_card ? id_card.associated_account_number : null
		//data["id_rank"] = id_card && id_card.assignment ? id_card.assignment : "Unassigned"
		data["id_owner"] = id_card && id_card.registered_name ? id_card.registered_name : "-----"
		data["id_name"] = id_card ? id_card.name : "-----"
		last_user_name = data["id_owner"]

	//Pass the shipped orders
	var/list/shipped_orders = SScargo.get_orders_by_status("shipped",1)
	data["order_shipped_list"] = shipped_orders
	data["order_shipped_number"] = shipped_orders.len
	data["order_shipped_value"] = SScargo.get_orders_value_by_status("shipped",1)

	//Pass along the order details
	data["order_details"] = order_details

	//Pass the current page
	data["page"] = page

	//Pass the status message along
	data["status_message"] = status_message

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cargo_delivery.tmpl", name, 500, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/datum/nano_module/program/civilian/cargodelivery/Topic(href, href_list)
	if(..())
		return 1

	//Everyone can pay
	if(href_list["pay"])
		if(order_details["payment_status"] == 1)
			status_message = "Unable to Pay - Order has already been paid."
			return 1

		if(program && program.computer && program.computer.card_slot && program.computer.network_card)
			var/transaction_amount = order_details["price_customer"];
			var/transaction_purpose = "Cargo Order #[order_details["order_id"]]";

			var/obj/item/weapon/card/id/id_card = program.computer.card_slot.stored_card

			if(!id_card || !id_card.registered_name)
				status_message = "Card Error: Invalid ID Card in Card Reader"
				return 1

			var/datum/money_account/D = get_account(id_card.associated_account_number)
			var/attempt_pin
			if(D.security_level)
				attempt_pin = input("Enter pin code", "EFTPOS transaction") as num
				D = null
			D = attempt_account_access(id_card.associated_account_number, attempt_pin, 2)
			if(D)
				if(!D.suspended)
					if(transaction_amount <= D.money)
						playsound(program.computer, 'sound/machines/chime.ogg', 50, 1)

						//transfer the money
						D.money -= transaction_amount
						SScargo.supply_account.money += transaction_amount

						//create entries in the two account transaction logs
						var/datum/transaction/T = new()
						T.target_name = "[SScargo.supply_account.owner_name]"
						T.purpose = transaction_purpose
						if(transaction_amount > 0)
							T.amount = "([transaction_amount])"
						else
							T.amount = "[transaction_amount]"
						T.source_terminal = "Modular Computer #[program.computer.network_card.identification_id]"
						T.date = current_date_string
						T.time = worldtime2text()
						D.transaction_log.Add(T)
						//
						T = new()
						T.target_name = D.owner_name
						T.purpose = transaction_purpose
						T.amount = "[transaction_amount]"
						T.source_terminal = "Modular Computer #[program.computer.network_card.identification_id]"
						T.date = current_date_string
						T.time = worldtime2text()
						SScargo.supply_account.transaction_log.Add(T)

						//Get the cargo order and update its status to delivered and paid
						status_message = SScargo.deliver_order(co,id_card.registered_name)
						order_details = co.get_list()

						return 1
					else
						status_message = "You don't have that much money!"
						return 1
				else
					status_message = "Your account has been suspended."
					return 1
			else
				status_message = "Unable to access account. Check security settings and try again."
				return 1
		else
			status_message = "Unable to pay - Network Card or Cardreader Missing"
			return 1


	//But only cargo can switch between the pages
	var/mob/user = usr
	if(!istype(user))
		return
	var/obj/item/weapon/card/id/I = user.GetIdCard()
	if(!istype(I) || !I.registered_name || !(access_cargo in I.access) || issilicon(user))
		to_chat(user, "Authentication error: Unable to locate ID with appropriate access to allow this operation.")
		return

	if(href_list["page"])
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
		return 1
