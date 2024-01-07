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
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/last_scan = 0
	var/mode = 1
	var/sound_scan = FALSE

/obj/item/device/healthanalyzer/attack(mob/living/M, mob/living/user)
	sound_scan = FALSE
	if(last_scan <= world.time - 20) //Spam limiter.
		last_scan = world.time
		sound_scan = TRUE
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(src)
	flick("[icon_state]-scan", src)	//makes it so that it plays the scan animation on a successful scan
	health_scan_mob(M, user, mode, sound_scan = sound_scan)
	add_fingerprint(user)

/obj/item/device/healthanalyzer/attack_self(mob/user)
	sound_scan = FALSE
	if(last_scan <= world.time - 20) //Spam limiter.
		last_scan = world.time
		sound_scan = TRUE
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(src)
	flick("[icon_state]-scan", src)	//makes it so that it plays the scan animation on a successful scan
	health_scan_mob(user, user, mode, sound_scan = sound_scan)
	add_fingerprint(user)

/proc/get_wound_severity(var/damage_ratio, var/uppercase = FALSE) //Used for ratios.
	var/degree = "none"

	switch(damage_ratio)
		if(0.001 to 0.1)
			degree = "minor"
		if(0.1 to 0.2)
			degree = "moderate"
		if(0.2 to 0.4)
			degree = "significant"
		if(0.4 to 0.6)
			degree = "severe"
		if(0.6 to 0.8)
			degree = "critical"
		if(0.8 to 1)
			degree = "fatal"

	if(uppercase)
		degree = capitalize(degree)
	return degree

/proc/get_severity(amount, var/uppercase = FALSE)
	var/output = "none"
	if(!amount)
		output = "none"
	else if(amount > 100)
		output = "fatal"
	else if(amount > 75)
		output = "critical"
	else if(amount > 50)
		output = "severe"
	else if(amount > 25)
		output = "significant"
	else if(amount > 10)
		output = "moderate"
	else
		output = "minor"

	if(uppercase)
		output = capitalize(output)
	return output

