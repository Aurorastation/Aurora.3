/*
CONTAINS:
HEALTH ANALYZER
GAS ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
BREATH ANALYZER
*/

/obj/item/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "healthanalyzer"
	item_state = "healthanalyzer"
	contained_sprite = TRUE
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MATERIAL_ALUMINIUM = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)

/obj/item/healthanalyzer/Initialize(mapload, ...)
	. = ..()
	src.LoadComponent(/datum/component/health_analyzer)
	flick("[icon_state]-scan", src)

/obj/item/healthanalyzer/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Health analyzers are faster at scanning people, the higher grade it is and the higher the anatomy skill of the user is."
	. += "Clicking it in hand will pull up the last scan, if it has not been cleared."

/obj/item/healthanalyzer/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/datum/component/health_analyzer/h_analyzer = src.GetComponent(/datum/component/health_analyzer)
	if(!h_analyzer)
		return
	h_analyzer.attack(target_mob, user, target_zone)

/obj/item/healthanalyzer/attack_self(mob/user)
	var/datum/component/health_analyzer/h_analyzer = src.GetComponent(/datum/component/health_analyzer)
	if(!h_analyzer)
		return
	h_analyzer.attack_self(user)

/// Calculates severity based on the ratios defined external limbs.
/proc/get_wound_severity(damage_ratio, can_heal_overkill, uppercase = FALSE)
	var/degree = "none"

	if(!damage_ratio)
		if(uppercase)
			degree = capitalize(degree)
		return degree

	switch(damage_ratio)
		if (0 to 10)
			degree = "minor"
		if (10 to 25)
			degree = "moderate"
		if (25 to 50)
			degree = "significant"
		if (50 to 75)
			degree = "severe"
		if (75 to 100)
			degree = "extreme"
		if (100 to INFINITY)
			degree = can_heal_overkill ? "critical" : "irreparable"

	if(uppercase)
		degree = capitalize(degree)
	return degree

/proc/get_severity(amount, uppercase = FALSE)
	var/output = "none"

	if(!amount)
		if(uppercase)
			output = capitalize(output)
		return output

	switch(amount)
		if (0 to 10)
			output = "minor"
		if (10 to 25)
			output = "moderate"
		if (25 to 50)
			output = "significant"
		if (50 to 75)
			output = "severe"
		if (75 to 100)
			output = "extreme"
		if (100 to INFINITY)
			output = "critical"

	if(uppercase)
		output = capitalize(output)
	return output

