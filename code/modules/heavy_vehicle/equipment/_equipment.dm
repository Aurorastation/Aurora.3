// Defining all of this here so it's centralized.
// Used by the mecha HUD to get a 1-10 value representing charge, ammo, etc.
/obj/item/mecha_equipment
	name = "exosuit hardpoint system"
	icon = 'icons/mecha/mech_equipment.dmi'
	icon_state = ""
	var/on_mech_icon_state
	matter = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_PLASTIC = 5000, MATERIAL_OSMIUM = 500)
	force = 10
	var/restricted_hardpoints
	var/mob/living/heavy_vehicle/owner
	var/list/restricted_software
	var/mech_layer = MECH_GEAR_LAYER
	var/equipment_delay = 0
	var/passive_power_use = 0
	var/active_power_use = 1 KILOWATTS
	var/require_adjacent = TRUE
	var/active = FALSE //For gear that has an active state (ie, floodlights)

/obj/item/mecha_equipment/examine(mob/user, distance)
	. = ..()
	if(length(restricted_hardpoints))
		var/hardpoints = english_list(restricted_hardpoints, and_text = ", ")
		to_chat(user, SPAN_NOTICE("<b>Exosuit Mounts:</b> [hardpoints]"))
	if(length(restricted_software))
		var/software = english_list(restricted_software, and_text = ", ")
		to_chat(user, SPAN_NOTICE("<b>Exosuit Software Requirement:</b> [software]"))

/obj/item/mecha_equipment/attack() //Generally it's not desired to be able to attack with items
	return 0

/obj/item/mecha_equipment/proc/get_effective_obj()
	return src

/obj/item/mecha_equipment/mounted_system
	var/holding_type
	var/obj/item/holding

/obj/item/mecha_equipment/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	if(require_adjacent)
		if(!inrange)
			return 0
	if (owner && loc == owner && ((user in owner.pilots) || user == owner))
		if(target in owner.contents)
			return 0

		if(!(owner.get_cell()?.check_charge(active_power_use * CELLRATE)))
			to_chat(user, "<span class='warning'>The power indicator flashes briefly as you attempt to use \the [src].</span>")
			return 0
		return 1
	else
		return 0

/obj/item/mecha_equipment/attack_self(var/mob/user)
	if (owner && loc == owner && ((user in owner.pilots) || user == owner))
		if(!(owner.get_cell()?.check_charge(active_power_use * CELLRATE)))
			to_chat(user, "<span class='warning'>The power indicator flashes briefly as you attempt to use \the [src].</span>")
			return 0
		return 1
	else
		return 0

/obj/item/mecha_equipment/proc/deactivate()
	active = FALSE
	return

/obj/item/mecha_equipment/proc/installed(var/mob/living/heavy_vehicle/_owner)
	owner = _owner
	//generally attached. Nothing should be able to grab it
	canremove = FALSE

/obj/item/mecha_equipment/proc/uninstalled()
	if(active)
		deactivate()
	owner = null
	canremove = TRUE

/obj/item/mecha_equipment/Destroy()
	owner = null
	. = ..()

/obj/item/mecha_equipment/mob_can_unequip(mob/M, slot, disable_warning)
	. = ..()
	if(. && owner)
		//Installed equipment shall not be unequiped.
		return FALSE

/obj/item/mecha_equipment/mounted_system/attack_self(var/mob/user)
	. = ..()
	if(. && holding)
		return holding.attack_self(user)

/obj/item/mecha_equipment/mounted_system/proc/forget_holding()
	if(holding) //It'd be strange for this to be called with this var unset
		destroyed_event.unregister(holding, src, PROC_REF(forget_holding))
		holding = null

/obj/item/mecha_equipment/mounted_system/Initialize()
	. = ..()
	if(holding_type)
		holding = new holding_type(src)
		destroyed_event.register(holding, src, PROC_REF(forget_holding))
	if(holding)
		if(!icon_state)
			icon = holding.icon
			icon_state = holding.icon_state
		if(istype(holding, /obj/item/gun))
			var/obj/item/gun/G = holding
			G.has_safety = FALSE
			G.safety_state = FALSE
		desc = "[holding.desc] This one is suitable for installation on an exosuit."

/obj/item/mecha_equipment/mounted_system/Destroy()
	if(holding)
		QDEL_NULL(holding)
	. = ..()

/obj/item/mecha_equipment/mounted_system/get_effective_obj()
	return (holding ? holding : src)

/obj/item/mecha_equipment/proc/MouseDragInteraction()
	return 0

/obj/item/mecha_equipment/mounted_system/get_hardpoint_status_value()
	return (holding ? holding.get_hardpoint_status_value() : null)

/obj/item/mecha_equipment/mounted_system/get_hardpoint_maptext()
	return (holding ? holding.get_hardpoint_maptext() : null)

/obj/item/proc/get_hardpoint_status_value()
	return null

/obj/item/proc/get_hardpoint_maptext()
	return null

/obj/item/mecha_equipment/mounted_system/get_cell()
	if(owner && loc == owner)
		return owner.get_cell()
	return null