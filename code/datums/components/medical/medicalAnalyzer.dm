#define SPAN_SCAN_GREEN(str) ("<span class='scan_green'>" + str + "</span>")
#define SPAN_SCAN_BLUE(str) ("<span class='scan_blue'>" + str + "</span>")
#define SPAN_SCAN_ORANGE(str) ("<span class='scan_orange'>" + str + "</span>")
#define SPAN_SCAN_ORANGE_DANGER(str) ("<span class='scan_orange_danger'>" + str + "</span>")
#define SPAN_SCAN_RED(str) ("<span class='scan_red'>" + str + "</span>")
#define SPAN_SCAN_NOTICE(str) ("<span class='scan_notice'>" + str + "</span>")
#define SPAN_SCAN_WARNING(str) ("<span class='scan_warning'>" + str + "</span>")
#define SPAN_SCAN_DANGER(str) ("<span class='scan_danger'>" + str + "</span>")

/datum/component/health_analyzer
	var/name = "health analyzer"
	var/last_scan = 0
	var/device_level = 4
	var/sound_scan = FALSE
	var/list/scan_results = list()
	var/list/reagent_results = list()
	var/scan_title = null
	/// The owner object, also known as parent. Defined to easily do obj specific procs
	var/obj/owner

// This one can't scan limbs. Like a simpler version of the analyzer
/datum/component/health_analyzer/simple
	device_level = 1

/datum/component/health_analyzer/mech
	name = "mech health analyzer"

/datum/component/health_analyzer/mech/ui_state(mob/user)
	return GLOB.heavy_vehicle_state

/datum/component/health_analyzer/borer

/datum/component/health_analyzer/borer/ui_state(mob/user)
	return GLOB.conscious_state

/datum/component/health_analyzer/observer
	name = "observer health analyzer"

/datum/component/health_analyzer/observer/ui_state(mob/user)
	return GLOB.observer_state

/datum/component/health_analyzer/Initialize(...)
	. = ..()
	if(!isobj(parent))
		return
	owner = parent

/datum/component/health_analyzer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HealthAnalyzer", name, 520, 620)
		ui.open()

/datum/component/health_analyzer/ui_data(mob/user)
	var/list/data = list()
	data["scan_title"] = scan_title
	data["scan_results"] = scan_results
	data["reagent_results"] = reagent_results
	return data

/datum/component/health_analyzer/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("clear_list")
			scan_results = list()
			reagent_results = list()
			scan_title = null
			return TRUE

/datum/component/health_analyzer/proc/attack(mob/living/target_mob, mob/living/user, target_zone)
	sound_scan = TRUE

	user.visible_message("\The [user] starts scanning [user == target_mob ? "themself" : "\the [target_mob]"] with \the [owner].")
	if(do_after(user, 1.5 SECONDS, target_mob, DO_UNIQUE))
		flick("[owner.icon_state]-scan", owner)

		health_scan_mob(target_mob, user, device_level, sound_scan = sound_scan)
		ui_interact(user)

		owner.add_fingerprint(user)
	else
		user.visible_message("\The [user] stops scanning \the [target_mob].")

/datum/component/health_analyzer/proc/attack_self(mob/user)
	ui_interact(user)

	owner.add_fingerprint(user)

