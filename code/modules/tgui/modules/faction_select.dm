/datum/tgui_module/faction_select
	var/datum/preferences/pref

/datum/tgui_module/faction_select/New(datum/preferences/pref)
	. = ..()
	src.pref = pref

/datum/tgui_module/faction_select/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FactionSelect")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tgui_module/faction_select/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/faction_icons)
	)

/datum/tgui_module/faction_select/ui_data(mob/user)
	var/list/data = list()
	data["selected_faction"] = pref.faction
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
