/obj/machinery/bodyscanner
	name = "body scanner"
	desc = "A state-of-the-art medical diagnostics machine. Guaranteed detection of all your bodily ailments or your money back!"
	desc_info = "The advanced scanner detects and reports internal injuries such as bone fractures, internal bleeding, and organ damage. \
	This is useful if you are about to perform surgery.<br>\
	<br>\
	Click your target with Grab intent, then click on the scanner to place them in it. Click the red terminal to operate. \
	Right-click the scanner and click 'Eject Occupant' to remove them.  You can enter the scanner yourself in a similar way, using the 'Enter Body Scanner' \
	verb."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "body_scanner"
	density = TRUE
	anchored = TRUE
	component_types = list(
			/obj/item/circuitboard/bodyscanner,
			/obj/item/stock_parts/capacitor = 2,
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/device/healthanalyzer
		)
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

	var/mob/living/carbon/occupant
	var/last_occupant_name = ""
	var/locked
	var/obj/machinery/body_scanconsole/connected
	var/list/allowed_species = list(
		SPECIES_HUMAN,
		SPECIES_HUMAN_OFFWORLD,
		SPECIES_SKRELL,
		SPECIES_SKRELL_AXIORI,
		SPECIES_UNATHI,
		SPECIES_TAJARA,
		SPECIES_TAJARA_MSAI,
		SPECIES_TAJARA_ZHAN,
		SPECIES_VAURCA_WORKER,
		SPECIES_VAURCA_WARRIOR,
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_DIONA,
		SPECIES_DIONA_COEUS,
		SPECIES_MONKEY
	)

/obj/machinery/bodyscanner/Initialize()
	. = ..()
	update_icon()

/obj/machinery/bodyscanner/Destroy()
	// So the GC can qdel this.
	if (connected)
		connected.connected = null
		connected = null
	occupant = null
	return ..()

/obj/machinery/bodyscanner/update_icon()
	flick("[initial(icon_state)]-anim", src)
	if(occupant)
		name = "[name] ([occupant])"
		if(stat & BROKEN)
			icon_state = "[initial(icon_state)]-broken-closed"
		if(stat & NOPOWER)
			icon_state = "[initial(icon_state)]-closed"
		else
			icon_state = "[initial(icon_state)]-working"
		return
	else
		name = initial(name)
		if(stat & BROKEN)
			icon_state = "[initial(icon_state)]-broken"
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

/obj/machinery/bodyscanner/AltClick()
	if(use_check_and_message(usr))
		eject()

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if (usr.stat != CONSCIOUS)
		return
	if (occupant)
		to_chat(usr, SPAN_WARNING("The scanner is already occupied!"))
		return
	if (usr.abiotic())
		to_chat(usr, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	occupant = usr
	update_use_power(POWER_USE_ACTIVE)
	update_icon()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/proc/go_out()
	if(!occupant || locked)
		return

	playsound(loc, 'sound/machines/compbeep2.ogg', 50)
	playsound(loc, 'sound/machines/windowdoor.ogg', 50)

	last_occupant_name = occupant.name
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	update_use_power(POWER_USE_IDLE)
	update_icon()
	return

/obj/machinery/bodyscanner/attackby(obj/item/grab/G, mob/user)
	if (!istype(G, /obj/item/grab) || !isliving(G.affecting) )
		return
	if (occupant)
		to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
		return TRUE
	if (G.affecting.abiotic())
		to_chat(user, SPAN_WARNING("Subject cannot have abiotic items on."))
		return TRUE

	var/mob/living/M = G.affecting
	var/bucklestatus = M.bucklecheck(user)
	if (!bucklestatus)
		return TRUE

	user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [M] into \the [src]."), SPAN_NOTICE("You start putting \the [M] into \the [src]."), range = 3)
	if (do_mob(user, G.affecting, 30, needhand = 0))
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

		M.forceMove(src)
		occupant = M
		update_use_power(POWER_USE_ACTIVE)
		update_icon()
		//Foreach goto(154)
	add_fingerprint(user)
	//G = null
	qdel(G)
	return TRUE

/obj/machinery/bodyscanner/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if(!istype(user))
		return
	if(!ismob(O))
		return
	var/mob/living/M = O//Theres no reason this shouldn't be /mob/living
	if (occupant)
		to_chat(user, SPAN_NOTICE("<B>The scanner is already occupied!</B>"))
		return
	if (M.abiotic())
		to_chat(user, SPAN_NOTICE("<B>Subject cannot have abiotic items on.</B>"))
		return

	var/mob/living/L = O
	var/bucklestatus = L.bucklecheck(user)
	if (!bucklestatus)
		return

	if(L == user)
		user.visible_message("\The <b>[user]</b> starts climbing into \the [src].", SPAN_NOTICE("You start climbing into \the [src]."), range = 3)
	else
		user.visible_message("\The <b>[user]</b> starts putting \the [L] into \the [src].", SPAN_NOTICE("You start putting \the [L] into \the [src]."), range = 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled_to
			LB.user_unbuckle(user)
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		occupant = M
		update_use_power(POWER_USE_ACTIVE)
		update_icon()
		playsound(loc, 'sound/machines/medbayscanner1.ogg', 50)
	add_fingerprint(user)
	//G = null
	return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A in src)
				A.forceMove(loc)
				ex_act(severity)
			qdel(src)
		if(2)
			if(prob(50))
				for(var/atom/movable/A in src)
					A.forceMove(loc)
					ex_act(severity)
				qdel(src)
		if(3)
			if(prob(25))
				for(var/atom/movable/A in src)
					A.forceMove(loc)
					ex_act(severity)
				qdel(src)

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
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)

