/obj/item/card/id/var/money = 2000

/obj/machinery/atm
	name = "Idris SelfServ Teller"
	desc = "For all your monetary needs! Astronomical figures!"
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "atm"
	anchored = 1
	idle_power_usage = 10
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/held_card
	var/editing_security_level = 0

/obj/machinery/atm/Initialize()
	. = ..()
	machine_id = "[SSeconomy.num_financial_terminals++]"
	update_icon()

/obj/machinery/atm/Destroy()
	authenticated_account = null
	if (held_card)
		held_card.forceMove(loc)
		held_card = null

	return ..()

/obj/machinery/atm/power_change()
	..()
	update_icon()

/obj/machinery/atm/update_icon()
	cut_overlays()
	if(stat & NOPOWER)
		set_light(FALSE)
		return

	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "atm-active", EFFECTS_ABOVE_LIGHTING_LAYER)
	add_overlay(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)

	if(held_card)
		var/mutable_appearance/card_overlay = mutable_appearance(icon, "atm-cardin", EFFECTS_ABOVE_LIGHTING_LAYER)
		add_overlay(card_overlay)

/obj/machinery/atm/process()
	if(stat & NOPOWER)
		cut_overlays()
		set_light(FALSE)
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/spacecash/S in src)
		S.forceMove(src.loc)
		playsound(loc, /singleton/sound_category/print_sound, 50, 1)

/obj/machinery/atm/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		return

	//short out the machine, shoot sparks, spew money!
	emagged = 1
	spark(src, 5, alldirs)
	spawn_money(rand(2000,5000),src.loc)
	//we don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//display a message to the user
	var/response = pick("Initiating withdrawal. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
	to_chat(user, SPAN_WARNING("[icon2html(src, user)] The [src] beeps: \"[response]\""))
	intent_message(MACHINE_SOUND)
	return 1

/obj/machinery/atm/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card))
		if(emagged)
			//prevent inserting id into an emagged ATM
			to_chat(user, SPAN_WARNING("[icon2html(src, user)] CARD READER ERROR. This system has been compromised!"))
			return
		else if(istype(I,/obj/item/card/emag))
			I.resolve_attackby(src, user)
			return

		var/obj/item/card/id/idcard = I
		if(!held_card)
			usr.drop_from_inventory(idcard,src)
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
			update_icon()
	else if(authenticated_account)
		if(istype(I,/obj/item/spacecash))
			//consume the money
			authenticated_account.money += I:worth
			playsound(loc, /singleton/sound_category/print_sound, 50, 1)

			//create a transaction log entry
			var/datum/transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = I:worth
			T.source_terminal = machine_id
			T.date = worlddate2text()
			T.time = worldtime2text()
			SSeconomy.add_transaction_log(authenticated_account,T)

			intent_message(MACHINE_SOUND)
			to_chat(user, SPAN_NOTICE("You insert [I] into [src]."))
			src.attack_hand(user)
			qdel(I)
	else
		..()

/obj/machinery/atm/attack_hand(mob/user)
	. = ..()
	if(issilicon(user))
		to_chat(user, SPAN_WARNING("[icon2html(src, user)] Artificial unit recognized. Artificial units do not currently receive monetary compensation, \
						as per system banking regulation #1005."))
		return

	ui_interact(user)

/obj/machinery/atm/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ATM", "Idris ATM #[machine_id]", 550, 650)
		ui.open()

/obj/machinery/atm/ui_data(mob/user)
	var/list/data = list()
	data["machine_id"] = machine_id
	data["card"] = held_card ? held_card.name : null
	data["ticks_left_locked_down"] = ticks_left_locked_down
	data["authenticated_account"] = !!authenticated_account
	if(authenticated_account)
		data["owner_name"] = authenticated_account.owner_name
		data["security_level"] = authenticated_account.security_level
		data["suspended"] = authenticated_account.suspended
		data["money"] = authenticated_account.money
	data["number_incorrect_tries"] = number_incorrect_tries
	data["emagged"] = emagged
	if(authenticated_account)
		data["transactions"] = list()
		for(var/datum/transaction/T in authenticated_account.transactions)
			data["transactions"] += list(list(
				"target_name" = T.target_name,
				"purpose" = T.purpose,
				"amount" = T.amount,
				"date" = T.date,
				"time" = T.time,
				"source_terminal" = T.source_terminal
			))
	return data

