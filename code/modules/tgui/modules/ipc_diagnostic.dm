/datum/tgui_module/ipc_diagnostic
	var/mob/patient

/datum/tgui_module/ipc_diagnostic/New(mob/user, mob/target)
	. = ..()
	patient = target

/datum/tgui_module/ipc_diagnostic/Destroy(force)
	patient = null
	return ..()

/datum/tgui_module/ipc_diagnostic/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DiagnosticsUnit", "Diagnostics Unit", 400, 600)
		ui.open()

/datum/tgui_module/ipc_diagnostic/ui_data(mob/user)
	var/list/data = list()
	data["broken"] = FALSE
	data["has_power_core"] = FALSE
	data["has_endoskeleton"] = FALSE
	data["has_armor"] = FALSE
	data["armor_data"] = list()
	data["missing_organs"] = list()

	if(isipc(patient))
		var/mob/living/carbon/human/ipc = patient
		var/datum/species/machine/machine_species = ipc.species // need to manually set to ipc species because of machine_ui_theme
		var/obj/item/organ/internal/machine/internal_diagnostics/diagnostics = ipc.internal_organs_by_name[BP_DIAGNOSTICS_SUITE]
		if(!istype(diagnostics))
			data["broken"] = TRUE
			data["patient_name"] = ipc.real_name
			data["machine_ui_theme"] = machine_species.machine_ui_theme
			return data

		data["patient_name"] = ipc.real_name
		data["broken"] = diagnostics.is_broken()
		data["integrity"] = diagnostics.get_integrity()
		data["temp"] = round(convert_k2c(ipc.bodytemperature))
		data["machine_ui_theme"] = machine_species.machine_ui_theme

		data["organs"] = list()
		for(var/obj/item/organ/internal/organ in ipc.internal_organs)
			var/list/organ_data = list()

			// this check is here first so we can avoid useless calculations in case the organ isn't visible from the diag suite
			if(istype(organ, /obj/item/organ/internal/machine))
				var/obj/item/organ/internal/machine/machine_organ = organ
				if(!machine_organ.diagnostics_suite_visible)
					continue

				organ_data["wiring_status"] = edit_organ_status(machine_organ.wiring.get_status(), diagnostics)
				organ_data["plating_status"] = edit_organ_status(machine_organ.plating.get_status(), diagnostics)
				organ_data["electronics_status"] = edit_organ_status(machine_organ.electronics.get_status(), diagnostics)
				organ_data["diagnostics_info"] = machine_organ.get_diagnostics_info()

			organ_data["name"] = organ.name
			organ_data["desc"] = organ.desc
			organ_data["damage"] = edit_organ_status(organ.get_damage(), diagnostics)
			organ_data["max_damage"] = organ.max_damage

			data["organs"] += list(organ_data)

		for(var/organ_name in ipc.species.has_organ)
			var/expected_organ_path = ipc.species.has_organ[organ_name]
			if(!locate(expected_organ_path) in ipc.internal_organs)
				data["missing_organs"] += capitalize_first_letters(organ_name)

		data["robolimb_self_repair_cap"] = ROBOLIMB_SELF_REPAIR_CAP
		data["limbs"] = list()
		for(var/obj/item/organ/external/limb in ipc.organs)
			data["limbs"] += list(list(
				"name" = limb.name,
				"brute_damage" = edit_organ_status(limb.brute_dam, diagnostics),
				"burn_damage" = edit_organ_status(limb.burn_dam, diagnostics),
				"max_damage" = limb.max_damage,
				"foreign_bodies" = get_synthetic_foreign_body_findings(limb)
			))

		var/obj/item/organ/internal/machine/power_core/C = ipc.internal_organs_by_name[BP_CELL]
		if(C)
			data["has_power_core"] = TRUE
			data["charge_percent"] = C.percent()
			data["power_core_integrity"] = edit_organ_status(C.get_integrity(), diagnostics)

		var/datum/component/synthetic_endoskeleton/endoskeleton = ipc.GetComponent(/datum/component/synthetic_endoskeleton)
		if(istype(endoskeleton))
			data["has_endoskeleton"] = TRUE
			data["endoskeleton_damage"] = endoskeleton.damage
			data["endoskeleton_max_damage"] = endoskeleton.max_damage

		var/datum/component/armor/synthetic/synth_armor = ipc.GetComponent(/datum/component/armor/synthetic)
		if(istype(synth_armor))
			data["has_armor"] = TRUE
			var/list/armor_damage = synth_armor.get_visible_damage()
			for(var/key in armor_damage)
				data["armor_data"] += list(list("key" = key, "status" = armor_damage[key]))

	return data

/** Mirrors the body scanner's visibility rules for implants and foreign bodies. */
/proc/get_synthetic_foreign_body_findings(obj/item/organ/external/limb)
	var/list/findings = list()
	var/unknown_objects = 0
	var/abnormal_organic_bodies = 0

	for(var/atom/movable/foreign_body in limb.implants)
		if(istype(foreign_body, /obj/item/implant))
			var/obj/item/implant/implant = foreign_body
			if(implant.hidden)
				continue
			if(implant.known)
				findings += "[implant.name] installed"
			else
				unknown_objects++
			continue

		if(istype(foreign_body, /obj/effect/spider))
			abnormal_organic_bodies++
		else
			unknown_objects++

	if(unknown_objects)
		findings += "[unknown_objects] unknown object(s) present"
	if(abnormal_organic_bodies)
		findings += abnormal_organic_bodies > 1 ? "Multiple abnormal organic bodies" : "Abnormal organic body"

	return findings

/**
 * Edits a status number based on the diagnostics unit's status.
 * The more damaged the diagnostics unit, the more errant a reading may be.
 */
/datum/tgui_module/ipc_diagnostic/proc/edit_organ_status(number, obj/item/organ/internal/machine/internal_diagnostics/diagnostics)
	if(!diagnostics)
		// what the hell are we doing here
		return 0

	var/integrity = diagnostics.get_integrity()
	if(integrity > IPC_INTEGRITY_THRESHOLD_LOW)
		return number

	var/variancy = (100 / integrity * rand(1, (100 / integrity * 10)))
	var/sign = prob(variancy) ? pick(1, -1) : 1
	var/random_number = sign * (rand(1, 100 / integrity))

	return number + (sign * rand(1, variancy) + random_number)