/proc/health_scan_mob(var/mob/M, var/mob/living/user, var/show_limb_damage = TRUE, var/just_scan = FALSE, var/sound_scan)
	if(!just_scan)
		if (((user.is_clumsy()) || HAS_FLAG(user.mutations, DUMB)) && prob(50))
			user.visible_message("<b>[user]</b> runs the scanner over the floor.", "<span class='notice'>You run the scanner over the floor.</span>", "<span class='notice'>You hear metal repeatedly clunking against the floor.</span>")
			to_chat(user, "<span class='notice'><b>Scan results for the ERROR:</b></span>")
			if(sound_scan)
				playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25)
			return

		if(!user.IsAdvancedToolUser())
			to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
			return

		user.visible_message("<b>[user]</b> runs a scanner over [M].","<span class='notice'>You run the scanner over [M].</span>")

	if(!istype(M, /mob/living/carbon/human))
		to_chat(user, "<span class='warning'>This scanner is designed for humanoid patients only.</span>")
		if(sound_scan)
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25)
		return

	var/mob/living/carbon/human/H = M

	if(H.isSynthetic() && !H.isFBP())
		to_chat(user, "<span class='warning'>This scanner is designed for organic humanoid patients only.</span>")
		if(sound_scan)
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25)
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

	if(H.stat == DEAD || H.status_flags & FAKEDEATH)
		dat += "<span class='scan_warning'>[b]Time of Death:[endb] [worldtime2text(H.timeofdeath)]</span>"

	// Brain activity.
	var/brain_status = H.get_brain_status()
	dat += "Brain activity: [brain_status]"
	var/brain_result = H.get_brain_result()

	if(sound_scan)
		switch(brain_result)
			if(0)
				playsound(user.loc, 'sound/items/healthscanner/healthscanner_dead.ogg', 25)
			if(-1)
				playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25)
			else
				if(brain_result <= 25)
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_critical.ogg', 25)
				else if(brain_result <= 50)
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_danger.ogg', 25)
				else if(brain_result <= 90)
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25)
				else
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_stable.ogg', 25)

	// Pulse rate.
	var/pulse_result = "normal"
	if(H.should_have_organ(BP_HEART))
		if(H.status_flags & FAKEDEATH)
			pulse_result = "<span class='danger'>0</span>"
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
		if(H.pulse() == PULSE_NONE)
			pulse_result = "<span class='scan_danger'>[pulse_result] BPM</span>"
		else if(H.pulse() < PULSE_NORM)
			pulse_result = "<span class='scan_notice'>[pulse_result] BPM</span>"
		else if(H.pulse() > PULSE_NORM)
			pulse_result = "<span class='scan_warning'>[pulse_result] BPM</span>"
		else
			pulse_result = "<span class='scan_green'>[pulse_result] BPM</span>"
	else
		pulse_result = "<span class='scan_danger'>0</span>"
	dat += "Pulse rate: [pulse_result]"

	// Body temperature. Rounds to one digit after decimal.
	var/temperature_string
	if(H.bodytemperature < H.species.cold_level_1 || H.bodytemperature > H.species.heat_level_1)
		temperature_string = "Body temperature: <span class='scan_warning'>[round(H.bodytemperature-T0C, 0.1)]&deg;C ([round(H.bodytemperature*1.8-459.67, 0.1)]&deg;F)</span>"
	else
		temperature_string = "Body temperature: <span class='scan_green'>[round(H.bodytemperature-T0C, 0.1)]&deg;C ([round(H.bodytemperature*1.8-459.67, 0.1)]&deg;F)</span>"
	dat += temperature_string

	// Blood pressure and blood type. Based on the idea of a normal blood pressure being 120 over 80.
	if(H.should_have_organ(BP_HEART))
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

		var/blood_volume_string = "<span class='scan_green'>\>[BLOOD_VOLUME_SAFE]%</span>"
		switch(H.get_blood_volume())
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				blood_volume_string = "<span class='scan_notice'>\<[BLOOD_VOLUME_SAFE]%</span>"
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_OKAY)
				blood_volume_string = "<span class='scan_warning'>\<[BLOOD_VOLUME_OKAY]%</span>"
			if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
				blood_volume_string = "<span class='scan_danger'>\<[BLOOD_VOLUME_SURVIVE]%</span>"

		var/oxygenation = H.get_blood_oxygenation()
		var/oxygenation_string = "<span class='scan_green'>[oxygenation]%</span>"
		switch(oxygenation)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				oxygenation_string = "<span class='scan_notice'>[oxygenation]%</span>"
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_OKAY)
				oxygenation_string = "<span class='scan_warning'>[oxygenation]%</span>"
			if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
				oxygenation_string = "<span class='scan_danger'>[oxygenation]%</span>"
		if(H.status_flags & FAKEDEATH)
			oxygenation_string = "<span class='scan_danger'>[rand(0,10)]%</span>"
		dat += "Blood pressure: [blood_pressure_string]"
		dat += "Blood oxygenation: [oxygenation_string]"
		dat += "Blood volume: [blood_volume_string]"
		dat += "Blood type: <span class ='scan_green'>[H.dna.b_type]</span>"
	else
		dat += "Blood pressure: N/A"

	// Traumatic shock.
	if(H.is_asystole() || (H.status_flags & FAKEDEATH))
		dat += "<span class='scan_danger'>Cardiovascular shock detected. Administer CPR immediately.</span>"
	else if(H.shock_stage > 80)
		dat += "<span class='scan_warning'>Imminent cardiovascular shock. Pain relief recommended.</span>"

	if(H.getOxyLoss() > 50)
		dat += "<span class='scan_blue'>[b]Severe oxygen deprivation detected.[endb]</span>"
	if(H.getToxLoss() > 50)
		dat += "<span class='scan_orange'>[b]Major systemic organ failure detected.[endb]</span>"
	if(H.getFireLoss() > 50)
		dat += "<span class='scan_orange'>[b]Severe burn damage detected.[endb]</span>"
	if(H.getBruteLoss() > 50)
		dat += "<span class='scan_red'>[b]Severe anatomical damage detected.[endb]</span>"

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
				var/is_bandaged = org.is_bandaged()
				var/is_salved = org.is_salved()
				if(is_bandaged && is_salved)
					var/icon/B = icon('icons/obj/item/stacks/medical.dmi', "bandaged")
					var/icon/S = icon('icons/obj/item/stacks/medical.dmi', "salved")
					limb_result = "[limb_result] \[[icon2html(B, user)] | [icon2html(S, user)]\]"
				else if(is_bandaged)
					var/icon/B = icon('icons/obj/item/stacks/medical.dmi', "bandaged")
					limb_result = "[limb_result] \[[icon2html(B, user)]\]"
				else if(is_salved)
					var/icon/S = icon('icons/obj/item/stacks/medical.dmi', "salved")
					limb_result = "[limb_result] \[[icon2html(S, user)]\]"
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
			if(!found_tendon && (e.tendon_status() & TENDON_CUT))
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
		for(var/_R in H.reagents.reagent_volumes)
			var/singleton/reagent/R = GET_SINGLETON(_R)
			if(R.scannable)
				print_reagent_default_message = FALSE
				reagentdata["[_R]"] = "<span class='notice'>    [round(REAGENT_VOLUME(H.reagents, _R), 1)]u [R.name]</span>"
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
		for(var/_R in ingested.reagent_volumes)
			var/singleton/reagent/R = GET_SINGLETON(_R)
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

	. += dat

	header = jointext(header, null)
	. = jointext(.,"<br>")
	. = jointext(list(header,.),null)

	if(user)
		to_chat(user, "<hr>")
		to_chat(user, .)
		to_chat(user, "<hr>")

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"
	set src in usr

	mode = !mode

	if(mode)
		to_chat(usr, "The scanner now shows specific limb damage.")
	else
		to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/device/analyzer
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon = 'icons/obj/item/tools/air_analyzer.dmi'
	icon_state = "analyzer"
	item_state = "analyzer"
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/device/analyzer/atmosanalyze(var/mob/user)
	if(!user) return
	var/air = user.return_air()
	if (!air) return

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
	w_class = ITEMSIZE_SMALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = FALSE

