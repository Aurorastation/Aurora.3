/obj/machinery/bodyscanner
	name = "body scanner"
	desc = "A state-of-the-art medical diagnostics machine. Guaranteed detection of all your bodily ailments or your money back!"
	desc_info = "The advanced scanner detects and reports internal injuries such as bone fractures, internal bleeding, and organ damage. \
	This is useful if you are about to perform surgery.<br>\
	<br>\
	Click your target with Grab intent, then click on the scanner to place them in it. Click the connected terminal to operate. \
	Right-click the scanner and click 'Eject Occupant' to remove them.  You can enter the scanner yourself in a similar way, using the 'Enter Body Scanner' \
	verb."
	icon = 'icons/obj/machinery/sleeper.dmi'
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
		SPECIES_VAURCA_ATTENDANT,
		SPECIES_VAURCA_BREEDER,
		SPECIES_VAURCA_BULWARK,
		SPECIES_DIONA,
		SPECIES_DIONA_COEUS,
		SPECIES_MONKEY
	)

/obj/machinery/bodyscanner/Initialize()
	. = ..()
	for(var/obj/machinery/body_scanconsole/C in orange(1,src))
		connected = C
		break
	if(connected)
		connected.connected = src
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

/obj/machinery/bodyscanner/relaymove(mob/living/user, direction)
	. = ..()

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

	playsound(loc, 'sound/machines/compbeep2.ogg', 25)
	playsound(loc, 'sound/machines/cryopod/cryopod_exit.ogg', 25)

	last_occupant_name = occupant.name
	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	update_use_power(POWER_USE_IDLE)
	update_icon()
	return

/obj/machinery/bodyscanner/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/grab/G = attacking_item
	if (!istype(G, /obj/item/grab) || !isliving(G.affecting) )
		return
	if (occupant)
		to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
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

