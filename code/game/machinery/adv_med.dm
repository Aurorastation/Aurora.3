// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/living/carbon/occupant
	var/last_occupant_name = ""
	var/locked
	var/obj/machinery/body_scanconsole/connected
	var/list/allowed_species = list(
		"Human",
		"Off-Worlder Human",
		"Skrell",
		"Unathi",
		"Aut'akh Unathi",
		"Tajara",
		"M'sai Tajara",
		"Zhan-Khazan Tajara",
		"Vaurca Worker",
		"Vaurca Warrior",
		"Diona",
		"Monkey"
	)
	name = "Body Scanner"
	desc = "A state-of-the-art medical diagnostics machine. Guaranteed detection of all your bodily ailments or your money back!"
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "body_scanner"
	density = 1
	anchored = 1
	component_types = list(
			/obj/item/circuitboard/bodyscanner,
			/obj/item/stock_parts/capacitor = 2,
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/device/healthanalyzer
		)

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.

/obj/machinery/bodyscanner/Initialize()
	. = ..()
	update_icon()

/obj/machinery/bodyscanner/Destroy()
	// So the GC can qdel this.
	if (connected)
		connected.connected = null
	return ..()

/obj/machinery/bodyscanner/update_icon()
	flick("[initial(icon_state)]-anim", src)
	if(occupant)
		icon_state = "[initial(icon_state)]-closed"
		return
	else
		icon_state = initial(icon_state)

/obj/machinery/bodyscanner/relaymove(mob/user as mob)
	if (user.stat)
		return
	go_out()
	return

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.stat != CONSCIOUS)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if (usr.stat != CONSCIOUS)
		return
	if (occupant)
		to_chat(usr, span("warning", "The scanner is already occupied!"))
		return
	if (usr.abiotic())
		to_chat(usr, span("warning", "The subject cannot have abiotic items on."))
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	occupant = usr
	update_use_power(2)
	update_icon()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/proc/go_out()
	if(!occupant || locked)
		return

	last_occupant_name = occupant.name
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	update_use_power(1)
	update_icon()
	return

/obj/machinery/bodyscanner/attackby(obj/item/grab/G, mob/user)
	if (!istype(G, /obj/item/grab) || !isliving(G.affecting) )
		return
	if (occupant)
		to_chat(user, span("warning", "The scanner is already occupied!"))
		return
	if (G.affecting.abiotic())
		to_chat(user, span("warning", "Subject cannot have abiotic items on."))
		return

	var/mob/living/M = G.affecting
	user.visible_message(span("notice", "\The [user] starts putting \the [M] into \the [src]."), span("notice", "You start putting \the [M] into \the [src]."), range = 3)

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
		occupant = M
		update_use_power(2)
		update_icon()
		//Foreach goto(154)
	add_fingerprint(user)
	//G = null
	qdel(G)
	return

/obj/machinery/bodyscanner/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if(!istype(user))
		return
	if(!ismob(O))
		return
	var/mob/living/M = O//Theres no reason this shouldn't be /mob/living
	if (occupant)
		to_chat(user, span("notice", "<B>The scanner is already occupied!</B>"))
		return
	if (M.abiotic())
		to_chat(user, span("notice", "<B>Subject cannot have abiotic items on.</B>"))
		return

	var/mob/living/L = O
	var/bucklestatus = L.bucklecheck(user)

	if (!bucklestatus)//We must make sure the person is unbuckled before they go in
		return

	if(L == user)
		user.visible_message(span("notice", "\The [user] starts climbing into \the [src]."), span("notice", "You start climbing into \the [src]."), range = 3)
	else
		user.visible_message(span("notice", "\The [user] starts putting \the [L] into \the [src]."), span("notice", "You start putting \the [L] into \the [src]."), range = 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled
			LB.user_unbuckle_mob(user)
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		occupant = M
		update_use_power(2)
		update_icon()
		playsound(loc, 'sound/machines/medbayscanner1.ogg', 50)
	add_fingerprint(user)
	//G = null
	return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(loc)
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/bodyscanner/proc/check_species()
	if (!occupant || !ishuman(occupant))
		return TRUE
	var/mob/living/carbon/human/O = occupant
	if (!O)
		return TRUE
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
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/mindshield, /obj/item/implant/tracking)
	var/collapse_desc = ""
	var/broken_desc = ""
	name = "Body Scanner Console"
	desc = "A control panel for some kind of medical device."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1
	component_types = list(
			/obj/item/circuitboard/bodyscannerconsole,
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/stock_parts/console_screen
		)


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
				icon_state = "body_scannerconsole-p"
		else
			icon_state = initial(icon_state)

