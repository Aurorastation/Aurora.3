/// This is really ugly copypaste, but we are seriously at the point where I don't give a fuck anymore.
/// Well, it's not the worst copypaste since this and the computer program need to be separate anyway, but it's still ugly.
/datum/tgui_module/admin/law_manager
	var/ion_law	= "IonLaw"
	var/zeroth_law = "ZerothLaw"
	var/inherent_law = "InherentLaw"
	var/supplied_law = "SuppliedLaw"
	var/supplied_law_position = MIN_SUPPLIED_LAW_NUMBER

	var/current_view = 0

	var/global/list/datum/ai_laws/admin_laws
	var/global/list/datum/ai_laws/player_laws
	var/mob/living/silicon/owner = null

/datum/tgui_module/admin/law_manager/New(var/mob/living/silicon/S)
	..()
	owner = S

	if(!admin_laws)
		admin_laws = new()
		player_laws = new()

		init_subtypes(/datum/ai_laws, admin_laws)
		sortTim(admin_laws, GLOBAL_PROC_REF(cmp_name_asc))

		for(var/datum/ai_laws/laws in admin_laws)
			if(laws.selectable)
				player_laws += laws

/datum/tgui_module/admin/law_manager/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LawManager", "Law Manager (Admin)")
		ui.autoupdate = FALSE
		ui.open()

/datum/tgui_module/admin/law_manager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("set_view")
			current_view = text2num(params["set_view"])
			return TRUE

		if("law_channel")
			if(params["law_channel"] in owner.law_channels())
				owner.law_channel = params["law_channel"]
			return TRUE

		if("state_law")
			var/datum/ai_law/AL = locate(params["ref"]) in owner.laws.all_laws()
			if(AL)
				var/state_law = text2num(params["state_law"])
				owner.laws.set_state_law(AL, state_law)
			return TRUE

		if("add_zeroth_law")
			if(zeroth_law && is_admin(usr) && !owner.laws.zeroth_law)
				owner.set_zeroth_law(zeroth_law)
			return TRUE

		if("add_ion_law")
			if(ion_law && is_malf(usr))
				owner.add_ion_law(ion_law)
			return TRUE

		if("add_inherent_law")
			if(inherent_law && is_malf(usr))
				owner.add_inherent_law(inherent_law)
			return TRUE

		if("add_supplied_law")
			if(supplied_law && supplied_law_position >= 1 && MIN_SUPPLIED_LAW_NUMBER <= MAX_SUPPLIED_LAW_NUMBER && is_malf(usr))
				owner.add_supplied_law(supplied_law_position, supplied_law)
			return TRUE

		if("change_zeroth_law")
			var/new_law = sanitize(input("Enter new law Zero. Leaving the field blank will cancel the edit.", "Edit Law", zeroth_law))
			if(new_law && new_law != zeroth_law && state.can_use_topic(src, usr))
				zeroth_law = new_law
			return TRUE

		if("change_ion_law")
			var/new_law = sanitize(input("Enter new ion law. Leaving the field blank will cancel the edit.", "Edit Law", ion_law))
			if(new_law && new_law != ion_law && state.can_use_topic(src, usr))
				ion_law = new_law
			return TRUE

		if("change_inherent_law")
			var/new_law = sanitize(input("Enter new inherent law. Leaving the field blank will cancel the edit.", "Edit Law", inherent_law))
			if(new_law && new_law != inherent_law && state.can_use_topic(src, usr))
				inherent_law = new_law
			return TRUE

		if("change_supplied_law")
			var/new_law = sanitize(input("Enter new supplied law. Leaving the field blank will cancel the edit.", "Edit Law", supplied_law))
			if(new_law && new_law != supplied_law && state.can_use_topic(src, usr))
				supplied_law = new_law
			return TRUE

		if("change_supplied_law_position")
			var/new_position = input(usr, "Enter new supplied law position between 1 and [MAX_SUPPLIED_LAW_NUMBER], inclusive. Inherent laws at the same index as a supplied law will not be stated.", "Law Position", supplied_law_position) as num|null
			if(isnum(new_position) && state.can_use_topic(src, usr))
				supplied_law_position = clamp(new_position, 1, MAX_SUPPLIED_LAW_NUMBER)
			return TRUE

		if("edit_law")
			if(is_malf(usr))
				var/datum/ai_law/AL = locate(params["edit_law"]) in owner.laws.all_laws()
				if(AL)
					var/new_law = sanitize(input(usr, "Enter new law. Leaving the field blank will cancel the edit.", "Edit Law", AL.law))
					if(new_law && new_law != AL.law && is_malf(usr) && state.can_use_topic(src, usr))
						log_and_message_admins("has changed a law of [owner] from '[AL.law]' to '[new_law]'")
						AL.law = new_law
				return TRUE

		if("delete_law")
			if(is_malf(usr))
				var/datum/ai_law/AL = locate(params["delete_law"]) in owner.laws.all_laws()
				if(AL && is_malf(usr))
					owner.delete_law(AL)
			return TRUE

		if("state_laws")
			owner.statelaws(owner.laws)
			return TRUE

		if("state_law_set")
			var/datum/ai_laws/ALs = locate(params["state_law_set"]) in (is_admin(usr) ? admin_laws : player_laws)
			if(ALs)
				owner.statelaws(ALs)
			return TRUE

		if("transfer_laws")
			if(is_malf(usr))
				var/datum/ai_laws/ALs = locate(params["transfer_laws"]) in (is_admin(usr) ? admin_laws : player_laws)
				if(ALs)
					log_and_message_admins("has transferred the [ALs.name] laws to [owner].")
					ALs.sync(owner, 0)
					current_view = 0
			return TRUE

		if("notify_laws")
			to_chat(owner, SPAN_DANGER("Law Notice"))
			owner.laws.show_laws(owner)
			if(isAI(owner))
				var/mob/living/silicon/ai/AI = owner
				for(var/mob/living/silicon/robot/R in AI.connected_robots)
					to_chat(R, SPAN_DANGER("Law Notice"))
					R.laws.show_laws(R)
			if(usr != owner)
				to_chat(usr, SPAN_NOTICE("Laws displayed."))
			return TRUE

