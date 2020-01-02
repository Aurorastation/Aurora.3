/obj/screen/hub
	name = "hub"
	var/mob/living/owner
	var/hidden = FALSE
	var/image/on_cooldown

/obj/screen/hub/New(var/mob/living/_owner)
	on_cooldown = image(icon, "cooldown")
	loc = null
	owner = _owner
	update_icon()
	..()
	START_PROCESSING(SSprocessing, src)

/obj/screen/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(owner && owner.client)
		owner.client.screen -= src
	owner = null
	. = ..()

/obj/screen/hub/process()
	..()
	if(!istype(owner))
		qdel(src)
		return