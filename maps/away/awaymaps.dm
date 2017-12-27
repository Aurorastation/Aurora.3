/datum/away_map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path
	var/gatewayonly = 1 // if the map can only be accessed through the gateway
	var/list/weathertypes = list()
	var/zloc = 0 // what z it is on

/datum/away_map/proc/handle_random_gen()
	return