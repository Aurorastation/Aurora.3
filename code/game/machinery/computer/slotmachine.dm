#define SPIN_PRICE 5
#define SMALL_PRIZE 400
#define BIG_PRIZE 1000
#define JACKPOT 10000
#define SPIN_TIME 65
#define REEL_DEACTIVATE_DELAY 7
#define SEVEN "<font color='red'>7</font>"

/obj/machinery/computer/slot_machine
	name = "slot machine"
	desc = "A large slot machine with various colourful slots on its face and a lever on its side. It takes various material coins."
	icon = 'icons/obj/machines/slotmachine.dmi'
	icon_state = "slots1"
	density = TRUE
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/circuitboard/slot_machine
	var/emmaged = FALSE
	var/money = 3000 //How much money it has CONSUMED
	var/plays = 0
	var/working = 0
	var/balance = 0 //How much money is in the machine, ready to be CONSUMED.
	var/jackpots = 0
	var/list/coinvalues = list()
	var/list/reels = list(list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0, list("", "", "") = 0)
	var/list/symbols = list(SEVEN = 1, "<font color='orange'>&</font>" = 2, "<font color='yellow'>@</font>" = 2, "<font color='green'>$</font>" = 2, "<font color='blue'>?</font>" = 2, "<font color='grey'>#</font>" = 2, "<font color='white'>!</font>" = 2, "<font color='fuchsia'>%</font>" = 2) //if people are winning too much, multiply every number in this list by 2 and see if they are still winning too much.

	light_color = LIGHT_COLOR_BROWN

/obj/machinery/computer/slot_machine/Initialize()
	. = ..()
	jackpots = rand(1, 4) //false hope
	plays = rand(75, 200)

	toggle_reel_spin(1) //The reels won't spin unless we activate them

	var/list/reel = reels[1]
	for(var/i = 0, i < reel.len, i++) //Populate the reels.
		randomize_reels()

	toggle_reel_spin(0)

	for(var/cointype in typesof(/obj/item/coin))
		var/obj/item/coin/C = cointype
		var/value = get_value(C)
		coinvalues["[cointype]"] = value

/obj/machinery/computer/slot_machine/Destroy()
	if(balance)
		give_coins(balance)
	return ..()

/obj/machinery/computer/slot_machine/process()
	. = ..()
	if(!.)
		return .

	money++

/obj/machinery/computer/slot_machine/update_icon()
	if(stat & NOPOWER)
		icon_state = "slots0"

	else if(stat & BROKEN)
		icon_state = "slotsb"

	else if(working)
		icon_state = "slots2"

	else
		icon_state = "slots1"

/obj/machinery/computer/slot_machine/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/slot_machine/power_change()
	..()
	update_icon()

/obj/machinery/computer/slot_machine/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/coin))
		var/obj/item/coin/C = I
		to_chat(user, "<span class='notice'>You insert a \the [C] into \the [src]'s slot!</span>")
		var/value = get_value(C)
		balance += value
		qdel(C)
	else
		return ..()

/obj/machinery/computer/slot_machine/emag_act()
	if(!emagged)
		emmaged = TRUE
		spark(src, 3)
		playsound(src, /decl/sound_category/spark_sound, 50, 1)
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
		give_coins(balance)
		balance = 0

/obj/machinery/computer/slot_machine/emp_act(severity)
	. = ..()
	if(stat & (NOPOWER|BROKEN))
		return
	var/severity_ascending = 4 - severity
	money = max(rand(money - (200 * severity_ascending), money + (200 * severity_ascending)), 0)
	balance = max(rand(balance - (50 * severity_ascending), balance + (50 * severity_ascending)), 0)
	money -= max(0, give_coins(min(rand(-50, 100 * severity_ascending)), money))
	spin()

/obj/machinery/computer/slot_machine/proc/spin(mob/user)
	if(!can_spin(user))
		return

	var/the_name
	if(user)
		the_name = user.real_name
		visible_message("<span class='notice'>[user] pulls the lever and the slot machine starts spinning!</span>")
	else
		the_name = "Exaybachay"

	balance -= SPIN_PRICE
	money += SPIN_PRICE
	plays += 1
	working = 1

	toggle_reel_spin(1)
	update_icon()
	updateUsrDialog()

	INVOKE_ASYNC(src, .proc/do_reels)

	addtimer(CALLBACK(src, .proc/finish_spin, user, the_name), SPIN_TIME - (REEL_DEACTIVATE_DELAY * reels.len)) //WARNING: no sanity checking for user since it's not needed and would complicate things (machine should still spin even if user is gone), be wary of this if you're changing this code.

/obj/machinery/computer/slot_machine/proc/finish_spin(mob/user, var/the_name)
	toggle_reel_spin(0, REEL_DEACTIVATE_DELAY)
	working = 0
	give_prizes(the_name, user)
	update_icon()
	updateUsrDialog()

/obj/machinery/computer/slot_machine/proc/do_reels()
	while(working)
		randomize_reels()
		updateUsrDialog()
		sleep(2)

/obj/machinery/computer/slot_machine/proc/can_spin(mob/user)
	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>The slot machine has no power!</span>")
	if(stat & BROKEN)
		to_chat(user, "<span class='warning'>The slot machine is broken!</span>")
	if(working)
		to_chat(user, "<span class='warning'>You need to wait until the machine stops spinning before you can play again!</span>")
		return FALSE
	if(balance < SPIN_PRICE)
		to_chat(user, "<span class='warning'>Insufficient money to play!</span>")
		return FALSE
	return TRUE

/obj/machinery/computer/slot_machine/proc/toggle_reel_spin(value, delay = 0) //value is 1 or 0 aka on or off
	for(var/list/reel in reels)
		reels[reel] = value
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
		visible_message("<b>[src]</b> says, 'JACKPOT! You win [money] credits worth of coins!'")
		jackpots += 1
		balance += money - give_coins(JACKPOT)
		money = 0

		for(var/i = 0, i < 5, i++)
			var/cointype = pick(subtypesof(/obj/item/coin))
			var/obj/item/coin/C = new cointype(loc)
			C.forceMove(get_turf(src))

	else if(linelength == 5)
		visible_message("<b>[src]</b> says, 'Big Winner! You win a thousand credits worth of coins!'")
		give_money(BIG_PRIZE)

	else if(linelength == 4)
		visible_message("<b>[src]</b> says, 'Winner! You win four hundred credits worth of coins!'")
		give_money(SMALL_PRIZE)

	else if(linelength == 3)
		to_chat(user, "<span class='notice'>You win three free games!</span>")
		balance += SPIN_PRICE * 4
		money = max(money - SPIN_PRICE * 4, money)

	else
		to_chat(user, "<span class='warning'>No luck!</span>")

/obj/machinery/computer/slot_machine/proc/get_lines()
	var/amountthesame

	for(var/i = 1, i <= 3, i++)
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
	var/surplus = amount_to_give - give_coins(amount_to_give)
	money = max(0, money - amount)
	balance += surplus

/obj/machinery/computer/slot_machine/proc/give_coins(amount)
	var/cointype = emagged ? /obj/item/coin/iron : /obj/item/coin/silver

	if(!(emagged))
		amount = dispense(amount, cointype, null, 0)

	else
		var/mob/living/target = locate() in range(2, src)

		amount = dispense(amount, cointype, target, 1)

	return amount

/obj/machinery/computer/slot_machine/proc/dispense(amount = 0, cointype = /obj/item/coin/silver, mob/living/target, throwit = 0)
	var/value = coinvalues["[cointype]"]
	while(amount >= value)
		var/obj/item/coin/C = new cointype(loc)
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