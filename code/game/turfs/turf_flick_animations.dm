/proc/anim(turf/location as turf,target as mob|obj,a_icon,a_icon_state as text,flick_anim as text,sleeptime = 0,direction as num)
	SHOULD_NOT_SLEEP(TRUE)
//This proc throws up either an icon or an animation for a specified amount of time.
//The variables should be apparent enough.
	if(!location && target)
		location = get_turf(target)
	if(location && !target)
		target = location
	var/atom/movable/overlay/animation = new(location)
	if(direction)
		animation.set_dir(direction)
	animation.icon = a_icon
	animation.layer = target:layer+1
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		animation.master = target
		flick(flick_anim, animation)

	QDEL_IN(animation, max(sleeptime, 15))
