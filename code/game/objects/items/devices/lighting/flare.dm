/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'twist cap off, make light'."
	desc_info = "Use this item in your hand, to turn on the light."
	w_class = WEIGHT_CLASS_TINY
	brightness_on = 5 // Pretty bright.
	light_power = 6
	light_color = LIGHT_COLOR_FLARE //"#E58775"
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	var/fuel = 0
	uv_intensity = 100
	var/on_damage = 7
	var/produce_heat = 1500
	light_wedge = LIGHT_OMNI
	power_use = FALSE
	activation_sound = 'sound/items/flare.ogg'
	toggle_sound = null
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/device/flashlight/flare/Initialize()
	. = ..()
	fuel = rand(12 MINUTES, 15 MINUTES)

/obj/item/device/flashlight/flare/process()
	if(produce_heat)
		var/turf/pos = get_turf(src)
		if(pos)
			pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		STOP_PROCESSING(SSprocessing, src)
		turn_off()
		update_damage()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"

/obj/item/device/flashlight/flare/update_icon()
	..()
	item_state = icon_state
	if(ismob(src.loc))
		var/mob/H = src.loc
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/device/flashlight/flare/attack_self(mob/user)
	// Usual checks
	if(!fuel)
		to_chat(user, SPAN_WARNING("\The [src] is spent."))
		return
	if(on)
		return
	. = ..()
	// All good, turn it on.
	if(.)
		activate(user)
		update_damage()
		START_PROCESSING(SSprocessing, src)
		update_icon()

/obj/item/device/flashlight/flare/proc/activate(mob/user)
	if(istype(user))
		user.visible_message(
			SPAN_NOTICE("\The [user] activates the flare."),
			SPAN_NOTICE("You twist the cap off the flare, activating it!"),
			SPAN_NOTICE("You hear a flare sparking to life.")
		)

/obj/item/device/flashlight/flare/proc/turn_off()
	on = FALSE
	visible_message(
		SPAN_NOTICE("\The [src] sputters out.")
	)
	update_icon()

/obj/item/device/flashlight/flare/proc/update_damage()
	if(on)
		force = on_damage
		damtype = "fire"
	else
		force = initial(force)
		damtype = initial(damtype)

/obj/item/device/flashlight/flare/torch
	name = "torch"
	desc = "A rustic source of light."
	desc_info = "Click on a source of flame, to light the torch."
	w_class = WEIGHT_CLASS_BULKY
	brightness_on = 2
	light_power = 3
	light_color = LIGHT_COLOR_FIRE
	icon_state = "torch"
	item_state = "torch"
	uv_intensity = 40
	produce_heat = 1000
	on_damage = 10

	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'

/obj/item/device/flashlight/flare/torch/attack_self(mob/user)
	if (on)
		turn_off()
		update_damage()
		user.visible_message("<b>[user]</b> extinguishes \the [src].", SPAN_NOTICE("You extinguish \the [src]."))
	return

/obj/item/device/flashlight/flare/torch/update_icon()
	..()
	item_state = icon_state
	if(ismob(src.loc))
		var/mob/H = src.loc
		H.update_inv_l_hand()
		H.update_inv_r_hand()


/obj/item/device/flashlight/flare/torch/proc/light(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] lights \the [src]."),	SPAN_NOTICE("You light \the [src]."))
	force = on_damage
	damtype = "fire"
	on = TRUE
	START_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/device/flashlight/flare/torch/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isFlameSource() && !on && fuel)
		light(user)
	else
		..()

/obj/item/device/flashlight/flare/torch/isFlameSource()
	return on

/obj/item/device/flashlight/flare/torch/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		STOP_PROCESSING(SSprocessing, src)
		turn_off()
		update_damage()
		if(!fuel)
			var/obj/item/torch/T = new(pos)
			if(ismob(src.loc))
				var/mob/H = src.loc
				H.put_in_hands(T)
			qdel(src)

/obj/item/torch
	name = "torch handle"
	desc = "A torch handle without its head."
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "torch-empty"
	item_state = "torch-empty"
	icon = 'icons/obj/lighting.dmi'
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'

/obj/item/torch/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/glass/rag))
		to_chat(user, SPAN_NOTICE("You add \the [attacking_item] to \the [src]."))
		var/obj/item/device/flashlight/flare/torch/T = new()
		qdel(attacking_item)
		user.put_in_hands(T)
		qdel(src)

/obj/item/device/flashlight/flare/torch/stick
	name = "flaming stick"
	desc = "How exciting!"
	brightness_on = 1.5
	light_power = 1
	produce_heat = 400

/obj/item/device/flashlight/flare/torch/stick/Initialize()
	. = ..()
	fuel = rand(30, 45)
	on = TRUE
	START_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/device/flashlight/flare/torch/stick/turn_off()
	visible_message("\The [src] burns out.")
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)
