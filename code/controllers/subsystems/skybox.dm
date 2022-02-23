var/datum/controller/subsystem/skybox/SSskybox

/datum/controller/subsystem/skybox
	name = "Space skybox"
	init_order = SS_INIT_PARALLAX
	flags = SS_NO_FIRE
	var/background_color
	var/skybox_icon = 'icons/skybox/skybox.dmi' //Skyboxes need to be 736x736
	var/base_icon = "ceti" //in case it all fails
	var/image/current_skybox

/datum/controller/subsystem/skybox/New()
	NEW_SS_GLOBAL(SSskybox)

/datum/controller/subsystem/skybox/Initialize()
	..()
	generate_skybox()

/datum/controller/subsystem/skybox/Recover()
	generate_skybox()

/datum/controller/subsystem/skybox/proc/get_skybox()
	if(!current_skybox)
		generate_skybox()
	return current_skybox

/datum/controller/subsystem/skybox/proc/generate_skybox()
	var/image/res = image(skybox_icon)
	res.appearance_flags = KEEP_TOGETHER
	var/background_icon
	if(SSatlas.current_sector)
		background_icon = SSatlas.current_sector.skybox_icon
	else
		background_icon = base_icon

	var/image/base = overlay_image(skybox_icon, background_icon)

	res.overlays += base

	//todo: add overlay stuff here, like asteroid and etc

	for(var/datum/event/E in SSevents.active_events)
		if(E.has_skybox_image && E.isRunning)
			res.overlays += E.get_skybox_image()

	current_skybox = res

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes()
	generate_skybox()

	for(var/client/C)
		C.update_skybox(1)

//todo: a proc that lets skyboxes change based on stuff like nar'sie and etc.