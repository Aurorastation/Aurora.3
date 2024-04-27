#define SPIN_PRICE 5
#define SMALL_PRIZE 400
#define BIG_PRIZE 1000
#define JACKPOT 10000
#define SPIN_TIME 65 //As always, deciseconds.
#define REEL_DEACTIVATE_DELAY 7
#define SEVEN "<font color='red'>7</font>"
#define CREDITCHIP 1
#define COIN 2

/obj/machinery/computer/slot_machine
	name = "slot machine"
	desc = "Gambling for the antisocial."
	icon = 'icons/obj/machinery/slotmachine.dmi'
	icon_state = "slots"
	density = TRUE
	clicksound = null
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/circuitboard/slot_machine
	var/emmaged = FALSE
	light_color = LIGHT_COLOR_BROWN
	var/money = 3000 //How much money it has CONSUMED
	var/plays = 0
	var/working = FALSE
	var/balance = 0 //How much money is in the machine, ready to be CONSUMED.
	var/jackpots = 0
	var/paymode = CREDITCHIP //toggles between CREDITCHIP/COIN, defined above
	var/cointype = /obj/item/coin/iron //default cointype
	var/list/coinvalues = list()
	var/list/reels = list(list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0)
	var/list/symbols = list(SEVEN = 1, "<font color='orange'>&</font>" = 2, "<font color='yellow'>@</font>" = 2, "<font color='green'>$</font>" = 2, "<font color='blue'>?</font>" = 2, "<font color='grey'>#</font>" = 2, "<font color='white'>!</font>" = 2, "<font color='fuchsia'>%</font>" = 2) //if people are winning too much, multiply every number in this list by 2 and see if they are still winning too much.


/obj/machinery/computer/slot_machine/Initialize()
	. = ..()
	jackpots = rand(1, 4) //false hope
	plays = rand(75, 200)
	money = round(rand(2500, 3500), 5)

	toggle_reel_spin(TRUE) //The reels won't spin unless we activate them

	var/list/reel = reels[1]
	for(var/i in 1 to reel.len) //Populate the reels.
		randomize_reels()

	toggle_reel_spin(FALSE)

	for(cointype in typesof(/obj/item/coin))
		coinvalues["[cointype]"] = get_value(cointype)

/obj/machinery/computer/slot_machine/Destroy()
	return ..()

/obj/machinery/computer/slot_machine/process(delta_time)
	. = ..() //Sanity checks.
	if(!.)
		return .

	money += round(delta_time / 2) //SPESSH MAJICKS

/obj/machinery/computer/slot_machine/update_icon()
	if(working)
		icon_screen = "slots_screen_working"
	else
		icon_screen = "slots_screen"
	. = ..()

/obj/machinery/computer/slot_machine/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/slot_machine/power_change()
	..()
	update_icon()

/obj/machinery/computer/slot_machine/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/coin))
		var/obj/item/coin/C = attacking_item
		if(paymode == COIN)
			if(prob(2))
				if(!user.drop_from_inventory(C, user.loc))
					return TRUE
				C.throw_at(user, 3, 10)
				if(prob(10))
					balance = max(balance - SPIN_PRICE, 0)
				to_chat(user, SPAN_WARNING("[src] spits your coin back out!"))
			else
				to_chat(user, SPAN_NOTICE("You insert [C] into [src]'s slot!"))
				playsound(loc, 'sound/arcade/sloto_token.ogg', 10, 1, extrarange = -3, falloff_distance = 10, required_asfx_toggles = ASFX_ARCADE)
				balance += get_value(C)
				updateUsrDialog()
				qdel(C)
		else
			to_chat(user, SPAN_WARNING("This machine is only accepting credit chips!"))
		return TRUE
	else if(istype(attacking_item, /obj/item/spacecash))
		if(paymode == CREDITCHIP)
			var/obj/item/spacecash/H = attacking_item
			to_chat(user, SPAN_NOTICE("You insert [H.worth] credits into [src]'s slot!"))
			playsound(loc, 'sound/arcade/sloto_token.ogg', 10, 1, extrarange = -3, falloff_distance = 10, required_asfx_toggles = ASFX_ARCADE)
			balance += H.worth
			updateUsrDialog()
			qdel(H)
		else
			to_chat(user, SPAN_WARNING("This machine is only accepting coins!"))
		return TRUE
	else if(attacking_item.ismultitool())
		if(balance > 0)
			visible_message("<b>[src]</b> says, 'ERROR! Please empty the machine balance before altering paymode'") //Prevents converting coins into credits and vice versa
		else
			if(paymode == CREDITCHIP)
				paymode = COIN
				visible_message("<b>[src]</b> says, 'This machine now works with COINS!'")
			else
				paymode = CREDITCHIP
				visible_message("<b>[src]</b> says, 'This machine now works with CREDITCHIPS!'")
		return TRUE
	else
		return ..()