/obj/machinery/body_scanconsole/proc/get_collapsed_lung_desc()
	if (!connected || !connected.occupant)
		return
	if (connected.occupant.name != connected.last_occupant_name || !collapse_desc)
		var/ldesc = pick("Shows symptoms of collapse.", "Collapsed.", "Pneumothorax detected.")
		collapse_desc = ldesc
		connected.last_occupant_name = connected.occupant.name

	return collapse_desc

/obj/machinery/body_scanconsole/proc/get_broken_lung_desc()
	if (!connected || !connected.occupant)
		return
	if (connected.occupant.name != connected.last_occupant_name || !broken_desc)
		var/ldesc = pick("Shows symptoms of rupture.", "Ruptured.", "Extensive damage detected.")
		broken_desc = ldesc
		connected.last_occupant_name = connected.occupant.name

	return broken_desc

/obj/machinery/body_scanconsole/Initialize()
	. = ..()
	for(var/obj/machinery/bodyscanner/C in orange(1,src))
		connected = C
		break
	connected.connected = src

/obj/machinery/body_scanconsole/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(var/mob/user)
	if(..())
		return

	ui_interact(user)

/obj/machinery/body_scanconsole/Topic(href, href_list)
	..()

	// shouldn't be reachable if occupant is invalid
	if(href_list["print"])
		var/obj/item/paper/R = new(loc)
		R.color = "#eeffe8"
		R.set_content_unsafe("Scan ([connected.occupant])", format_occupant_data(connected.get_occupant_data()))

		print(R, "[src] beeps, printing [R.name] after a moment.")

/obj/machinery/body_scanconsole/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "medical-bodyscanner", 800, 600, capitalize(name))
	ui.open()