/obj/machinery/body_scanconsole
	name = "body scanner console"
	desc = "An advanced control panel that can be used to interface with a connected body scanner."
	icon = 'icons/obj/sleeper.dmi'
	icon_state = "body_scannerconsole"
	var/obj/machinery/bodyscanner/connected
	var/known_implants = list(/obj/item/implant/chem, /obj/item/implant/death_alarm, /obj/item/implant/mindshield, /obj/item/implant/tracking, /obj/item/implant/integrated_circuit)
	var/collapse_desc = ""
	var/broken_desc = ""
	var/has_internal_injuries = FALSE
	var/has_external_injuries = FALSE
	density = FALSE
	anchored = TRUE
	component_types = list(
			/obj/item/circuitboard/bodyscannerconsole,
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/stock_parts/console_screen
		)
	var/global/image/console_overlay

/obj/machinery/body_scanconsole/Destroy()
	if (connected)
		connected.connected = null
		connected = null
	return ..()

/obj/machinery/body_scanconsole/power_change()
	..()
	update_icon()

/obj/machinery/body_scanconsole/update_icon()
	cut_overlays()
	if((stat & BROKEN) || (stat & NOPOWER))
		return
	else
		if(!console_overlay)
			console_overlay = make_screen_overlay(icon, "body_scannerconsole-screen")
		add_overlay(console_overlay)
		set_light(1.4, 1, COLOR_PURPLE)

/obj/machinery/body_scanconsole/proc/get_collapsed_lung_desc()
	if (!connected || !connected.occupant)
		return
	if (connected.occupant.name != connected.last_occupant_name || !collapse_desc)
		var/ldesc = pick("shows symptoms of collapse", "dollapsed", "pneumothorax detected")
		collapse_desc = ldesc
		connected.last_occupant_name = connected.occupant.name

	return collapse_desc

/obj/machinery/body_scanconsole/proc/get_broken_lung_desc()
	if (!connected || !connected.occupant)
		return
	if (connected.occupant.name != connected.last_occupant_name || !broken_desc)
		var/ldesc = pick("shows symptoms of rupture", "ruptured", "extensive damage detected")
		broken_desc = ldesc
		connected.last_occupant_name = connected.occupant.name

	return broken_desc

/obj/machinery/body_scanconsole/Initialize()
	. = ..()
	for(var/obj/machinery/bodyscanner/C in orange(1,src))
		connected = C
		break
	if(connected)
		connected.connected = src
	update_icon()

/obj/machinery/body_scanconsole/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(var/mob/user)
	if(..())
		return

	ui_interact(user)

