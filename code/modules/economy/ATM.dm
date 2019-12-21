/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define VIEW_TRANSACTION_LOGS 3

/obj/item/card/id/var/money = 2000

/obj/machinery/atm
	name = "Idris SelfServ Teller"
	desc = "For all your monetary needs! Astronomical figures!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/held_card
	var/editing_security_level = 0
	var/view_screen = NO_SCREEN

/obj/machinery/atm/Initialize()
	. = ..()
	machine_id = "Idris SelfServ #[SSeconomy.num_financial_terminals++]"

/obj/machinery/atm/Destroy()
	authenticated_account = null
	if (held_card)
		held_card.forceMove(loc)
		held_card = null

	return ..()


/obj/machinery/atm/machinery_process()
	if(stat & NOPOWER)
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
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
		break

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
	var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
	to_chat(user, "<span class='warning'>\icon[src] The [src] beeps: \"[response]\"</span>")
	return 1

/obj/machinery/atm/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/card))
		if(emagged)
			//prevent inserting id into an emagged ATM
			to_chat(user, "<span class='warning'>\icon[src] CARD READER ERROR. This system has been compromised!</span>")
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
	else if(authenticated_account)
		if(istype(I,/obj/item/spacecash))
			//consume the money
			authenticated_account.money += I:worth
			if(prob(50))
				playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			//create a transaction log entry
			var/datum/transaction/T = new()
			T.target_name = authenticated_account.owner_name
			T.purpose = "Credit deposit"
			T.amount = I:worth
			T.source_terminal = machine_id
			T.date = worlddate2text()
			T.time = worldtime2text()
			SSeconomy.add_transaction_log(authenticated_account,T)


			to_chat(user, "<span class='info'>You insert [I] into [src].</span>")
			src.attack_hand(user)
			qdel(I)
	else
		..()

