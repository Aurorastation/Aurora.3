/obj/item/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/item/tools/blueprints.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	var/list/valid_z_levels = list()
	var/area_prefix

/obj/item/blueprints/Initialize(mapload, ...)
	. = ..()
	desc = "Blueprints of the [station_name()]. There is a \"Classified\" stamp and several coffee stains on it."
	var/eye = GetComponent(/datum/component/eye)
	if(set_valid_z_levels() && !eye)
		AddComponent(/datum/component/eye/blueprints)

/obj/item/blueprints/attack_self(mob/user)
	if(use_check_and_message(usr, USE_DISALLOW_SILICONS) || usr.get_active_hand() != src)
		return
	add_fingerprint(user)
	var/datum/component/eye/blueprints = GetComponent(/datum/component/eye)
	if(!(user.z in valid_z_levels))
		to_chat(user, SPAN_WARNING("The markings on this are entirely irrelevant to your whereabouts!"))
		return
	if(blueprints)
		if(blueprints.look(user, list(valid_z_levels, area_prefix))) // Abandon all peripheral vision, ye who enter here.
			to_chat(user, SPAN_NOTICE("You start peering closely at \the [src]"))
			return
		else
			to_chat(user, SPAN_WARNING("You couldn't get a good look at \the [src]. Maybe someone else is using it?"))
			return
	to_chat(user, SPAN_WARNING("The markings on this are useless!"))

/obj/item/blueprints/proc/set_valid_z_levels()
	if(SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/S = GLOB.map_sectors["[GET_Z(src)]"]
		if(!S) //Blueprints are useless now, but keep them around for fluff
			desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
			return FALSE
		name += " - [S.name]"
		desc = "Blueprints of \the [S.name]. There is a \"Classified\" stamp and several coffee stains on it."
		valid_z_levels += S.map_z
		area_prefix = S.name
		return TRUE
	desc = "Blueprints of the [station_name()]. There is a \"Classified\" stamp and several coffee stains on it."
	area_prefix = station_name()
	valid_z_levels = SSatlas.current_map.station_levels

/obj/item/blueprints/outpost
	name = "outpost blueprints"
	icon_state = "blueprints2"

/obj/item/blueprints/outpost/attack_self(mob/user)
	var/obj/effect/overmap/visitable/sector/S = GLOB.map_sectors["[GET_Z(user)]"]
	area_prefix = S.name
	. = ..()

/obj/item/blueprints/outpost/set_valid_z_levels()
	if(!SSatlas.current_map.use_overmap)
		desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
		return FALSE
	desc = "Blueprints for the daring souls wanting to establish a planetary outpost. Has some sketchy looking stains and what appears to be bite holes."
	var/area/overmap/map = global.map_overmap
	for(var/obj/effect/overmap/visitable/sector/exoplanet/E in map)
		valid_z_levels += E.map_z
	return TRUE
