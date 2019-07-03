/obj/item/mecha_equipment/mounted_system/plasmacutter
	holding_type = /obj/item/weapon/gun/energy/plasmacutter
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/mecha_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mecha_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/obj/structure/carrying

/obj/item/mecha_equipment/clamp/attack()
	return 0

/obj/item/mecha_equipment/clamp/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(. && !carrying)
		if(istype(target, /obj/structure))
			var/obj/structure/S = target
			if(!S.anchored)
				owner.visible_message("<span class='notice'>\The [owner] begins loading \the [S].</span>")
				if(do_after(owner, 20, S, 0, 1))
					S.forceMove(src)
					carrying = S
					owner.visible_message("<span class='notice'>\The [owner] loads \the [S] into its cargo compartment.</span>")

/obj/item/mecha_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!carrying)
			to_chat(user, "<span class='warning'>You are not carrying anything in \the [src].</span>")
		else
			owner.visible_message("<span class='notice'>\The [owner] unloads \the [carrying].</span>")
			carrying.forceMove(get_turf(src))
			carrying = null

/obj/item/mecha_equipment/clamp/get_hardpoint_maptext()
	if(carrying)
		return carrying.name
	. = ..()

// A lot of this is copied from flashlights.
/obj/item/mecha_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)

	var/on = 0
	light_range = 8
	light_power = 8

/obj/item/mecha_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")
		update_icon()

/obj/item/mecha_equipment/light/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light()
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)