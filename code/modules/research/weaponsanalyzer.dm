/obj/machinery/weapons_analyzer
	name = "Weapons Analyzer"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "weapon_analyzer"
	density = 1
	anchored = 1
	use_power = 1
	var/obj/item/weapon/gun/gun = null

/obj/machinery/weapons_analyzer/examine(mob/user)
	..()
	to_chat(user, span("notice", "It has [gun ? "[gun]" : "nothing"] attached."))

/obj/machinery/weapons_analyzer/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(!I || !user || !ishuman(user))
		return
	
	if(istype(I, /obj/item/weapon/gun))
		if(gun)
			to_chat(user, span("warning", "\The [src] already has \the [gun] mounted. Remove it first."))
			return
		gun = I
		var/mob/living/carbon/human/H = user
		H.drop_from_inventory(I)
		I.forceMove(src)
		update_icon()

/obj/machinery/weapons_analyzer/verb/eject_gun()
	set category = "Object"
	set name = "Eject gun"
	set src in view(1)

	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))
		return
	
	if(!gun)
		to_chat(usr, span("warning", "There is no gun in \the [src]."))
		return
	
	gun.forceMove(usr.loc)
	gun = null
	update_icon()

/obj/machinery/weapons_analyzer/update_icon()
	icon_state = initial(icon_state)
	cut_overlays()

	if(gun)
		icon_state = "[icon_state]_on"
		var/icon/gun_I = new /icon(gun.icon, gun.icon_state)

		// Making gun sprite smaller and centering it where we want, cause dang they are thicc
		gun_I.Scale(round(gun_I.Width() * 0.6), round(gun_I.Height() * 0.6))
		var/image/gun_overlay = image(gun_I)
		gun_overlay.pixel_x += 8
		gun_overlay.pixel_y += 8
		add_overlay(gun_overlay, TRUE)