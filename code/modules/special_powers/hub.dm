/obj/screen/hub
	name = "hub"
	hidden = FALSE
	var/image/on_cooldown

/obj/screen/hub/New(var/mob/living/_owner)
	on_cooldown = image(icon, "cooldown")
	..()
	START_PROCESSING(SSprocessing, src)

/obj/screen/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner = null
	. = ..()

/obj/screen/hub/process()
	..()
	if(!istype(owner))
		qdel(src)
		return