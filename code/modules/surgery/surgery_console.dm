/**
 * Surgical planner backend for the patient monitoring console.
 *
 * The planner not call surgery_step/can_use() while TGUI data is being generated.
 */

/datum/surgery_planner
	var/static/list/target_zones = list(
		BP_HEAD,
		BP_EYES,
		BP_MOUTH,
		BP_CHEST,
		BP_GROIN,
		BP_L_ARM,
		BP_R_ARM,
		BP_L_HAND,
		BP_R_HAND,
		BP_L_LEG,
		BP_R_LEG,
		BP_L_FOOT,
		BP_R_FOOT
	)
	/// display data keyed by surgery-step type. Built once on demand.
	var/static/list/surgery_planner_step_metadata = list()

/obj/structure/machinery/computer/operating/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SurgeryPlanner", "Zeng-Hu Pharmaceuticals Surgical Theater", 1050, 700)
		ui.open()

/obj/structure/machinery/computer/operating/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	switch(action)
		if("select_zone")
			var/new_zone = params["zone"]
			if(!(new_zone in surgery_planner.target_zones))
				return
			if(!user?.zone_sel)
				return

			// Keep the normal BYOND targeting HUD in sync with the TGUI doll.
			user.zone_sel.set_selected_zone(new_zone, user)
			return TRUE

		if("open_scanner")
			if(embedded_scanner)
				embedded_scanner.ui_interact(user)
			return TRUE

		if("eject_primer")
			if(use_check(user))
				return
			return eject_surgery_primer(user)

/obj/structure/machinery/computer/operating/ui_data(mob/user)
	var/selected_zone = BP_CHEST
	if(user?.zone_sel && (user.zone_sel.selecting in surgery_planner.target_zones))
		selected_zone = user.zone_sel.selecting

	var/mob/living/carbon/human/patient = table?.get_valid_occupant()

	// the inserted medscan only validates that this patient was scanned.
	// Once validated, diagnostics reflect the patient's current condition,
	var/scan_primer_matches = FALSE
	var/scan_primer_subject = null
	var/scan_primer_time = null
	if(primer)
		var/atom/primer_scan_target = primer.scan_target?.resolve()
		scan_primer_subject = primer.scan_subject_name || primer_scan_target?.name
		scan_primer_time = primer.scan_time
		if(patient)
			scan_primer_matches = primer_scan_target == patient

	var/list/scan_findings = list()
	if(scan_primer_matches)
		scan_findings = get_surgery_scan_findings(patient)

	var/list/data = list(
		"has_table" = !!table,
		"has_patient" = !!patient,
		"patient_is_ipc" = isipc(patient),
		"patient_name" = null,
		"patient_species" = null,
		"selected_zone" = selected_zone,
		"selected_zone_name" = surgery_planner.surgery_zone_display_name(selected_zone),
		"area_state" = "No patient",
		"area_open_state" = "Unknown",
		"selected_zone_robotic" = FALSE,
		"scan_primer_loaded" = !!primer,
		"scan_primer_matches" = scan_primer_matches,
		"scan_primer_subject" = scan_primer_subject,
		"scan_primer_time" = scan_primer_time,
		"zones" = surgery_planner.get_surgery_zone_data(patient, scan_findings),
		"procedures" = list()
	)

	var/list/monitor_data = embedded_scanner.ui_data(user)
	for(var/key in monitor_data)
		data[key] = monitor_data[key]

	if(isipc(patient))
		data["invalid"] = TRUE
		data["ipc"] = TRUE
		return data

	if(!patient)
		return data

	data["patient_name"] = patient.name
	data["patient_species"] = patient.get_species()

	var/obj/item/organ/external/affected = patient.get_organ(selected_zone)
	if(!affected)
		data["area_state"] = "Missing"
		data["area_open_state"] = "No external organ present"
	else
		data["area_state"] = BP_IS_ROBOTIC(affected) ? "Robotic" : "Organic"
		data["selected_zone_robotic"] = !!BP_IS_ROBOTIC(affected)
		data["area_open_state"] = surgery_planner.get_surgery_open_state(patient, affected, selected_zone)

	if(scan_primer_matches && (!affected || !BP_IS_ROBOTIC(affected)))
		data["procedures"] = surgery_planner.get_surgery_guide_steps(
			user,
			patient,
			selected_zone,
			list(SURGERY_SKILL_COMPONENT, XENOBIOLOGY_SKILL_COMPONENT)
		)
	return data

