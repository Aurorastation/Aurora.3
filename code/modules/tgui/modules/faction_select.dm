/datum/tgui_module/faction_select
	/// todo
	var/datum/category_item/player_setup_item/occupation/occupation
	/// The name of the currently viewed faction.
	var/viewed_faction

/datum/tgui_module/faction_select/New(datum/category_item/player_setup_item/occupation/occupation)
	. = ..()
	src.occupation = occupation
	viewed_faction = occupation.pref.faction

/datum/tgui_module/faction_select/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FactionSelect")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tgui_module/faction_select/ui_data(mob/user)
	var/list/data = list()
	data["chosen_faction"] = occupation.pref.faction
	data["viewed_faction"] = viewed_faction
	return data

/datum/tgui_module/faction_select/ui_static_data(mob/user)
	var/list/data = list() // todo: alist

	var/list/factions = list()
	for(var/datum/faction/faction as anything in SSjobs.factions)
		if(!faction.is_visible(user))
			continue

		factions.Add(list(list(
			"name" = faction.name,
			"desc" = faction.description,
			"logo" = faction.get_logo_name(),
			"departments" = faction.departments
		)))
	data["factions"] = factions
	return data

/datum/tgui_module/faction_select/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/faction_name = params["faction"]
	var/datum/faction/faction = SSjobs.name_factions[faction_name]

	// Make sure any faction passed into here actually exists.
	if(!istype(faction))
		to_chat(usr, SPAN_WARNING("Invalid faction chosen. Resetting to [SSjobs.default_faction.name]."))
		faction_name = SSjobs.default_faction.name
		faction = SSjobs.name_factions[faction_name]

	if(action == "view_faction")
		viewed_faction = faction_name
		return TRUE

	if(action == "choose_faction")
		if(!faction.can_select(occupation.pref, usr))
			to_chat(usr, SPAN_DANGER("Error selecting faction!"))
			return FALSE

		occupation.validate_and_set_faction(faction)
		return TRUE

/datum/tgui_module/faction_select/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/faction_icons)
	)
