/var/datum/controller/subsystem/ghostroles/SSghostroles

/datum/controller/subsystem/ghostroles
	name = "Ghost Roles"
	flags = SS_NO_FIRE

	var/list/list/spawnpoints = list() //List of the available spawnpoints by spawnpoint type
		// -> type 1 -> spawnpoint 1
		//           -> spawnpoint 2

	var/list/spawners = list() //List of the available spawner datums

	// For special spawners that have mobile or object spawnpoints
	var/list/spawn_types = list("Golems", "Borers")
	var/list/spawn_atom = list()

/datum/controller/subsystem/ghostroles/Recover()
	src.spawnpoints = SSghostroles.spawnpoints
	src.spawners = SSghostroles.spawners

/datum/controller/subsystem/ghostroles/New()
	NEW_SS_GLOBAL(SSghostroles)

/datum/controller/subsystem/ghostroles/Initialize(start_timeofday)
	. = ..()
	for(var/spawner in subtypesof(/datum/ghostspawner))
		CHECK_TICK
		var/datum/ghostspawner/G = new spawner
		//Check if we have name, short_name and desc set
		if(!G.short_name || !G.name || !G.desc)
			log_ss("ghostroles","Spawner [G.type] got removed from selection because of missing data")
			continue
		//Check if we have a spawnpoint on the current map
		if(!G.select_spawnlocation(FALSE) && G.loc_type == GS_LOC_POS)
			log_ss("ghostroles","Spawner [G.type] got removed from selection because of missing spawnpoint")
			continue
		spawners[G.short_name] = G

	for (var/identifier in spawnpoints)
		CHECK_TICK
		update_spawnpoint_status_by_identifier(identifier)

	for(var/spawn_type in spawn_types)
		spawn_atom[spawn_type] = list()

//Adds a spawnpoint to the spawnpoint list
/datum/controller/subsystem/ghostroles/proc/add_spawnpoints(var/obj/effect/ghostspawpoint/P)
	if(!P.identifier) //If the spawnpoint has no identifier -> Abort
		log_ss("ghostroles","Spawner [P] at [P.x],[P.y],[P.z] has no identifier set")
		qdel(P)
		return

	if(!spawnpoints[P.identifier])
		spawnpoints[P.identifier] = list()

	spawnpoints[P.identifier].Add(P)
	//Only update the status if the round is started. During initialization that´s taken care of at the end of init.
	if(ROUND_IS_STARTED)
		update_spawnpoint_status(P)

/datum/controller/subsystem/ghostroles/proc/update_spawnpoint_status(var/obj/effect/ghostspawpoint/P)
	if(!P || !istype(P))
		return null
	//If any of the spawners uses that spawnpoint and is active set the status to available
	for(var/s in spawners)
		var/datum/ghostspawner/G = spawners[s]
		if(!G.is_enabled())
			continue
		if(!(P.identifier in G.spawnpoints))
			continue
		P.set_available()
		return TRUE
	P.set_unavailable()
	return FALSE

/datum/controller/subsystem/ghostroles/proc/update_spawnpoint_status_by_identifier(var/identifier)
	if(!identifier) //If no identifier ist set, return false
		return null
	if(!length(spawnpoints[identifier])) //If we have no spawnpoints for that identifier, return false
		return null

	for (var/spawnpoint in spawnpoints[identifier])
		CHECK_TICK
		var/obj/effect/ghostspawpoint/P = spawnpoint
		update_spawnpoint_status(P)

/datum/controller/subsystem/ghostroles/proc/remove_spawnpoints(var/obj/effect/ghostspawpoint/G)
	spawnpoints[G.identifier].Remove(G)
	return

//Returns the turf where the spawnpoint is located and updates the spawner to be used
/datum/controller/subsystem/ghostroles/proc/get_spawnpoint(var/identifier, var/use = TRUE)
	if(!identifier) //If no identifier ist set, return false
		return null
	if(!length(spawnpoints[identifier])) //If we have no spawnpoints for that identifier, return false
		return null

	for (var/spawnpoint in spawnpoints[identifier])
		var/obj/effect/ghostspawpoint/P = spawnpoint
		if(P.is_available())
			if(use)
				P.set_spawned()
			return get_turf(P)

/datum/controller/subsystem/ghostroles/proc/vui_interact(mob/user,var/spawnpoint=null)
	var/datum/vueui/ui = SSvueui.get_open_ui(user,src)
	if(!ui)
		ui = new(user,src,"misc-ghostspawner",950,700,"Ghost Role Spawner", state = interactive_state)
		ui.data = vueui_data_change(list("spawnpoint"=spawnpoint,"current_tag"="All"),user,ui)
	ui.open()