/datum/tgui_module/admin/law_manager/ui_data(mob/user)
	var/list/data = list()
	owner.lawsync()

	data["ion_law_nr"] = ionnum()
	data["ion_law"] = ion_law
	data["zeroth_law"] = zeroth_law
	data["inherent_law"] = inherent_law
	data["supplied_law"] = supplied_law
	data["supplied_law_position"] = supplied_law_position

	package_laws(data, "zeroth_laws", list(owner.laws.zeroth_law))
	package_laws(data, "ion_laws", owner.laws.ion_laws)
	package_laws(data, "inherent_laws", owner.laws.inherent_laws)
	package_laws(data, "supplied_laws", owner.laws.supplied_laws)

	data["isAI"] = isAI(owner)
	data["isMalf"] = is_malf(user)
	data["isSlaved"] = owner.is_slaved()
	data["isAdmin"] = is_admin(user)
	data["view"] = current_view

	var/channels = list()
	for (var/ch_name in owner.law_channels())
		channels += list(list("channel" = ch_name))
	data["channel"] = owner.law_channel
	data["channels"] = channels
	data["law_sets"] = package_multiple_laws(data["isAdmin"] ? admin_laws : player_laws)

	return data

/datum/tgui_module/admin/law_manager/proc/package_laws(var/list/data, var/field, var/list/datum/ai_law/laws)
	var/list/packaged_laws = list()
	for(var/datum/ai_law/AL in laws)
		packaged_laws += list(list("law" = AL.law, "index" = AL.get_index(), "state" = owner.laws.get_state_law(AL), "ref" = "[REF(AL)]"))
	data[field] = packaged_laws
	data["has_[field]"] = packaged_laws.len

/datum/tgui_module/admin/law_manager/proc/package_multiple_laws(var/list/datum/ai_laws/laws)
	var/list/law_sets = list()
	for(var/datum/ai_laws/ALs in laws)
		var/packaged_laws = list()
		package_laws(packaged_laws, "zeroth_laws", list(ALs.zeroth_law, ALs.zeroth_law_borg))
		package_laws(packaged_laws, "ion_laws", ALs.ion_laws)
		package_laws(packaged_laws, "inherent_laws", ALs.inherent_laws)
		package_laws(packaged_laws, "supplied_laws", ALs.supplied_laws)
		law_sets += list(list("name" = ALs.name, "header" = ALs.law_header, "ref" = "[REF(ALs)]","laws" = packaged_laws))

	return law_sets

/datum/tgui_module/admin/law_manager/proc/is_malf(var/mob/user)
	return (is_admin(user) && !owner.is_slaved()) || owner.is_malf_or_traitor()

/datum/tgui_module/admin/law_manager/proc/sync_laws(var/mob/living/silicon/ai/AI)
	if(!AI)
		return
	for(var/mob/living/silicon/robot/R in AI.connected_robots)
		R.sync()
	log_and_message_admins("has syncronized [AI]'s laws with its borgs.")