/datum/surgery_planner/proc/get_surgery_zone_data(mob/living/carbon/human/patient, list/scan_findings)
	var/list/zones = list()

	for(var/zone in target_zones)
		var/obj/item/organ/external/affected = patient?.get_organ(zone)
		var/list/zone_scan
		if(scan_findings)
			zone_scan = scan_findings[zone]

		zones += list(list(
			"id" = zone,
			"label" = surgery_zone_display_name(zone),
			"known" = !!patient,
			"present" = !!affected,
			"robotic" = affected ? !!BP_IS_ROBOTIC(affected) : FALSE,
			"scan_severity" = zone_scan ? zone_scan["severity"] : 0,
			"scan_findings" = zone_scan ? zone_scan["findings"] : list()
		))

	return zones

/**
 * This proc must only be called after the inserted medscan has been verified
 * to belong to the patient currently on the operating table.
 */
/obj/structure/machinery/computer/operating/proc/get_surgery_scan_findings(mob/living/carbon/human/patient)
	var/list/zones = list()

	if(!patient)
		return zones

	for(var/obj/item/organ/external/O in patient.organs)
		var/zone = O.limb_name
		if(!zone)
			continue

		var/list/zone_data = get_or_create_surgery_scan_zone(zones, zone)

		var/brute_damage = get_wound_severity(LIMB_GET_BRUTE_DAMAGE(O), (O.limb_flags & ORGAN_HEALS_OVERKILL), TRUE)
		var/brute_severity = get_surgery_scan_damage_severity(brute_damage)
		if(brute_severity)
			add_surgery_scan_finding(zone_data, "Brute trauma: [brute_damage]", brute_severity)

		var/burn_damage = get_wound_severity(LIMB_GET_BURN_DAMAGE(O), (O.limb_flags & ORGAN_HEALS_OVERKILL), TRUE)
		var/burn_severity = get_surgery_scan_damage_severity(burn_damage)
		if(burn_severity)
			add_surgery_scan_finding(zone_data, "Burn trauma: [burn_damage]", burn_severity)

		if(O.status & ORGAN_ARTERY_CUT)
			add_surgery_scan_finding(zone_data, "Severed [O.artery_name]", 4)

		if(O.tendon_status() & TENDON_CUT)
			add_surgery_scan_finding(zone_data, "Severed [O.tendon.name]", 3)

		if(O.status & ORGAN_BLEEDING)
			add_surgery_scan_finding(zone_data, "Active bleeding", 3)

		if(ORGAN_IS_DISLOCATED(O))
			add_surgery_scan_finding(zone_data, "Dislocated", 2)

		if(O.status & ORGAN_BROKEN)
			add_surgery_scan_finding(zone_data, capitalize_first_letters(O.broken_description), 3)

		if(O.status & ORGAN_SPLINTED)
			add_surgery_scan_finding(zone_data, "Splinted", 1)

		if(O.open)
			add_surgery_scan_finding(zone_data, "Open surgical site", 1)

		if(O.germ_level && embedded_scanner)
			var/external_infection = embedded_scanner.get_infection_level(O.germ_level)
			if(length(external_infection))
				add_surgery_scan_finding(
					zone_data,
					"Immune status: [external_infection]",
					get_surgery_scan_infection_severity(external_infection)
				)

		if(O.rejecting)
			add_surgery_scan_finding(zone_data, "Tissue rejection", 3)

		if(O.CheckNeedsAmputation())
			add_surgery_scan_finding(zone_data, "Amputation recommended", 4)

		if(length(O.implants))
			var/unknown_objects = 0
			var/abnormal_organic_bodies = 0

			for(var/atom/movable/object_in_organ in O.implants)
				if(istype(object_in_organ, /obj/item/implant))
					var/obj/item/implant/implant_in_organ = object_in_organ
					if(implant_in_organ.hidden)
						continue

					if(implant_in_organ.known)
						add_surgery_scan_finding(
							zone_data,
							"[capitalize_first_letters(implant_in_organ.name)] installed",
							1
						)
					else
						unknown_objects++
					continue

				if(istype(object_in_organ, /obj/effect/spider))
					abnormal_organic_bodies++
				else
					unknown_objects++

			if(unknown_objects)
				add_surgery_scan_finding(
					zone_data,
					"[unknown_objects] unknown object(s) present",
					2
				)

			if(abnormal_organic_bodies)
				add_surgery_scan_finding(
					zone_data,
					abnormal_organic_bodies > 1 ? "Multiple abnormal organic bodies" : "Abnormal organic body",
					3
				)

	for(var/obj/item/organ/internal/I in patient.internal_organs)
		var/zone = I.parent_organ
		if(!zone)
			continue

		var/list/zone_data = get_or_create_surgery_scan_zone(zones, zone)

		var/internal_damage = embedded_scanner.get_internal_damage(I)
		if(istype(I, /obj/item/organ/internal/brain) && (patient.status_flags & FAKEDEATH))
			internal_damage = "Severe"
		var/internal_severity = get_surgery_scan_damage_severity(internal_damage)
		if(internal_severity)
			add_surgery_scan_finding(
				zone_data,
				"[capitalize_first_letters(I.name)]: [internal_damage] damage",
				internal_severity
			)

		if(I.is_broken())
			add_surgery_scan_finding(
				zone_data,
				"[capitalize_first_letters(I.name)]: Broken",
				3
			)
		else if(I.is_bruised())
			add_surgery_scan_finding(
				zone_data,
				"[capitalize_first_letters(I.name)]: Bruised",
				2
			)

		if(istype(I, /obj/item/organ/internal/lungs))
			var/obj/item/organ/internal/lungs/L = I
			if(L.rescued)
				add_surgery_scan_finding(zone_data, "Lungs: Punctured", 3)

		if(istype(I, /obj/item/organ/internal/appendix))
			var/obj/item/organ/internal/appendix/A = I
			if(A.inflamed)
				add_surgery_scan_finding(zone_data, "Appendix: Inflamed", 2)

		if(istype(I, /obj/item/organ/internal/parasite))
			var/obj/item/organ/internal/parasite/P = I
			if(P.stage)
				add_surgery_scan_finding(
					zone_data,
					"[capitalize_first_letters(P.name)]: Stage [P.stage]",
					P.stage >= 4 ? 4 : 3
				)

			if(istype(P, /obj/item/organ/internal/parasite/malignant_tumour) && P.stage >= 4)
				add_surgery_scan_finding(zone_data, "Malignant growth: Metastasising", 4)

		if(I.status & ORGAN_DEAD)
			var/necrosis_state = I.can_recover() ? "debridable" : "dead"
			add_surgery_scan_finding(
				zone_data,
				"[capitalize_first_letters(I.name)]: Necrotic; [necrosis_state]",
				4
			)

		if(istype(I, patient.species.vision_organ))
			if(patient.sdisabilities & BLIND)
				add_surgery_scan_finding(zone_data, "Vision organ: Cataracts", 2)
			else if(patient.disabilities & NEARSIGHTED)
				add_surgery_scan_finding(zone_data, "Vision organ: Misaligned retinas", 1)

		if(istype(I, /obj/item/organ/internal/brain) && patient.has_brain_worms())
			add_surgery_scan_finding(zone_data, "Brain: Abnormal growth", 3)

		if(I.germ_level && embedded_scanner)
			var/internal_infection = embedded_scanner.get_infection_level(I.germ_level)
			if(length(internal_infection))
				add_surgery_scan_finding(
					zone_data,
					"[capitalize_first_letters(I.name)] immune status: [internal_infection]",
					get_surgery_scan_infection_severity(internal_infection)
				)

		if(I.rejecting)
			add_surgery_scan_finding(
				zone_data,
				"[capitalize_first_letters(I.name)]: Rejection",
				3
			)

		if(I.get_scarring_level() > 0.01)
			add_surgery_scan_finding(
				zone_data,
				"[capitalize_first_letters(I.name)]: [I.get_scarring_results()]",
				1
			)

	return zones

