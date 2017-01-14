// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/living/carbon/occupant
	var/locked
	name = "Body Scanner"
	desc = "A state-of-the-art medical diagnostics machine. Guaranteed detection of all your bodily ailments or your money back!"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.

/obj/machinery/bodyscanner/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if (usr.stat != 0)
		return
	if (src.occupant)
		usr << "<span class='warning'>The scanner is already occupied!</span>"
		return
	if (usr.abiotic())
		usr << "<span class='warning'>The subject cannot have abiotic items on.</span>"
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	update_use_power(2)
	src.icon_state = "body_scanner_1"
	for(var/obj/O in src)
		//O = null
		qdel(O)
		//Foreach goto(124)
	src.add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	for(var/obj/O in src)
		O.loc = src.loc
		//Foreach goto(30)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	update_use_power(1)
	src.icon_state = "body_scanner_0"
	return

/obj/machinery/bodyscanner/attackby(obj/item/weapon/grab/G as obj, user as mob)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (src.occupant)
		user << "<span class='warning'>The scanner is already occupied!</span>"
		return
	if (G.affecting.abiotic())
		user << "<span class='warning'>Subject cannot have abiotic items on.</span>"
		return

	if(istype(G, /obj/item/weapon/grab))

		var/mob/living/L = G:affecting
		visible_message("[user] starts putting [G:affecting] into the scanner bed.", 3)

		if (do_mob(user, G:affecting, 30, needhand = 0))
			var/bucklestatus = L.bucklecheck(user)
			if (!bucklestatus)//incase the patient got buckled during the delay
				return
			if (bucklestatus == 2)
				var/obj/structure/LB = L.buckled
				LB.user_unbuckle_mob(user)
			var/mob/M = G.affecting
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			src.occupant = M
			update_use_power(2)
			src.icon_state = "body_scanner_1"
			for(var/obj/O in src)
				O.loc = src.loc
		//Foreach goto(154)
	src.add_fingerprint(user)
	//G = null
	qdel(G)
	return

