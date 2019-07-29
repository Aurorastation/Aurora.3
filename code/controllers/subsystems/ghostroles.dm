#define UIDEBUG

/var/datum/controller/subsystem/ghostroles/SSghostroles

/datum/controller/subsystem/ghostroles
	name = "Ghost Roles"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_FIRST

	var/list/spawnpoints = list() //List of the available spawnpoints by spawnpoint type
		// -> type 1 -> spawnpoint 1
		//           -> spawnpoint 2

	var/list/spawners = list() //List of the available spawner datums

/datum/controller/subsystem/ghostroles/Recover()
	src.spawnpoints = SSghostroles.spawnpoints
	src.spawners = SSghostroles.spawners

/datum/controller/subsystem/ghostroles/New()
	NEW_SS_GLOBAL(SSghostroles)
	for(var/spawner in subtypesof(/datum/ghostspawner))
		var/datum/ghostspawner/G = new spawner
		//Check if we have name, short_name and desc set
		if(!G.short_name || !G.name || !G.desc)
			continue
		//Check if we have a spawnpoint on the current map
		if(!G.select_spawnpoint(FALSE))
			continue
		LAZYSET(spawners, G.short_name, G)

//Adds a spawnpoint to the spawnpoint list
/datum/controller/subsystem/ghostroles/proc/add_spawnpoints(var/obj/effect/ghostspawpoint/P)
	if(!P.identifier) //If the spawnpoint has no identifier -> Abort
		log_ss("ghostroles","Spawner [P] at [P.x],[P.y],[P.z] has no identifier set")
		qdel(P)
		return

	if(!(P.identifier in spawnpoints))
		spawnpoints[P.identifier] = list()
	
	spawnpoints[P.identifier].Add(P)
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
		ui = new(user,src,"misc-ghostspawner",950,700,"Ghost Role Spawner", nstate = interactive_state)
		ui.data = vueui_data_change(list("spawnpoint"=spawnpoint,"current_tag"="All"),user,ui)
	ui.open()

/datum/controller/subsystem/ghostroles/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
	if(!newdata)
		. = newdata = list("current_tag"="All")
	LAZYINITLIST(newdata["spawners"])
	for(var/s in spawners)
		var/datum/ghostspawner/G = spawners[s]
		if(G.cant_see(user))
			continue
		LAZYINITLIST(newdata["spawners"][G.short_name])
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["name"], html_encode(G.name), ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["desc"], html_encode(G.desc), ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["cant_spawn"], G.cant_spawn(user), ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["can_edit"], G.can_edit(user), ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["enabled"], G.enabled, ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["count"], G.count, ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["max_count"], G.max_count, ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["tags"], G.tags, ., newdata)
		VUEUI_SET_CHECK(newdata["spawners"][G.short_name]["spawnpoints"], G.spawnpoints, ., newdata)

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