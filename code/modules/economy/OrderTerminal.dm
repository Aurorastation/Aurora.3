/obj/machinery/orderterminal
	name = "Idris Ordering Terminal"
	desc = "An ordering terminal designed by Idris for quicker expedition."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	var/machine_id = ""
	var/list/items = list()
	var/sum = 0
	var/editmode = 0
	var/unlocking = 0
	var/receipt = ""
	var/ticket = ""
	var/destinationact = "Civilian"
	var/ticket_number = 1
	var/order_cost = 0
	req_one_access = list(access_bar, access_kitchen)

/obj/machinery/orderterminal/Initialize()
	. = ..()
	machine_id = "Idris Ordering Terminal #[SSeconomy.num_financial_terminals++]"

/obj/machinery/orderterminal/AltClick(var/mob/user)
	var/obj/item/card/id/I = user.GetIdCard()
	if(istype(I) && (access_heads in I.access))
		editmode = 1
		to_chat(user, SPAN_NOTICE("Command access granted."))
		SSvueui.check_uis_for_change(src)

// /obj/machinery/orderterminal/proc/print_reference()
// 	var/obj/item/paper/R = new(src.loc)
// 	var/pname = "Reference: [machine_id]"
// 	var/info = "<b>[machine_id] reference</b><br><br>"
// 	info += "Access code: [access_code]<br><br>"
// 	info += "<b>Do not lose or misplace this code.</b><br>"
// 	R.set_content_unsafe(pname, info)

// 	//stamp the paper
// 	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
// 	stampoverlay.icon_state = "paper_stamp-cent"
// 	if(!R.stamped)
// 		R.stamped = new
// 	R.stamped += /obj/item/stamp
// 	R.add_overlay(stampoverlay)
// 	R.stamps += "<HR><i>This paper has been stamped by the Head of Personnel's desk.</i>"
// 	var/obj/item/smallDelivery/D = new(R.loc)
// 	R.forceMove(D)
// 	D.wrapped = R
// 	D.name = "small parcel - 'Quik Pay access code'"

/obj/machinery/orderterminal/power_change()
	..()
	update_icon()

/obj/machinery/orderterminal/update_icon()
	cut_overlays()
	if(stat & NOPOWER)
		set_light(FALSE)
		return

	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "atm-active", EFFECTS_ABOVE_LIGHTING_LAYER)
	add_overlay(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/orderterminal/machinery_process()
	if(stat & NOPOWER)
		cut_overlays()
		set_light(FALSE)
		return

// --------------------
// /obj/item/holomenu/attackby(obj/item/I, mob/user)
// 	var/obj/item/card/id/ID = I.GetID()
// 	if(istype(ID))
// 		if(check_access(ID))
// 			anchored = !anchored
// 			to_chat(user, SPAN_NOTICE("You [anchored ? "" : "un"]anchor \the [src]."))
// 			update_icon()
// 		else
// 			to_chat(user, SPAN_WARNING("Access denied."))
// 		return
// 	return ..()

// /obj/machinery/orderterminal/attack_hand(mob/user)
// 	if(allowed(user))
// 		var/new_text = sanitize(input(user, "Enter new text for the holo-menu to display.", "Holo-Menu Display", html2pencode(menu_text, TRUE)) as null|message)
// 		if(!isnull(new_text))
// 			menu_text = pencode2html(new_text)
// 			update_icon()
// 	else
// 		interact(user)
// 	return

/obj/machinery/orderterminal/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/orderterminal/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	if (!ui)
		ui = new(usr, src, "machinery-orderterminal-ordering", 400, 400, "Idris Ordering Terminal")
	ui.open()

/obj/machinery/orderterminal/proc/print_receipt()
	var/obj/item/paper/R = new(usr.loc)
	var/receiptname = "Receipt: [machine_id]"
	R.set_content_unsafe(receiptname, receipt, sum)

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Idris Ordering Terminal.</i>"
	
	var/obj/item/paper/T = new(usr.loc)
	var/tickettname = "Ticket: [ticket_number]"
	ticket_number++
	T.set_content_unsafe(tickettname, receipt, sum)

	//stamp the ticket too
	if(!T.stamped)
		T.stamped = new
	T.stamped += /obj/item/stamp
	T.add_overlay(stampoverlay)
	T.stamps += "<HR><i>This paper has been stamped by the Idris Ordering Terminal.</i>"



/obj/machinery/orderterminal/attackby(obj/O, mob/user)
	if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		var/transaction_amount = sum
		var/transaction_purpose = "[destinationact] Payment"
		var/transaction_terminal = machine_id

		if(transaction_amount <= E.worth)
			src.visible_message("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes.")
			
			SSeconomy.charge_to_account(SSeconomy.get_department_account(destinationact)?.account_number, E.owner_name, transaction_purpose, transaction_terminal, transaction_amount)
			E.worth -= transaction_amount
			print_receipt()
			sum = 0
			receipt = ""
			ticket = ""
			to_chat(src.loc, SPAN_NOTICE("Transaction completed, please return to the home screen."))
		else if (transaction_amount > E.worth)
			to_chat(user, "[icon2html(src, user)]<span class='warning'>\The [E] doesn't have that much money!</span>")
		return
	
	var/obj/item/card/id/I = O.GetID()
	if (!I) 
		return
	if (!istype(O))
		return

	if(unlocking)
		if(check_access(I))
			to_chat(user, SPAN_NOTICE("You unlock \the [src]. Please return to the home screen."))
			editmode = 1
			unlocking = 0
		else
			to_chat(user, SPAN_WARNING("Access denied."))
	
	else
		var/transaction_amount = sum
		var/transaction_purpose = "[destinationact] Payment"
		var/transaction_terminal = machine_id

		var/transaction = SSeconomy.transfer_money(I.associated_account_number, SSeconomy.get_department_account(destinationact)?.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)

		if(transaction)
			to_chat(user,"[icon2html(src, user)]<span class='warning'>[transaction].</span>")
		else
			playsound(src, 'sound/machines/chime.ogg', 50, 1)
			src.visible_message("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes.")
			print_receipt()
			sum = 0
			receipt = ""
			ticket = ""
			to_chat(src.loc, SPAN_NOTICE("Transaction completed, please return to the home screen."))

// VUEUI below

/obj/machinery/orderterminal/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

	VUEUI_SET_CHECK_IFNOTSET(data["items"], items, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["price"], items, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_name"], "", ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_price"], 0, ., data)
	VUEUI_SET_CHECK(data["tmp_price"], max(0, data["tmp_price"]), ., data)
	if(data["tmp_price"] < 0)
		data["tmp_price"] = 0
		. = data
	VUEUI_SET_CHECK_IFNOTSET(data["selection"], list("_" = 0), ., data)
	VUEUI_SET_CHECK(data["editmode"], editmode, ., data)
	VUEUI_SET_CHECK(data["destinationact"], destinationact, ., data)