/obj/structure/machinery/computer/operating/proc/get_or_create_surgery_scan_zone(list/zones, zone)
	var/list/zone_data = zones[zone]

	if(!zone_data)
		zone_data = list(
			"severity" = 0,
			"findings" = list()
		)
		zones[zone] = zone_data

	return zone_data

/obj/structure/machinery/computer/operating/proc/add_surgery_scan_finding(list/zone_data, finding, severity)
	if(!zone_data || !length(finding))
		return

	var/list/findings = zone_data["findings"]
	findings += finding
	zone_data["severity"] = max(zone_data["severity"], severity)

/obj/structure/machinery/computer/operating/proc/get_surgery_scan_damage_severity(value)
	switch(lowertext("[value]"))
		if("", "none", "healthy")
			return 0
		if("minor")
			return 1
		if("moderate", "significant")
			return 2
		if("severe", "extreme")
			return 3
		if("critical", "irreparable")
			return 4

	return 1

/obj/structure/machinery/computer/operating/proc/get_surgery_scan_infection_severity(value)
	var/text = lowertext("[value]")

	if(findtext(text, "shock"))
		return 4
	if(findtext(text, "severe"))
		return 3
	if(findtext(text, "sepsis"))
		return 2

	return 1

/datum/surgery_planner/proc/get_surgery_guide_steps(mob/user, mob/living/carbon/human/patient, target_zone, list/allowed_skill_components)
	var/list/results = list()

	// Match do_surgery(): nobody can start another surgery on this zone while
	// an operation is already in progress there.
	if(target_zone in patient.op_stage.in_progress)
		return results

	// Match do_surgery(): one surgeon cannot operate on multiple zones at once.
	for(var/surgery_zone in patient.op_stage.in_progress)
		if(patient.op_stage.in_progress[surgery_zone] == user)
			return results

	var/list/all_surgeries = GET_SINGLETON_SUBTYPE_MAP(/singleton/surgery_step)

	// These signal-based modifiers depend on the surgeon and patient, rather
	// than the individual step. Query them once and apply the result to every
	// procedure below, in the same order used by do_surgery().
	var/success_modifier = 0
	var/duration_multiplier = 1
	SEND_SIGNAL(user, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, patient, &success_modifier, &duration_multiplier)

	for(var/decl in all_surgeries)
		var/singleton/surgery_step/S = all_surgeries[decl]

		if(!length(S.allowed_tools))
			continue
		if(!S.is_valid_target(patient))
			continue
		if(!S.can_show_in_surgery_planner(user, patient, target_zone))
			continue
		var/list/effective_skill_requirements
		if(length(allowed_skill_components))
			for(var/allowed_skill_component in allowed_skill_components)
				effective_skill_requirements = S.get_surgery_skill_requirements(user, patient, target_zone, allowed_skill_component)
				if(length(effective_skill_requirements))
					break
		else
			effective_skill_requirements = S.get_surgery_skill_requirements(user, patient, target_zone)
		if(!length(effective_skill_requirements))
			continue

		var/list/metadata = get_surgery_step_metadata(S)
		if(!metadata)
			continue

		results += list(get_surgery_step_viewer_data(user, S, metadata, success_modifier, duration_multiplier, effective_skill_requirements))

	return results