/obj/machinery/bodyscanner/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if(!istype(user))
		return
	if(!ismob(O))
		return
	var/mob/living/M = O//Theres no reason this shouldn't be /mob/living
	if (src.occupant)
		user << "<span class='notice'><B>The scanner is already occupied!</B></span>"
		return
	if (M.abiotic())
		user << "<span class='notice'><B>Subject cannot have abiotic items on.</B></span>"
		return

	var/mob/living/L = O
	var/bucklestatus = L.bucklecheck(user)

	if (!bucklestatus)//We must make sure the person is unbuckled before they go in
		return

	if(L == user)
		visible_message("[user] starts climbing into the scanner bed.", 3)
	else
		visible_message("[user] starts putting [L.name] into the scanner bed.", 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled
			LB.user_unbuckle_mob(user)
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		src.occupant = M
		update_use_power(2)
		src.icon_state = "body_scanner_1"
		for(var/obj/Obj in src)
			Obj.loc = src.loc
			//Foreach goto(154)
	src.add_fingerprint(user)
	//G = null
	return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/body_scanconsole/ex_act(severity)

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

/obj/machinery/body_scanconsole/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "body_scannerconsole-p"
	else
		if (stat & NOPOWER)
			spawn(rand(0, 15))
				src.icon_state = "body_scannerconsole-p"
		else
			icon_state = initial(icon_state)

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected
	var/known_implants = list(/obj/item/weapon/implant/chem, /obj/item/weapon/implant/death_alarm, /obj/item/weapon/implant/loyalty, /obj/item/weapon/implant/tracking)
	var/delete
	var/temphtml
	name = "Body Scanner Console"
	desc = "A control panel for some kind of medical device."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1


/obj/machinery/body_scanconsole/New()
	..()
	spawn( 5 )
		src.connected = locate(/obj/machinery/bodyscanner, get_step(src, WEST))
		return
	return

/*

/obj/machinery/body_scanconsole/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	//use_power(250) // power stuff

//	var/mob/M //occupant
//	if (!( src.status )) //remove this
//		return
//	if ((src.connected && src.connected.occupant)) //connected & occupant ok
//		M = src.connected.occupant
//	else
//		if (istype(M, /mob))
//		//do stuff
//		else
///			src.temphtml = "Process terminated due to lack of occupant in scanning chamber."
//			src.status = null
//	src.updateDialog()
//	return

*/

/obj/machinery/body_scanconsole/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(user as mob)
	ui_interact(user)	// TODO: CHECK STATE BEFORE RUNNING THIS
	return
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		user << "<span class='warning'>This console is not connected to a functioning body scanner.</span>"
		return
	if (!connected.occupant)
		user << span("warning", "The body scanner is empty.")
		return
	if(!ishuman(connected.occupant))
		user << "<span class='warning'>This device can only scan compatible lifeforms.</span>"
		return
		
	var/dat
	if (src.delete && src.temphtml) //Window in buffer but its just simple message, so nothing
		src.delete = src.delete
	else if (!src.delete && src.temphtml) //Window in buffer - its a menu, dont add clear message
		dat = text("[]<BR><BR><A href='?src=\ref[];clear=1'>Main Menu</A>", src.temphtml, src)
	else
		if (src.connected) //Is something connected?
			dat = format_occupant_data(src.connected.get_occupant_data())
			dat += "<HR><A href='?src=\ref[src];print=1'>Print</A><BR>"
		else
			dat = "<span class='warning'>Error: No Body Scanner connected.</span>"

	dat += text("<BR><A href='?src=\ref[];mach_close=scanconsole'>Close</A>", user)
	user << browse(dat, "window=scanconsole;size=430x600")
	return


/obj/machinery/body_scanconsole/Topic(href, href_list)
	..()

	if (href_list["print"])
		if (!src.connected)
			usr << "\icon[src]<span class='warning'>Error: No body scanner connected.</span>"
			return
		var/mob/living/carbon/human/occupant = src.connected.occupant
		if (!occupant)
			usr << "\icon[src]<span class='warning'>The body scanner is empty.</span>"
			return
		if (!ishuman(occupant))
			usr << "\icon[src]<span class='warning'>The body scanner cannot scan that lifeform.</span>"
			return

		world.log << "## DEBUG: Diag. scanner [src] at [src.loc] is printing a report."

		var/obj/item/weapon/paper/R = new(src.loc)
		R.set_content_unsafe("Scan ([occupant])", format_occupant_data(src.connected.get_occupant_data()))

		print(R, "[src] beeps, printing [R.name] after a moment.")


/obj/machinery/body_scanconsole/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/occupied = (src.connected && src.connected.occupant)
	
	data["occupied"] = occupied
	if (occupied)
		var/mob/living/carbon/human/occupant = src.connected.occupant
		var/datum/reagents/R = occupant.bloodstr
		var/datum/reagents/B = occupant.vessel
		data["stat"]			= occupant.stat
		data["name"]			= occupant.name
		data["health"]			= occupant.health
		data["maxHealth"]		= occupant.maxHealth
		data["minHealth"]		= config.health_threshold_dead
		data["bruteLoss"]		= occupant.getBruteLoss()
		data["oxyLoss"]			= occupant.getOxyLoss()
		data["toxLoss"]			= occupant.getToxLoss()
		data["fireLoss"]		= occupant.getFireLoss()
		data["rads"]			= occupant.total_radiation
		data["cloneloss"]		= occupant.getCloneLoss()
		data["brainloss"]		= occupant.getBrainLoss()
		data["paralysis"]		= occupant.paralysis
		data["bodytemp"]		= occupant.bodytemperature
		data["occupant"] 		= occupant
		data["bloodAmt"] 		= B.get_reagent_amount("blood")
		data["bloodMax"] 		= 560	// You'd think this'd be defined somewhere.
		data["bloodPerc"]		= (data["bloodAmt"] / data["bloodMax"]) * 100
		data["bloodStatus"]		= val2status(data["bloodAmt"], B.total_volume * 0.9, B.total_volume * 0.8, inverse = 1)
		data["inaprovAmt"] 		= R.get_reagent_amount("inaprovaline")
		data["soporAmt"] 		= R.get_reagent_amount("stoxin")
		data["bicardAmt"] 		= R.get_reagent_amount("bicaridine")
		data["dexAmt"] 			= R.get_reagent_amount("dexalin")
		data["dermAmt"]			= R.get_reagent_amount("dermaline")
		data["otherAmt"]		= R.total_volume - (data["soporAmt"] + data["dexAmt"] + data["bicardAmt"] + data["inaprovAmt"] + data["dermAmt"])
		data["brainDmgStatus"] 	= val2status(occupant.brainloss, 20, 50)
		data["radStatus"] 		= val2status(occupant.total_radiation)
		data["cloneDmgStatus"] 	= val2status(occupant.cloneloss, 10, 35)
		var/org 				= get_organ_wound_data(occupant)
		data["organData"]		= generate_organ_panes(org)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "med_diagnostics.tmpl", "Medical Diagnostics", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// It's ugly, but directly using NanoUI for this doesn't seem to work.
/obj/machinery/body_scanconsole/proc/generate_organ_panes(var/list/data)
	var/output = ""
	for (var/item in data)
		var/temp = "<div><div class='line'>"
		temp += "<b>[item["name"]]</b></div>"
		temp += "<div class='line'><div class='statusLabel'=&gt; Burn Dmg:</div>"
		temp += "<div class='statusValue'>[item["burnDmg"]]</div></div>"
		temp += "<div class='line'><div class='statusLabel'=&gt; Brute Dmg:</div>"
		temp += "<div class='statusValue'>[item["bruteDmg"]]</div></div>"
		if (item["hasWounds"])
			temp += "<ul>[item["wounds"]]</ul>"
		
		temp += "</div>"
		output += temp

	return output

/obj/machinery/body_scanconsole/proc/get_missing_organs(var/mob/living/carbon/human/H)
	var/list/missingOrgans = list()
	var/list/species_organs = H.species.has_organ
	for (var/organ_name in H.species.has_organ)
		if (!locate(species_organs[organ_name]) in H.internal_organs)
			missingOrgans += organ_name
	return missingOrgans

/obj/machinery/body_scanconsole/proc/get_organ_wound_data(var/mob/living/carbon/human/H)
	var/list/organs = list()
	
	// Internal Organs. (Duh.)
	for (var/obj/item/organ/O in H.internal_organs)
		var/list/data = list()
		data["name"] = O.name
		var/wounds = ""
		switch (O.damtype)
			if ("brute")
				data["bruteDmg"] = O.damage
				data["burnDmg"] = 0
			if ("burn")
				data["burnDmg"] = O.damage
				data["bruteDmg"] = 0

		if (istype(O, /obj/item/organ/lungs) && H.is_lung_ruptured())
			wounds += "<li>Appears to be ruptured.</li>"

		if (istype(O, /obj/item/organ/brain) && H.has_brain_worms())
			wounds += "<li>Has an abnormal growth.</li>"

		if (istype(O, H.species.vision_organ))
			if (H.sdisabilities & BLIND)
				wounds += "<li>Appears to have cataracts.</li>"
			else if (H.disabilities & NEARSIGHTED)
				wounds += "<li>Appears to have misaligned retinas.</li>"

		if (O.germ_level)
			wounds += get_infection_level(O.germ_level)
		
		if (O.rejecting)
			wounds += "<li>Shows symptoms of organ rejection.</li>"

		data["hasWounds"] = length(wounds) ? 1 : 0
		data["wounds"] = wounds
		organs += data
		world.log << "## DEBUG: Int. Organ [O.name]: hasWounds=[length(wounds) ? 1 : 0],damtype=[O.damtype],damage=[O.damage]"

	// Limbs.
	for (var/obj/item/organ/external/O in H.organs)
		var/list/data = list()
		data["burnDmg"] = O.burn_dam
		data["bruteDmg"] = O.brute_dam
		
		var/list/wounds = list()
		//var/broken
		var/num_IB = 0
		for (var/datum/wound/W in O.wounds)
			if (W.internal)
				num_IB++

		if (num_IB)
			if (num_IB > 1)
				wounds += "<li>Shows signs of severe internal bleeding.</li>"
			else
				wounds += "<li>Shows signs of internal bleeding.</li>"

		if (O.status & ORGAN_ROBOT)
			wounds += "<li>Appears to be prosthetic.</li>"
		if (O.status & ORGAN_SPLINTED)
			wounds += "<li>Appears to be splinted.</li>"
		if (O.status & ORGAN_BLEEDING)
			wounds += "<li>Appears to be bleeding.</li>"
		if (O.status & ORGAN_BROKEN)
			wounds += "<li>[O.broken_description]</li>"
		if (O.open)
			wounds += "<li>Has an open wound.</li>"
		if (O.germ_level)
			wounds += get_infection_level(O.germ_level)
		if (O.rejecting)
			wounds += "<li>Shows symptoms indicating limb rejection.</li>"

		if (O.implants.len)
			var/unk = 0
			for (var/I in O.implants)
				if (is_type_in_list(I, known_implants))
					wounds += "[I] implanted."
				else
					unk++
			if (unk)
				wounds += "<li>Has an abnormal mass of tissue present.</li>"
	
		data["hasWounds"] = length(wounds) ? 1 : 0
		data["wounds"] = wounds
		organs += data
		world.log << "## DEBUG: Ext. Organ [O.name]: hasWounds=[length(wounds) ? 1 : 0],num_IB=[num_IB],brute_dam=[O.brute_dam],burn_dam=[O.burn_dam]."

	return organs

/obj/machinery/body_scanconsole/proc/get_infection_level(var/level)
	var/output = ""
	switch (level)
		if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
			output = "mild"
		if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 200)
			output = "worsening mild"
		if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
			output = "borderline acute"
		if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
			output = "acute"
		if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
			output = "worsening acute"
		if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_TWO + 400)
			output = "borderline septic"
		if (INFECTION_LEVEL_THREE to INFINITY)
			output = "septic"
	
	return "<li>Shows symptoms of \a [output] infection.</li>"

