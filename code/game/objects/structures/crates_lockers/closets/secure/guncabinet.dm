/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = list(ACCESS_ARMORY)
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	anchored = TRUE
	canbemoved = TRUE

	door_underlay = TRUE
	door_anim_squish = 0.12
	door_anim_angle = 119
	door_hinge_x = -9.5

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/secure_closet/guncabinet/LateInitialize()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	ClearOverlays()
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
				AddOverlays("laser[i]")
			else if (shottas > 0)
				shottas--
				AddOverlays("projectile[i]")
	. = ..()

/obj/structure/closet/secure_closet/guncabinet/sci
	name = "science gun cabinet"
	req_access = list(ACCESS_TOX_STORAGE)
	icon_state = "sci"

/obj/structure/closet/secure_closet/guncabinet/peac
	name = "anti-materiel weapons platform cabinet"

/obj/structure/closet/secure_closet/guncabinet/peac/fill()
	new /obj/item/gun/projectile/peac/unloaded(src)
	for(var/i = 1 to 4)
		new /obj/item/ammo_casing/peac(src)
