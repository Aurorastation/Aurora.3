/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = 2.0
	brightness_on = 4 // Pretty bright.
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

/obj/item/device/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

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
		to_chat(user, "<span class='notice'>It's out of fuel.</span>")
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(
		"<span class='notice'>[user] activates the flare.</span>",
		"<span class='notice'>You pull the cord on the flare, activating it!</span>"
		)
		src.force = on_damage
		src.damtype = "fire"
		START_PROCESSING(SSprocessing, src)