/obj/machinery/body_scanconsole/proc/val2status(var/val, var/warn_threshold = 10, var/danger_threshold = 50, var/inverse = 0)
	if (val < warn_threshold)
		return inverse ? "bad" : "good"
	if (val < danger_threshold)
		return "average"
	return inverse ? "good" : "bad"

/obj/machinery/bodyscanner/proc/get_occupant_data()
	if (!occupant || !istype(occupant, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = occupant
	var/list/occupant_data = list(
		"stationtime" = worldtime2text(),
		"stat" = H.stat,
		"health" = H.health,
		"virus_present" = H.virus2.len,
		"bruteloss" = H.getBruteLoss(),
		"fireloss" = H.getFireLoss(),
		"oxyloss" = H.getOxyLoss(),
		"toxloss" = H.getToxLoss(),
		"rads" = H.total_radiation,
		"cloneloss" = H.getCloneLoss(),
		"brainloss" = H.getBrainLoss(),
		"paralysis" = H.paralysis,
		"bodytemp" = H.bodytemperature,
		"borer_present" = H.has_brain_worms(),
		"inaprovaline_amount" = H.reagents.get_reagent_amount("inaprovaline"),
		"dexalin_amount" = H.reagents.get_reagent_amount("dexalin"),
		"stoxin_amount" = H.reagents.get_reagent_amount("stoxin"),
		"bicaridine_amount" = H.reagents.get_reagent_amount("bicaridine"),
		"dermaline_amount" = H.reagents.get_reagent_amount("dermaline"),
		"blood_amount" = H.vessel.get_reagent_amount("blood"),
		"disabilities" = H.sdisabilities,
		"tg_diseases_list" = H.viruses.Copy(),
		"lung_ruptured" = H.is_lung_ruptured(),
		"external_organs" = H.organs.Copy(),
		"internal_organs" = H.internal_organs.Copy(),
		"species_organs" = H.species.has_organ //Just pass a reference for this, it shouldn't ever be modified outside of the datum.
		)
	return occupant_data


/obj/machinery/body_scanconsole/proc/format_occupant_data(var/list/occ)
	var/dat = "<font color='blue'><b>Scan performed at [occ["stationtime"]]</b></font><br>"
	dat += "<font color='blue'><b>Occupant Statistics:</b></font><br>"
	var/aux
	switch (occ["stat"])
		if(0)
			aux = "Conscious"
		if(1)
			aux = "Unconscious"
		else
			aux = "Dead"
	dat += text("[]\tHealth %: [] ([])</font><br>", ("<font color='[occ["health"] > 50 ? "blue" : "red"]>"), occ["health"], aux)
	if (occ["virus_present"])
		dat += "<font color='red'>Viral pathogen detected in blood stream.</font><br>"
	dat += text("[]\t-Brute Damage %: []</font><br>", ("<font color='[occ["bruteloss"] < 60  ? "blue" : "red"]'>"), occ["bruteloss"])
	dat += text("[]\t-Respiratory Damage %: []</font><br>", ("<font color='[occ["oxyloss"] < 60  ? "blue'" : "red"]'>"), occ["oxyloss"])
	dat += text("[]\t-Toxin Content %: []</font><br>", ("<font color='[occ["toxloss"] < 60  ? "blue" : "red"]'>"), occ["toxloss"])
	dat += text("[]\t-Burn Severity %: []</font><br><br>", ("<font color='[occ["fireloss"] < 60  ? "blue" : "red"]'>"), occ["fireloss"])

	dat += text("[]\tRadiation Level %: []</font><br>", ("<font color='[occ["rads"] < 10  ? "blue" : "red"]'>"), occ["rads"])
	dat += text("[]\tGenetic Tissue Damage %: []</font><br>", ("<font color='[occ["cloneloss"] < 1  ? "blue" : "red"]'>"), occ["cloneloss"])
	dat += text("[]\tApprox. Brain Damage %: []</font><br>", ("<font color='[occ["brainloss"] < 1  ? "blue" : "red"]'>"), occ["brainloss"])
	dat += text("Paralysis Summary %: [] ([] seconds left!)<br>", occ["paralysis"], round(occ["paralysis"] / 4))
	dat += text("Body Temperature: [occ["bodytemp"]-T0C]&deg;C ([occ["bodytemp"]*1.8-459.67]&deg;F)<br><HR>")

	if(occ["borer_present"])
		dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<br>"

	dat += text("[]\tBlood Level %: [] ([] units)</FONT><BR>", ("<font color='[occ["blood_amount"] > 448  ? "blue" : "red"]'>"), occ["blood_amount"]*100 / 560, occ["blood_amount"])

	dat += text("Inaprovaline: [] units<BR>", occ["inaprovaline_amount"])
	dat += text("Soporific: [] units<BR>", occ["stoxin_amount"])
	dat += text("[]\tDermaline: [] units</FONT><BR>", ("<font color='[occ["dermaline_amount"] < 30  ? "black" : "red"]'>"), occ["dermaline_amount"])
	dat += text("[]\tBicaridine: [] units</font><BR>", ("<font color='[occ["bicaridine_amount"] < 30  ? "black" : "red"]'>"), occ["bicaridine_amount"])
	dat += text("[]\tDexalin: [] units</font><BR>", ("<font color='[occ["dexalin_amount"] < 30  ? "black" : "red"]'>"), occ["dexalin_amount"])

	for(var/datum/disease/D in occ["tg_diseases_list"])
		if(!D.hidden[SCANNER])
			dat += text("<font color='red'><B>Warning: [D.form] Detected</B>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</FONT><BR>")

	dat += "<HR><table border='1'>"
	dat += "<tr>"
	dat += "<th>Organ</th>"
	dat += "<th>Burn Damage</th>"
	dat += "<th>Brute Damage</th>"
	dat += "<th>Other Wounds</th>"
	dat += "</tr>"

	for(var/obj/item/organ/external/e in occ["external_organs"])
		var/AN = ""
		var/open = ""
		var/infected = ""
		var/imp = ""
		var/bled = ""
		var/robot = ""
		var/splint = ""
		var/internal_bleeding = ""
		var/lung_ruptured = ""

		dat += "<tr>"

		for(var/datum/wound/W in e.wounds) if(W.internal)
			internal_bleeding = "<br>Internal bleeding"
			break
		if(istype(e, /obj/item/organ/external/chest) && occ["lung_ruptured"])
			lung_ruptured = "Lung ruptured:"
		if(e.status & ORGAN_SPLINTED)
			splint = "Splinted:"
		if(e.status & ORGAN_BLEEDING)
			bled = "Bleeding:"
		if(e.status & ORGAN_BROKEN)
			AN = "[e.broken_description]:"
		if(e.status & ORGAN_ROBOT)
			robot = "Prosthetic:"
		if(e.open)
			open = "Open:"

		switch (e.germ_level)
			if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
				infected = "Mild Infection:"
			if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
				infected = "Mild Infection+:"
			if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
				infected = "Mild Infection++:"
			if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
				infected = "Acute Infection:"
			if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
				infected = "Acute Infection+:"
			if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_TWO + 400)
				infected = "Acute Infection++:"
			if (INFECTION_LEVEL_THREE to INFINITY)
				infected = "Septic:"
		if(e.rejecting)
			infected += "(being rejected)"
		if (e.implants.len)
			var/unknown_body = 0
			for(var/I in e.implants)
				if(is_type_in_list(I,known_implants))
					imp += "[I] implanted:"
				else
					unknown_body++
			if(unknown_body)
				imp += "Unknown body present:"

		if(!AN && !open && !infected & !imp)
			AN = "None:"
		if(!e.is_stump())
			dat += "<td>[e.name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[robot][bled][AN][splint][open][infected][imp][internal_bleeding][lung_ruptured]</td>"
		else
			dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not [e.is_stump() ? "Found" : "Attached Completely"]</td>"
		dat += "</tr>"

	for(var/obj/item/organ/i in occ["internal_organs"])

		var/mech = ""
		if(i.robotic == 1)
			mech = "Assisted:"
		if(i.robotic == 2)
			mech = "Mechanical:"

		var/infection = "None"
		switch (i.germ_level)
			if (1 to INFECTION_LEVEL_ONE + 200)
				infection = "Mild Infection:"
			if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
				infection = "Mild Infection+:"
			if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
				infection = "Mild Infection++:"
			if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
				infection = "Acute Infection:"
			if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
				infection = "Acute Infection+:"
			if (INFECTION_LEVEL_TWO + 300 to INFINITY)
				infection = "Acute Infection++:"
		if(i.rejecting)
			infection += "(being rejected)"

		dat += "<tr>"
		dat += "<td>[i.name]</td><td>N/A</td><td>[i.damage]</td><td>[infection]:[mech]</td><td></td>"
		dat += "</tr>"
	dat += "</table>"

	var/list/species_organs = occ["species_organs"]
	for(var/organ_name in species_organs)
		if(!locate(species_organs[organ_name]) in occ["internal_organs"])
			dat += text("<font color='red'>No [organ_name] detected.</font><BR>")

	if(occ["sdisabilities"] & BLIND)
		dat += text("<font color='red'>Cataracts detected.</font><BR>")
	if(occ["sdisabilities"] & NEARSIGHTED)
		dat += text("<font color='red'>Retinal misalignment detected.</font><BR>")
	return dat
