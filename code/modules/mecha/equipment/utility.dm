/obj/item/weapon/mecha_equipment/mounted_system/drill
	icon_state = "mecha_drill"
	holding_type = /obj/item/weapon/pickaxe/drill
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/weapon/mecha_equipment/mounted_system/drill/diamond
	icon_state = "mecha_diamond_drill"
	holding_type = /obj/item/weapon/pickaxe/diamonddrill

/obj/item/weapon/mecha_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mecha_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/weapon/weldingtool/get_hardpoint_status_value()
	return (get_fuel()/max_fuel)

/obj/item/weapon/weldingtool/get_hardpoint_maptext()
	return "[get_fuel()]/[max_fuel]"

/obj/item/weapon/mecha_equipment/mounted_system/plasmacutter
	holding_type = /obj/item/weapon/gun/energy/plasmacutter
	restricted_software = list(MECH_SOFTWARE_UTILITY)

// A lot of this is copied from flashlights.
/obj/item/weapon/mecha_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)

	var/on = 0
	var/brightness_on = 8

/obj/item/weapon/mecha_equipment/light/attack_self(mob/user)
	on = !on
	user << "You switch \the [src] [on ? "on" : "off"]."
	update_icon()
	return 1

/obj/item/weapon/mecha_equipment/light/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)