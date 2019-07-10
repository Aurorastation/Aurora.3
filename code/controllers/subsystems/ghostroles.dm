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
		var/datum/ghostspawner/G = spawner
		//Check if we hae name, short_name and desc set
		if(!G.short_name || !G.name || !G.desc)
			continue
		LAZYADD(spawners, G)

/datum/controller/subsystem/ghostroles/proc/add_spawnpoints(var/obj/structure/ghostspawner/G)
	if(!G.identifier)
		log_ss("ghostroles","Spawner [G] at [G.x],[G.y],[G.z] has no identifier set")
		qdel(G)
		return

	if(!(G.identifier in spawnpoints))
		spawnpoints[G.identifier] = list()
	
	spawnpoints[G.identifier].Add(G)

	
/datum/controller/subsystem/ghostroles/proc/remove_spawnpoints(var/obj/structure/ghostspawner/G)
	spawnpoints[G.identifier].Remove(G)
	return

/datum/controller/subsystem/ghostroles/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user,src)
	if(!ui)
		ui = new(user,src,"uiname",300,300,"Title of ui")
	ui.open()

/datum/controller/subsystem/ghostroles/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
	if(!newdata)
		//generate new data
		return list("counter" = 0)
	// Here we can add checks for difference of state and alter it
    // or do actions depending on its change
    if(newdata["counter"] >= 10)
        return list("counter" = 0)

/datum/controller/subsystem/ghostroles/Topic(href, href_list)
	if(href_list["action"] == "test")
        to_world("Got Test Action! [href_list["data"]]")
    return