/**
 * Equivalent to IS_ORGAN_FULLY_OPEN, but safe to use from a generic helper
 * without relying on a local variable named "affected".
 */
/proc/surgery_planner_fully_open(obj/item/organ/external/affected)
	if(!affected)
		return FALSE

	return affected.open == ((affected.encased || affected.robotic) \
		? ORGAN_ENCASED_RETRACTED \
		: ORGAN_OPEN_RETRACTED)

// ---------------------------------------------------------------------------
// TGUI data helpers
// ---------------------------------------------------------------------------

/datum/surgery_planner/proc/get_surgery_tool_data(list/allowed_tools)
	var/list/tools = list()

	for(var/tool_type in allowed_tools)
		var/tool_name = null
		var/tool_path = null

		if(ispath(tool_type, /obj/item))
			tool_path = "[tool_type]"
		else
			tool_name = "[tool_type]"

		tools += list(list(
			"name" = tool_name,
			"path" = tool_path,
			"suitability" = allowed_tools[tool_type]
		))

	return tools

/datum/surgery_planner/proc/get_surgery_step_metadata(singleton/surgery_step/S)
	var/list/metadata = surgery_planner_step_metadata[S.type]
	if(metadata)
		return metadata

	var/display_name = get_surgery_step_display_name(S)
	if(!display_name)
		return null

	metadata = list(
		"id" = "[S.type]",
		"name" = display_name,
		"category" = get_surgery_step_category(S),
		"tools" = get_surgery_tool_data(S.allowed_tools),
		"tool_note" = get_surgery_tool_note(S)
	)
	surgery_planner_step_metadata[S.type] = metadata
	return metadata

