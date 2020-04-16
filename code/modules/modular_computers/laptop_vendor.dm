#define LAPTOP 1
#define TABLET 2
#define WRISTBOUND 3


// A vendor machine for modular computer portable devices - Laptops and Tablets

/obj/machinery/lapvend
	name = "computer vendor"
	desc = "A vending machine with microfabricator capable of dispensing various NT-branded computers."
	icon = 'icons/obj/vending.dmi'
	icon_state = "robotics"
	anchored = TRUE
	density = TRUE

	// The actual laptop/tablet
	var/obj/item/modular_computer/fabricated_medium
	var/obj/item/modular_computer/fabricated_small

	// Utility vars
	var/state = 0 							// 0: Select device type, 1: Select loadout, 2: Payment, 3: Thankyou screen
	var/devtype = 0 						// 0: None(unselected), 1: Laptop, 2: Tablet, 3: Wristbound
	var/total_price = 0						// Price of currently vended device.

	// Device loadout
	var/dev_cpu = 1							// 1: Default, 2: Upgraded
	var/dev_battery = 1						// 1: Default, 2: Upgraded, 3: Advanced
	var/dev_disk = 1						// 1: Default, 2: Upgraded, 3: Advanced
	var/dev_netcard = 0						// 0: None, 1: Basic, 2: Long-Range
	var/dev_tesla = 0						// 0: None, 1: Standard (LAPTOP ONLY)
	var/dev_nanoprint = 0					// 0: None, 1: Standard
	var/dev_card = 0						// 0: None, 1: Standard
	var/dev_aislot = 0						// 0: None, 1: Standard

// Removes all traces of old order and allows you to begin configuration from scratch.
/obj/machinery/lapvend/proc/reset_order()
	state = 0
	devtype = 0
	if(fabricated_medium)
		qdel(fabricated_medium)
		fabricated_medium = null
	if(fabricated_small)
		qdel(fabricated_small)
		fabricated_small = null
	dev_cpu = 1
	dev_battery = 1
	dev_disk = 1
	dev_netcard = 0
	dev_tesla = 0
	dev_nanoprint = 0
	dev_card = 0
	dev_aislot = 0

