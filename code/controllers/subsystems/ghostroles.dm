SUBSYSTEM_DEF(ghostroles)
	name = "Ghost Roles"
	flags = SS_NO_FIRE
	init_order = SS_INIT_GHOSTROLES

	var/list/spawnpoints = list() //List of the available spawnpoints by spawnpoint type
		// -> type 1 -> spawnpoint 1
		//           -> spawnpoint 2

	var/list/spawners = list() //List of the available spawner datums

	// For special spawners that have mobile or object spawnpoints
	var/list/spawn_types = list("Golems", "Borers")
	var/list/spawn_atom = list()

/datum/controller/subsystem/ghostroles/Recover()
	src.spawnpoints = SSghostroles.spawnpoints
	src.spawners = SSghostroles.spawners

/datum/controller/subsystem/ghostroles/Initialize(start_timeofday)
	. = ..()
	for(var/spawner in subtypesof(/datum/ghostspawner))
		CHECK_TICK
		var/datum/ghostspawner/G = new spawner
		//Check if we have name, short_name and desc set
		if(!G.short_name || !G.name || !G.desc)
			log_subsystem_ghostroles("Spawner [G.type] got removed from selection because of missing data")
			continue
		//Check if we have a spawnpoint on the current map
		if(!G.select_spawnlocation(FALSE) && G.loc_type == GS_LOC_POS)
			log_subsystem_ghostroles("Spawner [G.type] got removed from selection because of missing spawnpoint")
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
		log_subsystem_ghostroles_error("Spawner [P] at [P.x],[P.y],[P.z] has no identifier set")
		qdel(P)
		return

	if(!spawnpoints[P.identifier])
		spawnpoints[P.identifier] = list()

	spawnpoints[P.identifier] += P
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
	spawnpoints[G.identifier] -= G
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

/datum/controller/subsystem/ghostroles/ui_state(mob/user)
	return always_state

/datum/controller/subsystem/ghostroles/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/controller/subsystem/ghostroles/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GhostSpawner", "Ghost Spawners")
		ui.open()

/datum/controller/subsystem/ghostroles/ui_data(mob/user)
	var/list/data = list()
	data["spawners"] = list()
	data["categories"] = list()
	for(var/s in spawners)
		var/datum/ghostspawner/G = spawners[s]
		if(G.cant_see(user))
			continue
		var/cant_spawn = G.cant_spawn(user)
		var/list/manifest = list()
		if(LAZYLEN(G.spawned_mobs))
			for(var/datum/weakref/mob_ref in G.spawned_mobs)
				var/mob/spawned_mob = mob_ref.resolve()
				if(spawned_mob)
					manifest += spawned_mob.real_name
		var/list/spawner = list(
			"short_name" = G.short_name,
			"name" = G.name,
			"desc" = G.desc,
			"type" = G.type,
			"cant_spawn" = cant_spawn,
			"can_edit" = G.can_edit(user),
			"can_jump_to" = G.can_jump_to(user),
			"enabled" = G.enabled,
			"count" = G.count,
			"spawn_atoms" = length(G.spawn_atoms),
			"max_count" = G.max_count,
			"tags" = G.tags,
			"spawnpoints" = G.spawnpoints,
			"manifest" = manifest
		)
		data["categories"] |= G.tags
		data["spawners"] += list(spawner)
	return data

/datum/controller/subsystem/ghostroles/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("spawn")
			var/spawner = params["spawn"]
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
			LAZYADD(S.spawned_mobs, WEAKREF(M))
			log_and_message_admins("joined as GhostRole: [S.name]", M)
			SStgui.update_uis(src)
			. = TRUE

		if("jump_to")
			var/spawner_id = params["spawner_id"]
			var/datum/ghostspawner/human/spawner = spawners[spawner_id]
			var/mob/abstract/observer/observer = usr
			if(spawner && istype(observer) && spawner.can_jump_to(observer))
				var/atom/turf = spawner.select_spawnlocation(FALSE)
				if(isturf(turf))
					observer.on_mob_jump()
					observer.forceMove(turf)

		if("follow_manifest_entry")
			var/spawner_id = params["spawner_id"]
			var/spawned_mob_name = params["spawned_mob_name"]
			var/datum/ghostspawner/human/spawner = spawners[spawner_id]
			var/mob/abstract/observer/observer = usr
			if(istype(observer) && spawner.can_jump_to(observer) && spawner && LAZYLEN(spawner.spawned_mobs))
				for(var/datum/weakref/mob_ref in spawner.spawned_mobs)
					var/mob/spawned_mob = mob_ref.resolve()
					if(spawned_mob && spawned_mob.real_name == spawned_mob_name)
						observer.ManualFollow(spawned_mob)
						break

		if("enable")
			var/datum/ghostspawner/S = spawners[params["enable"]]
			if(!S)
				return
			if(!S.can_edit(usr))
				return
			if(!S.enabled)
				S.enable()
				to_chat(usr, SPAN_NOTICE("Ghost spawner enabled: [S.name]"))
				SStgui.update_uis(src)
				for(var/i in S.spawnpoints)
					update_spawnpoint_status_by_identifier(i)
				. = TRUE

		if("disable")
			var/datum/ghostspawner/S = spawners[params["disable"]]
			if(!S)
				return
			if(!S.can_edit(usr))
				return
			if(S.enabled)
				S.disable()
				to_chat(usr, SPAN_NOTICE("Ghost spawner disabled: [S.name]"))
				SStgui.update_uis(src)
				for(var/i in S.spawnpoints)
					update_spawnpoint_status_by_identifier(i)
				. = TRUE

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
