/////////////////////////////////////////
// SLEEPER CONSOLE
/////////////////////////////////////////

/obj/machinery/sleep_console
	name = "Sleeper Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeperconsole"
	var/obj/machinery/sleeper/connected = null
	anchored = 1 //About time someone fixed this.
	density = 0
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"

	use_power = 1
	idle_power_usage = 40
	interact_offline = 1

	var/ui_data = list()		// NanoUI Dataset (for live debugging)
	var/printjob_queued = 0		// printer status

/obj/machinery/sleep_console/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/sleep_console/New()
	..()
	spawn( 5 )
		if(orient == "RIGHT")
			icon_state = "sleeperconsole-r"
			src.connected = locate(/obj/machinery/sleeper, get_step(src, EAST))
		else
			src.connected = locate(/obj/machinery/sleeper, get_step(src, WEST))

		return
	return

/obj/machinery/sleep_console/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/sleep_console/attack_hand(mob/user as mob)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return

	// Handle NanoUI
	ui_interact(user)
	return

// Interaction with NanoUI
/obj/machinery/sleep_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// Generate dataset
	ui_data = generate_ui_data()

	// Update UI with data / create new UI
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, ui_data, force_open)
	if (!ui)
		// UI does not exist, yet. Create new one
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper Console", 455,675)
		ui.set_initial_data(ui_data)
		ui.open()

	// Update window every master controller tick
	ui.set_auto_update(1)
	return

// Generate dataset
/obj/machinery/sleep_console/proc/generate_ui_data()
	var/data = list()

	if (!src.connected || (connected.stat & (NOPOWER|BROKEN)))
		// Unit inoperable
		data["inop"] = 1
	else
		var/mob/living/occupant = src.connected.occupant

		// Add occupant data
		if (occupant)
			data["occupant"] = list()

			// General status
			data["occupant"]["stat"] = list()
			data["occupant"]["stat"]["value"] = occupant.stat
			switch (occupant.stat)
				if(DEAD)
					data["occupant"]["stat"]["string"] = "Dead"
				if(UNCONSCIOUS)
					data["occupant"]["stat"]["string"] = "Unconscious"
				if(CONSCIOUS)
					data["occupant"]["stat"]["string"] = "Conscious"
				else
					data["occupant"]["stat"]["string"] = "Unknown"

			// Health information
			data["occupant"]["health"] = list()
			// Carbon mobs: pulse
			if (iscarbon(occupant))
				var/mob/living/carbon/occupant_c = occupant
				data["occupant"]["health"]["pulse"] = list()
				data["occupant"]["health"]["pulse"]["value"] = occupant_c.get_pulse(GETPULSE_TOOL)
				switch(occupant_c.pulse)
					if(PULSE_NONE)
						data["occupant"]["health"]["pulse"]["state"] = "NONE"
					if(PULSE_THREADY)
						data["occupant"]["health"]["pulse"]["state"] = "THREADY"
					else
						data["occupant"]["health"]["pulse"]["state"] = "OK"
			// Damage
			data["occupant"]["health"]["combined"] = occupant.health
			data["occupant"]["health"]["brute"] = occupant.getBruteLoss()
			data["occupant"]["health"]["oxy"] = occupant.getOxyLoss()
			data["occupant"]["health"]["toxin"] = occupant.getToxLoss()
			data["occupant"]["health"]["burn"] = occupant.getFireLoss()

			// Reagents in occupant
			data["occupant"]["reagents"] = list()
			for (var/chemical in src.connected.available_chemicals)
				var/chems[0]
				chems["amount"] = occupant.reagents.get_reagent_amount(chemical)
				chems["name"] = src.connected.available_chemicals[chemical]
				chems["id"] = chemical
				data["occupant"]["reagents"] += list(chems)

		// Dispensable chemicals
		data["dispenser"] = list()
		data["dispenser"]["amounts"] = src.connected.amounts
		data["dispenser"]["chemicals"] = list()
		for (var/chemical in src.connected.available_chemicals)
			data["dispenser"]["chemicals"][chemical] = src.connected.available_chemicals[chemical]

		// Dialysis beaker data
		if (src.connected.beaker)
			data["beaker"] = list()
			data["beaker"]["max_volume"] = src.connected.beaker.reagents.maximum_volume
			data["beaker"]["reagents_volume"] = src.connected.beaker.reagents.total_volume
			data["beaker"]["free_volume"] = src.connected.beaker.reagents.maximum_volume - src.connected.beaker.reagents.total_volume
			data["beaker"]["dialysis"] = src.connected.filtering

	return data