/obj/machinery/body_scanconsole/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		// shouldn't be reachable if occupant is invalid
		if("print")
			var/obj/item/paper/medscan/R = new(loc)
			R.color = "#eeffe8"
			R.set_content_unsafe("Scan ([connected.occupant])", format_occupant_data(connected.get_occupant_data()))

			print(R, message = "\The [src] beeps, printing \the [R] after a moment.")

		if("eject")
			if(connected)
				connected.eject()

/obj/machinery/body_scanconsole/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BodyScanner", "Zeng-Hu Pharmaceuticals Body Scanner", 1200, 800)
		ui.open()

/obj/machinery/body_scanconsole/ui_data(mob/user)
	var/list/data = list(
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
		"thetaAmt" = null,
		"otherAmt" = null,
		"bodyparts" = list(),
		"organs" = list(),
		"missingparts" = list(),
		"hasmissing" = null
	)

	var/mob/living/carbon/human/occupant
	if (connected)
		occupant = connected.occupant

		data["noscan"] = !!connected.check_species()
		data["nocons"] = !connected
		data["occupied"] = !!connected.occupant
		data["invalid"] = !!connected.check_species()
		data["ipc"] = occupant && isipc(occupant)

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

		var/displayed_stat = occupant.stat
		var/blood_oxygenation = occupant.get_blood_oxygenation()
		if(occupant.status_flags & FAKEDEATH)
			displayed_stat = DEAD
			blood_oxygenation = min(blood_oxygenation, BLOOD_VOLUME_SURVIVE)
		data["stat"] = displayed_stat
		data["name"] = occupant.name
		data["species"] = occupant.get_species()
		data["brain_activity"] = brain_result
		data["pulse"] = text2num(pulse_result)
		data["blood_pressure"] = occupant.get_blood_pressure()
		data["blood_pressure_level"] = occupant.get_blood_pressure_alert()
		data["blood_volume"] = occupant.get_blood_volume()
		data["blood_o2"] = blood_oxygenation
		data["rads"] = occupant.total_radiation

		data["cloneLoss"] = get_severity(occupant.getCloneLoss(), TRUE)
		data["oxyLoss"] = get_severity(occupant.getOxyLoss(), TRUE)
		data["bruteLoss"] = get_severity(occupant.getBruteLoss(), TRUE)
		data["fireLoss"] = get_severity(occupant.getFireLoss(), TRUE)
		data["toxLoss"] = get_severity(occupant.getToxLoss(), TRUE)

		data["paralysis"] = occupant.paralysis
		data["bodytemp"] = round(occupant.bodytemperature - T0C)
		data["inaprovaline_amount"] = REAGENT_VOLUME(R, /singleton/reagent/inaprovaline)
		data["soporific_amount"] = REAGENT_VOLUME(R, /singleton/reagent/soporific)
		data["bicaridine_amount"] = REAGENT_VOLUME(R, /singleton/reagent/bicaridine)
		data["dexalin_amount"] = REAGENT_VOLUME(R, /singleton/reagent/dexalin)
		data["dermaline_amount"] = REAGENT_VOLUME(R, /singleton/reagent/dermaline)
		data["thetamycin_amount"] = REAGENT_VOLUME(R, /singleton/reagent/thetamycin)
		data["other_amount"] = R.total_volume - (data["inaprovaline_amount"] + data["soporific_amount"] + data["bicaridine_amount"] + data["dexalin_amount"] + data["dermaline_amount"] + data["thetamycin_amount"])
		has_internal_injuries = FALSE
		has_external_injuries = FALSE
		data["bodyparts"] = get_external_wound_data(occupant)
		data["organs"] = get_internal_wound_data(occupant)
		data["has_internal_injuries"] = has_internal_injuries
		data["has_external_injuries"] = has_external_injuries
		var/list/missing = get_missing_organs(occupant)
		data["missing_organs"] = missing
	return data

/obj/machinery/body_scanconsole/proc/get_internal_damage(var/obj/item/organ/internal/I)
	if(istype(I, /obj/item/organ/internal/parasite))
		var/obj/item/organ/internal/parasite/P = I
		switch(P.stage)
			if(1)
				return "Tiny"
			if(2)
				return "Small"
			if(3)
				return "Large"
			if(4)
				return "Massive"
			else
				return "Present"
	if(I.is_broken())
		return "Severe"
	if(I.is_bruised())
		return "Moderate"
	if(I.is_damaged())
		return "Minor"
	return "None"