/obj/machinery/body_scanconsole/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list(
			"noscan" = null,
			"nocons" = null,
			"occupied" = null,
			"invalid" = null,
			"ipc" = null,
			"stat" = null,
			"name" = null,
			"species" = null,
			"brain_activity" = null,
			"pulse" = null,
			"blood_pressure" = null,
			"blood_pressure_level" = null,
			"blood_volume" = null,
			"blood_o2" = null,
			"rads" = null,
			"cloneLoss" = null,
			"oxyLoss" = null,
			"bruteLoss" = null,
			"fireLoss" = null,
			"toxLoss" = null,
			"paralysis" = null,
			"bodytemp" = null,
			"occupant" = null,
			"norepiAmt" = null,
			"soporAmt" = null,
			"bicardAmt" = null,
			"dexAmt" = null,
			"dermAmt" = null,
			"otherAmt" = null,
			"bodyparts" = list(),
			"organs" = list(),
			"missingparts" = list(),
			"hasmissing" = null,
			"hasvirus" = null,
			"hastgvirus" = null,
			"tgvirus" = list()
		)

	var/mob/living/carbon/human/occupant
	if (connected)
		occupant = connected.occupant

		VUEUI_SET_CHECK(data["noscan"], !!connected.check_species(), ., data)
		VUEUI_SET_CHECK(data["nocons"], !connected, ., data)
		VUEUI_SET_CHECK(data["occupied"], connected.occupant, ., data)
		VUEUI_SET_CHECK(data["invalid"], !!connected.check_species(), ., data)
		VUEUI_SET_CHECK(data["ipc"], (occupant && isipc(occupant)), ., data)

	if (!data["invalid"])
		var/datum/reagents/R = occupant.bloodstr

		var/brain_result = occupant.get_brain_result()

		var/pulse_result
		if(occupant.should_have_organ(BP_HEART))
			var/obj/item/organ/internal/heart/heart = occupant.internal_organs_by_name[BP_HEART]
			if(!heart)
				pulse_result = 0
			else if(BP_IS_ROBOTIC(heart))
				pulse_result = -2
			else if(occupant.status_flags & FAKEDEATH)
				pulse_result = 0
			else
				pulse_result = occupant.get_pulse(GETPULSE_TOOL)
		else
			pulse_result = -1

		if(pulse_result == ">250")
			pulse_result = -3

		VUEUI_SET_CHECK(data["stat"], occupant.stat, ., data)
		VUEUI_SET_CHECK(data["name"], occupant.name, ., data)
		VUEUI_SET_CHECK(data["species"], occupant.get_species(), ., data)
		VUEUI_SET_CHECK(data["brain_activity"], brain_result, ., data)
		VUEUI_SET_CHECK(data["pulse"], text2num(pulse_result), ., data)
		VUEUI_SET_CHECK(data["blood_pressure"], occupant.get_blood_pressure(), ., data)
		VUEUI_SET_CHECK(data["blood_pressure_level"], occupant.get_blood_pressure_alert(), ., data)
		VUEUI_SET_CHECK(data["blood_volume"], occupant.get_blood_volume(), ., data)
		VUEUI_SET_CHECK(data["blood_o2"], occupant.get_blood_oxygenation(), ., data)
		VUEUI_SET_CHECK(data["rads"], occupant.total_radiation, ., data)

		VUEUI_SET_CHECK(data["cloneLoss"], get_severity(occupant.getCloneLoss()), ., data)
		VUEUI_SET_CHECK(data["oxyLoss"], get_severity(occupant.getOxyLoss()), ., data)
		VUEUI_SET_CHECK(data["bruteLoss"], get_severity(occupant.getBruteLoss()), ., data)
		VUEUI_SET_CHECK(data["fireLoss"], get_severity(occupant.getFireLoss()), ., data)
		VUEUI_SET_CHECK(data["toxLoss"], get_severity(occupant.getToxLoss()), ., data)

		VUEUI_SET_CHECK(data["paralysis"], occupant.paralysis, ., data)
		VUEUI_SET_CHECK(data["bodytemp"], occupant.bodytemperature, ., data)
		VUEUI_SET_CHECK(data["occupant"], !!occupant, ., data)
		VUEUI_SET_CHECK(data["norepiAmt"], R.get_reagent_amount("norepinephrine"), ., data)
		VUEUI_SET_CHECK(data["soporAmt"], R.get_reagent_amount("stoxin"), ., data)
		VUEUI_SET_CHECK(data["bicardAmt"], R.get_reagent_amount("bicaridine"), ., data)
		VUEUI_SET_CHECK(data["dexAmt"], R.get_reagent_amount("dexalin"), ., data)
		VUEUI_SET_CHECK(data["dermAmt"], R.get_reagent_amount("dermaline"), ., data)
		VUEUI_SET_CHECK(data["otherAmt"], R.total_volume - (data["soporAmt"] + data["dexAmt"] + data["bicardAmt"] + data["norepiAmt"] + data["dermAmt"]), ., data)
		VUEUI_SET_CHECK_LIST(data["bodyparts"], get_external_wound_data(occupant), ., data)
		VUEUI_SET_CHECK_LIST(data["organs"], get_internal_wound_data(occupant), ., data)
		var/list/missing 		= get_missing_organs(occupant)
		VUEUI_SET_CHECK_LIST(data["missingparts"], missing, ., data)
		VUEUI_SET_CHECK(data["hasmissing"], missing.len, ., data)
		VUEUI_SET_CHECK(data["hasvirus"], occupant.virus2.len || occupant.viruses.len, ., data)
		VUEUI_SET_CHECK(data["hastgvirus"], occupant.viruses.len, ., data)
		VUEUI_SET_CHECK_LIST(data["tgvirus"], occupant.viruses, ., data)

