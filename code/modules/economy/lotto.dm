#define LOTTO_MAXROLL 1000000

/obj/item/spacecash/ewallet/lotto
	name = "lottery card"
	icon_state = "lottocard"
	desc = "A virtual scratch-action charge card which users can use to participate in a lottery. Pays best of 3."
	desc_extended = "This lottery card gives three chances to 'scratch', netting a prize (or no prize) each time. At the end of the scratching session, the best prize of the three scratches is finalized as the reward on the ticket. \
	Prizes do not stack. If you win two 100-credit prizes on a single ticket, for example, you will only get 100 credits, not 200. \
	Once expended, this card can be redeemed at any Idris Self-Serv ATM for the money inside."

	worth = 0

	var/scratches_remaining = 3
	var/next_scratch = 0
	var/best = 0
	var/mult = 10 //Credit value of the lotto ticket
	var/win_state = 0 //How good the win was; determines the color of the scratch display

	//For debugging, or rigging
	var/minimum_roll = 1
	var/maximum_roll = LOTTO_MAXROLL

/obj/item/spacecash/ewallet/lotto/attack_self(mob/user)

	if(scratches_remaining <= 0)
		to_chat(user, SPAN_WARNING("The card flashes: \"No scratches remaining!\""))
		return

	if(next_scratch > world.time)
		to_chat(user, SPAN_WARNING("The card flashes: \"Please wait!\""))
		return

	next_scratch = world.time + 4.5 SECONDS

	to_chat(user, SPAN_NOTICE("You initiate the simulated scratch action process on the [src]..."))
	playsound(src.loc, 'sound/items/drumroll.ogg', 10, 0, -4)
	if(do_after(user, 4 SECONDS))
		var/won = 0
		var/result = rand(minimum_roll, maximum_roll)
		win_state = 0

		switch(result)
			// 78.4700% lose
			if(1 to 784700)
				won = 0
				win_state = 0
				speak("Scratch: 0 credits. Better luck next time!", "buzz")

			// 15.0000% -> 1x
			if(784701 to 934700)
				won = 1 * mult
				win_state = 1
				speak("Scratch: [won] credits. Broke even!", "ping")

			// 5.0000% -> 1.25x
			if(934701 to 984700)
				won = round(1.25 * mult)
				win_state = 1
				speak("Scratch: [won] credits (1.25x). Nice hit!", "ping")

			// 1.2000% -> 2x
			if(984701 to 996700)
				won = 2 * mult
				win_state = 2
				speak("Scratch: [won] credits (2x). Solid!", "ping")

			// 0.2500% -> 5x
			if(996701 to 999200)
				won = 5 * mult
				win_state = 2
				speak("Scratch: [won] credits (5x). Big hit!", "ping")

			// 0.0200% -> 50x
			if(999201 to 999400)
				won = 50 * mult
				win_state = 3
				speak("Scratch: [won] credits (50x). HUGE HIT!", "3ping")

			// 0.0500% -> 100x
			if(999401 to 999900)
				won = 100 * mult
				win_state = 3
				speak("Scratch: [won] credits (100x). MONSTER HIT!", "3ping")

			// 0.0100% -> 1000x JACKPOT
			if(999901 to LOTTO_MAXROLL)
				won = 1000 * mult
				win_state = 4
				speak("Scratch: [won] CREDITS. JACKPOT!", "jackpot")

		scratches_remaining -= 1
		update_icon()

		// Get the best score
		if(won > best)
			best = won

		sleep(1 SECONDS)
		if(scratches_remaining > 0)
			speak("You have: [scratches_remaining] SCRATCHES remaining! Your current top prize is: [best] credits. Scratch again!")
		else
			// Finalize the deal
			worth = best
			speak("You have: [scratches_remaining] SCRATCHES remaining! Your best prize was: [worth] CREDITS. Thanks for playing!")
			sleep(1 SECONDS)
			speak("This card can be redeemed at any participating ATM or purchasing apparatus for [worth] credits.")

		owner_name = user.name

/obj/item/spacecash/ewallet/lotto/proc/speak(var/message = "Hello!", sound = "click")
	for(var/mob/O in hearers(src.loc, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> pings, \"[message]\"</span>",2)
	switch(sound)
		if("jackpot")
			playsound(src.loc, 'sound/arcade/sloto_jackpot.ogg', 30, 0, -4)
		if("buzz")
			playsound(src.loc, 'sound/machines/synth_no.ogg',  10, 0, -4)
		if("3ping")
			playsound(src.loc, 'sound/machines/pingx3.ogg', 20, 0, -4)
		if("ping")
			playsound(src.loc, 'sound/machines/ping.ogg', 20, 0, -4)
		if("click")
			playsound(src.loc, 'sound/machines/pda_click.ogg', 10, 0, -4)

/obj/item/spacecash/ewallet/lotto/update_icon()
	..()
	var/image/lotto_overlay = null
	var/image/emissive_overlay = null

	if(isnum(scratches_remaining) && scratches_remaining >= 0 && scratches_remaining <= 3)
		lotto_overlay = image(icon, "scratch_[scratches_remaining]")
		emissive_overlay = emissive_appearance(lotto_overlay)

		switch(win_state)
			if(1)
				lotto_overlay.color = COLOR_CIVIE_GREEN
			if(2)
				lotto_overlay.color = COLOR_SKY_BLUE
			if(3)
				lotto_overlay.color = COLOR_VIOLET
			if(4)
				lotto_overlay.color = COLOR_AMBER
			else
				lotto_overlay.color = COLOR_GRAY

		AddOverlays(lotto_overlay)
		AddOverlays(emissive_overlay)

#undef LOTTO_MAXROLL
