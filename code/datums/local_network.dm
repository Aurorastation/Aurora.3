var/global/list/local_networks = list()

/datum/local_network
	var/id_tag
	var/list/network_entities =    list()
	var/const/network_size    =    25 // Distance in tiles network objects can be from each other.

/datum/local_network/New(_id)
	id_tag = _id
	local_networks[id_tag] = src

/datum/local_network/Destroy()
	network_entities.Cut()
	local_networks -= src
	. = ..()

/datum/local_network/proc/within_radius(atom/checking)
	for(var/entity_list in network_entities)
		for(var/entity in entity_list)
			if(get_dist(entity, checking) > network_size)
				return FALSE
	return TRUE

/datum/local_network/proc/add_device(obj/machinery/device)
	var/list/entities = get_devices(device.type)

	if(!entities)
		entities = list()
		network_entities[device.type] = entities

	entities[device] = TRUE

	return entities[device]

/datum/local_network/proc/remove_device(obj/machinery/device)
	var/list/entities = get_devices(device.type)
	if(!entities)
		return TRUE

	entities -= device
	if(length(entities) <= 0)
		network_entities -= device.type
	if(length(network_entities) <= 0)
		qdel(src)
	return isnull(entities[device])

/datum/local_network/proc/is_connected(obj/machinery/device)
	var/list/entities = get_devices(device.type)

	if(!entities)
		return FALSE
	return !isnull(entities[device])

/datum/local_network/proc/get_devices(device_type)
	for(var/entity_type in network_entities)
		if(ispath(entity_type, device_type))
			return network_entities[entity_type]


//Multilevel network
var/global/list/multilevel_local_networks = list()

/datum/local_network/multilevel/New(_id)
	id_tag = _id
	multilevel_local_networks[id_tag] = src

/datum/local_network/multilevel/Destroy()
	network_entities.Cut()
	multilevel_local_networks -= src
	. = ..()

/datum/local_network/multilevel/within_radius(atom/checking)
	for(var/entity_list in network_entities)
		for(var/atom/entity in entity_list)
			if(!(GET_Z(entity) in GetConnectedZlevels(GET_Z(checking))))
				return FALSE
	return TRUE
