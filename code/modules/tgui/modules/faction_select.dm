/datum/tgui_module/faction_select
	/// The 'occupation' datum of the user viewing the interface.
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

/datum/tgui_module/faction_select/ui_close(mob/user)
	. = ..()
	occupation.on_ui_close()

/datum/tgui_module/faction_select/ui_data(mob/user)
	var/list/data = alist()
	data["chosen_faction"] = occupation.pref.faction

	var/datum/faction/faction_datum = get_faction(viewed_faction, user)
	// Set `viewed_faction` to the `get_faction()` result from it, since that double checks that it's actually valid.
	data["viewed_faction"] = faction_datum.name
	data["viewed_selection_error"] = faction_datum.get_selection_error(occupation.pref, user)

	return data

/datum/tgui_module/faction_select/ui_static_data(mob/user)
	var/list/data = alist()

	var/list/factions = list()
	for(var/datum/faction/faction as anything in sort_list(SSjobs.factions, GLOBAL_PROC_REF(cmp_faction)))
		if(!faction.is_visible(user))
			continue

		factions.Add(list(alist(
			"name" = faction.name,
			"suffix" = faction.title_suffix,
			"desc" = faction.description,
			"logo" = faction.get_logo_name(),
			"departments" = faction.departments,
			"wiki_page" = faction.wiki_page
		)))
	data["factions"] = factions
	data["wiki_url"] = GLOB.config.wikiurl
	return data

/datum/tgui_module/faction_select/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/faction/faction = get_faction(params["faction"], usr, FALSE)

	if(action == "view_faction")
		viewed_faction = faction.name
		return TRUE

	if(action == "choose_faction")
		var/faction_error = faction.get_selection_error(occupation.pref, usr)
		if(faction_error)
			to_chat(usr, SPAN_DANGER("Error selecting faction!: [faction_error]"))
			return FALSE

		occupation.validate_and_set_faction(faction)
		usr.client.prefs.ShowChoices(usr)
		usr.client.prefs.update_preview_icon()
		return TRUE

	if(action == "open_wiki")
		var/client/client = usr.get_client()
		client?.wiki(faction.wiki_page)
		return FALSE

/datum/tgui_module/faction_select/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/faction_icons)
	)

/datum/tgui_module/faction_select/proc/get_faction(faction_name, mob/user, quiet = TRUE)
	var/datum/faction/faction = SSjobs.name_factions[faction_name]
	if(!istype(faction) || !faction.is_visible(user))
		if(!quiet)
			to_chat(usr, SPAN_WARNING("Invalid faction chosen. Resetting to [SSjobs.default_faction.name]."))
		update_static_data(user) // Update the faction list to hopefully remove anything invalid.
		return SSjobs.default_faction

	return faction