/obj/machinery/sleep_console/Topic(href, href_list)
	if(..())
		return

	if (!(src.connected))
		return

	if (usr == src.connected.occupant)
		usr << "<span class='warning'>You can't reach the controls from the inside.</span>"
		return

	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.set_machine(src)
		src.add_fingerprint(usr)

		// Inject reagent
		if (href_list["chemical"])
			if (src.connected && src.connected.occupant && src.connected.occupant.stat != DEAD)
				// Prevent href shenanigans
				if (href_list["chemical"] in src.connected.available_chemicals)
					src.connected.inject_chemical(usr,href_list["chemical"],text2num(href_list["amount"]))

		// Eject dialysis beaker
		if (href_list["removebeaker"])
			src.connected.remove_beaker()

		// Toggle filtering on/off
		if (href_list["togglefilter"])
			src.connected.toggle_filter()

		// Eject occupant
		if (href_list["ejectify"])
			src.connected.eject()

		// Sensor printout
		if (href_list["print"])
			// Limit rate
			if (!printjob_queued)
				printjob_queued = 1
				var/printer_data = generate_ui_data()
				sleep(50)
				var/obj/item/weapon/paper/printout = new /obj/item/weapon/paper(src.loc)
				printout.name = "Sleeper Scanner Printout"
				printout.desc = "This is a printout from one of the sleeper consoles."
				printout.info = "<pre><tt>"
				printout.info +="---------------------------------------\n"
				printout.info +="-  SLEEPER SCANNER REPORT    NT#1290a -\n"
				printout.info +="---------------------------------------\n"
				printout.info +="\n"
				printout.info +=text("M. ACTIVITY  :  []\n", printer_data["occupant"]["stat"]["string"])
				printout.info +=text("HEALTH RATING:  []%\n",printer_data["occupant"]["health"]["combined"])
				printout.info +=text("         BRT :  []%\n",printer_data["occupant"]["health"]["brute"])
				printout.info +=text("         OXY :  []%\n",printer_data["occupant"]["health"]["oxy"])
				printout.info +=text("         TOX :  []%\n",printer_data["occupant"]["health"]["toxin"])
				printout.info +=text("         BRN :  []%\n",printer_data["occupant"]["health"]["burn"])
				printout.info +="\n"
				/*printout.info +=text("PARALYSIS REP:  []%\n",printer_data["occupant"]["health"]["paralysis"]["amount"])
				printout.info +=text("         REM :  []s\n",printer_data["occupant"]["health"]["paralysis"]["countdown"])
				printout.info +="\n"*/
				if (printer_data["occupant"]["health"]["pulse"])
					printout.info += text("PULSE        :  [] bpm ([])\n",printer_data["occupant"]["health"]["pulse"]["value"],printer_data["occupant"]["health"]["pulse"]["state"])
				printout.info += "REAGENTS     :  \n"
				for (var/chem in printer_data["occupant"]["reagents"])
					printout.info += text("     [][]\t []U\n",chem["name"],(length(chem["name"]) > 9) ? "" : "\t", chem["amount"])
				printout.info +="\n\n------------- tear here ---------------</tt></pre>"
				// Ready for next printjob
				printjob_queued = 0
	return









/////////////////////////////////////////
// THE SLEEPER ITSELF
/////////////////////////////////////////

