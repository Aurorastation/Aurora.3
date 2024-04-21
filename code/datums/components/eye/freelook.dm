//For mobs connecting to the station's cameranet without needing AI procs
/datum/component/eye/cameranet
	eye_type = /mob/abstract/eye/cameranet

//For mobs connecting to other visualnets. Pass visualnet as eye_args in look()
/datum/component/eye/freelook
	eye_type = /mob/abstract/eye

/datum/component/eye/freelook/proc/set_visualnet(var/datum/visualnet/net)
	if(component_eye)
		var/mob/abstract/eye/eye = component_eye
		if(istype(eye))
			eye.visualnet = net