/obj/machinery/body_scanconsole/proc/get_missing_organs(var/mob/living/carbon/human/H)
	var/list/missingOrgans = list()
	var/list/species_organs = H.species.has_organ
	for (var/organ_name in H.species.has_organ)
		if (!locate(species_organs[organ_name]) in H.internal_organs)
			missingOrgans += organ_name
	return capitalize(english_list(missingOrgans))

/obj/machinery/body_scanconsole/proc/get_external_wound_data(var/mob/living/carbon/human/H)
	// Limbs.
	var/organs = list()
	for (var/obj/item/organ/external/O in H.organs)
		var/list/data = list()
		data["name"] = capitalize_first_letters(O.name)
		var/burn_damage = get_severity(O.burn_dam, TRUE)
		data["burn_damage"] = burn_damage
		var/brute_damage = get_severity(O.brute_dam, TRUE)
		data["brute_damage"] = brute_damage

		var/list/wounds = list()

		if (O.status & ORGAN_ROBOT)
			wounds += "appears to be composed of inorganic material"
		if (O.status & ORGAN_ARTERY_CUT)
			wounds += "severed [O.artery_name]"
		if (O.tendon_status() & TENDON_CUT)
			wounds += "severed [O.tendon.name]"
		if (O.status & ORGAN_SPLINTED)
			wounds += "splinted"
		if (O.status & ORGAN_BLEEDING)
			wounds += "bleeding"
		if(ORGAN_IS_DISLOCATED(O))
			wounds += "dislocated"
		if (O.status & ORGAN_BROKEN)
			wounds += "[O.broken_description]"
		if (O.open)
			wounds += "has an open wound"
		if (O.germ_level)
			var/level = get_infection_level(O.germ_level)
			if (level && level != "")
				wounds += "shows symptoms of \a [level] infection"
		if (O.rejecting)
			wounds += "shows symptoms indicating limb rejection"

		if (O.implants.len)
			var/unk = 0
			var/list/organic = list()
			for (var/atom/movable/I in O.implants)
				if(is_type_in_list(I, known_implants))
					wounds += "\a [I.name] is installed"
				else if(istype(I, /obj/effect/spider))
					organic += I
				else
					unk += 1
			if (unk)
				wounds += "has unknown objects present"
			var/friends = length(organic)
			if(friends)
				wounds += friends > 1 ? "multiple abnormal organic bodies present" : "abnormal organic body present"

		if(length(wounds) || brute_damage != "None" || burn_damage != "None")
			has_external_injuries = TRUE

		data["wounds"] = capitalize(english_list(wounds, "None"))
		organs += list(data)

	return organs

