/**
 * Opens a TGUI picker for a gear tweak's item paths and returns the selected display name.
 */
/proc/tgui_gear_selection(mob/user, list/items, default)
	if(!user)
		user = usr
	if(!length(items))
		return
	if(!istype(user))
		if(istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	if(isnull(user.client))
		return

	if(!user.client.prefs.tgui_inputs)
		return input(user, "Choose a type.", "Character Preference", default) as null|anything in items

	var/datum/tgui_gear_selection/input = new(user, items, default)
	input.ui_interact(user)
	input.wait()
	if(input)
		. = input.choice
		qdel(input)

/** TGUI input used to show the icons for item variants offered by a loadout gear tweak. */
/datum/tgui_gear_selection
	var/list/items
	var/list/item_data
	var/choice
	var/default
	var/closed = FALSE
	var/static/list/icon_cache = list()

/datum/tgui_gear_selection/New(mob/user, list/items, default)
	src.items = items.Copy()
	src.default = (default in items) ? default : items[1]
	item_data = list()

	for(var/item_name in items)
		var/item_path = items[item_name]
		if(islist(item_path))
			item_path = item_path[1]

		var/item_icon
		if(ispath(item_path, /obj/item))
			item_icon = icon_cache[item_path]
			if(!item_icon)
				var/obj/item/item = item_path
				var/icon/item_icon_file = icon(
					icon = initial(item.icon),
					icon_state = initial(item.icon_state),
					frame = 1,
				)
				item_icon = icon2base64(item_icon_file)
				icon_cache[item_path] = item_icon

		item_data += list(list(
			"name" = item_name,
			"icon" = item_icon,
		))

/datum/tgui_gear_selection/Destroy(force)
	SStgui.close_uis(src)
	items = null
	item_data = null
	return ..()

/datum/tgui_gear_selection/proc/wait()
	while(!closed && !QDELETED(src))
		stoplag(1)

/datum/tgui_gear_selection/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GearSelection")
		ui.open()

/datum/tgui_gear_selection/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_gear_selection/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_gear_selection/ui_static_data(mob/user)
	return list(
		"default_item" = default,
		"items" = item_data,
		"large_buttons" = user.client.prefs.tgui_buttons_large,
		"swapped_buttons" = user.client.prefs.tgui_inputs_swapped,
	)

/datum/tgui_gear_selection/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("submit")
			var/selection = params["entry"]
			if(!(selection in items))
				return
			choice = selection
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

	return FALSE