/obj/machinery/atm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("transfer")
			if(authenticated_account)
				var/transfer_amount = text2num(params["funds_amount"])
				transfer_amount = round(transfer_amount, 0.01)
				if(transfer_amount <= 0)
					to_chat(usr, SPAN_WARNING("That is an invalid amount!"))
				else if(transfer_amount <= authenticated_account.money)
					var/target_account_number = text2num(params["target_acc_number"])
					var/transfer_purpose = params["purpose"]
					if(SSeconomy.charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
						to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] Funds transfer successful."))
						authenticated_account.money -= transfer_amount

						//create an entry in the account transaction log
						var/datum/transaction/T = new()
						T.target_name = "Account #[target_account_number]"
						T.purpose = transfer_purpose
						T.source_terminal = machine_id
						T.date = worlddate2text()
						T.time = worldtime2text()
						T.amount = "([transfer_amount])"
						SSeconomy.add_transaction_log(authenticated_account,T)
						. = TRUE
					else
						to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] Funds transfer failed."))

				else
					to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] You don't have enough funds to do that!"))

		if("change_security_level")
			if(authenticated_account)
				var/new_sec_level = max( min(text2num(params["new_security_level"]), 2), 0)
				authenticated_account.security_level = new_sec_level
				. = TRUE

		if("attempt_auth")
			if (ticks_left_locked_down)
				return
			if (!held_card && !params["account_num"])
				return
			var/tried_account_num = text2num(params["account_num"])
			if (!tried_account_num && held_card)
				tried_account_num = held_card.associated_account_number
			var/tried_pin = text2num(params["account_pin"])
			var/datum/money_account/potential_account = SSeconomy.get_account(tried_account_num)
			if (!potential_account)
				to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] Account not found."))
				number_incorrect_tries++
				handle_lockdown()
				return TRUE
			switch (potential_account.security_level+1) //checks the security level of an account number to see what checks to do
				if (1) // Security level zero
					authenticated_account = SSeconomy.attempt_account_access(tried_account_num, tried_pin, potential_account.security_level)
					// It should be impossible to fail at this point
				if (2) // Security level one
					authenticated_account = SSeconomy.attempt_account_access(text2num(params["account_num"]), tried_pin, potential_account.security_level)
				if (3) // Security level two
					if (held_card)
						if (text2num(params["account_num"]) == held_card.associated_account_number)
							authenticated_account = SSeconomy.attempt_account_access(tried_account_num, tried_pin, potential_account.security_level)
					else to_chat(usr, SPAN_WARNING("Account not found."))
			if (!authenticated_account)
				number_incorrect_tries++
				to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] Incorrect pin/account combination entered, [(max_pin_attempts+1) - number_incorrect_tries] attempts remaining."))
				handle_lockdown(tried_account_num)
				. = TRUE
			else
				SSeconomy.bank_log_access(authenticated_account, machine_id)
				number_incorrect_tries = 0
				playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
				ticks_left_timeout = 120
				to_chat(usr, SPAN_NOTICE("[icon2html(src, usr)] Access granted. Welcome, [authenticated_account.owner_name], and have an Idris day!"))
				. = TRUE
			previous_account_number = tried_account_num

		if("e_withdrawal")
			var/amount = max(text2num(params["funds_amount"]),0)
			amount = round(amount, 0.01)
			if(amount <= 0)
				to_chat(usr, SPAN_WARNING("That is an invalid amount!"))
			else if(authenticated_account && amount > 0)
				if(amount <= authenticated_account.money)
					playsound(src, 'sound/machines/chime.ogg', 50, 1)

					//remove the money
					authenticated_account.money -= amount

					//	spawn_money(amount,src.loc)
					spawn_ewallet(amount,src.loc,usr)
					intent_message(MACHINE_SOUND)

					//create an entry in the account transaction log
					var/datum/transaction/T = new()
					T.target_name = authenticated_account.owner_name
					T.purpose = "Credit withdrawal"
					T.amount = "([amount])"
					T.source_terminal = machine_id
					T.date = worlddate2text()
					T.time = worldtime2text()
					SSeconomy.add_transaction_log(authenticated_account,T)
					. = TRUE
				else
					to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] You don't have enough funds to do that!"))
		if("withdrawal")
			var/amount = max(text2num(params["funds_amount"]),0)
			amount = round(amount, 0.01)
			if(amount <= 0)
				to_chat(usr, SPAN_WARNING("That is an invalid amount!"))
			else if(authenticated_account && amount > 0)
				if(amount <= authenticated_account.money)
					playsound(src, 'sound/machines/chime.ogg', 50, 1)

					//remove the money
					authenticated_account.money -= amount

					spawn_money(amount,src.loc,usr)
					intent_message(MACHINE_SOUND)

					//create an entry in the account transaction log
					var/datum/transaction/T = new()
					T.target_name = authenticated_account.owner_name
					T.purpose = "Credit withdrawal"
					T.amount = "([amount])"
					T.source_terminal = machine_id
					T.date = worlddate2text()
					T.time = worldtime2text()
					SSeconomy.add_transaction_log(authenticated_account,T)
				else
					to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] You don't have enough funds to do that!"))
					. = TRUE

		if("balance_statement")
			if(authenticated_account)
				var/obj/item/paper/R = new()
				var/pname = "Account balance: [authenticated_account.owner_name]"
				var/info = "<b>Idris Automated Teller Account Statement</b><br><br>"
				info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
				info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
				info += "<i>Balance:</i> $[authenticated_account.money]<br>"
				info += "<i>Date and time:</i> [worldtime2text()], [worlddate2text()]<br><br>"
				info += "<i>Service terminal ID:</i> [machine_id]<br>"
				R.set_content_unsafe(pname, info)

				//stamp the paper
				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-cent"
				if(!R.stamped)
					R.stamped = new
				R.stamped += /obj/item/stamp
				R.add_overlay(stampoverlay)
				R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"
				print(R, user = usr)

				release_held_id(usr) // printing ends the ATM session similar to real life + prevents spam
				. = TRUE

			playsound(loc, /singleton/sound_category/print_sound, 50, 1)
		if ("print_transaction")
			if(authenticated_account)
				var/obj/item/paper/R = new()
				var/pname = "Transaction logs: [authenticated_account.owner_name]"
				var/info = "<b>Transaction logs</b><br>"
				info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
				info += "<i>Account number:</i> [authenticated_account.account_number]<br>"
				info += "<i>Date and time:</i> [worldtime2text()], [worlddate2text()]<br><br>"
				info += "<i>Service terminal ID:</i> [machine_id]<br>"
				info += "<table border=1 style='width:100%'>"
				info += "<tr>"
				info += "<td><b>Date</b></td>"
				info += "<td><b>Time</b></td>"
				info += "<td><b>Target</b></td>"
				info += "<td><b>Purpose</b></td>"
				info += "<td><b>Value</b></td>"
				info += "<td><b>Source terminal ID</b></td>"
				info += "</tr>"
				for(var/datum/transaction/T in authenticated_account.transactions)
					info += "<tr>"
					info += "<td>[T.date]</td>"
					info += "<td>[T.time]</td>"
					info += "<td>[T.target_name]</td>"
					info += "<td>[T.purpose]</td>"
					info += "<td>$[T.amount]</td>"
					info += "<td>[T.source_terminal]</td>"
					info += "</tr>"
				info += "</table>"

				R.set_content_unsafe(pname, info)

				//stamp the paper
				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-cent"
				if(!R.stamped)
					R.stamped = new
				R.stamped += /obj/item/stamp
				R.add_overlay(stampoverlay)
				R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"
				print(R, user = usr)

			playsound(loc, /singleton/sound_category/print_sound, 50, 1)
			release_held_id(usr) // printing ends the ATM session similar to real life + prevents spam
			. = TRUE

		if("insert_card")
			if(!held_card)
				//this might happen if the user had the browser window open when somebody emagged it
				if(emagged)
					to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] The ATM card reader rejects your ID!"))
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card/id))
						usr.drop_from_inventory(I,src)
						held_card = I
						update_icon()
						. = TRUE
			else
				release_held_id(usr)
				. = TRUE

		if("logout")
			authenticated_account = null
			. = TRUE

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user)
	if(!authenticated_account)
		if(istype(human_user))
			var/obj/item/card/id/I = human_user.GetIdCard()
			if(istype(I))
				authenticated_account = SSeconomy.attempt_account_access(I.associated_account_number)
				if(authenticated_account)
					to_chat(human_user, SPAN_WARNING("[icon2html(src, usr)] Access granted. Welcome, [authenticated_account.owner_name]."))

					//create a transaction log entry
					var/datum/transaction/T = new()
					T.target_name = authenticated_account.owner_name
					T.purpose = "Remote terminal access"
					T.source_terminal = machine_id
					T.date = worlddate2text()
					T.time = worldtime2text()
					SSeconomy.add_transaction_log(authenticated_account,T)

// checks if the ATM needs to be locked down and locks it down if it does
/obj/machinery/atm/proc/handle_lockdown(var/tried_account_num = null)
	if (number_incorrect_tries > max_pin_attempts)
		//lock down the atm
		var/area/t = get_area(src)
		ticks_left_locked_down = 60
		playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
		global_announcer.autosay("An ATM has gone into lockdown in [t.name].", machine_id)
		if (tried_account_num)
			SSeconomy.bank_log_unauthorized(SSeconomy.get_account(tried_account_num), machine_id)
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)


/obj/machinery/atm/AltClick(var/mob/user)
	release_held_id(user)

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user as mob)

	if (!ishuman(human_user))
		return

	if(!held_card)
		return

	if(human_user.stat || human_user.lying || human_user.restrained() || !Adjacent(human_user))	return

	held_card.forceMove(src.loc)
	authenticated_account = null

	if(!human_user.get_active_hand())
		human_user.put_in_hands(held_card)
	held_card = null
	authenticated_account = null
	update_icon()

/obj/machinery/atm/proc/spawn_ewallet(var/sum, loc, mob/living/carbon/human/human_user as mob)
	var/obj/item/spacecash/ewallet/E = new /obj/item/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name