/obj/item/device/mass_spectrometer/Initialize()
	. = ..()
	create_reagents(5)

/obj/item/device/mass_spectrometer/on_reagent_change()
	clear_blood_overlay()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
		var/image/I = image(icon, null, "[initial(icon_state)]-reagent")
		I.color = reagents.get_color()
		add_blood_overlay(I)
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/proc/clear_blood_overlay()
	underlays = null

/obj/item/device/mass_spectrometer/proc/add_blood_overlay(var/image/I)
	underlays += I

/obj/item/device/mass_spectrometer/attack_self(mob/user)
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

/obj/item/device/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = TRUE
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/mass_spectrometer/adv/clear_blood_overlay()
	cut_overlays()

/obj/item/device/mass_spectrometer/adv/add_blood_overlay(var/image/I)
	add_overlay(I)

/obj/item/device/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "reagent_scanner"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/reagent_scanner/afterattack(obj/O, mob/user, proximity)
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

/obj/item/device/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_reagent_scanner"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/slime_scanner
	name = "slime scanner"
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	origin_tech = list(TECH_BIO = 1)
	w_class = ITEMSIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)

/obj/item/device/slime_scanner/attack(mob/living/M, mob/living/user)
	if(!isslime(M))
		to_chat(user, SPAN_WARNING("This device can only scan slimes!"))
		return
	var/mob/living/carbon/slime/T = M
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

