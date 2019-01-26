
/obj/item/device/nanoquikpay
	name = "\improper NT Quik-Pay"
	desc = "Swipe you're ID to make direct company purcheses"
	icon = 'icons/obj/device.dmi'
	icon_state = "quikpay"
	var/machine_id = ""
	var/list/items = list()
	var/sum = 0
	var/access_code = 0
	var/editmode = 0




/obj/item/device/nanoquikpay/New()
	..()
	machine_id = "[station_name()] Quik-Pay #[SSeconomy.num_financial_terminals++]"
	access_code = rand(1111,111111)
	spawn(0)
		print_reference()

		//create a short manual as well
		var/obj/item/weapon/paper/R = new(src.loc)
		R.name = "Quik And Easy: How to make a transaction"

		R.info += "<b>Quik-Pay setup:</b><br>"
		R.info += "1.Remember your access code included on the paper that is included with your device<br>"
		R.info += "2. Enter the pin into the locking mechanism to be able to add items to the menu<br><br>"
		R.info += "3. Add items to the menu by typing the item name and its price<br><br>"
		R.info += "<b>When starting a new transaction:</b><br>"
		R.info += "1.Have the customer enter the amount of the item they want.<br>"
		R.info += "2. Press confirm payment.<br>"
		R.info += "3. Allow them to review the sum.<br>"
		R.info += "4. Have them swipe their card to pay for the items, press return to reset the sum..<br>"


		//stamp the paper
		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		stampoverlay.icon_state = "paper_stamp-cent"
		if(!R.stamped)
			R.stamped = new
		R.offset_x += 0
		R.offset_y += 0
		R.ico += "paper_stamp-cent"
		R.stamped += /obj/item/weapon/stamp
		R.add_overlay(stampoverlay)
		R.stamps += "<HR><i>This paper has been stamped by the Head of Personnel's desk.</i>"


/obj/item/device/nanoquikpay/proc/print_reference()
	var/obj/item/weapon/paper/R = new(src.loc)
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
	R.stamped += /obj/item/weapon/stamp
	R.add_overlay(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Head of Personnel's desk.</i>"
	var/obj/item/smallDelivery/D = new(R.loc)
	R.forceMove(D)
	D.wrapped = R
	D.name = "small parcel - 'Quik Pay access code'"



/obj/item/device/nanoquikpay/attackby(obj/O, mob/user)
	var/obj/item/weapon/card/id/I = O.GetID()
	if(!istype(O, /obj/item/weapon/card/id))

	else

		var/datum/money_account/quickpay_account = SSeconomy.get_department_account("Civilian")
		var/datum/money_account/customer_account = SSeconomy.get_account(I.associated_account_number)
		if (!customer_account)
			to_chat(user, span("notice", "Unable to access account, please contact the Head of Personnel."))
			return 0

		if(customer_account.suspended)
			to_chat(user, span("notice", "Account Suspended, please contact the Head of Personnel."))
			return 0

		if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
			var/attempt_pin = input("Enter pin code", "Quik-Pay transaction") as num
			customer_account = SSeconomy.attempt_account_access(I.associated_account_number, attempt_pin, 2)

			if(!customer_account)
				to_chat(user, span("notice", "Unable to access account, please contact the Head of Personnel."))
				return 0

		if(sum > customer_account.money)
			to_chat(user, span("notice", "Your account lack's the funds to process this payment."))
			return 0
		else


		// debit money from the purchaser's account
			customer_account.money -= sum
			quickpay_account.money += sum




		// create entry in the purchaser's account log
			var/datum/transaction/T = new()
			T.target_name = machine_id
			T.purpose = "Quik Pay Transaction"
			T.amount = sum
			T.source_terminal = machine_id
			T.date = worlddate2text()
			T.time = worldtime2text()
			SSeconomy.add_transaction_log(customer_account,T)

			sum = 0

// UI Shit Below


/obj/item/device/eftpos/attack_self(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	if (!ui)
		ui = new(usr, src, "quikpay-main", 500, 500, "NT Quik-Pay")
	ui.open()

/obj/item/device/nanoquikpay/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

	VUEUI_SET_CHECK_IFNOTSET(data["items"], items, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_name"], "", ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_price"], 0, ., data)
	VUEUI_SET_CHECK(data["tmp_price"], max(0, data["tmp_price"]), ., data)
	if(data["tmp_price"] < 0)
		data["tmp_price"] = 0
		. = data
	VUEUI_SET_CHECK_IFNOTSET(data["selection"], list("_" = 0), ., data)
	VUEUI_SET_CHECK(data["editmode"], editmode, ., data)

/obj/item/device/nanoquikpay/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return
	if(href_list["add"])
		items[href_list["add"]["name"]] = href_list["add"]["price"]
		ui.data["items"][href_list["add"]["name"]] = href_list["add"]["price"]
		. = TRUE
	if(href_list["remove"])
		items -= href_list["remove"]
		ui.data["items"] -= href_list["remove"]
		. = TRUE
	if(href_list["confirm"])
		to_world("Payment selection: [json_encode(href_list["confirm"])]")
		var/selection = ui.data["selection"]
		var/items = ui.data["items"]
		for(var/name in selection)
			if(items[name])
				sum += items[name] * selection[name]
		ui.activeui = "quikpay-confirmation"	
		. = TRUE
	if(href_list["return"])
		sum= 0
		ui.activeui = "quikpay-main"	
		. = TRUE

	if(href_list["unlock"])
		if(editmode == 1)
			editmode = 0
			to_chat(user, span("notice", "Menu Locked."))
			SSvueui.check_uis_for_change(src)
			return 0
	if(editmode == 0)
		var/attempt_code = input("Enter the edit code", "Confirm edit access code") as num //Copied the eftpos method, dont judge
		if(attempt_code == access_code)
			editmode = 1
			to_chat(user, span("notice", "Menu Unlocked."))
			SSvueui.check_uis_for_change(src)