/datum/component/health_analyzer/proc/health_scan_mob(var/mob/M, var/mob/living/user, var/device_level = 2, var/just_scan = FALSE, var/sound_scan)
	scan_results = list()
	reagent_results = list()
	scan_title = null

	if(!just_scan)
		if (((user.is_clumsy()) || (user.mutations & DUMB)) && prob(50))
			user.visible_message("<b>[user]</b> runs the scanner over the floor.",
									SPAN_NOTICE("You run the scanner over the floor."),
									SPAN_NOTICE("You hear metal repeatedly clunking against the floor."))

			to_chat(user, SPAN_NOTICE("<b>Scan results for the ERROR:</b>"))
			if(sound_scan)
				playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
			return

		if(!user.IsAdvancedToolUser())
			to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
			return

		user.visible_message("<b>[user]</b> runs a scanner over [M].",SPAN_NOTICE("You run the scanner over [M]."))

	if(!istype(M, /mob/living/carbon/human))
		scan_title = "Scan failed"
		scan_results += SPAN_SCAN_WARNING("This scanner is designed for humanoid patients only.")
		if(sound_scan)
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
		return

	var/mob/living/carbon/human/H = M
	scan_title = "Scan results for \the [H]"

	if(H.isSynthetic() && !H.isFBP())
		to_chat(user, SPAN_WARNING("This scanner is designed for organic humanoid patients only."))
		if(sound_scan)
			playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
		return

	var/list/dat = list()
	var/b = "<b>"
	var/endb = "</b>"

	if(H.stat == DEAD || H.status_flags & FAKEDEATH)
		dat += SPAN_SCAN_WARNING("[b]Time of Death:[endb] [worldtime2text(H.timeofdeath)]")

	// Brain activity.
	var/brain_status = H.get_brain_status()
	dat += "Brain activity: [brain_status]"
	var/brain_result = H.get_brain_result()

	if(sound_scan)
		switch(brain_result)
			if(0)
				playsound(user.loc, 'sound/items/healthscanner/healthscanner_dead.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
			if(-1)
				playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
			else
				if(brain_result <= 25)
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_critical.ogg', 25, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
				else if(brain_result <= 50)
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_danger.ogg', 25, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
				else if(brain_result <= 90)
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_used.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)
				else
					playsound(user.loc, 'sound/items/healthscanner/healthscanner_stable.ogg', 25, extrarange = SILENCED_SOUND_EXTRARANGE)

	// Pulse rate.
	var/pulse_result = "normal"
	if(H.should_have_organ(BP_HEART))
		if(H.status_flags & FAKEDEATH)
			pulse_result = SPAN_DANGER("0")
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
		if(H.pulse() == PULSE_NONE)
			pulse_result = SPAN_SCAN_DANGER("[pulse_result] BPM")
		else if(H.pulse() < PULSE_NORM)
			pulse_result = SPAN_SCAN_NOTICE("[pulse_result] BPM")
		else if(H.pulse() > PULSE_NORM)
			pulse_result = SPAN_SCAN_WARNING("[pulse_result] BPM")
		else
			pulse_result = SPAN_SCAN_GREEN("[pulse_result] BPM")
	else
		pulse_result = SPAN_SCAN_DANGER("0")
	dat += "Pulse rate: [pulse_result]"

	// Body temperature. Rounds to one digit after decimal.
	var/temperature_string
	if(H.bodytemperature < H.species.cold_level_1 || H.bodytemperature > H.species.heat_level_1)
		temperature_string = "Body temperature: [SPAN_SCAN_WARNING("[round(H.bodytemperature-T0C, 0.1)]&deg;C ([round(H.bodytemperature*1.8-459.67, 0.1)]&deg;F")]"
	else
		temperature_string = "Body temperature: [SPAN_SCAN_GREEN("[round(H.bodytemperature-T0C, 0.1)]&deg;C ([round(H.bodytemperature*1.8-459.67, 0.1)]&deg;F)")]"
	dat += temperature_string

	// Blood pressure and blood type. Based on the idea of a normal blood pressure being 120 over 80.
	if(H.should_have_organ(BP_HEART))
		var/blood_pressure_string
		switch(H.get_blood_pressure_alert())
			if(1)
				blood_pressure_string = SPAN_SCAN_DANGER("[H.get_blood_pressure()]")
			if(2)
				blood_pressure_string = SPAN_SCAN_GREEN("[H.get_blood_pressure()]")
			if(3)
				blood_pressure_string = SPAN_SCAN_WARNING("[H.get_blood_pressure()]")
			if(4)
				blood_pressure_string = SPAN_SCAN_DANGER("[H.get_blood_pressure()]")

		var/blood_volume_string = SPAN_SCAN_GREEN("\>[BLOOD_VOLUME_SAFE]%")
		switch(H.get_blood_volume())
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				blood_volume_string = SPAN_SCAN_NOTICE("\<[BLOOD_VOLUME_SAFE]%")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_OKAY)
				blood_volume_string = SPAN_SCAN_WARNING("\<[BLOOD_VOLUME_OKAY]%")
			if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
				blood_volume_string = SPAN_SCAN_DANGER("\<[BLOOD_VOLUME_SURVIVE]%")

		var/oxygenation = H.get_blood_oxygenation()
		var/oxygenation_string = SPAN_SCAN_GREEN("[oxygenation]%")
		switch(oxygenation)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				oxygenation_string = SPAN_SCAN_NOTICE("[oxygenation]%")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_OKAY)
				oxygenation_string = SPAN_SCAN_WARNING("[oxygenation]%")
			if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
				oxygenation_string = SPAN_SCAN_DANGER("[oxygenation]%")
		if(H.status_flags & FAKEDEATH)
			oxygenation_string = SPAN_SCAN_DANGER("[rand(0,10)]%")
		dat += "Blood pressure: [blood_pressure_string]"
		dat += "Blood oxygenation: [oxygenation_string]"
		dat += "Blood volume: [blood_volume_string]"
		dat += "Blood type: [SPAN_SCAN_GREEN("[H.dna.b_type]")]"
	else
		dat += "Blood pressure: N/A"

	// Traumatic shock.
	if(H.is_asystole() || (H.status_flags & FAKEDEATH))
		dat += SPAN_SCAN_DANGER("Cardiovascular shock detected. Administer CPR immediately.")
	else if(H.shock_stage > 80)
		dat += SPAN_SCAN_WARNING("Imminent cardiovascular shock. Pain relief recommended.")

	if(H.getOxyLoss() > 50)
		dat += SPAN_SCAN_BLUE("[b]Severe oxygen deprivation detected.[endb]")
	if(H.getToxLoss() > 50)
		dat += SPAN_SCAN_ORANGE("[b]Major systemic organ failure detected.[endb]")
	if(H.getFireLoss() > 50)
		dat += SPAN_SCAN_ORANGE("[b]Severe burn damage detected.[endb]")
	if(H.getBruteLoss() > 50)
		dat += SPAN_SCAN_RED("[b]Severe anatomical damage detected.[endb]")

	if(device_level >= 2)
		var/list/damaged = H.get_damaged_organs(1,1)
		if(damaged.len)
			for(var/obj/item/organ/external/org in damaged)
				var/limb_result = "[capitalize(org.name)][BP_IS_ROBOTIC(org) ? " (Cybernetic)" : ""]:"
				if(org.brute_dam > 0)
					limb_result = "[limb_result] [SPAN_SCAN_DANGER("[get_wound_severity(org.brute_dam, (org.limb_flags & ORGAN_HEALS_OVERKILL), TRUE)] physical trauma")]"
				if(org.burn_dam > 0)
					limb_result = "[limb_result] [SPAN_SCAN_ORANGE_DANGER("[get_wound_severity(org.burn_dam, (org.limb_flags & ORGAN_HEALS_OVERKILL), TRUE)] burns")]"
				if(org.status & ORGAN_BLEEDING)
					limb_result = "[limb_result] [SPAN_SCAN_DANGER("bleeding")]"
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

	if(device_level >= 3)
		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(!e)
				continue
			var/limb = e.name
			if(e.status & ORGAN_BROKEN)
				if(((e.name == BP_L_ARM) || (e.name == BP_R_ARM) || (e.name == BP_L_LEG) || (e.name == BP_R_LEG)) && !(e.status & ORGAN_SPLINTED))
					dat += SPAN_SCAN_WARNING("Unsecured fracture in subject [limb]. Splinting recommended for transport.")

		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(e && e.status & ORGAN_BROKEN)
				dat += SPAN_SCAN_WARNING("Bone fractures detected. Advanced scanner required for location.")
				break

	if(device_level >= 4)
		var/found_bleed
		var/found_tendon
		var/found_disloc
		for(var/obj/item/organ/external/e in H.organs)
			if(e)
				if(!found_disloc && e.dislocated == 2)
					dat += SPAN_SCAN_WARNING("Dislocation detected. Advanced scanner required for location.")
					found_disloc = TRUE
				if(!found_bleed && (e.status & ORGAN_ARTERY_CUT))
					dat += SPAN_SCAN_WARNING("Arterial bleeding detected. Advanced scanner required for location.")
					found_bleed = TRUE
				if(!found_tendon && (e.tendon_status() & TENDON_CUT))
					dat += SPAN_SCAN_WARNING("Tendon or ligament damage detected. Advanced scanner required for location.")
					found_tendon = TRUE
			if(found_disloc && found_bleed && found_tendon)
				break

	scan_results += dat
	dat = list()

	// Reagent data.
	. += "[b]Reagent scan:[endb]"

	var/print_reagent_default_message = TRUE

	if(device_level >= 3)
		if(H.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			for(var/_R in H.reagents.reagent_volumes)
				var/singleton/reagent/R = GET_SINGLETON(_R)
				if(R.scannable)
					print_reagent_default_message = FALSE
					reagentdata["[_R]"] = SPAN_NOTICE("    [round(REAGENT_VOLUME(H.reagents, _R), 1)]u [R.name]")
				else
					unknown++
			if(reagentdata.len)
				print_reagent_default_message = FALSE
				dat += SPAN_NOTICE("Beneficial reagents detected in subject's blood:")
				for(var/d in reagentdata)
					dat += reagentdata[d]
			if(unknown)
				print_reagent_default_message = FALSE
				dat += SPAN_WARNING("Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.")

	if(device_level >= 4)
		var/datum/reagents/ingested = H.get_ingested_reagents()
		if(ingested && ingested.total_volume)
			var/unknown = 0
			for(var/_R in ingested.reagent_volumes)
				var/singleton/reagent/R = GET_SINGLETON(_R)
				if(R.scannable)
					print_reagent_default_message = FALSE
					dat += SPAN_NOTICE("[R.name] found in subject's stomach.")
				else
					++unknown
			if(unknown)
				print_reagent_default_message = FALSE
				dat +=  SPAN_WARNING("Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.")

	if(print_reagent_default_message)
		dat += "No results."

	reagent_results += dat
	ui_interact(user)

#undef SPAN_SCAN_GREEN
#undef SPAN_SCAN_BLUE
#undef SPAN_SCAN_ORANGE
#undef SPAN_SCAN_ORANGE_DANGER
#undef SPAN_SCAN_RED
#undef SPAN_SCAN_NOTICE
#undef SPAN_SCAN_WARNING
#undef SPAN_SCAN_DANGER