/obj/machinery/computer/slot_machine/emag_act()
	if(!emagged)
		emmaged = TRUE
		spark(src, 3)
		playsound(src, /singleton/sound_category/spark_sound, 50, 1)
		return TRUE

/obj/machinery/computer/slot_machine/ui_interact(mob/living/user)
	. = ..()
	var/reeltext = {"<center><font face=\"courier new\">
	/*****^*****^*****^*****^*****\\<BR>
	| \[[reels[1][1]]\] | \[[reels[2][1]]\] | \[[reels[3][1]]\] | \[[reels[4][1]]\] | \[[reels[5][1]]\] |<BR>
	| \[[reels[1][2]]\] | \[[reels[2][2]]\] | \[[reels[3][2]]\] | \[[reels[4][2]]\] | \[[reels[5][2]]\] |<BR>
	| \[[reels[1][3]]\] | \[[reels[2][3]]\] | \[[reels[3][3]]\] | \[[reels[4][3]]\] | \[[reels[5][3]]\] |<BR>
	\\*****v*****v*****v*****v*****/<BR>
	</center></font>"}

	var/dat
	if(working)
		dat = reeltext

	else
		dat = {"Five credits to play!<BR>
		<B>Prize Money Available:</B> [money] (jackpot payout is ALWAYS 100%!)<BR>
		<B>Credit Remaining:</B> [balance]<BR>
		[plays] players have tried their luck today, and [jackpots] have won a jackpot!<BR>
		<HR><BR>
		<A href='?src=\ref[src];spin=1'>Play!</A><BR>
		<BR>
		[reeltext]
		<BR>
		<font size='1'><A href='?src=\ref[src];refund=1'>Refund balance</font></A><BR>"}

	var/datum/browser/popup = new(user, "slotmachine", "Slot Machine")
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/computer/slot_machine/Topic(href, href_list)
	. = ..() //Sanity checks.
	if(.)
		return .

	if(href_list["spin"])
		spin(usr)

	else if(href_list["refund"])
		playsound(src, /singleton/sound_category/button_sound, clickvol)
		if(balance > 0)
			give_payout(balance, usr)
			balance = 0
			updateUsrDialog()

/obj/machinery/computer/slot_machine/emp_act(severity)
	. = ..()

	if(stat & (NOPOWER|BROKEN))
		return

	if(prob(15 * severity))
		return

	if(prob(1)) // :^)
		emagged = TRUE

	var/severity_ascending = 4 - severity
	money = max(rand(money - (200 * severity_ascending), money + (200 * severity_ascending)), 0)
	balance = max(rand(balance - (50 * severity_ascending), balance + (50 * severity_ascending)), 0)
	money -= max(0, give_payout(min(rand(-50, 100 * severity_ascending)), money)) //This starts at -50 because it shouldn't always dispense coins yo
	spin()

/obj/machinery/computer/slot_machine/proc/spin(mob/user)
	if(!can_spin(user))
		return

	var/the_name
	if(user)
		the_name = user.real_name
		visible_message(SPAN_NOTICE("[user] pulls the lever and the slot machine starts spinning!"))
		playsound(loc, 'sound/arcade/sloto_lever.ogg', 10, 0, extrarange = -3, falloff_distance = 10, required_asfx_toggles = ASFX_ARCADE)
		flick("slots_pull", src)
	else
		the_name = "Exaybachay"

	balance -= SPIN_PRICE
	money += SPIN_PRICE
	plays += 1
	working = TRUE

	toggle_reel_spin(TRUE)
	update_icon()
	updateUsrDialog()

	INVOKE_ASYNC(src, PROC_REF(do_spin))

	addtimer(CALLBACK(src, PROC_REF(finish_spinning), user, the_name), SPIN_TIME - (REEL_DEACTIVATE_DELAY * reels.len)) //WARNING: no sanity checking for user since it's not needed and would complicate things (machine should still spin even if user is gone), be wary of this if you're changing this code.

/obj/machinery/computer/slot_machine/proc/do_spin(mob/user, the_name)
	while(working)
		randomize_reels()
		updateUsrDialog()
		sleep(2)

/obj/machinery/computer/slot_machine/proc/finish_spinning(mob/user, the_name)
	toggle_reel_spin(0, REEL_DEACTIVATE_DELAY)
	working = FALSE
	give_prizes(the_name, user)
	update_icon()
	updateUsrDialog()

/obj/machinery/computer/slot_machine/proc/can_spin(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("The slot machine has no power!"))
		return FALSE
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("The slot machine is broken!"))
		return FALSE
	if(working)
		to_chat(user, SPAN_WARNING("You need to wait until the machine stops spinning before you can play again!"))
		return FALSE
	if(balance < SPIN_PRICE)
		to_chat(user, SPAN_WARNING("Insufficient money to play!"))
		return FALSE
	return TRUE

/obj/machinery/computer/slot_machine/proc/toggle_reel_spin(value) //value is 1 or 0 aka on or off
	for(var/list/reel in reels)
		reels[reel] = value

/obj/machinery/computer/slot_machine/proc/toggle_reel_spin_delay(value, delay = 0) //value is 1 or 0 aka on or off
	toggle_reel_spin(value)

	if(delay)
		sleep(delay)

/obj/machinery/computer/slot_machine/proc/randomize_reels()
	for(var/reel in reels)
		if(reels[reel])
			reel[3] = reel[2]
			reel[2] = reel[1]
			reel[1] = pick(symbols)

/obj/machinery/computer/slot_machine/proc/give_prizes(usrname, mob/user)
	var/linelength = get_lines()

	if(reels[1][2] + reels[2][2] + reels[3][2] + reels[4][2] + reels[5][2] == "[SEVEN][SEVEN][SEVEN][SEVEN][SEVEN]")
		visible_message("<b>[src]</b> says, 'JACKPOT! You win [money] credits!'")
		GLOB.global_announcer.autosay("Congratulations to [user ? user.real_name : usrname] for winning the jackpot at the slot machine in [get_area(src)]!", "Automated Announcement System")
		playsound(loc, 'sound/arcade/sloto_jackpot.ogg', 20, 1, required_asfx_toggles = ASFX_ARCADE) // ham it up
		jackpots += 1
		balance += money - give_payout(JACKPOT)
		money = 0
		if(paymode == CREDITCHIP)
			spawn_money(JACKPOT, get_turf(user), user)
		else
			for(var/i in 1 to 5)
				cointype = pick(subtypesof(/obj/item/coin))
				var/obj/item/coin/C = new cointype(loc)
				C.forceMove(get_turf(src))

	else if(linelength == 5)
		visible_message("<b>[src]</b> says, 'Big Winner! You win a thousand credits!'")
		playsound(loc, 'sound/arcade/sloto_jackpot.ogg', 10, 1, required_asfx_toggles = ASFX_ARCADE)
		give_money(BIG_PRIZE)

	else if(linelength == 4)
		visible_message("<b>[src]</b> says, 'Winner! You win four hundred credits!'")
		playsound(loc, 'sound/arcade/sloto_jackpot.ogg', 10, 1, required_asfx_toggles = ASFX_ARCADE)
		give_money(SMALL_PRIZE)

	else if(linelength == 3)
		to_chat(user, SPAN_NOTICE("You win three free games!"))
		playsound(loc, 'sound/arcade/sloto_token.ogg', 10, 1, required_asfx_toggles = ASFX_ARCADE)
		balance += SPIN_PRICE * 4
		money = max(money - SPIN_PRICE * 4, money)

	updateUsrDialog()

/obj/machinery/computer/slot_machine/proc/get_lines()
	var/amountthesame

	for(var/i in 1 to 3)
		var/inputtext = reels[1][i] + reels[2][i] + reels[3][i] + reels[4][i] + reels[5][i]
		for(var/symbol in symbols)
			var/j = 3 //The lowest value we have to check for.
			var/symboltext = symbol + symbol + symbol
			while(j <= 5)
				if(findtext(inputtext, symboltext))
					amountthesame = max(j, amountthesame)
				j++
				symboltext += symbol

			if(amountthesame)
				break

	return amountthesame

/obj/machinery/computer/slot_machine/proc/give_money(amount)
	var/amount_to_give = money >= amount ? amount : money
	var/surplus = amount_to_give - give_payout(amount_to_give)
	money = max(0, money - amount)
	balance += surplus

/obj/machinery/computer/slot_machine/proc/give_payout(amount, usr)
	if(paymode == CREDITCHIP)
		cointype = /obj/item/spacecash
	else
		cointype = emagged ? /obj/item/coin/iron : /obj/item/coin/silver

	if(!(emagged))
		amount = dispense(amount, cointype, usr, 0)

	else
		var/mob/living/target = locate() in range(2, src)

		amount = dispense(amount, cointype, target, 1)

	return amount

/obj/machinery/computer/slot_machine/proc/dispense(amount = 0, cointype = /obj/item/coin/silver, mob/living/target, throwit = 0)
	if(paymode == CREDITCHIP)
		spawn_money(amount, src.loc, target)
		if(throwit && target)
			for(var/obj/item/spacecash/S in loc)
				S.throw_at(target, 3, 10)
	else
		var/value = coinvalues["[cointype]"]
		if(value <= 0)
			CRASH("Coin value of zero, refusing to payout in dispenser")
		while(amount >= value)
			var/obj/item/coin/C = new cointype(loc) //DOUBLE THE PAIN
			amount -= value
			if(throwit && target)
				C.throw_at(target, 3, 10)

	return amount

#undef SEVEN
#undef SPIN_TIME
#undef JACKPOT
#undef BIG_PRIZE
#undef SMALL_PRIZE
#undef SPIN_PRICE
#undef CREDITCHIP
#undef COIN
