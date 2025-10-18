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