/obj/machinery/bodyscanner/mouse_drop_receive(atom/dropped, mob/user, params)
	if(!istype(user))
		return

	if(!ismob(dropped))
		return

	if (occupant)
		to_chat(user, SPAN_NOTICE("<B>The scanner is already occupied!</B>"))
		return

	var/mob/living/L = dropped
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
		if (L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
		L.forceMove(src)
		occupant = L
		update_use_power(POWER_USE_ACTIVE)
		update_icon()
		playsound(loc, 'sound/machines/cryopod/cryopod_enter.ogg', 25)
		playsound(loc, 'sound/machines/medbayscanner1.ogg', 25)
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
	var/tgui_name = "Zeng-Hu Pharmaceuticals Body Scanner"
	desc = "An advanced control panel that can be used to interface with a connected body scanner."
	icon = 'icons/obj/machinery/sleeper.dmi'
	icon_state = "body_scannerconsole"
	var/obj/machinery/bodyscanner/connected
	var/collapse_desc = ""
	var/broken_desc = ""
	var/has_internal_injuries = FALSE
	var/has_external_injuries = FALSE
	density = FALSE
	anchored = TRUE
	z_flags = ZMM_MANGLE_PLANES
	component_types = list(
			/obj/item/circuitboard/bodyscannerconsole,
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/stock_parts/console_screen
		)
	var/global/image/console_overlay
	var/list/connected_displays = list()
	var/list/data = list()
	var/scan_data

	var/has_detailed_view = TRUE
	var/has_print_and_eject = TRUE
	var/no_scan_message = "No diagnostics profile installed for this species."

/obj/machinery/body_scanconsole/Destroy()
	if (connected)
		connected.connected = null
		connected = null
	for(var/D in connected_displays)
		remove_display(D)
	return ..()

/obj/machinery/body_scanconsole/power_change()
	..()
	update_icon()

/obj/machinery/body_scanconsole/update_icon()
	ClearOverlays()
	if((stat & BROKEN) || (stat & NOPOWER))
		return
	else
		if(!console_overlay)
			console_overlay = image(icon, "body_scannerconsole-screen")
		var/emissive_overlay = emissive_appearance(icon, "body_scannerconsole-screen")
		AddOverlays(console_overlay)
		AddOverlays(emissive_overlay)
		set_light(1.4, 1, COLOR_PURPLE)

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
			var/obj/item/paper/medscan/R = new /obj/item/paper/medscan(src, format_occupant_data(connected.get_occupant_data()), "Scan ([connected.occupant]) ([worldtime2text()])", connected.occupant)
			print(R, message = "\The [src] beeps, printing \the [R] after a moment.", user = usr)

		if("eject")
			if(connected)
				connected.eject()

/obj/machinery/body_scanconsole/proc/FindDisplays()
	for(var/obj/machinery/computer/operating/D in SSmachinery.machinery)
		if (AreConnectedZLevels(D.z, z))
			connected_displays += D
			RegisterSignal(D, COMSIG_QDELETING, PROC_REF(on_connected_display_deletion))
	return !!length(connected_displays)

/obj/machinery/body_scanconsole/ui_interact(mob/user, var/datum/tgui/ui)
	if(!get_connected())
		to_chat(usr, SPAN_WARNING("[icon2html(src, usr)]Error: No body scanner detected."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BodyScanner", tgui_name, 850, 500)
		ui.open()

/obj/machinery/body_scanconsole/proc/on_connected_display_deletion(datum/source)
	SIGNAL_HANDLER

	remove_display(source)

/obj/machinery/body_scanconsole/proc/remove_display(datum/source, obj/machinery/computer/operating/display)
	connected_displays -= display
	UnregisterSignal(display, COMSIG_QDELETING)

/obj/machinery/body_scanconsole/proc/get_connected()
	if(connected)
		return connected
	return null

/obj/machinery/body_scanconsole/proc/get_occupant()
	if(connected)
		return connected.occupant
	return null

/obj/machinery/body_scanconsole/proc/check_species()
	if(connected)
		return connected.check_species()
	return FALSE

/obj/machinery/body_scanconsole/ui_data(mob/user)
	var/list/data = list(
		"noscan" = null,
		"nocons" = null,
		"occupied" = null,
		"invalid" = TRUE,
		"ipc" = null,
		"stationtime" = null,
		"stat" = null,
		"name" = null,
		"species" = null,
		"brain_activity" = null,
		"pulse" = null,
		"blood_pressure" = null,
		"blood_pressure_level" = null,
		"blood_volume" = null,
		"blood_o2" = null,
		"blood_type" = null,
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
		"hasmissing" = null,
		"has_detailed_view" = has_detailed_view,
		"has_print_and_eject" = has_print_and_eject,
		"no_scan_message" = no_scan_message
	)

	var/mob/living/carbon/human/occupant = get_occupant()
	if(occupant)
		data["noscan"] = !!check_species()
		data["nocons"] = !get_connected()
		data["occupied"] = !!occupant
		data["invalid"] = !!check_species()
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

		data["stationtime"] = worldtime2text()
		data["stat"] = displayed_stat
		data["name"] = occupant.name
		data["species"] = occupant.get_species()
		data["brain_activity"] = brain_result
		data["pulse"] = text2num(pulse_result)
		data["blood_pressure"] = occupant.get_blood_pressure()
		data["blood_pressure_level"] = occupant.get_blood_pressure_alert()
		data["blood_volume"] = occupant.get_blood_volume()
		data["blood_o2"] = blood_oxygenation
		data["blood_type"] = occupant.dna.b_type
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
		var/list/missing_limbs = get_missing_limbs(occupant)
		data["missing_limbs"] = missing_limbs
		var/list/missing_organs = get_missing_organs(occupant)
		data["missing_organs"] = missing_organs
	return data

/obj/machinery/body_scanconsole/proc/get_internal_damage(var/obj/item/organ/internal/I)
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

/obj/machinery/body_scanconsole/proc/get_missing_limbs(var/mob/living/carbon/human/H)
	var/list/missingLimbs = list()
	var/list/species_limbs = H.species.has_limbs
	for(var/limb_tag in species_limbs)
		var/obj/item/organ/external/E = H.get_organ(limb_tag)
		if(!locate(E) in H.organs)
			var/list/organ_data = species_limbs[limb_tag]
			var/organ_descriptor = organ_data["descriptor"]
			missingLimbs += organ_descriptor
	return capitalize(english_list(missingLimbs))

/obj/machinery/body_scanconsole/proc/get_external_wound_data(var/mob/living/carbon/human/H)
	// Limbs.
	var/organs = list()
	for(var/obj/item/organ/external/O in H.organs)
		var/list/data = list()
		data["name"] = capitalize_first_letters(O.name)
		var/burn_damage = get_severity(O.burn_dam, TRUE)
		data["burn_damage"] = burn_damage
		var/brute_damage = get_severity(O.brute_dam, TRUE)
		data["brute_damage"] = brute_damage

		var/list/wounds = list()

		if(O.status & ORGAN_ROBOT)
			wounds += "inorganic"
		if(O.status & ORGAN_ARTERY_CUT)
			wounds += "severed [O.artery_name]"
		if(O.tendon_status() & TENDON_CUT)
			wounds += "severed [O.tendon.name]"
		if(O.status & ORGAN_SPLINTED)
			wounds += "splinted"
		if(O.status & ORGAN_BLEEDING)
			wounds += "bleeding"
		if(ORGAN_IS_DISLOCATED(O))
			wounds += "dislocated"
		if(O.status & ORGAN_BROKEN)
			wounds += "[O.broken_description]"
		if(O.open)
			wounds += "open incision"

		var/list/infection = list()
		if(O.germ_level)
			var/level = get_infection_level(O.germ_level)
			if (level && level != "")
				infection += "[level]"
		if(O.rejecting)
			infection += "rejection"

		if(length(O.implants))
			var/unk = 0
			var/list/organic = list()

			for(var/atom/movable/object_in_organ in O.implants)
				//Handle actual implants
				if(istype(object_in_organ, /obj/item/implant))
					var/obj/item/implant/implant_in_organ = object_in_organ
					//If the implant is hidden, skip it, no report in the scan
					if(implant_in_organ.hidden)
						continue

					//If it's a known implant, report it with its full name
					if(implant_in_organ.known)
						wounds += "[implant_in_organ.name] installed"
					//Otherwise, just let the player know there's something unknown there and call it a day
					else
						unk += 1

					//We did our job with implants, continue
					continue

				//Ok, implants fucked off above thanks to the continue, handle gremorian eggs now, they report as organics
				//and whatever else is present, is unknown
				if(istype(object_in_organ, /obj/effect/spider))
					organic += object_in_organ
				else
					unk += 1

			//If we found unknown objects, report them as such
			if(unk)
				wounds += "[unk] unknown object(s) present"

			//If we found organic things present, report them as one or many
			if(length(organic))
				wounds += length(organic) > 1 ? "multiple abnormal organic bodies" : "abnormal organic body"


		if(length(wounds) || brute_damage != "None" || burn_damage != "None")
			has_external_injuries = TRUE

		data["wounds"] = capitalize(english_list(wounds, "None"))
		data["infection"] = capitalize(english_list(infection, "None"))
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
					wounds += "necrotic; dead"
			if(H.has_brain_worms())
				wounds += "abnormal growth"
		data["damage"] = internal_damage
		if(O.is_broken())
			wounds += "broken"
		else if(O.is_bruised())
			wounds += "bruised"
		if(istype(O, /obj/item/organ/internal/lungs))
			var/obj/item/organ/internal/lungs/L = O
			if(L.rescued)
				wounds += "punctured"

		if(istype(O, /obj/item/organ/internal/appendix))
			var/obj/item/organ/internal/appendix/A = O
			if(A.inflamed)
				wounds += "inflamed"

		if(istype(O, /obj/item/organ/internal/parasite))
			var/obj/item/organ/internal/parasite/P = O
			if(P.stage)
				wounds += "stage [P.stage]"
			if(P.parent_organ)
				wounds += "growing in [P.parent_organ]"
			if(istype(P, /obj/item/organ/internal/parasite/malignant_tumour) && P.stage >= 4)
				wounds += "metastasising"

		if(O.status & ORGAN_DEAD)
			if(O.can_recover())
				wounds += "necrotic; debridable"
			else
				wounds += "necrotic; dead"

		if(istype(O, H.species.vision_organ))
			if(H.sdisabilities & BLIND)
				wounds += "has cataracts"
			else if(H.disabilities & NEARSIGHTED)
				wounds += "has misaligned retinas"

		var/list/infection  = list()
		if(O.germ_level)
			var/level = get_infection_level(O.germ_level)
			if (level && level != "")
				infection += "[level]"

		if(O.rejecting)
			infection += "rejection"

		if(O.get_scarring_level() > 0.01)
			wounds += "[O.get_scarring_results()]"

		if(length(wounds) || internal_damage != "None" || length(infection))
			has_internal_injuries = TRUE

		if(!length(infection))
			infection += "healthy"

		data["wounds"] = capitalize(english_list(wounds, "None"))
		data["infection"] = capitalize(english_list(infection, "None"))
		organs += list(data)
	return organs

/obj/machinery/body_scanconsole/proc/get_infection_level(var/level)
	switch (level)
		if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
			return "Sepsis"
		if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
			return "Worsening Sepsis"
		if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
			return "Borderline Severe Sepsis"
		if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
			return "Severe Sepsis"
		if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
			return "Worsening Severe Sepsis"
		if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_TWO + 400)
			return "Borderline Septic Shock"
		if (INFECTION_LEVEL_THREE to INFINITY)
			return "Septic Shock"

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

	var/displayed_stat = H.stat
	var/blood_oxygenation = H.get_blood_oxygenation()
	if(H.status_flags & FAKEDEATH)
		displayed_stat = DEAD
		blood_oxygenation = min(blood_oxygenation, BLOOD_VOLUME_SURVIVE)
	switch(displayed_stat)
		if(CONSCIOUS)
			displayed_stat = "Conscious"
		if(UNCONSCIOUS)
			displayed_stat = "Unconscious"
		if(DEAD)
			displayed_stat = "DEAD"

	var/pulse_result
	if(H.should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
		if(!heart)
			pulse_result = 0
		else if(BP_IS_ROBOTIC(heart))
			pulse_result = -2
		else if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
	else
		pulse_result = -1

	if(pulse_result == ">250")
		pulse_result = -3

	var/datum/reagents/R = H.bloodstr

	connected.has_internal_injuries = FALSE
	connected.has_external_injuries = FALSE
	var/list/bodyparts = connected.get_external_wound_data(H)
	var/list/organs = connected.get_internal_wound_data(H)

	var/list/occupant_data = list(
		"stationtime" = worldtime2text(),
		"stat" = displayed_stat,
		"name" = H.name,
		"species" = H.get_species(),

		"brain_activity" = H.get_brain_status(),
		"pulse" = text2num(pulse_result),
		"blood_volume" = H.get_blood_volume(),
		"blood_oxygenation" = H.get_blood_oxygenation(),
		"blood_pressure" = H.get_blood_pressure(),
		"blood_type" = H.dna.b_type,

		"bruteloss" = get_severity(H.getBruteLoss(), TRUE),
		"fireloss" = get_severity(H.getFireLoss(), TRUE),
		"oxyloss" = get_severity(H.getOxyLoss(), TRUE),
		"toxloss" = get_severity(H.getToxLoss(), TRUE),
		"cloneloss" = get_severity(H.getCloneLoss(), TRUE),

		"rads" = H.total_radiation,
		"paralysis" = H.paralysis,
		"bodytemp" = H.bodytemperature,
		"borer_present" = H.has_brain_worms(),
		"inaprovaline_amount" = REAGENT_VOLUME(R, /singleton/reagent/inaprovaline),
		"dexalin_amount" = REAGENT_VOLUME(R, /singleton/reagent/dexalin),
		"soporific_amount" = REAGENT_VOLUME(R, /singleton/reagent/soporific),
		"bicaridine_amount" = REAGENT_VOLUME(R, /singleton/reagent/bicaridine),
		"dermaline_amount" = REAGENT_VOLUME(R, /singleton/reagent/dermaline),
		"thetamycin_amount" = REAGENT_VOLUME(R, /singleton/reagent/thetamycin),
		"other_amount" = R.total_volume - (REAGENT_VOLUME(R, /singleton/reagent/inaprovaline) + REAGENT_VOLUME(R, /singleton/reagent/soporific) + REAGENT_VOLUME(R, /singleton/reagent/bicaridine) + REAGENT_VOLUME(R, /singleton/reagent/dexalin) + REAGENT_VOLUME(R, /singleton/reagent/dermaline) + REAGENT_VOLUME(R, /singleton/reagent/thetamycin)),
		"bodyparts" = bodyparts,
		"organs" = organs,
		"has_internal_injuries" = connected.has_internal_injuries,
		"has_external_injuries" = connected.has_external_injuries,
		"missing_limbs" = connected.get_missing_limbs(H),
		"missing_organs" = connected.get_missing_organs(H)
		)
	return occupant_data


/obj/machinery/body_scanconsole/proc/format_occupant_data(var/list/occ)
	var/dat = "<font face=\"Courier New\"><font size=\"1\">Scan performed at [occ["stationtime"]]</font></font><br>"
	dat += "<font face=\"Verdana\">"
	dat += "<b>Patient Status</b><br><HR>"
	dat += "<font size=\"1\">"
	dat += "Name: 					[occ["name"]]<br>"
	dat += "Status: 				[occ["stat"]]<br>"
	dat += "Species: 				[occ["species"]]<br>"
	dat += "Pulse: 				[occ["pulse"]] BPM<br>"
	dat += "Brain Activity:		[occ["brain_activity"]]<br>"
	dat += "Body Temperature: 		[(occ["bodytemp"] - T0C)]&deg;C "
	dat += "([(occ["bodytemp"]*1.8-459.67)]&deg;F)<br>"

	dat += "<b><br>Blood Status</b><br><HR>"
	dat += "Blood Pressure:		[occ["blood_pressure"]]<br>"
	dat += "Blood Oxygenation: 	[occ["blood_oxygenation"]]%<br>"
	dat += "Blood Volume: 			[occ["blood_volume"]]%<br>"
	dat += "Blood Type: 			[occ["blood_type"]]<br>"

	if(occ["inaprovaline_amount"])
		dat += "Inaprovaline: 		[occ["inaprovaline_amount"]] units<BR>"
	if(occ["soporific_amount"])
		dat += "Soporific: 		[occ["soporific_amount"]] units<BR>"
	if(occ["dermaline_amount"])
		dat += "[("<font color='[occ["dermaline_amount"] < 20  ? "black" : "red"]'>")]\tDermaline: 	[occ["dermaline_amount"]] units</font><BR>"
	if(occ["bicaridine_amount"])
		dat += "[("<font color='[occ["bicaridine_amount"] < 20  ? "black" : "red"]'>")]\tBicaridine: 	[occ["bicaridine_amount"]] units</font><BR>"
	if(occ["dexalin_amount"])
		dat += "[("<font color='[occ["dexalin_amount"] < 20  ? "black" : "red"]'>")]\tDexalin: 		[occ["dexalin_amount"]] units</font><BR>"
	if(occ["thetamycin_amount"])
		dat += "[("<font color='[occ["thetamycin_amount"] < 20 ? "black" : "red"]'>")]\tThetamycin: 	[occ["thetamycin_amount"]] units</font><BR>"
	if(occ["other_amount"])
		dat += "Other:				[occ["other_amount"]] units<BR>"

	dat += "<b><br>Symptom Status</b><br><HR>"
	dat += "Radiation Level:  [round(occ["rads"])] Gy<br>"
	dat += "Genetic Damage:   [occ["cloneloss"]]<br>"
	if(occ["paralysis"])
		dat += "Est Paralysis Level:	[round(occ["paralysis"] / 4)] Seconds Left<br>"
	else
		dat += "Est Paralysis Level:	None<br>"

	dat += "<b><br>Damage Status</b><br><HR>"
	dat += "Brute Trauma:       [occ["bruteloss"]]<br>"
	dat += "Burn Severity:      [occ["fireloss"]]<br>"
	dat += "Oxygen Deprivation: [occ["oxyloss"]]<br>"
	dat += "Toxin Exposure:     [occ["toxloss"]]<br>"

	dat += "<br><b>Body Status</b><HR>"

	if(occ["has_external_injuries"])
		dat += "<table border='1'>"
		dat += "<tr>"
		dat += "<th>Name</th>"
		dat += "<th>Brute</th>"
		dat += "<th>Burn</th>"
		dat += "<th>Complications</th>"
		dat += "<th>Immune</th>"
		dat += "</tr>"
		for(var/list/data in occ["bodyparts"]) // cant believe this shit worked HOLY FUCK

			dat += "<tr>"
			dat += "<td>[data["name"]]</td><td>[data["brute_damage"]]</td><td>[data["burn_damage"]]</td><td>[data["wounds"]]</td><td>[data["infection"]]</td>"
			dat += "</tr>"

	if(!has_external_injuries)
		dat += "No external injuries detected.<br>"
	else
		dat += "</table>"

	if(occ["missing_limbs"] != "Nothing")
		dat += SPAN_WARNING("Missing limbs : [occ["missing_limbs"]]<BR>")

	dat += "<br><b>Internal Organ Status<HR></b>"

	if(occ["has_internal_injuries"])
		dat += "<table border='1'>"
		dat += "<tr>"
		dat += "<th>Name</th>"
		dat += "<th>Damage</th>"
		dat += "<th>Complications</th>"
		dat += "<th>Immune</th>"
		dat += "</tr>"
		for(var/list/data in occ["organs"]) // cant believe this shit worked HOLY FUCK

			dat += "<tr>"
			dat += "<td>[data["name"]]</td><td>[data["damage"]]</td><td>[data["wounds"]]</td><td>[data["infection"]]</td>"
			dat += "</tr>"

	if(!has_internal_injuries)
		dat += "No internal injuries detected.<br>"
	else
		dat += "</table>"

	if(occ["missing_organs"] != "Nothing")
		dat += SPAN_WARNING("Missing organs : [occ["missing_organs"]]<BR>")

	dat += "</font></font>"

	return dat

/// an embedded bodyscanner belonging to a patient monitoring console
/obj/machinery/body_scanconsole/embedded
	name = "embedded bodyscanner"
	tgui_name = "Zeng-Hu Pharmaceuticals Surgical Theater"
	has_detailed_view = FALSE
	has_print_and_eject = FALSE
	no_scan_message = "No matching body scanner primer has been added to the monitoring console."

	var/obj/machinery/computer/operating/monitor_console

/obj/machinery/body_scanconsole/embedded/Initialize(mapload, d = 0, populate_components = TRUE, is_internal = FALSE)
	. = ..()
	monitor_console = loc

/obj/machinery/body_scanconsole/embedded/Destroy()
	monitor_console = null
	return ..()

/obj/machinery/body_scanconsole/embedded/ui_state(mob/user)
	return GLOB.human_adjacent_loc_state

/obj/machinery/body_scanconsole/embedded/get_connected()
	if(monitor_console)
		return monitor_console
	return null

/obj/machinery/body_scanconsole/embedded/get_occupant()
	if(monitor_console?.table)

		if(istype(monitor_console.table.occupant, /datum/weakref))
			return monitor_console.table.occupant.resolve()
		else
			return monitor_console.table.occupant

	return null

// if our primer has a scan target, that means it was validated by a bodyscanner
/obj/machinery/body_scanconsole/embedded/check_species()
	var/atom/occupant = get_occupant()
	if(!occupant)
		return TRUE
	if(monitor_console?.primer)
		var/atom/primer_scan_target = monitor_console.primer.scan_target?.resolve()
		return primer_scan_target != occupant
	return TRUE
