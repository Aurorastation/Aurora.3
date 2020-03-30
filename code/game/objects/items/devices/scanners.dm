/*
CONTAINS:
HEALTH ANALYZER
GAS ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
BREATH ANALYZER
*/

/obj/item/device/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health"
	item_state = "healthanalyzer"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 2.0
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/mode = 1

/obj/item/device/healthanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	health_scan_mob(M, user, mode)
	src.add_fingerprint(user)
	return

/obj/item/device/healthanalyzer/attack_self(mob/user)
	health_scan_mob(user, user, mode)
	src.add_fingerprint(user)
	return

/proc/get_wound_severity(var/damage_ratio) //Used for ratios.
	var/degree = "none"

	switch(damage_ratio)
		if(0.05 to 0.1)
			degree = "minor"
		if(0.1 to 0.25)
			degree = "moderate"
		if(0.25 to 0.5)
			degree = "significant"
		if(0.5 to 0.75)
			degree = "severe"
		if(0.75 to 1)
			degree = "extreme"
	return degree

/proc/get_severity(amount, var/tag = FALSE)
	if(!amount)
		return "none"
	. = "minor"
	if(amount > 50)
		if(tag)
			. = "<span class='bad'>severe</span>"
		else
			. = "severe"
	else if(amount > 25)
		if(tag)
			. = "<span class='bad'>significant</span>"
		else
			. = "significant"
	else if(amount > 10)
		if(tag)
			. = "<span class='average'>moderate</span>"
		else
			. = "moderate"

