// A vendor machine for modular computer portable devices - Laptops and Tablets

// Vendor machine state
#define LAPVEND_STATE_SELECT   0	// Select device type
#define LAPVEND_STATE_CONFIGURE 1	// Select hardware loadout
#define LAPVEND_STATE_PAYMENT  2	// Awaiting payment
#define LAPVEND_STATE_COMPLETE 3	// Thank-you screen

// Device types
#define LAPVEND_DEVICE_NONE   0
#define LAPVEND_DEVICE_LAPTOP 1
#define LAPVEND_DEVICE_TABLET 2
#define LAPVEND_DEVICE_PDA    3

/obj/structure/machinery/lapvend
	name = "computer vendor"
	desc = "A vending machine with microfabricator capable of dispensing various NT-branded computers."
	icon = 'icons/obj/vending.dmi'
	icon_state = "robotics"
	anchored = TRUE
	density = TRUE

	// The actual laptop/tablet
	var/obj/item/modular_computer/laptop/fabricated_laptop
	var/obj/item/modular_computer/handheld/fabricated_tablet
	var/obj/item/modular_computer/handheld/pda/fabricated_pda

	// Utility vars
	var/state = LAPVEND_STATE_SELECT
	var/devtype = LAPVEND_DEVICE_NONE
	var/total_price = 0						// Price of currently vended device.

	// Device loadout
	var/dev_cpu = 1							// 1: Default, 2: Upgraded
	var/dev_battery = 1						// 1: Default, 2: Upgraded, 3: Advanced
	var/dev_disk = 1						// 1: Default, 2: Upgraded, 3: Advanced
	var/dev_netcard = 0						// 0: None, 1: Basic, 2: Long-Range
	var/dev_tesla = 0						// 0: None, 1: Standard
	var/dev_nanoprint = 0					// 0: None, 1: Standard
	var/dev_card = 0						// 0: None, 1: Standard
	var/dev_aislot = 0						// 0: None, 1: Standard

// Removes all traces of old order and allows you to begin configuration from scratch.
/obj/structure/machinery/lapvend/proc/reset_order()
	state = LAPVEND_STATE_SELECT
	devtype = LAPVEND_DEVICE_NONE
	if(fabricated_laptop)
		qdel(fabricated_laptop)
		fabricated_laptop = null
	if(fabricated_tablet)
		qdel(fabricated_tablet)
		fabricated_tablet = null
	if(fabricated_pda)
		qdel(fabricated_pda)
		fabricated_pda = null
	dev_cpu = 1
	dev_battery = 1
	dev_disk = 1
	dev_netcard = 0
	dev_tesla = 0
	dev_nanoprint = 0
	dev_card = 0
	dev_aislot = 0

