/datum/computer_file/program/camera_monitor/hacked
	filename = "camcrypt"
	filedesc = "Camera Decryption Tool"
	program_icon_state = "hostile"
	program_key_icon_state = "red_key"
	extended_desc = "This very advanced piece of software uses adaptive programming and large database of cipherkeys to bypass most encryptions used on camera networks. Be warned that the system administrator may notice this."
	size = 8
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	color = LIGHT_COLOR_RED

/datum/computer_file/program/camera_monitor/hacked/process_tick()
	..()
	if(program_state != PROGRAM_STATE_ACTIVE) // Background programs won't trigger alarms.
		return

	// The program is active and connected to one of the station's networks. Has a very small chance to trigger IDS alarm every tick.
	if(current_network && (current_network in current_map.station_networks) && prob(0.1))
		if(GLOB.ntnet_global.intrusion_detection_enabled)
			GLOB.ntnet_global.add_log("IDS WARNING - Unauthorised access detected to camera network [current_network] by device with NID [computer.network_card.get_network_tag()]")
			GLOB.ntnet_global.intrusion_detection_alarm = TRUE

/datum/computer_file/program/camera_monitor/hacked/can_access_network(var/mob/user, var/network_access)
	return TRUE

// The hacked variant has access to all commonly used networks.
/datum/computer_file/program/camera_monitor/hacked/modify_networks_list(var/list/networks)
	networks.Add(list(list("tag" = NETWORK_CRESCENT, "has_access" = TRUE)))
	return networks