/obj/machinery/body_scanconsole/proc/get_internal_wound_data(var/mob/living/carbon/human/H)
	var/list/organs = list()
	// Internal Organs. (Duh.)
	for (var/obj/item/organ/internal/O in H.internal_organs)
		var/list/data = list()
		data["name"] = capitalize_first_letters(O.name)
		data["location"] = capitalize_first_letters(parse_zone(O.parent_organ))
		var/list/wounds = list()
		var/internal_damage = get_internal_damage(O)
		if(istype(O, /obj/item/organ/internal/brain))
			if(H.status_flags & FAKEDEATH)
				internal_damage = "Severe" // fake some brain damage
				if(!(O.status & ORGAN_DEAD)) // to prevent this wound from appearing twice
					wounds += "Necrotic and decaying."
			if(H.has_brain_worms())
				wounds += "Has an abnormal growth."
		data["damage"] = internal_damage
		if(istype(O, /obj/item/organ/internal/lungs))
			var/obj/item/organ/internal/lungs/L = O
			if(L.is_broken())
				wounds += get_broken_lung_desc()
			else if(L.is_bruised())
				wounds += get_collapsed_lung_desc()
			if(L.rescued)
				wounds += "has a small puncture wound"

		if(O.status & ORGAN_DEAD)
			wounds += "necrotic and decaying"

		if(istype(O, H.species.vision_organ))
			if(H.sdisabilities & BLIND)
				wounds += "appears to have cataracts"
			else if(H.disabilities & NEARSIGHTED)
				wounds += "appears to have misaligned retinas"

		if(O.germ_level)
			var/level = get_infection_level(O.germ_level)
			if (level && level != "")
				wounds += "shows symptoms of \a [level] infection"

		if(O.rejecting)
			wounds += "shows symptoms of organ rejection"

		if(O.get_scarring_level() > 0.01)
			wounds += "[O.get_scarring_results()]"

		if(length(wounds) || internal_damage != "None")
			has_internal_injuries = TRUE

		data["wounds"] = english_list(wounds, "None")

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
		"bodytemp" = H.bodytemperature - T0C,
		"borer_present" = H.has_brain_worms(),
		"inaprovaline_amount" = REAGENT_VOLUME(H.reagents, /singleton/reagent/inaprovaline),
		"dexalin_amount" = REAGENT_VOLUME(H.reagents, /singleton/reagent/dexalin),
		"soporific_amount" = REAGENT_VOLUME(H.reagents, /singleton/reagent/soporific),
		"bicaridine_amount" = REAGENT_VOLUME(H.reagents, /singleton/reagent/bicaridine),
		"dermaline_amount" = REAGENT_VOLUME(H.reagents, /singleton/reagent/dermaline),
		"thetamycin_amount" = REAGENT_VOLUME(H.reagents, /singleton/reagent/thetamycin),
		"blood_amount" = REAGENT_VOLUME(H.vessel, /singleton/reagent/blood),
		"disabilities" = H.sdisabilities,
		"lung_ruptured" = H.is_lung_ruptured(),
		"lung_rescued" = H.is_lung_rescued(),
		"external_organs" = H.organs.Copy(),
		"internal_organs" = H.internal_organs.Copy(),
		"species_organs" = H.species.has_organ //Just pass a reference for this, it shouldn't ever be modified outside of the datum.
		)
	return occupant_data


