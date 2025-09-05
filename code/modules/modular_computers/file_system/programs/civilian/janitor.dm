/datum/computer_file/program/civilian/janitor
	filename = "janitor"
	filedesc = "Custodial Supplies Locator"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program is used by custodial staff to keep track of work-related supplies."
	usage_flags = PROGRAM_ALL_REGULAR
	size = 4
	required_access_run = ACCESS_JANITOR
	required_access_download = ACCESS_JANITOR
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	tgui_id = "Janitor"
	var/list/types = list("Mops", "Buckets", "Cleanbots", "Janicarts")

/datum/computer_file/program/civilian/janitor/ui_data(mob/user)
	var/list/data = list()

	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/turf/p = get_turf(user)
	var/dir
	data["categories"] = list()
	data["supplies"] = list()

	data["user_x"] = p ? p.x : null
	data["user_y"] = p ? p.y : null

	data["categories"] = types
	var/status = ""
	var/list/supplies = list()

	for(var/atom/A in GLOB.janitorial_supplies)
		var/supply_type
		if(istype(A, /obj/item/mop))
			var/obj/item/mop/M = A
			status = M.reagents.total_volume ? "Wet" : "Dry"
			supply_type = "Mops"
		else if(istype(A, /obj/structure/mopbucket))
			var/obj/structure/mopbucket/B = A
			status = (B.reagents.total_volume / B.reagents.maximum_volume) * 100
			status = "[status]% filled"
			supply_type = "Buckets"
		else if(istype(A, /mob/living/bot/cleanbot))
			var/mob/living/bot/cleanbot/C = A
			status = C.on ? "Online" : "Offline"
			supply_type = "Cleanbots"
		else if(istype(A, /obj/structure/cart/storage/janitorialcart))
			var/obj/structure/cart/storage/janitorialcart/J = A
			status = J.get_short_status()
			supply_type = "Janicarts"
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
			"z" = AT.z,
			"dir" = dir,
			"status" = status,
			"supply_type" = supply_type
		)

		supplies += list(L)

	data["supplies"] = supplies

	return data

