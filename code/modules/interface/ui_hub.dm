/obj/screen/interface/hub
	name = "Hub"
	var/image/on_cooldown

/obj/screen/interface/hub/New(var/mob/living/_owner)
	on_cooldown = image(icon, "cooldown")
	..()
	START_PROCESSING(SSprocessing, src)

/obj/screen/interface/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner = null
	. = ..()

/obj/screen/interface/hub/process()
	if(!istype(owner))
		qdel(src)
		return

//For an example of click behaviour, see psi_hub.dm.
