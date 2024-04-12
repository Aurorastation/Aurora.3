// Freelook Eye
//
// Streams chunks as it moves around, which will show it what the controller can and cannot see.

/mob/abstract/eye/freelook
	var/list/visibleChunks = list()
	var/datum/visualnet/visualnet

/mob/abstract/eye/freelook/Initialize(var/mapload, var/datum/visualnet/net)
	. = ..()
	if(net)
		visualnet = net

/mob/abstract/eye/freelook/Destroy()
	. = ..()
	visualnet = null

/mob/abstract/eye/freelook/possess(var/mob/user)
	. = ..()
	if(visualnet)
		visualnet.update_eye_chunks(src, TRUE)

/mob/abstract/eye/freelook/release(var/mob/user)
	if(visualnet && user == owner)
		visualnet.remove_eye(src)
	. = ..()

// Streams the chunk that the new loc is in.
/mob/abstract/eye/freelook/setLoc(var/T)
	. = ..()

	if(. && visualnet)
		visualnet.update_eye_chunks(src)
