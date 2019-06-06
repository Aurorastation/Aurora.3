/obj/machinery/weapons_analyzer
	name = "Weapons Analyzer"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "weapon_analyzer"
	density = 1
	anchored = 1
	use_power = 1
	var/obj/item/weapon/gun/gun = null
	var/obj/item/device/laser_assembly/assembly = null
	var/process = FALSE

/obj/machinery/weapons_analyzer/examine(mob/user)
	..()
	to_chat(user, span("notice", "It has [gun ? "[gun]" : "nothing"] attached."))

/obj/machinery/weapons_analyzer/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(!I || !user || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(istype(I, /obj/item/weapon/gun))

		if(!check_gun(user))
			return

		gun = I

		H.drop_from_inventory(I)
		I.forceMove(src)
		update_icon()
	else if(istype(I, /obj/item/device/laser_assembly))
		if(!check_gun(user))
			return

		var/obj/item/device/laser_assembly/A = I
		A.ready_to_craft = TRUE
		assembly = A
		H.drop_from_inventory(I)
		I.forceMove(src)
		A.analyzer = WEAKREF(src)
		update_icon()
	else if(istype(I, /obj/item/laser_components))
		if(!assembly)
			to_chat(user, span("warning", "\The [src] does not have any assembly installed!"))
			return
		assembly.attackby(I, user)
		playsound(loc, 'sound/machines/weapns_analyzer.ogg', 75, 1)
		process = TRUE
		addtimer(CALLBACK(src, .proc/reset), 20)
		update_icon()

/obj/machinery/weapons_analyzer/proc/reset()
	process = FALSE

/obj/machinery/weapons_analyzer/proc/check_gun(var/mob/user)
	if(gun)
		to_chat(user, span("warning", "\The [src] already has \the [gun] mounted. Remove it first."))
		return FALSE
	if(assembly)
		to_chat(user, span("warning", "\The [src] already has \the [assembly] mounted. Remove it first."))
		return FALSE
	return TRUE

/obj/machinery/weapons_analyzer/verb/eject_gun_or_assembly()
	set category = "Object"
	set name = "Eject gun or assembly"
	set src in view(1)

	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))
		return
	
	if(!gun)
		to_chat(usr, span("warning", "There is no gun in \the [src]."))
		return
	
	if(!assembly)
		to_chat(usr, span("warning", "There is no assembly in \the [src]."))
		return
	
	if(gun)
		gun.forceMove(usr.loc)
		gun = null
		update_icon()

	else
		gun.forceMove(usr.loc)
		assembly.ready_to_craft = FALSE
		assembly.analyzer = null
		assembly = null
		update_icon()

/obj/machinery/weapons_analyzer/update_icon()
	icon_state = initial(icon_state)
	cut_overlays()

	var/icon/Icon_used

	if(gun)
		icon_state = "[icon_state]_on"
		Icon_used = new /icon(gun.icon, gun.icon_state)

	else if(assembly)
		icon_state = process ?  "[icon_state]_on" : "[icon_state]_on"
		Icon_used = new /icon(assembly.icon, assembly.icon_state)

	if(Icon_used)
		// Making gun sprite smaller and centering it where we want, cause dang they are thicc
		Icon_used.Scale(round(Icon_used.Width() * 0.6), round(Icon_used.Height() * 0.6))
		var/image/gun_overlay = image(Icon_used)
		gun_overlay.pixel_x += 7
		gun_overlay.pixel_y += 8
		add_overlay(gun_overlay)