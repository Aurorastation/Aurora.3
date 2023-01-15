/datum/computer_file/program/civilian/janitor
	filename = "janitor"
	filedesc = "Custodial Supplies Locator"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program is used by custodial staff to keep track of work-related supplies."
	usage_flags = PROGRAM_ALL_REGULAR
	size = 4
	required_access_run = access_janitor
	required_access_download = access_janitor
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	var/sel_type = "Mops"
	var/list/types = list("Mops", "Buckets", "Cleanbots", "Janicarts")


/datum/computer_file/program/civilian/janitor/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-janitor", 500, 500, "Custodial Supplies Locator")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/civilian/janitor/vueui_transfer(oldobj)
	for(var/o in SSvueui.transfer_uis(oldobj, src, "mcomputer-janitor", 500, 500, "Custodial Supplies Locator"))
		var/datum/vueui/ui = o
		ui.auto_update_content = TRUE
	return TRUE

/datum/computer_file/program/civilian/janitor/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data
	if(!data)
		data = list()

	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/turf/p = get_turf(user)
	var/dir
	LAZYINITLIST(data["user_loc"])
	LAZYINITLIST(data["categories"])
	data["supplies"] = list()

	VUEUI_SET_CHECK(data["user_loc"]["x"], p ? p.x : null, ., data)
	VUEUI_SET_CHECK(data["user_loc"]["y"], p ? p.y : null, ., data)

	if(LAZYLEN(data["categories"]) != LAZYLEN(types))
		VUEUI_SET_CHECK_LIST(data["categories"], types, ., data)

	if(!sel_type || !data["sel_category"])
		VUEUI_SET_CHECK(data["sel_category"], "Mops", ., data)
		sel_type = data["sel_category"]
	else if (sel_type != data["sel_category"])
		VUEUI_SET_CHECK(data["sel_category"], sel_type, ., data)

	var/status = ""
	var/list/supplies = list()

	for(var/atom/A in global.janitorial_supplies)
		if(istype(A, /obj/item/mop) && sel_type == "Mops")
			var/obj/item/mop/M = A
			status = M.reagents.total_volume ? "Wet" : "Dry"
		else if(istype(A, /obj/structure/mopbucket) && sel_type == "Buckets")
			var/obj/structure/mopbucket/B = A
			status = (B.reagents.total_volume / B.reagents.maximum_volume) * 100
			status = "[status]% filled"
		else if(istype(A, /mob/living/bot/cleanbot) && sel_type == "Cleanbots")
			var/mob/living/bot/cleanbot/C = A
			status = C.on ? "Online" : "Offline"
		else if(istype(A, /obj/structure/janitorialcart) && sel_type == "Janicarts")
			var/obj/structure/janitorialcart/J = A
			status = J.get_short_status()
		else
			continue

		var/turf/AT = get_turf(A)
		if(AT && AreConnectedZLevels(AT.z, p.z))
			dir = dir2text(get_dir(p, AT))
		if(!dir)
			continue

		dir = uppertext(dir)

		var/list/L = list(
			"name" = A.name,
			"key" = length(supplies),
			"x" = AT.x,
			"y" = AT.y,
			"dir" = dir,
			"status" = status
		)

		supplies[++supplies.len] = L

	data["supplies"] = supplies

	return data

/datum/computer_file/program/civilian/janitor/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["selected"])
		sel_type = href_list["selected"]

	SSvueui.check_uis_for_change(src)
	return
