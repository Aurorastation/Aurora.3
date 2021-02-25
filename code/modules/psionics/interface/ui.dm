/obj/screen/psi
	icon = 'icons/mob/screen/psi.dmi'
	var/mob/living/owner
	var/hidden = TRUE

/obj/screen/psi/New(var/mob/living/_owner)
	SHOULD_CALL_PARENT(FALSE) // since this is a recent bay port, i assume this is intentional - geeves | 25/02/2021
	loc = null
	owner = _owner
	update_icon()

/obj/screen/psi/Destroy()
	if(owner && owner.client)
		owner.client.screen -= src
	. = ..()