/datum/surgery_planner/proc/get_surgery_step_viewer_data(mob/user, singleton/surgery_step/S, list/metadata, success_modifier, duration_multiplier, list/effective_skill_requirements)
	var/list/viewer_data = metadata.Copy()
	var/skill_modifier = success_modifier
	var/list/skill_names = list()

	for(var/skill_component, required_level in effective_skill_requirements)
		var/skill_level = GET_SKILL_LEVEL(user, skill_component)
		if(!isnull(skill_level))
			skill_modifier += (skill_level - required_level) * S.skill_diff_fail_modifier
		skill_names |= get_surgery_skill_name(skill_component)

	var/list/viewer_tools = list()
	for(var/list/tool_data as anything in metadata["tools"])
		var/list/viewer_tool = tool_data.Copy()
		viewer_tool["success_chance"] = round(clamp(tool_data["suitability"] + skill_modifier, 0, 100), 0.1)
		viewer_tools += list(viewer_tool)

	viewer_data["tools"] = viewer_tools
	viewer_data["skills"] = skill_names
	viewer_data["estimated_time"] = round((S.base_surgery_time / 10) * duration_multiplier, 0.1)
	return viewer_data

/datum/surgery_planner/proc/get_surgery_skill_name(skill_component)
	switch(skill_component)
		if(SURGERY_SKILL_COMPONENT)
			return "Surgery"
		if(ROBOTICS_SKILL_COMPONENT)
			return "Robotics"
		if(XENOBIOLOGY_SKILL_COMPONENT)
			return "Xenobiology"
	return "Unspecified skill"

/datum/surgery_planner/proc/get_surgery_tool_note(singleton/surgery_step/S)
	if(istype(S, /singleton/surgery_step/cavity/place_item))
		return "The item must fit in the remaining cavity space."
	if(istype(S, /singleton/surgery_step/limb/attach))
		return "The donor limb and its parent connection must be compatible."
	if(istype(S, /singleton/surgery_step/limb/mechanize))
		return "The prosthetic assembly must contain the selected body part."
	if(istype(S, /singleton/surgery_step/robotics/install_mmi))
		return "The MMI must contain a living, client-controlled brain."
	if(istype(S, /singleton/surgery_step/treat_necrosis))
		return "The selected reagent container must contain peridaxon."

	return ""

/datum/surgery_planner/proc/get_surgery_step_display_name(singleton/surgery_step/S)
	if(S.name)
		return S.name

	// These current facial steps do not define names on their datums.
	if(istype(S, /singleton/surgery_step/generic/cut_face))
		return "Make Facial Incision"

	if(istype(S, /singleton/surgery_step/generic/prepare_face))
		return "Retract Facial Incision"

	if(istype(S, /singleton/surgery_step/robotics/face/synthskin))
		return "Make Synthskin Facial Incision"

	return null

