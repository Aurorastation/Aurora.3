/obj/screen/psi
	icon = 'icons/mob/screen/psi.dmi'
	var/mob/living/owner
	var/hidden = TRUE

/obj/screen/psi/New(var/mob/living/_owner)
	loc = null
	owner = _owner
	update_icon()

/obj/screen/psi/Destroy()
	if(owner && owner.client)
		owner.client.screen -= src
	. = ..()
