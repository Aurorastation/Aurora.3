/**
 * Freelook eye component
 *
 * For mobs connecting to the station's cameranet without needing AI procs
 *
 * For mobs connecting to other visualnets, call set_visualnet() with the visualnet to use
 */
/datum/component/eye/freelook
	eye_type = /mob/abstract/eye/freelook

/datum/component/eye/freelook/proc/set_visualnet(datum/visualnet/net = GLOB.cameranet)
	if(component_eye)
		var/mob/abstract/eye/eye = component_eye
		if(istype(eye))
			eye.visualnet = net
