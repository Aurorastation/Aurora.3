#define UIDEBUG
/obj/item/device/nanoquikpay
	name = "\improper NT Quik-Pay"
	desc = "Swipe you're ID to make direct company purcheses"
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	var/machine_id = ""
	var/list/items = list()



/obj/item/device/nanoquikpay/New()
	..()
	machine_id = "[station_name()] Quik-Pay #[SSeconomy.num_financial_terminals++]"

/*

/obj/item/device/nanoquikpay/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/obj/item/weapon/card/id/I = W.GetID()
	var/datum/money_account/quickpay_account = SSeconomy.get_department_account("Civilian") //Now money will automaticly goto the civilian get_department_account


	if (quickpay_account && !quickpay_account.suspended)
		var/paid = 0

		if (quickpay_account.suspended)
			visible_message(span("warning","\The [src] buzzes and flashes a message on its LCD: <b>\"TRANSACTION FAILED, CONTACT IT SUPPORT.\"</b>"))
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 35, 1)
			return

		if (I) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(I,W)


		if(paid)
			user << "You process the payment!."


/obj/item/device/nanoquikpay/proc/pay_with_card(var/obj/item/weapon/card/id/I, var/obj/item/ID_container, var/mob/user)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	var/datum/money_account/quickpay_account = SSeconomy.get_department_account("Civilian")
	var/datum/money_account/customer_account = SSeconomy.get_account(I.associated_account_number)
	if (!customer_account)
		src << "<span class='warning'>\icon[src] The [src] beeps: Error: Unable to access account. Please contact technical support if problem persists</span>"
		return 0

	if(customer_account.suspended)
		user << "<span class='warning'>\icon[src] The [src] beeps: Error: Account Suspended</span>"
		return 0

	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Quik-Pay transaction") as num
		customer_account = SSeconomy.attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			src << "<span class='warning'>\icon[src] The [src] beeps: Error: Card Missing Account Number</span>"
			return 0

	if(current_quickpayamount > customer_account.money)
		src << "<span class='warning'>\icon[src] The [src] beeps: Error: Missing funds for transaction</span>"
		return 0
	else


		// debit money from the purchaser's account
		customer_account.money -= current_quickpayamount
		quickpay_account.money += current_quickpayamount




		// create entry in the purchaser's account log
		var/datum/transaction/T = new()
		T.target_name = machine_id
		T.purpose = "Purchase of [current_quickpayitem]"
		T.amount = "[current_quickpayamount]"
		T.source_terminal = machine_id
		T.date = worlddate2text()
		T.time = worldtime2text()
		SSeconomy.add_transaction_log(customer_account,T)

/obj/item/device/nanoquikpay/verb/setprice()
	set name = "Set Quik-Pay Amount"
	set category = "Quik-Pay"
	current_quickpayamount = input("Enter transaction amount", "Quik-Pay Transaction") as num
	while(current_quickpayamount <= 0)
		src << "<span class='warning'>\icon[src] The [src] beeps: Error: Invalid Transaction Amount</span>"
		current_quickpayamount = input("Enter transaction amount", "Quik-Pay Transaction") as num
	return



/obj/item/device/nanoquikpay/verb/setreceipt()
	set name = "Set Quik-Pay Receipt Data"
	set category = "Quik-Pay"

	current_quickpayitem = input("Enter item's the customer ordered", "Quik-Pay transaction") as text
	return


*//
// UI Shit Below


/obj/item/device/nanoquikpay/verb/openui()
	set name = "Quik-Pay UI"
	set category = "Quik-Pay"
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
		ui.activeui = "quikpay-confirmation"
		. = TRUE