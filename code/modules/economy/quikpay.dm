

/obj/item/device/quikpay
	name = "\improper NT Quik-Pay"
	desc = "Swipe your ID to make direct company purchases."
	icon = 'icons/obj/device.dmi'
	icon_state = "quikpay"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	var/machine_id = ""
	var/list/items = list()
	var/list/buying = list()
	var/new_item
	var/new_price
	var/sum = 0
	var/access_code = 0
	var/editmode = FALSE
	var/receipt = ""
	var/destinationact = "Service"

/obj/item/device/quikpay/Initialize()
	. = ..()
	machine_id = "[station_name()] Idris Quik-Pay #[SSeconomy.num_financial_terminals++]"
	access_code = rand(1111,111111)
	print_reference()

	//create a short manual as well
	var/obj/item/paper/R = new(src.loc)
	R.name = "Quik And Easy: How to make a transaction"

	R.info += "<b>Quik-Pay setup:</b><br>"
	R.info += "<ol><li>Remember your access code included on the paper that is included with your device</li>"
	R.info += "<li>Enter the pin into the locking mechanism to be able to add items to the menu</li>"
	R.info += "<li>Add items to the menu by typing the item name and its price</li></ol>"
	R.info += "<b>When starting a new transaction:</b><br>"
	R.info += "<ol><li>Have the customer enter the amount of the item they want.</li>"
	R.info += "<li>Press confirm payment</li>"
	R.info += "<li>Allow them to review the sum.</li>"
	R.info += "<li>Have them swipe their card to pay for the items, press return to reset the sum.</li></ol>"


	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.offset_x += 0
	R.offset_y += 0
	R.ico += "paper_stamp-cent"
	R.stamped += /obj/item/stamp
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Executive Officer's desk.</i>"

/obj/item/device/quikpay/AltClick(var/mob/user)
	var/obj/item/card/id/I = user.GetIdCard()
	if(istype(I) && (access_heads in I.access))
		editmode = TRUE
		to_chat(user, SPAN_NOTICE("Command access granted."))
		SStgui.update_uis(src)

/obj/item/device/quikpay/proc/print_reference()
	var/obj/item/paper/R = new(src.loc)
	var/pname = "Reference: [machine_id]"
	var/info = "<b>[machine_id] reference</b><br><br>"
	info += "Access code: [access_code]<br><br>"
	info += "<b>Do not lose or misplace this code.</b><br>"
	R.set_content_unsafe(pname, info)

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Executive Officer's desk.</i>"
	var/obj/item/smallDelivery/D = new(R.loc)
	R.forceMove(D)
	D.wrapped = R
	D.name = "small parcel - 'Quik Pay access code'"

/obj/item/device/quikpay/proc/print_receipt()
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
	R.stamps += "<HR><i>This paper has been stamped by the Quik-Pay device.</i>"

/obj/item/device/quikpay/attackby(obj/O, mob/user)
	if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		var/transaction_amount = sum
		var/transaction_purpose = "[destinationact] Payment"
		var/transaction_terminal = machine_id

		if(transaction_amount <= E.worth)
			playsound(src, 'sound/machines/chime.ogg', 50, 1)
			src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes."))

			SSeconomy.charge_to_account(SSeconomy.get_department_account(destinationact)?.account_number, E.owner_name, transaction_purpose, transaction_terminal, transaction_amount)
			E.worth -= transaction_amount
			print_receipt()
			sum = 0
			receipt = ""
			to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))
		else if (transaction_amount > E.worth)
			to_chat(user, SPAN_WARNING("[icon2html(src, user)]\The [E] doesn't have that much money!"))
		return

	var/obj/item/card/id/I = O.GetID()
	if (!istype(O))
		return

	var/transaction_amount = sum
	var/transaction_purpose = "[destinationact] Payment"
	var/transaction_terminal = machine_id

	var/transaction = SSeconomy.transfer_money(I.associated_account_number, SSeconomy.get_department_account(destinationact)?.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)

	if(transaction)
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)]<span class='warning'>[transaction].</span>"))
	else
		playsound(src, 'sound/machines/chime.ogg', 50, 1)
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes."))
		print_receipt()
		sum = 0
		receipt = ""
		to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))

/obj/item/device/quikpay/attack_self(var/mob/user)
	ui_interact()

/obj/item/device/quikpay/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "QuikPay", "Idris Quik-Pay", 400, 400)
		ui.open()

/obj/item/device/quikpay/ui_data(var/mob/user)
	var/list/data = list()

	data["items"] = list()
	for(var/item in items)
		data["items"] += list(list("name" = item, "price" = items[item]))
	data["sum"] = sum
	data["new_item"] = new_item
	data["new_price"] = new_price
	data["selection"] = list("_" = 0)
	data["editmode"] = editmode
	data["destinationact"] = destinationact

	return data

/obj/item/device/quikpay/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("add")
			if(!editmode)
				to_chat(usr, SPAN_WARNING("Device locked."))
				return FALSE

			items[new_item] = new_price
			. = TRUE

		if("remove")
			if(!editmode)
				to_chat(usr, SPAN_NOTICE("Device locked."))
				return FALSE

			items -= params["remove"]
			. = TRUE

		if("set_new_price")
			new_price = params["set_new_price"]
			. = TRUE

		if("set_new_item")
			new_item = params["set_new_item"]
			. = TRUE

		if("buy")
			for(var/list/L in buying)
				if(L["name"] == params["buying"])
					L["amount"]++
					return TRUE
			buying += list(list("name" = params["buying"], "amount" = params["amount"]))

		if("removal")
			for(var/list/L in buying)
				if(L["name"] == params["removal"])
					if(L["amount"] > 1)
						L["amount"]--
					else
						buying -= L
			. = TRUE

		if("confirm")
			for(var/list/bought_item in buying)
				var/item_name = bought_item["name"]
				var/item_amount = bought_item["amount"]
				var/item_price = items[item_name]

				receipt += "<b>[name]</b>: [item_name] x[item_amount] at [item_price]电 each<br>"
				sum += item_price
			. = TRUE

		if("locking")
			if(editmode)
				editmode = FALSE
				to_chat(usr, SPAN_NOTICE("Device locked."))
			else
				if(!editmode)
					var/attempt_code = input("Enter the edit code.", "Confirm edit access code.") as num
					if(attempt_code == access_code)
						editmode = TRUE
						to_chat(usr, SPAN_NOTICE("Device unlocked."))
			. = TRUE

		if("accountselect")
			if(!editmode)
				to_chat(usr, SPAN_WARNING("Device locked."))
				return FALSE

			switch(input("What account would you like to select?", "Destination Account") as null|anything in list("Service", "Operations", "Command", "Medical", "Security", "Engineering", "Science"))
				if("Service")
					destinationact = "Service"
				if("Operations")
					destinationact = "Operations"
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