/obj/machinery/orderterminal/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["add"])

		if(editmode == 0)
			to_chat(src, SPAN_NOTICE("You don't have access to use this option."))
			return 0

		items[href_list["add"]["name"]] = href_list["add"]["price"]
		ui.data["items"][href_list["add"]["name"]] = href_list["add"]["price"]
		. = TRUE

	if(href_list["remove"])

		if(editmode == 0)
			to_chat(src, SPAN_NOTICE("You don't have access to use this option."))
			return 0
		items -= href_list["remove"]
		ui.data["items"] -= href_list["remove"]
		. = TRUE

	if(href_list["confirm"])
		var/selection = ui.data["selection"]
		var/items = ui.data["items"]
		for(var/name in selection)
			if(items[name])
				sum += items[name] * selection[name]
				receipt += "<b>[name]</b> : [items[name]]x[selection[name]]:  [items[name] * selection[name]]<br>"
				ticket += "<b>[name]</b> : [items[name]]<br>"
		if(sum > 0)
			ui.activeui = "machinery-orderterminal-orderconfirmation"
		else
			print_receipt()
		. = TRUE

	if(href_list["return"])
		sum = 0
		receipt = ""
		unlocking = 0
		ui.activeui = "machinery-orderterminal-ordering"
		. = TRUE

	if(href_list["locking"])
		if(editmode == 1)
			editmode = 0
			to_chat(src, SPAN_NOTICE("Device Locked."))
			SSvueui.check_uis_for_change(src)
			return 0
		if(editmode == 0)
			unlocking = 1
			ui.activeui = "machinery-orderterminal-editconfirmation"
		. = TRUE

	if(href_list["accountselect"])
		if(editmode == 0)
			to_chat(usr, SPAN_NOTICE("You don't have access to use this option."))
			return 0
		switch(input("What account would you like to select?", "Destination Account") as null|anything in list("Civilian", "Cargo", "Command", "Medical", "Security", "Engineering", "Science"))
		
			if("Civilian")
				destinationact = "Civilian"
			if("Cargo")
				destinationact = "Cargo"
			if("Command")
				destinationact = "Command"
			if("Medical")
				destinationact = "Medical"
			if("Security")
				destinationact = "Security"
			if("Engineering")
				destinationact = "Engineering"
			if("Science")
				destinationact = "Science"
	. = TRUE
	SSvueui.check_uis_for_change(src)