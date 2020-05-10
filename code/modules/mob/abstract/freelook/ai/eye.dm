// AI EYE
//
// A mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/abstract/eye/cameranet
	// Generic version of the AI eye without the AI-specific handling, for things like the Camera MIU mask.
	name = "Inactive Camera Eye"
	name_suffix = "Camera Eye"

/mob/abstract/eye/cameranet/Initialize()
	. = ..()
	visualnet = cameranet

/mob/abstract/eye/aiEye
	name = "Inactive AI Eye"
	name_suffix = "AI Eye"
	icon_state = "AI-eye"

/mob/abstract/eye/aiEye/Initialize()
	. = ..()
	visualnet = cameranet

/mob/abstract/eye/aiEye/setLoc(var/T, var/cancel_tracking = 1)
	. = ..()
	if(. && isAI(owner))
		var/mob/living/silicon/ai/ai = owner
		if(cancel_tracking)
			ai.ai_cancel_tracking()

		//Holopad
		if(ai.holo && ai.hologram_follow)
			ai.holo.move_hologram(ai)
		return 1

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	holo = null

/mob/living/silicon/ai/proc/destroy_eyeobj(var/atom/new_eye)
	if(!eyeobj) return
	if(!new_eye)
		new_eye = src
	QDEL_NULL(eyeobj)
	if(client)
		client.eye = new_eye

/mob/living/silicon/ai/proc/create_eyeobj(var/newloc = get_turf(src))
	if(eyeobj) destroy_eyeobj()
	eyeobj = new /mob/abstract/eye/aiEye(newloc)
	eyeobj.possess(src)

// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/Initialize()
	. = ..()
	create_eyeobj()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.eyeobj.setLoc(src)

// Return to the Core.
/mob/living/silicon/ai/proc/core()
	set category = "AI Commands"
	set name = "AI Core"

	view_core()

/mob/living/silicon/ai/proc/view_core()
	camera = null
	unset_machine()

	if(!src.eyeobj)
		return

	eyeobj.possess(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "AI Commands"
	set name = "Toggle Camera Acceleration"

	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration
	to_chat(usr, "Camera acceleration has been toggled [eyeobj.acceleration ? "on" : "off"].")