/proc/health_scan_mob(var/mob/M, var/mob/living/user, var/show_limb_damage = TRUE)
	if (((user.is_clumsy()) || (DUMB in user.mutations)) && prob(50))
		user.visible_message("<span class='notice'>\The [user] runs the scanner over the floor.</span>", "<span class='notice'>You run the scanner over the floor.</span>", "<span class='notice'>You hear metal repeatedly clunking against the floor.</span>")
		to_chat(user, "<span class='notice'><b>Scan results for the floor:</b></span>")
		to_chat(user, "Overall Status: Healthy</span>")
		return

	if(!usr.IsAdvancedToolUser())
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	user.visible_message("<span class='notice'>[user] runs the scanner over [M].</span>","<span class='notice'>You run the scanner over [M].</span>")

	if(!istype(M, /mob/living/carbon/human))
		to_chat(user, "<span class='warning'>This scanner is designed for humanoid patients only.</span>")
		return

	var/mob/living/carbon/human/H = M

	if(H.isSynthetic() && !H.isFBP())
		to_chat(user, "<span class='warning'>This scanner is designed for organic humanoid patients only.</span>")
		return

	. = list()
	var/header = list()
	var/b
	var/endb
	var/dat = list()

	header += "<style> .scan_notice{color: #5f94af;}</style>"
	header += "<style> .scan_warning{color: #ff0000; font-style: italic;}</style>"
	header += "<style> .scan_danger{color: #ff0000; font-weight: bold;}</style>"
	header += "<style> .scan_red{color:red}</style>"
	header += "<style> .scan_green{color:green}</style>"
	header += "<style> .scan_blue{color: #5f94af}</style>"
	header += "<style> .scan_orange{color:#ffa500}</style>"
	b		= "<b>"
	endb	= "</b>"

	. += "[b]Scan results for \the [H]:[endb]"

	// Brain activity.
	var/brain_result = H.get_brain_status()
	dat += "Brain activity: [brain_result]."

	if(H.stat == DEAD || (H.status_flags & FAKEDEATH))
		dat += "<span class='scan_warning'>[b]Time of Death:[endb] [time2text(worldtime2text(H.timeofdeath), "hh:mm")]</span>"

	// Pulse rate.
	var/pulse_result = "normal"
	if(H.should_have_organ(BP_HEART))
		if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
		pulse_result = "<span class='scan_green'>[pulse_result]bpm</span>"
		if(H.pulse() == PULSE_NONE)
			pulse_result = "<span class='scan_danger'>[pulse_result]</span>"
		else if(H.pulse() < PULSE_NORM)
			pulse_result = "<span class='scan_notice'>[pulse_result]</span>"
		else if(H.pulse() > PULSE_NORM)
			pulse_result = "<span class='scan_warning'>[pulse_result]</span>"
	else
		if(H.isFBP())
			pulse_result = "[rand(70, 85)]bpm"
		else
			pulse_result = "<span class='scan_danger'>ERROR - Nonstandard biology</span>"
	dat += "Pulse rate: [pulse_result]."

	// Blood pressure. Based on the idea of a normal blood pressure being 120 over 80.
	if(H.should_have_organ(BP_HEART))
		if(H.get_blood_volume() <= 70)
			dat += "<span class='scan_danger'>Severe blood loss detected.</span>"
		var/oxygenation_string = "<span class='scan_green'>[H.get_blood_oxygenation()]% blood oxygenation</span>"
		switch(H.get_blood_oxygenation())
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				oxygenation_string = "<span class='scan_notice'>[oxygenation_string]</span>"
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_OKAY)
				oxygenation_string = "<span class='scan_warning'>[oxygenation_string]</span>"
			if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
				oxygenation_string = "<span class='scan_danger'>[oxygenation_string]</span>"

		var/blood_pressure_string
		switch(H.get_blood_pressure_alert())
			if(1)
				blood_pressure_string = "<span class='scan_danger'>[H.get_blood_pressure()]</span>"
			if(2)
				blood_pressure_string = "<span class='scan_green'>[H.get_blood_pressure()]</span>"
			if(3)
				blood_pressure_string = "<span class='scan_warning'>[H.get_blood_pressure()]</span>"
			if(4)
				blood_pressure_string = "<span class='scan_danger'>[H.get_blood_pressure()]</span>"
		dat += "[b]Blood pressure:[endb] [blood_pressure_string] ([oxygenation_string])"
	else
		if(H.isFBP())
			dat += "[b]Blood pressure:[endb] [rand(118, 125)]/[rand(77, 85)] (100%)"
		else
			dat += "[b]Blood pressure:[endb] N/A"

	// Body temperature.
	var/temperature_string
	if(H.bodytemperature < H.species.cold_level_1 || H.bodytemperature > H.species.heat_level_1)
		temperature_string = "<span class='scan_warning'>Body temperature: [H.bodytemperature-T0C]&deg;C ([H.bodytemperature*1.8-459.67]&deg;F)</span>"
	else
		temperature_string = "<span class='scan_green'>Body temperature: [H.bodytemperature-T0C]&deg;C ([H.bodytemperature*1.8-459.67]&deg;F)</span>"
	dat += temperature_string

	// Traumatic shock.
	if(H.is_asystole())
		dat += "<span class='scan_danger'>Patient is suffering from cardiovascular shock. Administer CPR immediately.</span>"
	else if(H.shock_stage > 80)
		dat += "<span class='scan_warning'>Patient is at serious risk of going into shock. Pain relief recommended.</span>"

	if(H.getOxyLoss() > 50)
		dat += "<span class='scan_blue'>[b]Severe oxygen deprivation detected.[endb]</span>"
	if(H.getToxLoss() > 50)
		dat += "<span class='scan_orange'>[b]Major systemic organ failure detected.[endb]</span>"
	if(H.getFireLoss() > 50)
		dat += "<span class='scan_orange'>[b]Severe burn damage detected.[endb]</span>"
	if(H.getBruteLoss() > 50)
		dat += "<span class='scan_red'>[b]Severe anatomical damage detected.[endb]</span>"

	var/rad_result = "Radiation: "
	switch(H.total_radiation)
		if(RADS_NONE)
			rad_result += span("scan_green", "No radiation detected.")
		if(RADS_LOW to RADS_MED)
			rad_result += span("scan_orange", "Low levels of radiation poisoning detected.")
		if(RADS_MED to RADS_HIGH)
			rad_result += span("scan_orange", "Severe levels of radiation poisoning detected!")
		if(RADS_HIGH to INFINITY)
			rad_result += span("scan_red", "[b]Extreme levels of radiation poisoning detected![endb]")
	dat += rad_result
	
	if(show_limb_damage)
		var/list/damaged = H.get_damaged_organs(1,1)
		if(damaged.len)
			for(var/obj/item/organ/external/org in damaged)
				var/limb_result = "[capitalize(org.name)][BP_IS_ROBOTIC(org) ? " (Cybernetic)" : ""]:"
				if(org.brute_dam > 0)
					limb_result = "[limb_result] \[<font color = 'red'><b>[get_severity(org.brute_dam, TRUE)] physical trauma</b></font>\]"
				if(org.burn_dam > 0)
					limb_result = "[limb_result] \[<font color = '#ffa500'><b>[get_severity(org.burn_dam, TRUE)] burns</b></font>\]"
				if(org.status & ORGAN_BLEEDING)
					limb_result = "[limb_result] \[<span class='scan_danger'>bleeding</span>\]"
				dat += limb_result
		else
			dat += "No detectable limb injuries."

	for(var/name in H.organs_by_name)
		var/obj/item/organ/external/e = H.organs_by_name[name]
		if(!e)
			continue
		var/limb = e.name
		if(e.status & ORGAN_BROKEN)
			if(((e.name == BP_L_ARM) || (e.name == BP_R_ARM) || (e.name == BP_L_LEG) || (e.name == BP_R_LEG)) && !(e.status & ORGAN_SPLINTED))
				dat += "<span class='scan_warning'>Unsecured fracture in subject [limb]. Splinting recommended for transport.</span>"

	for(var/name in H.organs_by_name)
		var/obj/item/organ/external/e = H.organs_by_name[name]
		if(e && e.status & ORGAN_BROKEN)
			dat += "<span class='scan_warning'>Bone fractures detected. Advanced scanner required for location.</span>"
			break

	var/found_bleed
	var/found_tendon
	var/found_disloc
	for(var/obj/item/organ/external/e in H.organs)
		if(e)
			if(!found_disloc && e.dislocated == 2)
				dat += "<span class='scan_warning'>Dislocation detected. Advanced scanner required for location.</span>"
				found_disloc = TRUE
			if(!found_bleed && (e.status & ORGAN_ARTERY_CUT))
				dat += "<span class='scan_warning'>Arterial bleeding detected. Advanced scanner required for location.</span>"
				found_bleed = TRUE
			if(!found_tendon && (e.status & ORGAN_TENDON_CUT))
				dat += "<span class='scan_warning'>Tendon or ligament damage detected. Advanced scanner required for location.</span>"
				found_tendon = TRUE
		if(found_disloc && found_bleed && found_tendon)
			break

	. += dat
	dat = list()

	// Reagent data.
	. += "[b]Reagent scan:[endb]"

	var/print_reagent_default_message = TRUE

	if(H.reagents.total_volume)
		var/unknown = 0
		var/reagentdata[0]
		for(var/A in H.reagents.reagent_list)
			var/datum/reagent/R = A
			if(R.scannable)
				print_reagent_default_message = FALSE
				reagentdata["[R.id]"] = "<span class='notice'>    [round(H.reagents.get_reagent_amount(R.id), 1)]u [R.name]</span>"
			else
				unknown++
		if(reagentdata.len)
			print_reagent_default_message = FALSE
			dat += "<span class='notice'>Beneficial reagents detected in subject's blood:</span>"
			for(var/d in reagentdata)
				dat += reagentdata[d]
		if(unknown)
			print_reagent_default_message = FALSE
			dat += "<span class='warning'>Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>"

	var/datum/reagents/ingested = H.get_ingested_reagents()
	if(ingested && ingested.total_volume)
		var/unknown = 0
		for(var/datum/reagent/R in ingested.reagent_list)
			if(R.scannable)
				print_reagent_default_message = FALSE
				dat += "<span class='notice'>[R.name] found in subject's stomach.</span>"
			else
				++unknown
		if(unknown)
			print_reagent_default_message = FALSE
			dat +=  "<span class='warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.</span>"

	if(print_reagent_default_message)
		dat += "No results."

	if(H.virus2.len)
		for (var/ID in H.virus2)
			var/datum/record/virus/V = SSrecords.find_record("id", "[ID]", RECORD_VIRUS)
			if(istype(V))
				dat += "<span class='warning'>Warning: Pathogen [V.name] detected in subject's blood. Known antigen : [V.antigen]</span>"

	. += dat

	header = jointext(header, null)
	. = jointext(.,"<br>")
	. = jointext(list(header,.),null)

	to_chat(user, "<hr>")
	to_chat(user, .)
	to_chat(user, "<hr>")

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode

	if(mode)
		to_chat(usr, "The scanner now shows specific limb damage.")
	else
		to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/device/analyzer
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = 2.0
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/device/analyzer/atmosanalyze(var/mob/user)
	var/air = user.return_air()
	if (!air)
		return

	return atmosanalyzer_scan(src, air, user)

