/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/turf/simulated/open/CanZPass(atom, direction)
	return 1

/turf/space/CanZPass(atom, direction)
	return 1

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	plane = PLANE_SPACE_BACKGROUND
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/turf/below

/turf/simulated/open/post_change()
	..()
	update()

/turf/simulated/open/initialize()
	..()
	update()

/turf/simulated/open/proc/update()
	below = GetBelow(src)
	levelupdate()
	for(var/atom/movable/A in src)
		A.fall()
	update_icon()

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/Entered(var/atom/movable/mover)
	..()
	mover.fall()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/update_icon()
	if(below)
		var/image/t_img = list()
		var/image/temp = image(icon = below.icon, icon_state = below.icon_state)
		temp.color = rgb(127,127,127)
		temp.overlays += below.overlays
		t_img += temp
		underlays += t_img

		var/image/o_img = list()
		for(var/obj/o in below)
			// ingore objects that have any form of invisibility
			if(o.invisibility) continue
			var/image/temp2 = image(o, dir=o.dir, layer = TURF_LAYER+0.05*o.layer)
			temp2.color = rgb(127,127,127)
			temp2.overlays += o.overlays
			o_img += temp2
		underlays += o_img

	var/list/noverlays = list()
	if(!istype(below,/turf/space))
		noverlays += image(icon =icon, icon_state = "empty", layer = 2.45)
	else
		// This is stolen from /turf/space's New() proc.
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
		var/image/I = image('icons/turf/space_parallax1.dmi',"[icon_state]")
		I.plane = PLANE_SPACE_DUST
		I.alpha = 80
		I.blend_mode = BLEND_ADD
		noverlays += I

	for(var/direction in cardinal)
		var/turf/simulated/T = get_step(src,direction)
		if(istype(T) && !istype(T,/turf/simulated/open))
			if(istype(T,/turf/simulated/mineral))
				var/image/border = image(icon = 'icons/turf/walls.dmi', icon_state = "rock_side", dir = direction, layer = 3)
				noverlays += border
			else if(istype(T,/turf/simulated/floor/asteroid))
				var/image/border = image(icon = 'icons/turf/cliff.dmi', icon_state = "sand", dir = direction, layer = 3)
				noverlays += border

	var/obj/structure/stairs/S = locate() in below
	if(S && S.loc == below)
		var/image/I = image(icon = S.icon, icon_state = "below", dir = S.dir, layer = 2.45)
		I.pixel_x = S.pixel_x
		I.pixel_y = S.pixel_y
		noverlays += I

	overlays = noverlays

/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>You lay down the support lattice.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z))
		return

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	//To lay cable.
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return 1
