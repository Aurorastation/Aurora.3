/datum/computer_file/program/robotics
	filename = "robotics"
	filedesc = "Robotics Interface"
	program_icon_state = "ai-fixer-empty"
	program_key_icon_state = "teal_key"
	extended_desc = "A program made to interface with positronics and prosthetic systems."
	size = 14
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_run = list(ACCESS_RESEARCH, ACCESS_ROBOTICS)
	required_access_download = list(ACCESS_RESEARCH, ACCESS_ROBOTICS)
	available_on_ntnet = FALSE
	tgui_id = "RoboticsComputer"
	var/datum/tgui_module/ipc_diagnostic/diagnostic
	var/datum/surgery_planner/surgery_planner

/datum/computer_file/program/robotics/Destroy()
	QDEL_NULL(diagnostic)
	QDEL_NULL(surgery_planner)
	return ..()

/datum/computer_file/program/robotics/proc/get_access_cable_target()
	return computer?.access_cable_dongle?.access_cable?.target

/** IPC ports expose the chassis; prosthetic sockets and service jacks authenticate their wearer. */
/datum/computer_file/program/robotics/proc/get_connected_patient()
	var/obj/connected = get_access_cable_target()
	if(istype(connected, /obj/item/organ/internal/machine/access_port))
		var/obj/item/organ/internal/machine/access_port/port = connected
		if(isipc(port.owner))
			return port.owner
	if(istype(connected, /obj/item/organ/external))
		var/obj/item/organ/external/prosthetic = connected
		if(BP_IS_ROBOTIC(prosthetic) && ishuman(prosthetic.owner))
			return prosthetic.owner
	if(istype(connected, /obj/item/organ/internal/augment/service_jack))
		var/obj/item/organ/internal/augment/service_jack/service_jack = connected
		if(!service_jack.is_broken() && ishuman(service_jack.owner))
			return service_jack.owner

/datum/computer_file/program/robotics/proc/get_connected_prosthetic()
	var/obj/item/organ/external/prosthetic = get_access_cable_target()
	if(istype(prosthetic) && BP_IS_ROBOTIC(prosthetic) && ishuman(prosthetic.owner))
		return prosthetic

/datum/computer_file/program/robotics/proc/get_connected_service_jack()
	var/obj/item/organ/internal/augment/service_jack/service_jack = get_access_cable_target()
	if(istype(service_jack) && !service_jack.is_broken() && ishuman(service_jack.owner))
		return service_jack

/datum/computer_file/program/robotics/proc/get_planner()
	if(!surgery_planner)
		surgery_planner = new
	return surgery_planner

/datum/computer_file/program/robotics/proc/get_patient_prosthetics(mob/living/carbon/human/patient)
	var/list/prosthetics = list()
	for(var/zone in patient.organs_by_name)
		var/obj/item/organ/external/prosthetic = patient.organs_by_name[zone]
		if(prosthetic && BP_IS_ROBOTIC(prosthetic))
			prosthetics |= prosthetic
	return prosthetics

/**
 * Returns whether an internal organ has components the Robotics Interface can
 * service. This includes assisted organs, which are also visible to the patient monitor.
 */
/datum/computer_file/program/robotics/proc/is_mechatronic_internal_organ(obj/item/organ/internal/organ)
	return organ && ((organ.status & (ORGAN_ROBOT | ORGAN_ASSISTED)) || organ.robotic >= ROBOTIC_ASSISTED)

/datum/computer_file/program/robotics/proc/get_damage_severity(damage, maximum)
	if(damage <= 0)
		return 0
	var/damage_ratio = damage / max(1, maximum)
	if(damage_ratio >= 0.75)
		return 4
	if(damage_ratio >= 0.5)
		return 3
	if(damage_ratio >= 0.25)
		return 2
	return 1

/datum/computer_file/program/robotics/proc/get_integrity_severity(integrity)
	if(integrity >= 100)
		return 0
	if(integrity <= 25)
		return 4
	if(integrity <= 50)
		return 3
	if(integrity <= 75)
		return 2
	return 1

/datum/computer_file/program/robotics/proc/get_severity_label(severity)
	switch(severity)
		if(4)
			return "Critical"
		if(3)
			return "Severe"
		if(2)
			return "Moderate"
		if(1)
			return "Minor"
	return "Nominal"

/datum/computer_file/program/robotics/proc/get_patient_prosthetic_zones(mob/living/carbon/human/patient)
	var/list/zones = list()
	var/list/prosthetics = get_patient_prosthetics(patient)
	for(var/obj/item/organ/external/prosthetic as anything in prosthetics)
		zones |= prosthetic.limb_name
	for(var/obj/item/organ/internal/organ in patient.internal_organs)
		if(is_mechatronic_internal_organ(organ) && patient.get_organ(organ.parent_organ))
			zones |= organ.parent_organ
	return zones