/obj/item/device/analyzer/attack_self(mob/user as mob)

	if (user.stat)
		return
	if (!usr.IsAdvancedToolUser())
		to_chat(usr, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	analyze_gases(src, user)
	return

/obj/item/device/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = 2.0
	flags = CONDUCT | OPENCONTAINER
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/mass_spectrometer/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/device/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/attack_self(mob/user as mob)
	if (user.stat)
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id != "blood")
				reagents.clear_reagents()
				to_chat(user, "<span class='warning'>The sample was contaminated! Please insert another sample</span>")
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat = "Trace Chemicals Found: "
		for(var/R in blood_traces)
			if(details)
				dat += "[R] ([blood_traces[R]] units) "
			else
				dat += "[R] "
		to_chat(user, "[dat]")
		reagents.clear_reagents()
	return

/obj/item/device/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = 2.0
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/reagent_scanner/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return
	if (user.stat)
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return
	if(!istype(O))
		return

	if(!isnull(O.reagents))
		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			var/one_percent = O.reagents.total_volume / 100
			for (var/datum/reagent/R in O.reagents.reagent_list)
				dat += "\n \t <span class='notice'>[R][details ? ": [R.volume / one_percent]%" : ""]"
		if(dat)
			to_chat(user, "<span class='notice'>Chemicals found: [dat]</span>")
		else
			to_chat(user, "<span class='notice'>No active chemical agents found in [O].</span>")
	else
		to_chat(user, "<span class='notice'>No significant chemical agents found in [O].</span>")

	return

