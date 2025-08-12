/datum/tgui_module/neural_configuration
	var/mob/living/carbon/human/owner

/datum/tgui_module/neural_configuration/New(mob/user, mob/target)
	. = ..()
	if(!isipc(target))
		log_debug("Neural configuration created without IPC target!")
		qdel(src)
	owner = target

/datum/tgui_module/neural_configuration/Destroy(force)
	owner = null
	return ..()

/datum/tgui_module/neural_configuration/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NeuralConfiguration", "Neural Configuration", 400, 400)
		ui.open()

/datum/tgui_module/neural_configuration/ui_data(mob/user)
	var/list/data = list()
	var/obj/item/organ/internal/machine/posibrain/posibrain = owner.internal_organs_by_name[BP_BRAIN]
	if(istype(posibrain))
		data["neural_coherence"] = posibrain.damage
		data["max_neural_coherence"] = posibrain.max_damage
		data["owner_real_name"] = posibrain.owner.real_name
		data["firewall"] = posibrain.firewall
		data["p2p_communication"] = posibrain.p2p_communication_allowed

		var/obj/item/organ/internal/machine/access_port/port = owner.internal_organs_by_name[BP_ACCESS_PORT]
		if(istype(port) && !port.is_broken())
			data["port"] = TRUE
			if(port.access_cable && istype(port.access_cable.target, /obj/item/organ/internal/machine/access_port))
				var/obj/item/organ/internal/machine/access_port/other_port = port.access_cable.target
				if(isipc(other_port.owner))
					var/mob/living/carbon/human/connected_ipc = other_port.owner
					data["port_connected"] = connected_ipc.real_name
					if(other_port && !other_port.is_broken())
						data["port_can_communicate"] = TRUE

	return data

/datum/tgui_module/neural_configuration/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("toggle_firewall")
			var/obj/item/organ/internal/machine/posibrain/posibrain = owner.internal_organs_by_name[BP_BRAIN]
			if(istype(posibrain))
				posibrain.toggle_firewall()
				. = TRUE

		if("toggle_p2p")
			var/obj/item/organ/internal/machine/posibrain/posibrain = owner.internal_organs_by_name[BP_BRAIN]
			if(istype(posibrain))
				posibrain.toggle_p2p()
				. = TRUE

		if("talk_p2p")
			var/obj/item/organ/internal/machine/access_port/port = owner.internal_organs_by_name[BP_ACCESS_PORT]
			if(istype(port) && !port.is_broken())
				if(port.access_cable && istype(port.access_cable.target, /obj/item/organ/internal/machine/access_port))
					var/obj/item/organ/internal/machine/access_port/other_port = port.access_cable.target
					if(isipc(other_port.owner))
						var/mob/living/carbon/human/connected_ipc = other_port.owner
						if(other_port && !other_port.is_broken())
							if(connected_ipc.client)
								var/obj/item/organ/internal/machine/posibrain/other_posibrain = connected_ipc.internal_organs_by_name[BP_BRAIN]
								if(!other_posibrain.p2p_communication_allowed)
									to_chat(owner, SPAN_MACHINE_WARNING("[connected_ipc.real_name]'s Virtual Communication ports are not open."))
									return

								var/message = sanitize_tg(tgui_input_text(owner, "Enter a peer-to-peer message to send to [connected_ipc.real_name].", "Virtual Communication", max_length = MAX_MESSAGE_LEN))
								// re-do all the checks just in case. bit ass but oh well
								if(message && !port.is_broken() && (port.access_cable.target && port.access_cable.target == connected_ipc && !other_port.is_broken()))
									var/p2p_message = SPAN_ITALIC("Virtual Communication, ") + SPAN_BOLD("[owner.real_name] transmits: ") + SPAN_MACHINE_WARNING(message)
									to_chat(connected_ipc, p2p_message)
									log_say("VIRTUAL COMMUNICATION: [owner]/[owner.client.ckey] to [connected_ipc]/[connected_ipc.client.ckey]: [message]")
									. = TRUE
							else
								to_chat(owner, SPAN_WARNING("That posibrain seems to be in deep sleep."))
								. = FALSE
						else
							to_chat(owner, SPAN_WARNING("The other port isn't responding at all!"))
							. = FALSE

	if(.)
		sound_to(owner, 'sound/effects/neural_config.ogg')
