/obj/screen/interface
	var/mob/living/owner
	var/hidden = TRUE

/obj/screen/interface/New(var/mob/living/_owner)
	loc = null
	owner = _owner
	update_icon()

/obj/screen/interface/Destroy()
	if(owner && owner.client)
		owner.client.screen -= src
	. = ..()

