/datum/vueui_module/ghost_menu/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "misc-ghostmenu", 800, 450, "Ghost Menu", state = interactive_state)
	ui.open()

/datum/vueui_module/ghost_menu/Topic(ref, href_list)
	if(..())
		return TRUE

	var/mob/abstract/observer/ghost = usr
	if(!istype(ghost))
		return TRUE

	if(href_list["follow_target"])
		ghost.ManualFollow(locate(href_list["follow_target"]) in mob_list)

	return FALSE

/datum/vueui_module/ghost_menu/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	var/list/menu_info = list()

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
			if(M.mind && isobserver(user))
				var/mob/abstract/observer/O = user
				if(O.antagHUD && player_is_antag(M.mind))
					category = M.mind.special_role
			if(!category)
				category = "Alive"
		if(menu_info[category])
			menu_info[category] += list(list("name" = name, "ref" = ref(M))) // this is how to add a list to a list without them merging
		else
			menu_info[category] = list(list("name" = name, "ref" = ref(M)))

	data["menuinfo"] = menu_info
	return data