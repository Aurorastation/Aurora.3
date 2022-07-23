/obj/machinery/orderterminal
	name = "Idris Ordering Terminal"
	desc = "An ordering terminal designed by Idris for quicker expedition."
	desc_info = "To edit the menu, select 'Toggle Lock' and swipe with an id with either kitchen or bar access. Afterwards click 'Toggle Lock' again to exit editting mode.\nAll credits from the machine will automatically go to the civilian account."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "kitchenterminal"
	anchored = 1
	idle_power_usage = 10
	var/machine_id = ""
	var/list/items = list()
	var/list/buying = list()
	var/sum = 0
	var/editmode = FALSE // Permits the menu to be changed
	var/unlocking = FALSE // Checks if the machine is waiting for an id to unlock it
	var/confirmorder = FALSE // Waits for an id to confirm an order
	var/receipt = ""
	var/ticket = ""
	var/destinationact = "Service"
	var/ticket_number = 1
	req_one_access = list(access_bar, access_kitchen) // Access to change the menu

/obj/machinery/orderterminal/Initialize()
	. = ..()
	machine_id = "Idris Ordering Terminal #[SSeconomy.num_financial_terminals++]"
	update_icon()

/obj/machinery/orderterminal/power_change()
	..()
	update_icon()

/obj/machinery/orderterminal/update_icon()
	cut_overlays()
	if(stat & NOPOWER)
		set_light(FALSE)
		return

	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "kitchenterminal-active", EFFECTS_ABOVE_LIGHTING_LAYER)
	add_overlay(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/orderterminal/process()
	if(stat & NOPOWER)
		cut_overlays()
		set_light(FALSE)
		return

/obj/machinery/orderterminal/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/orderterminal/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	if (!ui)
		ui = new(usr, src, "machinery-orderterminal-ordering", 450, 450, "Idris Ordering Terminal")
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
	flick("kitchenterminal-receipt",src)

/obj/machinery/orderterminal/proc/stamp_receipt(obj/item/paper/R) // Stamps the papers, made into a proc to avoid copy pasting too much
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Idris Ordering Terminal.</i>"

/obj/machinery/orderterminal/attackby(obj/O, mob/user)
	var/obj/item/card/id/I = O.GetID()
	if (!I)
		return
	if (!istype(O))
		return

	if(unlocking)
		if(check_access(I))
			to_chat(user, SPAN_NOTICE("You unlock \the [src]. Please return to the home screen."))
			editmode = TRUE
			unlocking = FALSE
		else
			to_chat(user, SPAN_WARNING("Access denied."))

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
				sum = 0
				receipt = ""
				ticket = ""
				to_chat(src.loc, SPAN_NOTICE("Transaction completed, please return to the home screen."))

// VUEUI below

/obj/machinery/orderterminal/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

	VUEUI_SET_CHECK_IFNOTSET(data["items"], items, ., data) // List of items that is on the menu
	VUEUI_SET_CHECK_IFNOTSET(data["price"], items, ., data) // the price of said items
	VUEUI_SET_CHECK_IFNOTSET(data["buying"], buying, ., data) // And the list with items the customer is buying
	VUEUI_SET_CHECK_IFNOTSET(data["sum"], sum, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_name"], "", ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_price"], 0, ., data)
	VUEUI_SET_CHECK(data["tmp_price"], max(0, data["tmp_price"]), ., data)
	if(data["tmp_price"] < 0)
		data["tmp_price"] = 0
		. = data
	VUEUI_SET_CHECK(data["editmode"], editmode, ., data)
	VUEUI_SET_CHECK(data["destinationact"], destinationact, ., data)

/obj/machinery/orderterminal/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["add"])
		if(!editmode)
			to_chat(src, SPAN_NOTICE("You don't have access to use this option."))
			return 0
		items[href_list["add"]["name"]] = href_list["add"]["price"]
		ui.data["items"][href_list["add"]["name"]] = href_list["add"]["price"]
		. = TRUE

	if(href_list["remove"])

		if(!editmode)
			to_chat(src, SPAN_NOTICE("You don't have access to use this option."))
			return 0
		items -= href_list["remove"]
		ui.data["items"] -= href_list["remove"]
		. = TRUE

	if(href_list["buy"])
		ui.data["buying"][href_list["buy"]["name"]] += href_list["buy"]["amount"]
		. = TRUE

	if(href_list["removal"])
		ui.data["buying"][href_list["removal"]["name"]] -= href_list["removal"]["amount"]
		. = TRUE

	if(href_list["clear"])
		var/buying = ui.data["buying"]
		for(var/name in buying)
			if(buying[name])
				buying[name] = 0
		. = TRUE

	if(href_list["confirm"])
		confirmorder = TRUE
		var/buying = ui.data["buying"]
		var/items = ui.data["items"]
		receipt += "<center><font size=\"4\"><b>Idris Food Terminal Receipt</b></font></br><img src = idrislogo.png></center><hr>"
		ticket += "<center><font size=\"4\"><b>Idris Food Terminal Ticket</b></font></br><img src = idrislogo.png></center><hr>"
		for(var/name in buying)
			if(buying[name])
				sum += items[name] * buying[name]
				receipt += "<b>[name]</b>: [buying[name]] x [items[name]]c: [items[name] * buying[name]]c<br>"
				ticket += "<b>[name]</b>: [buying[name]]<br>"
		receipt += "<hr><b>Total:</b> [sum]c"
		ticket += "<hr><b>Total:</b> [sum]c"
		ui.data["sum"] = sum
		ui.activeui = "machinery-orderterminal-orderconfirmation"
		. = TRUE

	if(href_list["return"])
		sum = 0
		receipt = ""
		ticket = ""
		unlocking = FALSE
		confirmorder = FALSE
		ui.activeui = "machinery-orderterminal-ordering"
		. = TRUE

	if(href_list["locking"])
		if(editmode)
			editmode = FALSE
			to_chat(src, SPAN_NOTICE("Device Locked."))
			SSvueui.check_uis_for_change(src)
			return 0
		if(!editmode)
			unlocking = TRUE
			ui.activeui = "machinery-orderterminal-editconfirmation"
		. = TRUE

	. = TRUE
	SSvueui.check_uis_for_change(src)
