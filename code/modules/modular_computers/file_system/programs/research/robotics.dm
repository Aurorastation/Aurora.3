/datum/computer_file/program/robotics
	filename = "robotics"
	filedesc = "Robotics Interface"
	program_icon_state = "ai-fixer-empty"
	program_key_icon_state = "teal_key"
	extended_desc = "A program made to interface with positronics."
	size = 14
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_run = list(ACCESS_RESEARCH, ACCESS_ROBOTICS)
	required_access_download = list(ACCESS_RESEARCH, ACCESS_ROBOTICS)
	available_on_ntnet = FALSE
	tgui_id = "RoboticsComputer"
	/// The diagnostics module associated with this program.
	var/datum/tgui_module/ipc_diagnostic/diagnostic

/datum/computer_file/program/robotics/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!ishuman(ui.user))
		return

	var/mob/living/carbon/human/user = ui.user
	if(action == "run_diagnostics")
		if(computer.access_cable_dongle && computer.access_cable_dongle.access_cable)
			var/mob/living/carbon/human/synthetic = computer.access_cable_dongle.access_cable.target
			if(istype(user) && istype(synthetic))
				ui.user.visible_message(SPAN_NOTICE("[user] begins running a diagnostic scan..."))
				if(do_after(user, 3 SECONDS))
					diagnostic = new(user, synthetic)
					return TRUE

	if(action == "open_diagnostic")
		if(computer.access_cable_dongle && computer.access_cable_dongle.access_cable)

			if(istype(diagnostic))
				if(diagnostic.patient != computer.access_cable_dongle.access_cable.target)
					to_chat(user, SPAN_WARNING("This diagnostic is no longer valid and has been deleted."))
					qdel(diagnostic)
					return TRUE

				var/mob/living/carbon/human/synthetic = computer.access_cable_dongle.access_cable.target
				if(istype(user) && istype(synthetic))
					diagnostic.ui_interact(user)
					return TRUE

/datum/computer_file/program/robotics/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/ipc
	if(computer.access_cable_dongle && computer.access_cable_dongle.access_cable)
		var/obj/item/organ/internal/machine/access_port/port = computer.access_cable_dongle.access_cable.target
		if(istype(port))
			ipc = port.owner

	if(isipc(ipc))
		var/datum/species/machine/machine_species = ipc.species // need to manually set to ipc species because of machine_ui_theme
		data["patient_name"] = ipc.real_name
		data["temp"] = round(convert_k2c(ipc.bodytemperature))
		data["machine_ui_theme"] = machine_species.machine_ui_theme

		data["organs"] = list()
		for(var/obj/item/organ/internal/organ in ipc.internal_organs)
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
			organ_data["desc"] = organ.desc
			organ_data["damage"] = organ.damage
			organ_data["max_damage"] = organ.max_damage

			data["organs"] += list(organ_data)

		data["robolimb_self_repair_cap"] = ROBOLIMB_SELF_REPAIR_CAP
		data["limbs"] = list()
		for(var/obj/item/organ/external/limb in ipc.organs)
			if(limb.brute_dam || limb.burn_dam)
				data["limbs"] += list(list("name" = limb.name, "brute_damage" = limb.brute_dam, "burn_damage" = limb.burn_dam, "max_damage" = limb.max_damage))

		var/obj/item/organ/internal/machine/power_core/C = ipc.internal_organs_by_name[BP_CELL]
		if(C)
			data["charge_percent"] = C.percent()

		var/datum/component/synthetic_endoskeleton/endoskeleton = ipc.GetComponent(/datum/component/synthetic_endoskeleton)
		if(istype(endoskeleton))
			data["endoskeleton_damage"] = endoskeleton.damage
			data["endoskeleton_max_damage"] = endoskeleton.max_damage

		var/datum/component/armor/synthetic/synth_armor = ipc.GetComponent(/datum/component/armor/synthetic)
		if(istype(synth_armor))
			data["armor_data"] = list()
			var/list/armor_damage = synth_armor.get_visible_damage()
			for(var/key in armor_damage)
				data["armor_data"] += list(list("key" = key, "status" = armor_damage[key]))
	return data