/obj/item/analyzer
	name = "gas analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "airanalyzer"
	item_state = "airanalyzer"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(MATERIAL_ALUMINIUM = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/analyzer/atmosanalyze(var/mob/user)
	if(!user) return
	var/air = user.return_air()
	if (!air) return
	flick("[icon_state]-scan", src)
	return atmosanalyzer_scan(src, air, user)

/obj/item/analyzer/attack_self(mob/user as mob)

	if (user.stat)
		return
	if (!usr.IsAdvancedToolUser())
		to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	analyze_gases(src, user)
	return

/obj/item/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "spectrometer"
	// Reuses the basic health analyzer inhands.
	item_state = "healthanalyzer"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(MATERIAL_ALUMINIUM = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = FALSE

/obj/item/mass_spectrometer/Initialize()
	. = ..()
	create_reagents(5)

/obj/item/mass_spectrometer/on_reagent_change()
	clear_blood_overlay()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
		var/image/I = image(icon, null, "[initial(icon_state)]-reagent")
		I.color = reagents.get_color()
		add_blood_overlay(I)
	else
		icon_state = initial(icon_state)

/obj/item/mass_spectrometer/proc/clear_blood_overlay()
	underlays = null

/obj/item/mass_spectrometer/proc/add_blood_overlay(var/image/I)
	underlays += I

/obj/item/mass_spectrometer/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	if(reagents.total_volume)
		if(LAZYLEN(reagents.reagent_volumes) > 1)
			to_chat(user, SPAN_WARNING("There isn't enough blood in the sample!"))
			return
		if(!REAGENT_DATA(reagents, /singleton/reagent/blood))
			to_chat(user, SPAN_WARNING("The sample was contaminated with non-blood reagents!"))
			return
		var/list/blood_traces = reagents.reagent_data[/singleton/reagent/blood]["trace_chem"]
		var/list/output_text = list("Trace Chemicals Found:")
		for(var/_C in blood_traces)
			var/singleton/reagent/C = GET_SINGLETON(_C)
			if(C.spectro_hidden && !details)
				continue
			if(details)
				output_text += "- [C] ([max(round(blood_traces[_C], 0.1), 0.1)] units)"
			else
				output_text += "- [C]"
		if(length(output_text) == 1)
			output_text[1] = SPAN_NOTICE("No trace chemicals found.")
		to_chat(user, jointext(output_text, "\n"))

/obj/item/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "spectrometer_adv"
	details = TRUE
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/mass_spectrometer/adv/clear_blood_overlay()
	ClearOverlays()

/obj/item/mass_spectrometer/adv/add_blood_overlay(var/image/I)
	AddOverlays(I)

/obj/item/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "reagent_scanner"
	// Reuses the basic health analyzer inhands.
	item_state = "healthanalyzer"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter = list(MATERIAL_ALUMINIUM = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/reagent_scanner/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if(use_check_and_message(user))
		return
	if(!istype(O))
		return
	if(isemptylist(O.reagents?.reagent_volumes))
		to_chat(user, SPAN_WARNING("No active chemical agents found in [O]."))
		return

	var/dat = ""
	var/one_percent = O.reagents.total_volume / 100
	for (var/_R in O.reagents.reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		dat += "\n \t [R][details ? ": [O.reagents.reagent_volumes[_R] / one_percent]%" : ""]"
	to_chat(user, SPAN_NOTICE("Chemicals found: [dat]"))

/obj/item/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "reagent_scanner_adv"
	// Reuses the advanced health analyzer inhands.
	item_state = "healthanalyzer_adv"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/slime_scanner
	name = "slime scanner"
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "slime_scanner"
	item_state = "slime_scanner"
	contained_sprite = TRUE
	origin_tech = list(TECH_BIO = 1)
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	matter = list(MATERIAL_ALUMINIUM = 30, MATERIAL_GLASS = 20)

/obj/item/slime_scanner/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!isslime(target_mob))
		to_chat(user, SPAN_WARNING("This device can only scan slimes!"))
		return

	var/mob/living/carbon/slime/T = target_mob
	to_chat(user, SPAN_NOTICE("**************************"))
	to_chat(user, SPAN_NOTICE("Slime scan results:"))
	to_chat(user, SPAN_NOTICE(capitalize_first_letters("[T.colour] [T.is_adult ? "adult" : "baby"] slime")))
	to_chat(user, SPAN_NOTICE("Health: [T.health]"))
	to_chat(user, SPAN_NOTICE("Nutrition: [T.nutrition]/[T.get_max_nutrition()]"))
	if(T.nutrition < T.get_starve_nutrition())
		to_chat(user, SPAN_ALERT("Warning: slime is starving!"))
	else if (T.nutrition < T.get_hunger_nutrition())
		to_chat(user, SPAN_WARNING("Warning: slime is hungry!"))
	to_chat(user, SPAN_NOTICE("Electric charge strength: [T.powerlevel]"))
	to_chat(user, SPAN_NOTICE("Growth progress: [T.amount_grown]/10"))
	if(T.cores > 1)
		to_chat(user, SPAN_WARNING("Anomalous number of slime cores detected."))
	else if(!T.cores)
		to_chat(user, SPAN_WARNING("No slime cores detected."))
	to_chat(user, SPAN_NOTICE("Genetic Information:"))
	if(T.slime_mutation[4] == T.colour)
		to_chat(user, SPAN_WARNING("This slime cannot evolve any further."))
	else
		var/list/poss_mutations = uniquelist(T.slime_mutation)
		var/mutation_message = capitalize(english_list(poss_mutations))
		to_chat(user, SPAN_NOTICE(mutation_message))
		var/mut_chance = T.mutation_chance / (poss_mutations.len > 2 ? 1 : 2)
		to_chat(user, SPAN_NOTICE("Instability: [mut_chance]% chance of mutation upon reproduction."))
		to_chat(user, SPAN_NOTICE("**************************"))

/obj/item/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "price_scanner"
	item_state = "price_scanner"
	contained_sprite = TRUE
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 3
	matter = list(DEFAULT_WALL_MATERIAL = 25, MATERIAL_GLASS = 25)

/obj/item/price_scanner/afterattack(atom/movable/target, mob/user as mob, proximity)
	if(!proximity)
		return

	var/value = get_value(target)
	user.visible_message(SPAN_NOTICE("\The [user] scans \the [target] with \the [src]."))
	to_chat(user, SPAN_NOTICE("\The [src] estimates the price of \the [target] at <b>[value ? value : "N/A"]电</b>."))

/obj/item/breath_analyzer
	name = "breath analyzer"
	desc = "A hand-held breath analyzer that provides a robust amount of information about the subject's respiratory system."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "breath_analyzer"
	// Reuses the basic health analyzer inhands.
	item_state = "healthanalyzer"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 3
	matter = list(MATERIAL_ALUMINIUM = 30, MATERIAL_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

/obj/item/breath_analyzer/attack(mob/living/target_mob, mob/living/user, target_zone)

	var/mob/living/carbon/human/H = target_mob

	if (!istype(H))
		to_chat(user,SPAN_WARNING("You can't find a way to use \the [src] on [H]!"))
		return

	if ( ((user.is_clumsy()) || (user.mutations & DUMB)) && prob(20))
		to_chat(user,SPAN_DANGER("Your hand slips from clumsiness!"))
		if(!H.eyes_protected(src, FALSE))
			eyestab(H,user)
		to_chat(user,SPAN_DANGER("Alert: No breathing detected."))
		return

	if (!user.IsAdvancedToolUser())
		to_chat(user,SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(user == H && !H.can_eat(src))
		return
	else if(!H.can_force_feed(user, src))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	user.visible_message(SPAN_NOTICE("[user] is trying to take a breath sample from [H]."),
							SPAN_NOTICE("You gently insert \the [src] into [H]'s mouth."))

	if (!LAZYLEN(src.other_DNA))
		LAZYADD(src.other_DNA, H.dna.unique_enzymes)
		src.other_DNA_type = "saliva"

	if (!do_after(user, 2 SECONDS, H, DO_UNIQUE & ~DO_BOTH_CAN_TURN))
		return

	user.visible_message(SPAN_NOTICE("[user] takes a breath sample from [H]."),
							SPAN_NOTICE("\The [src] clicks as it finishes reading [H]'s breath sample."))

	to_chat(user,"<b>Breath Sample Results:</b>")

	if(H.stat == DEAD || H.losebreath || !H.breathing)
		to_chat(user,SPAN_DANGER("Alert: No breathing detected."))
		playsound(user.loc, 'sound/items/healthscanner/healthscanner_dead.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
		return

	switch(H.getOxyLoss())
		if(0 to 25)
			to_chat(user,"Subject oxygen levels nominal.")
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_stable.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
		if(25 to 50)
			to_chat(user,SPAN_NOTICE("Subject oxygen levels abnormal."))
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_danger.ogg', 25, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
		if(50 to INFINITY)
			to_chat(user,SPAN_NOTICE("<b>Severe oxygen deprivation detected.</b>"))
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_critical.ogg', 25, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	var/obj/item/organ/internal/L = H.internal_organs_by_name[BP_LUNGS]
	if(istype(L))
		if(L.is_bruised())
			to_chat(user,SPAN_WARNING("<b>Ruptured lung detected.</b>"))
		else if(L.is_damaged())
			to_chat(user,"<b>Damaged lung detected.</b>")
		else
			to_chat(user,"Subject lung health nominal.")
	else
		to_chat(user,SPAN_WARNING("Subject lung health unknown."))

	var/additional_string = "<font color='green'>\[NORMAL\]</font>"
	var/bac = H.get_blood_alcohol()
	switch(bac)
		if(INTOX_JUDGEIMP to INTOX_MUSCLEIMP)
			additional_string = "\[LIGHTLY INTOXICATED\]"
		if(INTOX_MUSCLEIMP to INTOX_BALANCE)
			additional_string = "\[MODERATELY INTOXICATED\]"
		if(INTOX_BALANCE to INTOX_BLACKOUT)
			additional_string = "<span class='warning'>\[HEAVILY INTOXICATED\]</span>"
		if(INTOX_BLACKOUT to INTOX_DEATH)
			additional_string = "<span class='warning'>\[ALCOHOL POISONING LIKELY\]</span>"
		if(INTOX_DEATH to INFINITY)
			additional_string = SPAN_WARNING("\[DEATH IMMINENT\]")
	to_chat(user,"<span class='normal'>Blood Alcohol Content: [round(bac,0.01)] <b>[additional_string]</b></span>")

	if(H.breathing && H.breathing.total_volume)
		var/unknown = 0
		for(var/_R in H.breathing.reagent_volumes)
			var/singleton/reagent/R = GET_SINGLETON(_R)
			if(R.scannable)
				to_chat(user,SPAN_NOTICE("[R.name] found in subject's respiratory system."))
			else
				++unknown
		if(unknown)
			to_chat(user,SPAN_WARNING("Non-medical reagent[(unknown > 1)?"s":""] found in subject's respiratory system."))


/obj/item/advanced_healthanalyzer
	name = "advanced health analyzer"
	desc = "An expensive and varied-use health analyzer that prints full-body scans after a short scanning delay."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "healthanalyzer_adv"
	item_state = "healthanalyzer_adv"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	var/obj/structure/machinery/body_scanconsole/connected = null //this is used to print the date and to deal with extra

/obj/item/advanced_healthanalyzer/Initialize()
	. = ..()
	if(!connected)
		var/obj/structure/machinery/body_scanconsole/S = new (src)
		S.forceMove(src)
		S.update_use_power(POWER_USE_OFF)
		connected = S

/obj/item/advanced_healthanalyzer/Destroy()
	if(connected)
		QDEL_NULL(connected)
	return ..()

/obj/item/advanced_healthanalyzer/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!connected)
		return
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.visible_message("<b>[user]</b> starts scanning \the [target_mob] with \the [src].", SPAN_NOTICE("You start scanning \the [target_mob] with \the [src]."))
	flick("[icon_state]-scan", src)
	if(do_after(user, 7 SECONDS, target_mob, DO_UNIQUE))
		print_scan(target_mob, user)
		add_fingerprint(user)

/obj/item/advanced_healthanalyzer/proc/print_scan(var/mob/M, var/mob/living/user)
	var/obj/item/paper/medscan/R = new /obj/item/paper/medscan(src, connected.format_occupant_data(get_occupant_data(M)), "Scan ([M.name]) ([worldtime2text()])", M)
	connected.print(R, message = "\The [src] beeps, printing \the [R] after a moment.", user = user)

/// Variant of print_scan(), main difference is different method to print the paper
/obj/item/advanced_healthanalyzer/cyborg/print_scan(var/mob/M, var/mob/living/user)
	var/obj/item/paper/medscan/R = new /obj/item/paper/medscan(src, connected.format_occupant_data(get_occupant_data(M)), "Scan ([M.name]) ([worldtime2text()])", M)
	user.visible_message(SPAN_NOTICE("\The [src] beeps, printing \the [R] after a moment."))
	playsound(user.loc, SFX_PRINT, 50, 1)
	R.forceMove(user.loc)

/obj/item/advanced_healthanalyzer/proc/get_occupant_data(var/mob/living/carbon/human/H)
	if (!ishuman(H))
		return

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
