// EYE
//
// A mob that another mob controls to look around the station with.
// It streams chunks as it moves around, which will show it what the controller can and cannot see.

/mob/abstract/eye
	name = "Eye"
	var/name_suffix = "Eye"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	alpha = 127
	density = 0

	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/owner_follows_eye = 0

	see_in_dark = 7
	status_flags = GODMODE
	invisibility = INVISIBILITY_EYE

	var/mob/owner = null
	var/list/visibleChunks = list()

	var/ghostimage = null
	var/datum/visualnet/visualnet

/mob/abstract/eye/New()
	ghostimage = image(src.icon,src,src.icon_state)
	SSmob.ghost_darkness_images |= ghostimage //so ghosts can see the eye when they disable darkness
	SSmob.ghost_sightless_images |= ghostimage //so ghosts can see the eye when they disable ghost sight
	updateallghostimages()
	..()

/mob/abstract/eye/Destroy()
	if (ghostimage)
		SSmob.ghost_darkness_images -= ghostimage
		SSmob.ghost_sightless_images -= ghostimage
		qdel(ghostimage)
		ghostimage = null
		updateallghostimages()

	release(owner)
	owner = null
	visualnet = null
	return ..()

/mob/abstract/eye/Move(n, direct)
	if(owner == src)
		return EyeMove(n, direct)
	return 0

/mob/abstract/eye/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

/mob/abstract/eye/examinate()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/abstract/eye/pointed()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/abstract/eye/examine(mob/user)
	return

/mob/abstract/eye/proc/possess(var/mob/user)
	if(owner && owner != user)
		return
	if(owner && owner.eyeobj != src)
		return

	owner = user
	owner.eyeobj = src
	name = "[owner.name] ([name_suffix])"
	if(owner.client)
		owner.client.eye = src
	setLoc(owner)
	visualnet.update_eye_chunks(src, TRUE)

/mob/abstract/eye/proc/release(var/mob/user)
	if(owner != user || !user)
		return
	if(owner.eyeobj != src)
		return
	visualnet.remove_eye(src)
	owner.eyeobj = null
	owner = null
	name = initial(name)

// Use this when setting the eye's location.
// It will also stream the chunk that the new loc is in.
/mob/abstract/eye/proc/setLoc(var/T)
	if(!owner)
		return FALSE
	
	T = get_turf(T)
	if(!T || T == loc)
		return FALSE

	forceMove(T)

	if(owner.client)
		owner.client.eye = src
	if(owner_follows_eye)
		owner.forceMove(loc)
	
	visualnet.update_eye_chunks(src)
	return TRUE

/mob/abstract/eye/proc/getLoc()
	if(owner)
		if(!isturf(owner.loc) || !owner.client)
			return
		return loc

/mob
	var/mob/abstract/eye/eyeobj

/mob/proc/EyeMove(n, direct)
	if(!eyeobj)
		return

	return eyeobj.EyeMove(n, direct)

/mob/abstract/eye/EyeMove(n, direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.timeofday)
		sprint = initial

	for(var/i = 0; i < max(sprint, initial); i += 20)
		var/turf/step = get_turf(get_step(src, direct))
		if(step)
			setLoc(step)

	cooldown = world.timeofday + 5
	if(acceleration)
		sprint = min(sprint + 0.5, max_sprint)
	else
		sprint = initial
	return 1
