/obj/structure/closet/secure_closet/sciguncabinet
	name = "science gun cabinet"
	req_access = list(access_tox_storage)
	icon = 'icons/obj/sciguncabinet.dmi'
	icon_state = "base"
	icon_off ="base"
	icon_broken ="base"
	icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"
	anchored = TRUE
	canbemoved = TRUE
	secured_wires = TRUE

/obj/structure/closet/secure_closet/sciguncabinet/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/secure_closet/sciguncabinet/LateInitialize()
	..()
	update_icon()

/obj/structure/closet/secure_closet/sciguncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/sciguncabinet/update_icon()
	cut_overlays()
	if(opened)
		add_overlay("door_open")
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/gun/G in contents)
			if (istype(G, /obj/item/gun/energy))
				lazors++
			if (istype(G, /obj/item/gun/projectile/))
				shottas++
		if (lazors || shottas)
			for (var/i = 0 to 2)
				if (lazors > 0 && (shottas <= 0 || prob(50)))
					lazors--
					add_overlay("laser[i]")
				else if (shottas > 0)
					shottas--
					add_overlay("projectile[i]")

		add_overlay("door")
		if(welded)
			add_overlay(welded_overlay_state)
		if(crowbarred)
			add_overlay("crowbarred")

		if(broken)
			add_overlay("off")
		else if (locked)
			add_overlay("locked")
		else
			add_overlay("open")