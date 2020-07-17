/obj/item/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "hdiffuser_off"
	origin_tech = "{'magnets':5,'powerstorage':5,'esoteric':2}"
	matter = list(
		MATERIAL_GLASS = 1000,
		MATERIAL_GOLD = 100,
		MATERIAL_SILVER = 100
	)

	var/obj/item/cell/device/cell
	var/enabled = FALSE

/obj/item/shield_diffuser/update_icon()
	if(enabled)
		icon_state = "hdiffuser_on"
	else
		icon_state = "hdiffuser_off"

/obj/item/shield_diffuser/Initialize()
	. = ..()
	cell = new(src)

/obj/item/shield_diffuser/Destroy()
	QDEL_NULL(cell)
	if(enabled)
		STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/shield_diffuser/get_cell()
	return cell

/obj/item/shield_diffuser/process()
	if(!enabled)
		return

	for(var/direction in global.cardinal)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/shield/S in shielded_tile)
			// 10kJ per pulse, but gap in the shield lasts for longer than regular diffusers.
			if(istype(S) && !S.diffused_for && !S.disabled_for && cell.checked_use(10 KILOWATTS * CELLRATE))
				S.diffuse(20)

/obj/item/shield_diffuser/attack_self()
	enabled = !enabled
	update_icon()
	if(enabled)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	to_chat(usr, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/item/shield_diffuser/examine(mob/user)
	. = ..()
	to_chat(user, "The charge meter reads [cell ? cell.percent() : 0]%")
	to_chat(user, "It is [enabled ? "enabled" : "disabled"].")
