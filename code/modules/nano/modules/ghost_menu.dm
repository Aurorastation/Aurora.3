/datum/tgui_module/ghost_menu/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FollowMenu", "Follow Menu", 800, 400)
		ui.open()

/datum/tgui_module/ghost_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/abstract/observer/ghost = usr
	if(!istype(ghost))
		return

	if(action == "follow_target")
		ghost.ManualFollow(locate(params["follow_target"]) in mob_list)

/datum/tgui_module/ghost_menu/ui_data(mob/user)
	var/list/data = list()
	var/is_mod = check_rights(R_MOD|R_ADMIN, 0, user)
	data["is_mod"] = is_mod

	var/list/ghosts = list()
	var/list/categories = list()

	var/list/names = list()
	var/list/namecounts = list()
	for(var/mob/M in mob_list)
		var/category
		var/name = M.name
		if(name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if(M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if(!M.mind)
			if(M.stat == DEAD)
				category = "Dead NPCs"
			else
				category = "NPCs"
		else if(M.stat == DEAD)
			if(isobserver(M))
				name += " \[Ghost\]"
				category = "Observer"
			else
				name += " \[Dead\]"
				category = "Dead"
		else
			if(player_is_obvious_antag(M.mind))
				category = M.mind.special_role
			else if(isobserver(user))
				var/mob/abstract/observer/O = user
				if(O.antagHUD && player_is_antag(M.mind))
					category = M.mind.special_role
		if(!category)
			category = "Alive"
		var/special_char = is_special_character(M)
		if(!name)
			continue

		ghosts += list(list("name" = name, "ref" = ref(M), "category" = category, "special_character" = special_char))
		categories |= category

	data["categories"] = categories
	data["ghosts"] = ghosts
	return data

/datum/tgui_module/ghost_menu/proc/sort_categories(var/list/menu_info)
	var/static/list/ordered_categories = list("Alive", "Dead", "Observer", "NPCs", "Dead NPCs")
	var/list/sorted_menu_info = list()

	// antags first
	for(var/category in menu_info)
		if(!(category in ordered_categories))
			sorted_menu_info[category] = menu_info[category]

	// set categories in the order people probably want to look at them
	for(var/ordered_category in ordered_categories)
		if(menu_info[ordered_category])
			sorted_menu_info[ordered_category] = menu_info[ordered_category]

	return sorted_menu_info