// Recalculates the price and optionally even fabricates the device.
/obj/structure/machinery/lapvend/proc/fabricate_and_recalc_price(fabricate = FALSE)
	total_price = 0
	if(devtype == LAPVEND_DEVICE_LAPTOP) 		// Laptop, generally cheaper to make it accessible for most station roles
		if(fabricate)
			fabricated_laptop = new(src)
		total_price = 99
		switch(dev_cpu)
			if(1)
				if(fabricate)
					fabricated_laptop.processor_unit = new/obj/item/computer_hardware/processor_unit/small(fabricated_laptop)
			if(2)
				if(fabricate)
					fabricated_laptop.processor_unit = new/obj/item/computer_hardware/processor_unit(fabricated_laptop)
				total_price += 199
		switch(dev_battery)
			if(1) //Micro(500C)
				if(fabricate)
					fabricated_laptop.battery_module = new/obj/item/computer_hardware/battery_module/micro(fabricated_laptop)
			if(2) // Basic(750C)
				if(fabricate)
					fabricated_laptop.battery_module = new/obj/item/computer_hardware/battery_module(fabricated_laptop)
				total_price += 99
			if(3) // Upgraded(1100C)
				if(fabricate)
					fabricated_laptop.battery_module = new/obj/item/computer_hardware/battery_module/advanced(fabricated_laptop)
				total_price += 499
		switch(dev_disk)
			if(1)
				if(fabricate)
					fabricated_laptop.hard_drive = new/obj/item/computer_hardware/hard_drive/small(fabricated_laptop)
			if(2) // Basic(128GQ)
				if(fabricate)
					fabricated_laptop.hard_drive = new/obj/item/computer_hardware/hard_drive(fabricated_laptop)
				total_price += 99
			if(3)  // Upgraded(256GQ)
				if(fabricate)
					fabricated_laptop.hard_drive = new/obj/item/computer_hardware/hard_drive/advanced(fabricated_laptop)
				total_price += 299
		switch(dev_netcard)
			if(1) // Basic(Short-Range)
				if(fabricate)
					fabricated_laptop.network_card = new/obj/item/computer_hardware/network_card(fabricated_laptop)
				total_price += 99
			if(2) // Advanced (Long Range)
				if(fabricate)
					fabricated_laptop.network_card = new/obj/item/computer_hardware/network_card/advanced(fabricated_laptop)
				total_price += 299
		if(dev_tesla)
			total_price += 399
			if(fabricate)
				fabricated_laptop.tesla_link = new/obj/item/computer_hardware/tesla_link(fabricated_laptop)
		if(dev_nanoprint)
			total_price += 99
			if(fabricate)
				fabricated_laptop.nano_printer = new/obj/item/computer_hardware/nano_printer(fabricated_laptop)
		if(dev_card)
			total_price += 99
			if(fabricate)
				fabricated_laptop.card_slot = new/obj/item/computer_hardware/card_slot(fabricated_laptop)
		if(dev_aislot)
			total_price += 499
			if(fabricate)
				fabricated_laptop.ai_slot = new/obj/item/computer_hardware/ai_slot(fabricated_laptop)

		return total_price
	else if(devtype == LAPVEND_DEVICE_TABLET) 	// Tablet more expensive, not everyone could probably afford this.
		if(fabricate)
			fabricated_tablet = new(src)
		total_price = 199
		switch(dev_cpu)
			if(1)
				if(fabricate)
					fabricated_tablet.processor_unit = new/obj/item/computer_hardware/processor_unit/small(fabricated_tablet)
			if(2)
				if(fabricate)
					fabricated_tablet.processor_unit = new/obj/item/computer_hardware/processor_unit/small/adv(fabricated_tablet)
				total_price += 299
		switch(dev_battery)
			if(1) // Basic(300C)
				if(fabricate)
					fabricated_tablet.battery_module = new/obj/item/computer_hardware/battery_module/nano(fabricated_tablet)
			if(2) // Upgraded(500C)
				if(fabricate)
					fabricated_tablet.battery_module = new/obj/item/computer_hardware/battery_module/micro(fabricated_tablet)
				total_price += 99
			if(3) // Advanced(750C)
				if(fabricate)
					fabricated_tablet.battery_module = new/obj/item/computer_hardware/battery_module(fabricated_tablet)
				total_price += 149
		switch(dev_disk)
			if(1) // Basic(32GQ)
				if(fabricate)
					fabricated_tablet.hard_drive = new/obj/item/computer_hardware/hard_drive/micro(fabricated_tablet)
			if(2) // Upgraded(64GQ)
				if(fabricate)
					fabricated_tablet.hard_drive = new/obj/item/computer_hardware/hard_drive/small(fabricated_tablet)
				total_price += 49
			if(3) // Advanced(128GQ)
				if(fabricate)
					fabricated_tablet.hard_drive = new/obj/item/computer_hardware/hard_drive(fabricated_tablet)
				total_price += 129
		switch(dev_netcard)
			if(1) // Basic(Short-Range)
				if(fabricate)
					fabricated_tablet.network_card = new/obj/item/computer_hardware/network_card(fabricated_tablet)
				total_price += 49
			if(2) // Advanced (Long Range)
				if(fabricate)
					fabricated_tablet.network_card = new/obj/item/computer_hardware/network_card/advanced(fabricated_tablet)
				total_price += 129
		if(dev_nanoprint)
			total_price += 49
			if(fabricate)
				fabricated_tablet.nano_printer = new/obj/item/computer_hardware/nano_printer(fabricated_tablet)
		if(dev_card)
			total_price += 99
			if(fabricate)
				fabricated_tablet.card_slot = new/obj/item/computer_hardware/card_slot(fabricated_tablet)
		if(dev_tesla)
			total_price += 459
			if(fabricate)
				fabricated_tablet.tesla_link = new/obj/item/computer_hardware/tesla_link(fabricated_tablet)
		if(dev_aislot)
			total_price += 199
			if(fabricate)
				fabricated_tablet.ai_slot = new/obj/item/computer_hardware/ai_slot(fabricated_tablet)
		return total_price
	else if(devtype == LAPVEND_DEVICE_PDA) 	// PDA, same cost as tablet but smaller form factor
		if(fabricate)
			fabricated_pda = new(src)
		total_price = 199
		switch(dev_cpu)
			if(1)
				if(fabricate)
					fabricated_pda.processor_unit = new/obj/item/computer_hardware/processor_unit/small(fabricated_pda)
			if(2)
				if(fabricate)
					fabricated_pda.processor_unit = new/obj/item/computer_hardware/processor_unit/small/adv(fabricated_pda)
				total_price += 299
		switch(dev_battery)
			if(1) // Basic(300C)
				if(fabricate)
					fabricated_pda.battery_module = new/obj/item/computer_hardware/battery_module/nano(fabricated_pda)
			if(2) // Upgraded(500C)
				if(fabricate)
					fabricated_pda.battery_module = new/obj/item/computer_hardware/battery_module/micro(fabricated_pda)
				total_price += 99
			if(3) // Advanced(750C)
				if(fabricate)
					fabricated_pda.battery_module = new/obj/item/computer_hardware/battery_module(fabricated_pda)
				total_price += 149
		switch(dev_disk)
			if(1) // Basic(32GQ)
				if(fabricate)
					fabricated_pda.hard_drive = new/obj/item/computer_hardware/hard_drive/micro(fabricated_pda)
			if(2) // Upgraded(64GQ)
				if(fabricate)
					fabricated_pda.hard_drive = new/obj/item/computer_hardware/hard_drive/small(fabricated_pda)
				total_price += 49
			if(3) // Advanced(128GQ)
				if(fabricate)
					fabricated_pda.hard_drive = new/obj/item/computer_hardware/hard_drive(fabricated_pda)
				total_price += 129
		switch(dev_netcard)
			if(1) // Basic(Short-Range)
				if(fabricate)
					fabricated_pda.network_card = new/obj/item/computer_hardware/network_card(fabricated_pda)
				total_price += 49
			if(2) // Advanced (Long Range)
				if(fabricate)
					fabricated_pda.network_card = new/obj/item/computer_hardware/network_card/advanced(fabricated_pda)
				total_price += 129
		if(dev_nanoprint)
			total_price += 49
			if(fabricate)
				fabricated_pda.nano_printer = new/obj/item/computer_hardware/nano_printer(fabricated_pda)
		if(dev_card)
			total_price += 99
			if(fabricate)
				fabricated_pda.card_slot = new/obj/item/computer_hardware/card_slot(fabricated_pda)
		if(dev_tesla)
			total_price += 459
			if(fabricate)
				fabricated_pda.tesla_link = new/obj/item/computer_hardware/tesla_link(fabricated_pda)
		if(dev_aislot)
			total_price += 199
			if(fabricate)
				fabricated_pda.ai_slot = new/obj/item/computer_hardware/ai_slot(fabricated_pda)
		return total_price
	return 0


