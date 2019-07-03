// Defining all of this here so it's centralized.
// Used by the mecha HUD to get a 1-10 value representing charge, ammo, etc.
/obj/item/mecha_equipment
	name = "mech hardpoint system"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = ""
	matter = list("steel" = 35000, "plastic" = 7500, "osmium" = 1500)
	force = 10

	var/restricted_hardpoints
	var/mob/living/heavy_vehicle/owner
	var/list/restricted_software

/obj/item/mecha_equipment/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	return (owner && loc == owner)

/obj/item/mecha_equipment/attack_self(var/mob/user)
	return (owner && owner.pilot == user)

/obj/item/mecha_equipment/proc/installed(var/mob/living/heavy_vehicle/_owner)
	owner = _owner
	//moved_event.register(owner, src, /obj/item/mecha_equipment/proc/on_owner_move)

/obj/item/mecha_equipment/proc/uninstalled()
	moved_event.unregister(owner, src)
	owner = null

/*/obj/item/mecha_equipment/proc/on_owner_move()
	if(light_obj) light_obj.follow_holder()*/

/obj/item/mecha_equipment/proc/get_effective_obj()
	return src

/obj/item/mecha_equipment/mounted_system
	var/holding_type
	var/obj/item/holding

/obj/item/mecha_equipment/mounted_system/attack_self(var/mob/user)
	. = ..()
	if(. && holding)
		return holding.attack_self(user)

/obj/item/mecha_equipment/mounted_system/New()
	..()
	if(holding_type)
		holding = new holding_type(src)
	if(holding)
		if(!icon_state)
			icon = holding.icon
			icon_state = holding.icon_state
		name = holding.name
		desc = "[holding.desc] This one is suitable for installation on an exosuit."

/obj/item/mecha_equipment/mounted_system/get_effective_obj()
	return (holding ? holding : src)

/obj/item/mecha_equipment/mounted_system/get_hardpoint_status_value()
	return (holding ? holding.get_hardpoint_status_value() : null)

/obj/item/mecha_equipment/mounted_system/get_hardpoint_maptext()
	return (holding ? holding.get_hardpoint_maptext() : null)

/obj/item/proc/get_hardpoint_status_value()
	return null

/obj/item/proc/get_hardpoint_maptext()
	return null