// Recalculates the price and optionally even fabricates the device.
/obj/machinery/lapvend/proc/fabricate_and_recalc_price(var/fabricate = FALSE)
	total_price = 0
	if(devtype == LAPTOP)	// Laptop, generally cheaper to make it accessible for most station roles
		if(fabricate)
			fabricated_medium = new /obj/item/modular_computer/laptop(src)
		total_price = 99
		switch(dev_cpu)
			if(1)
				if(fabricate)
					fabricated_medium.processor_unit = new /obj/item/computer_hardware/processor_unit/small(fabricated_medium)
			if(2)
				if(fabricate)
					fabricated_medium.processor_unit = new /obj/item/computer_hardware/processor_unit(fabricated_medium)
				total_price += 299
		switch(dev_battery)
			if(1) //Micro(500C)
				if(fabricate)
					fabricated_medium.battery_module = new /obj/item/computer_hardware/battery_module/micro(fabricated_medium)
			if(2) // Basic(750C)
				if(fabricate)
					fabricated_medium.battery_module = new /obj/item/computer_hardware/battery_module(fabricated_medium)
				total_price += 199
			if(3) // Upgraded(1100C)
				if(fabricate)
					fabricated_medium.battery_module = new /obj/item/computer_hardware/battery_module/advanced(fabricated_medium)
				total_price += 499
		switch(dev_disk)
			if(1)
				if(fabricate)
					fabricated_medium.hard_drive = new /obj/item/computer_hardware/hard_drive/small(fabricated_medium)
			if(2) // Basic(128GQ)
				if(fabricate)
					fabricated_medium.hard_drive = new /obj/item/computer_hardware/hard_drive(fabricated_medium)
				total_price += 199
			if(3) // Upgraded(256GQ)
				if(fabricate)
					fabricated_medium.hard_drive = new /obj/item/computer_hardware/hard_drive/advanced(fabricated_medium)
				total_price += 299
		switch(dev_netcard)
			if(1) // Basic(Short-Range)
				if(fabricate)
					fabricated_medium.network_card = new /obj/item/computer_hardware/network_card(fabricated_medium)
				total_price += 199
			if(2) // Advanced (Long Range)
				if(fabricate)
					fabricated_medium.network_card = new /obj/item/computer_hardware/network_card/advanced(fabricated_medium)
				total_price += 299
		if(dev_tesla)
			total_price += 399
			if(fabricate)
				fabricated_medium.tesla_link = new /obj/item/computer_hardware/tesla_link(fabricated_medium)
		if(dev_nanoprint)
			total_price += 99
			if(fabricate)
				fabricated_medium.nano_printer = new /obj/item/computer_hardware/nano_printer(fabricated_medium)
		if(dev_card)
			total_price += 399
			if(fabricate)
				fabricated_medium.card_slot = new /obj/item/computer_hardware/card_slot(fabricated_medium)
		if(dev_aislot)
			total_price += 749
			if(fabricate)
				fabricated_medium.ai_slot = new /obj/item/computer_hardware/ai_slot(fabricated_medium)
		return total_price
	else if(devtype == TABLET || devtype == WRISTBOUND)	// Tablet or Wristbound, more expensive, not everyone could probably afford this.
		if(fabricate)
			if(devtype == TABLET)
				fabricated_small = new /obj/item/modular_computer/tablet(src)
			else if(devtype == WRISTBOUND)
				fabricated_small = new /obj/item/modular_computer/wristbound(src)
			fabricated_small.processor_unit = new /obj/item/computer_hardware/processor_unit/small(fabricated_small)
		total_price = 199
		switch(dev_battery)
			if(1) // Basic(300C)
				if(fabricate)
					fabricated_small.battery_module = new /obj/item/computer_hardware/battery_module/nano(fabricated_small)
			if(2) // Upgraded(500C)
				if(fabricate)
					fabricated_small.battery_module = new /obj/item/computer_hardware/battery_module/micro(fabricated_small)
				total_price += 199
			if(3) // Advanced(750C)
				if(fabricate)
					fabricated_small.battery_module = new /obj/item/computer_hardware/battery_module(fabricated_small)
				total_price += 499
		switch(dev_disk)
			if(1) // Basic(32GQ)
				if(fabricate)
					fabricated_small.hard_drive = new /obj/item/computer_hardware/hard_drive/micro(fabricated_small)
			if(2) // Upgraded(64GQ)
				if(fabricate)
					fabricated_small.hard_drive = new /obj/item/computer_hardware/hard_drive/small(fabricated_small)
				total_price += 199
		switch(dev_netcard)
			if(1) // Basic(Short-Range)
				if(fabricate)
					fabricated_small.network_card = new /obj/item/computer_hardware/network_card(fabricated_small)
				total_price += 199
		if(dev_nanoprint)
			total_price += 99
			if(fabricate)
				fabricated_small.nano_printer = new /obj/item/computer_hardware/nano_printer(fabricated_small)
		if(dev_card)
			total_price += 199
			if(fabricate)
				fabricated_small.card_slot = new /obj/item/computer_hardware/card_slot(fabricated_small)
		if(dev_tesla)
			total_price += 399
			if(fabricate)
				fabricated_small.tesla_link = new /obj/item/computer_hardware/tesla_link(fabricated_small)
		if(dev_aislot)
			total_price += 499
			if(fabricate)
				fabricated_small.ai_slot = new /obj/item/computer_hardware/ai_slot(fabricated_small)
		return total_price
	return FALSE

/obj/machinery/lapvend/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["pick_device"])
		if(state) // We've already picked a device type
			return FALSE
		devtype = text2num(href_list["pick_device"])
		state = 1
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["clean_order"])
		reset_order()
		return TRUE
	if((state != 1) && devtype) // Following IFs should only be usable when in the Select Loadout mode
		return FALSE
	if(href_list["confirm_order"])
		state = 2 // Wait for ID swipe for payment processing
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_cpu"])
		dev_cpu = text2num(href_list["hw_cpu"])
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_battery"])
		dev_battery = text2num(href_list["hw_battery"])
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_disk"])
		dev_disk = text2num(href_list["hw_disk"])
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_netcard"])
		dev_netcard = text2num(href_list["hw_netcard"])
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_tesla"])
		dev_tesla = text2num(href_list["hw_tesla"])
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_nanoprint"])
		dev_nanoprint = text2num(href_list["hw_nanoprint"])
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_card"])
		dev_card = text2num(href_list["hw_card"])
		fabricate_and_recalc_price(0)
		return TRUE
	if(href_list["hw_aislot"])
		dev_aislot = text2num(href_list["hw_aislot"])
		fabricate_and_recalc_price(0)
		return TRUE
	return FALSE

/obj/machinery/lapvend/attack_hand(mob/user)
	if(anchored)
		ui_interact(user)
	else
		to_chat(user, SPAN_WARNING("\The [src] needs to be anchored to the floor to function!"))