/obj/structure/machinery/lapvend/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("pick_device")
			if(src.state) // We've already picked a device type
				return TRUE
			devtype = text2num(params["devtype"])
			src.state = LAPVEND_STATE_CONFIGURE
			fabricate_and_recalc_price(FALSE)
			return TRUE

		if("clean_order")
			reset_order()
			return TRUE

		if("confirm_order")
			if(src.state != LAPVEND_STATE_CONFIGURE || !devtype)
				return TRUE
			src.state = LAPVEND_STATE_PAYMENT
			fabricate_and_recalc_price(FALSE)
			return TRUE

		if("set_hw")
			if(src.state != LAPVEND_STATE_CONFIGURE || !devtype)
				return TRUE
			var/hw = params["hw"]
			var/val = text2num(params["val"])
			switch(hw)
				if("cpu")
					dev_cpu = val
				if("battery")
					dev_battery = val
				if("disk")
					dev_disk = val
				if("netcard")
					dev_netcard = val
				if("tesla")
					dev_tesla = val
				if("nanoprint")
					dev_nanoprint = val
				if("card")
					dev_card = val
				if("aislot")
					dev_aislot = val
			fabricate_and_recalc_price(FALSE)
			return TRUE

/obj/structure/machinery/lapvend/attack_hand(mob/user)
	. = ..()
	if(anchored)
		ui_interact(user)
	else
		to_chat(user, SPAN_NOTICE("\The [src] needs to be anchored to the floor to function!"))

/obj/structure/machinery/lapvend/ui_interact(mob/user, datum/tgui/ui)
	if(stat & (BROKEN | NOPOWER | MAINT))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ComputerFabricator", "Personal Computer Vendor")
		ui.open()

/obj/structure/machinery/lapvend/ui_data(mob/user)
	var/list/data = list("state" = src.state)
	if(src.state == LAPVEND_STATE_CONFIGURE)
		data["devtype"] = devtype
		data["hw_cpu"] = dev_cpu
		data["hw_battery"] = dev_battery
		data["hw_disk"] = dev_disk
		data["hw_netcard"] = dev_netcard
		data["hw_tesla"] = dev_tesla
		data["hw_nanoprint"] = dev_nanoprint
		data["hw_card"] = dev_card
		data["hw_aislot"] = dev_aislot
	if(src.state == LAPVEND_STATE_CONFIGURE || src.state == LAPVEND_STATE_PAYMENT)
		data["totalprice"] = total_price
	return data

