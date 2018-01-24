// MASK EYE
//
// A mob that a cultists controls to look around the station with.
// It streams chunks as it moves around, which will show it what the cultist can and cannot see.

/mob/abstract/eye/maskEye
	name = "Eye of Nar-Sie"
	acceleration = 0
	owner_follows_eye = 1

/mob/abstract/eye/maskEye/New()
	..()
	visualnet = cultnet