/obj/item/device/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/slime_scanner
	name = "slime scanner"
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	origin_tech = list(TECH_BIO = 1)
	w_class = 2.0
	flags = CONDUCT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

/obj/item/device/slime_scanner/attack(mob/living/M, mob/living/user)
	if(!isslime(M))
		to_chat(user, span("warning", "This device can only scan slimes!"))
		return
	var/mob/living/carbon/slime/T = M
	to_chat(user, span("notice", "**************************"))
	to_chat(user, span("notice", "Slime scan results:"))
	to_chat(user, span("notice", capitalize_first_letters("[T.colour] [T.is_adult ? "adult" : "baby"] slime")))
	to_chat(user, span("notice", "Health: [T.health]"))
	to_chat(user, span("notice", "Nutrition: [T.nutrition]/[T.get_max_nutrition()]"))
	if(T.nutrition < T.get_starve_nutrition())
		to_chat(user, span("alert", "Warning: slime is starving!"))
	else if (T.nutrition < T.get_hunger_nutrition())
		to_chat(user, span("warning", "Warning: slime is hungry!"))
	to_chat(user, span("notice", "Electric charge strength: [T.powerlevel]"))
	to_chat(user, span("notice", "Growth progress: [T.amount_grown]/10"))
	if(T.cores > 1)
		to_chat(user, span("warning", "Anomalous number of slime cores detected."))
	else if(!T.cores)
		to_chat(user, span("warning", "No slime cores detected."))
	to_chat(user, span("notice", "Genetic Information:"))
	if(T.slime_mutation[4] == T.colour)
		to_chat(user, span("warning", "This slime cannot evolve any further."))
	else
		var/list/poss_mutations = uniquelist(T.slime_mutation)
		var/mutation_message = capitalize(english_list(poss_mutations))
		to_chat(user, SPAN_NOTICE(mutation_message))
		var/mut_chance = T.mutation_chance / (poss_mutations.len > 2 ? 1 : 2)
		to_chat(user, SPAN_NOTICE("Instability: [mut_chance]% chance of mutation upon reproduction."))
		to_chat(user, SPAN_NOTICE("**************************"))

/obj/item/device/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon_state = "price_scanner"
	slot_flags = SLOT_BELT
	w_class = 2
	throwforce = 0
	throw_speed = 3
	throw_range = 3
	matter = list(DEFAULT_WALL_MATERIAL = 25, MATERIAL_GLASS = 25)

