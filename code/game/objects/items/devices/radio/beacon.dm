var/global/list/teleportbeacons = list()

/obj/item/device/radio/beacon
	name = "tracking beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaler"
	var/code = "electronic"
	origin_tech = list(TECH_BLUESPACE = 1)

/obj/item/device/radio/beacon/fulton
	name = "two-way bluespace beacon"
	desc = "A single-use, disposable tracking beacon capable of accurately translocating cargo containers when used alongside a bluespace teleporter. Not for use with sentient life."
	origin_tech = list(TECH_BLUESPACE = 4)

	var/attached

/obj/item/device/radio/beacon/fulton/proc/remove()
	var/obj/O = attached
	if(istype(O))
		O.overlays.Cut()
	for(var/mob/M in hearers(src, null))
		M.show_message("<span class='warning'>\The [src] shorts out and breaks!</span>")
	qdel(src)

/obj/item/device/radio/beacon/fulton/syndicate
	name = "illicit two-way beacon"
	desc = "A single-use, disposable tracking beacon capable of accurately translocating cargo containers when used alongside a bluespace teleporter. This one looks purposefully tampered with."
	frequency = SYND_FREQ


/obj/item/device/radio/beacon/New()
	..()
	teleportbeacons += src

/obj/item/device/radio/beacon/Destroy()
	teleportbeacons.Remove(src)
	return ..()

/obj/item/device/radio/beacon/hear_talk()
	return


/obj/item/device/radio/beacon/send_hear()
	return null


/obj/item/device/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	if ((usr.canmove && !( usr.restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return


/obj/item/device/radio/beacon/bacon //Probably a better way of doing this, I'm lazy.
	proc/digest_delay()
		QDEL_IN(src, 600)


// SINGULO BEACON SPAWNER

/obj/item/device/radio/beacon/syndicate
	name = "suspicious beacon"
	desc = "A label on it reads: <i>Activate to have a singularity beacon teleported to your location</i>."
	origin_tech = list(TECH_BLUESPACE = 1, TECH_ILLEGAL = 7)

/obj/item/device/radio/beacon/syndicate/attack_self(mob/user as mob)
	if(user)
		to_chat(user, "<span class='notice'>Locked In</span>")
		new /obj/machinery/power/singularity_beacon/syndicate( user.loc )
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return
