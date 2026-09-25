/datum/tgui_module/adpi_panel/ui_state(mob/user)
	return GLOB.staff_state

/datum/tgui_module/adpi_panel/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ADPIPanel", "ADPI Panel", 700, 520)
		ui.open()

/datum/tgui_module/adpi_panel/ui_data(mob/user)
	var/list/data = list()
	data["targets"] = get_adpi_targets()
	return data

/datum/tgui_module/adpi_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!can_use_adpi_panel(ui.user))
		return FALSE

	var/custom_message = sanitizeSafe(params["message"], MAX_MESSAGE_LEN)
	if(!length(custom_message))
		custom_message = null

	if(action == "send_target")
		var/mob/living/target = locate(params["target"]) in GLOB.living_mob_list
		if(!is_adpi_target(target))
			to_chat(ui.user, SPAN_WARNING("That target is no longer valid."))
			return TRUE

		if(!SShallucinations.send_admin_adpi_message(target, custom_message))
			to_chat(ui.user, SPAN_WARNING("No ADPI message could be sent to [target]."))
			return TRUE

		log_adpi_send(ui.user, list(target), custom_message)
		return TRUE

	if(action == "send_all")
		var/list/targets = get_adpi_target_mobs()
		var/list/sent_targets = list()
		for(var/mob/living/target in targets)
			if(SShallucinations.send_admin_adpi_message(target, custom_message))
				sent_targets += target

		if(!length(sent_targets))
			to_chat(ui.user, SPAN_WARNING("No ADPI messages could be sent."))
			return TRUE

		log_adpi_send(ui.user, sent_targets, custom_message)
		return TRUE

	if(action == "refresh")
		ui.send_full_update()
		return TRUE

/datum/tgui_module/adpi_panel/proc/can_use_adpi_panel(var/mob/user)
	return check_rights(R_ADMIN|R_MOD|R_FUN, 0, user)

/datum/tgui_module/adpi_panel/proc/is_adpi_target(var/mob/living/target)
	if(!istype(target))
		return FALSE
	if(!target.client || !target.mind || target.stat == DEAD)
		return FALSE
	if(SShallucinations.is_adpi_excluded(target))
		return FALSE
	if(SShallucinations.is_adpi_blocked(target))
		return FALSE
	return TRUE

/datum/tgui_module/adpi_panel/proc/get_adpi_target_mobs()
	var/list/targets = list()
	for(var/mob/living/target in GLOB.living_mob_list)
		if(is_adpi_target(target))
			targets += target
	return targets

/datum/tgui_module/adpi_panel/proc/get_adpi_targets()
	var/list/targets = list()
	var/list/names = list()
	var/list/namecounts = list()

	for(var/mob/living/target in get_adpi_target_mobs())
		var/name = target.name
		if(name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1

		if(target.real_name && target.real_name != target.name)
			name += " \[[target.real_name]\]"

		var/job = ""
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			job = H.job

		targets += list(list(
			"name" = name,
			"ref" = REF(target),
			"key" = target.key,
			"job" = job,
			"can_random" = can_random_adpi(target)
		))

	return targets

/datum/tgui_module/adpi_panel/proc/can_random_adpi(var/mob/living/target)
	SShallucinations.ensure_adpi_lists_loaded()
	return SShallucinations.has_adpi_messages(target, FALSE)

/datum/tgui_module/adpi_panel/proc/log_adpi_send(var/mob/user, var/list/targets, var/custom_message)
	var/admin_target_text = length(targets) == 1 ? key_name_admin(targets[1]) : "[length(targets)] characters"
	var/log_target_text = length(targets) == 1 ? key_name(targets[1]) : "[length(targets)] characters"
	var/message_text = custom_message ? ": [sanitize_tg(custom_message)]" : " using random pool messages"
	message_admins("[key_name_admin(user)] sent ADPI to [admin_target_text][message_text]", 1)
	log_admin("[key_name(user)] sent ADPI to [log_target_text][message_text]")