/obj/item/device/price_scanner/afterattack(atom/movable/target, mob/user as mob, proximity)
	if(!proximity)
		return

	var/value = get_value(target)
	user.visible_message("\The [user] scans \the [target] with \the [src]")
	user.show_message("Price estimation of \the [target]: [value ? value : "N/A"] Credits")

/obj/item/device/breath_analyzer
	name = "breath analyzer"
	desc = "A hand-held breath analyzer that provides a robust amount of information about the subject's repository system."
	icon_state = "breath_analyzer"
	item_state = "analyzer"
	w_class = 2.0
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 3
	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

/obj/item/device/breath_analyzer/attack(mob/living/carbon/human/H, mob/living/user as mob)

	if (!istype(H))
		to_chat(user,"<span class='warning'>You can't find a way to use \the [src] on [H]!</span>")
		return

	if ( ((user.is_clumsy()) || (DUMB in user.mutations)) && prob(20))
		to_chat(user,"<span class='danger'>Your hand slips from clumsiness!</span>")
		eyestab(H,user)
		to_chat(user,"<span class='danger'>Alert: No breathing detected.</span>")
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user,"<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	if(user == H && !H.can_eat(src))
		return
	else if(!H.can_force_feed(user, src))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(H)

	user.visible_message("<span class='notice'>[user] is trying to take a breath sample from [H].</span>","<span class='notice'>You gently insert \the [src] into [H]'s mouth.</span>")

	if (!LAZYLEN(src.other_DNA))
		LAZYADD(src.other_DNA, H.dna.unique_enzymes)
		src.other_DNA_type = "saliva"

	if (!do_after(user, 2 SECONDS, act_target = H))
		to_chat(user,"<span class='notice'>You and the target need to be standing still in order to take a breath sample.</span>")
		return

	user.visible_message("<span class='notice'>[user] takes a breath sample from [H].</span>","<span class='notice'>\The [src] clicks as it finishes reading [H]'s breath sample.</span>")

	to_chat(user,"<b>Breath Sample Results:</b>")

	if(H.stat == DEAD || H.losebreath || !H.breathing)
		to_chat(user,"<span class='danger'>Alert: No breathing detected.</span>")
		return

	switch(H.getOxyLoss())
		if(0 to 25)
			to_chat(user,"Subject oxygen levels nominal.")
		if(25 to 50)
			to_chat(user,"<font color='blue'>Subject oxygen levels abnormal.</font>")
		if(50 to INFINITY)
			to_chat(user,"<font color='blue'><b>Severe oxygen deprivation detected.</b></font>")

	var/obj/item/organ/internal/L = H.internal_organs_by_name[BP_LUNGS]
	if(istype(L))
		if(L.is_bruised())
			to_chat(user,"<font color='red'><b>Ruptured lung detected.</b></font>")
		else if(L.is_damaged())
			to_chat(user,"<b>Damaged lung detected.</b>")
		else
			to_chat(user,"Subject lung health nominal.")
	else
		to_chat(user,"<span class='warning'>Subject lung health unknown.</span>")

	var/additional_string = "<font color='green'>\[NORMAL\]</font>"
	var/bac = H.get_blood_alcohol()
	switch(bac)
		if(INTOX_JUDGEIMP to INTOX_MUSCLEIMP)
			additional_string = "\[LIGHTLY INTOXICATED\]"
		if(INTOX_MUSCLEIMP to INTOX_VOMIT)
			additional_string = "\[MODERATELY INTOXICATED\]"
		if(INTOX_VOMIT to INTOX_BALANCE)
			additional_string = "<font color='red'>\[HEAVILY INTOXICATED\]</font>"
		if(INTOX_BALANCE to INTOX_DEATH)
			additional_string = "<font color='red'>\[ALCOHOL POISONING LIKELY\]</font>"
		if(INTOX_DEATH to INFINITY)
			additional_string = "<font color='red'>\[DEATH IMMINENT\]</font>"
	to_chat(user,"<span class='normal'>Blood Alcohol Content: [round(bac,0.01)] <b>[additional_string]</b></span>")

	if(H.breathing && H.breathing.total_volume)
		var/unknown = 0
		for(var/datum/reagent/R in H.breathing.reagent_list)
			if(R.scannable)
				to_chat(user,"<span class='notice'>[R.name] found in subject's respitory system.</span>")
			else
				++unknown
		if(unknown)
			to_chat(user,"<span class='warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's respitory system.</span>")
