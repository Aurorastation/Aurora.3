// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/living/carbon/occupant
	var/last_occupant_name = ""
	var/locked
	var/obj/machinery/body_scanconsole/connected
	var/list/allowed_species = list(
		"Human",
		"Skrell",
		"Unathi",
		"Tajara",
		"M'sai Tajara",
		"Zhan-Khazan Tajara",
		"Vaurca Worker",
		"Vaurca Warrior",
		"Diona"
	)
	name = "Body Scanner"
	desc = "A state-of-the-art medical diagnostics machine. Guaranteed detection of all your bodily ailments or your money back!"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scanner_0"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.

/obj/machinery/bodyscanner/Destroy()
	// So the GC can qdel this.
	if (connected)
		connected.connected = null
	return ..()

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
	usr.forceMove(src)
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

	last_occupant_name = src.occupant.name
	for(var/obj/O in src)
		O.forceMove(src.loc)
		//Foreach goto(30)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.forceMove(src.loc)
	src.occupant = null
	update_use_power(1)
	src.icon_state = "body_scanner_0"
	return

/obj/machinery/bodyscanner/attackby(obj/item/weapon/grab/G, mob/user)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( isliving(G.affecting) )))
		return
	if (src.occupant)
		user << "<span class='warning'>The scanner is already occupied!</span>"
		return
	if (G.affecting.abiotic())
		user << "<span class='warning'>Subject cannot have abiotic items on.</span>"
		return

	var/mob/living/M = G.affecting
	user.visible_message("<span class='notice'>[user] starts putting [M] into [src].</span>", "<span class='notice'>You start putting [M] into [src].</span>", range = 3)

	if (do_mob(user, G.affecting, 30, needhand = 0))
		var/bucklestatus = M.bucklecheck(user)
		if (!bucklestatus)//incase the patient got buckled during the delay
			return
		if (bucklestatus == 2)
			var/obj/structure/LB = M.buckled
			LB.user_unbuckle_mob(user)
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

		M.forceMove(src)
		src.occupant = M
		update_use_power(2)
		src.icon_state = "body_scanner_1"
		for(var/obj/O in src)
			O.forceMove(loc)
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
		user.visible_message("<span class='notice'>[user] starts climbing into [src].</span>", "<span class='notice'>You start climbing into [src].</span>", range = 3)
	else
		user.visible_message("<span class='notice'>[user] starts putting [L] into [src].</span>", "<span class='notice'>You start putting [L] into [src].</span>", range = 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled
			LB.user_unbuckle_mob(user)
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		src.occupant = M
		update_use_power(2)
		src.icon_state = "body_scanner_1"
		for(var/obj/Obj in src)
			Obj.forceMove(src.loc)
			//Foreach goto(154)
	src.add_fingerprint(user)
	//G = null
	return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/bodyscanner/proc/check_species()
	if (!occupant || !ishuman(occupant))
		return 1
	var/mob/living/carbon/human/O = occupant
	if (!O)
		return 1
	return !(O.get_species() in allowed_species)

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

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected
	var/known_implants = list(/obj/item/weapon/implant/chem, /obj/item/weapon/implant/death_alarm, /obj/item/weapon/implant/loyalty, /obj/item/weapon/implant/tracking)
	var/collapse_desc = ""
	name = "Body Scanner Console"
	desc = "A control panel for some kind of medical device."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1

/obj/machinery/body_scanconsole/Destroy()
	if (connected)
		connected.connected = null
	return ..()

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

/obj/machinery/body_scanconsole/proc/get_lung_desc()
	if (!src.connected || !src.connected.occupant)
		return
	if (src.connected.occupant.name != src.connected.last_occupant_name || !collapse_desc)
		var/ldesc = pick("Contains fluid.", "Shows symptoms of collapse.", "Collapsed.", "Shows symptoms of rupture.", "Is ruptured.")
		collapse_desc = ldesc
		src.connected.last_occupant_name = src.connected.occupant.name
		return ldesc

	return collapse_desc

/obj/machinery/body_scanconsole/Initialize()
	. = ..()
	for(var/obj/machinery/bodyscanner/C in orange(1,src))
		connected = C
		break
	src.connected.connected = src

/obj/machinery/body_scanconsole/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(user as mob)
	if(..())
		return

	ui_interact(user)

/obj/machinery/body_scanconsole/Topic(href, href_list)
	..()

	// shouldn't be reachable if occupant is invalid
	if (href_list["print"])
		var/obj/item/weapon/paper/R = new(src.loc)
		R.set_content_unsafe("Scan ([src.connected.occupant])", format_occupant_data(src.connected.get_occupant_data()))

		print(R, "[src] beeps, printing [R.name] after a moment.")

/obj/machinery/body_scanconsole/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/occupied = (src.connected && src.connected.occupant)
	var/mob/living/carbon/human/occupant
	if (src.connected)
		occupant = src.connected.occupant

	data["noscan"]		= src.connected.check_species()
	data["nocons"]		= !src.connected
	data["occupied"] 	= occupied
	data["invalid"]		= src.connected && src.connected.check_species()
	data["ipc"]			= src.connected && occupant && isipc(occupant)
	if (!data["invalid"])
		var/datum/reagents/R = occupant.bloodstr
		var/datum/reagents/B = occupant.vessel
		data["stat"]			= occupant.stat
		data["name"]			= occupant.name
		data["species"]			= occupant.get_species()	// mostly for fluff.
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
		data["brainDmgStatus"] 	= val2status(occupant.getBrainLoss(), 20, 50)
		data["radStatus"] 		= val2status(occupant.total_radiation)
		data["cloneDmgStatus"] 	= val2status(occupant.cloneloss, 10, 35)
		data["bodyparts"]		= get_organ_wound_data(occupant)
		var/list/missing 		= get_missing_organs(occupant)
		data["missingparts"]	= missing
		data["hasmissing"]		= missing.len ? 1 : 0
		data["hasvirus"]		= occupant.virus2.len || occupant.viruses.len
		data["hastgvirus"]		= occupant.viruses.len
		data["tgvirus"]			= occupant.viruses

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "med_diagnostics.tmpl", "Medical Diagnostics", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

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
		var/list/wounds = list()
		switch (O.damtype)
			if ("brute")
				data["bruteDmg"] = O.damage
				data["burnDmg"] = 0
			if ("burn")
				data["burnDmg"] = O.damage
				data["bruteDmg"] = 0

		if (istype(O, /obj/item/organ/lungs) && H.is_lung_ruptured())
			wounds += get_lung_desc()

		if (istype(O, /obj/item/organ/brain) && H.has_brain_worms())
			wounds += "Has an abnormal growth."

		if (istype(O, H.species.vision_organ))
			if (H.sdisabilities & BLIND)
				wounds += "Appears to have cataracts."
			else if (H.disabilities & NEARSIGHTED)
				wounds += "Appears to have misaligned retinas."

		if (O.germ_level)
			var/level = get_infection_level(O.germ_level)
			if (level && level != "")
				wounds += "Shows symptoms of \a [level] infection."

		if (O.rejecting)
			wounds += "Shows symptoms of organ rejection."

		data["hasWounds"] = length(wounds) ? 1 : 0
		data["wounds"] = wounds
		organs += list(data)

	// Limbs.
	for (var/obj/item/organ/external/O in H.organs)
		var/list/data = list()
		data["burnDmg"] = O.burn_dam
		data["bruteDmg"] = O.brute_dam
		data["name"] = O.name

		var/list/wounds = list()
		var/num_IB = 0
		for (var/datum/wound/W in O.wounds)
			if (W.internal)
				num_IB++

		if (num_IB)
			if (num_IB > 1)
				wounds += "Shows signs of severe internal bleeding."
			else
				wounds += "Shows signs of internal bleeding."

		if (O.status & ORGAN_ROBOT)
			wounds += "Appears to be composed of inorganic material."
		if (O.status & ORGAN_SPLINTED)
			wounds += "Splinted."
		if (O.status & ORGAN_BLEEDING)
			wounds += "Bleeding."
		if (O.status & ORGAN_BROKEN)
			wounds += "[O.broken_description]."
		if (O.open)
			wounds += "Has an open wound."
		if (O.germ_level)
			var/level = get_infection_level(O.germ_level)
			if (level && level != "")
				wounds += "Shows symptoms of \a [level] infection."
		if (O.rejecting)
			wounds += "Shows symptoms indicating limb rejection."

		if (O.implants.len)
			var/unk = 0
			for (var/atom/movable/I in O.implants)
				if (is_type_in_list(I, known_implants))
					wounds += "\a [I.name] is installed."
				else
					unk += 1
			if (unk)
				wounds += "Has an abnormal mass present."

		data["hasWounds"] = length(wounds) ? 1 : 0
		data["wounds"] = wounds
		organs += list(data)

	return organs

/obj/machinery/body_scanconsole/proc/get_infection_level(var/level)
	switch (level)
		if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
			return "mild"
		if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
			return "worsening mild"
		if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
			return "borderline acute"
		if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
			return "acute"
		if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
			return "worsening acute"
		if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_TWO + 400)
			return "borderline septic"
		if (INFECTION_LEVEL_THREE to INFINITY)
			return "septic"

	return ""

/obj/machinery/body_scanconsole/proc/val2status(var/val, var/warn_threshold = 10, var/danger_threshold = 50, var/inverse = 0)
	if (val < warn_threshold)
		return inverse ? "bad" : "good"
	if (val < danger_threshold)
		return "average"
	return inverse ? "good" : "bad"


// These are old procs used for printing.

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

		var/infection = "[get_infection_level(e.germ_level)] infection"
		if (infection == "")
			infection = "None"
		if(e.rejecting)
			infected += " (being rejected)"

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

		var/infection = get_infection_level(i.germ_level)
		if (infection == "")
			infection = "None"
		else
			infection = "[infection] infection"
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