/obj/machinery/atm/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/silicon))
		to_chat(user, "<span class='warning'>\icon[src] Artificial unit recognized. Artificial units do not currently receive monetary compensation, as per system banking regulation #1005.</span>")
		return
	if(get_dist(src,user) <= 1)

		//js replicated from obj/machinery/computer/card
		var/dat = "<h1>Automatic Teller Machine</h1>"
		dat += "For all your monetary needs!<br>"
		dat += "<i>This terminal is</i> [machine_id]. <i>Report this code when contacting Idris Banking Support</i><br/>"

		if(emagged)
			dat += "Card: <span style='color: red;'>LOCKED</span><br><br><span style='color: red;'>Unauthorized terminal access detected! This ATM has been locked. Please contact Idris Banking Support.</span>"
		else
			dat += "Card: <a href='?src=\ref[src];choice=insert_card'>[held_card ? held_card.name : "------"]</a><br><br>"

			if(ticks_left_locked_down > 0)
				dat += "<span class='alert'>Maximum number of pin attempts exceeded! Access to this ATM has been temporarily disabled.</span>"
			else if(authenticated_account)
				if(authenticated_account.suspended)
					dat += "<span class='danger'>Access to this account has been suspended, and the funds within frozen.</span>"
				else
					switch(view_screen)
						if(CHANGE_SECURITY_LEVEL)
							dat += "Select a new security level for this account:<br><hr>"
							var/text = "Zero - Either the account number or card is required to access this account. EFTPOS transactions will require a card and ask for a pin, but not verify the pin is correct."
							if(authenticated_account.security_level != 0)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=0'>[text]</a>"
							dat += "[text]<hr>"
							text = "One - An account number and pin must be manually entered to access this account and process transactions."
							if(authenticated_account.security_level != 1)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=1'>[text]</a>"
							dat += "[text]<hr>"
							text = "Two - In addition to account number and pin, a card is required to access this account and process transactions."
							if(authenticated_account.security_level != 2)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=2'>[text]</a>"
							dat += "[text]<hr><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
						if(VIEW_TRANSACTION_LOGS)
							dat += "<b>Transaction logs</b><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
							dat += "<table border=1 style='width:100%'>"
							dat += "<tr>"
							dat += "<td><b>Date</b></td>"
							dat += "<td><b>Time</b></td>"
							dat += "<td><b>Target</b></td>"
							dat += "<td><b>Purpose</b></td>"
							dat += "<td><b>Value</b></td>"
							dat += "<td><b>Source terminal ID</b></td>"
							dat += "</tr>"
							for(var/datum/transaction/T in authenticated_account.transactions)
								dat += "<tr>"
								dat += "<td>[T.date]</td>"
								dat += "<td>[T.time]</td>"
								dat += "<td>[T.target_name]</td>"
								dat += "<td>[T.purpose]</td>"
								dat += "<td>$[T.amount]</td>"
								dat += "<td>[T.source_terminal]</td>"
								dat += "</tr>"
							dat += "</table>"
							dat += "<A href='?src=\ref[src];choice=print_transaction'>Print</a><br>"
						if(TRANSFER_FUNDS)
							dat += "<b>Account balance:</b> $[authenticated_account.money]<br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a><br><br>"
							dat += "<form name='transfer' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='hidden' name='choice' value='transfer'>"
							dat += "Target account number: <input type='text' name='target_acc_number' value='' style='width:200px; background-color:white;'><br>"
							dat += "Funds to transfer: <input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><br>"
							dat += "Transaction purpose: <input type='text' name='purpose' value='Funds transfer' style='width:200px; background-color:white;'><br>"
							dat += "<input type='submit' value='Transfer funds'><br>"
							dat += "</form>"
						else
							dat += "Welcome, <b>[authenticated_account.owner_name].</b><br/>"
							dat += "<b>Account balance:</b> $[authenticated_account.money]"
							dat += "<form name='withdrawal' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='radio' name='choice' value='withdrawal' checked> Cash  <input type='radio' name='choice' value='e_withdrawal'> Chargecard<br>"
							dat += "<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><input type='submit' value='Withdraw'>"
							dat += "</form>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=1'>Change account security level</a><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=2'>Make transfer</a><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=3'>View transaction log</a><br>"
							dat += "<A href='?src=\ref[src];choice=balance_statement'>Print balance statement</a><br>"
							dat += "<A href='?src=\ref[src];choice=logout'>Logout</a><br>"
			else
				dat += "<form name='atm_auth' action='?src=\ref[src]' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='choice' value='attempt_auth'>"
				dat += "<b>Account:</b> <input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;'><br>"
				dat += "<b>PIN:</b> <input type='text' id='account_pin' name='account_pin' style='width:250px; background-color:white;'><br>"
				dat += "<input type='submit' value='Submit'><br>"
				dat += "</form>"

		send_theme_resources(user)
		user << browse(enable_ui_theme(user, dat),"window=atm;size=550x650")
	else
		user << browse(null,"window=atm")