/obj/machinery/body_scanconsole/proc/get_internal_damage(var/obj/item/organ/internal/I)
	if(I.is_broken())
		return "severe"
	if(I.is_bruised())
		return "moderate"
	if(I.is_damaged())
		return "minor"
	return "none"

/obj/machinery/body_scanconsole/proc/get_missing_organs(var/mob/living/carbon/human/H)
	var/list/missingOrgans = list()
	var/list/species_organs = H.species.has_organ
	for (var/organ_name in H.species.has_organ)
		if (!locate(species_organs[organ_name]) in H.internal_organs)
			missingOrgans += organ_name
	return missingOrgans

/obj/machinery/body_scanconsole/proc/get_external_wound_data(var/mob/living/carbon/human/H)
	// Limbs.
	var/organs = list()
	for (var/obj/item/organ/external/O in H.organs)
		var/list/data = list()
		data["burnDmg"] = get_wound_severity(O.burn_ratio, TRUE)
		data["bruteDmg"] = get_wound_severity(O.brute_ratio, TRUE)
		data["name"] = O.name

		var/list/wounds = list()

		if (O.status & ORGAN_ROBOT)
			wounds += "Appears to be composed of inorganic material."
		if (O.status & ORGAN_ARTERY_CUT)
			wounds += "Severed [O.artery_name]."
		if (O.status & ORGAN_TENDON_CUT)
			wounds += "Severed [O.tendon_name]."
		if (O.status & ORGAN_SPLINTED)
			wounds += "Splinted."
		if (O.status & ORGAN_BLEEDING)
			wounds += "Bleeding."
		if(O.is_dislocated())
			wounds += "Dislocated."
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

		data["hasWounds"] = !!length(wounds)
		data["wounds"] = wounds
		organs += list(data)

	return organs

