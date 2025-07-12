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
	return data

/datum/tgui_module/neural_configuration/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("toggle_firewall")
			var/obj/item/organ/internal/machine/posibrain/posibrain = owner.internal_organs_by_name[BP_BRAIN]
			if(istype(posibrain))
				posibrain.toggle_firewall()