/obj/machinery/atm/Topic(var/href, var/href_list)
	if(href_list["choice"])
		if (!usr.Adjacent(src)) return
		switch(href_list["choice"])
			if("transfer")
				if(authenticated_account)
					var/transfer_amount = text2num(href_list["funds_amount"])
					transfer_amount = round(transfer_amount, 0.01)
					if(transfer_amount <= 0)
						alert("That is not a valid amount.")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = text2num(href_list["target_acc_number"])
						var/transfer_purpose = href_list["purpose"]
						if(SSeconomy.charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
							to_chat(usr, "\icon[src]<span class='info'>Funds transfer successful.</span>")
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
						else
							to_chat(usr, "\icon[src]<span class='warning'>Funds transfer failed.</span>")

					else
						to_chat(usr, "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>")
			if("view_screen")
				view_screen = text2num(href_list["view_screen"])
			if("change_security_level")
				if(authenticated_account)
					var/new_sec_level = max( min(text2num(href_list["new_security_level"]), 2), 0)
					authenticated_account.security_level = new_sec_level
			if("attempt_auth")

				//scan_user(usr) // ATMs shouldn't be able to scan people for a card - Bedshaped

				if (ticks_left_locked_down) return
				if (!held_card && !href_list["account_num"]) return
				var/tried_account_num = text2num(href_list["account_num"])
				if (!tried_account_num && held_card)
					tried_account_num = held_card.associated_account_number
				var/tried_pin = text2num(href_list["account_pin"])
				var/datum/money_account/potential_account = SSeconomy.get_account(tried_account_num)
				if (!potential_account)
					to_chat(usr, "<span class='warning'>\icon[src] Account number not found.</span>")
					number_incorrect_tries++
					handle_lockdown()
					return
				switch (potential_account.security_level+1) //checks the security level of an account number to see what checks to do
					if (1) // Security level zero
						authenticated_account = SSeconomy.attempt_account_access(tried_account_num, tried_pin, potential_account.security_level)
						// It should be impossible to fail at this point
					if (2) // Security level one
						authenticated_account = SSeconomy.attempt_account_access(text2num(href_list["account_num"]), tried_pin, potential_account.security_level)
					if (3) // Security level two
						if (held_card)
							if (text2num(href_list["account_num"]) != held_card.associated_account_number)
							else authenticated_account = SSeconomy.attempt_account_access(tried_account_num, tried_pin, potential_account.security_level)
						else to_chat(usr, "<span class='warning'>Account card not found.</span>")
				if (!authenticated_account)
					number_incorrect_tries++
					to_chat(usr, "<span class='warning'>\icon[src] Incorrect pin/account combination entered, [(max_pin_attempts+1) - number_incorrect_tries] attempts remaining.</span>")
					handle_lockdown(tried_account_num)
				else
					SSeconomy.bank_log_access(authenticated_account, machine_id)
					number_incorrect_tries = 0
					playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
					ticks_left_timeout = 120
					view_screen = NO_SCREEN
					to_chat(usr, "<span class='notice'> \icon[src] Access granted. Welcome user '[authenticated_account.owner_name].'</span>")
				previous_account_number = tried_account_num

			if("e_withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						//	spawn_money(amount,src.loc)
						spawn_ewallet(amount,src.loc,usr)

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
						to_chat(usr, "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>")
			if("withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						spawn_money(amount,src.loc,usr)

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
						to_chat(usr, "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>")
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
					print(R)

					release_held_id(usr) // printing ends the ATM session similar to real life + prevents spam

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
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
					print(R)

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
				release_held_id(usr) // printing ends the ATM session similar to real life + prevents spam

			if("insert_card")
				if(!held_card)
					//this might happen if the user had the browser window open when somebody emagged it
					if(emagged)
						to_chat(usr, "<span class='warning'>\icon[src] The ATM card reader rejected your ID because this machine has been sabotaged!</span>")
					else
						var/obj/item/I = usr.get_active_hand()
						if (istype(I, /obj/item/card/id))
							usr.drop_from_inventory(I,src)
							held_card = I
				else
					release_held_id(usr)
			if("logout")
				authenticated_account = null
				//usr << browse(null,"window=atm")

	src.attack_hand(usr)

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(!authenticated_account)
		if(human_user.wear_id)
			var/obj/item/card/id/I
			if(istype(human_user.wear_id, /obj/item/card/id) )
				I = human_user.wear_id
			else if(istype(human_user.wear_id, /obj/item/device/pda) )
				var/obj/item/device/pda/P = human_user.wear_id
				I = P.id
			if(I)
				authenticated_account = SSeconomy.attempt_account_access(I.associated_account_number)
				if(authenticated_account)
					to_chat(human_user, "<span class='notice'>\icon[src] Access granted. Welcome user '[authenticated_account.owner_name].'</span>")

					//create a transaction log entry
					var/datum/transaction/T = new()
					T.target_name = authenticated_account.owner_name
					T.purpose = "Remote terminal access"
					T.source_terminal = machine_id
					T.date = worlddate2text()
					T.time = worldtime2text()
					SSeconomy.add_transaction_log(authenticated_account,T)

					view_screen = NO_SCREEN

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
		view_screen = NO_SCREEN
	else playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)


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


/obj/machinery/atm/proc/spawn_ewallet(var/sum, loc, mob/living/carbon/human/human_user as mob)
	var/obj/item/spacecash/ewallet/E = new /obj/item/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name