/obj/item/device/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon_state = "price_scanner"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
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
	desc = "A hand-held breath analyzer that provides a robust amount of information about the subject's respiratory system."
	icon_state = "breath_analyzer"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
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

	if ( ((user.is_clumsy()) || HAS_FLAG(user.mutations, DUMB)) && prob(20))
		to_chat(user,"<span class='danger'>Your hand slips from clumsiness!</span>")
		if(!H.eyes_protected(src, FALSE))
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

	if (!do_after(user, 2 SECONDS, H, DO_UNIQUE & ~DO_BOTH_CAN_TURN))
		return

	user.visible_message("<span class='notice'>[user] takes a breath sample from [H].</span>","<span class='notice'>\The [src] clicks as it finishes reading [H]'s breath sample.</span>")

	to_chat(user,"<b>Breath Sample Results:</b>")

	if(H.stat == DEAD || H.losebreath || !H.breathing)
		to_chat(user,"<span class='danger'>Alert: No breathing detected.</span>")
		playsound(user.loc, 'sound/items/healthscanner/healthscanner_dead.ogg', 25)
		return

	switch(H.getOxyLoss())
		if(0 to 25)
			to_chat(user,"Subject oxygen levels nominal.")
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_stable.ogg', 25)
		if(25 to 50)
			to_chat(user,"<span class='notice'>Subject oxygen levels abnormal.</span>")
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_danger.ogg', 25)
		if(50 to INFINITY)
			to_chat(user,"<span class='notice'><b>Severe oxygen deprivation detected.</b></span>")
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_critical.ogg', 25)

	var/obj/item/organ/internal/L = H.internal_organs_by_name[BP_LUNGS]
	if(istype(L))
		if(L.is_bruised())
			to_chat(user,"<span class='warning'><b>Ruptured lung detected.</b></span>")
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
			additional_string = "<span class='warning'>\[HEAVILY INTOXICATED\]</span>"
		if(INTOX_BALANCE to INTOX_DEATH)
			additional_string = "<span class='warning'>\[ALCOHOL POISONING LIKELY\]</span>"
		if(INTOX_DEATH to INFINITY)
			additional_string = "<span class='warning'>\[DEATH IMMINENT\]</span>"
	to_chat(user,"<span class='normal'>Blood Alcohol Content: [round(bac,0.01)] <b>[additional_string]</b></span>")

	if(H.breathing && H.breathing.total_volume)
		var/unknown = 0
		for(var/_R in H.breathing.reagent_volumes)
			var/singleton/reagent/R = GET_SINGLETON(_R)
			if(R.scannable)
				to_chat(user,"<span class='notice'>[R.name] found in subject's respiratory system.</span>")
			else
				++unknown
		if(unknown)
			to_chat(user,"<span class='warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's respiratory system.</span>")


/obj/item/device/advanced_healthanalyzer
	name = "advanced health analyzer"
	desc = "An expensive and varied-use health analyzer of Zeng-Hu design that prints full-body scans after a short scanning delay."
	icon_state = "adv-analyzer"
	item_state = "adv-analyzer"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	var/obj/machinery/body_scanconsole/connected = null //this is used to print the date and to deal with extra

/obj/item/device/advanced_healthanalyzer/Initialize()
	. = ..()
	if(!connected)
		var/obj/machinery/body_scanconsole/S = new (src)
		S.forceMove(src)
		S.update_use_power(POWER_USE_OFF)
		connected = S

/obj/item/device/advanced_healthanalyzer/Destroy()
	if(connected)
		QDEL_NULL(connected)
	return ..()

/obj/item/device/advanced_healthanalyzer/attack(mob/living/M, mob/living/user)
	if(!connected)
		return
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(src)
	user.visible_message("<b>[user]</b> starts scanning \the [M] with \the [src].", SPAN_NOTICE("You start scanning \the [M] with \the [src]."))
	if(do_after(user, 7 SECONDS, M, DO_UNIQUE))
		print_scan(M, user)
		add_fingerprint(user)

/obj/item/device/advanced_healthanalyzer/proc/print_scan(var/mob/M, var/mob/living/user)
	var/obj/item/paper/medscan/R = new /obj/item/paper/medscan(src, connected.format_occupant_data(get_occupant_data(M)), "Scan ([M.name])", M)
	connected.print(R, message = "\The [src] beeps, printing \the [R] after a moment.", user = user)

/obj/item/device/advanced_healthanalyzer/proc/get_occupant_data(var/mob/living/carbon/human/H)
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