/datum/controller/subsystem/ghostroles/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list("current_tag"="All")
	LAZYINITLIST(data["spawners"])
	for(var/s in spawners)
		var/datum/ghostspawner/G = spawners[s]
		if(G.cant_see(user))
			//if we have this spawner in our data list, then remove it
			if(data["spawners"][G.short_name])
				data["spawners"] -= G.short_name
			continue
		var/cant_spawn = G.cant_spawn(user)
		LAZYINITLIST(data["spawners"][G.short_name])
		VUEUI_SET_CHECK(data["spawners"][G.short_name]["name"], G.name, ., data)
		if(cant_spawn)
			VUEUI_SET_CHECK(data["spawners"][G.short_name]["desc"], "[G.desc] ([cant_spawn])", ., data)
		else
			VUEUI_SET_CHECK(data["spawners"][G.short_name]["desc"], G.desc, ., data)
		VUEUI_SET_CHECK(data["spawners"][G.short_name]["cant_spawn"], cant_spawn, ., data)
		VUEUI_SET_CHECK(data["spawners"][G.short_name]["can_edit"], G.can_edit(user), ., data)
		VUEUI_SET_CHECK(data["spawners"][G.short_name]["enabled"], G.enabled, ., data)
		VUEUI_SET_CHECK(data["spawners"][G.short_name]["count"], G.count, ., data)
		VUEUI_SET_CHECK(data["spawners"][G.short_name]["spawnatoms"], length(G.spawn_atoms), ., data)
		VUEUI_SET_CHECK(data["spawners"][G.short_name]["max_count"], G.max_count, ., data)
		VUEUI_SET_CHECK_LIST(data["spawners"][G.short_name]["tags"], G.tags, ., data)
		VUEUI_SET_CHECK_LIST(data["spawners"][G.short_name]["spawnpoints"], G.spawnpoints, ., data)

/datum/controller/subsystem/ghostroles/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return
	if(href_list["spawn"])
		var/spawner = href_list["spawn"]
		var/datum/ghostspawner/S = spawners[spawner]
		if(!S)
			return
		var/cant_spawn = S.cant_spawn(usr)
		if(cant_spawn)
			to_chat(usr, "Unable to spawn: [cant_spawn]")
			return
		if(isnewplayer(usr))
			var/mob/abstract/new_player/N = usr
			N.close_spawn_windows()
		if(!S.pre_spawn(usr))
			to_chat(usr, "Unable to spawn: pre_spawn failed. Report this on GitHub")
			return
		var/mob/M = S.spawn_mob(usr)
		if(!M)
			to_chat(usr, "Unable to spawn: spawn_mob failed. Report this on GitHub")
			return
		if(!S.post_spawn(M))
			to_chat(usr, "Unable to spawn: post_spawn failed. Report this on GitHub")
			return
		log_and_message_admins("joined as GhostRole: [S.name]", M)
		SSvueui.check_uis_for_change(src) //Make sure to update all the UIs so the count is updated
	if(href_list["enable"])
		var/datum/ghostspawner/S = spawners[href_list["enable"]]
		if(!S)
			return
		if(!S.can_edit(usr))
			return
		if(!S.enabled)
			S.enable()
			to_chat(usr, "Ghost spawner enabled: [S.name]")
			SSvueui.check_uis_for_change(src) //Update all the UIs to update the status of the spawner
			for(var/i in S.spawnpoints)
				update_spawnpoint_status_by_identifier(i)
	if(href_list["disable"])
		var/datum/ghostspawner/S = spawners[href_list["disable"]]
		if(!S)
			return
		if(!S.can_edit(usr))
			return
		if(S.enabled)
			S.disable()
			to_chat(usr, "Ghost spawner disabled: [S.name]")
			SSvueui.check_uis_for_change(src) //Update all the UIs to update the status of the spawner
			for(var/i in S.spawnpoints)
				update_spawnpoint_status_by_identifier(i)
	return

/datum/controller/subsystem/ghostroles/proc/add_spawn_atom(var/ghost_role_name, var/atom/spawn_atom)
	if(ghost_role_name && spawn_atom)
		var/datum/ghostspawner/G = spawners[ghost_role_name]
		if(G && !(spawn_atom in G.spawn_atoms))
			G.spawn_atoms += spawn_atom
			if(G.atom_add_message)
				say_dead_direct("[G.atom_add_message]<br>Spawn in as it by using the ghost spawner menu in the ghost tab, and try to be good!")

/datum/controller/subsystem/ghostroles/proc/remove_spawn_atom(var/ghost_role_name, var/atom/spawn_atom)
	if(ghost_role_name && spawn_atom)
		var/datum/ghostspawner/G = spawners[ghost_role_name]
		if(G)
			G.spawn_atoms -= spawn_atom

/datum/controller/subsystem/ghostroles/proc/get_spawn_atoms(var/ghost_role_name)
	var/datum/ghostspawner/G = spawners[ghost_role_name]
	if(G)
		return G.spawn_atoms
	return list()

//Returns the spawner with the specified (short) name or null
/datum/controller/subsystem/ghostroles/proc/get_spawner(var/spawner_name)
	if(spawner_name in spawners)
		return spawners[spawner_name]
	return null
