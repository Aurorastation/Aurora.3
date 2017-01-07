/datum/computer_file/program/camera_monitor/engineering
    filename = "cameng"
    filedesc = "Engineering Camera Monitoring"
    nanomodule_path = /datum/nano_module/camera_monitor/engineering
    program_icon_state = "cameras"
    extended_desc = "This program allows remote access to engineering camera network."
    size = 12
    available_on_ntnet = 1
    requires_ntnet = 1
    required_access_download = access_heads
    required_access_run = access_engine

/datum/nano_module/camera_monitor/engineering
	name = "Engineering Camera Monitoring Program"
	available_to_ai = FALSE //Not useful for AI´s its a duplicate of the normal one with less cams

// The hacked variant has access to all commonly used networks.
/datum/nano_module/camera_monitor/engineering/modify_networks_list(var/list/networks)
    var/list/eng_networks[0]
    for(var/network in engineering_networks)
        eng_networks.Add(list(list(
                            "tag" = network,
                            "has_access" = 1
                            )))
    return eng_networks
