/datum/tgui_module/hivenet_manifest
	var/list/all_vaurca = list()

/datum/tgui_module/hivenet_manifest/New(mob/user, var/list/set_all_vaurca)
	..()
	all_vaurca = set_all_vaurca

/datum/tgui_module/hivenet_manifest/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HivenetManifest", "Hivenet Manifest", 350, 400)
		ui.autoupdate = FALSE
		ui.open()

/datum/tgui_module/hivenet_manifest/ui_data(mob/user)
	var/list/data = list()

	var/list/zora_vaurca = list()
	var/list/cthur_vaurca = list()
	var/list/klax_vaurca = list()

	for(var/mob/living/carbon/human/vaurca as anything in all_vaurca)
		var/list/fullname = splittext(vaurca.real_name, " ")
		var/surname = fullname[2]
		switch(surname)
			if("Zo'ra")
				zora_vaurca += vaurca_to_data(vaurca)
			if("C'thur")
				cthur_vaurca += vaurca_to_data(vaurca)
			if("K'lax")
				klax_vaurca += vaurca_to_data(vaurca)

	data["all_vaurca"] = list(
		"Zo'ra" = list("vaurca" = sort_vaurca_list(zora_vaurca), "color" = "Security"),
		"C'thur" = list("vaurca" = sort_vaurca_list(cthur_vaurca), "color" = "Command"),
		"K'lax" = list("vaurca" = sort_vaurca_list(klax_vaurca), "color" = "Medical")
	)

	return data

/datum/tgui_module/hivenet_manifest/proc/vaurca_to_data(var/mob/living/carbon/human/vaurca)
	var/list/fullname = splittext(vaurca.real_name, "'")
	var/identifier = fullname[1]
	return list(list(
		"name" = vaurca.real_name,
		"bold" = identifier == "Ta" ? TRUE : FALSE
	))

/datum/tgui_module/hivenet_manifest/proc/sort_vaurca_list(var/list/vaurca_list)
	if(!length(vaurca_list))
		return vaurca_list

	var/list/identifiers = list("Ta", "Za", "Ka", "Ra")
	var/list/statuses = list("Akaix", "Viax")
	var/list/sorting_operations = list()

	for(var/status in statuses)
		for(var/identifier in identifiers)
			sorting_operations += list(list(
				identifier,
				status
			))

	var/list/return_list = list()
	for(var/list/sort in sorting_operations)
		for(var/list/vaurca in vaurca_list)
			var/list/fullname = splittext(vaurca["name"], "'")
			var/vaurca_identifier = fullname[1]
			var/vaurca_status = fullname[2]
			if(vaurca_identifier == sort[1] && vaurca_status == sort[2])
				return_list += list(vaurca)

	return return_list
