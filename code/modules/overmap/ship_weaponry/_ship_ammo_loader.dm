/obj/machinery/ammunition_loader
	name = "ammunition loader"
	desc = "An ammunition loader for ship weapons systems. All hands to battlestations!"
	icon = 'icons/obj/machines/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "ammo_loader"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/ship_weapon/weapon
	var/weapon_id //Used to connect weapon systems to the relevant ammunition loader.

/obj/machinery/ammunition_loader/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/ammunition_loader/LateInitialize()
	for(var/obj/machinery/ship_weapon/SW in SSmachinery.machinery)
		if(SW.weapon_id == weapon_id)
			weapon = SW
	if(!weapon)
		crash_with("[src] at [x] [y] [z] has no weapon attached!")

/obj/machinery/ammunition_loader/attackby(obj/item/W, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/H = user
		if(istype(W, /obj/item/ship_ammunition))
			var/obj/item/ship_ammunition/SA = W
			if(SA.caliber == weapon.get_caliber())
				if(SA.can_be_loaded())
					visible_message(SPAN_NOTICE("[H] begins loading \the [SA] into \the [src]..."))
					if(do_after(H, weapon.load_time))
						if(weapon.load_ammunition(SA))
							visible_message(SPAN_NOTICE("[H] loads \the [SA] into \the [src]."))
							H.drop_from_inventory(SA)
							return
						else
							to_chat(H, SPAN_WARNING("The loader's full!"))
				else
					to_chat(H, SPAN_WARNING("That ammunition's not ready to be loaded!"))
			else
				to_chat(H, SPAN_WARNING("That ammo doesn't fit here!"))
				return
	. = ..()

/obj/structure/viewport
	name = "viewport"
	desc = "A viewport for some sort of ship-mounted weapon. You can see your enemies blow up into many, many bits and pieces from here."
	icon = 'icons/obj/machines/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "viewport_generic"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	atmos_canpass = CANPASS_DENSITY

/obj/structure/viewport/zavod
	icon_state = "viewport_zavod"
