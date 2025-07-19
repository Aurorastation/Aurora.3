/obj/item/blueprints
	name = "blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/item/blueprints.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	w_class = WEIGHT_CLASS_SMALL
	var/list/valid_z_levels = list()
	var/area_prefix
	///Will these blueprints display the wire schema?
	var/show_wires = TRUE
	///Airlock wires
	var/datum/wires/airlock/blueprint/airlock_wires
	///Vending machine wires
	var/datum/wires/vending/blueprint/vending_wires

/obj/item/blueprints/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/blueprints/LateInitialize()
	. = ..()
	if(show_wires)
		airlock_wires = new(src)
		vending_wires = new(src)
	desc = "Blueprints of the [station_name()]. There is a \"Classified\" stamp and several coffee stains on it."
	if(set_valid_z_levels())
		create_blueprint_component()

/obj/item/blueprints/attack_self(mob/user)
	if(use_check_and_message(usr, USE_DISALLOW_SILICONS) || usr.get_active_hand() != src)
		return
	add_fingerprint(user)
	if(show_wires)
		var/choice = tgui_alert(user, "Select blueprint action", "Blueprints", list("Airlock Wire Schema", "Vending Wire Schema", "Use Blueprints"))
		if(choice == "Airlock Wire Schema")
			airlock_wires.get_wire_diagram(user)
		else if(choice == "Vending Wire Schema")
			vending_wires.get_wire_diagram(user)
		if(choice != "Use Blueprints") //Don't do the normal blueprints stuff if the user just wants wires
			return

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
	valid_z_levels = SSmapping.levels_by_trait(ZTRAIT_STATION)

/obj/item/blueprints/proc/create_blueprint_component() //So that subtypes can override
	AddComponent(/datum/component/eye/blueprints)

/obj/item/blueprints/proc/get_look_args() // ditto
	return list(valid_z_levels, area_prefix)

//Blueprints for building exoplanet outposts
/obj/item/blueprints/outpost
	name = "outpost blueprints"
	icon_state = "blueprints2"
	show_wires = FALSE

/obj/item/blueprints/outpost/attack_self(mob/user)
	if(!length(valid_z_levels) || !valid_z_levels) //Outpost blueprints can initialize before exoplanets, so put this in here to doublecheck it.
		set_valid_z_levels()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[GET_Z(user)]"]
	if(istype(E))
		if(E.generated_name) //Prevent the prefix from being super long with the planet type appended
			area_prefix = E.planet_name
		else
			area_prefix = E.name
	else
		area_prefix = E.name
	. = ..()

/obj/item/blueprints/outpost/set_valid_z_levels()
	if(!SSatlas.current_map.use_overmap)
		desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
		return FALSE
	desc = "Blueprints for the daring souls wanting to establish a planetary outpost. Has some sketchy looking stains and what appears to be bite holes."
	var/area/overmap/map = GLOB.map_overmap
	for(var/obj/effect/overmap/visitable/sector/exoplanet/E in map)
		valid_z_levels += E.map_z
	if(length(SSodyssey.scenario_zlevels))
		valid_z_levels += SSodyssey.scenario_zlevels
	return TRUE

/obj/item/blueprints/shuttle
	///Name of the blueprints' linked shuttle. Mapped-in versions should have this preset, or be mapped into the shuttle area itself.
	var/shuttle_name
	///The actual overmap shuttle type, for setting on preset blueprints.
	var/obj/effect/overmap/visitable/ship/landable/shuttle_type

/obj/item/blueprints/shuttle/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "These blueprints can be used to modify a shuttle. In order to be used, the shuttle must be located on its \"Open Space\" z-level."
	. += "Newly-created areas will be automatically added to the shuttle. If all shuttle areas are removed, the shuttle will be destroyed!"

/obj/item/blueprints/shuttle/set_valid_z_levels()
	if(SSatlas.current_map.use_overmap)
		var/area/A = get_area(src)

		if(!shuttle_type)
			for(var/obj/effect/overmap/visitable/ship/landable/landable in SSshuttle.ships)
				var/datum/shuttle/shuttle = SSshuttle.shuttles[landable.shuttle]
				if(shuttle && (A in shuttle.shuttle_area))
					shuttle_type = landable
					break
		else
			var/obj/effect/overmap/visitable/ship/landable/S = SSshuttle.ship_by_type(shuttle_type)
			shuttle_type = S

		if(istype(shuttle_type) && !isnull(shuttle_type))
			if(isnull(shuttle_name))
				shuttle_name = shuttle_type.shuttle
			update_linked_name(shuttle_type, null, shuttle_type.name)
			RegisterSignal(shuttle_type, COMSIG_QDELETING, PROC_REF(on_shuttle_destroy))
			RegisterSignal(shuttle_type, COMSIG_BASENAME_SETNAME, PROC_REF(update_linked_name))
			valid_z_levels += shuttle_type.map_z
			area_prefix = shuttle_type.name
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

/obj/item/blueprints/shuttle/intrepid
	shuttle_name = "Intrepid"
	shuttle_type = /obj/effect/overmap/visitable/ship/landable/intrepid

/obj/item/blueprints/shuttle/mining_shuttle
	shuttle_name = "Spark"
	shuttle_type = /obj/effect/overmap/visitable/ship/landable/mining_shuttle

/obj/item/blueprints/shuttle/canary
	shuttle_name = "Canary"
	shuttle_type = /obj/effect/overmap/visitable/ship/landable/canary

/obj/item/blueprints/shuttle/quark
	shuttle_name = "Quark"
	shuttle_type = /obj/effect/overmap/visitable/ship/landable/quark

/obj/item/storage/lockbox/shuttle_blueprints //Blueprints for modifying the Horizon's shuttles.
	name = "shuttle blueprints lockbox"
	req_access = list(ACCESS_CE)
	starts_with = list(
		/obj/item/blueprints/shuttle/intrepid = 1,
		/obj/item/blueprints/shuttle/mining_shuttle = 1,
		/obj/item/blueprints/shuttle/canary = 1,
		/obj/item/blueprints/shuttle/quark = 1,
	)
