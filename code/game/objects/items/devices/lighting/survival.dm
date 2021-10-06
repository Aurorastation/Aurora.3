/obj/item/device/flashlight/survival
	name = "survival flashlight"
	desc = "A hand-held emergency light. This one has been modified with a larger bulb pointing inwards."
	icon_state = "survival_flashlight"
	item_state = "survival_flashlight"
	light_wedge = null

	uv_intensity = 255
	light_power = 2
	brightness_on = 2
	light_color = LIGHT_COLOR_GREEN

	var/obj/item/cell/cell
	var/last_drain = 0
	var/drain_per_second = 4 // should last about four minutes

/obj/item/device/flashlight/survival/Initialize()
	. = ..()
	cell = new /obj/item/cell/device(src)

/obj/item/device/flashlight/survival/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/device/flashlight/survival/examine(mob/user, distance)
	. = ..()
	to_chat(user, SPAN_NOTICE("\The [src]'s power cell is at [round(cell.percent())]%."))

/obj/item/device/flashlight/survival/attack_self(mob/user)
	if(!on && !cell.check_charge(1))
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any charge!"))
		return
	return ..()

/obj/item/device/flashlight/survival/toggle()
	if(!on && !cell.check_charge(1))
		return
	..()
	if(on)
		last_drain = world.time
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/survival/process()
	var/cell_drain = ((world.time - last_drain) / 10) * drain_per_second
	if(!cell.use(cell_drain) && on)
		toggle()
	last_drain = world.time

/obj/item/device/flashlight/survival/get_cell()
	return cell