/obj/structure/machinery/lapvend/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_WRENCH)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(anchored)
			user.visible_message("<b>[user]</b> begins unsecuring \the [src] from the floor.", \
								SPAN_NOTICE("You start unsecuring \the [src] from the floor."))
		else
			user.visible_message("<b>[user]</b> begins securing \the [src] to the floor.", \
								SPAN_NOTICE("You start securing \the [src] to the floor."))
		if(attacking_item.use_tool(src, user, 20, volume = 50))
			if(!src)
				return
			to_chat(user, SPAN_NOTICE("You [anchored ? "un" : ""]secured \the [src]!"))
			anchored = !anchored
		return
	else if(state == LAPVEND_STATE_PAYMENT) // awaiting payment state
		var/obj/item/card/id/id_card = attacking_item.GetID()
		if(id_card)
			if(process_payment(id_card, attacking_item))
				create_device(user)
				return TRUE
		else if(istype(attacking_item, /obj/item/card/tech_support))
			create_device(user, "Have a NanoTrasen day!")
			return TRUE
	return ..()

/obj/structure/machinery/lapvend/proc/create_device(mob/user, message = "Enjoy your new product!")
	fabricate_and_recalc_price(TRUE)
	if((devtype == LAPVEND_DEVICE_LAPTOP) && fabricated_laptop)
		fabricated_laptop.forceMove(src.loc)
		if(fabricated_laptop.battery_module)
			fabricated_laptop.battery_module.charge_to_full()
		fabricated_laptop.screen_on = 0
		fabricated_laptop.anchored = 0
		fabricated_laptop.update_icon()
		if(Adjacent(user))
			user.put_in_hands(fabricated_laptop)
		fabricated_laptop = null
	else if((devtype == LAPVEND_DEVICE_TABLET) && fabricated_tablet)
		fabricated_tablet.forceMove(src.loc)
		if(fabricated_tablet.battery_module)
			fabricated_tablet.battery_module.charge_to_full()
		if(Adjacent(user))
			user.put_in_hands(fabricated_tablet)
		fabricated_tablet = null
	else if((devtype == LAPVEND_DEVICE_PDA) && fabricated_pda)
		fabricated_pda.forceMove(src.loc)
		if(fabricated_pda.battery_module)
			fabricated_pda.battery_module.charge_to_full()
		if(Adjacent(user))
			user.put_in_hands(fabricated_pda)
		fabricated_pda = null
	ping(message)
	intent_message(MACHINE_SOUND)
	state = LAPVEND_STATE_COMPLETE

// Simplified payment processing, returns TRUE on success.
/obj/structure/machinery/lapvend/proc/process_payment(obj/item/card/id/id_card, obj/item/id_container)
	var/obj/item/spacecash/cash = null
	if(istype(id_container, /obj/item/spacecash))
		cash = id_container
	if(id_card == id_container || !id_container)
		visible_message("<span class='info'>\The [usr] swipes \the [id_card] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [id_container] through \the [src].</span>")
	playsound(src.loc, 'sound/machines/id_swipe.ogg', 50, 1)
	if(id_card)
		//Allow BSTs to take stuff from vendors, for debugging and adminbus purposes
		if(istype(id_card, /obj/item/card/id/bst))
			return TRUE
		var/datum/money_account/customer_account = SSeconomy.get_account(id_card.associated_account_number)
		if(!customer_account || customer_account.suspended)
			ping("Connection error. Unable to connect to account.")
			return FALSE

		if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
			var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
			customer_account = SSeconomy.attempt_account_access(id_card.associated_account_number, attempt_pin, 2)

			if(!customer_account)
				ping("Unable to access account: incorrect credentials.")
				return FALSE

		if(total_price > customer_account.money)
			ping("Insufficient funds in account.")
			return FALSE
		else
			customer_account.money -= total_price
			var/datum/transaction/transaction = new()
			transaction.target_name = "Computer Manufacturer (via [src.name])"
			transaction.purpose = "Purchase of [(devtype == LAPVEND_DEVICE_LAPTOP) ? "laptop computer" : "tablet microcomputer"]."
			transaction.amount = total_price
			transaction.source_terminal = src.name
			transaction.date = worlddate2text()
			transaction.time = worldtime2text()
			SSeconomy.add_transaction_log(customer_account, transaction)
			return TRUE
	else if(cash)
		if(total_price > cash.worth)
			ping("Insufficient funds!")
			return FALSE
		else
			cash.worth -= total_price
			if(cash.worth <= 0)
				qdel(cash)
			else
				cash.update_icon()
			return TRUE

	else // just incase
		ping("You cannot pay with this!")
		return FALSE

#undef LAPVEND_STATE_SELECT
#undef LAPVEND_STATE_CONFIGURE
#undef LAPVEND_STATE_PAYMENT
#undef LAPVEND_STATE_COMPLETE
#undef LAPVEND_DEVICE_NONE
#undef LAPVEND_DEVICE_LAPTOP
#undef LAPVEND_DEVICE_TABLET
#undef LAPVEND_DEVICE_PDA