/datum/computer_file/program/robotics/proc/get_synthetic_scan_findings(mob/living/carbon/human/patient, obj/item/organ/external/connected_prosthetic, list/limb_diagnostics, list/organ_diagnostics)
	var/list/findings_by_zone = list()
	for(var/list/limb_data in limb_diagnostics)
		var/obj/item/organ/external/limb
		for(var/obj/item/organ/external/candidate in patient.organs)
			if(candidate.name == limb_data["name"])
				limb = candidate
				break
		if(!limb && connected_prosthetic?.name == limb_data["name"])
			limb = connected_prosthetic
		if(!limb?.limb_name)
			continue

		var/brute_damage = max(0, limb_data["brute_damage"])
		var/burn_damage = max(0, limb_data["burn_damage"])
		var/list/foreign_bodies = limb_data["foreign_bodies"]
		if(!brute_damage && !burn_damage && !length(foreign_bodies))
			continue

		var/max_damage = max(1, limb_data["max_damage"])
		var/brute_severity = get_damage_severity(brute_damage, max_damage)
		var/burn_severity = get_damage_severity(burn_damage, max_damage)
		var/severity = max(brute_severity, burn_severity)

		var/list/limb_findings = list()
		if(brute_damage)
			limb_findings += "Impact damage: [get_severity_label(brute_severity)]"
		if(burn_damage)
			limb_findings += "Thermal damage: [get_severity_label(burn_severity)]"
		for(var/foreign_body_finding in foreign_bodies)
			var/foreign_body_severity = 1
			if(findtext(lowertext(foreign_body_finding), "abnormal organic"))
				foreign_body_severity = 3
			else if(findtext(lowertext(foreign_body_finding), "unknown object"))
				foreign_body_severity = 2
			severity = max(severity, foreign_body_severity)
			limb_findings += capitalize_first_letters(foreign_body_finding)
		findings_by_zone[limb.limb_name] = list(
			"severity" = severity,
			"findings" = limb_findings
		)

	for(var/list/organ_data in organ_diagnostics)
		var/zone = organ_data["parent_organ"]
		if(!zone)
			continue

		var/list/organ_findings = list()
		var/organ_severity = 0
		var/organ_name = capitalize_first_letters(organ_data["name"])
		var/organ_damage = max(0, organ_data["damage"])
		var/organ_max_damage = max(1, organ_data["max_damage"])
		if(organ_damage)
			organ_severity = get_damage_severity(organ_damage, organ_max_damage)
			organ_findings += "[organ_name] damage: [get_severity_label(organ_severity)]"

		for(var/status_key in list("wiring_status", "plating_status", "electronics_status"))
			var/integrity = organ_data[status_key]
			if(isnull(integrity) || integrity >= 100)
				continue
			var/status_severity = get_integrity_severity(integrity)
			organ_severity = max(organ_severity, status_severity)
			var/status_name = replacetext(status_key, "_status", "")
			organ_findings += "[organ_name] [status_name] damage: [get_severity_label(status_severity)]"

		if(!length(organ_findings))
			continue
		var/list/zone_findings = findings_by_zone[zone]
		if(!zone_findings)
			zone_findings = list("severity" = 0, "findings" = list())
			findings_by_zone[zone] = zone_findings
		zone_findings["severity"] = max(zone_findings["severity"], organ_severity)
		var/list/existing_findings = zone_findings["findings"]
		existing_findings += organ_findings
	return findings_by_zone

/datum/computer_file/program/robotics/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(ui.user))
		return

	var/mob/living/carbon/human/user = ui.user
	var/mob/living/carbon/human/patient = get_connected_patient()

	if(action == "select_zone")
		if(!patient || !user.zone_sel)
			return
		var/new_zone = params["zone"]
		if(!(new_zone in get_planner().target_zones))
			return
		if(!isipc(patient))
			var/list/prosthetic_zones = get_patient_prosthetic_zones(patient)
			if(!(new_zone in prosthetic_zones))
				return
		user.zone_sel.set_selected_zone(new_zone, user)
		return TRUE

	if(action == "run_diagnostics")
		if(isipc(patient))
			ui.user.visible_message(SPAN_NOTICE("[user] begins running a diagnostic scan..."))
			if(do_after(user, 3 SECONDS))
				QDEL_NULL(diagnostic)
				diagnostic = new(user, patient)
				return TRUE

	if(action == "open_diagnostic")
		if(istype(diagnostic))
			if(diagnostic.patient != patient)
				to_chat(user, SPAN_WARNING("This diagnostic is no longer valid and has been deleted."))
				QDEL_NULL(diagnostic)
				return TRUE
			if(isipc(patient))
				diagnostic.ui_interact(user)
				return TRUE

