/// Generates a real, honest to god new z level. Will create the actual space, and also generate a datum that holds info about the new plot of land
/// Accepts the name, traits list, datum type, and if we should manage the turfs we create
/datum/controller/subsystem/mapping/proc/add_new_zlevel(name, traits = list(), z_type = /datum/space_level, contain_turfs = TRUE)
	UNTIL(!adding_new_zlevel)
	adding_new_zlevel = TRUE
	var/new_z = z_list.len + 1
	if (world.maxz < new_z)
		world.incrementMaxZ()
		CHECK_TICK
	// TODO: sleep here if the Z level needs to be cleared
	var/datum/space_level/S = new z_type(new_z, name, traits)
	manage_z_level(S, filled_with_space = TRUE, contain_turfs = contain_turfs)
	generate_linkages_for_z_level(new_z)
	adding_new_zlevel = FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_Z, S)
	return S

/datum/controller/subsystem/mapping/proc/get_level(z)
	if (z_list && z >= 1 && z <= z_list.len)
		return z_list[z]
	CRASH("Unmanaged z-level [z]! maxz = [world.maxz], z_list.len = [z_list ? z_list.len : "null"]")
