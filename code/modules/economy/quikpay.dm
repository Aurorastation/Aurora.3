

/obj/item/device/nanoquikpay
	name = "\improper NT Quik-Pay"
	desc = "Swipe your ID to make direct company purchases."
	icon = 'icons/obj/device.dmi'
	icon_state = "quikpay"
	var/machine_id = ""
	var/list/items = list()
	var/sum = 0
	var/access_code = 0
	var/editmode = 0
	var/receipt = ""
	var/destinationact = "Civilian"




/obj/item/device/nanoquikpay/Initialize()
	. = ..()
	machine_id = "[station_name()] Quik-Pay #[SSeconomy.num_financial_terminals++]"
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
	R.stamps += "<HR><i>This paper has been stamped by the Head of Personnel's desk.</i>"

/obj/item/device/nanoquikpay/AltClick(var/mob/user)
	var/obj/item/card/id/I = user.GetIdCard()
	if(istype(I) && (access_heads in I.access))
		editmode = 1
		to_chat(user, span("notice", "Command access granted."))
		SSvueui.check_uis_for_change(src)


/obj/item/device/nanoquikpay/proc/print_reference()
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
	R.stamps += "<HR><i>This paper has been stamped by the Head of Personnel's desk.</i>"
	var/obj/item/smallDelivery/D = new(R.loc)
	R.forceMove(D)
	D.wrapped = R
	D.name = "small parcel - 'Quik Pay access code'"


/obj/item/device/nanoquikpay/proc/print_receipt()
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



/obj/item/device/nanoquikpay/attackby(obj/O, mob/user)
	var/obj/item/card/id/I = O.GetID()
	if (!I) 
		return
	if (!istype(O))
		return
	

	else

		var/transaction_amount = sum
		var/transaction_purpose = "[destinationact] Payment"
		var/transaction_terminal = machine_id

		var/transaction = SSeconomy.transfer_money(I.associated_account_number, SSeconomy.get_department_account(destinationact)?.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)

		if(transaction)
			to_chat(usr,"\icon[src]<span class='warning'>[transaction].</span>")
		else
			playsound(src, 'sound/machines/chime.ogg', 50, 1)
			src.visible_message("\icon[src] \The [src] chimes.")
			print_receipt()
			sum = 0
			receipt = ""
			to_chat(src.loc, span("notice", "Transaction completed, please return to the home screen."))

// VUEUI Below <3


/obj/item/device/nanoquikpay/attack_self(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	if (!ui)
		ui = new(usr, src, "quikpay-main", 400, 400, "NT Quik-Pay")
	ui.open()

/obj/item/device/nanoquikpay/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
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

/obj/item/device/nanoquikpay/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return
	if(href_list["add"])

		if(editmode == 0)
			to_chat(src, span("notice", "You don't have access to use this option."))
			return 0

		items[href_list["add"]["name"]] = href_list["add"]["price"]
		ui.data["items"][href_list["add"]["name"]] = href_list["add"]["price"]
		. = TRUE
	if(href_list["remove"])

		if(editmode == 0)
			to_chat(src, span("notice", "You don't have access to use this option."))
			return 0
		items -= href_list["remove"]
		ui.data["items"] -= href_list["remove"]
		. = TRUE
	if(href_list["confirm"])
		var/selection = ui.data["selection"]
		var/items = ui.data["items"]
		for(var/name in selection)
			if(items[name] && selection[name])
				sum += items[name] * selection[name]
				receipt += "<b>[name]</b> : [items[name]]x[selection[name]]:  [items[name] * selection[name]]<br>"
		ui.activeui = "devices-quikpay-confirmation"	
		. = TRUE
	if(href_list["return"])
		sum = 0
		receipt = ""
		ui.activeui = "devices-quikpay-main"	
		. = TRUE


	if(href_list["locking"])
		if(editmode == 1)
			editmode = 0
			to_chat(src, span("notice", "Device Locked."))
			SSvueui.check_uis_for_change(src)
			return 0
		if(editmode == 0)
			var/attempt_code = input("Enter the edit code", "Confirm edit access code") as num //Copied the eftpos method, dont judge
			if(attempt_code == access_code)
				editmode = 1
				to_chat(src, span("notice", "Device Unlocked."))
				SSvueui.check_uis_for_change(src)
		. = TRUE

	if(href_list["accountselect"])

		if(editmode == 0)
			to_chat(usr, span("notice", "You don't have access to use this option."))
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
	playsound(src, 'sound/machines/chime.ogg', 50, 1)
	SSvueui.check_uis_for_change(src)
		