/obj/machinery/body_scanconsole/proc/format_occupant_data(var/list/occ)
	var/dat = "<span class='notice'><b>Scan performed at [occ["stationtime"]]</b></span><br>"
	dat += "<span class='notice'><b>Occupant Statistics:</b></span><br>"
	dat += text("Brain Activity: []<br>", occ["brain_activity"])
	dat += text("Blood Pressure: []<br>", occ["blood_pressure"])
	dat += text("Blood Oxygenation: []%<br>", occ["blood_oxygenation"])
	dat += text("Blood Volume: []%<br>", occ["blood_volume"])
	dat += text("Physical Trauma: []<br>", occ["bruteloss"])
	dat += text("Oxygen Deprivation: []<br>", occ["oxyloss"])
	dat += text("Systemic Organ Failure: []<br>", occ["toxloss"])
	dat += text("Burn Severity: []<br><br>", occ["fireloss"])

	dat += text("[]\tRadiation Level %: []</font><br>", ("<font color='[occ["rads"] < 10  ? "blue" : "red"]'>"), occ["rads"])
	dat += text("Genetic Tissue Damage: []<br>", occ["cloneloss"])
	dat += text("Paralysis Summary %: [] ([] seconds left!)<br>", occ["paralysis"], round(occ["paralysis"] / 4))
	dat += text("Body Temperature: [occ["bodytemp"]]&deg;C<br><HR>")

	if(occ["borer_present"])
		dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<br>"

	dat += text("Inaprovaline: [] units<BR>", occ["inaprovaline_amount"])
	dat += text("Soporific: [] units<BR>", occ["soporific_amount"])
	dat += text("[]\tDermaline: [] units</FONT><BR>", ("<font color='[occ["dermaline_amount"] < 20  ? "black" : "red"]'>"), occ["dermaline_amount"])
	dat += text("[]\tBicaridine: [] units</font><BR>", ("<font color='[occ["bicaridine_amount"] < 20  ? "black" : "red"]'>"), occ["bicaridine_amount"])
	dat += text("[]\tDexalin: [] units</font><BR>", ("<font color='[occ["dexalin_amount"] < 20  ? "black" : "red"]'>"), occ["dexalin_amount"])
	dat += text("[]\tThetamycin: [] units</font><BR>", ("<font color='[occ["thetamycin_amount"] < 20 ? "black" : "red"]'>"), occ["thetamycin_amount"])

	dat += "<HR><table border='1'>"
	dat += "<tr>"
	dat += "<th>Organ</th>"
	dat += "<th>Burn Severity</th>"
	dat += "<th>Physical Trauma</th>"
	dat += "<th>Other Wounds</th>"
	dat += "</tr>"

	for(var/obj/item/organ/external/e in occ["external_organs"])
		var/list/wounds = list()

		dat += "<tr>"

		if(e.status & ORGAN_ARTERY_CUT)
			wounds += "severed [e.artery_name]"
		if(e.tendon_status() & TENDON_CUT)
			wounds += "severed [e.tendon.name]"
		if(istype(e, /obj/item/organ/external/chest) && occ["lung_ruptured"])
			wounds += "lung ruptured"
		if(e.status & ORGAN_SPLINTED)
			wounds += "splinted"
		if(ORGAN_IS_DISLOCATED(e))
			wounds += "dislocated"
		if(e.status & ORGAN_BLEEDING)
			wounds += "bleeding"
		if(e.status & ORGAN_BROKEN)
			wounds += "[e.broken_description]"
		if(e.status & ORGAN_ROBOT)
			wounds += "prosthetic"
		if(e.open)
			wounds += "open"

		var/infection = get_infection_level(e.germ_level)
		if (infection != "")
			var/infected = "[infection] infection"
			if(e.rejecting)
				infected += " (being rejected)"
			wounds += infection

		if (e.implants.len)
			var/unk = 0
			var/list/organic = list()
			for(var/atom/movable/I in e.implants)
				if(is_type_in_list(I, known_implants))
					wounds += "\a [I.name] implanted:"
				else if(istype(I, /obj/effect/spider))
					organic += I
				else
					unk += 1
			if(unk)
				wounds += "has unknown objects present:"
			var/friends = length(organic)
			if(friends)
				wounds += friends > 1 ? "multiple abnormal organic bodies present" : "abnormal organic body present"
		if(!length(wounds))
			wounds += "none"
		if(!e.is_stump())
			dat += "<td>[e.name]</td><td>[get_severity(e.burn_dam, TRUE)]</td><td>[get_severity(e.brute_dam, TRUE)]</td><td>[capitalize(english_list(wounds))]</td>"
		else
			dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not [e.is_stump() ? "Found" : "Attached Completely"]</td>"
		dat += "</tr>"

	for(var/obj/item/organ/internal/i in occ["internal_organs"])

		var/mech = ""
		if(i.robotic == ROBOTIC_ASSISTED)
			mech = "Assisted:"
		if(i.robotic == ROBOTIC_MECHANICAL)
			mech = "Mechanical:"

		var/infection = get_infection_level(i.germ_level)
		if(infection == "")
			infection = "No infection."
		else
			infection = "[infection] infection."
		if(i.rejecting)
			infection += "(being rejected)."

		var/necrotic = ""
		if(i.get_scarring_level() > 0.01)
			necrotic += " [i.get_scarring_results()]."
		if(i.status & ORGAN_DEAD)
			necrotic = " <span class='warning'>Necrotic and decaying</span>."

		var/rescued = ""
		if(istype(i, /obj/item/organ/internal/lungs) && occ["lung_rescued"])
			rescued = " Has a small puncture wound."

		dat += "<tr>"
		dat += "<td>[i.name]</td><td>N/A</td><td>[get_internal_damage(i)]</td><td>[infection][mech][necrotic][rescued]</td><td></td>"
		dat += "</tr>"
	dat += "</table>"

	var/list/species_organs = occ["species_organs"]
	for(var/organ_name in species_organs)
		if(!locate(species_organs[organ_name]) in occ["internal_organs"])
			dat += text("<span class='warning'>No [organ_name] detected.</span><BR>")

	if(occ["sdisabilities"] & BLIND)
		dat += text("<span class='warning'>Cataracts detected.</span><BR>")
	if(occ["sdisabilities"] & NEARSIGHTED)
		dat += text("<font color='red'>Retinal misalignment detected.</font><BR>")
	return dat
