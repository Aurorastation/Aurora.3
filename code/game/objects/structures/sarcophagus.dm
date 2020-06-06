/obj/structure/sarcophagus
	name = "sarcophagus"
	desc = "A sealed ancient sarcophagus."
	icon = 'icons/obj/sarcophagus.dmi'
	icon_state = "sarcophagus"
	density = 1
	anchored = 0
	var/open = FALSE

/obj/structure/sarcophagus/examine(mob/user)
	..()
	if(!open)
		to_chat(user, "\The [src]'s lid is closed shut.")
	else
		to_chat(user, "\The [src]'s lid is open.")

/obj/structure/sarcophagus/Initialize()
	. = ..()
	if(prob(25))
		desc = "Don't open it."

/obj/structure/sarcophagus/update_icon()
	if(open)
		icon_state = "sarcophagus_open"
	else
		icon_state = initial(icon_state)

/obj/structure/sarcophagus/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
		if(3.0)
			if(prob(25))
				open()
	return

/obj/structure/sarcophagus/attackby(obj/item/I as obj, mob/user as mob)
	if(open)
		return
	if(istype(I, /obj/item/sarcophagus_key))
		to_chat(usr, "<span class='notice'>You slide \the [I] inside an opening in \the [src].</span>")
		open()

/obj/structure/sarcophagus/proc/open()
	playsound((get_turf(src)), 'sound/effects/stonedoor_openclose.ogg', 100, 1)
	open = TRUE
	update_icon()

	if(prob(25))
		explosion(get_turf(src), 2, 3, 4, 4)
		qdel(src)
		return

	var/outcomes = pick("remains", "xenoarch", "highvalue", "supermatter", "artifact", "beyond")
	switch(outcomes)
		if("remains")
			new /obj/effect/decal/remains/xeno (get_turf(src))
		if("xenoarch")
			new /obj/item/archaeological_find (get_turf(src))
		if("highvalue")
			new /obj/random/highvalue (get_turf(src))
		if("supermatter")
			new /obj/machinery/power/supermatter/shard (get_turf(src))
		if("artifact")
			new /obj/machinery/artifact (get_turf(src))
		if("beyond")
			new /obj/machinery/from_beyond (get_turf(src))
	return

/obj/item/sarcophagus_key
	name = "ancient key"
	desc = "An archaic key, probably not used to open any airlock on station."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "unknown1"
	w_class = 2