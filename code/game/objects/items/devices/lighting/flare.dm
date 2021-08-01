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

/obj/item/device/flashlight/flare/torch
	name = "torch"
	desc = "A rustic source of light."
	w_class = ITEMSIZE_LARGE
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

/obj/item/device/flashlight/flare/torch/attackby(var/obj/item/W, mob/user)
	if(W.isFlameSource() && !on && fuel)
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
		turn_off()
		STOP_PROCESSING(SSprocessing, src)
		if(!fuel)
			var/obj/item/torch/T = new(pos)
			if(ismob(src.loc))
				var/mob/H = src.loc
				H.put_in_hands(T)
			qdel(src)

/obj/item/torch
	name = "torch handle"
	desc = "A torch handle without its head."
	w_class = ITEMSIZE_NORMAL
	icon_state = "torch-empty"
	item_state = "torch-empty"
	icon = 'icons/obj/lighting.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_lighting.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_lighting.dmi',
		)

	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'

/obj/item/torch/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/glass/rag))
		to_chat(user, SPAN_NOTICE("You add \the [I] to \the [src]."))
		var/obj/item/device/flashlight/flare/torch/T = new()
		qdel(I)
		user.put_in_hands(T)
		qdel(src)
