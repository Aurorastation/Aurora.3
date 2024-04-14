/obj/item/blueprints
	name = "blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/item/tools/blueprints.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	var/list/valid_z_levels = list()
	var/area_prefix

/obj/item/blueprints/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/blueprints/LateInitialize()
	. = ..()
	desc = "Blueprints of the [station_name()]. There is a \"Classified\" stamp and several coffee stains on it."
	if(set_valid_z_levels())
		create_blueprint_component()

/obj/item/blueprints/attack_self(mob/user)
	if(use_check_and_message(usr, USE_DISALLOW_SILICONS) || usr.get_active_hand() != src)
		return
	add_fingerprint(user)
	var/datum/component/eye/blueprints = GetComponent(/datum/component/eye)
	if(!(user.z in valid_z_levels))
		to_chat(user, SPAN_WARNING("The markings on this are entirely irrelevant to your whereabouts!"))
		return
	if(blueprints)
		if(blueprints.look(user, get_look_args())) // Abandon all peripheral vision, ye who enter here.
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

/obj/item/blueprints/proc/create_blueprint_component() //So that subtypes can override
	AddComponent(/datum/component/eye/blueprints)

/obj/item/blueprints/proc/get_look_args() // ditto
	return list(valid_z_levels, area_prefix)

//Blueprints for building exoplanet outposts
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

/obj/item/blueprints/shuttle
	///Name of the blueprints' linked shuttle. Should be preset for mapped-in versions, unless the shuttle spawns on its map z-level.
	var/shuttle_name
	desc_info = "These blueprints can be used to modify a shuttle. In order to be used, the shuttle must be located on its \"Open Space\" z-level. Newly-created areas will be automatically added to the shuttle. If all shuttle areas are removed, the shuttle will be destroyed!"

/obj/item/blueprints/shuttle/set_valid_z_levels()
	if(SSatlas.current_map.use_overmap)
		var/area/A = get_area(src)
		var/obj/effect/overmap/visitable/ship/landable/S
		for(var/obj/effect/overmap/visitable/ship/landable/landable in SSshuttle.ships)
			var/datum/shuttle/shuttle = SSshuttle.shuttles[landable.shuttle]
			if(A in shuttle.shuttle_area)
				S = landable
				break
		if(istype(S) && !isnull(S))
			if(isnull(shuttle_name))
				shuttle_name = S.shuttle
			update_linked_name(S, null, S.name)
			RegisterSignal(S, COMSIG_QDELETING, PROC_REF(on_shuttle_destroy))
			RegisterSignal(S, COMSIG_BASENAME_SETNAME, PROC_REF(update_linked_name))
			valid_z_levels += S.map_z
			area_prefix = S.name
			return TRUE
	// The blueprints are useless now, but keep them around for fluff.
	desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
	return FALSE

/obj/item/blueprints/shuttle/proc/update_linked_name(atom/namee, old_name, new_name)
	name = "\improper [new_name] blueprints"
	desc = "Blueprints of \the [new_name]. There are several coffee stains on it."
	area_prefix = new_name

/obj/item/blueprints/shuttle/proc/on_shuttle_destroy(datum/destroyed)
	UnregisterSignal(destroyed, COMSIG_QDELETING)
	UnregisterSignal(destroyed, COMSIG_BASENAME_SETNAME)
	name = initial(name)
	desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
	valid_z_levels = list()
	area_prefix = null

/obj/item/blueprints/shuttle/create_blueprint_component()
	AddComponent(/datum/component/eye/blueprints/shuttle)

/obj/item/blueprints/shuttle/get_look_args()
	return list(valid_z_levels, area_prefix, shuttle_name)