/obj/machinery/lapvend/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (BROKEN | NOPOWER | MAINT))
		if(ui)
			ui.close()
		return FALSE

	var/list/data[0]
	data["state"] = state
	if(state == 1)
		data["devtype"] = devtype
		data["hw_battery"] = dev_battery
		data["hw_disk"] = dev_disk
		data["hw_netcard"] = dev_netcard
		data["hw_tesla"] = dev_tesla
		data["hw_nanoprint"] = dev_nanoprint
		data["hw_card"] = dev_card
		data["hw_cpu"] = dev_cpu
		data["hw_aislot"] = dev_aislot
	if(state == 1 || state == 2)
		data["totalprice"] = total_price

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "computer_fabricator.tmpl", "Personal Computer Vendor", 500, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/lapvend/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		playsound(get_turf(src), W.usesound, 100, TRUE)
		if(anchored)
			user.visible_message(SPAN_NOTICE("\The [user] begins unsecuring \the [src] from the floor."), SPAN_NOTICE("You start unsecuring \the [src] from the floor."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] begins securing \the [src] to the floor."), SPAN_NOTICE("You start securing \the [src] to the floor."))
		if(do_after(user, 20 / W.toolspeed))
			if(!src)
				return
			to_chat(user, SPAN_NOTICE("You [anchored ? "un" : ""]secured \the [src]!"))
			anchored = !anchored
		return
	else if(state != 2 && (istype(W, /obj/item/card/id) || istype(W, /obj/item/device/pda) || istype(W, /obj/item/modular_computer) || istype(W, /obj/item/card/tech_support)))
		to_chat(user, SPAN_WARNING("\The [src] isn't in the payment mode yet!"))
		return
	else if(state == 2) // awaiting payment state
		if(istype(W, /obj/item/card/id) || istype(W, /obj/item/device/pda) || istype(W, /obj/item/modular_computer))
			var/obj/item/card/id/I = W.GetID()
			if(process_payment(I, W))
				create_device()
				return TRUE
			return
		else if(istype(W, /obj/item/card/tech_support))
			create_device("Have a Nanotrasen day!")
			return TRUE
	return ..()

/obj/machinery/lapvend/proc/create_device(var/message = "Enjoy your new product!")
	fabricate_and_recalc_price(TRUE)
	if((devtype == LAPTOP) && fabricated_medium)
		if(fabricated_medium.battery_module)
			fabricated_medium.battery_module.charge_to_full()
		fabricated_medium.forceMove(get_turf(src))
		fabricated_medium.screen_on = FALSE
		fabricated_medium.anchored = FALSE
		fabricated_medium.update_icon()
		fabricated_medium = null
	else if((devtype == TABLET || devtype == WRISTBOUND) && fabricated_small)
		if(fabricated_small.battery_module)
			fabricated_small.battery_module.charge_to_full()
		fabricated_small.forceMove(get_turf(src))
		fabricated_small = null
	ping(message)
	state = 3

// Simplified payment processing, returns 1 on success.
/obj/machinery/lapvend/proc/process_payment(var/obj/item/card/id/I, var/obj/item/ID_container)
	var/obj/item/spacecash/S
	if(istype(ID_container, /obj/item/spacecash))
		S = ID_container
	if(I == ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] taps \the [ID_container] against \the [src].</span>")
	if(I)
		var/datum/money_account/customer_account = SSeconomy.get_account(I.associated_account_number)
		if (!customer_account || customer_account.suspended)
			ping("Connection error. Unable to connect to account.")
			return FALSE

		if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
			var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
			customer_account = SSeconomy.attempt_account_access(I.associated_account_number, attempt_pin, 2)

			if(!customer_account)
				ping("Unable to access account: incorrect credentials.")
				return FALSE

		if(total_price > customer_account.money)
			ping("Insufficient funds in account.")
			return FALSE
		else
			customer_account.money -= total_price
			var/datum/transaction/T = new()
			T.target_name = "Computer Manufacturer (via [src.name])"
			if(devtype == LAPTOP)
				T.purpose = "Purchase of laptop computer."
			if(devtype == TABLET)
				T.purpose = "Purchase of tablet microcomputer."
			if(devtype == WRISTBOUND)
				T.purpose = "Purchase of wristbound microcomputer."
			T.amount = total_price
			T.source_terminal = src.name
			T.date = worlddate2text()
			T.time = worldtime2text()
			SSeconomy.add_transaction_log(customer_account,T)
			return TRUE
	else if(S)
		if(total_price > S.worth)
			ping("Insufficient funds!")
			return FALSE
		else
			S.worth -= total_price
			if(S.worth <= 0)
				qdel(S)
			else
				S.update_icon()
			return TRUE

	else // just incase
		ping("You cannot pay with this!")
		return FALSE