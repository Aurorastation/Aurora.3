/datum/tgui_module/ipc_diagnostic/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IPCDiagnostics", "Internal Diagnostics", 400, 600)
		ui.open()

/datum/tgui_module/ipc_diagnostic/ui_data(mob/user)
	var/list/data = list()
	data["broken"] = FALSE

	if(isipc(user))
		var/mob/living/carbon/human/ipc = user
		var/datum/species/machine/machine_species = ipc.species
		var/obj/item/organ/internal/machine/internal_diagnostics/diagnostics = ipc.internal_organs_by_name[BP_DIAGNOSTICS_SUITE]
		if(!istype(diagnostics))
			data["broken"] = TRUE

		data["broken"] = diagnostics.is_broken()
		data["integrity"] = diagnostics.get_integrity()
		data["temp"] = round(convert_k2c(ipc.bodytemperature))
		data["diagnostics_theme"] = machine_species.diagnostics_theme

		data["organs"] = list()
		for(var/obj/item/organ/internal/organ in ipc.internal_organs)
			var/list/organ_data = list()
			organ_data["name"] = organ.name
			organ_data["desc"] = organ.desc
			organ_data["damage"] = edit_organ_status(organ.damage, diagnostics)
			organ_data["max_damage"] = organ.max_damage

			if(istype(organ, /obj/item/organ/internal/machine))
				var/obj/item/organ/internal/machine/machine_organ = organ
				organ_data["wiring_status"] = edit_organ_status(machine_organ.wiring.get_status(), diagnostics)
				organ_data["plating_status"] = edit_organ_status(machine_organ.plating.get_status(), diagnostics)
				organ_data["electronics_status"] = edit_organ_status(machine_organ.electronics.get_status(), diagnostics)
				organ_data["diagnostics_info"] = machine_organ.get_diagnostics_info()

			data["organs"] += list(organ_data)

		data["robolimb_self_repair_cap"] = ROBOLIMB_SELF_REPAIR_CAP
		data["limbs"] = list()
		for(var/obj/item/organ/external/limb in ipc.organs)
			if(limb.brute_dam || limb.burn_dam)
				data["limbs"] += list(list("name" = limb.name, "brute_damage" = edit_organ_status(limb.brute_dam, diagnostics), "burn_damage" = edit_organ_status(limb.burn_dam, diagnostics), "max_damage" = limb.max_damage))

		var/obj/item/organ/internal/machine/cell/C = ipc.internal_organs_by_name[BP_CELL]
		if(C)
			data["charge_percent"] = C.percent()

	return data

/**
 * Edits a status number based on the diagnostics unit's status.
 * The more damaged the diagnostics unit, the more errant a reading may be.
 */
/datum/tgui_module/ipc_diagnostic/proc/edit_organ_status(number, obj/item/organ/internal/machine/internal_diagnostics/diagnostics)
	if(!diagnostics)
		// what the hell are we doing here
		return number

	if(diagnostics.get_damage_percent() < 25)
		return number

	var/variancy = (100 / diagnostics.get_damage_percent() * rand(1, (100 / diagnostics.get_damage_percent() * 10)))
	var/sign = prob(variancy) ? pick(1, -1) : 1
	var/random_number = sign * (rand(1, 100 / diagnostics.get_damage_percent()))

	return number + (sign * rand(1, variancy) + random_number)
