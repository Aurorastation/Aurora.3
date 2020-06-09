/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEMSIZE_SMALL
	brightness_on = 3 // Pretty bright.
	light_power = 4
	light_color = LIGHT_COLOR_FLARE //"#E58775"
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	var/fuel = 0
	uv_intensity = 100
	var/on_damage = 7
	var/produce_heat = 1500
	light_wedge = LIGHT_OMNI
	activation_sound = 'sound/items/flare.ogg'
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

	var/overrides_activation_message = FALSE

/obj/item/device/flashlight/flare/Initialize()
	. = ..()
	fuel = rand(400, 600)

/obj/item/device/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	update_icon()

/obj/item/device/flashlight/flare/attack_self(mob/user)
	// Usual checks
	if(!fuel)
		to_chat(user, SPAN_WARNING("It's out of fuel."))
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		if(!overrides_activation_message)
			user.visible_message(SPAN_NOTICE("\The [user] activates the flare."), SPAN_NOTICE("You pull the cord on the flare, activating it!"))
		src.force = on_damage
		src.damtype = "fire"
		START_PROCESSING(SSprocessing, src)