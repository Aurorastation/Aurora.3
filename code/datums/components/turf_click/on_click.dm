/datum/component/on_click
	var/atom/atom_holder

/datum/component/on_click/Initialize()
	..()
	if(isatom(parent)) 
		atom_holder = parent

/datum/component/on_click/Destroy()
	atom_holder = null
	return ..()

/datum/component/on_click/proc/on_click(var/mob/user)
	return FALSE