/datum/computer_file/program/robotics/ui_data(mob/user)
	var/list/data = list(
		"has_patient" = FALSE,
		"patient_is_ipc" = FALSE,
		"patient_name" = null,
		"patient_species" = null,
		"diagnostic_mode" = null,
		"machine_ui_theme" = "ntos",
		"organs" = list(),
		"limbs" = list(),
		"armor_data" = list(),
		"missing_organs" = list(),
		"has_power_core" = FALSE,
		"has_endoskeleton" = FALSE,
		"has_armor" = FALSE
	)

	var/mob/living/carbon/human/patient = get_connected_patient()
	if(!patient)
		return data

	var/obj/item/organ/external/connected_prosthetic = get_connected_prosthetic()
	var/obj/item/organ/internal/augment/service_jack/connected_service_jack = get_connected_service_jack()
	var/is_ipc_patient = isipc(patient)
	data["has_patient"] = TRUE
	data["patient_is_ipc"] = is_ipc_patient
	data["patient_name"] = patient.real_name
	data["patient_species"] = patient.get_species()
	data["diagnostic_mode"] = is_ipc_patient ? "ipc" : "prosthetic"

	if(is_ipc_patient)
		data["broken"] = FALSE
		data["temp"] = round(convert_k2c(patient.bodytemperature))

		var/obj/item/organ/internal/machine/internal_diagnostics/diagnostics = patient.internal_organs_by_name[BP_DIAGNOSTICS_SUITE]
		if(diagnostics)
			data["integrity"] = diagnostics.get_integrity()

		for(var/obj/item/organ/internal/organ in patient.internal_organs)
			var/list/organ_data = list()
			if(istype(organ, /obj/item/organ/internal/machine))
				var/obj/item/organ/internal/machine/machine_organ = organ
				if(!machine_organ.diagnostics_suite_visible)
					continue
				organ_data["wiring_status"] = machine_organ.wiring.get_status()
				organ_data["plating_status"] = machine_organ.plating.get_status()
				organ_data["electronics_status"] = machine_organ.electronics.get_status()
				organ_data["diagnostics_info"] = machine_organ.get_diagnostics_info()
			organ_data["name"] = organ.name
			organ_data["parent_organ"] = organ.parent_organ
			organ_data["desc"] = organ.desc
			organ_data["damage"] = organ.get_damage()
			organ_data["max_damage"] = organ.max_damage
			data["organs"] += list(organ_data)

		for(var/organ_name in patient.species.has_organ)
			var/expected_organ_path = patient.species.has_organ[organ_name]
			if(!locate(expected_organ_path) in patient.internal_organs)
				data["missing_organs"] += capitalize_first_letters(organ_name)

		data["robolimb_self_repair_cap"] = ROBOLIMB_SELF_REPAIR_CAP
		for(var/obj/item/organ/external/limb in patient.organs)
			data["limbs"] += list(list(
				"name" = limb.name,
				"brute_damage" = limb.brute_dam,
				"burn_damage" = limb.burn_dam,
				"max_damage" = limb.max_damage,
				"foreign_bodies" = get_synthetic_foreign_body_findings(limb)
			))

		var/obj/item/organ/internal/machine/power_core/power_core = patient.internal_organs_by_name[BP_CELL]
		if(power_core)
			data["has_power_core"] = TRUE
			data["charge_percent"] = power_core.percent()
			data["power_core_integrity"] = power_core.get_integrity()

		var/datum/component/synthetic_endoskeleton/endoskeleton = patient.GetComponent(/datum/component/synthetic_endoskeleton)
		if(endoskeleton)
			data["has_endoskeleton"] = TRUE
			data["endoskeleton_damage"] = endoskeleton.damage
			data["endoskeleton_max_damage"] = endoskeleton.max_damage

		var/datum/component/armor/synthetic/synth_armor = patient.GetComponent(/datum/component/armor/synthetic)
		if(synth_armor)
			data["has_armor"] = TRUE
			var/list/armor_damage = synth_armor.get_visible_damage()
			for(var/key in armor_damage)
				data["armor_data"] += list(list("key" = key, "status" = armor_damage[key]))
	else
		data["connected_zone_name"] = connected_prosthetic ? connected_prosthetic.name : connected_service_jack.name

		// One prosthetic socket or service jack authenticates the patient's
		// cybernetic network. Organic anatomy remains outside the interface's scope.
		var/list/patient_prosthetics = get_patient_prosthetics(patient)
		for(var/obj/item/organ/external/prosthetic as anything in patient_prosthetics)
			data["limbs"] += list(list(
				"name" = prosthetic.name,
				"brute_damage" = prosthetic.brute_dam,
				"burn_damage" = prosthetic.burn_dam,
				"max_damage" = prosthetic.max_damage,
				"foreign_bodies" = get_synthetic_foreign_body_findings(prosthetic)
			))

		for(var/obj/item/organ/internal/organ in patient.internal_organs)
			var/obj/item/organ/external/parent = patient.get_organ(organ.parent_organ)
			var/organ_is_mechatronic = is_mechatronic_internal_organ(organ)
			if(!parent || (!BP_IS_ROBOTIC(parent) && !organ_is_mechatronic))
				continue
			var/list/organ_data = list(
				"name" = organ.name,
				"parent_organ" = organ.parent_organ,
				"location" = parent.name,
				"desc" = organ.desc,
				"damage" = organ.get_damage(),
				"max_damage" = organ.max_damage
			)
			if(istype(organ, /obj/item/organ/internal/machine))
				var/obj/item/organ/internal/machine/machine_organ = organ
				organ_data["wiring_status"] = machine_organ.wiring.get_status()
				organ_data["plating_status"] = machine_organ.plating.get_status()
				organ_data["electronics_status"] = machine_organ.electronics.get_status()
				organ_data["diagnostics_info"] = machine_organ.get_diagnostics_info()
			data["organs"] += list(organ_data)

	// Robotics Interface always uses its industrial repair-suite presentation,
	// rather than inheriting the connected IPC chassis theme.
	data["machine_ui_theme"] = "hephaestus"

	var/datum/surgery_planner/planner = get_planner()
	var/selected_zone = BP_CHEST
	var/list/prosthetic_zones = list()
	if(!is_ipc_patient)
		prosthetic_zones = get_patient_prosthetic_zones(patient)
		var/user_selected_zone = user?.zone_sel?.selecting
		selected_zone = connected_prosthetic ? connected_prosthetic.limb_name : connected_service_jack.parent_organ
		if(user_selected_zone in prosthetic_zones)
			selected_zone = user_selected_zone
	else if(user?.zone_sel && (user.zone_sel.selecting in planner.target_zones))
		selected_zone = user.zone_sel.selecting

	var/obj/item/organ/external/affected = patient.get_organ(selected_zone)
	data["has_table"] = TRUE
	data["selected_zone"] = selected_zone
	data["selected_zone_name"] = planner.surgery_zone_display_name(selected_zone)
	if(!affected)
		data["area_state"] = "Missing"
	else if(BP_IS_ROBOTIC(affected))
		data["area_state"] = "Robotic"
	else
		data["area_state"] = "Augmented"
	data["selected_zone_robotic"] = !!(affected && BP_IS_ROBOTIC(affected))
	data["area_open_state"] = planner.get_surgery_open_state(patient, affected, selected_zone)
	data["scan_primer_loaded"] = TRUE
	data["scan_primer_matches"] = TRUE
	data["scan_primer_subject"] = patient.real_name
	data["scan_primer_time"] = null
	data["planner_locked_zone"] = null
	data["planner_robotic_only"] = FALSE
	data["planner_available_zones"] = is_ipc_patient ? null : prosthetic_zones
	var/list/synthetic_findings = get_synthetic_scan_findings(patient, connected_prosthetic, data["limbs"], data["organs"])
	var/list/zone_data = planner.get_surgery_zone_data(patient, synthetic_findings)
	if(!is_ipc_patient)
		for(var/list/zone as anything in zone_data)
			var/zone_id = zone["id"]
			var/obj/item/organ/external/zone_organ = patient.get_organ(zone_id)
			if((zone_id in prosthetic_zones) && zone_organ && !BP_IS_ROBOTIC(zone_organ))
				zone["prosthetic_internal"] = TRUE
	data["zones"] = zone_data

	var/list/selected_prosthetic_organs = list()
	for(var/obj/item/organ/internal/selected_organ in patient.internal_organs)
		if(selected_organ.parent_organ == selected_zone && is_mechatronic_internal_organ(selected_organ))
			selected_prosthetic_organs += capitalize_first_letters(selected_organ.name)
	data["selected_prosthetic_organs"] = selected_prosthetic_organs
	data["procedures"] = list()
	if(is_ipc_patient || (selected_zone in prosthetic_zones))
		data["procedures"] = planner.get_surgery_guide_steps(user, patient, selected_zone, list(ROBOTICS_SKILL_COMPONENT))
	return data
