/obj/machinery/orderterminal
	name = "Idris Ordering Terminal"
	desc = "An ordering terminal designed by Idris for quicker expedition."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "kitchenterminal"
	anchored = 1
	idle_power_usage = 10
	var/machine_id = ""

	var/list/items = list()
	var/list/items_to_price = list()
	var/list/buying = list()

	var/new_item = ""
	var/new_price = 0

	var/sum = 0
	var/editmode = FALSE // Permits the menu to be changed
	var/confirmorder = FALSE // Waits for an id to confirm an order
	var/receipt = ""
	var/ticket = ""
	var/destinationact = "Service"
	var/ticket_number = 1
	req_one_access = list(ACCESS_BAR, ACCESS_KITCHEN) // Access to change the menu

/obj/machinery/orderterminal/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "To edit the menu, select 'Toggle Lock' while wearing an ID with kitchen access."
	. += "All credits from the machine will automatically go to the civilian account."

/obj/machinery/orderterminal/Initialize()
	. = ..()
	machine_id = "Idris Ordering Terminal #[SSeconomy.num_financial_terminals++]"
	update_icon()

/obj/machinery/orderterminal/power_change()
	..()
	update_icon()

/obj/machinery/orderterminal/update_icon()
	ClearOverlays()
	if(stat & NOPOWER)
		set_light(FALSE)
		return

	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "kitchenterminal-active", plane = EFFECTS_ABOVE_LIGHTING_PLANE)
	AddOverlays(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/orderterminal/process()
	if(stat & NOPOWER)
		ClearOverlays()
		set_light(FALSE)
		return

/obj/machinery/orderterminal/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/orderterminal/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OrderTerminal", "Idris Ordering Terminal", 450, 450)
		ui.open()

/obj/machinery/orderterminal/proc/print_receipt() // Print the receipt followed by the order ticket
	var/obj/item/paper/R = new(usr.loc)
	var/receiptname = "Receipt: [machine_id]"
	R.set_content_unsafe(receiptname, receipt, sum)
	stamp_receipt(R)
	// And now we do it but for the ticket.
	var/obj/item/paper/T = new(usr.loc)
	var/tickettname = "Order ticket: [ticket_number]"
	ticket_number++
	T.set_content_unsafe(tickettname, ticket, sum)
	stamp_receipt(T)

/obj/machinery/orderterminal/proc/stamp_receipt(obj/item/paper/R) // Stamps the papers, made into a proc to avoid copy pasting too much
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.AddOverlays(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Idris Ordering Terminal.</i>"

/obj/machinery/orderterminal/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/card/id/I = attacking_item.GetID()
	if (!I)
		return
	if (!istype(attacking_item))
		return

	else if (confirmorder)
		var/transaction_amount = sum
		var/transaction_purpose = "Idris Ordering Terminal order."
		var/transaction_terminal = machine_id
		if(sum > 0) // it will just get denied if the order is 0 credits. We still need the id regardless for the name
			var/transaction = SSeconomy.transfer_money(I.associated_account_number, SSeconomy.get_department_account(destinationact)?.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)
			if(transaction)
				to_chat(user,"[icon2html(src, user)]<span class='warning'>[transaction].</span>")
			else
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
				src.visible_message("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes.")
				ticket += "<br><b>Customer:</b> [I.registered_name]"
				receipt += "<br><b>Customer:</b> [I.registered_name]"
				print_receipt()
				clear_order()

/obj/machinery/orderterminal/ui_data(mob/user)
	var/list/data = list()

	data["items"] = items
	data["buying"] = buying
	data["sum"] = sum
	data["new_item"] = new_item
	data["new_price"] = new_price
	data["editmode"] = editmode
	data["destinationact"] = destinationact

	return data

/obj/machinery/orderterminal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("add")
			if(!editmode)
				to_chat(usr, SPAN_NOTICE("You don't have access to use this option."))
				return FALSE
			items += list(list("name" = new_item, "price" = new_price))
			items_to_price[new_item] = new_price
			. = TRUE

		if("remove")
			if(!editmode)
				to_chat(usr, SPAN_NOTICE("You don't have access to use this option."))
				return FALSE
			items -= params["remove"]
			items_to_price -= params["remove"]
			. = TRUE

		if("buy")
			for(var/list/L in buying)
				if(L["name"] == params["buying"])
					L["amount"]++
					return TRUE
			buying += list(list("name" = params["buying"], "amount" = params["amount"]))
			. = TRUE

		if("removal")
			for(var/list/L in buying)
				if(L["name"] == params["removal"])
					if(L["amount"] > 1)
						L["amount"]--
					else
						buying -= L
			. = TRUE

		if("clear")
			clear_order()
			. = TRUE

		if("set_new_price")
			new_price = params["set_new_price"]
			. = TRUE

		if("set_new_item")
			new_item = params["set_new_item"]
			. = TRUE

		if("confirm")
			confirmorder = TRUE
			receipt += "<center><font size=\"4\"><b>Idris Food Terminal Receipt</b></font></br><img src = idrislogo.png></center><hr>"
			ticket += "<center><font size=\"4\"><b>Idris Food Terminal Ticket</b></font></br><img src = idrislogo.png></center><hr>"
			for(var/list/bought_item in buying)
				var/item_name = bought_item["name"]
				var/item_amount = bought_item["amount"]
				var/item_price = items_to_price[item_name]
				sum += item_price

				receipt += "<b>[name]</b>: [item_name] x[item_amount] at [item_price]cr each<br>"
				ticket += "<b>[name]</b>: [item_name] x[item_amount] at [item_price]cr each<br>"
			receipt += "<hr><b>Total:</b> [sum]电"
			ticket += "<hr><b>Total:</b> [sum]电"
			sum = sum
			. = TRUE

		if("locking")
			var/obj/item/card/id/I = usr.GetIdCard()
			if(!istype(I))
				return
			if(check_access(I))
				editmode = !editmode
				to_chat(usr, SPAN_NOTICE("Device [editmode ? "un" : ""]locked."))
			. = TRUE

/obj/machinery/orderterminal/proc/clear_order()
	buying.Cut()
	sum = 0
	receipt = ""
	ticket = ""
	confirmorder = FALSE
