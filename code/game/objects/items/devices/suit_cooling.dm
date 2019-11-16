/obj/item/device/suit_cooling_unit
	name = "portable suit cooling unit"
	desc = "A portable heat sink and liquid cooled radiator that can be hooked up to a space suit's existing temperature controls to provide industrial levels of cooling."
	w_class = 4
	icon = 'icons/obj/suitcooler.dmi'
	icon_state = "suitcooler0"
	item_state = "coolingpack"
	contained_sprite = 1
	slot_flags = SLOT_BACK	//you can carry it on your back if you want, but it won't do anything unless attached to suit storage

	//copied from tank.dm
	flags = CONDUCT
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4

	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2)

	var/celltype = /obj/item/cell	//comes with the crappy default power cell - high-capacity ones shouldn't be hard to find

	matter = list(DEFAULT_WALL_MATERIAL = 25000, "glass" = 3500)
	var/on = 0				//is it turned on?
	var/cover_open = 0		//is the cover open?
	var/obj/item/cell/cell
	var/max_cooling = 12				//in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 16.6		//charge per second at max_cooling
	var/thermostat = T20C

	//TODO: make it heat up the surroundings when not in space

/obj/item/device/suit_cooling_unit/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	cell = new celltype(src)

/obj/item/device/suit_cooling_unit/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(cell)
	return ..()

// Checks whether the cooling unit is being worn on the back/suit slot.
// That way you can't carry it in your hands while it's running to cool yourself down.
/obj/item/device/suit_cooling_unit/proc/is_in_slot()
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return 0

	return (H.back == src) || (H.s_store == src)

/obj/item/device/suit_cooling_unit/process()
	if (!on || !cell)
		return

	if (!is_in_slot())
		return

	var/mob/living/carbon/human/H = loc

	var/efficiency = !!(H.species.flags & ACCEPTS_COOLER) || 1 - H.get_pressure_weakness()		//you need to have a good seal for effective cooling; some species can directly connect to the cooler, so get a free 100% efficiency here
	var/env_temp = get_environment_temperature()		//wont save you from a fire
	var/temp_adj = min(H.bodytemperature - max(thermostat, env_temp), max_cooling)

	if (temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj/max_cooling)*charge_consumption

	H.bodytemperature -= temp_adj*efficiency

	cell.use(charge_usage)

	if(cell.charge <= 0)
		turn_off()

	update_icon()

/obj/item/device/suit_cooling_unit/proc/get_environment_temperature()
	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(istype(H.loc, /obj/mecha))
			var/obj/mecha/M = H.loc
			return M.return_temperature()
		else if(istype(H.loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/C = H.loc
			return C.air_contents.temperature

	var/turf/T = get_turf(src)
	if(istype(T, /turf/space))
		return 0	//space has no temperature, this just makes sure the cooling unit works in space

	var/datum/gas_mixture/environment = T.return_air()
	if (!environment)
		return 0

	return environment.temperature

/obj/item/device/suit_cooling_unit/proc/attached_to_suit(mob/M)
	if (!ishuman(M))
		return 0

	var/mob/living/carbon/human/H = M

	if (!H.wear_suit || H.s_store != src)
		return 0

	return 1

/obj/item/device/suit_cooling_unit/proc/turn_on()
	if(!cell)
		return
	if(cell.charge <= 0)
		return

	on = 1
	update_icon()

/obj/item/device/suit_cooling_unit/proc/turn_off()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.show_message("\The [src] clicks and whines as it powers down.", 2)	//let them know in case it's run out of power.
	on = 0
	update_icon()

/obj/item/device/suit_cooling_unit/attack_self(mob/user as mob)
	if(cover_open && cell)
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.forceMove(get_turf(loc))

		cell.add_fingerprint(user)
		cell.update_icon()

		to_chat(user, "You remove the [src.cell].")
		src.cell = null
		update_icon()
		return

	//TODO use a UI like the air tanks
	if(on)
		turn_off()
	else
		turn_on()
		if (on)
			to_chat(user, "You switch on the [src].")

/obj/item/device/suit_cooling_unit/attackby(obj/item/W as obj, mob/user as mob)
	if (W.isscrewdriver())
		if(cover_open)
			cover_open = 0
			to_chat(user, "You screw the panel into place.")
		else
			cover_open = 1
			to_chat(user, "You unscrew the panel.")
		update_icon()
		return

	if (istype(W, /obj/item/cell))
		if(cover_open)
			if(cell)
				to_chat(user, "There is a [cell] already installed here.")
			else
				user.drop_from_inventory(W,src)
				cell = W
				to_chat(user, "You insert the [cell].")
		update_icon()
		return

	return ..()

/obj/item/device/suit_cooling_unit/update_icon()
	cut_overlays()
	if (cover_open)
		if (cell)
			icon_state = "suitcooler1"
		else
			icon_state = "suitcooler2"
		return

	icon_state = "suitcooler0"

	if(!cell || !on)
		return

	switch(round(cell.percent()))
		if(86 to INFINITY)
			add_overlay("battery-0")
		if(69 to 85)
			add_overlay("battery-1")
		if(52 to 68)
			add_overlay("battery-2")
		if(35 to 51)
			add_overlay("battery-3")
		if(18 to 34)
			add_overlay("battery-4")
		if(-INFINITY to 17)
			add_overlay("battery-5")

/obj/item/device/suit_cooling_unit/examine(mob/user)
	if(!..(user, 1))
		return

	if (on)
		if (attached_to_suit(src.loc))
			to_chat(user, "It's switched on and running.")
		else if (ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if (H.species.flags & ACCEPTS_COOLER)
				to_chat(user, "It's switched on and running, connected to the cooling systems of [H].")
		else
			to_chat(user, "It's switched on, but not attached to anything.")
	else
		to_chat(user, "It is switched off.")

	if (cover_open)
		if(cell)
			to_chat(user, "The panel is open, exposing the [cell].")
		else
			to_chat(user, "The panel is open.")

	if (cell)
		to_chat(user, "The charge meter reads [round(cell.percent())]%.")
	else
		to_chat(user, "It doesn't have a power cell installed.")

/obj/item/device/suit_cooling_unit/improved //those should come with a better powercell
	celltype = /obj/item/cell/high
