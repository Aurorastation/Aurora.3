/obj/machinery/computer/coin_machine
	name = "coin machine"
	desc = "An easy way to convert coins into and from cash."
	icon = 'icons/obj/machines/slotmachine.dmi'
	icon_state = "coin_machine1"
	density = TRUE
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/weapon/circuitboard/coin_machine
	var/money = 1000
	light_color = LIGHT_COLOR_YELLOW
	var/credit_count = 0
	var/death_dispense = 0

/obj/machinery/computer/coin_machine/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/coin_machine/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/weapon/spacecash/bundle))
		var/obj/item/weapon/spacecash/bundle/inserted_credits = I
		if(emagged && prob(25))
			visible_message("<span class='game say'><span class='name'>\The [src]</span> pings, \"We can put those credits in a Money Market Mutual Fund, then we'll reinvest the earnings into foreign currency accounts with compounding interest aaand it's gone.\"</span>")
		else
			credit_count += inserted_credits.worth
			visible_message("<span class='game say'><span class='name'>\The [src]</span> pings, \"Credits successfully inserted!\"</span>")
		qdel(inserted_credits)
		updateUsrDialog()
	else
		return ..()

/obj/machinery/computer/coin_machine/emag_act(var/charges, var/mob/user)
	if(!emagged)
		emagged = 1
		spark(src, 3)
		playsound(src, "sparks", 50, 1)
		updateUsrDialog()
		return 1

/obj/machinery/computer/coin_machine/emp_act(severity)
	. = ..()
	if(stat & (NOPOWER|BROKEN))
		return
	emag_act()

/obj/machinery/computer/coin_machine/power_change()
	..()
	update_icon()
	updateUsrDialog()

/obj/machinery/computer/coin_machine/machinery_process()

	if (inoperable()) return

	if(death_dispense && credit_count)
		var/mob/living/target = locate() in view(7,src)
		if(target)
			var/obj/item/weapon/spacecash/bundle/coins_only/vend = new(get_turf(src))
			vend.worth = min(50,credit_count)
			credit_count -= vend.worth
			vend.update_icon()

			var/list/rude_responses = list(
				"Take this, you filthy whore!",
				"Dance for me, bitch!",
				"Eat silver, motherfucker!"
			)

			if(prob(10))
				visible_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[pick(rude_responses)]\"</span>")
			vend.throw_at(target, 16, 3, src)
			visible_message("<span class='warning'>\The [src] launches \the [vend] at [target]!</span>")
			updateUsrDialog()

/obj/machinery/computer/coin_machine/ui_interact(mob/living/user)
	. = ..()

	var/company_machine_name = "Space [emagged ? "Sluts" : "Slots"] Co."

	var/dat = "<center><h1>[company_machine_name] Coin Machine</h1></center>\
	<center><b>Select Dispense Type</b></center>\
	<center><A href='?src=\ref[src];dispense_type=1'>Dispense Coins!</A></center>\
	<center><A href='?src=\ref[src];dispense_type=2'>Dispense Credits!</A></center>\
	<center><A href='?src=\ref[src];dispense_type=3'>Dispense Card!</A></center>"

	if(emagged)
		dat += "<center><A href='?src=\ref[src];dispense_type=666'>DISPENSE DEATH!</A></center>"

	dat += "<center><b>Credits Remaining:</b>[credit_count]</center>"

	var/datum/browser/popup = new(user, "coin_machine", "Coin Machine")
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/computer/coin_machine/Topic(href, href_list)
	. = ..() //Sanity checks.
	if(.)
		return .

	var/company_machine_name = "Space [emagged ? "Sluts" : "Slots"] Co."
	var/dispense = text2num(href_list["dispense_type"])
	if(dispense)
		if(!credit_count)
			visible_message("<span class='game say'><span class='name'>\The [src]</span> errors, \"There are no credits to convert for the machine! Please insert additional credits!\"</span>")
		else
			switch(dispense)
				if(1)
					var/obj/item/weapon/spacecash/bundle/coins_only/vend = new(get_turf(src))
					vend.worth = credit_count
					credit_count = 0
					vend.update_icon()
					visible_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"Coins successfully vended. Thank you for choosing [company_machine_name]!\"</span>")
				if(2)
					var/obj/item/weapon/spacecash/bundle/vend = new(get_turf(src))
					vend.worth = credit_count
					credit_count = 0
					vend.update_icon()
					visible_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"Cash successfully vended. Thank you for choosing [company_machine_name]!\"</span>")
				if(3)
					var/obj/item/weapon/spacecash/ewallet/vend = new(get_turf(src))
					vend.worth = credit_count
					credit_count = 0
					vend.owner_name = company_machine_name
					vend.update_icon()
					visible_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"Ewallet sucessfully vended. Thank you for choosing [company_machine_name]!\"</span>")
				if(666)
					if(!death_dispense)
						visible_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"Dispensing Death...\"</span>")
						death_dispense = 1
			updateUsrDialog()