/obj/machinery/body_scanconsole/proc/get_internal_wound_data(var/mob/living/carbon/human/H)
	var/list/organs = list()
	// Internal Organs. (Duh.)
	for (var/obj/item/organ/internal/O in H.internal_organs)
		var/list/data = list()
		data["name"] = O.name
		var/list/wounds = list()
		data["damage"] = get_internal_damage(O)
		if(istype(O, /obj/item/organ/internal/lungs) && H.is_lung_ruptured())
			if(O.is_broken())
				wounds += get_broken_lung_desc()
			else
				wounds += get_collapsed_lung_desc()

		if(O.status & ORGAN_DEAD)
			wounds += "Necrotic and decaying."

		if(istype(O, /obj/item/organ/internal/brain) && H.has_brain_worms())
			wounds += "Has an abnormal growth."

		if(istype(O, H.species.vision_organ))
			if(H.sdisabilities & BLIND)
				wounds += "Appears to have cataracts."
			else if(H.disabilities & NEARSIGHTED)
				wounds += "Appears to have misaligned retinas."

		if(O.germ_level)
			var/level = get_infection_level(O.germ_level)
			if (level && level != "")
				wounds += "Shows symptoms of \a [level] infection."

		if(O.rejecting)
			wounds += "Shows symptoms of organ rejection."

		if(O.get_scarring_level() > 0.01)
			wounds += "[O.get_scarring_results()]."

		data["hasWounds"] = !!length(wounds)
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
		"brain_activity" = H.get_brain_status(),
		"virus_present" = H.virus2.len,
		"blood_volume" = H.get_blood_volume(),
		"blood_oxygenation" = H.get_blood_oxygenation(),
		"blood_pressure" = H.get_blood_pressure(),

		"bruteloss" = get_severity(H.getBruteLoss(), TRUE),
		"fireloss" = get_severity(H.getFireLoss(), TRUE),
		"oxyloss" = get_severity(H.getOxyLoss(), TRUE),
		"toxloss" = get_severity(H.getToxLoss(), TRUE),
		"cloneloss" = get_severity(H.getCloneLoss(), TRUE),

		"rads" = H.total_radiation,
		"paralysis" = H.paralysis,
		"bodytemp" = H.bodytemperature,
		"borer_present" = H.has_brain_worms(),
		"norepinephrine_amount" = H.reagents.get_reagent_amount("norepinephrine"),
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
	dat += text("Brain Activity: []<br>", occ["brain_activity"])
	if (occ["virus_present"])
		dat += "<font color='red'>Viral pathogen detected in blood stream.</font><br>"
	dat += text("Blood Pressure: []<br>", occ["blood_pressure"])
	dat += text("Blood Oxygenation: []%<br>", occ["blood_oxygenation"])
	dat += text("Physical Trauma: []<br>", occ["bruteloss"])
	dat += text("Oxygen Deprivation: []<br>", occ["oxyloss"])
	dat += text("Systemic Organ Failure: []<br>", occ["toxloss"])
	dat += text("Burn Severity: []<br><br>", occ["fireloss"])

	dat += text("[]\tRadiation Level %: []</font><br>", ("<font color='[occ["rads"] < 10  ? "blue" : "red"]'>"), occ["rads"])
	dat += text("Genetic Tissue Damage: []<br>", occ["cloneloss"])
	dat += text("Paralysis Summary %: [] ([] seconds left!)<br>", occ["paralysis"], round(occ["paralysis"] / 4))
	dat += text("Body Temperature: [occ["bodytemp"]-T0C]&deg;C ([occ["bodytemp"]*1.8-459.67]&deg;F)<br><HR>")

	if(occ["borer_present"])
		dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<br>"

	dat += text("Norepinephrine: [] units<BR>", occ["norepinephrine_amount"])
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
	dat += "<th>Burn Severity</th>"
	dat += "<th>Physical Trauma</th>"
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
		var/severed_tendon = ""
		var/lung_ruptured = ""
		var/dislocated = ""

		dat += "<tr>"

		if(e.status & ORGAN_ARTERY_CUT)
			internal_bleeding = "Arterial bleeding."
		if(e.status & ORGAN_TENDON_CUT)
			severed_tendon = "Severed tendon."
		if(istype(e, /obj/item/organ/external/chest) && occ["lung_ruptured"])
			lung_ruptured = "Lung ruptured."
		if(e.status & ORGAN_SPLINTED)
			splint = "Splinted."
		if(e.is_dislocated())
			dislocated = "Dislocated."
		if(e.status & ORGAN_BLEEDING)
			bled = "Bleeding."
		if(e.status & ORGAN_BROKEN)
			AN = "[e.broken_description]."
		if(e.status & ORGAN_ROBOT)
			robot = "Prosthetic."
		if(e.open)
			open = "Open."

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
			dat += "<td>[e.name]</td><td>[e.burn_dam]</td><td>[get_severity(e.brute_dam)]</td><td>[robot][bled][AN][splint][open][infected][imp][dislocated][internal_bleeding][severed_tendon][lung_ruptured]</td>"
		else
			dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not [e.is_stump() ? "Found" : "Attached Completely"]</td>"
		dat += "</tr>"

	for(var/obj/item/organ/internal/i in occ["internal_organs"])

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

		var/necrotic = ""
		if(i.get_scarring_level() > 0.01)
			necrotic += ", [i.get_scarring_results()]"
		if(i.status & ORGAN_DEAD)
			necrotic = ", <font color='red'>necrotic and decaying</font>"

		dat += "<tr>"
		dat += "<td>[i.name]</td><td>N/A</td><td>[get_internal_damage(i)]</td><td>[infection], [mech][necrotic]</td><td></td>"
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