/datum/surgery_planner/proc/get_surgery_step_category(singleton/surgery_step/S)
	if(istype(S, /singleton/surgery_step/generic/cut_face) \
		|| istype(S, /singleton/surgery_step/generic/prepare_face) \
		|| istype(S, /singleton/surgery_step/generic/alter_face) \
		|| istype(S, /singleton/surgery_step/face) \
		|| istype(S, /singleton/surgery_step/robotics/face))
		return "Facial"

	if(istype(S, /singleton/surgery_step/robotics))
		return "Robotic"

	if(istype(S, /singleton/surgery_step/internal))
		return "Internal"

	if(istype(S, /singleton/surgery_step/open_encased))
		return "Encased"

	if(istype(S, /singleton/surgery_step/cavity))
		return "Cavity"

	if(istype(S, /singleton/surgery_step/limb))
		return "Limb"

	if(istype(S, /singleton/surgery_step/generic))
		return "Incision"

	if(istype(S, /singleton/surgery_step/glue_bone) \
		|| istype(S, /singleton/surgery_step/set_bone) \
		|| istype(S, /singleton/surgery_step/mend_skull) \
		|| istype(S, /singleton/surgery_step/finish_bone))
		return "Bone"

	if(istype(S, /singleton/surgery_step/fix_vein) \
		|| istype(S, /singleton/surgery_step/fix_tendon) \
		|| istype(S, /singleton/surgery_step/treat_necrosis))
		return "Trauma"

	if(istype(S, /singleton/surgery_step/amputate))
		return "Amputation"

	if(istype(S, /singleton/surgery_step/hardsuit))
		return "Equipment"

	return "Surgery"

/datum/surgery_planner/proc/get_surgery_open_state(mob/living/carbon/human/patient, obj/item/organ/external/affected, target_zone)
	if(!patient || !affected)
		return "No external organ present"

	if(target_zone == BP_MOUTH)
		switch(patient.op_stage.face)
			if(FACE_NORMAL)
				return "Face intact"
			if(FACE_CUT_OPEN)
				return "Facial incision open"
			if(FACE_RETRACTED)
				return "Facial incision retracted"
			if(FACE_ALTERED)
				return "Facial alteration complete"
		return "Unknown facial stage"

	switch(affected.open)
		if(ORGAN_CLOSED)
			return BP_IS_ROBOTIC(affected) ? "Hatch closed" : "Closed"
		if(ORGAN_OPEN_INCISION)
			return BP_IS_ROBOTIC(affected) ? "Hatch unscrewed" : "Incision made"
		if(ORGAN_OPEN_RETRACTED)
			return BP_IS_ROBOTIC(affected) ? "Hatch access prepared" : "Incision retracted"
		if(ORGAN_ENCASED_OPEN)
			return BP_IS_ROBOTIC(affected) ? "Hatch open" : "Encasing opened"
		if(ORGAN_ENCASED_RETRACTED)
			return BP_IS_ROBOTIC(affected) ? "Hatch fully open" : "Encasing retracted"

	return "Unknown"

/datum/surgery_planner/proc/surgery_zone_display_name(zone)
	switch(zone)
		if(BP_HEAD)
			return "Head"
		if(BP_EYES)
			return "Eyes"
		if(BP_MOUTH)
			return "Mouth / Face"
		if(BP_CHEST)
			return "Chest"
		if(BP_GROIN)
			return "Groin"
		if(BP_L_ARM)
			return "Left Arm"
		if(BP_R_ARM)
			return "Right Arm"
		if(BP_L_HAND)
			return "Left Hand"
		if(BP_R_HAND)
			return "Right Hand"
		if(BP_L_LEG)
			return "Left Leg"
		if(BP_R_LEG)
			return "Right Leg"
		if(BP_L_FOOT)
			return "Left Foot"
		if(BP_R_FOOT)
			return "Right Foot"

	return "[zone]"