/obj/machinery/sleeper
	name = "Sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = 1
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"
	var/mob/living/carbon/human/occupant = null
	var/available_chemicals = list("inaprovaline" = "Inaprovaline", "stoxin" = "Soporific", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin")
	var/amounts = list(5, 10)
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = 0
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.

	New()
		..()
		beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
		spawn( 5 )
			if(orient == "RIGHT")
				icon_state = "sleeper_0-r"
			return
		return

	process()
		if (stat & (NOPOWER|BROKEN))
			return

		if(filtering > 0)
			if(beaker)
				if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
					var/pumped = 0
					for(var/datum/reagent/x in src.occupant.reagents.reagent_list)
						src.occupant.reagents.trans_to_obj(beaker, 3)
						pumped++
					if (ishuman(src.occupant))
						src.occupant.vessel.trans_to_obj(beaker, pumped + 1)
		src.updateUsrDialog()
		return


	blob_act()
		if(prob(75))
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				A.blob_act()
			qdel(src)
		return

	attackby(var/obj/item/weapon/G as obj, var/mob/user as mob)
		if(istype(G, /obj/item/weapon/reagent_containers/glass))
			if(!beaker)
				beaker = G
				user.drop_item()
				G.loc = src
				user.visible_message("[user] adds \a [G] to \the [src]!", "You add \a [G] to \the [src]!")
				src.updateUsrDialog()
				return
			else
				user << "\red The sleeper has a beaker already."
				return

		else if(istype(G, /obj/item/weapon/grab))
			if(!ismob(G:affecting))
				return

			if(src.occupant)
				user << "\blue <B>The sleeper is already occupied!</B>"
				return

			for(var/mob/living/carbon/slime/M in range(1,G:affecting))
				if(M.Victim == G:affecting)
					usr << "[G:affecting.name] will not fit into the sleeper because they have a slime latched onto their head."
					return


			visible_message("[user] starts putting [G:affecting:name] into the sleeper.", 3)

			if (do_mob(user, G:affecting, 30, needhand = 0))
				var/bucklestatus = G:affecting.bucklecheck(user)
				if (!bucklestatus)//incase the patient got buckled during the delay
					return
				if (bucklestatus == 2)
					var/obj/structure/LB = G:affecting.buckled
					LB.user_unbuckle_mob(user)

				if(src.occupant)
					user << "\blue <B>The sleeper is already occupied!</B>"
					return
				if(!G || !G:affecting) return
				var/mob/M = G:affecting
				if(M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src
				M.loc = src
				update_use_power(2)
				src.occupant = M
				src.icon_state = "sleeper_1"
				if(orient == "RIGHT")
					icon_state = "sleeper_1-r"

				src.add_fingerprint(user)
				qdel(G)
			return
		return

	MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
		if(!istype(user))
			return
		if(!check_occupant_allowed(O))
			return

		if(src.occupant)
			user << "\blue <B>The sleeper is already occupied!</B>"
			return

		for(var/mob/living/carbon/slime/M in range(1,O))
			if(M.Victim == O)
				usr << "[O.name] will not fit into the sleeper because they have a slime latched onto their head."
				return
		var/mob/living/L = O
		var/bucklestatus = L.bucklecheck(user)

		if (!bucklestatus)//We must make sure the person is unbuckled before they go in
			return


		if(L == user)
			visible_message("[user] starts climbing into the sleeper.", 3)
		else
			visible_message("[user] starts putting [L.name] into the sleeper.", 3)

		if (do_mob(user, L, 30, needhand = 0))
			if (bucklestatus == 2)
				var/obj/structure/LB = L.buckled
				LB.user_unbuckle_mob(user)
			if(src.occupant)
				user << "\blue <B>The sleeper is already occupied!</B>"
				return
			if(!L) return

			if(L.client)
				L.client.perspective = EYE_PERSPECTIVE
				L.client.eye = src
			L.loc = src
			src.occupant = L
			src.icon_state = (orient == "RIGHT") ? "sleeper_1-r" : "sleeper_1"
			L << "\blue <b>You feel cool air surround you. You go numb as your senses turn inward.</b>"
			src.add_fingerprint(user)
			if(user.pulling == L)
				user.pulling = null


	proc/check_occupant_allowed(mob/M)
		var/correct_type = 0
		for(var/type in allow_occupant_types)
			if(istype(M, type))
				correct_type = 1
				break

		if(!correct_type) return 0

		for(var/type in disallow_occupant_types)
			if(istype(M, type))
				return 0

		return 1

	ex_act(severity)
		if(filtering)
			toggle_filter()
		switch(severity)
			if(1.0)
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				qdel(src)
				return
			if(2.0)
				if(prob(50))
					for(var/atom/movable/A as mob|obj in src)
						A.loc = src.loc
						ex_act(severity)
					qdel(src)
					return
			if(3.0)
				if(prob(25))
					for(var/atom/movable/A as mob|obj in src)
						A.loc = src.loc
						ex_act(severity)
					qdel(src)
					return
		return
	emp_act(severity)
		if(filtering)
			toggle_filter()
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		if(occupant)
			go_out()
		..(severity)

	alter_health(mob/living/M as mob)
		if (M.health > 0)
			if (M.getOxyLoss() >= 10)
				var/amount = max(0.15, 1)
				M.adjustOxyLoss(-amount)
			else
				M.adjustOxyLoss(-12)
			M.updatehealth()
		M.AdjustParalysis(-4)
		M.AdjustWeakened(-4)
		M.AdjustStunned(-4)
		M.Paralyse(1)
		M.Weaken(1)
		M.Stun(1)
		if (M:reagents.get_reagent_amount("inaprovaline") < 5)
			M:reagents.add_reagent("inaprovaline", 5)
		return
	proc/toggle_filter()
		if(!src.occupant)
			filtering = 0
			return
		if(filtering)
			filtering = 0
		else
			filtering = 1

	proc/go_out()
		if(filtering)
			toggle_filter()
		if(!src.occupant)
			return
		for(var/obj/O in src) //once again, why wasn't this here?
			if (O != beaker)
				O.loc = src.loc
		if(src.occupant.client)
			src.occupant.client.eye = src.occupant.client.mob
			src.occupant.client.perspective = MOB_PERSPECTIVE
		src.occupant.loc = src.loc
		src.occupant = null
		update_use_power(1)
		if(orient == "RIGHT")
			icon_state = "sleeper_0-r"
		return


	proc/inject_chemical(mob/living/user as mob, chemical, amount)
		if (stat & (BROKEN|NOPOWER))
			return

		if(src.occupant && src.occupant.reagents)
			if(src.occupant.reagents.get_reagent_amount(chemical) + amount <= 20)
				use_power(amount * CHEM_SYNTH_ENERGY)
				src.occupant.reagents.add_reagent(chemical, amount)
				user << "Occupant now has [src.occupant.reagents.get_reagent_amount(chemical)] units of [available_chemicals[chemical]] in their bloodstream."
				return
		user << "There's no occupant in the sleeper or the subject has too many chemicals!"
		return


	proc/check(mob/living/user as mob)
		if(src.occupant)
			user << text("\blue <B>Occupant ([]) Statistics:</B>", src.occupant)
			var/t1
			switch(src.occupant.stat)
				if(0.0)
					t1 = "Conscious"
				if(1.0)
					t1 = "Unconscious"
				if(2.0)
					t1 = "*dead*"
				else
			user << text("[]\t Health %: [] ([])", (src.occupant.health > 50 ? "\blue " : "\red "), src.occupant.health, t1)
			user << text("[]\t -Core Temperature: []&deg;C ([]&deg;F)</FONT><BR>", (src.occupant.bodytemperature > 50 ? "<font color='blue'>" : "<font color='red'>"), src.occupant.bodytemperature-T0C, src.occupant.bodytemperature*1.8-459.67)
			user << text("[]\t -Brute Damage %: []", (src.occupant.getBruteLoss() < 60 ? "\blue " : "\red "), src.occupant.getBruteLoss())
			user << text("[]\t -Respiratory Damage %: []", (src.occupant.getOxyLoss() < 60 ? "\blue " : "\red "), src.occupant.getOxyLoss())
			user << text("[]\t -Toxin Content %: []", (src.occupant.getToxLoss() < 60 ? "\blue " : "\red "), src.occupant.getToxLoss())
			user << text("[]\t -Burn Severity %: []", (src.occupant.getFireLoss() < 60 ? "\blue " : "\red "), src.occupant.getFireLoss())
			user << "\blue Expected time till occupant can safely awake: (note: If health is below 20% these times are inaccurate)"
			user << text("\blue \t [] second\s (if around 1 or 2 the sleeper is keeping them asleep.)", src.occupant.paralysis / 5)
			if(src.beaker)
				user << text("\blue \t Dialysis Output Beaker has [] of free space remaining.", src.beaker.reagents.maximum_volume - src.beaker.reagents.total_volume)
			else
				user << "\blue No Dialysis Output Beaker loaded."
		else
			user << "\blue There is no one inside!"
		return


	verb/eject()
		set name = "Eject Sleeper"
		set category = "Object"
		set src in oview(1)
		if(usr.stat != 0)
			return
		if(orient == "RIGHT")
			icon_state = "sleeper_0-r"
		src.icon_state = "sleeper_0"
		src.go_out()
		add_fingerprint(usr)
		return

	verb/remove_beaker()
		set name = "Remove Beaker"
		set category = "Object"
		set src in oview(1)
		if(usr.stat != 0)
			return
		if(beaker)
			filtering = 0
			beaker.loc = usr.loc
			beaker = null
		add_fingerprint(usr)
		return

	verb/move_inside()
		set name = "Enter Sleeper"
		set category = "Object"
		set src in oview(1)

		if(usr.stat != 0 || !(ishuman(usr) || issmall(usr)))
			return

		if(src.occupant)
			usr << "\blue <B>The sleeper is already occupied!</B>"
			return

		for(var/mob/living/carbon/slime/M in range(1,usr))
			if(M.Victim == usr)
				usr << "You're too busy getting your life sucked out of you."
				return
		visible_message("[usr] starts climbing into the sleeper.", 3)
		if(do_after(usr, 20))
			if(src.occupant)
				usr << "\blue <B>The sleeper is already occupied!</B>"
				return
			usr.stop_pulling()
			usr.client.perspective = EYE_PERSPECTIVE
			usr.client.eye = src
			usr.loc = src
			update_use_power(2)
			src.occupant = usr
			src.icon_state = "sleeper_1"
			if(orient == "RIGHT")
				icon_state = "sleeper_1-r"

			for(var/obj/O in src)
				qdel(O)
			src.add_fingerprint(usr)
			return
		return
